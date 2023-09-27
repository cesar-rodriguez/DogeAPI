terraform {
  required_version = "~> 1.5.6"

  backend "s3" {
    bucket   = "cafi-demo1"
    key      = "demos/dogeapi/rds2/terraform.tfstate"
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

provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::180217099948:role/atlantis-access"
  }
}

locals {
  tags = {
    Terraform   = "True"
    Environment = var.environment
  }
}

# PostgreSQL Serverless v1
data "aws_rds_engine_version" "postgresql" {
  engine  = var.db_engine
  version = var.db_engine_version
  filter {
    name   = "engine-mode"
    values = ["serverless"]
  }
}

/*
aws rds create-db-cluster --db-cluster-identifier sample-cluster \
    --engine aurora-postgresql --engine-version 13.9 \
    --engine-mode serverless \
    --scaling-configuration MinCapacity=8,MaxCapacity=64,SecondsUntilAutoPause=1000,AutoPause=true \
    --master-username username --manage-master-user-password
*/
resource "aws_rds_cluster" "this" {
  cluster_identifier      = "${var.database_name}-${var.environment}"
  engine                  = data.aws_rds_engine_version.postgresql.engine
  engine_version          = data.aws_rds_engine_version.postgresql.version
  engine_mode             = "serverless"
  database_name           = var.database_name
  master_username         = "root"
  master_password         = var.master_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = true
  storage_encrypted       = true

  scaling_configuration {
    auto_pause               = var.rds_auto_pause
    max_capacity             = var.rds_max_capacity
    min_capacity             = var.rds_min_capacity
    seconds_until_auto_pause = var.rds_seconds_until_auto_pause
  }

  tags = local.tags
}

resource "aws_db_subnet_group" "this" {
  name       = var.db_subnet_group_name
  subnet_ids = var.private_subnets_cidr_blocks
  tags       = local.tags
}
