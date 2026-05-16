# Troubleshooting Guide

## ❌ Common Issues & Solutions

### Port Already in Use

**Error:** `Error response from daemon: driver failed... address already in use`

**Solution:**
```bash
# Find process using port 8000
netstat -ano | findstr :8000  # Windows
lsof -i :8000                 # Mac/Linux

# Change port in terraform.tfvars
external_port = 8001

# Redeploy
terraform apply
```

### Docker Daemon Not Running

**Error:** `Cannot connect to the Docker daemon`

**Solution:**
```bash
# Windows
# Start Docker Desktop from Applications

# Linux
sudo systemctl start docker

# Mac
# Start Docker Desktop from Applications
```

### Container Won't Start

**Error:** Container exits immediately

**Solution:**
```bash
# Check logs
docker logs nginx-webserver

# Common causes:
# 1. Permission denied - check volume permissions
# 2. Configuration error - test nginx config
docker exec nginx-webserver nginx -t

# 3. Port binding issue - check ports
docker port nginx-webserver

# 4. Image not available - pull manually
docker pull nginx:latest
```

### Permission Denied on Volumes

**Error:** `permission denied while trying to connect to the Docker daemon`

**Solution:**
```bash
# Linux: Add user to docker group
sudo usermod -aG docker $USER
sudo systemctl restart docker

# Or run with sudo
sudo terraform apply

# Fix volume permissions
docker exec nginx-webserver chown -R nginx:nginx /var/log/nginx
docker exec nginx-webserver chmod -R 755 /etc/nginx
```

### High Memory Usage

**Error:** Container using excessive memory

**Solution:**
```hcl
# Reduce memory limit in terraform.tfvars
container_memory = 268435456  # 256MB instead of 512MB

# Apply changes
terraform apply
```

**Monitor:**
```bash
docker stats nginx-webserver

# Check actual usage
docker inspect nginx-webserver | grep -A 10 Memory
```

### Slow Response Times

**Error:** Nginx responds slowly

**Solutions:**

1. Check resource limits:
```bash
docker stats nginx-webserver
```

2. Increase resources:
```hcl
# terraform.tfvars
container_memory = 1073741824  # 1GB
container_cpu_shares = 2048    # More CPU
```

3. Optimize Nginx config:
```nginx
# templates/nginx.conf
worker_processes auto;
worker_connections 2048;
keepalive_timeout 30;
```

4. Check network:
```bash
docker inspect nginx-network
```

### Health Check Failing

**Error:** Health check continuously failing

**Solution:**
```bash
# Test health endpoint manually
curl -v http://localhost:8000/health

# Check logs
docker logs nginx-webserver | grep health

# Verify endpoint in nginx.conf
docker exec nginx-webserver curl localhost/health

# Increase health check timeout
# Edit main.tf and increase timeout values
```

### Cannot Access Nginx URL

**Error:** `curl: (7) Failed to connect to localhost:8000`

**Solution:**
```bash
# 1. Check container is running
docker ps | grep nginx-webserver

# 2. Verify port mapping
docker port nginx-webserver

# 3. Test inside container
docker exec nginx-webserver curl localhost

# 4. Check firewall (Windows)
netsh advfirewall firewall add rule name="Nginx 8000" dir=in action=allow protocol=tcp localport=8000

# 5. Check network connectivity
ping localhost
telnet localhost 8000
```

### Terraform Errors

#### "Terraform not initialized"
```bash
terraform init
```

#### "Resource already exists"
```bash
# Import existing resource or remove it manually
docker rm nginx-webserver
terraform apply
```

#### "Variable validation failed"
```bash
# Check terraform.tfvars for correct values
# Common issues:
# - Port out of range (1-65535)
# - Invalid container name (only alphanumeric, dash, underscore)
# - Invalid environment (must be development/staging/production)
```

#### "State lock timeout"
```bash
# Force unlock (use carefully)
terraform force-unlock <LOCK_ID>

# Or remove lock file
rm .terraform.tfstate.lock.hcl
```

