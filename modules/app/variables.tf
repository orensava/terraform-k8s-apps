variable "app_name" {
  description = "Application name"
  type        = string
}

variable "app_config" {
  description = "Application configuration"
  type = object({
    replicas       = number
    container_port = number
    node_port      = number
  })
}