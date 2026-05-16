# Project Structure & Reference Guide

## 📁 Complete File Organization

```
terrform/
│
├── 📄 Core Terraform Files
│   ├── main.tf                      # Docker image, network, volumes, container
│   ├── variables.tf                 # 25+ configurable variables with validation
│   ├── outputs.tf                   # 20+ outputs (IDs, URLs, commands)
│   ├── Makefile                     # 15+ make commands
│   ├── .gitignore                   # Git patterns
│   └── README.md                    # Root documentation
│
├── 📁 templates/                    # Configuration Templates
│   ├── nginx.conf                   # Nginx server configuration
│   ├── terraform.tfvars.example     # Example variables (copy to .tfvars)
│   └── docker-compose.yml           # Docker Compose alternative
│
├── 📁 scripts/                      # Automation Scripts
│   └── deploy.sh                    # Automated deployment script
│
└── 📁 references/                   # Documentation & Guides
    ├── README.md                    # Complete operations guide
    ├── QUICKSTART.md               # 30-second quick start
    ├── EXAMPLES.md                 # Real-world usage examples
    ├── TROUBLESHOOTING.md          # Problem-solving guide
    └── INDEX.md                    # This file
```

## 📖 File Descriptions

### Core Terraform Files

#### main.tf
**Purpose**: Main infrastructure resources

**Contains**:
- Docker provider configuration
- Docker image resource (Nginx)
- Docker network creation
- Docker volumes (config, logs)
- Docker container with:
  - Port mapping (8000)
  - Health checks
  - Resource limits
  - Logging configuration
  - Security labels
  - Restart policy

**Key Features**:
- Complete container lifecycle management
- Automatic network and volume creation
- Health check endpoint at `/health`
- Comprehensive logging setup

#### variables.tf
**Purpose**: Input variables and validation

**Contains**: 25+ variables including:
- Docker configuration (host, image)
- Container settings (name, restart policy)
- Resource limits (memory, CPU)
- Network configuration
- Logging settings
- Environment variables

**Key Features**:
- Input validation rules
- Default values
- Clear descriptions
- Type specifications

#### outputs.tf
**Purpose**: Output values and useful information

**Contains**: 20+ outputs:
- Container ID and status
- Network information
- Access URLs
- Convenient Docker commands
- Health check details
- Logging information

**Key Features**:
- Easy access to all important values
- Shell commands for common tasks
- Environment information summary

#### Makefile
**Purpose**: Convenient commands for common tasks

**Commands**:
```makefile
make init           # Initialize Terraform
make validate       # Validate configuration
make plan           # Plan changes
make apply          # Apply changes
make destroy        # Destroy resources
make logs           # View container logs
make shell          # Connect to container
```

**Key Features**:
- One-word operations
- Help documentation
- Combines related commands
- User-friendly output

### Template Files

#### templates/nginx.conf
**Purpose**: Production-grade Nginx configuration

**Features**:
- Worker process auto-tuning
- Gzip compression
- Security headers (X-Frame-Options, etc.)
- Health check endpoint (/health)
- Status endpoint (optional)
- Example reverse proxy blocks
- Example load balancing blocks

**Usage**:
1. Edit as needed
2. Place in volume mount
3. Redeploy with `terraform apply`

#### templates/terraform.tfvars.example
**Purpose**: Template for variable configuration

