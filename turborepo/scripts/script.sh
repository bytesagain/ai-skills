#!/bin/bash
# Turborepo - High-Performance Monorepo Build System Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              TURBOREPO REFERENCE                            ║
║          High-Performance Monorepo Build System             ║
╚══════════════════════════════════════════════════════════════╝

Turborepo is a build system for JavaScript/TypeScript monorepos.
It makes builds fast through intelligent caching, parallelization,
and dependency-aware task scheduling. Acquired by Vercel in 2021.

KEY FEATURES:
  Caching          Never do the same work twice
  Parallelism      Run tasks concurrently across packages
  Incremental      Only rebuild what changed
  Remote caching   Share cache across CI and team
  Task pipelines   Define task dependencies

TURBOREPO vs NX vs LERNA:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Turbo    │ Nx       │ Lerna    │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Speed        │ Fast     │ Fast     │ Slow     │
  │ Caching      │ Built-in │ Built-in │ Via Nx   │
  │ Remote cache │ Vercel   │ Nx Cloud │ Nx Cloud │
  │ Config       │ Minimal  │ More     │ Minimal  │
  │ Language     │ Go       │ JS/Rust  │ JS       │
  │ Learning     │ Easy     │ Moderate │ Easy     │
  │ Plugins      │ No       │ Yes      │ No       │
  │ Generators   │ No       │ Yes      │ No       │
  └──────────────┴──────────┴──────────┴──────────┘

SETUP:
  npx create-turbo@latest my-monorepo
  # or add to existing
  pnpm add turbo -w -D
EOF
}

cmd_config() {
cat << 'EOF'
CONFIGURATION
===============

TURBO.JSON:
  {
    "$schema": "https://turbo.build/schema.json",
    "globalDependencies": ["**/.env.*local"],
    "globalEnv": ["NODE_ENV", "CI"],
    "tasks": {
      "build": {
        "dependsOn": ["^build"],
        "outputs": ["dist/**", ".next/**", "!.next/cache/**"],
        "env": ["DATABASE_URL"]
      },
      "test": {
        "dependsOn": ["build"],
        "inputs": ["src/**", "test/**"],
        "outputs": ["coverage/**"]
      },
      "lint": {
        "dependsOn": ["^build"]
      },
      "dev": {
        "cache": false,
        "persistent": true
      },
      "typecheck": {
        "dependsOn": ["^build"]
      },
      "deploy": {
        "dependsOn": ["build", "test", "lint"],
        "outputs": []
      }
    }
  }

TASK DEPENDENCIES:
  "^build"         Build dependencies first (topological)
  ["build"]        Run build in same package first
  ["^build", "^typecheck"]  Multiple upstream deps
  No dependsOn     Can run immediately (parallel)

OUTPUTS:
  "dist/**"        Cache the dist folder
  ".next/**"       Cache Next.js build
  "!.next/cache/**"  Exclude Next.js cache from turbo cache
  []               No outputs (side-effect only task)

INPUTS:
  "src/**"         Only re-run if src changes
  "test/**"        Or test files change
  Default: all files tracked by git

ENVIRONMENT VARIABLES:
  "env": ["API_KEY"]          Task-level env
  "globalEnv": ["CI"]         All tasks
  "passThroughEnv": ["AWS_*"] Passthrough (no cache impact)
EOF
}

cmd_commands() {
cat << 'EOF'
CLI & REMOTE CACHING
=======================

CLI:
  turbo build                         # Build all packages
  turbo dev                           # Dev all packages
  turbo build --filter=web            # Build specific package
  turbo build --filter=./apps/*       # Build all apps
  turbo build --filter=web...         # web and its dependencies
  turbo build --filter=...web         # web and its dependents
  turbo build --filter=...[HEAD~1]    # Only changed since last commit
  turbo build --filter=web --filter=api  # Multiple packages
  turbo build --dry-run               # Show what would run
  turbo build --graph                 # Generate dependency graph
  turbo build --summarize             # Show summary after run
  turbo build --force                 # Skip cache
  turbo build --concurrency=4         # Limit parallelism
  turbo prune web                     # Generate pruned monorepo for deploy

OUTPUT:
  # Cache hit:
  # web:build: cache hit, replaying logs...
  # Cache miss:
  # web:build: cache miss, executing...

REMOTE CACHING:
  # Vercel Remote Cache (easiest)
  turbo login                         # Login to Vercel
  turbo link                          # Link to Vercel project
  # Now caches are shared across CI and team!

  # Self-hosted (Turborepo Remote Cache)
  # Docker: ducktors/turborepo-remote-cache
  # Set in .turbo/config.json:
  {
    "teamId": "my-team",
    "apiUrl": "https://cache.example.com"
  }

GITHUB ACTIONS:
  - uses: actions/checkout@v4
  - uses: pnpm/action-setup@v2
  - uses: actions/setup-node@v4
    with:
      node-version: 22
      cache: 'pnpm'
  - run: pnpm install
  - run: pnpm turbo build test lint
    env:
      TURBO_TOKEN: ${{ secrets.TURBO_TOKEN }}
      TURBO_TEAM: ${{ secrets.TURBO_TEAM }}

DOCKER (deploy specific app):
  FROM node:22-alpine AS base
  RUN npm install -g turbo pnpm
  
  FROM base AS pruned
  WORKDIR /app
  COPY . .
  RUN turbo prune web --docker

  FROM base AS installer
  WORKDIR /app
  COPY --from=pruned /app/out/json/ .
  RUN pnpm install
  COPY --from=pruned /app/out/full/ .
  RUN pnpm turbo build --filter=web

  FROM base AS runner
  WORKDIR /app
  COPY --from=installer /app/apps/web/.next/standalone ./
  CMD ["node", "server.js"]

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Turborepo - High-Performance Monorepo Build System Reference

Commands:
  intro      Overview, comparison
  config     turbo.json, tasks, dependencies, env
  commands   CLI, remote caching, GitHub Actions, Docker

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  config)   cmd_config ;;
  commands) cmd_commands ;;
  help|*)   show_help ;;
esac
