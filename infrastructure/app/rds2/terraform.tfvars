environment          = "demo"
aws_region           = "us-east-2"
database_name        = "dogeapiserverless"
db_subnet_group_name = "demo-vpc-demo"
private_subnets_cidr_blocks = [
  "10.0.3.0/24",
  "10.0.4.0/24",
  "10.0.5.0/24",
]
subnets = [
  "subnet-0a1eeecd978b2d990",
  "subnet-06a1939485b03e1e8",
  "subnet-04b60b5362d2d3a61",
]
vpc_id = "vpc-0c37ffe0affae162f"
