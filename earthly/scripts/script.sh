#!/bin/bash
# Earthly - Containerized CI/CD Build Tool Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              EARTHLY REFERENCE                              ║
║          Dockerfile + Makefile = Earthfile                   ║
╚══════════════════════════════════════════════════════════════╝

Earthly combines the best of Dockerfiles and Makefiles into a
single build system. Builds are containerized (reproducible),
cacheable, and work the same locally and in CI.

KEY FEATURES:
  Reproducible     Same result locally and in CI
  Cacheable        Layer caching like Docker
  Parallelizable   Targets run in parallel automatically
  Multi-language    Not tied to any language/framework
  CI-agnostic      Works with GitHub Actions, GitLab, Jenkins
  Monorepo         Import targets from other directories/repos

EARTHLY vs ALTERNATIVES:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Earthly  │ Makefile │ Bazel    │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Containerized│ Yes      │ No       │ Sandboxed│
  │ Reproducible │ Yes      │ No       │ Yes      │
  │ Learning     │ Easy     │ Easy     │ Hard     │
  │ Caching      │ Docker   │ File     │ Content  │
  │ Multi-lang   │ Yes      │ Yes      │ Yes      │
  │ CI=Local     │ Yes      │ Maybe    │ Yes      │
  │ Setup        │ Minutes  │ Instant  │ Hours    │
  └──────────────┴──────────┴──────────┴──────────┘

INSTALL:
  # Linux/macOS
  sudo /bin/sh -c 'wget https://github.com/earthly/earthly/releases/latest/download/earthly-linux-amd64 -O /usr/local/bin/earthly && chmod +x /usr/local/bin/earthly'

  # macOS (Homebrew)
  brew install earthly

  # Bootstrap
  earthly bootstrap
EOF
}

cmd_earthfile() {
cat << 'EOF'
EARTHFILE SYNTAX
==================

An Earthfile is like a Dockerfile with named targets.

BASIC EXAMPLE:
  VERSION 0.8

  FROM golang:1.22-alpine
  WORKDIR /app

  deps:
      COPY go.mod go.sum .
      RUN go mod download
      SAVE ARTIFACT go.mod AS LOCAL go.mod

  build:
      FROM +deps
      COPY . .
      RUN go build -o server ./cmd/server
      SAVE ARTIFACT server /server

  test:
      FROM +deps
      COPY . .
      RUN go test ./...

  docker:
      FROM alpine:3.19
      COPY +build/server /usr/local/bin/server
      EXPOSE 8080
      ENTRYPOINT ["/usr/local/bin/server"]
      SAVE IMAGE myapp:latest

  all:
      BUILD +test
      BUILD +docker

COMMANDS:
  earthly +build          # Run build target
  earthly +test           # Run test target
  earthly +docker         # Build Docker image
  earthly +all            # Run all target (test + docker)
  earthly --push +docker  # Push image to registry

MULTI-LANGUAGE:
  # Node.js
  node-deps:
      FROM node:20-alpine
      WORKDIR /app
      COPY package.json package-lock.json .
      RUN npm ci
      SAVE ARTIFACT node_modules

  node-build:
      FROM +node-deps
      COPY . .
      RUN npm run build
      SAVE ARTIFACT dist /dist

  # Python
  python-deps:
      FROM python:3.12-slim
      WORKDIR /app
      COPY requirements.txt .
      RUN pip install --no-cache-dir -r requirements.txt

  python-test:
      FROM +python-deps
      COPY . .
      RUN pytest

  # Rust
  rust-build:
      FROM rust:1.77-slim
      WORKDIR /app
      COPY . .
      RUN cargo build --release
      SAVE ARTIFACT target/release/myapp /myapp
EOF
}

cmd_features() {
cat << 'EOF'
ADVANCED FEATURES
===================

ARGS (variables):
  ARG --global VERSION=latest
  ARG --global REGISTRY=ghcr.io/myorg

  build:
      ARG TARGET=release
      FROM golang:1.22
      RUN go build -o app ./cmd/$TARGET

  docker:
      FROM alpine
      COPY +build/app /app
      SAVE IMAGE --push $REGISTRY/myapp:$VERSION

  # Override
  earthly +docker --VERSION=v1.2.3

IF/FOR LOGIC:
  build:
      ARG OS=linux
      IF [ "$OS" = "darwin" ]
          RUN echo "Building for macOS"
      ELSE
          RUN echo "Building for Linux"
      END

  multi-arch:
      FOR arch IN amd64 arm64
          BUILD +build --GOARCH=$arch
      END

SECRETS:
  deploy:
      RUN --secret AWS_ACCESS_KEY_ID \
          --secret AWS_SECRET_ACCESS_KEY \
          aws s3 sync dist/ s3://mybucket/

  # Pass secrets
  earthly --secret AWS_ACCESS_KEY_ID --secret AWS_SECRET_ACCESS_KEY +deploy

IMPORTING:
  # From another directory
  BUILD ./frontend+build
  BUILD ./backend+test

  # From another repo
  BUILD github.com/myorg/shared-builds+lint

  # From other Earthfile
  IMPORT ./shared AS shared
  BUILD shared+lint

CACHE MOUNTS:
  build:
      FROM golang:1.22
      RUN --mount=type=cache,target=/root/.cache/go-build \
          go build -o app

  node-deps:
      FROM node:20
      RUN --mount=type=cache,target=/root/.npm \
          npm ci

CI INTEGRATION:
  # GitHub Actions
  - name: Install Earthly
    uses: earthly/actions-setup@v1

  - name: Build
    run: earthly +all
    env:
      EARTHLY_TOKEN: ${{ secrets.EARTHLY_TOKEN }}

  # GitLab CI
  build:
    image: earthly/earthly:latest
    script:
      - earthly +all

SAVE / ARTIFACTS:
  # Save file from build
  SAVE ARTIFACT output.txt AS LOCAL ./output.txt

  # Save Docker image
  SAVE IMAGE myapp:latest
  SAVE IMAGE --push registry.example.com/myapp:latest

WAIT / PARALLEL:
  all:
      WAIT
          BUILD +frontend
          BUILD +backend
          BUILD +worker
      END
      # All three run in parallel, wait for all to finish
      BUILD +integration-test

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Earthly - Containerized Build Tool Reference

Commands:
  intro      Overview, comparison, install
  earthfile  Syntax, targets, multi-language
  features   Args, secrets, imports, CI, caching

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)     cmd_intro ;;
  earthfile) cmd_earthfile ;;
  features)  cmd_features ;;
  help|*)    show_help ;;
esac
