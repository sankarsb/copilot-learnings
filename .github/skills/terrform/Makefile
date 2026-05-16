.PHONY: help init validate plan apply destroy fmt logs shell status clean

help:
	@echo "Terraform Docker Nginx Deployment"
	@echo "===================================="
	@echo ""
	@echo "Available commands:"
	@echo "  make init       - Initialize Terraform workspace"
	@echo "  make validate   - Validate Terraform configuration"
	@echo "  make fmt        - Format Terraform files"
	@echo "  make plan       - Plan infrastructure changes"
	@echo "  make apply      - Apply Terraform configuration"
	@echo "  make destroy    - Destroy Terraform resources"
	@echo "  make output     - Show Terraform outputs"
	@echo "  make logs       - View container logs"
	@echo "  make shell      - Connect to container shell"
	@echo "  make status     - Show container status"
	@echo "  make inspect    - Inspect Docker resources"
	@echo "  make clean      - Clean temporary files"
	@echo "  make help       - Show this help message"

init:
	@echo "Initializing Terraform..."
	terraform init

validate:
	@echo "Validating Terraform configuration..."
	terraform validate

fmt:
	@echo "Formatting Terraform files..."
	terraform fmt -recursive

plan:
	@echo "Planning infrastructure changes..."
	terraform plan -out=tfplan

apply:
	@echo "Applying Terraform configuration..."
	terraform apply

destroy:
	@echo "Destroying Terraform resources..."
	terraform destroy

output:
	@echo "Terraform outputs:"
	terraform output

logs:
	@echo "Tailing container logs..."
	docker logs -f nginx-webserver

shell:
	@echo "Connecting to container shell..."
	docker exec -it nginx-webserver /bin/bash

status:
	@echo "Container status:"
	docker ps -a | grep nginx

inspect:
	@echo "Docker network:"
	docker network inspect nginx-network
	@echo ""
	@echo "Container details:"
	docker inspect nginx-webserver

stats:
	@echo "Container resource usage:"
	docker stats nginx-webserver

test-nginx:
	@echo "Testing Nginx configuration..."
	docker exec nginx-webserver nginx -t

reload-nginx:
	@echo "Reloading Nginx configuration..."
	docker exec nginx-webserver nginx -s reload

clean:
	@echo "Cleaning temporary files..."
	rm -f tfplan *.tfplan crash.log crash.*.log

health:
	@echo "Checking health endpoint..."
	curl -i http://localhost:8000/health

verify: validate plan
	@echo "Configuration verified!"

full-deploy: clean init validate plan apply output
	@echo "Deployment complete!"

full-destroy: destroy clean
	@echo "Cleanup complete!"
