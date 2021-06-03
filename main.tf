terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.12.2"
    }
  }
}

provider "docker" { 
# host = "tcp://127.0.0.1:2375"
 host = "unix:///var/run/docker.sock"
}

# Pulls the image
resource "docker_image" "example-alpine" {
  name = "bamik/docker-alpine:latest"
  keep_locally = true
}

# Create a container
resource "docker_container" "example-alpine" {
  image = docker_image.example-alpine.latest
  name  = "php-site"
  restart = "always"
  privileged = "true"
  ports {
    internal = 8080
    external = 8890
  }
  volumes {
    container_path = "/var/www/html"
    host_path      = "/var/www/alpine-site"
    
  }
 

}
