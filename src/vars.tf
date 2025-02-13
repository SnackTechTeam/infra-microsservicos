variable "regionDefault" {
  default = "us-east-1"
}

variable "projectName" {
  default = "snacktech"
}

variable "vpcCidr" {
  default = "172.31.0.0/16"
}

variable "instanceType" {
  default = "t3.micro"
}

variable "accountIdVoclabs" {
  default = "NNNNNNNNNN"
}

variable "policyArn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

variable "accessConfig" {
  default = "API_AND_CONFIG_MAP"
}

variable "dbUserPedidos" {
  default = "sa"
}

variable "dbPasswordPedidos" {
  default = "Senha12345"
}

variable "dbUserProdutos" {
  default = "sa"
}

variable "dbPasswordProdutos" {
  default = "Senha12345"
}

variable "sqsPagamentosQueueName" {
  default = "snacktech-processed-payments"
}