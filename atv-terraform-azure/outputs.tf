# Valores exibidos no terminal depois do "terraform apply", úteis para confirmar o que foi criado ou para usar em outras etapas/automatizações.

# Nome do Resource Group criado.
output "resource_group_name" {
  description = "Nome do Resource Group provisionado"
  value       = azurerm_resource_group.rg.name
}

# ID do Resource Group, útil para referenciar o recurso em outros módulos.
output "resource_group_id" {
  description = "ID do Resource Group provisionado"
  value       = azurerm_resource_group.rg.id
}

# Nome da Storage Account criada.
output "storage_account_name" {
  description = "Nome da Storage Account provisionada"
  value       = azurerm_storage_account.storage.name
}

# Endpoint público de acesso aos blobs da Storage Account (mesmo sendo
# container privado, o endpoint em si é informativo).
output "storage_account_primary_blob_endpoint" {
  description = "Endpoint primário de blob da Storage Account"
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}

# ID da assinatura Azure usada, obtido via data source (data.tf).
output "subscription_id" {
  description = "ID da assinatura Azure em uso, obtido via data source"
  value       = data.azurerm_client_config.current.subscription_id
}
