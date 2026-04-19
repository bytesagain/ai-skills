---
name: "vercel-tool"
description: "Generate Vercel API commands for deployment management. Use when checking deployment status, viewing build logs, inspecting domain SSL, listing recent deployments, rolling back, or auditing environment variables. No credentials stored — commands are generated for you to run."
---

# vercel-tool

## Triggers on
check deployment, vercel status, build logs, rollback deployment, domain ssl, environment variables, vercel project, vercel deploy

## What This Skill Does
Manage Vercel deployments, domains, and environment variables via the Vercel API.

## Commands

### status
Check the latest deployment status of a project.
```bash
bash scripts/script.sh status <project-name>
```

### list
List recent deployments across all projects.
```bash
bash scripts/script.sh list [limit]
```

### logs
View build logs for the latest or a specific deployment.
```bash
bash scripts/script.sh logs <project-name> [deployment-id]
```

### domains
Check domain configuration and SSL status.
```bash
bash scripts/script.sh domains <project-name>
```

### rollback
Promote a previous deployment to production.
```bash
bash scripts/script.sh rollback <project-name> <deployment-id>
```

### env
List environment variables for a project.
```bash
bash scripts/script.sh env <project-name> [production|preview|development]
```

### deploy
Show instructions for triggering a new deployment.
```bash
bash scripts/script.sh deploy <project-name>
```

### help
Show all available commands.
```bash
bash scripts/script.sh help
```


Get your token at: https://vercel.com/account/tokens

## Requirements
- bash 4+
- curl
- python3

Powered by BytesAgain | bytesagain.com
