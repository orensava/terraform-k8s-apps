# Input variables for the app module

variable "app_name" {
  description = "Name of the application"
}

variable "replicas" {
  description = "Number of replicas"
}

variable "container_port" {
  description = "Port the container listens on"
}

variable "node_port" {
  description = "NodePort to expose externally"
}
