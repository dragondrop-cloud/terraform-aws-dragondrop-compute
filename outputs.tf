output "https_trigger_url" {
  value       = module.containerized_lambda_https_endpoint.https_trigger_url
  description = "The url where requests to the https dragondrop trigger hosted on a containerized lambda instance can be sent."
}
