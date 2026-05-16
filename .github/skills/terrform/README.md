# Terraform Docker Nginx Deployment

Production-ready Terraform configuration for deploying Nginx web server in Docker with port 8000 exposure.

## Quick Start

### Prerequisites
- Terraform >= 1.0
- Docker daemon running
- Docker CLI installed

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Configure Variables

Create `terraform.tfvars` from the example:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your settings:

```hcl
external_port = 8000
environment   = "production"
container_name = "nginx-webserver"
```

### 3. Plan Deployment

```bash
terraform plan
```

### 4. Apply Configuration

```bash
terraform apply
```

### 5. Verify Deployment

```bash
# Access Nginx
curl http://localhost:8000

# View container logs
docker logs -f nginx-webserver

# Check container status
docker ps | grep nginx
```

## Configuration Options

### Essential Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `external_port` | 8000 | Port to expose Nginx service |
| `container_name` | nginx-webserver | Name of Docker container |
| `nginx_version` | latest | Nginx image version |
| `environment` | production | Environment name (development/staging/production) |

### Resource Limits

| Variable | Default | Description |
|----------|---------|-------------|
| `container_memory` | 512MB | Memory limit |
| `container_cpu_shares` | 1024 | CPU shares |
| `log_max_size` | 10m | Max log file size |

### Volumes

- **Configuration**: `/etc/nginx` - Nginx configuration
- **Logs**: `/var/log/nginx` - Access and error logs
- **HTML**: `/usr/share/nginx/html` - Web content (if html_path is set)

## Usage Examples

### Development Environment

```hcl
environment        = "development"
external_port      = 8080
container_memory   = 256870912  # 256MB
nginx_version      = "1.25-alpine"  # Lightweight image
```

### Production Environment

```hcl
environment        = "production"
external_port      = 8000
container_memory   = 536870912  # 512MB
restart_policy     = "always"
nginx_version      = "1.25"
```

### Staging with Specific Version

```hcl
environment        = "staging"
external_port      = 8081
nginx_version      = "1.24"  # Pin specific version
```

## Accessing the Container

### Connect to Container Shell

```bash
docker exec -it nginx-webserver /bin/bash
```

### View Nginx Configuration

```bash
docker exec nginx-webserver nginx -T
```

### Test Nginx Configuration

```bash
docker exec nginx-webserver nginx -t
```

### View Access Logs

```bash
docker exec nginx-webserver tail -f /var/log/nginx/access.log
```

### View Error Logs

```bash
docker exec nginx-webserver tail -f /var/log/nginx/error.log
```

## Health Checks

Health check endpoint is automatically configured at:

```
http://localhost:8000/health
```

Monitor health check status:

```bash
docker inspect --format='{{json .State.Health}}' nginx-webserver | jq
```

## Customization

### Using Custom Nginx Configuration

Place your `nginx.conf` in the host path and mount it:

1. Update the volumes section in `main.tf`
2. Or use the provided `nginx.conf` template as a starting point

### Using Custom Web Content

Set the `html_path` variable to your content directory:

```hcl
html_path = "/path/to/your/content"
```

### Environment-Specific Configuration

Use Terraform workspaces:

```bash
# Create workspace
terraform workspace new production

# Select workspace
terraform workspace select production

# Apply with environment-specific variables
terraform apply -var-file="production.tfvars"
```

## Troubleshooting

### Container Won't Start

```bash
# Check logs
docker logs nginx-webserver

# Check container status
docker inspect nginx-webserver
```

### Port Already in Use

Change the port in `terraform.tfvars`:

```hcl
external_port = 8001  # Use different port
terraform apply
```

### Volume Permission Issues

```bash
# Check volume mounts
docker inspect nginx-webserver | grep -A 20 "Mounts"

# Fix permissions
docker exec nginx-webserver chown -R nginx:nginx /var/log/nginx
```

### High Memory Usage

Reduce memory limit in `terraform.tfvars`:

```hcl
container_memory = 268435456  # 256MB
terraform apply
```

## Common Commands

```bash
# View outputs
terraform output

# Get container IP
terraform output -json | jq '.container_id'

# Destroy deployment
terraform destroy

# Refresh state
terraform refresh

# Format code
terraform fmt -recursive

# Validate configuration
terraform validate
```

## Outputs

After deployment, useful outputs are available:

- `nginx_url`: Direct access URL
- `connection_command`: Docker exec command
- `view_logs_command`: Command to view logs
- `container_id`: Docker container ID
- `network_name`: Docker network name

View all outputs:

```bash
terraform output
terraform output -json
```

## Security Considerations

1. **Image Versions**: Pin specific Nginx versions for production
2. **Resource Limits**: Set appropriate memory and CPU limits
3. **Logging**: Configure log rotation to prevent disk space issues
4. **Network**: Use Docker networks to isolate containers
5. **Updates**: Regularly update the Nginx image and Terraform code

## Performance Tuning

### Worker Processes

Edit `nginx.conf`:
```
worker_processes auto;  # Uses available CPUs
```

### Connection Limits

```
worker_connections 1024;  # Adjust based on requirements
```

### Gzip Compression

Already enabled for text content in default config.

## Cleanup

To remove the deployment:

```bash
terraform destroy
```

This will remove:
- Nginx container
- Docker network
- Docker volumes (keep locally if configured)

## Support

For issues or questions:
1. Check Docker logs: `docker logs nginx-webserver`
2. Validate Terraform: `terraform validate`
3. Review Nginx config: `docker exec nginx-webserver nginx -T`
