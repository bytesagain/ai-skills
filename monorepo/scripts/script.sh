#!/bin/bash
# Monorepo - Multi-Package Repository Management Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              MONOREPO REFERENCE                             ║
║          Multi-Package Repository Management                ║
╚══════════════════════════════════════════════════════════════╝

A monorepo stores multiple projects/packages in a single
repository. Used by Google, Meta, Microsoft, and most modern
open-source projects.

MONOREPO vs POLYREPO:
  ┌──────────────┬──────────────┬──────────────┐
  │ Feature      │ Monorepo     │ Polyrepo     │
  ├──────────────┼──────────────┼──────────────┤
  │ Code sharing │ Easy         │ Via packages │
  │ Refactoring  │ Atomic       │ Multi-PR     │
  │ Dependencies │ Shared       │ Duplicated   │
  │ CI/CD        │ Smart builds │ Per-repo     │
  │ Onboarding   │ One clone    │ Many clones  │
  │ Scale        │ Needs tools  │ Natural      │
  │ Permissions  │ CODEOWNERS   │ Per-repo     │
  │ Build time   │ Needs caching│ Independent  │
  └──────────────┴──────────────┴──────────────┘

MONOREPO TOOLS:
  Task runners    Turborepo, Nx, Lerna, Moon
  Package mgrs    pnpm workspaces, npm workspaces, Yarn Berry
  Build systems   Bazel, Buck2, Pants, Gradle
  VCS             Git (with sparse checkout), Sapling

TYPICAL STRUCTURE:
  my-monorepo/
  ├── apps/
  │   ├── web/           # Next.js frontend
  │   ├── mobile/        # React Native
  │   └── api/           # Express/Fastify backend
  ├── packages/
  │   ├── ui/            # Shared React components
  │   ├── utils/         # Shared utilities
  │   ├── config/        # Shared configs (ESLint, TS)
  │   └── types/         # Shared TypeScript types
  ├── package.json       # Root (workspaces)
  ├── pnpm-workspace.yaml
  └── turbo.json         # Task pipeline
EOF
}

cmd_workspaces() {
cat << 'EOF'
PACKAGE MANAGER WORKSPACES
============================

PNPM (recommended):
  # pnpm-workspace.yaml
  packages:
    - 'apps/*'
    - 'packages/*'

  # Commands
  pnpm install                        # Install all deps
  pnpm add react --filter web         # Add dep to specific package
  pnpm add @repo/ui --filter web --workspace  # Add internal dep
  pnpm run build --filter web         # Run in specific package
  pnpm run build --filter ./apps/*    # Run in all apps
  pnpm run test --recursive           # Run in all packages
  pnpm run dev --filter web --filter api  # Run in multiple

  # Root package.json
  {
    "private": true,
    "scripts": {
      "dev": "turbo dev",
      "build": "turbo build",
      "test": "turbo test",
      "lint": "turbo lint"
    },
    "devDependencies": {
      "turbo": "^2.0.0"
    }
  }

NPM WORKSPACES:
  // package.json
  { "workspaces": ["apps/*", "packages/*"] }
  npm run build -w apps/web
  npm run test --workspaces

YARN BERRY:
  // package.json
  { "workspaces": ["apps/*", "packages/*"] }
  yarn workspace web add react
  yarn workspace web run build

INTERNAL PACKAGES:
  // packages/ui/package.json
  {
    "name": "@repo/ui",
    "version": "0.0.0",
    "private": true,
    "main": "./src/index.ts",
    "types": "./src/index.ts",
    "exports": {
      ".": "./src/index.ts",
      "./button": "./src/button.tsx"
    }
  }

  // apps/web/package.json
  {
    "dependencies": {
      "@repo/ui": "workspace:*"
    }
  }

  // apps/web/src/app.tsx
  import { Button } from '@repo/ui';
  import { Button } from '@repo/ui/button';
EOF
}

cmd_practices() {
cat << 'EOF'
BEST PRACTICES
================

DEPENDENCY MANAGEMENT:
  # Single version policy (all packages use same version)
  # Install shared deps at root
  pnpm add -w -D typescript eslint prettier

  # Catalog (pnpm 9+)
  # pnpm-workspace.yaml
  catalog:
    react: ^18.3.0
    typescript: ^5.5.0
  # Then in package.json: "react": "catalog:"

SHARED CONFIGS:
  # packages/config-eslint/
  module.exports = {
    extends: ['next', 'prettier'],
    rules: { /* shared rules */ },
  };

  # apps/web/.eslintrc.js
  module.exports = { extends: ['@repo/eslint-config'] };

  # packages/config-typescript/base.json
  { "compilerOptions": { "strict": true, "target": "ES2022" } }
  # apps/web/tsconfig.json
  { "extends": "@repo/typescript-config/base.json" }

GIT AT SCALE:
  # Sparse checkout (only clone what you need)
  git clone --sparse --filter=blob:none <repo>
  git sparse-checkout set apps/web packages/ui

  # CODEOWNERS
  apps/web/        @frontend-team
  apps/api/        @backend-team
  packages/ui/     @design-team
  packages/types/  @platform-team

CI/CD:
  # Only build what changed
  # GitHub Actions
  - uses: dorny/paths-filter@v2
    id: changes
    with:
      filters: |
        web: 'apps/web/**'
        api: 'apps/api/**'
        ui: 'packages/ui/**'
  - if: steps.changes.outputs.web == 'true'
    run: pnpm run build --filter web

  # Turborepo handles this automatically
  turbo build --filter=...[HEAD~1]  # Only changed packages

VERSIONING:
  # Changesets (recommended for publishing)
  npx changeset                      # Create changeset
  npx changeset version             # Bump versions
  npx changeset publish             # Publish to npm

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Monorepo - Multi-Package Repository Reference

Commands:
  intro        Overview, monorepo vs polyrepo
  workspaces   pnpm/npm/yarn workspaces, internal packages
  practices    Shared configs, Git at scale, CI/CD, versioning

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  workspaces) cmd_workspaces ;;
  practices)  cmd_practices ;;
  help|*)     show_help ;;
esac
