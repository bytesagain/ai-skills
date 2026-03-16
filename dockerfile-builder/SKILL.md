---
version: "2.0.0"
name: dockerfile-builder
description: "Unknown option: help. Use when you need dockerfile builder capabilities. Triggers on: dockerfile builder, lang, app-name, port, multi-stage, dockerignore."
author: BytesAgain
---

# dockerfile-builder

Generate production-ready, optimized Dockerfiles for multiple languages and frameworks. Supports Node.js, Python, Go, Java, and Rust with multi-stage builds, security hardening, non-root users, layer caching optimization, and .dockerignore generation. Follows Docker best practices including minimal base images, proper signal handling, health checks, and secret management.

## Commands

| Command | Description |
|---------|-------------|
| `generate` | Generate a complete Dockerfile for a given language/framework |
| `multistage` | Create a multi-stage build Dockerfile |
| `dockerignore` | Generate a .dockerignore file for a project type |
| `optimize` | Analyze and optimize an existing Dockerfile |
| `compose` | Generate a docker-compose.yml for multi-service setups |
| `security` | Generate a security-hardened Dockerfile |
| `healthcheck` | Add health check configuration to a Dockerfile |

## Usage

```
# Generate a basic Dockerfile for a Node.js project
dockerfile-builder generate --lang node --version 20

# Generate multi-stage build for Go
dockerfile-builder multistage --lang go --binary myapp

# Generate .dockerignore
dockerfile-builder dockerignore --lang python

# Security-hardened Python Dockerfile
dockerfile-builder security --lang python --version 3.12

# Generate docker-compose for Node + PostgreSQL + Redis
dockerfile-builder compose --services "node,postgres,redis"

# Optimize existing Dockerfile
dockerfile-builder optimize --file ./Dockerfile

# Add healthcheck
dockerfile-builder healthcheck --lang node --port 3000
```

## Examples

### Node.js Production Dockerfile
```
dockerfile-builder generate --lang node --version 20 --framework express --port 3000
```

### Go Multi-stage Build
```
dockerfile-builder multistage --lang go --binary server --port 8080
```

### Java Spring Boot
```
dockerfile-builder generate --lang java --version 21 --framework springboot --port 8080
```

### Rust Production Build
```
dockerfile-builder multistage --lang rust --binary myapp --port 3000
```

## Features

- **Multi-stage builds** — Minimize final image size by separating build and runtime stages
- **Security hardening** — Non-root users, read-only filesystem, no new privileges
- **Layer caching** — Optimized layer ordering for fast rebuilds
- **Health checks** — Built-in health check configuration
- **.dockerignore** — Language-aware ignore patterns
- **docker-compose** — Multi-service orchestration configs
- **Best practices** — Follows Docker official guidelines

## Keywords

dockerfile, docker, container, multi-stage build, docker-compose, containerization, devops, deployment, microservices, cloud-native
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
