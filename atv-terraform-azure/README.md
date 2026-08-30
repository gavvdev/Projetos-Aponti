# Atividade Individual — Terraform + Microsoft Azure

Projeto individual desenvolvido para o curso de DevOps, com o objetivo de
provisionar recursos de infraestrutura na **Microsoft Azure** usando
**Terraform**, com base na documentação oficial do provider `azurerm`.

> A conexão real com a Azure não era obrigatória para esta entrega, o foco
> foi escrever o código de forma correta, comentada e seguindo a
> documentação oficial (registry.terraform.io/providers/hashicorp/azurerm).

## O que este projeto provisiona

- **Resource Group** (`azurerm_resource_group`) - agrupador lógico de todos
  os recursos do projeto na assinatura Azure.
- **Storage Account** (`azurerm_storage_account`) - conta de armazenamento
  na nuvem, equivalente a um bucket S3 da AWS.
- **Storage Container** (`azurerm_storage_container`) - "pasta" dentro da
  Storage Account onde os arquivos (blobs) seriam armazenados.

## Estrutura do projeto

```
atv-terraform-azure/
├── main.tf              # Provider Azure e definição dos recursos
├── data.tf               # Data sources (consulta de dados já                                       existentes na Azure)
├── variables.tf           # Declaração das variáveis do projeto
├── outputs.tf             # Saídas exibidas após o terraform apply
├── terraform.tfvars        # Valores atribuídos às variáveis
├── .gitignore              # Arquivos/pastas que não devem ir para o Git
└── README.md               # Este arquivo
```

## Processo de conexão com a Azure

Para rodar este projeto de verdade contra uma conta Azure real, o processo
seria:

1. **Instalar o Azure CLI** e autenticar com:
   ```
   az login
   ```
   Isso cria uma sessão local que o provider `azurerm` usa automaticamente
   para autenticação, sem precisar colocar credenciais no código.

2. **Alternativa via Service Principal** (mais indicada para pipelines
   CI/CD, como Jenkins): criar um Service Principal no Azure AD e exportar
   as credenciais como variáveis de ambiente:
   ```
   export ARM_CLIENT_ID="..."
   export ARM_CLIENT_SECRET="..."
   export ARM_TENANT_ID="..."
   export ARM_SUBSCRIPTION_ID="..."
   ```

3. **Inicializar o Terraform** (baixa o provider `azurerm`):
   ```
   terraform init
   ```

4. **Validar a sintaxe**:
   ```
   terraform validate
   ```

5. **Visualizar o plano de execução** (o que será criado, sem aplicar
   ainda):
   ```
   terraform plan
   ```

6. **Aplicar de fato** (cria os recursos na Azure):
   ```
   terraform apply
   ```

7. **Destruir os recursos** ao final, para não gerar custos:
   ```
   terraform destroy
   ```

## Anotações do que foi aprendido

- Assim como a AWS exige um par de chaves (access key / secret key), a
  Azure tem seu próprio fluxo de autenticação, sendo o `az login` o mais
  simples para uso local, e o Service Principal o indicado para automações.
- Praticamente **todo recurso na Azure precisa estar dentro de um Resource
  Group**, diferente da AWS, onde os recursos não têm essa obrigatoriedade
  de agrupamento lógico.
- O nome da `Storage Account` precisa ser **globalmente único em toda a
  Azure** (não só dentro da minha assinatura), além de aceitar só letras
  minúsculas e números - isso é bem mais restritivo que o nome de um bucket
  S3.
- Os **data sources** (`data.tf`) servem para consultar informações que já
  existem na nuvem (como a subscription atual) sem precisar criar nada,
  o que é útil para reaproveitar dados em outros recursos.
- Separar o projeto em `main.tf`, `variables.tf`, `outputs.tf`, `data.tf` e
  `terraform.tfvars` deixa o código mais organizado e reutilizável, dá
  pra trocar valores (região, nomes) só editando o `.tfvars`, sem tocar na
  lógica principal.
- O `.gitignore` é essencial em projetos Terraform porque o arquivo de
  state (`.tfstate`) pode conter dados sensíveis do ambiente provisionado,
  e nunca deve ir para um repositório público.
