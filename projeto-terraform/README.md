# Projeto Terraform - Infraestrutura Simulada

Projeto individual desenvolvido em sala, no curso de DevOps, usando Terraform com o provider local. Como não há conta AWS disponível, os recursos de nuvem (servidores, banco de dados e load balancer) são simulados através de arquivos locais, permitindo demonstrar na prática os principais conceitos do Terraform sem custo ou necessidade de conta em nuvem.

## O que o projeto cria

- 3 servidores web (web-01, web-02, web-03), cada um com tipo de instância e porta configuráveis
- 1 banco de dados, com nome, engine e porta configuráveis
- 1 load balancer, que lista os servidores conectados a ele (demonstra dependência entre recursos com depends_on)

## Arquivos do projeto

- main.tf - provider e recursos (local_file)
- variables.tf - variáveis de entrada (ambiente, servidores, banco de dados)
- terraform.tfvars - valores usados nas variáveis
- outputs.tf - saídas exibidas após o apply
- .gitignore - evita subir estado do Terraform e a pasta gerada

## Sobre a conexão com a Cloud (AWS)

Este projeto usa o provider local por não haver conta AWS disponível no momento. Para conectar um projeto Terraform à AWS, o processo seria:

1. Criar uma conta AWS e um usuário IAM com permissões programáticas, gerando uma Access Key ID e uma Secret Access Key.
2. Configurar as credenciais na máquina local, via AWS CLI (comando "aws configure") ou variáveis de ambiente (AWS_ACCESS_KEY_ID e AWS_SECRET_ACCESS_KEY).
3. Trocar o bloco provider de "local" para "aws", informando a região desejada.
4. Trocar os recursos "local_file" por recursos reais da AWS (ex: aws_instance para servidores, aws_db_instance para banco de dados, aws_lb para load balancer).
5. Rodar terraform init, terraform plan e terraform apply normalmente — o Terraform usa as credenciais configuradas para se conectar e criar os recursos na AWS.

## Anotações / o que foi aprendido em aula

- O Terraform trabalha com o conceito de Infraestrutura como Código: a infraestrutura é descrita em arquivos de texto (.tf), versionáveis e reutilizáveis.
- O bloco provider define com qual serviço/cloud o Terraform vai se comunicar.
- O bloco resource define o que será criado.
- Variáveis (variable) tornam o código reutilizável, evitando valores fixos ("hardcoded") no meio do código.
- Outputs (output) mostram informações relevantes sobre o que foi criado, sem precisar abrir o console da nuvem.
- O arquivo .tfstate guarda o "retrato" do que já foi criado — por isso é sensível e não deve ir para o repositório.
- for_each permite criar múltiplos recursos parecidos a partir de um mapa, evitando repetir código.
- depends_on garante que um recurso só seja criado depois de outro, quando a dependência não é automática.
- Os comandos seguem sempre a mesma ordem: init (prepara o projeto) → plan (mostra o que vai mudar) → apply (executa) → destroy (remove tudo, se necessário).