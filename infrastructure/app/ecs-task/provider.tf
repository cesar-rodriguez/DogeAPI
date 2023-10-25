terraform {
  required_version = "~> 1.5.6"

  backend "s3" {
    bucket   = "cafi-demo1"
    key      = "demos/core/ecs-task/terraform.tfstate"
    region   = "us-east-1"
    role_arn = "arn:aws:iam::180217099948:role/atlantis-access"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::180217099948:role/atlantis-access"
  }
}
