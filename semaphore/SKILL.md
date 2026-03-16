---
name: Semaphore
description: "Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt, PowerShell and other DevOps t Based on semaphoreui/semaphore (13,331+ GitHub stars). semaphore, go, ansible, awx, ci, cicd, devops"
version: "2.0.0"
license: MIT
runtime: python3
---

# Semaphore

Modern UI and powerful API for Ansible, Terraform/OpenTofu/Terragrunt, PowerShell and other DevOps tools.

Inspired by [semaphoreui/semaphore]([configured-endpoint]) (13,331+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from semaphoreui/semaphore

## Usage

Run any command: `semaphore <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
semaphore help
semaphore run
```

## When to Use

- to automate semaphore tasks in your workflow
- for batch processing semaphore operations

## Output

Returns reports to stdout. Redirect to a file with `semaphore run > output.txt`.

## Configuration

Set `SEMAPHORE_DIR` environment variable to change the data directory. Default: `~/.local/share/semaphore/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
