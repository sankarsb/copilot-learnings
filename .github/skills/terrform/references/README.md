# Terraform Docker Nginx - Complete Operations Guide

## 📋 Overview

Production-ready Terraform configuration for deploying Nginx web server in Docker with port 8000 exposure, health checks, logging, and resource management.

## 🚀 Quick Start

```bash
# Setup
terraform init
cp templates/terraform.tfvars.example terraform.tfvars

# Deploy
terraform plan
terraform apply

# Verify
curl http://localhost:8000
```

See `QUICKSTART.md` for 30-second deployment.

## 📁 Project Structure

```
terrform/
├── main.tf                          # Core resources
├── variables.tf                     # Configuration variables
├── outputs.tf                       # Deployment outputs
├── Makefile                         # Make commands
├── templates/                       # Configuration templates
│   ├── nginx.conf                   # Nginx configuration
│   ├── terraform.tfvars.example     # Example variables
│   └── docker-compose.yml           # Docker Compose alternative
├── scripts/                         # Automation scripts
│   └── deploy.sh                    # Automated deployment
└── references/                      # Documentation
    ├── README.md                    # This file
    ├── QUICKSTART.md               # Quick reference
    ├── EXAMPLES.md                 # Usage examples
    ├── TROUBLESHOOTING.md          # Problem solving
    └── INDEX.md                    # Detailed structure
```

## 🔧 Configuration

### Essential Variables

Edit `terraform.tfvars`:

```hcl
# Port configuration
external_port = 8000

# Container settings
container_name = "nginx-webserver"
restart_policy = "always"

# Resource limits
container_memory = 536870912  # 512MB

# Environment
environment = "production"
```

### All Available Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `docker_host` | `unix:///var/run/docker.sock` | Docker daemon socket |
| `nginx_image` | `nginx` | Docker image name |
| `nginx_version` | `latest` | Nginx version/tag |
| `external_port` | `8000` | Exposed port |
| `container_name` | `nginx-webserver` | Container name |
| `restart_policy` | `always` | Restart policy |
| `container_memory` | `536870912` | Memory limit (bytes) |
| `container_cpu_shares` | `1024` | CPU shares |
| `environment` | `production` | Environment (dev/staging/prod) |
| `log_driver` | `json-file` | Log driver |
| `log_max_size` | `10m` | Max log size |
| `log_max_file` | `3` | Max log files |

See `variables.tf` for complete list with validation rules.

## 🎯 Deployment Scenarios

### Development

```hcl
environment        = "development"
external_port      = 8080
container_memory   = 268435456      # 256MB
nginx_version      = "1.25-alpine"
restart_policy     = "no"
```

### Staging

```hcl
environment        = "staging"
external_port      = 8081
container_memory   = 536870912      # 512MB
nginx_version      = "1.25"
```

### Production

```hcl
environment        = "production"
external_port      = 8000
container_memory   = 1073741824     # 1GB
container_cpu_shares = 2048
restart_policy     = "always"
```

See `EXAMPLES.md` for more scenarios.

## 📊 Resource Configuration

### Volumes

- **Config**: `/etc/nginx` - Nginx configuration
- **Logs**: `/var/log/nginx` - Access and error logs
- **HTML**: `/usr/share/nginx/html` - Web content (optional)

### Ports

- **Internal**: 80 (inside container)
- **External**: 8000 (on host, configurable)

### Health Check

Endpoint: `GET /health` (returns 200 "healthy")

Check status:
```bash
docker inspect --format='{{json .State.Health}}' nginx-webserver | jq
```

## 📈 Usage Commands

### Make Commands

```bash
make init           # Initialize Terraform
make validate       # Validate configuration
make fmt            # Format files
make plan           # Plan changes
make apply          # Apply changes
make destroy        # Destroy resources
make output         # Show outputs
make logs           # View container logs
make shell          # Connect to container
make status         # Show container status
make inspect        # Inspect Docker resources
make health         # Check health endpoint
make verify         # Validate and plan
make full-deploy    # Complete deployment
make full-destroy   # Complete cleanup
```

### Docker Commands

```bash
# Logs
docker logs -f nginx-webserver

# Execute command
docker exec -it nginx-webserver /bin/bash

# Stats
docker stats nginx-webserver

# Test Nginx
docker exec nginx-webserver nginx -t

# Reload config
docker exec nginx-webserver nginx -s reload

# Access logs
docker exec nginx-webserver tail -f /var/log/nginx/access.log
```

### Terraform Commands

```bash
terraform init
terraform validate
terraform fmt -recursive
terraform plan
terraform apply
terraform output
terraform destroy
terraform state show
terraform state list
```

## 🔄 Lifecycle Management

### First Deployment

```bash
# 1. Setup
terraform init
cp templates/terraform.tfvars.example terraform.tfvars

# 2. Customize (edit terraform.tfvars)
# 3. Preview
terraform plan

# 4. Deploy
terraform apply

# 5. Verify
curl http://localhost:8000
make status
```

