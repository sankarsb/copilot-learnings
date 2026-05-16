# Docker configuration variables
variable "docker_host" {
  description = "Docker daemon socket to connect to"
  type        = string
  default     = "unix:///var/run/docker.sock"

  validation {
    condition     = can(regex("^(unix|tcp|ssh)://", var.docker_host))
    error_message = "Docker host must be a valid socket (unix://, tcp://, or ssh://)."
  }
}

# Nginx image variables
variable "nginx_image" {
  description = "Nginx Docker image name"
  type        = string
  default     = "nginx"

  validation {
    condition     = length(var.nginx_image) > 0
    error_message = "Nginx image name cannot be empty."
  }
}

variable "nginx_version" {
  description = "Nginx image version/tag"
  type        = string
  default     = "latest"

  validation {
    condition     = length(var.nginx_version) > 0
    error_message = "Nginx version cannot be empty."
  }
}

variable "keep_image_locally" {
  description = "Whether to keep the Docker image locally after destroying the container"
  type        = bool
  default     = true
}

# Network variables
variable "network_name" {
  description = "Name of the Docker network"
  type        = string
  default     = "nginx-network"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.network_name))
    error_message = "Network name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

# Container configuration variables
variable "container_name" {
  description = "Name of the Docker container"
  type        = string
  default     = "nginx-webserver"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.container_name))
    error_message = "Container name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "restart_policy" {
  description = "Docker restart policy: no, always, on-failure, unless-stopped"
  type        = string
  default     = "always"

  validation {
    condition     = contains(["no", "always", "on-failure", "unless-stopped"], var.restart_policy)
    error_message = "Restart policy must be one of: no, always, on-failure, unless-stopped."
  }
}

# Port configuration
variable "external_port" {
  description = "External port to expose Nginx service"
  type        = number
  default     = 8000

  validation {
    condition     = var.external_port > 0 && var.external_port < 65536
    error_message = "Port must be between 1 and 65535."
  }
}

# Resource limits
variable "container_memory" {
  description = "Memory limit for container in bytes"
  type        = number
  default     = 536870912 # 512MB

  validation {
    condition     = var.container_memory > 0
    error_message = "Memory must be greater than 0."
  }
}

variable "container_memory_swap" {
  description = "Memory swap limit for container in bytes (-1 for unlimited)"
  type        = number
  default     = -1
}

variable "container_cpu_shares" {
  description = "CPU shares for container (relative weight)"
  type        = number
  default     = 1024

  validation {
    condition     = var.container_cpu_shares > 0
    error_message = "CPU shares must be greater than 0."
  }
}

# Logging variables
variable "log_driver" {
  description = "Docker logging driver"
  type        = string
  default     = "json-file"

  validation {
    condition     = contains(["json-file", "syslog", "awslogs", "splunk", "gcplogs"], var.log_driver)
    error_message = "Log driver must be one of: json-file, syslog, awslogs, splunk, gcplogs."
  }
}

variable "log_max_size" {
  description = "Maximum log file size"
  type        = string
  default     = "10m"
}

variable "log_max_file" {
  description = "Maximum number of log files"
  type        = string
  default     = "3"
}

# Volume paths
variable "html_path" {
  description = "Host path to mount as Nginx HTML directory"
  type        = string
  default     = "/var/www/html"
}

# Environment variables
variable "timezone" {
  description = "Container timezone"
  type        = string
  default     = "UTC"
}

variable "environment" {
  description = "Environment name for labeling and organization"
  type        = string
  default     = "production"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be one of: development, staging, production."
  }
}
