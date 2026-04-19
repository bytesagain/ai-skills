---
description: "Generate CI/CD pipeline configs for GitHub Actions, GitLab CI, and Jenkins. Use when setting up Node.js, Python, Go, or Docker pipelines, configuring rollback strategies, or adding deployment automation."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# bytesagain-ci-cd-pipeline

Generate production-ready CI/CD pipeline configurations for GitHub Actions, GitLab CI, and Jenkins. Supports Node.js, Python, Go, Docker, and Kubernetes stacks with rollback strategies and pre-deploy checklists.

## Usage

```
bytesagain-ci-cd-pipeline github <stack>
bytesagain-ci-cd-pipeline gitlab <stack>
bytesagain-ci-cd-pipeline jenkins
bytesagain-ci-cd-pipeline checklist
bytesagain-ci-cd-pipeline rollback <type>
```

## Commands

- `github` — Generate GitHub Actions workflow YAML (node/python/go/docker/k8s)
- `gitlab` — Generate GitLab CI configuration file
- `jenkins` — Generate declarative Jenkinsfile with stages and approvals
- `checklist` — Print pre-deployment checklist covering code, config, infra, comms
- `rollback` — Show rollback strategy (blue-green/canary/rolling)

## Examples

```bash
bytesagain-ci-cd-pipeline github node
bytesagain-ci-cd-pipeline github docker
bytesagain-ci-cd-pipeline gitlab python
bytesagain-ci-cd-pipeline jenkins
bytesagain-ci-cd-pipeline checklist
bytesagain-ci-cd-pipeline rollback blue-green
bytesagain-ci-cd-pipeline rollback canary
```

## Requirements

- bash
- python3

## When to Use

Use when setting up a new project pipeline, onboarding to a CI platform, reviewing deployment safety, or planning rollback procedures for production releases.
