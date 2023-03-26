output "https_trigger_url" {
  value       = module.lambda_https_endpoint.https_trigger_url
  description = "The url where requests to the https dragondrop trigger hosted on a lambda instance can be sent."
}
