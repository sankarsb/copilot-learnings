terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = true
}

resource "docker_container" "ec2_bill" {
  name    = "ec2-bill-9010"
  image   = docker_image.nginx.image_id
  restart = "unless-stopped"

  ports {
    internal = 80
    external = 9010
    ip       = "127.0.0.1"
    protocol = "tcp"
  }

  volumes {
    host_path      = "${abspath(path.module)}/index.html"
    container_path = "/usr/share/nginx/html/index.html"
    read_only      = true
  }
}

output "container_name" {
  value = docker_container.ec2_bill.name
}

output "url" {
  value = "http://localhost:9010"
}
