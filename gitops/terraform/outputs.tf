
output "aws_dynamodb_my_table_arn" {
  value = module.stackgen_e567b60b-9bea-4cd5-8672-f6f8a3bc6abd.arn
  sensitive = false
}


output "aws_iam_role_dogeapi_role_arn" {
  value = module.stackgen_5946a085-5560-51f9-8683-3b21d7bd5f37.arn
  sensitive = false
}


output "aws_iam_role_dogeapi_role_name" {
  value = module.stackgen_5946a085-5560-51f9-8683-3b21d7bd5f37.name
  sensitive = false
}
