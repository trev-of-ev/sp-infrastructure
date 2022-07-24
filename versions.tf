terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.23"
    }
  }

  required_version = ">= 0.14.5"
}

provider "aws" {
  region  = "us-east-1"
}