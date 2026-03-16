---
version: "2.0.0"
name: github-actions-gen
description: "Unknown: help. Use when you need github actions gen capabilities. Triggers on: github actions gen, type, lang, deploy, matrix, no-cache."
author: BytesAgain
---

# github-actions-gen

Generate production-ready GitHub Actions CI/CD workflow files for any project type. Supports Node.js, Python, Docker, Terraform, Go, and Rust with matrix builds, dependency caching, artifact management, deployment pipelines, environment secrets, and reusable workflows. Create complete .github/workflows/ YAML configurations with best practices for testing, building, linting, and deploying applications.

## Commands

| Command | Description |
|---------|-------------|
| `ci` | Generate a CI workflow (test, lint, build) |
| `cd` | Generate a CD workflow (deploy to various targets) |
| `docker` | Generate Docker build and push workflow |
| `terraform` | Generate Terraform plan/apply workflow |
| `matrix` | Generate a matrix build workflow |
| `release` | Generate a release/publish workflow |
| `cron` | Generate a scheduled workflow |
| `reusable` | Generate a reusable workflow template |

## Usage

```
# Generate CI workflow for Node.js
github-actions-gen ci --lang node --version "18,20,22"

# Generate CD workflow deploying to AWS
github-actions-gen cd --target aws --service ecs

# Docker build and push to GHCR
github-actions-gen docker --registry ghcr --platforms "linux/amd64,linux/arm64"

# Terraform workflow with plan on PR, apply on merge
github-actions-gen terraform --provider aws --workspace production

# Matrix build for Python
github-actions-gen matrix --lang python --versions "3.10,3.11,3.12" --os "ubuntu,macos"

# Release workflow with changelog
github-actions-gen release --lang node --registry npm

# Scheduled workflow
github-actions-gen cron --schedule "0 2 * * 1" --job "cleanup"
```

## Examples

### Node.js CI with Tests and Coverage
```
github-actions-gen ci --lang node --version 20 --coverage --lint
```

### Python CI/CD Pipeline
```
github-actions-gen ci --lang python --version "3.11,3.12" --test pytest --lint ruff
```

### Multi-platform Docker Build
```
github-actions-gen docker --registry ghcr --platforms "linux/amd64,linux/arm64" --cache
```

## Features

- **Matrix builds** — Test across multiple versions and OS combinations
- **Dependency caching** — npm, pip, go modules, cargo caching
- **Docker builds** — Multi-platform builds with layer caching
- **Terraform** — Plan on PR, apply on merge workflows
- **Releases** — Automated versioning and publishing
- **Reusable workflows** — DRY workflow templates
- **Security** — Minimal permissions, secret management

## Keywords

github actions, ci/cd, workflow, pipeline, continuous integration, continuous deployment, devops, automation, testing, deployment
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
