---
version: "2.0.0"
name: deploy-helper
description: "One-command deployment assistant. Generate Dockerfiles, docker-compose configs, Nginx configs, CI/CD pipelines, Vercel/Netlify configs, Kubernetes manifests."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# 🚀 Deploy Helper

> From local to production — deployment configs generated in seconds.

## Usage

```bash
bash scripts/deploy.sh <command> <project_type> [options]
```

Where `project_type` is one of: `node`, `python`, `go`, `java`, `static`

## Commands

### Containers
- `docker <type>` — Multi-stage Dockerfile with security best practices
- `compose <type>` — docker-compose.yml with common middleware

### Web Server
- `nginx <type>` — Nginx config (reverse proxy / SPA / static site)
- `ssl <domain>` — SSL/Let's Encrypt certificate config

### CI/CD
- `ci <platform>` — CI/CD pipeline (`github` / `gitlab` / `jenkins`)

### Serverless
- `vercel <type>` — vercel.json configuration
- `netlify <type>` — netlify.toml configuration

### Orchestration
- `k8s <type>` — Kubernetes Deployment + Service + Ingress YAML

## Choosing a Deploy Path

```
Side project  → Vercel / Netlify (zero config)
Small team    → Docker Compose + Nginx
Production    → K8s + CI/CD + SSL
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
