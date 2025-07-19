output "container_id" {
  description = "ID of the Docker container"
  value       = docker_container.webapp.id
}

output "image_id" {
  description = "ID of the Docker image"
  value       = docker_image.webapp.image_id
}

output "application_url" {
  description = "URL to access the application"
  value       = "http://localhost:${var.external_port}"
}