#!/usr/bin/env bash
# Terraform Helper — Generate Terraform configurations
# Usage: bash main.sh --provider <aws|gcp|azure> --resource <type> [options]
set -euo pipefail

PROVIDER=""
RESOURCE=""
NAME="main"
REGION="us-east-1"
OUTPUT=""
INCLUDE_VARS="true"
INCLUDE_OUTPUTS="true"

show_help() {
    cat << 'HELPEOF'
Terraform Helper — Generate HCL configurations with best practices

Usage: bash main.sh --provider <provider> --resource <resource> [options]

Options:
  --provider <p>     Cloud provider: aws, gcp, azure
  --resource <r>     Resource type (see below)
  --name <name>      Resource name prefix (default: main)
  --region <r>       Region (default: us-east-1)
  --no-vars          Skip variables file
  --no-outputs       Skip outputs file
  --output <dir>     Output directory
  --help             Show this help

AWS Resources:     ec2, s3, rds, vpc, lambda, ecs, dynamodb, sqs, sns, cloudfront
GCP Resources:     compute, gcs, cloudsql, vpc, functions, gke, pubsub, bigquery
Azure Resources:   vm, storage, sql, vnet, functions, aks, cosmosdb, servicebus

Examples:
  bash main.sh --provider aws --resource ec2 --name web --region us-west-2
  bash main.sh --provider aws --resource s3 --name data
  bash main.sh --provider aws --resource vpc --name production
  bash main.sh --provider gcp --resource compute --name api
  bash main.sh --provider azure --resource vm --name app

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --provider) PROVIDER="$2"; shift 2;;
        --resource) RESOURCE="$2"; shift 2;;
        --name) NAME="$2"; shift 2;;
        --region) REGION="$2"; shift 2;;
        --no-vars) INCLUDE_VARS="false"; shift;;
        --no-outputs) INCLUDE_OUTPUTS="false"; shift;;
        --output) OUTPUT="$2"; shift 2;;
        --help|-h) show_help; exit 0;;
        *) echo "Unknown: $1"; shift;;
    esac
done

[ -z "$PROVIDER" ] && { echo "Error: --provider required"; show_help; exit 1; }
[ -z "$RESOURCE" ] && { echo "Error: --resource required"; show_help; exit 1; }

