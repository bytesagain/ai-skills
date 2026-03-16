---
version: "2.0.0"
name: terraform-helper
description: "Unknown: help. Use when you need terraform helper capabilities. Triggers on: terraform helper, provider, resource, name, region, no-vars."
author: BytesAgain
---

# terraform-helper

Generate production-ready Terraform (HCL) configurations for AWS, GCP, and Azure cloud resources. Supports VPC networking, compute instances, databases, storage, IAM, Kubernetes clusters, load balancers, DNS, and CDN. Generates modular configurations with variables, outputs, state management, and follows HashiCorp best practices for code organization, naming conventions, and security hardening.

## Commands

| Command | Description |
|---------|-------------|
| `resource` | Generate a Terraform resource configuration |
| `module` | Create a reusable Terraform module |
| `vpc` | Generate VPC/networking configuration |
| `compute` | Generate compute instance (EC2/GCE/VM) config |
| `database` | Generate managed database (RDS/CloudSQL/Azure SQL) config |
| `storage` | Generate storage (S3/GCS/Blob) configuration |
| `iam` | Generate IAM roles, policies, and permissions |
| `k8s` | Generate managed Kubernetes cluster config |
| `backend` | Generate remote state backend configuration |
| `variables` | Generate variables.tf and terraform.tfvars templates |

## Usage

```
# Generate AWS VPC with subnets
terraform-helper vpc --provider aws --cidr "10.0.0.0/16" --azs 3

# Generate EC2 instance
terraform-helper compute --provider aws --type t3.medium --ami ubuntu

# Generate RDS PostgreSQL
terraform-helper database --provider aws --engine postgres --version 15 --size db.t3.medium

# Generate S3 bucket with versioning
terraform-helper storage --provider aws --versioning --encryption

# Generate IAM role for ECS
terraform-helper iam --provider aws --service ecs --policy readonly

# Generate EKS cluster
terraform-helper k8s --provider aws --version 1.28 --nodes 3

# Generate reusable module
terraform-helper module --name "web-app" --resources "ec2,rds,alb"

# Generate backend config
terraform-helper backend --provider aws --bucket my-tf-state
```

## Examples

### AWS Full Stack
```
terraform-helper vpc --provider aws --cidr "10.0.0.0/16"
terraform-helper compute --provider aws --type t3.medium
terraform-helper database --provider aws --engine postgres
```

### GCP Kubernetes Setup
```
terraform-helper k8s --provider gcp --version 1.28 --nodes 5
```

### Azure Web App
```
terraform-helper compute --provider azure --type Standard_B2s
terraform-helper database --provider azure --engine postgres
```

## Features

- **Multi-cloud** — AWS, GCP, and Azure support
- **Modular design** — Reusable modules with clear interfaces
- **State management** — Remote backend configurations
- **Security** — IAM least-privilege, encryption, network isolation
- **Variables** — Parameterized configs with sensible defaults
- **Outputs** — Useful output values for cross-module references
- **Best practices** — HashiCorp recommended patterns

## Keywords

terraform, infrastructure as code, iac, aws, gcp, azure, cloud, hcl, devops, provisioning, infrastructure, modules
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
