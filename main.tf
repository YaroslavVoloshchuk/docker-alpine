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
resource "docker_image" "jenkins" {
  name = "jenkins/jenkins:2.295-alpine"
  keep_locally = true
}

# Create a container
resource "docker_container" "jenkins" {
  image = docker_image.jenkins.latest
  name  = "jenkins-server"
  restart = "always"
  privileged = "true"
  ports {
    internal = 8080
    external = 8889
  }
  volumes {
    container_path = "/var/jenkins_home"
    host_path      = "/var/jenkins_data"
    
  }
 volumes {
    container_path = "/var/run/docker.sock"
    host_path      = "/var/run/docker.sock"

  }

}
