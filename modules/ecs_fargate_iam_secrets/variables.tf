variable "dragondrop_api_path_name" {
  description = "dragondrop API path."
  type        = string
}

variable "log_creator_policy_name" {
  description = "Name of the log creator policy to create. Will be prefixed by 'dragondrop'."
  type        = string
}

variable "secret_reader_policy_name" {
  description = "Name of the secret_reader policy to create. Will be prefixed by 'dragondrop'."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
