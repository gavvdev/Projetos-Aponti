# Atividade Prática — Hardening de Containers

## Objetivo

Nesta atividade, você deverá analisar e aplicar medidas de segurança em uma aplicação executada em containers Docker.

O projeto fornecido possui uma aplicação funcional, porém sua configuração inicial não foi preparada considerando boas práticas de segurança.

O desafio consiste em identificar os pontos que podem representar riscos e realizar o **hardening do ambiente**, mantendo a aplicação funcionando normalmente.

Durante a atividade, também será necessário aplicar uma estratégia básica de gerenciamento de informações sensíveis para o ambiente local, utilizando **variáveis de ambiente por meio de um arquivo `.env`**.

A atividade deverá ser realizada considerando os conceitos apresentados na aula de **Segurança de Containers**.

---

# Cenário

Uma equipe de desenvolvimento criou uma aplicação web utilizando Docker.

A aplicação funciona corretamente em ambiente de desenvolvimento, porém, antes de ser disponibilizada em um ambiente de produção, a equipe de segurança solicitou uma revisão da configuração dos containers.

Durante a análise, foram levantadas preocupações relacionadas a:

* imagem utilizada na aplicação;
* privilégios de execução;
* exposição de informações sensíveis;
* exposição desnecessária de serviços;
* utilização de recursos do host;
* configuração dos containers;
* comunicação entre serviços;
* segurança durante o processo de build.

Você faz parte da equipe responsável por corrigir essas configurações.

Seu objetivo é reduzir a superfície de ataque e aplicar o princípio do menor privilégio, sem comprometer o funcionamento da aplicação.

Além disso, informações sensíveis utilizadas pela aplicação não deverão permanecer diretamente escritas no código ou nas configurações versionadas do projeto.

---

# Estrutura inicial

O projeto possui a seguinte estrutura:

```text
projeto/

├── app/
├── docs/
├── Dockerfile
└── docker-compose.yml
```

Antes de realizar qualquer alteração, execute a aplicação e confirme que ela está funcionando.

É importante conhecer o comportamento inicial do projeto para que seja possível comparar o ambiente antes e depois do hardening.

---

# Etapa 1 — Análise inicial

Antes de modificar os arquivos, faça uma análise da configuração atual.

Observe principalmente:

* qual imagem está sendo utilizada como base;
* se a imagem possui uma versão definida;
* quais pacotes são instalados;
* qual usuário executa a aplicação;
* quais portas estão expostas;
* quais informações são configuradas como variáveis de ambiente;
* se existem informações sensíveis diretamente nos arquivos;
* quais serviços estão acessíveis externamente;
* como os serviços se comunicam;
* se existem limites de utilização de CPU e memória;
* quais recursos do host podem ser acessados pelos containers.

Registre os problemas encontrados e explique por que cada configuração pode representar um risco de segurança.

---

# Etapa 2 — Hardening da imagem

Analise o `Dockerfile` e procure reduzir a superfície de ataque da imagem.

Considere os seguintes princípios:

* utilizar uma imagem base adequada à aplicação;
* evitar imagens desnecessariamente grandes;
* evitar versões genéricas quando uma versão específica puder ser utilizada;
* instalar somente os pacotes necessários;
* evitar arquivos e dependências desnecessárias;
* evitar armazenar informações sensíveis nas camadas da imagem.

A imagem final deve conter somente o necessário para executar a aplicação.

### Pergunta

Por que uma imagem menor e com menos componentes pode reduzir a superfície de ataque?

---

# Etapa 3 — Princípio do menor privilégio

Analise com qual usuário a aplicação está sendo executada.

O container não deve executar a aplicação com privilégios administrativos sem necessidade.

Configure o ambiente para que a aplicação seja executada utilizando um usuário com os privilégios mínimos necessários para seu funcionamento.

Depois da alteração, valide qual usuário está sendo utilizado dentro do container.

### Pergunta

Qual seria o impacto de um atacante obter controle de uma aplicação que está sendo executada com privilégios administrativos dentro do container?

---

# Etapa 4 — Gerenciamento de informações sensíveis

Verifique se existem senhas, tokens, chaves ou outras informações sensíveis armazenadas diretamente no `Dockerfile`, `docker-compose.yml`, código da aplicação ou outros arquivos do projeto.

Essas informações não devem fazer parte da imagem construída nem permanecer diretamente escritas em arquivos que serão versionados.

Para o ambiente local, utilize um arquivo `.env` para armazenar os valores sensíveis necessários para a execução da aplicação.

Por exemplo:

```text
.env
```

As informações sensíveis devem ser referenciadas por meio de variáveis de ambiente, e não escritas diretamente nas configurações do projeto.

O `docker-compose.yml` deverá utilizar essas variáveis durante a inicialização dos serviços.

### Proteção do arquivo `.env`

O arquivo `.env` contém informações sensíveis e **não deve ser enviado para o repositório Git**.

