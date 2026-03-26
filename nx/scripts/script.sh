#!/bin/bash
# Nx - Smart Monorepo Build System Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              NX REFERENCE                                   ║
║          Smart Monorepo Build System                        ║
╚══════════════════════════════════════════════════════════════╝

Nx is a build system with first-class monorepo support and
powerful code generation. Created by ex-Google engineers (Nrwl),
it brings Google-style monorepo tooling to everyone.

KEY FEATURES:
  Affected          Only run tasks on changed projects
  Computation cache Hash-based, local and remote
  Distributed       Split tasks across CI machines
  Generators        Scaffold code consistently
  Module graph      Enforce architecture boundaries
  Plugins           React, Angular, Node, Go, Rust, etc.

SETUP:
  npx create-nx-workspace@latest my-org
  # or add to existing repo
  npx nx@latest init

PROJECT STRUCTURE:
  my-org/
  ├── apps/
  │   ├── web/               # Frontend app
  │   └── api/               # Backend app
  ├── libs/
  │   ├── shared/ui/         # Shared components
  │   ├── shared/utils/      # Shared utilities
  │   └── feature/auth/      # Feature library
  ├── nx.json                # Nx config
  ├── project.json           # Per-project config
  └── package.json
EOF
}

cmd_commands() {
cat << 'EOF'
COMMANDS & AFFECTED
=====================

CORE COMMANDS:
  nx serve web                    # Dev server
  nx build web                    # Build
  nx test web                     # Test
  nx lint web                     # Lint
  nx e2e web-e2e                  # E2E tests

AFFECTED (only changed):
  nx affected -t build            # Build affected projects
  nx affected -t test             # Test affected
  nx affected -t lint             # Lint affected
  nx affected --graph             # Visual graph of affected
  nx affected -t build --base=main --head=HEAD

RUN MANY:
  nx run-many -t build            # Build all
  nx run-many -t build -p web,api # Build specific
  nx run-many -t build --parallel=4

GRAPH:
  nx graph                        # Open project dependency graph
  nx graph --affected             # Show affected in graph
  # Opens interactive browser UI

NX.JSON:
  {
    "targetDefaults": {
      "build": {
        "dependsOn": ["^build"],
        "cache": true
      },
      "test": {
        "cache": true
      },
      "lint": {
        "cache": true
      }
    },
    "namedInputs": {
      "default": ["{projectRoot}/**/*", "sharedGlobals"],
      "production": ["default", "!{projectRoot}/**/*.spec.*"],
      "sharedGlobals": ["{workspaceRoot}/tsconfig.base.json"]
    },
    "defaultBase": "main"
  }

PROJECT.JSON:
  {
    "name": "web",
    "sourceRoot": "apps/web/src",
    "targets": {
      "build": {
        "executor": "@nx/next:build",
        "outputs": ["{options.outputPath}"],
        "options": { "outputPath": "dist/apps/web" }
      },
      "serve": {
        "executor": "@nx/next:server",
        "options": { "port": 3000 }
      }
    },
    "tags": ["scope:web", "type:app"]
  }
EOF
}

cmd_generators() {
cat << 'EOF'
GENERATORS & BOUNDARIES
==========================

BUILT-IN GENERATORS:
  nx g @nx/react:app web          # Generate React app
  nx g @nx/react:lib ui           # Generate library
  nx g @nx/react:component Button --project=ui
  nx g @nx/node:app api           # Generate Node app
  nx g @nx/next:app frontend      # Generate Next.js app

  # Other plugins
  nx g @nx/angular:app dashboard
  nx g @nx/nest:app backend
  nx g @nx/express:app server
  nx g @nx/vue:app vue-app

CUSTOM GENERATORS:
  nx g @nx/plugin:generator my-gen --project=my-plugin

  # generators/my-gen/generator.ts
  import { Tree, formatFiles, generateFiles } from '@nx/devkit';
  export async function myGenerator(tree: Tree, options) {
    generateFiles(tree, path.join(__dirname, 'files'), options.path, {
      ...options,
      tmpl: '',
    });
    await formatFiles(tree);
  }

MODULE BOUNDARIES:
  // nx.json
  {
    "targetDefaults": {
      "lint": {
        "inputs": ["default", "{workspaceRoot}/.eslintrc.json"]
      }
    }
  }

  // .eslintrc.json (root)
  {
    "plugins": ["@nx"],
    "rules": {
      "@nx/enforce-module-boundaries": ["error", {
        "depConstraints": [
          { "sourceTag": "type:app", "onlyDependOnLibsWithTags": ["type:lib"] },
          { "sourceTag": "scope:web", "onlyDependOnLibsWithTags": ["scope:web", "scope:shared"] },
          { "sourceTag": "scope:api", "onlyDependOnLibsWithTags": ["scope:api", "scope:shared"] }
        ]
      }]
    }
  }
  // This enforces: apps can use libs, web can't import api libs

NX CLOUD:
  npx nx connect                  # Connect to Nx Cloud
  # Remote caching + distributed tasks
  # CI runs tasks across multiple machines automatically

  # CI config
  - run: npx nx affected -t build test lint --configuration=ci

MIGRATION:
  # From Turborepo
  npx nx@latest init
  # Nx reads turbo.json and converts automatically

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Nx - Smart Monorepo Build System Reference

Commands:
  intro        Overview, structure
  commands     CLI, affected, graph, config
  generators   Code generation, module boundaries, Nx Cloud

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  commands)   cmd_commands ;;
  generators) cmd_generators ;;
  help|*)     show_help ;;
esac
