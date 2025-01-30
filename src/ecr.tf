#criar um ecr para guardar as imagens da API
resource "aws_ecr_repository" "api-produtos-ecr" {
  name = "ecr-${var.projectName}-api-produtos"
}

resource "aws_ecr_repository" "api-pagamentos-ecr" {
  name = "ecr-${var.projectName}-api-pagamentos"
}

resource "aws_ecr_repository" "api-pedidos-ecr" {
  name = "ecr-${var.projectName}-api-pedidos"
}

output "api-produtos-ecr" {
  value = aws_ecr_repository.api-produtos-ecr.repository_url
}

output "api-pagamentos-ecr" {
  value = aws_ecr_repository.api-pagamentos-ecr.repository_url
}

output "api-pedidos-ecr" {
  value = aws_ecr_repository.api-pedidos-ecr.repository_url
}


## Execução de scripts para limpar ECR antes do destroy
resource "null_resource" "clear_ecr_produtos" {
  depends_on = [aws_ecr_repository.api-produtos-ecr]

  provisioner "local-exec" {
    command = "./scripts/clear_ecr.sh ${aws_ecr_repository.api-produtos-ecr.name}"
  }

  triggers = {
    always_run = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "null_resource" "clear_ecr_pagamentos" {
  depends_on = [aws_ecr_repository.api-pagamentos-ecr]

  provisioner "local-exec" {
    command = "./scripts/clear_ecr.sh ${aws_ecr_repository.api-pagamentos-ecr.name}"
  }

  triggers = {
    always_run = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "null_resource" "clear_ecr_pedidos" {
  depends_on = [aws_ecr_repository.api-pedidos-ecr]

  provisioner "local-exec" {
    command = "./scripts/clear_ecr.sh ${aws_ecr_repository.api-pedidos-ecr.name}"
  }

  triggers = {
    always_run = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}