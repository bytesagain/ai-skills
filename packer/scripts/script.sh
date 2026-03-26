#!/bin/bash
# Packer - Machine Image Builder Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              PACKER REFERENCE                               ║
║          Automated Machine Image Building                   ║
╚══════════════════════════════════════════════════════════════╝

Packer builds identical machine images for multiple platforms
from a single source configuration. Created by HashiCorp.

WHY PACKER:
  Immutable infra    Build once, deploy anywhere
  Multi-cloud        Same image for AWS, GCP, Azure, Docker
  CI/CD              Automated image pipeline
  Fast deploys       Pre-built = instant boot
  Testable           Test image before production

SUPPORTED BUILDERS:
  AWS         amazon-ebs, amazon-instance
  GCP         googlecompute
  Azure       azure-arm
  Docker      docker
  VMware      vmware-iso, vmware-vmx
  VirtualBox  virtualbox-iso
  QEMU        qemu
  Vagrant     vagrant
  Proxmox     proxmox-iso

WORKFLOW:
  1. Define template (HCL or JSON)
  2. packer init — download plugins
  3. packer validate — check syntax
  4. packer build — create image
     → Launches temp VM
     → Runs provisioners (shell, ansible)
     → Creates snapshot/AMI
     → Destroys temp VM

INSTALL:
  brew install packer               # macOS
  # Or download from packer.io
EOF
}

cmd_templates() {
cat << 'EOF'
HCL TEMPLATES
===============

AWS AMI:
  # aws-ubuntu.pkr.hcl
  packer {
    required_plugins {
      amazon = {
        version = ">= 1.3.0"
        source  = "github.com/hashicorp/amazon"
      }
    }
  }

  variable "region" {
    type    = string
    default = "us-east-1"
  }

  variable "instance_type" {
    type    = string
    default = "t3.micro"
  }

  source "amazon-ebs" "ubuntu" {
    ami_name      = "myapp-{{timestamp}}"
    instance_type = var.instance_type
    region        = var.region

    source_ami_filter {
      filters = {
        name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
        root-device-type    = "ebs"
        virtualization-type = "hvm"
      }
      most_recent = true
      owners      = ["099720109477"]  # Canonical
    }

    ssh_username = "ubuntu"

    tags = {
      Name    = "MyApp"
      Builder = "Packer"
    }
  }

  build {
    sources = ["source.amazon-ebs.ubuntu"]

    provisioner "shell" {
      inline = [
        "sudo apt-get update",
        "sudo apt-get install -y nginx docker.io",
        "sudo systemctl enable nginx docker",
      ]
    }

    provisioner "file" {
      source      = "config/nginx.conf"
      destination = "/tmp/nginx.conf"
    }

    provisioner "shell" {
      inline = [
        "sudo mv /tmp/nginx.conf /etc/nginx/nginx.conf",
        "sudo nginx -t",
      ]
    }

    provisioner "ansible" {
      playbook_file = "ansible/setup.yml"
    }

    post-processor "manifest" {
      output = "manifest.json"
    }
  }

DOCKER:
  source "docker" "ubuntu" {
    image  = "ubuntu:22.04"
    commit = true
  }

  build {
    sources = ["source.docker.ubuntu"]
    provisioner "shell" {
      inline = ["apt-get update && apt-get install -y nginx"]
    }
    post-processor "docker-tag" {
      repository = "myapp"
      tags       = ["latest", "1.0.0"]
    }
  }
EOF
}

cmd_commands() {
cat << 'EOF'
CLI & CI/CD
=============

COMMANDS:
  packer init .                      # Download plugins
  packer validate .                  # Validate templates
  packer fmt .                       # Format HCL files
  packer build .                     # Build all sources
  packer build -var 'region=eu-west-1' .  # Override variable
  packer build -var-file=prod.pkrvars.hcl .
  packer build -only=amazon-ebs.ubuntu .  # Build specific
  packer build -force .              # Force rebuild
  packer inspect .                   # Show template details

VARIABLES:
  # Variables file (prod.pkrvars.hcl)
  region        = "us-west-2"
  instance_type = "t3.large"

  # Environment variables
  export PKR_VAR_region="eu-west-1"

  # Command line
  packer build -var 'region=ap-southeast-1' .

CI/CD PIPELINE:
  # GitHub Actions
  - name: Packer Init
    run: packer init .

  - name: Packer Validate
    run: packer validate .

  - name: Packer Build
    run: packer build -color=false .
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_KEY }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET }}

GOLDEN IMAGE PIPELINE:
  1. Code change → trigger CI
  2. packer validate → syntax check
  3. packer build → create AMI
  4. Test AMI (launch, health check, destroy)
  5. Tag AMI as "approved"
  6. Update Terraform to use new AMI ID
  7. terraform apply → rolling deploy

MULTI-CLOUD:
  # Same provisioners, different builders
  build {
    sources = [
      "source.amazon-ebs.ubuntu",
      "source.googlecompute.ubuntu",
      "source.azure-arm.ubuntu",
    ]
    provisioner "shell" {
      inline = ["sudo apt install -y nginx"]
    }
  }

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Packer - Machine Image Builder Reference

Commands:
  intro      Overview, workflow, builders
  templates  AWS AMI, Docker, HCL syntax
  commands   CLI, variables, CI/CD, golden image

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)     cmd_intro ;;
  templates) cmd_templates ;;
  commands)  cmd_commands ;;
  help|*)    show_help ;;
esac
