---
name: "Terrform"
description: "Expert skill for creating production-ready Docker Terraform templates that deploy Nginx web servers with port 8000 exposure"
tags: ["terraform", "docker", "nginx", "containerization", "infrastructure-as-code"]
version: "1.0.0"
---

# Terraform Docker Nginx Web Server Skill

## Overview

This skill provides expert guidance and implementation for creating Terraform configurations that deploy Nginx web servers using Docker containers. Specializes in exposing port 8000 and managing container infrastructure as code.

A complete, production-ready implementation with Terraform code, templates, scripts, and comprehensive documentation.

## 📁 Project Structure

```
terrform/
├── config/                          # Terraform configuration
│   ├── main.tf                      # Core Docker resources
│   ├── variables.tf                 # 25+ configuration variables
│   └── outputs.tf                   # 20+ deployment outputs
│
├── templates/                       # Configuration templates
│   ├── nginx.conf                   # Production Nginx configuration
│   ├── terraform.tfvars.example     # Example variables (copy to .tfvars)
│   └── docker-compose.yml           # Docker Compose alternative
│
├── scripts/                         # Automation scripts
│   └── deploy.sh                    # Automated deployment script
│
├── references/                      # Documentation & guides
│   ├── README.md                    # Complete operations guide
│   ├── QUICKSTART.md               # 30-second quick start
│   ├── EXAMPLES.md                 # Real-world usage examples
│   ├── TROUBLESHOOTING.md          # Problem-solving guide
│   └── INDEX.md                    # Project structure reference
│
├── Makefile                         # 15+ make commands
├── SKILL.md                         # Skill definition (this file)
└── README.md                        # Root documentation
```

## Core Competencies

### 1. Docker Container Management
- Creating optimized Nginx Docker images
- Managing container lifecycle with Terraform
- Port mapping and network configuration
- Volume management for configuration and logs
- Reference: [config/main.tf](config/main.tf)

### 2. Terraform Docker Provider
- `docker_image` resource management
- `docker_container` resource configuration
- Environment variable handling
- Network and port binding setup
- Reference: [config/variables.tf](config/variables.tf), [config/outputs.tf](config/outputs.tf)

### 3. Nginx Configuration
- Web server configuration best practices
- Port 8000 exposure and binding
- Server blocks and virtual hosts
- SSL/TLS support and configuration
- Template: [templates/nginx.conf](templates/nginx.conf)

### 4. Infrastructure Patterns
- High availability setups
- Load balancing configurations
- Monitoring and logging integration
- Auto-scaling policies
- Examples: [references/EXAMPLES.md](references/EXAMPLES.md)

## Key Capabilities

When invoked, this skill provides:

1. **Template Generation**: Complete, production-ready Terraform modules
   - Reference: [config/main.tf](config/main.tf), [config/variables.tf](config/variables.tf), [config/outputs.tf](config/outputs.tf)

2. **Port Configuration**: Automatic port 8000 binding with security
   - Default: 8000 (configurable in [templates/terraform.tfvars.example](templates/terraform.tfvars.example))

3. **Best Practices**: Terraform best practices with validation
   - Input validation in [config/variables.tf](config/variables.tf)
   - Security headers in [templates/nginx.conf](templates/nginx.conf)

4. **Validation & Planning**: Automated validation and planning
   - Commands in [Makefile](Makefile)
   - Script: [scripts/deploy.sh](scripts/deploy.sh)

5. **Configuration Management**: 25+ configurable variables
   - Complete list: [config/variables.tf](config/variables.tf)
   - Examples: [templates/terraform.tfvars.example](templates/terraform.tfvars.example)

6. **Troubleshooting**: Diagnostics and solutions for common issues
   - Guide: [references/TROUBLESHOOTING.md](references/TROUBLESHOOTING.md)

## Common Use Cases

- **Web Server Deployment**: Quick deployment of Nginx servers on Docker
  - Guide: [references/QUICKSTART.md](references/QUICKSTART.md)

