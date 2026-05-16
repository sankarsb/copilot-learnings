# Usage Examples

## 🎯 Common Scenarios

### 1. Development Environment

```hcl
# terraform.tfvars
environment        = "development"
external_port      = 8080
container_memory   = 268435456  # 256MB
nginx_version      = "1.25-alpine"
restart_policy     = "no"
```

Deploy:
```bash
terraform apply
curl http://localhost:8080
```

### 2. Production High-Performance

```hcl
# terraform.tfvars
environment        = "production"
external_port      = 8000
container_memory   = 1073741824  # 1GB
container_cpu_shares = 2048      # Double CPU
nginx_version      = "1.25"      # Specific version
restart_policy     = "always"
```

### 3. Staging Environment

```hcl
# terraform.tfvars
environment        = "staging"
external_port      = 8081
container_memory   = 536870912   # 512MB
nginx_version      = "1.25-alpine"
```

### 4. Minimal Resource Usage

```hcl
# terraform.tfvars
external_port      = 8000
container_memory   = 134217728   # 128MB
container_cpu_shares = 512       # Half CPU
log_max_file       = "1"         # Single log file
```

## 🔄 Multiple Instances (Load Balanced)

Using Terraform workspaces:

```bash
# Create instances
terraform workspace new nginx-1
terraform apply -var="external_port=8000" -var="container_name=nginx-1"

terraform workspace new nginx-2
terraform apply -var="external_port=8001" -var="container_name=nginx-2"

terraform workspace new nginx-3
terraform apply -var="external_port=8002" -var="container_name=nginx-3"
```

Configure Nginx load balancer:

```nginx
upstream backend {
    server localhost:8000;
    server localhost:8001;
    server localhost:8002;
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
    }
}
```

## 🔗 Integration with Reverse Proxy

Using Nginx as reverse proxy for backend services:

**nginx.conf snippet:**
```nginx
upstream api_backend {
    server backend-api:3000;
}

server {
    listen 80;
    server_name api.example.com;

    location / {
        proxy_pass http://api_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 🌐 Custom Domain Configuration

For serving multiple domains:

**nginx.conf snippet:**
```nginx
server {
    listen 80;
    server_name api.example.com;
    location / {
        proxy_pass http://api-backend:3000;
    }
}

server {
    listen 80;
    server_name web.example.com;
    location / {
        proxy_pass http://web-backend:8080;
    }
}

server {
    listen 80;
    server_name static.example.com;
    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}
```

## 📊 Monitoring Setup

Add monitoring labels:

```hcl
# main.tf - Add to docker_container
labels {
  label = "monitoring"
  value = "prometheus"
}

labels {
  label = "alerts"
  value = "enabled"
}
```

Monitor with Docker stats:
```bash
docker stats nginx-webserver --no-stream
```

## 🔐 SSL/TLS Configuration (Advanced)

**nginx.conf snippet:**
```nginx
server {
    listen 443 ssl http2;
    server_name example.com;

    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location / {
        proxy_pass http://backend:3000;
    }
}

server {
    listen 80;
    server_name example.com;
    return 301 https://$server_name$request_uri;
}
```

Mount SSL certificates via volume in Terraform.

## 🐳 Docker Network Integration

Deploy multiple containers on same network:

```bash
# Create network
docker network create myapp-network

# Deploy Nginx
terraform apply -var="network_name=myapp-network"

# Deploy other services on same network
docker run --network myapp-network --name api-backend -d myapi:latest
docker run --network myapp-network --name web-backend -d myweb:latest
```

## 📈 Auto-Scaling Scenario

Using external automation:

```bash
#!/bin/bash
for i in {1..5}; do
  PORT=$((8000 + i))
  NAME="nginx-instance-$i"
  terraform workspace new "$NAME"
  terraform apply \
    -var="external_port=$PORT" \
    -var="container_name=$NAME"
done
```

## 🔧 Custom Nginx Modules

Using custom Nginx image with modules:

```hcl
# terraform.tfvars
nginx_image = "my-registry/nginx-custom"
nginx_version = "1.25-with-modules"
```

## 📝 CI/CD Pipeline Example

GitHub Actions workflow:

```yaml
name: Deploy Nginx

on: [push]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v1
      
      - name: Initialize
        run: terraform init
      
      - name: Plan
        run: terraform plan -out=tfplan
      
      - name: Apply
        run: terraform apply tfplan
      
      - name: Verify
        run: curl -f http://localhost:8000/health
```

## 🚀 Container Registry Example

Using Docker Hub or private registry:

```hcl
# terraform.tfvars
nginx_image = "docker.io/library/nginx"
nginx_version = "1.25"

# Or private registry
# nginx_image = "registry.example.com/nginx"
# nginx_version = "v1.0"
```

## 📚 More Examples

Check README.md for:
- Development setup
- Production hardening
- Performance tuning
- Security configuration
