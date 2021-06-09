terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.12.2"
    }
  }
  backend "local" {
    path = "~/data/terraform.tfstate"
  }

}

provider "docker" { 
 host = "unix:///var/run/docker.sock"
}

# Pulls the image
data "docker_registry_image" "example-alpine" {

  name = "bamik/docker-alpine:latest"
}

resource "docker_image" "example-alpine" {
  name          = data.docker_registry_image.example-alpine.name
  pull_triggers = [data.docker_registry_image.example-alpine.sha256_digest]
}

# Create a container
resource "docker_container" "example-alpine" {
  image = docker_image.example-alpine.latest
  name  = "php-site"
  restart = "always"
  privileged = "true"
 # lifecycle {
  #  create_before_destroy = true
 # }
  ports {
    internal = 80
    external = 8890
  }
}