**Usage**:
```bash
cp templates/terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

**Contains**: Examples for:
- Development environment
- Production environment
- Staging environment
- Custom port configurations

#### templates/docker-compose.yml
**Purpose**: Alternative deployment method without Terraform

**Features**:
- Complete Docker Compose configuration
- Equivalent to Terraform setup
- Resource limits
- Health checks
- Network and volumes

**Usage**:
```bash
docker-compose -f templates/docker-compose.yml up -d
```

### Scripts

#### scripts/deploy.sh
**Purpose**: Automated deployment with validation

**Features**:
- Prerequisites checking
- Configuration setup
- Terraform initialization
- Validation and planning
- Interactive confirmation
- Deployment verification
- Helpful output

**Usage**:
```bash
cd scripts/
chmod +x deploy.sh
./deploy.sh deploy      # Deploy
./deploy.sh destroy     # Cleanup
./deploy.sh check       # Check prerequisites
```

### Reference Documentation

#### references/README.md
**Purpose**: Complete operations guide

**Sections**:
- Overview and quick start
- Configuration details
- Deployment scenarios
- Lifecycle management
- Monitoring and troubleshooting
- Performance tuning
- Customization options
- Security features
- Integration examples

**Best for**: Comprehensive understanding and operations

#### references/QUICKSTART.md
**Purpose**: Fast deployment guide

**Sections**:
- 30-second deployment
- Prerequisites
- Automation options
- Configuration
- Verification
- Cleanup

**Best for**: Getting started quickly

#### references/EXAMPLES.md
**Purpose**: Real-world usage patterns

**Sections**:
- Development setup
- Production configuration
- Staging environment
- Multiple instances
- Load balancing
- Reverse proxy setup
- Custom domains
- Monitoring setup
- SSL/TLS configuration
- Docker network integration
- CI/CD pipeline example

**Best for**: Implementation patterns and scenarios

#### references/TROUBLESHOOTING.md
**Purpose**: Problem diagnosis and solutions

**Sections**:
- Common errors with solutions
- Port already in use
- Docker daemon issues
- Container startup failures
- Permission problems
- Performance issues
- Health check failures
- Terraform errors
- Volume and network issues
- Debugging commands
- Recovery steps

**Best for**: Resolving issues quickly

#### references/INDEX.md
**Purpose**: Project structure and navigation

**Sections**:
- File organization
- File descriptions
- Variable reference
- Command reference
- Best practices
- Integration points

**Best for**: Understanding project structure

## 🔍 Variable Reference

### Docker Configuration
- `docker_host`: Docker daemon socket
- `nginx_image`: Container image name
- `nginx_version`: Image version/tag
- `keep_image_locally`: Retain image after destroy

### Network & Container
- `network_name`: Docker network name
- `container_name`: Container identifier
- `restart_policy`: Auto-restart behavior

### Port Configuration
- `external_port`: Port exposed to host (default: 8000)

### Resource Limits
- `container_memory`: Memory allocation
- `container_memory_swap`: Swap memory (-1 for unlimited)
- `container_cpu_shares`: CPU allocation

### Logging
- `log_driver`: Driver type (json-file, syslog, etc.)
- `log_max_size`: Maximum log file size
- `log_max_file`: Number of log files to retain

### Volumes & Environment
- `html_path`: Path to web content
- `timezone`: Container timezone
- `environment`: Environment name (dev/staging/prod)

See `variables.tf` for complete list with validation.

## 🎯 Command Reference

### Terraform
```bash
terraform init          # Initialize workspace
terraform validate      # Check configuration
terraform fmt           # Format code
terraform plan          # Preview changes
terraform apply         # Apply configuration
terraform destroy       # Destroy resources
terraform output        # Show outputs
terraform workspace     # Manage workspaces
```

### Make
```bash
make init              # Initialize
make plan              # Plan changes
make apply             # Apply changes
make destroy           # Destroy resources
make validate          # Validate configuration
make fmt               # Format files
make logs              # View container logs
make shell             # Connect to container
make status            # Show container status
```

### Docker
```bash
docker ps              # List containers
docker logs            # View logs
docker exec            # Execute command
docker stats           # Resource usage
docker inspect         # Get details
docker network         # Network operations
docker volume          # Volume operations
```

### Scripts
```bash
./scripts/deploy.sh deploy    # Deploy
./scripts/deploy.sh destroy   # Destroy
./scripts/deploy.sh check     # Check prerequisites
```

## 🔄 Workflow Guide

### First-Time Setup
1. Read `references/QUICKSTART.md`
2. Copy `templates/terraform.tfvars.example` → `terraform.tfvars`
3. Edit `terraform.tfvars`
4. Run `make init && make plan && make apply`

### Daily Operations
- View logs: `make logs`
- Connect to container: `make shell`
- Check status: `make status`
- Scale: `terraform apply -var="external_port=8001"`

### Troubleshooting
1. Check `references/TROUBLESHOOTING.md`
2. Run `docker logs nginx-webserver`
3. Run `make status` or `make inspect`
4. Run `terraform plan` to identify issues

### Updates
1. Edit `terraform.tfvars`
2. Run `terraform plan`
3. Review changes
4. Run `terraform apply`

## 🔗 Integration Points

### With Other Services
- Mount on custom Docker network
- Use as reverse proxy for backends
- Integrate with monitoring solutions
- Use in CI/CD pipelines

### Configuration Sources
- Variables from `terraform.tfvars`
- Nginx config from `templates/nginx.conf`
- Docker Compose from `templates/docker-compose.yml`
- Deployment script in `scripts/deploy.sh`

### External Systems
- Docker daemon
- Terraform state backend
- Container registries
- Monitoring/logging systems

## ✨ Best Practices

1. **Always validate**: `terraform validate` before apply
2. **Plan first**: Run `terraform plan` to review changes
3. **Version control**: Commit `main.tf`, `variables.tf`, `outputs.tf`
4. **Don't commit**: Exclude `terraform.tfvars`, `.terraform/`, `*.tfstate`
5. **Test changes**: Use dev environment first
6. **Monitor logs**: Regularly check `docker logs nginx-webserver`
7. **Document**: Keep `terraform.tfvars` commented
8. **Backup**: Version control your configuration

## 🚀 Quick Navigation

**Want to...**
- **Deploy quickly?** → `references/QUICKSTART.md`
- **Set up properly?** → `references/README.md`
- **See examples?** → `references/EXAMPLES.md`
- **Fix a problem?** → `references/TROUBLESHOOTING.md`
- **Understand structure?** → This file (INDEX.md)

## 📊 File Statistics

| Category | Files | Purpose |
|----------|-------|---------|
| Terraform | 3 | Core infrastructure |
| Configuration | 1 | Variables & defaults |
| Scripts | 1 | Automation |
| Templates | 3 | Configuration templates |
| Documentation | 5 | Guides and references |
| Total | 13 | Complete solution |

## 🎓 Learning Path

1. **Beginner**: Read QUICKSTART.md → Deploy with `make apply`
2. **Intermediate**: Read README.md → Explore examples in EXAMPLES.md
3. **Advanced**: Study main.tf → Customize configuration
4. **Expert**: Modify templates → Integrate with external systems

---

**Start here**: Choose your learning path above, or jump to `references/QUICKSTART.md` for immediate deployment.
