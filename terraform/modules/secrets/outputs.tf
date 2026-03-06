output "db_password_secret_arn" {
  description = "ARN of the Secrets Manager Secret holding the DB password"
  value       = aws_secretsmanager_secret.db_password.arn
}

output "db_password" {
  description = "The generated database password"
  value       = random_password.db_password.result
  sensitive   = true
}
