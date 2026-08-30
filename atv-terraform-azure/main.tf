# Arquivo principal do projeto: define o provider da Azure e os recursos que serão provisionados na Cloud.

# Bloco terraform: define a versão mínima do Terraform e o provider necessário
# fixando uma faixa de versão para evitar quebras por updates automáticos do provider.
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Provider "azurerm": conecta o Terraform à conta Azure.
# A autenticação pode ser feita via Azure CLI (az login), Service Principal
# "features {}" é obrigatório mesmo vazio, é a forma do provider habilitar comportamentos padrão de cada tipo de recurso.
provider "azurerm" {
  features {}
}

# Resource Group: "pasta" lógica que agrupa todos os recursos do projeto
# dentro da assinatura Azure. Praticamente todo recurso Azure precisa pertencer a um Resource Group.
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Storage Account: conta de armazenamento na Azure (equivalente ao bucket S3 da AWS).
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard" # Standard (HDD) ou Premium (SSD)
  account_replication_type = "LRS"      # LRS = redundância local (mais barata)

  tags = var.tags
}

# Storage Container: "pasta" dentro da Storage Account onde os blobs (arquivos) são efetivamente armazenados, parecido a um bucket dentro de
# outro serviço de storage.
resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}
