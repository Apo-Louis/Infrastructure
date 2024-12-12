# Infrastructure Repository

This repository contains the complete Infrastructure as Code (IaC) for deploying and managing a secure, scalable WordPress platform on AWS EKS using Terraform, Helm, and GitOps principles.

## Architecture Overview

The infrastructure is built around several key components:

- AWS EKS Cluster with managed node groups
- VPC with public and private subnets across multiple AZs
- Kubernetes components including:
  - ArgoCD for GitOps deployments
  - Cert-Manager for SSL/TLS automation
  - NGINX Ingress Controller
  - Prometheus & Grafana for monitoring
  - Velero for backups
  - GateKeeper & KubeArmor for security

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0.0
- Kubectl >= 1.25
- Helm >= 3.0.0
- Docker (for local development)

## Repository Structure

```
.
├── modules/                    # Terraform modules
│   ├── argocd/                # ArgoCD deployment
│   ├── autoscaler/            # Cluster autoscaling
│   ├── cert-manager/          # Certificate management
│   ├── eks/                   # EKS cluster configuration
│   ├── gatekeeper/            # Security policies
│   ├── kubearmor/            # Runtime security
│   ├── metrics-server/        # Kubernetes metrics
│   ├── monitoring/           # Prometheus & Grafana
│   ├── nginx-ingress/        # Ingress controller
│   ├── velero/               # Backup solution
│   └── vpc_and_subnets/      # Network infrastructure
├── environments/              # Environment-specific configurations
├── charts/                    # Helm charts for WordPress
└── scripts/                   # Utility scripts
```

## Quick Start

1. Clone the repository:
```bash
git clone https://github.com/your-org/infrastructure.git
cd infrastructure
```

2. Create a terraform.tfvars file with your configuration:
```hcl
region = "eu-west-3"
environment = "staging"
cluster_prefix = "wp"
vpc_name = "wordpress"
eks_cluster_name = "wordpress"
k8s_version = "1.31"
```

3. Initialize and apply Terraform:
```bash
terraform init
terraform plan
terraform apply
```

## Modules

### VPC and Subnets
Creates a VPC with:
- Public and private subnets across 2 AZs
- NAT Gateways
- Internet Gateway
- Appropriate routing tables

### EKS
Deploys an EKS cluster with:
- Managed node groups
- EFS storage configuration
- IAM roles and policies
- Kubernetes add-ons

### ArgoCD
Sets up GitOps with:
- ArgoCD deployment
- Application configurations
- Repository credentials
- DNS configuration via OVH

### Cert-Manager
Manages SSL/TLS certificates:
- Let's Encrypt integration
- OVH DNS validation
- Automatic certificate renewal

### Monitoring
Deploys monitoring stack:
- Prometheus for metrics collection
- Grafana for visualization
- Custom dashboards
- Alert configurations

## Security Features

The infrastructure includes several security measures:

1. Network Security:
   - Private subnets for worker nodes
   - Security groups for EKS and EFS
   - Network policies

2. Pod Security:
   - GateKeeper policies
   - KubeArmor runtime protection
   - Resource quotas

3. Access Control:
   - RBAC configuration
   - IAM integration
   - Service accounts

## Backup and Disaster Recovery

Velero is configured for:
- Regular scheduled backups
- Point-in-time recovery
- Cross-region backup storage
- Selective restore capabilities

## Environment Configuration

The infrastructure supports multiple environments:

### Development
```hcl
workers_config = {
  instance_types = ["t3.large"]
  capacity_type  = "SPOT"
  desired_size   = 2
  min_size      = 2
  max_size      = 4
}
```

### Production
```hcl
workers_config = {
  instance_types = ["t3.large"]
  capacity_type  = "ON_DEMAND"
  desired_size   = 4
  min_size      = 4
  max_size      = 8
}
```

## Monitoring and Alerts

The monitoring stack provides:
- WordPress performance metrics
- Database monitoring
- Infrastructure metrics
- Custom Grafana dashboards
- Alert configurations

## License

This project is licensed under the MIT License - see the LICENSE file for details.
