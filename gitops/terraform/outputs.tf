
output "aws_iam_role_dogeapi_role_name" {
  value = module.appcd_5946a085-5560-51f9-8683-3b21d7bd5f37.name
  sensitive = false
}


output "aws_iam_role_dogeapi_role_arn" {
  value = module.appcd_5946a085-5560-51f9-8683-3b21d7bd5f37.arn
  sensitive = false
}


output "aws_dynamodb_my_table_arn" {
  value = module.appcd_1223c601-9c6f-4d03-b019-b721ed77686c.arn
  sensitive = false
}
