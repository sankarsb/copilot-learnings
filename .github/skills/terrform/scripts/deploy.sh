#!/bin/bash

# Terraform Docker Nginx Deployment Script
# Quick deployment script for setting up Nginx with Terraform

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_VERSION_MIN="1.0"
DOCKER_VERSION_MIN="20.0"

# Functions
print_header() {
    echo -e "${BLUE}===================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}===================================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

check_prerequisites() {
    print_header "Checking Prerequisites"
    
    # Check Terraform
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform is not installed"
        echo "Install from: https://www.terraform.io/downloads"
        exit 1
    fi
    print_success "Terraform found: $(terraform version -json | jq -r '.terraform_version')"
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed"
        echo "Install from: https://www.docker.com/products/docker-desktop"
        exit 1
    fi
    print_success "Docker found: $(docker --version)"
    
    # Check Docker daemon
    if ! docker info &> /dev/null; then
        print_error "Docker daemon is not running"
        echo "Start Docker Desktop or Docker service"
        exit 1
    fi
    print_success "Docker daemon is running"
}

setup_configuration() {
    print_header "Setting Up Configuration"
    
    if [ ! -f "$PROJECT_DIR/terraform.tfvars" ]; then
        if [ -f "$PROJECT_DIR/templates/terraform.tfvars.example" ]; then
            cp "$PROJECT_DIR/templates/terraform.tfvars.example" "$PROJECT_DIR/terraform.tfvars"
            print_success "Created terraform.tfvars from template"
            print_warning "Edit terraform.tfvars to customize settings"
        else
            print_error "terraform.tfvars.example not found in templates/"
            exit 1
        fi
    else
        print_success "terraform.tfvars already exists"
    fi
}

terraform_init() {
    print_header "Initializing Terraform"
    cd "$PROJECT_DIR/.."
    terraform init
    print_success "Terraform initialized"
}

terraform_validate() {
    print_header "Validating Configuration"
    cd "$PROJECT_DIR/.."
    terraform validate
    print_success "Configuration is valid"
}

terraform_plan() {
    print_header "Planning Deployment"
    cd "$PROJECT_DIR/.."
    terraform plan -out=tfplan
    print_success "Plan created (tfplan)"
}

terraform_apply() {
    print_header "Applying Configuration"
    cd "$PROJECT_DIR/.."
    terraform apply tfplan
    print_success "Deployment applied"
}

show_outputs() {
    print_header "Deployment Outputs"
    cd "$PROJECT_DIR/.."
    terraform output
}

verify_deployment() {
    print_header "Verifying Deployment"
    
    # Wait for container to start
    echo "Waiting for container to be ready..."
    sleep 5
    
    # Check container status
    if docker ps | grep -q nginx-webserver; then
        print_success "Container is running"
    else
        print_error "Container is not running"
        exit 1
    fi
    
    # Check health endpoint
    if curl -f http://localhost:8000/health &> /dev/null; then
        print_success "Health check passed"
    else
        print_warning "Health check not yet responding (may be starting up)"
    fi
    
    # Test Nginx
    if curl -s http://localhost:8000/ &> /dev/null; then
        print_success "Nginx is responding"
    else
        print_warning "Nginx not yet responding (may be starting up)"
    fi
}

cleanup() {
    rm -f tfplan
}

deploy() {
    check_prerequisites
    setup_configuration
    terraform_init
    terraform_validate
    terraform_plan
    
    echo ""
    print_warning "Review the plan above"
    read -p "Continue with deployment? (y/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        terraform_apply
        verify_deployment
        show_outputs
        cleanup
        
        print_header "Deployment Complete!"
        echo ""
        echo -e "${GREEN}Nginx is now available at:${NC}"
        echo -e "${BLUE}  http://localhost:8000${NC}"
        echo ""
        echo -e "${GREEN}Useful commands:${NC}"
        echo "  View logs:      docker logs -f nginx-webserver"
        echo "  Connect shell:  docker exec -it nginx-webserver /bin/bash"
        echo "  Destroy:        terraform destroy"
        echo ""
    else
        print_warning "Deployment cancelled"
        cleanup
        exit 0
    fi
}

destroy() {
    print_header "Destroying Deployment"
    
    read -p "Are you sure? This will destroy all resources (y/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd "$PROJECT_DIR/.."
        terraform destroy
        cleanup
        print_success "Deployment destroyed"
    else
        print_warning "Destroy cancelled"
    fi
}

show_usage() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  deploy      - Deploy Nginx (default)"
    echo "  destroy     - Destroy deployment"
    echo "  check       - Check prerequisites only"
    echo "  help        - Show this message"
}

# Main
case "${1:-deploy}" in
    deploy)
        deploy
        ;;
    destroy)
        destroy
        ;;
    check)
        check_prerequisites
        ;;
    help)
        show_usage
        ;;
    *)
        print_error "Unknown command: $1"
        show_usage
        exit 1
        ;;
esac
