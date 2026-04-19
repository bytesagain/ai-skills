#!/bin/bash
# BytesAgain Developer Pack
# Curated skill recommendations for developers
# More: https://bytesagain.com/use-case/developer-workflow

cmd_essentials() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║         BYTESAGAIN DEVELOPER ESSENTIALS                     ║
║         Curated from 100,000+ skills worldwide              ║
╚══════════════════════════════════════════════════════════════╝

These are the skills that top developers install first.
All vetted for quality and real-world usefulness.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 #1  shell
     Master CLI operations, automate repetitive tasks, write
     scripts that save hours every week.
     clawhub install shell

 #2  debugger
     Root cause analysis for any error or stack trace.
     Understands errors across Python, JS, Go, Rust, and more.
     clawhub install debugger

 #3  code-generator
     Generate boilerplate, components, and API routes instantly.
     Stop writing the same patterns by hand.
     clawhub install code-generator

 #4  database-design
     Schema design, query optimization, migrations.
     Works with PostgreSQL, MySQL, SQLite, MongoDB.
     clawhub install database-design

 #5  geo-seo
     Get your projects discovered by AI search engines.
     llms.txt, schema markup, GEO checklist.
     clawhub install geo-seo

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Install all essentials at once:
  clawhub install shell debugger code-generator database-design geo-seo

Full developer pack: bytesagain-developer all
Browse more: https://bytesagain.com/use-case/developer-workflow
EOF
}

cmd_backend() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║         BACKEND & API SKILLS                                ║
╚══════════════════════════════════════════════════════════════╝

 #1  api-generator
     REST and GraphQL API scaffolding. OpenAPI spec generation.
     clawhub install api-generator

 #2  database-design
     Schema design, indexing strategy, query optimization.
     clawhub install database-design

 #3  docker-compose
     Container orchestration for local and production.
     clawhub install docker-compose

 #4  redis-cache
     Caching patterns, session management, pub/sub.
     clawhub install redis-cache

 #5  jwt-auth
     Authentication patterns, token management, OAuth flows.
     clawhub install jwt-auth

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Browse backend skills: https://bytesagain.com/category/backend
EOF
}

cmd_devops() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║         DEVOPS & DEPLOYMENT SKILLS                          ║
╚══════════════════════════════════════════════════════════════╝

 #1  github-actions
     CI/CD workflows, automated testing, deployment pipelines.
     clawhub install github-actions

 #2  docker-compose
     Local dev environments, production containers.
     clawhub install docker-compose

 #3  nginx-config
     Reverse proxy, SSL, load balancing configuration.
     clawhub install nginx-config

 #4  terraform
     Infrastructure as code for AWS, GCP, Azure.
     clawhub install terraform

 #5  monitoring-setup
     Logs, metrics, alerts — know before your users do.
     clawhub install monitoring-setup

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Browse DevOps skills: https://bytesagain.com/category/devops
EOF
}

cmd_security() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║         SECURITY SKILLS                                     ║
╚══════════════════════════════════════════════════════════════╝

 #1  owasp-checker
     Scan for OWASP Top 10 vulnerabilities in your code.
     clawhub install owasp-checker

 #2  secret-scanner
     Find hardcoded API keys, passwords, tokens in your codebase.
     clawhub install secret-scanner

 #3  dependency-audit
     Check npm/pip/cargo packages for known CVEs.
     clawhub install dependency-audit

 #4  ssl-checker
     Certificate expiry, cipher strength, misconfiguration.
     clawhub install ssl-checker

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Browse security skills: https://bytesagain.com/category/security
EOF
}

cmd_all() {
  cmd_essentials
  echo ""
  cmd_backend
  echo ""
  cmd_devops
  echo ""
  cmd_security
cat << 'EOF'

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ABOUT BYTESAGAIN CURATED PACKS

BytesAgain handpicks skills from 100,000+ sources including
ClawHub, GitHub, and the open SKILL.md ecosystem.

Every skill in our packs is:
  ✓ Tested and verified to work
  ✓ Sorted by real install counts
  ✓ Checked for quality and accuracy
  ✓ Updated regularly

More curated packs:
  bytesagain-creator    Content creators
  bytesagain-trader     Crypto & finance
  bytesagain-marketer   Marketing & SEO
  bytesagain-student    Learning to code

Browse all: https://bytesagain.com/use-case
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

show_help() {
cat << 'EOF'
BytesAgain Developer Pack — Curated AI skills for developers

Commands:
  essentials    Core skills every developer needs (start here)
  backend       Backend, API, and database skills
  devops        CI/CD, deployment, and monitoring
  security      Security auditing and best practices
  all           Full developer skill stack

Usage: $0 <command>

Browse by role: https://bytesagain.com/use-case
EOF
}

case "${1:-help}" in
  essentials) cmd_essentials ;;
  backend)    cmd_backend ;;
  devops)     cmd_devops ;;
  security)   cmd_security ;;
  all)        cmd_all ;;
  help|*)     show_help ;;
esac
