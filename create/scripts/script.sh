#!/usr/bin/env bash
# create — Project Scaffolding Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Project Scaffolding Overview ===

Scaffolding is the automated generation of project boilerplate —
directory structures, config files, starter code, and build setup.

Why Scaffold?
  - Consistency across team projects
  - Reduce setup time (hours → minutes)
  - Enforce best practices from day one
  - Include security defaults (gitignore, env handling)
  - Standardize toolchain (linter, formatter, test runner)

When to Scaffold:
  ✓ Starting a new microservice
  ✓ Creating a new library/package
  ✓ Spinning up a prototype
  ✓ Onboarding a new project type
  ✗ One-off scripts (just create the file)
  ✗ Modifying existing projects (use codemods)

Scaffolding Approaches:
  1. CLI Tools        npm create, cargo init, django-admin startproject
  2. Template Repos   GitHub template repositories, degit
  3. Generators       Yeoman, Cookiecutter, Hygen
  4. Custom Scripts   Company-specific init scripts
  5. IDE Integration  VS Code snippets, IntelliJ project wizards

Generation Strategies:
  Copy-based      Copy template files, replace placeholders
  AST-based       Parse and modify code programmatically
  Prompt-based    Ask questions, generate based on answers
  Composition     Combine multiple smaller templates
  AI-assisted     LLM generates project based on description
EOF
}

cmd_structures() {
    cat << 'EOF'
=== Standard Directory Structures ===

--- Node.js / TypeScript ---
project/
├── src/
│   ├── index.ts
│   ├── routes/
│   ├── middleware/
│   ├── services/
│   ├── models/
│   └── utils/
├── tests/
│   ├── unit/
│   └── integration/
├── docs/
├── scripts/
├── .github/workflows/
├── package.json
├── tsconfig.json
├── .eslintrc.json
├── .prettierrc
├── .gitignore
├── .env.example
├── Dockerfile
└── README.md

--- Python ---
project/
├── src/
│   └── project_name/
│       ├── __init__.py
│       ├── main.py
│       ├── models/
│       ├── services/
│       └── utils/
├── tests/
│   ├── conftest.py
│   ├── test_main.py
│   └── fixtures/
├── docs/
├── scripts/
├── pyproject.toml
├── requirements.txt (or Pipfile / poetry.lock)
├── .flake8 / ruff.toml
├── .gitignore
├── .env.example
├── Dockerfile
├── Makefile
└── README.md

--- Go ---
project/
├── cmd/
│   └── server/
│       └── main.go
├── internal/
│   ├── handler/
│   ├── service/
│   ├── repository/
│   └── model/
├── pkg/          (public libraries)
├── api/          (OpenAPI specs, protobuf)
├── configs/
├── scripts/
├── go.mod
├── go.sum
├── Makefile
├── Dockerfile
└── README.md

--- Rust ---
project/
├── src/
│   ├── main.rs (or lib.rs)
│   ├── config.rs
│   └── handlers/
├── tests/
├── benches/
├── examples/
├── Cargo.toml
├── .gitignore
└── README.md
EOF
}

cmd_tools() {
    cat << 'EOF'
=== Popular Scaffolding Tools ===

Language-Specific:

  Node.js:
    npm create vite@latest my-app -- --template react-ts
    npx create-react-app my-app --template typescript
    npx create-next-app@latest my-app
    npm init fastify -- my-app
    npx nuxi init my-app

  Python:
    django-admin startproject myproject
    flask init (via cookiecutter-flask)
    poetry new my-package
    cookiecutter gh:audreyfeldroy/cookiecutter-pypackage
    uv init my-project

  Go:
    go mod init github.com/user/project
    gonew golang.org/x/example/hello my-project

  Rust:
    cargo init my-project
    cargo new my-library --lib
    cargo generate --git https://github.com/user/template

  Java:
    mvn archetype:generate
    spring init --dependencies=web my-app (Spring Boot)
    gradle init --type java-application

Cross-Language Generators:

  Cookiecutter (Python-based):
    cookiecutter gh:user/template
    Supports: Jinja2 templates, prompts, hooks
    Ecosystem: 10,000+ templates on GitHub

  Yeoman (Node-based):
    yo generator-name
    Supports: prompts, file transforms, composition
    Ecosystem: 8,000+ generators on npm

  Hygen (Node-based):
    hygen component new --name MyComponent
    Template-based, lives in project (_templates/)
    Good for adding to existing projects

  degit (lightweight):
    npx degit user/repo my-project
    Downloads repo without git history
    Perfect for template repositories
EOF
}

