# Gets account ID
data "aws_caller_identity" "current" {}

# Used to get VPC ID
data "aws_subnet" "selected" {
  id = var.private_subnet_ids[0]
}
