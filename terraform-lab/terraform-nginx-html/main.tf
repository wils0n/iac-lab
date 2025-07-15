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
  name         = "${var.app_name}-image"
  build {
    context    = "${path.module}"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "webapp" {
  name  = "${var.app_name}-${var.environment}"
  image = docker_image.webapp.name

  ports {
    internal = 80
    external = var.external_port
  }

  labels {
    label = "environment"
    value = var.environment
  }
}
