resource "aws_sqs_queue" "sqs_pagamentos" {
  name                    = "${var.projectName}-sqs-pagamentos" # Give your queue a descriptive name
  delay_seconds           = 0 # How long (in seconds) messages are delayed before becoming available
  visibility_timeout_seconds = 30 # How long (in seconds) a message is hidden from other consumers after being received

  tags = {
    Name        = "${var.projectName}-sqs-pagamentos" 
  }
}

resource "aws_sqs_queue" "sqs_pagamentos_dlq" {
  name                    = "${var.projectName}-sqs-pagamentos-dlq"
  fifo_queue              = false
  visibility_timeout_seconds = 30

  tags = {
    Name        = "${var.projectName}-sqs-pagamentos-dlq"
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