### Updates

```bash
# 1. Edit terraform.tfvars
# 2. Preview
terraform plan

# 3. Apply
terraform apply
```

### Upgrades (Nginx Version)

```bash
# 1. Update version
# nano terraform.tfvars
# Change: nginx_version = "1.26"

# 2. Apply (recreates container)
terraform apply

# 3. Verify
curl http://localhost:8000
```

### Cleanup

```bash
# Destroy all resources
terraform destroy

# Or use script
make destroy
```

## 🔐 Security Features

1. **Network Isolation** - Custom Docker network
2. **Security Headers** - Pre-configured in nginx.conf
3. **Resource Limits** - Memory and CPU constraints
4. **Logging** - JSON-file driver with rotation
5. **Health Checks** - Continuous monitoring
6. **Labels** - Resource identification
7. **Read-only Volumes** - Where possible

## 📊 Monitoring

### Real-time Monitoring

```bash
# Resource usage
docker stats nginx-webserver

# Logs (last 50 lines)
docker logs --tail 50 nginx-webserver

# Follow logs
docker logs -f nginx-webserver

# JSON format
docker logs --log-driver json-file nginx-webserver
```

### Health Status

```bash
# Health check
curl http://localhost:8000/health

# Detailed status
docker inspect --format='{{json .State.Health}}' nginx-webserver

# Full container details
docker inspect nginx-webserver
```

### Performance Analysis

```bash
# Active connections
netstat -an | grep 8000 | wc -l

# Nginx status page (if enabled)
curl http://localhost:8000/nginx_status

# Access logs analysis
docker exec nginx-webserver tail -100 /var/log/nginx/access.log
```

## 🔧 Customization

### Custom Nginx Configuration

1. Edit `templates/nginx.conf`
2. Add volume mount in `main.tf` (if needed)
3. Update container and redeploy:
   ```bash
   terraform apply
   ```

### Custom HTML Content

```hcl
# terraform.tfvars
html_path = "/path/to/your/content"
```

### Custom Image

```hcl
# terraform.tfvars
nginx_image = "my-registry/nginx-custom"
nginx_version = "1.0"
```

### Environment-Specific Configuration

Using workspaces:

```bash
terraform workspace new production
terraform workspace select production
terraform apply -var-file="production.tfvars"
```

## 🚀 Automation Scripts

### Using deploy.sh

```bash
cd scripts/
chmod +x deploy.sh

# Deploy
./deploy.sh deploy

# Check prerequisites
./deploy.sh check

# Destroy
./deploy.sh destroy
```

### Using Docker Compose

```bash
docker-compose -f templates/docker-compose.yml up -d
docker-compose -f templates/docker-compose.yml down
```

## 🐛 Troubleshooting

Common issues and solutions:

| Issue | Solution |
|-------|----------|
| Port 8000 in use | Change `external_port` in terraform.tfvars |
| Container won't start | Check logs: `docker logs nginx-webserver` |
| Permission denied | Run with sudo or fix Docker group permissions |
| High memory usage | Reduce `container_memory` |
| Slow response | Increase resources or check configuration |

See `TROUBLESHOOTING.md` for detailed solutions.

## 📈 Performance Tuning

### Worker Configuration

In `templates/nginx.conf`:
```nginx
worker_processes auto;          # Use available CPUs
worker_connections 1024;        # Per worker
keepalive_timeout 30;           # Client timeout
```

### Gzip Compression

```nginx
gzip on;
gzip_min_length 1024;
gzip_types text/plain text/css application/json;
```

### Resource Limits

In `terraform.tfvars`:
```hcl
container_memory = 1073741824       # 1GB
container_cpu_shares = 2048         # 2x default
```

## 📚 Additional Resources

- **Nginx Documentation**: https://nginx.org/en/docs/
- **Terraform Docs**: https://www.terraform.io/docs
- **Docker Docs**: https://docs.docker.com
- **Kreuzwerker Docker Provider**: https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs

## 📞 Support

1. Check `QUICKSTART.md` for basic commands
2. Review `EXAMPLES.md` for usage patterns
3. See `TROUBLESHOOTING.md` for common issues
4. Inspect logs: `docker logs nginx-webserver`
5. Validate config: `terraform validate`

## ✨ Key Features Summary

| Feature | Status | Details |
|---------|--------|---------|
| Production Ready | ✅ | Validated config, health checks |
| Easy Setup | ✅ | Single `make apply` |
| Flexible Config | ✅ | 25+ variables, all customizable |
| Security | ✅ | Headers, isolation, logging |
| Monitoring | ✅ | Health checks, logs, stats |
| Documentation | ✅ | Complete guides and examples |
| Automation | ✅ | Scripts, Make, Docker Compose |
| Scalable | ✅ | Multiple instances supported |

---

**Start deploying:** `make init && make plan && make apply`
