# =============================================================================
# data.tf
# Data sources: usados para CONSULTAR informações que já existem na Azure
# (e não são criadas por este projeto), permitindo reutilizá-las no código.
# =============================================================================

# Consulta os dados da conta/sessão autenticada no momento (subscription_id,
# tenant_id, object_id do usuário/service principal logado). Muito útil para
# usar esses IDs em outros recursos (ex.: políticas de acesso) sem precisar
# digitá-los manualmente.
data "azurerm_client_config" "current" {}

# Consulta a lista de localizações (regiões) disponíveis para a assinatura
# atual da Azure. Serve para validar ou documentar em quais regiões o
# provisionamento pode acontecer.
data "azurerm_subscription" "current" {}
