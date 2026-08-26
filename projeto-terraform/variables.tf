# Define o ambiente em que a infraestrutura está sendo provisionada
variable "ambiente" {
  description = "Nome do ambiente da infraestrutura (dev, homologacao, producao)"
  type        = string
  default     = "dev"
}

# Define o conjunto de servidores web, cada um com seu tipo de instancia e porta
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

# Define as configuracoes do banco de dados: nome, engine e porta
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