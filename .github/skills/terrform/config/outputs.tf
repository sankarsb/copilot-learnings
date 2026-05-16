# Output values for the Nginx Docker deployment

output "container_id" {
  description = "ID of the created Nginx container"
  value       = docker_container.nginx.id
}

output "container_name" {
  description = "Name of the created Nginx container"
  value       = docker_container.nginx.name
}

output "container_image" {
  description = "Docker image used for the container"
  value       = docker_image.nginx.repo_digest != null ? docker_image.nginx.repo_digest : "${docker_image.nginx.name}:${var.nginx_version}"
}

output "network_id" {
  description = "ID of the Docker network"
  value       = docker_network.nginx_network.id
}

output "network_name" {
  description = "Name of the Docker network"
  value       = docker_network.nginx_network.name
}

output "nginx_url" {
  description = "URL to access the Nginx web server"
  value       = "http://localhost:${var.external_port}"
}

output "nginx_external_port" {
  description = "External port exposed for Nginx"
  value       = var.external_port
}

output "nginx_internal_port" {
  description = "Internal container port for Nginx"
  value       = 80
}

output "config_volume_name" {
  description = "Name of the Nginx configuration volume"
  value       = docker_volume.nginx_config.name
}

output "logs_volume_name" {
  description = "Name of the Nginx logs volume"
  value       = docker_volume.nginx_logs.name
}

output "container_status" {
  description = "Whether the container must be running"
  value       = docker_container.nginx.must_run
}

output "container_memory" {
  description = "Memory limit for the container in bytes"
  value       = var.container_memory
}

output "container_memory_mb" {
  description = "Memory limit for the container in MB"
  value       = var.container_memory / 1048576
}

output "access_logs_location" {
  description = "Location of Nginx access logs in container"
  value       = "/var/log/nginx/access.log"
}

output "error_logs_location" {
  description = "Location of Nginx error logs in container"
  value       = "/var/log/nginx/error.log"
}

output "healthcheck_status" {
  description = "Health check command for the container"
  value       = "curl -f http://localhost:80/"
}

output "environment_info" {
  description = "Environment and deployment information"
  value = {
    environment    = var.environment
    container_name = var.container_name
    docker_network = var.network_name
    timezone       = var.timezone
    restart_policy = var.restart_policy
  }
}

output "connection_command" {
  description = "Docker command to connect to the container"
  value       = "docker exec -it ${docker_container.nginx.name} /bin/bash"
}

output "view_logs_command" {
  description = "Docker command to view container logs"
  value       = "docker logs -f ${docker_container.nginx.name}"
}

output "container_stats_command" {
  description = "Docker command to view container stats"
  value       = "docker stats ${docker_container.nginx.name}"
}
