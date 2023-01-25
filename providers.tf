terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region     = local.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
