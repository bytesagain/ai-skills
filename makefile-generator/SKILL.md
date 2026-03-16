---
version: "2.0.0"
name: makefile-generator
description: "Error: --lang required. Use when you need makefile generator capabilities. Triggers on: makefile generator, lang, name, docker, output, help."
---

# makefile-generator

Generate complete, language-aware Makefiles for any project type. Supports Node.js, Python, Go, Java, Rust, C/C++, and multi-language monorepos. Includes build targets, dependency management, testing, linting, formatting, Docker integration, help targets with auto-documentation, and common development recipes. Features self-documenting targets with `make help`, phony target declarations, variable management, and cross-platform compatibility.

## Commands

| Command | Description |
|---------|-------------|
| `generate` | Generate a complete Makefile for a project type |
| `target` | Add specific targets to an existing Makefile |
| `docker` | Add Docker-related targets (build, push, run) |
| `ci` | Add CI/CD-related targets (test, lint, coverage) |
| `monorepo` | Generate Makefile for a monorepo with sub-projects |
| `help` | Add self-documenting help target |
| `release` | Add release/versioning targets |

## Usage

```
# Generate Makefile for a Node.js project
makefile-generator generate --lang node --pm npm

# Generate for Python project with poetry
makefile-generator generate --lang python --pm poetry

# Generate for Go project
makefile-generator generate --lang go --binary myapp

# Generate for Rust project
makefile-generator generate --lang rust --binary myapp

# Add Docker targets
makefile-generator docker --image myapp --registry ghcr.io/user

# Add CI targets
makefile-generator ci --lang python --test pytest --lint ruff

# Monorepo Makefile
makefile-generator monorepo --services "api,web,worker"

# Add release targets with semver
makefile-generator release --strategy semver
```

## Examples

### Node.js Project
```
makefile-generator generate --lang node --pm npm --docker
```

### Python FastAPI
```
makefile-generator generate --lang python --pm poetry --framework fastapi
```

### Go Microservice
```
makefile-generator generate --lang go --binary server --docker --k8s
```

### C++ Project
```
makefile-generator generate --lang cpp --compiler g++ --standard c++20
```

## Features

- **Self-documenting** — `make help` shows all targets with descriptions
- **Language-aware** — Correct build tools and conventions per language
- **Docker integration** — Build, tag, push, run targets
- **Testing** — Unit, integration, and e2e test targets
- **Linting** — Language-specific linter configurations
- **Release** — Semantic versioning and changelog targets
- **Monorepo** — Sub-project orchestration

## Keywords

makefile, make, build system, build automation, devops, developer tools, project setup, scaffolding, build targets
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
