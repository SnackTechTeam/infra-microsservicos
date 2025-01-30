#criar um ecr para guardar as imagens da API
resource "aws_ecr_repository" "api-ecr" {
  name = "ecr-${var.projectName}"
}

resource "aws_ecr_repository" "lambda-ecr" {
  name = "ecr-${var.projectName}-authorizer"
}

output "ecr_repository" {
  value = aws_ecr_repository.api-ecr.repository_url
}

output "ecr_repository_authorizer" {
  value = aws_ecr_repository.lambda-ecr.repository_url
}
