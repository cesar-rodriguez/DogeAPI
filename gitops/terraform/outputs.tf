
output "aws_iam_role_dogeapi_role_arn" {
  value = module.appcd_5946a085-5560-51f9-8683-3b21d7bd5f37.arn
  sensitive = false
}


output "aws_iam_role_dogeapi_role_name" {
  value = module.appcd_5946a085-5560-51f9-8683-3b21d7bd5f37.name
  sensitive = false
}


output "aws_s3_stackgen_test_cesar_arn" {
  value = module.appcd_74482f48-9cfc-488d-9418-0e621a6fe666.arn
  sensitive = false
}


output "aws_s3_stackgen_test_cesar_bucket_name" {
  value = module.appcd_74482f48-9cfc-488d-9418-0e621a6fe666.bucket_name
  sensitive = false
}


output "aws_s3_stackgen_test_cesar_bucket_website_endpoint" {
  value = module.appcd_74482f48-9cfc-488d-9418-0e621a6fe666.bucket_website_endpoint
  sensitive = false
}


output "aws_s3_stackgen_test_cesar_kms_arn" {
  value = module.appcd_74482f48-9cfc-488d-9418-0e621a6fe666.kms_arn
  sensitive = false
}
