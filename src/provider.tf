terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
    }
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.regionDefault
}

provider "null" {}