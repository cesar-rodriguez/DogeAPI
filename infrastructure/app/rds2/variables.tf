variable "environment" {
  description = "Environment name"
}

variable "aws_region" {
  description = "AWS region"
}

variable "database_name" {
  description = "Database name"
}

variable "db_engine" {
  description = "Database engine"
  default     = "aurora-postgresql"
}

variable "db_engine_version" {
  description = "Engine version"
  default     = "13.9"
}

variable "db_subnet_group_name" {
  description = "Database subnet group name"
}

variable "private_subnets_cidr_blocks" {
  description = "Private subnets CIDR blocks"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "backup_retention_period" {
  type        = string
  description = "The number of days to retain backups for"
  default     = 7
}

variable "master_password" {
  type        = string
  description = "The master password for the RDS cluster"
}

variable "rds_auto_pause" {
  type        = bool
  default     = true
  description = "value for auto pause"
}

variable "rds_max_capacity" {
  type        = number
  default     = 16
  description = "value for max capacity"
}

variable "rds_min_capacity" {
  type        = number
  default     = 2
  description = "value for min capacity"
}

variable "rds_seconds_until_auto_pause" {
  type        = number
  default     = 300
  description = "value for seconds until auto pause"
}
