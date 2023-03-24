output "https_trigger_url" {
  value       = aws_lambda_function_url.dragondrop_https_endpoint.function_url
  description = "HTTPS Trigger URL to which dragondrop can trigger Job executions."
}
