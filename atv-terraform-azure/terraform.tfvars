# Valores reais atribuídos às variáveis declaradas em variables.tf.

resource_group_name  = "rg-atv-terraform"
location              = "Brazil South"

# IMPORTANTE: storage_account_name precisa ser único em toda a Azure.
storage_account_name = "gabi123456789"

container_name        = "atividadecontainer"

tags = {
  projeto    = "atv-terraform"
  ambiente   = "estudo"
  criado_por = "gabriela"
}