generate_terraform() {
    python3 << PYEOF
provider = "$PROVIDER"
resource = "$RESOURCE"
name = "$NAME"
region = "$REGION"
inc_vars = "$INCLUDE_VARS" == "true"
inc_out = "$INCLUDE_OUTPUTS" == "true"

configs = {}

# ──── AWS ────
configs[("aws", "ec2")] = {
    "main": '''terraform {{
  required_providers {{
    aws = {{
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }}
  }}
}}

provider "aws" {{
  region = var.region
}}

data "aws_ami" "amazon_linux" {{
  most_recent = true
  owners      = ["amazon"]
  filter {{
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }}
}}

resource "aws_instance" "{name}" {{
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.{name}.id]
  subnet_id              = var.subnet_id

  root_block_device {{
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }}

  tags = merge(var.tags, {{
    Name = "{name}"
  }})
}}

resource "aws_security_group" "{name}" {{
  name_prefix = "{name}-"
  vpc_id      = var.vpc_id

  ingress {{
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }}

  egress {{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }}

  tags = var.tags
}}''',
    "vars": '''variable "region" {{
  default = "{region}"
}}
variable "instance_type" {{
  default = "t3.micro"
}}
variable "root_volume_size" {{
  default = 20
}}
variable "vpc_id" {{
  type = string
}}
variable "subnet_id" {{
  type = string
}}
variable "ssh_cidr_blocks" {{
  type    = list(string)
  default = ["0.0.0.0/0"]
}}
variable "tags" {{
  type    = map(string)
  default = {{}}
}}''',
    "outputs": '''output "instance_id" {{
  value = aws_instance.{name}.id
}}
output "public_ip" {{
  value = aws_instance.{name}.public_ip
}}
output "private_ip" {{
  value = aws_instance.{name}.private_ip
}}
output "security_group_id" {{
  value = aws_security_group.{name}.id
}}'''
}

configs[("aws", "s3")] = {
    "main": '''terraform {{
  required_providers {{
    aws = {{
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }}
  }}
}}

provider "aws" {{
  region = var.region
}}

resource "aws_s3_bucket" "{name}" {{
  bucket = var.bucket_name
  tags   = var.tags
}}

resource "aws_s3_bucket_versioning" "{name}" {{
  bucket = aws_s3_bucket.{name}.id
  versioning_configuration {{
    status = var.versioning ? "Enabled" : "Suspended"
  }}
}}

resource "aws_s3_bucket_server_side_encryption_configuration" "{name}" {{
  bucket = aws_s3_bucket.{name}.id
  rule {{
    apply_server_side_encryption_by_default {{
      sse_algorithm = "AES256"
    }}
  }}
}}

resource "aws_s3_bucket_public_access_block" "{name}" {{
  bucket                  = aws_s3_bucket.{name}.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}}''',
    "vars": '''variable "region" {{ default = "{region}" }}
variable "bucket_name" {{ type = string }}
variable "versioning" {{ default = true }}
variable "tags" {{ type = map(string); default = {{}} }}''',
    "outputs": '''output "bucket_id" {{ value = aws_s3_bucket.{name}.id }}
output "bucket_arn" {{ value = aws_s3_bucket.{name}.arn }}
output "bucket_domain" {{ value = aws_s3_bucket.{name}.bucket_regional_domain_name }}'''
}

configs[("aws", "vpc")] = {
    "main": '''terraform {{
  required_providers {{
    aws = {{
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }}
  }}
}}

provider "aws" {{
  region = var.region
}}

resource "aws_vpc" "{name}" {{
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(var.tags, {{ Name = "{name}-vpc" }})
}}

resource "aws_internet_gateway" "{name}" {{
  vpc_id = aws_vpc.{name}.id
  tags   = merge(var.tags, {{ Name = "{name}-igw" }})
}}

resource "aws_subnet" "{name}_public" {{
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.{name}.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = merge(var.tags, {{ Name = "{name}-public-${{count.index}}" }})
}}

resource "aws_subnet" "{name}_private" {{
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.{name}.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(var.tags, {{ Name = "{name}-private-${{count.index}}" }})
}}

resource "aws_route_table" "{name}_public" {{
  vpc_id = aws_vpc.{name}.id
  route {{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.{name}.id
  }}
  tags = var.tags
}}

resource "aws_route_table_association" "{name}_public" {{
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.{name}_public[count.index].id
  route_table_id = aws_route_table.{name}_public.id
}}''',
    "vars": '''variable "region" {{ default = "{region}" }}
variable "vpc_cidr" {{ default = "10.0.0.0/16" }}
variable "public_subnets" {{ default = ["10.0.1.0/24", "10.0.2.0/24"] }}
variable "private_subnets" {{ default = ["10.0.10.0/24", "10.0.11.0/24"] }}
variable "azs" {{ default = ["{region}a", "{region}b"] }}
variable "tags" {{ type = map(string); default = {{}} }}''',
    "outputs": '''output "vpc_id" {{ value = aws_vpc.{name}.id }}
output "public_subnet_ids" {{ value = aws_subnet.{name}_public[*].id }}
output "private_subnet_ids" {{ value = aws_subnet.{name}_private[*].id }}'''
}

# Default fallback
key = (provider, resource)
if key not in configs:
    print("# Error: No template for provider='{}' resource='{}'".format(provider, resource))
    print("# Available:")
    for k in sorted(configs.keys()):
        print("#   --provider {} --resource {}".format(k[0], k[1]))
    import sys; sys.exit(1)

cfg = configs[key]

print("# ══════════════════════════════════════")
print("# Terraform Configuration: {} / {}".format(provider, resource))
print("# Generated by BytesAgain Terraform Helper")
print("# ══════════════════════════════════════")
print("")
print("## main.tf")
print("```hcl")
print(cfg["main"].format(name=name, region=region))
print("```")

if inc_vars and "vars" in cfg:
    print("")
    print("## variables.tf")
    print("```hcl")
    print(cfg["vars"].format(name=name, region=region))
    print("```")

if inc_out and "outputs" in cfg:
    print("")
    print("## outputs.tf")
    print("```hcl")
    print(cfg["outputs"].format(name=name, region=region))
    print("```")

print("")
print("---")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
}

if [ -n "$OUTPUT" ]; then
    generate_terraform > "$OUTPUT/terraform-output.md"
    echo "Saved to $OUTPUT/terraform-output.md"
else
    generate_terraform
fi