cmd_templates() {
    cat << 'EOF'
=== Template Engine Patterns ===

Variable Substitution:
  {{project_name}}     → my-awesome-app
  {{author}}           → Jane Doe
  {{license}}          → MIT
  {{year}}             → 2024
  {{description}}      → A web application for...

Common Template Engines:

  Jinja2 (Cookiecutter):
    {{ cookiecutter.project_name }}
    {% if cookiecutter.use_docker == "y" %}
    Dockerfile content here
    {% endif %}

  EJS (Yeoman):
    <%= projectName %>
    <% if (useTypeScript) { %>
    tsconfig.json content
    <% } %>

  Handlebars (Hygen):
    {{name}}
    {{#if typescript}}
    TypeScript setup
    {{/if}}

  Go Templates (gonew):
    {{.ProjectName}}
    {{if .EnableAuth}}
    Auth middleware
    {{end}}

Conditional File Generation:
  # Include Dockerfile only if docker option selected
  # Include CI config based on provider choice (GitHub, GitLab, etc.)
  # Include test setup based on framework choice

  Cookiecutter hooks (pre/post generation):
    hooks/
    ├── pre_gen_project.py    # Validate inputs
    └── post_gen_project.py   # Clean up, git init, install deps

Dynamic Filename Templates:
  {{cookiecutter.project_slug}}/      → my-project/
  {{cookiecutter.module_name}}.py     → app.py

Best Practices:
  1. Keep templates minimal — don't over-generate
  2. Include .env.example, never .env
  3. Provide sensible defaults for all prompts
  4. Include README explaining the generated structure
  5. Run linter/formatter as post-generation hook
  6. Validate inputs (project name format, license choices)
  7. Version your templates (tag releases)
EOF
}

cmd_configs() {
    cat << 'EOF'
=== Essential Config Files ===

.gitignore (must have):
  # OS
  .DS_Store
  Thumbs.db
  # IDE
  .idea/
  .vscode/
  *.swp
  # Environment
  .env
  .env.local
  # Dependencies
  node_modules/
  __pycache__/
  venv/
  # Build output
  dist/
  build/
  *.egg-info/
  # Logs
  *.log

.editorconfig (cross-IDE consistency):
  root = true
  [*]
  indent_style = space
  indent_size = 2
  end_of_line = lf
  charset = utf-8
  trim_trailing_whitespace = true
  insert_final_newline = true
  [*.md]
  trim_trailing_whitespace = false
  [*.py]
  indent_size = 4

.env.example (document required env vars):
  DATABASE_URL=postgresql://user:pass@localhost:5432/dbname
  API_KEY=your-api-key-here
  NODE_ENV=development
  PORT=3000

CI/CD Config:
  .github/workflows/ci.yml   (GitHub Actions)
  .gitlab-ci.yml              (GitLab CI)
  Jenkinsfile                  (Jenkins)
  .circleci/config.yml         (CircleCI)

Docker:
  Dockerfile                   Multi-stage build
  .dockerignore                Exclude node_modules, .git, etc.
  docker-compose.yml           Local dev services

Code Quality:
  .eslintrc.json / .eslintrc.js    (JS/TS linting)
  .prettierrc                       (JS/TS formatting)
  ruff.toml / pyproject.toml        (Python linting)
  .golangci.yml                     (Go linting)
  rustfmt.toml                      (Rust formatting)

Security:
  .npmrc (registry config)
  .nvmrc / .python-version / .tool-versions (runtime versions)
  renovate.json / dependabot.yml (dependency updates)
EOF
}

cmd_conventions() {
    cat << 'EOF'
=== Project Conventions ===

Naming Conventions:
  Repository:    kebab-case (my-awesome-project)
  Package:       kebab-case (npm) or snake_case (Python/Rust)
  Module:        snake_case (Python), camelCase (JS/TS)
  Class:         PascalCase (universal)
  Function:      camelCase (JS/TS/Java), snake_case (Python/Rust/Go)
  Constant:      UPPER_SNAKE_CASE (universal)
  CSS class:     kebab-case or BEM (block__element--modifier)

Versioning (SemVer):
  MAJOR.MINOR.PATCH
  MAJOR  Breaking changes (incompatible API changes)
  MINOR  New features (backward-compatible)
  PATCH  Bug fixes (backward-compatible)

  Pre-release: 1.0.0-alpha.1, 1.0.0-beta.2, 1.0.0-rc.1
  Build meta:  1.0.0+build.123

Conventional Commits:
  feat:     New feature            → bumps MINOR
  fix:      Bug fix                → bumps PATCH
  docs:     Documentation only
  style:    Code style (no logic change)
  refactor: Code change (no feature/fix)
  perf:     Performance improvement
  test:     Adding/fixing tests
  chore:    Build process, tooling
  ci:       CI/CD changes

  Breaking change: add ! after type
    feat!: remove deprecated API endpoint

  Examples:
    feat(auth): add OAuth2 login support
    fix(api): handle null response from payment gateway
    docs: update installation instructions for v2

Changelog (Keep a Changelog format):
  ## [1.2.0] - 2024-01-15
  ### Added
  - OAuth2 login support (#123)
  ### Fixed
  - Null response handling in payment API (#456)
  ### Changed
  - Updated Node.js requirement to >= 18

Branch Strategy:
  main / master     Production-ready code
  develop           Integration branch
  feature/xxx       New features
  fix/xxx           Bug fixes
  release/x.x.x     Release preparation
  hotfix/xxx        Production hotfixes
EOF
}

cmd_monorepo() {
    cat << 'EOF'
=== Monorepo Scaffolding ===

What Is a Monorepo?
  Single repository containing multiple projects/packages.
  Shared tooling, consistent versioning, atomic changes across packages.

Directory Structure:
  monorepo/
  ├── apps/
  │   ├── web/           (Next.js frontend)
  │   ├── api/           (Express backend)
  │   └── mobile/        (React Native)
  ├── packages/
  │   ├── ui/            (Shared component library)
  │   ├── utils/         (Shared utilities)
  │   ├── config/        (Shared ESLint, TS configs)
  │   └── types/         (Shared TypeScript types)
  ├── tools/
  ├── package.json       (Root with workspaces)
  ├── turbo.json         (Turborepo config)
  └── pnpm-workspace.yaml

Workspace Managers:
  npm workspaces:     "workspaces": ["packages/*", "apps/*"]
  pnpm workspaces:    pnpm-workspace.yaml
  yarn workspaces:    "workspaces": ["packages/*"]

Build Orchestration:

  Turborepo:
    npx create-turbo@latest
    turbo run build --filter=web
    # Caches builds, runs tasks in parallel
    # Understands dependency graph

  Nx:
    npx create-nx-workspace@latest
    nx build web
    nx affected --target=test
    # Computation caching, affected detection
    # Rich plugin ecosystem

  Lerna (legacy, now Nx-powered):
    npx lerna init
    lerna run build
    lerna publish

Cross-Package References:
  # package.json in apps/web
  {
    "dependencies": {
      "@myorg/ui": "workspace:*",
      "@myorg/utils": "workspace:*"
    }
  }

Benefits:
  ✓ Atomic cross-package changes
  ✓ Shared tooling and configs
  ✓ Single CI/CD pipeline
  ✓ Easier dependency management
  ✓ Code reuse without publishing

Challenges:
  ✗ Large repo size over time
  ✗ CI complexity (need smart task running)
  ✗ Permission management (everyone sees everything)
  ✗ Tooling must support workspaces
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== New Project Checklist ===

Initialization:
  [ ] Choose project name (check npm/PyPI/crates.io availability)
  [ ] Initialize version control (git init)
  [ ] Create directory structure
  [ ] Choose license (MIT, Apache-2.0, GPL-3.0)
  [ ] Write initial README.md

Code Setup:
  [ ] Initialize package manager (npm init, cargo init, etc.)
  [ ] Set up TypeScript / type checking
  [ ] Configure linter (ESLint, ruff, golangci-lint)
  [ ] Configure formatter (Prettier, black, rustfmt)
  [ ] Set up test framework (Jest, pytest, go test)
  [ ] Create .editorconfig

Git Setup:
  [ ] Create comprehensive .gitignore
  [ ] Set up commit hooks (husky, pre-commit)
  [ ] Configure conventional commits (commitlint)
  [ ] Create PR/MR template
  [ ] Set up branch protection rules

Environment:
  [ ] Create .env.example with all required variables
  [ ] Document environment setup in README
  [ ] Pin runtime version (.nvmrc, .python-version)
  [ ] Set up local development scripts (npm run dev, make dev)

CI/CD:
  [ ] Set up CI pipeline (lint, test, build)
  [ ] Configure automated dependency updates (Dependabot, Renovate)
  [ ] Set up code coverage reporting
  [ ] Configure security scanning (Snyk, CodeQL)

Documentation:
  [ ] README: what, why, how to install, how to use
  [ ] CONTRIBUTING.md: how to contribute
  [ ] LICENSE file
  [ ] CHANGELOG.md (start with ## [Unreleased])
  [ ] API documentation setup (if applicable)

Docker (if applicable):
  [ ] Multi-stage Dockerfile
  [ ] .dockerignore
  [ ] docker-compose.yml for local development
  [ ] Health check endpoint

First Commit:
  [ ] git add -A
  [ ] git commit -m "feat: initial project scaffold"
  [ ] Create remote repository
  [ ] git push -u origin main
EOF
}

show_help() {
    cat << EOF
create v$VERSION — Project Scaffolding Reference

Usage: script.sh <command>

Commands:
  intro        Scaffolding overview — why, when, approaches
  structures   Standard directory structures by language
  tools        Popular scaffolding tools and generators
  templates    Template engine patterns and best practices
  configs      Essential config files every project needs
  conventions  Naming, versioning, commits, branching
  monorepo     Monorepo scaffolding with Turborepo, Nx, workspaces
  checklist    New project checklist — idea to first commit
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    structures)  cmd_structures ;;
    tools)       cmd_tools ;;
    templates)   cmd_templates ;;
    configs)     cmd_configs ;;
    conventions) cmd_conventions ;;
    monorepo)    cmd_monorepo ;;
    checklist)   cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "create v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
