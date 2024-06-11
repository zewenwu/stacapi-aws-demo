terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.45.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.1.0"
    }
  }
  required_version = ">= 1.1.3"
}
