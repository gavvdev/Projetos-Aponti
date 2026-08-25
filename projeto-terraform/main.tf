terraform {
    required_version = ">= 1.5.0"

    required_providers {
      local = {
        source = "hashicorp/local"
        version = "~> 2.5"
      }
    }
}

resource "local_file" "servidor_web" {
    for_earch = var.servidores_web

    filename = "${path.module}/
infraestrutura/servidores/$
{earch.key}.txt"

}