terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.12.2"
   }
  }
  backend "local" {
    path = "/data/terraform.tfstate"
   
  }
}

#data "terraform_remote_state" "terra" {
#  backend = "local"

#  config = {
#    path = "${path.module}/../../terraform.tfstate"
#  }
#}

provider "docker" { 
 host = "unix:///var/run/docker.sock"
 }

# Pulls the image
data "docker_registry_image" "example-alpine" {

  name = "bamik/docker-alpine:v1.0.106"
}

resource "docker_image" "example-alpine" {
  name          = data.docker_registry_image.example-alpine.name
  pull_triggers = [data.docker_registry_image.example-alpine.sha256_digest]
}

# Create a container
resource "docker_container" "example-alpine" {
 # name_prefix   ="cn-"
  lifecycle {
   #ignore_changes = [name]
   create_before_destroy = true
 }
  image = docker_image.example-alpine.latest
  name  = ""
  restart = "always"
 # privileged = "true"
  ports {
    internal = 80
    external = 8891
  }
 
}

###some text####
###new item###
##blabla##
#bla
#aaa
