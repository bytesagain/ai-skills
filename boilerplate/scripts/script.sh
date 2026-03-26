#!/bin/bash
# Boilerplate - Project Scaffolding Tools Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              BOILERPLATE REFERENCE                          ║
║          Project Scaffolding & Templates                    ║
╚══════════════════════════════════════════════════════════════╝

Scaffolding tools generate project structures, configs, and
boilerplate code so you start with best practices instead of
from scratch.

OFFICIAL SCAFFOLDERS:
  React        npx create-react-app my-app (legacy)
  Next.js      npx create-next-app@latest my-app
  Vite         npm create vite@latest my-app
  Vue          npm create vue@latest my-app
  Svelte       npx sv create my-app
  Angular      npx @angular/cli new my-app
  Remix        npx create-remix@latest my-app
  Astro        npm create astro@latest my-app
  Nuxt         npx nuxi@latest init my-app
  Nest.js      npx @nestjs/cli new my-app
  Express      npx express-generator my-app
  Fastify      npx fastify-cli generate my-app
  Django       django-admin startproject myproject
  Flask        (no official, use cookiecutter)
  Rails        rails new my-app
  Spring       start.spring.io (Spring Initializr)
  Go           go mod init github.com/user/project
  Rust         cargo new my-project
  .NET         dotnet new webapi -n MyApi

META SCAFFOLDERS:
  Yeoman       yo <generator> (community generators)
  Cookiecutter cookiecutter <template> (Python)
  Degit        npx degit user/repo my-project (Git clone)
  Plop         npx plop (custom file generators)
  Hygen        npx hygen component new --name Button
  Nx           npx create-nx-workspace (monorepo)
  Turborepo    npx create-turbo@latest (monorepo)
EOF
}

cmd_modern() {
cat << 'EOF'
MODERN FRAMEWORK SCAFFOLDING
================================

NEXT.JS:
  npx create-next-app@latest my-app \
    --typescript --tailwind --eslint \
    --app --src-dir --import-alias "@/*"

  # Generated structure:
  my-app/
  ├── src/
  │   ├── app/
  │   │   ├── layout.tsx       # Root layout
  │   │   ├── page.tsx         # Home page
  │   │   ├── globals.css
  │   │   └── api/             # API routes
  │   └── components/
  ├── public/
  ├── next.config.ts
  ├── tailwind.config.ts
  ├── tsconfig.json
  └── package.json

VITE (any framework):
  npm create vite@latest my-app -- --template react-ts
  # Templates: react, react-ts, vue, vue-ts, svelte, svelte-ts,
  #            preact, lit, vanilla, vanilla-ts

ASTRO:
  npm create astro@latest my-site
  # Prompts: template, TypeScript, strict mode, git
  # Templates: basics, blog, portfolio, starlight (docs)

T3 STACK (Next.js + tRPC + Prisma + Tailwind):
  npm create t3-app@latest my-app
  # Full-stack TypeScript with end-to-end type safety

MONOREPO:
  npx create-turbo@latest my-monorepo
  # Turborepo + pnpm workspaces

  my-monorepo/
  ├── apps/
  │   ├── web/                 # Next.js app
  │   └── docs/                # Docs site
  ├── packages/
  │   ├── ui/                  # Shared components
  │   ├── eslint-config/       # Shared ESLint
  │   └── typescript-config/   # Shared tsconfig
  ├── turbo.json
  └── package.json

DJANGO:
  django-admin startproject myproject
  cd myproject
  python manage.py startapp myapp

  myproject/
  ├── myproject/
  │   ├── settings.py
  │   ├── urls.py
  │   └── wsgi.py
  ├── myapp/
  │   ├── models.py
  │   ├── views.py
  │   ├── urls.py
  │   └── tests.py
  └── manage.py
EOF
}

cmd_custom() {
cat << 'EOF'
CUSTOM SCAFFOLDING TOOLS
===========================

COOKIECUTTER (Python, any language):
  pip install cookiecutter

  # Use a template
  cookiecutter https://github.com/audreyr/cookiecutter-pypackage
  cookiecutter gh:tiangolo/full-stack-fastapi-template

  # Template structure
  {{cookiecutter.project_name}}/
  ├── {{cookiecutter.project_slug}}/
  │   ├── __init__.py
  │   └── main.py
  ├── tests/
  ├── setup.py
  └── README.md

  # cookiecutter.json
  {
    "project_name": "My Project",
    "project_slug": "{{ cookiecutter.project_name|lower|replace(' ', '_') }}",
    "version": "0.1.0",
    "use_docker": ["yes", "no"]
  }

PLOP (micro-generator):
  npm install plop

  // plopfile.js
  export default function (plop) {
    plop.setGenerator('component', {
      description: 'React component',
      prompts: [{
        type: 'input',
        name: 'name',
        message: 'Component name?',
      }],
      actions: [{
        type: 'add',
        path: 'src/components/{{pascalCase name}}/index.tsx',
        templateFile: 'plop-templates/component.tsx.hbs',
      }, {
        type: 'add',
        path: 'src/components/{{pascalCase name}}/styles.module.css',
        templateFile: 'plop-templates/styles.css.hbs',
      }],
    });
  }

  npx plop component

HYGEN (fast code generator):
  npx hygen init self
  npx hygen generator new component

  # _templates/component/new/index.tsx.ejs.t
  ---
  to: src/components/<%= name %>/index.tsx
  ---
  export function <%= name %>() {
    return <div><%= name %></div>;
  }

  npx hygen component new --name Button

DEGIT (lightweight git clone):
  npx degit user/repo my-project
  npx degit sveltejs/template my-svelte-app
  npx degit user/repo/subfolder my-project  # Subdirectory!
  # No .git history — clean start

ESSENTIAL FILES CHECKLIST:
  ✅ .gitignore           (gitignore.io)
  ✅ .editorconfig        (consistent editor settings)
  ✅ .nvmrc / .node-version  (pin Node version)
  ✅ .env.example          (document env vars)
  ✅ LICENSE               (choose one: MIT, Apache, GPL)
  ✅ README.md             (project description)
  ✅ CONTRIBUTING.md       (how to contribute)
  ✅ .github/workflows/    (CI/CD)
  ✅ Dockerfile            (containerization)

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Boilerplate - Project Scaffolding Reference

Commands:
  intro    Overview, scaffolding tools
  modern   Next.js, Vite, Astro, T3, Django
  custom   Cookiecutter, Plop, Hygen, Degit

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)   cmd_intro ;;
  modern)  cmd_modern ;;
  custom)  cmd_custom ;;
  help|*)  show_help ;;
esac
