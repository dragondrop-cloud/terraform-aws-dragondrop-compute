output "security_group" {
  description = "Security group for ECS fargate task networking."
  type        = string
  value       = aws_security_group.ecs_fargate_sg.arn
}

output "subnet" {
  description = "Subnet within which the ECS Fargate Task is placed."
  type        = string
  value       = aws_subnet.public_subnet.arn
}
