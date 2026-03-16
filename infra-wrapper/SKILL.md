---
version: "2.0.0"
name: Terragrunt
description: "Terragrunt is a flexible orchestration tool that allows Infrastructure as Code written in OpenTofu/T terraform-wrapper, go, aws, cli, developer-tools, devops, opentofu. Use when you need terraform-wrapper capabilities. Triggers on: terraform-wrapper."
---

# Terragrunt

Terragrunt is a flexible orchestration tool that allows Infrastructure as Code written in OpenTofu/Terraform to scale. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from gruntwork-io/terraform-wrapper

## Usage

Run any command: `terraform-wrapper <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
infra-wrapper help
infra-wrapper run
```

## When to Use

- for batch processing wrapper operations
- as part of a larger automation pipeline

## Output

Returns structured data to stdout. Redirect to a file with `infra-wrapper run > output.txt`.
