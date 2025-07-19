terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "webapp" {
  name         = "nginx:alpine"
  keep_locally = false
}

resource "docker_container" "webapp" {
  image = docker_image.webapp.image_id
  name  = "${var.app_name}-${var.environment}"
  
  ports {
    internal = 80
    external = var.external_port
  }
  
  labels {
    label = "environment"
    value = var.environment
  }
}