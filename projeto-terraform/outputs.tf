# Lista os nomes de todos os servidores web criados
output "servidores_criados" {
  description = "Nomes de todos os servidores web provisionados"
  value       = keys(var.servidores_web)
}

# Mostra quantos servidores foram criados no total
output "total_servidores" {
  description = "Quantidade total de servidores web"
  value       = length(var.servidores_web)
}

# Mostra o nome e o engine do banco de dados criado
output "banco_de_dados" {
  description = "Nome e engine do banco de dados provisionado"
  value       = "${var.banco_dados.nome} (${var.banco_dados.engine})"
}

# Mostra em qual ambiente a infraestrutura foi provisionada
output "ambiente_atual" {
  description = "Ambiente em que a infraestrutura foi provisionada"
  value       = var.ambiente
}

# Mostra o caminho do arquivo que representa o load balancer
output "caminho_load_balancer" {
  description = "Caminho do arquivo que representa o load balancer"
  value       = local_file.load_balancer.filename
}