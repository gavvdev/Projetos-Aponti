terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

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