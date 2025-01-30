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
