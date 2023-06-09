variable "default_secret_value" {
  description = "Default secret value during instantiation"
  type        = string
  default     = "placeholder"
}

variable "name" {
  description = "Name of the secret"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
