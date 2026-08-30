# Declaração das variáveis usadas pelo projeto. Os valores reais ficam no terraform.tfvars, mantendo o código reutilizável e sem dados fixos.

# Nome do Resource Group que agrupará todos os recursos do projeto na Azure.
variable "resource_group_name" {
  description = "Nome do Resource Group na Azure"
  type        = string
  default     = "rg-atv-terraform"
}

# Região da Azure onde os recursos serão provisionados.
variable "location" {
  description = "Região da Azure onde os recursos serão criados"
  type        = string
  default     = "Brazil South"
}

# Nome da Storage Account. 
variable "storage_account_name" {
  description = "Nome da Storage Account"
  type        = string
}

# Nome do container dentro da Storage Account.
variable "container_name" {
  description = "Nome do container de armazenamento dentro da Storage Account"
  type        = string
  default     = "atividadecontainer"
}

# Tags aplicadas aos recursos, úteis para organização, custos e identificação
# de quem/qual projeto criou o recurso.
variable "tags" {
  description = "Tags padrão aplicadas aos recursos criados"
  type        = map(string)
  default = {
    projeto    = "atv-terraform"
    ambiente   = "estudo"
    criado_por = "terraform"
  }
}
