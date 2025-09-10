terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "django-recipe-devops"
    key            = "tfstate/setup"
    region         = "us-east-1"
    dynamodb_table = "django-recipe-devops-tf-lock"
    encrypt        = true

  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = terraform.workspace
      project     = var.project_name
      contact     = var.contact
      ManagedBY   = "TF/setup"
    }
  }
}
