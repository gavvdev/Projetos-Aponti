variable "ambiente" {
  description = "Nome do ambiente da infraestrutura (dev, homologacao, producao)"
  type        = string
  default     = "dev"
}

variable "servidores_web" {
  description = "Mapa de servidores web a serem provisionados"
  type = map(object({
    tipo_instancia = string
    porta          = number
  }))
  default = {
    "web-01" = {
      tipo_instancia = "t2.micro"
      porta          = 80
    }
    "web-02" = {
      tipo_instancia = "t2.micro"
      porta          = 80
    }
    "web-03" = {
      tipo_instancia = "t2.small"
      porta          = 8080
    }
  }
}

variable "banco_dados" {
  description = "Configuração do banco de dados"
  type = object({
    nome   = string
    engine = string
    porta  = number
  })
  default = {
    nome   = "db-atv-terraform"
    engine = "postgres"
    porta  = 5432
  }
}