### Docker Image Issues

#### "Image pull failed"
```bash
# Try pulling manually
docker pull nginx:latest

# Check Docker registry connection
docker search nginx

# Use different registry
# terraform.tfvars
nginx_image = "gcr.io/nginx"
```

#### "Image not found"
```bash
# List available images
docker images | grep nginx

# Pull specific version
docker pull nginx:1.25

# Update terraform.tfvars
nginx_version = "1.25"
```

### Volume Issues

#### "Volume already exists"
```bash
# List volumes
docker volume ls

# Remove conflicting volume
docker volume rm nginx-webserver-config

# Recreate
terraform apply
```

#### "Cannot mount volume"
```bash
# Check volume permissions
docker inspect <VOLUME_NAME>

# Fix permissions
docker run --rm -v <VOLUME_NAME>:/mnt alpine chown -R 1000:1000 /mnt
```

### Network Issues

#### "Network already exists"
```bash
# List networks
docker network ls

# Remove conflicting network
docker network rm nginx-network

# Recreate
terraform apply
```

#### "Container can't reach other services"
```bash
# Verify network connection
docker network inspect nginx-network

# Test DNS resolution
docker exec nginx-webserver nslookup other-service

# Check service is on same network
docker inspect other-container | grep -A 3 NetworkSettings
```

### Logging Issues

#### "Log files too large"
```bash
# Reduce log rotation size
# terraform.tfvars
log_max_size = "5m"
log_max_file = "2"

# Or clean up manually
docker exec nginx-webserver truncate -s 0 /var/log/nginx/access.log
```

#### "Can't view logs"
```bash
# Check log driver
docker inspect nginx-webserver | grep LogDriver

# View with docker logs
docker logs -f nginx-webserver

# Or access volume directly
docker run -v nginx-webserver-logs:/logs -it alpine tail -f /logs/access.log
```

## 🔍 Debugging Commands

```bash
# Check container status
docker ps -a | grep nginx

# Detailed container info
docker inspect nginx-webserver

# Check network
docker network inspect nginx-network

# Check volumes
docker volume inspect nginx-webserver-config
docker volume inspect nginx-webserver-logs

# View all logs
docker logs nginx-webserver

# Follow logs in real-time
docker logs -f nginx-webserver

# Get last 100 lines
docker logs --tail 100 nginx-webserver

# Check resource usage
docker stats nginx-webserver

# Execute commands in container
docker exec -it nginx-webserver /bin/bash
docker exec nginx-webserver nginx -T

# Test connectivity
docker exec nginx-webserver curl localhost
docker exec nginx-webserver curl localhost/health
```

## 📊 Performance Diagnostics

```bash
# Check Nginx status
docker exec nginx-webserver curl http://localhost/nginx_status

# Monitor in real-time
watch 'docker stats nginx-webserver --no-stream'

# Check active connections
docker exec nginx-webserver grep active /var/log/nginx/access.log | wc -l

# Benchmark
docker run --rm --network container:nginx-webserver \
  apache2-utils ab -n 1000 -c 10 http://localhost/
```

## 🔧 Recovery Steps

If deployment is stuck:

```bash
# 1. Stop container
docker stop nginx-webserver

# 2. Remove container
docker rm nginx-webserver

# 3. Remove network and volumes (optional)
docker network rm nginx-network
docker volume rm nginx-webserver-config nginx-webserver-logs

# 4. Clear Terraform state (optional)
terraform state rm docker_container.nginx

# 5. Redeploy
terraform apply
```

## 📞 Getting Help

1. **Check Terraform plan:** `terraform plan`
2. **Review container logs:** `docker logs nginx-webserver`
3. **Test configuration:** `docker exec nginx-webserver nginx -t`
4. **Check resources:** `docker stats nginx-webserver`
5. **Review SKILL.md** for expected behavior

For more details, see `README.md` and `EXAMPLES.md`.
