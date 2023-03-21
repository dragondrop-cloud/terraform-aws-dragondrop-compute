output "arn" {
  description = "The ARN of the secret manager secret."
  value       = aws_secretsmanager_secret.secret.arn
}
