# Bloco de configuração do Terraform, define a versão e qual provider vai ser usado para provisionar os recursos
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

# Recurso que simula os servidores web, criando um arquivo para cada servidor definido na variável servidores_web
resource "local_file" "servidor_web" {
  for_each = var.servidores_web

  filename = "${path.module}/infraestrutura/servidores/${each.key}.txt"

  content = <<-EOT
    ==========================================
    SERVIDOR WEB: ${each.key}
    ==========================================
    Ambiente:          ${var.ambiente}
    Tipo de instancia: ${each.value.tipo_instancia}
    Porta:             ${each.value.porta}
    Status:            provisionado
  EOT
}

# Recurso que simula o banco de dados, criando um arquivo comas informações configuradas
resource "local_file" "banco_dados" {
  filename = "${path.module}/infraestrutura/banco-dados/${var.banco_dados.nome}.txt"

  content = <<-EOT
    ==========================================
    BANCO DE DADOS: ${var.banco_dados.nome}
    ==========================================
    Ambiente: ${var.ambiente}
    Engine:   ${var.banco_dados.engine}
    Porta:    ${var.banco_dados.porta}
    Status:   provisionado
  EOT
}

# Recurso que simula o load balancer, listando todos os servidores conectados a ele, depends_on garante que ele só é criado depois dos servidores 
# e do banco de dados
resource "local_file" "load_balancer" {
  filename = "${path.module}/infraestrutura/load-balancer/lb.txt"

  content = <<-EOT
    ==========================================
    LOAD BALANCER
    ==========================================
    Ambiente: ${var.ambiente}
    Servidores conectados:
    %{for nome, srv in var.servidores_web~}
    - ${nome} (porta ${srv.porta})
    %{endfor~}
    Banco de dados vinculado: ${var.banco_dados.nome}
    Status: ativo
  EOT

  depends_on = [
    local_file.servidor_web,
    local_file.banco_dados
  ]
}