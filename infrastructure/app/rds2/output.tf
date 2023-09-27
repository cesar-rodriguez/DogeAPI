output "rds_cluster_endpoint" {
  description = "The endpoint for the RDS cluster."
  value       = aws_rds_cluster.this.endpoint
}

output "rds_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the RDS cluster."
  value       = aws_rds_cluster.this.arn
}
