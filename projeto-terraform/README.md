# atv-terraform

Projeto individual criado para atividade em sala do curso de DevOps, utilizando **Terraform** com o provider `local` (não requer conta em nuvem, todos os recursos são arquivos criados na própria máquina).

## O que o projeto faz

- Cria um arquivo `info.txt` com informações do projeto.
- Cria múltiplos arquivos de exemplo (`arquivo-1.txt`, `arquivo-2.txt`, ...), em uma quantidade definida por variável.
- Expõe outputs com os caminhos dos arquivos criados.

## Estrutura dos arquivos

| Arquivo | Função |
|---|---|
| `main.tf` | Define o provider e os recursos (`local_file`) que serão criados |
| `variables.tf` | Define as variáveis de entrada (diretório de saída, quantidade de arquivos, nome do projeto) |
| `outputs.tf` | Define as saídas exibidas após o `apply` |
| `.gitignore` | Evita subir arquivos de estado, cache do provider e a pasta de saída |

## Pré-requisitos

- Terraform instalado ([instruções oficiais](https://developer.hashicorp.com/terraform/install))
- Verificar instalação: `terraform version`

## Comandos utilizados (passo a passo)

1. **Inicializar o projeto** (baixa o provider `local` e prepara o diretório):
   ```bash
   terraform init
   ```

2. **Validar a sintaxe dos arquivos**:
   ```bash
   terraform validate
   ```

3. **Formatar os arquivos** (padroniza identação/estilo):
   ```bash
   terraform fmt
   ```

4. **Ver o plano de execução** (o que será criado, sem aplicar ainda):
   ```bash
   terraform plan
   ```

5. **Aplicar e criar os recursos**:
   ```bash
   terraform apply
   ```
   Digite `yes` quando solicitado para confirmar.

6. **Conferir os outputs**:
   ```bash
   terraform output
   ```

7. **Destruir os recursos** (limpar tudo o que foi criado):
   ```bash
   terraform destroy
   ```

## Personalizando a execução

É possível alterar as variáveis sem editar o código, direto na linha de comando:
```bash
terraform apply -var="quantidade_arquivos=5" -var="nome_projeto=meu-projeto"
```

## Resultado esperado

Após o `apply`, uma pasta `saida/` é criada localmente contendo os arquivos `.txt` gerados pelo Terraform, e o terminal exibe os outputs definidos em `outputs.tf`.