# Quick Start Guide

## 🚀 30-Second Deployment

```bash
# 1. Initialize
make init

# 2. Preview
make plan

# 3. Deploy
make apply

# 4. Access
curl http://localhost:8000
```

## 📋 Prerequisites

- Terraform >= 1.0
- Docker daemon running
- Port 8000 available

## 🔧 Using Automation Script

```bash
cd scripts/
chmod +x deploy.sh
./deploy.sh deploy
```

## 🐳 Using Docker Compose

```bash
docker-compose -f templates/docker-compose.yml up -d
```

## 📝 Configuration

Edit variables before deployment:

```bash
cp templates/terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your settings
make init
make apply
```

## ✅ Verify Deployment

```bash
# Check container
docker ps | grep nginx

# Test endpoint
curl http://localhost:8000

# View logs
make logs
```

## 🧹 Cleanup

```bash
make destroy
```

## 📚 More Information

- Full guide: See `references/README.md`
- Examples: See `references/EXAMPLES.md`
- Troubleshooting: See `references/TROUBLESHOOTING.md`
- Project structure: See `references/INDEX.md`
