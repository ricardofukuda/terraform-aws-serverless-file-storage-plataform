terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.2.0"
    }
  }

  backend "s3" {
    bucket  = "terraform-aws-serverless-file-plataform-12345"
    region  = "us-east-1"
    key     = "terraform.tfstate"
    profile = "ricardo"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "ricardo"
}