Configure o `.gitignore` para impedir que esse arquivo seja versionado.

O projeto também deverá possuir um arquivo:

```text
.env.example
```

Esse arquivo deverá apresentar apenas os nomes das variáveis necessárias, sem armazenar seus valores reais.

Exemplo:

```env
DB_USER=
DB_PASSWORD=
DB_NAME=
```

O `.env.example` pode ser versionado porque não contém os valores reais dos secrets.

### Atenção

O objetivo não é simplesmente mover a senha para outro arquivo.

Você deverá garantir que:

* a senha não esteja diretamente no `Dockerfile`;
* a senha não esteja diretamente no `docker-compose.yml`;
* a senha não esteja no código da aplicação;
* o `.env` não seja enviado para o Git;
* o `.env.example` não contenha valores reais;
* a aplicação continue recebendo as informações necessárias por meio de variáveis de ambiente.

### Perguntas

1. Por que armazenar uma senha diretamente no `Dockerfile` representa um risco mesmo que a aplicação esteja funcionando corretamente?

2. Por que o arquivo `.env` não deve ser enviado para o repositório?

3. Qual é a finalidade do arquivo `.env.example`?

4. Qual é a diferença entre armazenar uma senha diretamente no `docker-compose.yml` e utilizar uma variável de ambiente fornecida pelo `.env`?

---

# Etapa 5 — Segurança de rede

Analise o `docker-compose.yml` e identifique quais serviços precisam realmente ser acessíveis externamente.

Nem todo serviço precisa ter sua porta publicada para o host.

Avalie a arquitetura da aplicação e determine:

* qual serviço precisa receber requisições externas;
* quais serviços precisam apenas se comunicar internamente;
* quais portas podem deixar de ser publicadas;
* quais comunicações são realmente necessárias.

O objetivo é reduzir a exposição dos serviços sem impedir o funcionamento da aplicação.

Considere o seguinte princípio:

```text
Expor somente o que é necessário.
```

### Pergunta

Se um banco de dados é utilizado apenas pela aplicação, existe necessidade de disponibilizar sua porta diretamente para toda a máquina hospedeira?

Justifique.

---

# Etapa 6 — Controle de recursos

Analise o consumo de recursos dos containers.

Um container comprometido ou mal configurado pode consumir uma quantidade excessiva de CPU ou memória e afetar outros serviços executados no mesmo host.

Configure limites apropriados para os recursos utilizados pelos containers.

Considere principalmente:

* CPU;
* memória.

Depois, observe como os limites definidos protegem o ambiente contra consumo excessivo de recursos.

### Pergunta

O que pode acontecer com outros serviços de um host caso um único container consiga consumir continuamente toda a CPU ou memória disponível?

---

# Etapa 7 — Isolamento e exposição

Analise a configuração geral do ambiente procurando recursos que possam aumentar desnecessariamente o nível de acesso de um container.

Verifique se existem configurações que:

* concedem privilégios desnecessários;
* permitem acesso excessivo ao host;
* expõem serviços sem necessidade;
* aumentam o impacto de um possível comprometimento.

O objetivo é garantir que cada container possua somente os acessos necessários para realizar sua função.

---

# Etapa 8 — Documentação

Crie um arquivo:

```text
HARDENING.md
```

Esse arquivo deverá documentar o trabalho realizado.

## 1. Problemas encontrados

Liste as configurações inseguras identificadas antes do hardening.

Para cada problema, explique:

* o que estava errado;
* qual era o risco;
* onde o problema foi encontrado.

## 2. Medidas aplicadas

Descreva as alterações realizadas.

Para cada alteração, explique:

* o que foi modificado;
* qual objetivo de segurança foi alcançado;
* qual risco foi reduzido.

## 3. Análise final

Responda:

1. Qual era o principal risco encontrado no projeto?

2. Qual alteração de hardening foi mais importante? Por quê?

3. O que poderia acontecer caso o container da aplicação fosse comprometido?

4. Como o princípio do menor privilégio foi aplicado?

5. Por que o `.env` não deve ser enviado para o repositório?

6. Qual é a função do `.env.example`?

7. Como o projeto poderia receber novas verificações de segurança automaticamente em uma pipeline CI/CD?

8. Quais medidas adicionais poderiam ser aplicadas caso essa aplicação fosse executada em Kubernetes?

---

# Entrega

A entrega deverá conter:

```text
projeto/

├── app/
├── docs/
├── Dockerfile
├── docker-compose.yml
├── .env.example
├── .gitignore
└── HARDENING.md
```

O arquivo `.env` deverá existir no ambiente local para permitir a execução da aplicação, porém **não deverá ser enviado para o repositório**.

O `.env.example` deverá ser enviado para o repositório e conter somente a estrutura das variáveis necessárias, sem seus valores reais.

O projeto deverá estar funcional após as alterações.

O `HARDENING.md` deverá apresentar o diagnóstico, as medidas aplicadas e as evidências da validação.