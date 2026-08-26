
ambiente = "dev"

servidores_web = {
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

banco_dados = {
  nome   = "db-atv-terraform"
  engine = "postgres"
  porta  = 5432
}