resource "aws_sqs_queue" "sqs_pagamentos" {
  name                    = var.sqsPagamentosQueueName
  delay_seconds           = 0
  visibility_timeout_seconds = 30
  message_retention_seconds = 345600 # 4 dias
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sqs_pagamentos_dlq.arn,
    maxReceiveCount     = 5,
  })

  tags = {
    Name        = var.sqsPagamentosQueueName
  }
}

resource "aws_sqs_queue" "sqs_pagamentos_dlq" {
  name                    = "${var.sqsPagamentosQueueName}-dlq"
  visibility_timeout_seconds = 30
  message_retention_seconds = 1209600 # 14 days
  tags = {
    Name        = "${var.sqsPagamentosQueueName}-dlq"
  }
}

output "sqs_pagamentos" {
  value = aws_sqs_queue.sqs_pagamentos.url
}

output "sqs_pagamentos_arn" {
  value = aws_sqs_queue.sqs_pagamentos.arn
}

output "sqs_pagamentos_dlq" {
  value = aws_sqs_queue.sqs_pagamentos_dlq.url
}

output "sqs_pagamentos_dlq_arn" {
  value = aws_sqs_queue.sqs_pagamentos_dlq.arn
}