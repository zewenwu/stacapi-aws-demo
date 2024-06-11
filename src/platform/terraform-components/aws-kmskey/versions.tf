terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.45.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.2.0"
    }
  }
  required_version = ">= 1.1.3"
}
