#!/bin/bash
# Linter - Code Quality Analysis Tools Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              LINTER REFERENCE                               ║
║          Code Quality & Static Analysis Tools               ║
╚══════════════════════════════════════════════════════════════╝

Linters analyze source code for bugs, style violations, and
anti-patterns without executing it. Essential for code quality.

LINTERS BY LANGUAGE:
  JavaScript/TS  ESLint, Biome, oxlint
  Python         Ruff, Pylint, Flake8, mypy
  Go             golangci-lint, staticcheck
  Rust           Clippy (built-in)
  Java           Checkstyle, PMD, SpotBugs
  C/C++          clang-tidy, cppcheck
  Ruby           RuboCop
  PHP            PHP_CodeSniffer, PHPStan, Psalm
  Shell          ShellCheck
  CSS            Stylelint
  SQL            sqlfluff
  Docker         hadolint
  YAML           yamllint
  Markdown       markdownlint
  Terraform      tflint, tfsec

LINT TYPES:
  Style          Formatting, naming conventions
  Logic          Potential bugs, dead code
  Security       SQL injection, XSS, secrets
  Performance    N+1 queries, unnecessary allocations
  Complexity     Cyclomatic complexity, nesting depth
  Type           Type errors (mypy, TypeScript)
  Accessibility  a11y issues in HTML/JSX
EOF
}

cmd_javascript() {
cat << 'EOF'
JAVASCRIPT / TYPESCRIPT LINTING
==================================

ESLINT:
  npm init @eslint/config

  # eslint.config.js (flat config, ESLint 9+)
  import js from "@eslint/js";
  import tsPlugin from "@typescript-eslint/eslint-plugin";
  import tsParser from "@typescript-eslint/parser";

  export default [
    js.configs.recommended,
    {
      files: ["**/*.ts", "**/*.tsx"],
      languageOptions: { parser: tsParser },
      plugins: { "@typescript-eslint": tsPlugin },
      rules: {
        "no-unused-vars": "off",
        "@typescript-eslint/no-unused-vars": "error",
        "no-console": "warn",
        "eqeqeq": ["error", "always"],
        "prefer-const": "error",
        "no-var": "error",
      },
    },
    { ignores: ["dist/", "node_modules/"] },
  ];

  npx eslint .                      # Lint all files
  npx eslint --fix .                # Auto-fix
  npx eslint --cache .              # Cache results (faster)

BIOME (ESLint + Prettier replacement):
  npm install --save-dev @biomejs/biome
  npx biome init

  # biome.json
  {
    "linter": {
      "enabled": true,
      "rules": {
        "recommended": true,
        "complexity": { "noForEach": "warn" },
        "suspicious": { "noExplicitAny": "error" }
      }
    },
    "formatter": { "indentStyle": "space", "indentWidth": 2 }
  }

  npx biome check .                 # Lint + format
  npx biome check --apply .         # Auto-fix

OXLINT (Rust-based, 50-100x faster):
  npx oxlint .
  # Meant to complement ESLint, not replace it
  # Great for CI pre-check (runs in seconds on huge codebases)
EOF
}

cmd_python() {
cat << 'EOF'
PYTHON LINTING
================

RUFF (fastest, replaces Flake8 + isort + pyupgrade):
  pip install ruff

  # ruff.toml (or pyproject.toml [tool.ruff])
  line-length = 88
  target-version = "py312"

  [lint]
  select = [
      "E",    # pycodestyle errors
      "W",    # pycodestyle warnings
      "F",    # pyflakes
      "I",    # isort
      "N",    # pep8-naming
      "UP",   # pyupgrade
      "B",    # flake8-bugbear
      "S",    # flake8-bandit (security)
      "C4",   # flake8-comprehensions
      "SIM",  # flake8-simplify
      "RUF",  # ruff-specific rules
  ]
  ignore = ["E501"]  # Line too long

  ruff check .                      # Lint
  ruff check --fix .                # Auto-fix
  ruff format .                     # Format (like Black)

MYPY (type checking):
  pip install mypy

  # mypy.ini
  [mypy]
  python_version = 3.12
  strict = true
  warn_return_any = true
  warn_unused_configs = true
  disallow_untyped_defs = true

  # Per-module overrides
  [mypy-tests.*]
  disallow_untyped_defs = false

  mypy src/                         # Type check

PYLINT:
  pip install pylint
  pylint src/                       # Full analysis
  pylint --disable=C0114,C0115 src/ # Skip docstring checks

CI PIPELINE:
  # .github/workflows/lint.yml
  - name: Ruff
    run: |
      pip install ruff
      ruff check .
      ruff format --check .
  - name: Mypy
    run: |
      pip install mypy
      mypy src/

PRE-COMMIT:
  # .pre-commit-config.yaml
  repos:
    - repo: https://github.com/astral-sh/ruff-pre-commit
      rev: v0.6.0
      hooks:
        - id: ruff
          args: [--fix]
        - id: ruff-format
    - repo: https://github.com/pre-commit/mirrors-mypy
      rev: v1.11.0
      hooks:
        - id: mypy

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Linter - Code Quality Analysis Tools Reference

Commands:
  intro       Overview, linters by language
  javascript  ESLint, Biome, oxlint
  python      Ruff, mypy, Pylint, pre-commit

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  javascript) cmd_javascript ;;
  python)     cmd_python ;;
  help|*)     show_help ;;
esac
