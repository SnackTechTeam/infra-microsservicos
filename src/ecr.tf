#criar um ecr para guardar as imagens da API
resource "aws_ecr_repository" "ecr_api_produtos" {
  name = "ecr-${var.projectName}-api-products"
}

resource "aws_ecr_repository" "ecr_api_pagamentos" {
  name = "ecr-${var.projectName}-api-payment"
}

resource "aws_ecr_repository" "ecr_api_pedidos" {
  name = "ecr-${var.projectName}-api-orders"
}

resource "aws_ecr_repository" "ecr_worker_pagamento" {
  name = "ecr-${var.projectName}-worker-pagamento"
}

output "ecr_api_produtos" {
  value = aws_ecr_repository.ecr_api_produtos.repository_url
}

output "ecr_api_pagamentos" {
  value = aws_ecr_repository.ecr_api_pagamentos.repository_url
}

output "ecr_api_pedidos" {
  value = aws_ecr_repository.ecr_api_pedidos.repository_url
}

output "ecr_worker_pagamento" {
  value = aws_ecr_repository.ecr_worker_pagamento.repository_url
}
