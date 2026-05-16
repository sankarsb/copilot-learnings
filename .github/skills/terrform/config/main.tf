# Docker provider configuration for Nginx deployment
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = var.docker_host
}

# Pull the official Nginx image
resource "docker_image" "nginx" {
  name          = "${var.nginx_image}:${var.nginx_version}"
  keep_locally  = var.keep_image_locally
  pull_triggers = [var.nginx_version]
}

# Create Docker network
resource "docker_network" "nginx_network" {
  name   = var.network_name
  driver = "bridge"

  labels {
    label = "environment"
    value = var.environment
  }
}

# Create Docker volume for Nginx configuration
resource "docker_volume" "nginx_config" {
  name = "${var.container_name}-config"

  labels {
    label = "environment"
    value = var.environment
  }
}

# Create Docker volume for Nginx logs
resource "docker_volume" "nginx_logs" {
  name = "${var.container_name}-logs"

  labels {
    label = "environment"
    value = var.environment
  }
}

# Create Nginx container
resource "docker_container" "nginx" {
  name              = var.container_name
  image             = docker_image.nginx.image_id
  restart_policy    = var.restart_policy
  must_run          = true
  memory            = var.container_memory
  memory_swap       = var.container_memory_swap
  cpu_shares        = var.container_cpu_shares
  log_driver        = var.log_driver
  network_mode      = docker_network.nginx_network.name

  # Port mapping - expose 8000
  ports {
    internal = 80
    external = var.external_port
    protocol = "tcp"
  }

  # Environment variables
  env = [
    "TZ=${var.timezone}",
    "NGINX_PORT=80",
  ]

  # Volume mounts
  volumes {
    volume_name    = docker_volume.nginx_config.name
    container_path = "/etc/nginx"
    read_only      = false
  }

  volumes {
    volume_name    = docker_volume.nginx_logs.name
    container_path = "/var/log/nginx"
    read_only      = false
  }

  # Optional: Mount default Nginx HTML
  volumes {
    host_path      = var.html_path
    container_path = "/usr/share/nginx/html"
    read_only      = false
  }

  # Logging configuration
  log_opts = {
    "max-size" = var.log_max_size
    "max-file" = var.log_max_file
  }

  # Health check
  healthcheck {
    test     = ["CMD", "curl", "-f", "http://localhost:80/"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
  }

  # Resource limits
  ulimit {
    name = "nofile"
    soft = 65536
    hard = 65536
  }

  # Labels
  labels {
    label = "environment"
    value = var.environment
  }

  labels {
    label = "application"
    value = "nginx"
  }

  labels {
    label = "managed_by"
    value = "terraform"
  }

  depends_on = [
    docker_network.nginx_network,
    docker_volume.nginx_config,
    docker_volume.nginx_logs
  ]
}
