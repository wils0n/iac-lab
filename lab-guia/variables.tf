variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "my-app"
}

variable "external_port" {
  description = "External port for the application"
  type        = number
  default     = 8080
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}