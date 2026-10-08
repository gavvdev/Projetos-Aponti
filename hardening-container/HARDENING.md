# HARDENING.md

## 1. Problemas encontrados

| # | Problema | Risco | Onde |
|---|----------|-------|------|
| 1 | Imagem `ubuntu:latest` | Imagem grande, com muitos pacotes e sem versão fixa; build não reproduzível e mais vulnerabilidades possíveis | Dockerfile |
| 2 | `apt-get install nodejs npm` sem versão e sem limpeza de cache | Pacotes extras e versões imprevisíveis; ferramentas de build ficam na imagem final | Dockerfile |
| 3 | `COPY . .` | Copia `.git`, `.env`, docs e qualquer arquivo para as camadas da imagem | Dockerfile |
| 4 | Execução como `root` (sem `USER`) | Comprometer a aplicação dá privilégios administrativos no container | Dockerfile |
| 5 | `ENV DB_PASSWORD=123456` | Senha fraca, versionada e gravada nas camadas da imagem (visível com `docker history`/`inspect`) | Dockerfile |
| 6 | `MYSQL_ROOT_PASSWORD: root` | Senha trivial e hardcoded no repositório; app e banco usando o root | docker-compose.yml |
| 7 | `mysql:latest` | Versão não controlada; upgrade inesperado pode quebrar ou introduzir falhas | docker-compose.yml |
| 8 | Porta `3306` publicada no host | Banco acessível por toda a máquina/rede sem necessidade | docker-compose.yml |
| 9 | Porta `3000` publicada em `0.0.0.0` | App exposta a todas as interfaces do host | docker-compose.yml |
| 10 | Sem limites de CPU, memória e processos | Um container comprometido ou com falha pode derrubar o host e os outros serviços (DoS) | docker-compose.yml |
| 11 | Rede padrão única, sem segmentação | Banco alcançável por qualquer container na mesma rede e com saída para a internet | docker-compose.yml |
| 12 | Capabilities padrão, sem `no-new-privileges`, filesystem gravável | Maior impacto em caso de comprometimento e possibilidade de escalar privilégios ou persistir arquivos | docker-compose.yml |
| 13 | Banco sem volume nomeado | Dados perdidos ao recriar o container | docker-compose.yml |

## 2. Medidas aplicadas

| Medida | Objetivo de segurança | Risco reduzido |
|--------|----------------------|----------------|
| Imagem `node:20-alpine3.21` (versão fixa) com multi-stage build | Imagem mínima, reproduzível, só com o necessário para rodar | Superfície de ataque e CVEs de pacotes desnecessários |
| `npm install --omit=dev --ignore-scripts` e `npm cache clean` | Sem dependências de desenvolvimento nem scripts de terceiros no build | Supply chain e arquivos desnecessários |
| `.dockerignore` (exclui `.git`, `.env`, docs) | `COPY` leva só o que é necessário | Vazamento de segredos nas camadas |
| `COPY --chown=node:node` + `USER node` | Menor privilégio: app roda sem root | Impacto de uma invasão da aplicação |
| Remoção de `ENV DB_PASSWORD` do Dockerfile | Nenhum segredo na imagem | Vazamento via camadas/histórico |
| Variáveis em `.env` referenciadas no compose (`${DB_*}`) | Segredos fora de arquivos versionados | Senha exposta no Git |
| `.gitignore` com `.env` e `.env.example` versionado só com nomes | `.env` nunca vai ao repositório | Vazamento de credenciais |
| Usuário dedicado do banco (`MYSQL_USER`/`MYSQL_PASSWORD`) usado pela app; root separado | Menor privilégio no banco | Uso do root pela aplicação |
| `mysql:8.4.3` | Versão controlada | Mudanças inesperadas |
| Porta 3306 removida | Banco só acessível internamente | Acesso externo ao banco |
| App publicada em `127.0.0.1:3000` | Exposição só local (em produção, usar proxy reverso) | Acesso indevido pela rede |
| Redes `frontend` e `backend` (`internal: true`) | Banco isolado, sem acesso externo e sem saída para a internet | Movimentação lateral e exfiltração |
| `cpus`, `mem_limit`, `pids_limit` | Limites de recursos | DoS por consumo excessivo, fork bomb |
| `cap_drop: ALL` (banco com apenas as capabilities necessárias ao entrypoint) | Menos privilégios do kernel | Escalada de privilégios |
| `no-new-privileges`, `read_only` + `tmpfs /tmp` na app | Impede ganho de privilégio e escrita no filesystem | Persistência de malware e escalada |
| Volume nomeado `dados_banco` | Persistência sem expor diretórios do host | Perda de dados |
| Nenhum `privileged`, `docker.sock` ou bind mount do host | Sem acesso excessivo ao host | Fuga do container |

## 3. Análise final

1. **Principal risco:** senhas hardcoded (`123456` e `root`) combinadas com o banco publicado na porta 3306 e processos rodando como root.
2. **Alteração mais importante:** retirar os segredos dos arquivos versionados e da imagem (`.env`), pois credenciais vazadas dão acesso direto aos dados, independentemente das outras proteções. O isolamento do banco vem logo em seguida.
3. **App comprometida:** um atacante rodando como root poderia alterar o filesystem do container, instalar ferramentas, ler variáveis de ambiente, acessar o banco e tentar escapar para o host (com capabilities, mounts ou recursos excessivos).
4. **Menor privilégio:** usuário `node` não-root, `cap_drop: ALL`, `no-new-privileges`, filesystem somente leitura, usuário de banco sem uso do root, banco em rede interna e sem mounts do host.
5. **`.env` fora do Git:** contém valores reais dos segredos; o histórico do Git é permanente e público para quem tem acesso ao repositório.
6. **`.env.example`:** documenta quais variáveis são necessárias, sem valores, para que outra pessoa crie seu próprio `.env`.
7. **Pipeline CI/CD:** adicionar lint de Dockerfile (Hadolint), scan de imagem (Trivy/Grype), scan de segredos (Gitleaks), SAST (Semgrep), DAST (OWASP ZAP), SBOM e falha do pipeline em vulnerabilidades críticas.
8. **Kubernetes:** `securityContext` (`runAsNonRoot`, `readOnlyRootFilesystem`, `allowPrivilegeEscalation: false`, drop de capabilities), Secrets (ou secret manager externo), NetworkPolicies, `resources.requests/limits`, ResourceQuota/LimitRange, Pod Security Standards, RBAC mínimo, imagens por digest e admission controllers (Kyverno/OPA).

## Validação

Execute e cole a saída real em cada item:

```bash
cp .env.example .env   # preencher os valores
docker compose up -d --build
docker compose exec app whoami          # esperado: node
docker compose exec app id              # esperado: uid=1000(node)
docker compose ps                       # 3306 não deve aparecer publicada
docker inspect --format '{{.HostConfig.Memory}} {{.HostConfig.NanoCpus}}' $(docker compose ps -q app)
docker history $(docker compose images -q app) | grep -i password   # esperado: vazio
git check-ignore .env                   # esperado: .env
```