- **Containerized Applications**: Serving containerized apps through Nginx
  - Example: [references/EXAMPLES.md#integration-with-reverse-proxy](references/EXAMPLES.md)

- **Development Environments**: Local and staging environment setup
  - Examples: [references/EXAMPLES.md#1-development-environment](references/EXAMPLES.md)

- **Microservices**: Nginx as API gateway or service mesh component
  - Example: [references/EXAMPLES.md#integration-with-reverse-proxy](references/EXAMPLES.md)

- **Testing**: Rapid provisioning for testing scenarios
  - Docker Compose: [templates/docker-compose.yml](templates/docker-compose.yml)

## Deployment Methods

### 1. Terraform (Recommended)
```bash
make init
make plan
make apply
```
Guide: [references/README.md](references/README.md)

### 2. Automated Script
```bash
./scripts/deploy.sh deploy
```
Script: [scripts/deploy.sh](scripts/deploy.sh)

### 3. Docker Compose
```bash
docker-compose -f templates/docker-compose.yml up -d
```
Template: [templates/docker-compose.yml](templates/docker-compose.yml)

### 4. Manual Make Commands
Guide: [Makefile](Makefile)

## Configuration Reference

All variables are configurable. Examples:

- **Port**: `external_port = 8000` ([templates/terraform.tfvars.example](templates/terraform.tfvars.example))
- **Memory**: `container_memory = 536870912` (512MB default)
- **Environment**: `environment = "production"` (dev/staging/prod)
- **Nginx Version**: `nginx_version = "1.25"`

Complete reference: [variables.tf](variables.tf)

## Resources & Outputs

The deployment generates 20+ outputs including:
- Container ID and status
- Network information
- Access URLs and port mappings
- Useful Docker commands
- Health check status

Full list: [outputs.tf](outputs.tf)

## Integration Points

- **Docker daemon**: Local or remote socket
- **Docker registries**: Docker Hub, private registries
- **Terraform state**: Local or remote backends
- **Monitoring**: Integration points for Prometheus, etc.
- **CI/CD**: GitHub Actions, GitLab CI, Jenkins, etc.
- **Load balancing**: Multiple instances with load balancer
- **Reverse proxy**: Backend service integration

Examples: [references/EXAMPLES.md](references/EXAMPLES.md)

## When to Use This Skill

Use when you need to:
- Deploy Nginx servers using Docker and Terraform
- Expose web services on port 8000
- Create infrastructure-as-code templates
- Automate container provisioning
- Standardize Nginx deployments across environments
- Set up development/staging/production environments
- Implement reverse proxy for backend services
- Create reproducible infrastructure

## Documentation Structure

| Document | Purpose | Audience |
|----------|---------|----------|
| [references/QUICKSTART.md](references/QUICKSTART.md) | 30-second deployment | Beginners |
| [references/README.md](references/README.md) | Complete operations guide | All users |
| [references/EXAMPLES.md](references/EXAMPLES.md) | Real-world patterns | Intermediate+ |
| [references/TROUBLESHOOTING.md](references/TROUBLESHOOTING.md) | Problem solving | All users |
| [references/INDEX.md](references/INDEX.md) | Project structure | Reference |

## Files Reference

### Core Terraform Files (in config/)
- [config/main.tf](config/main.tf) - Docker resources and container configuration
- [config/variables.tf](config/variables.tf) - 25+ input variables with validation
- [config/outputs.tf](config/outputs.tf) - 20+ output values
- [Makefile](Makefile) - 15+ make commands

### Templates (Customize as Needed)
- [templates/nginx.conf](templates/nginx.conf) - Nginx configuration
- [templates/terraform.tfvars.example](templates/terraform.tfvars.example) - Variable template
- [templates/docker-compose.yml](templates/docker-compose.yml) - Docker Compose alternative

### Automation
- [scripts/deploy.sh](scripts/deploy.sh) - Automated deployment script

### Documentation
- [references/README.md](references/README.md) - Complete operations guide
- [references/QUICKSTART.md](references/QUICKSTART.md) - Quick start guide
- [references/EXAMPLES.md](references/EXAMPLES.md) - Usage examples and patterns
- [references/TROUBLESHOOTING.md](references/TROUBLESHOOTING.md) - Problem solving
- [references/INDEX.md](references/INDEX.md) - Project structure guide

## Quick Start Commands

```bash
# Initialize
make init

# Preview
make plan

# Deploy
make apply

# Verify
curl http://localhost:8000

# View logs
make logs

# Cleanup
make destroy
```

Full guide: [references/QUICKSTART.md](references/QUICKSTART.md)

## Restrictions & Limitations

- Requires Docker daemon running or accessible
- Terraform must have Docker provider configured
- Port 8000 must be available on the host (configurable)
- Proper permissions required for Docker operations
- Linux/Mac: Docker group permissions needed

## Key Features

✅ **Production-Ready** - Health checks, logging, security  
✅ **Fully Documented** - 5 reference guides included  
✅ **Templates Included** - Nginx, Terraform, Docker Compose  
✅ **Automation Scripts** - deploy.sh for one-command setup  
✅ **Make Commands** - 15+ convenient commands  
✅ **Comprehensive** - 25+ variables, 20+ outputs  
✅ **Flexible** - Dev/staging/production configs  
✅ **Secure** - Security headers, resource limits  

## Support & Resources

- **Quick help**: See [references/QUICKSTART.md](references/QUICKSTART.md)
- **Full guide**: See [references/README.md](references/README.md)
- **Examples**: See [references/EXAMPLES.md](references/EXAMPLES.md)
- **Issues**: See [references/TROUBLESHOOTING.md](references/TROUBLESHOOTING.md)
- **Structure**: See [references/INDEX.md](references/INDEX.md)

---

**Ready to deploy?** Start with `make init && make plan && make apply`

For detailed guide, see [references/README.md](references/README.md)
