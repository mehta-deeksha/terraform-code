output "rds_endpoint" {
  value       = aws_db_instance.rds_instance.endpoint
  description = "The connection endpoint for the RDS instance"
}
