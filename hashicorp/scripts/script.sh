#!/bin/bash
# HashiCorp - Infrastructure Automation Suite Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              HASHICORP REFERENCE                            ║
║          Infrastructure Automation Suite                    ║
╚══════════════════════════════════════════════════════════════╝

HashiCorp builds the standard tools for cloud infrastructure
automation. Their products cover the full lifecycle: provision,
secure, connect, and run.

THE HASHICORP STACK:
  ┌──────────────┬──────────────────────────────────────┐
  │ Product      │ Purpose                              │
  ├──────────────┼──────────────────────────────────────┤
  │ Terraform    │ Infrastructure as Code (IaC)         │
  │ Vault        │ Secrets management & encryption      │
  │ Consul       │ Service mesh & discovery             │
  │ Nomad        │ Workload orchestration               │
  │ Packer       │ Machine image building               │
  │ Vagrant      │ Development environments             │
  │ Boundary     │ Zero-trust remote access             │
  │ Waypoint     │ Application deployment               │
  └──────────────┴──────────────────────────────────────┘

LICENSING:
  Pre-2023    All products were MPL-2.0 (open-source)
  2023+       Core products changed to BSL 1.1
  OpenTofu    Community fork of Terraform (MPL-2.0)

  BSL products: Terraform, Vault, Consul, Nomad, Boundary, Waypoint
  Still MPL: Vagrant, Packer, Serf

HCL (HashiCorp Configuration Language):
  All HashiCorp tools use HCL — a declarative configuration
  language that's human-readable and machine-friendly.
  
  resource "type" "name" {
    attribute = "value"
    nested_block {
      key = "value"
    }
  }
EOF
}

cmd_terraform() {
cat << 'EOF'
TERRAFORM
===========

WORKFLOW:
  terraform init       Download providers
  terraform plan       Preview changes
  terraform apply      Create/update infrastructure
  terraform destroy    Tear down everything

BASIC CONFIG:
  # main.tf
  terraform {
    required_providers {
      aws = { source = "hashicorp/aws", version = "~> 5.0" }
    }
    backend "s3" {
      bucket = "my-terraform-state"
      key    = "prod/terraform.tfstate"
      region = "us-east-1"
    }
  }

  provider "aws" { region = "us-east-1" }

  resource "aws_instance" "web" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t3.micro"
    tags = { Name = "web-server" }
  }

  resource "aws_s3_bucket" "data" {
    bucket = "my-data-bucket"
  }

  output "instance_ip" {
    value = aws_instance.web.public_ip
  }

VARIABLES:
  # variables.tf
  variable "environment" {
    type    = string
    default = "dev"
  }
  variable "instance_count" {
    type = number
  }

  # terraform.tfvars
  environment    = "prod"
  instance_count = 3

MODULES:
  module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "5.0.0"
    cidr    = "10.0.0.0/16"
  }

STATE:
  terraform state list
  terraform state show aws_instance.web
  terraform state mv aws_instance.old aws_instance.new
  terraform import aws_instance.web i-1234567890abcdef0

OPENTOFU (open-source fork):
  # Drop-in replacement, same commands
  tofu init && tofu plan && tofu apply
EOF
}

cmd_vault_consul() {
cat << 'EOF'
VAULT & CONSUL
================

VAULT (secrets management):
  vault server -dev           # Dev mode

  # KV secrets
  vault kv put secret/db password=s3cret host=db.example.com
  vault kv get secret/db
  vault kv get -field=password secret/db

  # Dynamic secrets (auto-rotating)
  vault write database/config/mydb \
    plugin_name=mysql-database-plugin \
    connection_url="{{username}}:{{password}}@tcp(db:3306)/"
  vault read database/creds/readonly
  # Returns: temporary username + password (auto-revoked)

  # Transit (encryption as a service)
  vault write transit/encrypt/mykey plaintext=$(echo "secret" | base64)
  vault write transit/decrypt/mykey ciphertext=vault:v1:abc...

  # PKI (certificate authority)
  vault write pki/issue/my-role common_name="app.example.com"

  # Auth methods
  vault auth enable userpass
  vault auth enable kubernetes
  vault auth enable aws

  # Policies
  vault policy write dev - << EOF
  path "secret/data/dev/*" { capabilities = ["read"] }
  path "database/creds/dev-readonly" { capabilities = ["read"] }
  EOF

CONSUL (service mesh & discovery):
  consul agent -dev            # Dev mode

  # Service registration
  consul services register - << EOF
  {
    "Name": "web",
    "Port": 8080,
    "Check": {"HTTP": "http://localhost:8080/health", "Interval": "10s"}
  }
  EOF

  # Service discovery
  consul catalog services
  dig @127.0.0.1 -p 8600 web.service.consul
  curl http://localhost:8500/v1/health/service/web?passing

  # KV store
  consul kv put config/db/host "db.example.com"
  consul kv get config/db/host

  # Connect (service mesh)
  # Automatic mTLS between services
  # Intentions (allow/deny service-to-service)
  consul intention create web api     # Allow web→api
  consul intention create -deny web db  # Deny web→db

PACKER (machine images):
  packer build template.pkr.hcl

  # template.pkr.hcl
  source "amazon-ebs" "ubuntu" {
    ami_name      = "my-app-{{timestamp}}"
    instance_type = "t3.micro"
    region        = "us-east-1"
    source_ami_filter {
      filters = { name = "ubuntu/images/*22.04*" }
      owners  = ["099720109477"]
    }
    ssh_username = "ubuntu"
  }

  build {
    sources = ["source.amazon-ebs.ubuntu"]
    provisioner "shell" {
      inline = ["sudo apt update", "sudo apt install -y nginx"]
    }
  }

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
HashiCorp - Infrastructure Automation Suite Reference

Commands:
  intro         Stack overview, HCL, licensing
  terraform     IaC workflow, modules, state, OpenTofu
  vault_consul  Vault secrets, Consul mesh, Packer images

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)        cmd_intro ;;
  terraform)    cmd_terraform ;;
  vault_consul) cmd_vault_consul ;;
  help|*)       show_help ;;
esac
