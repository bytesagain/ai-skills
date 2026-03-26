#!/bin/bash
# Formatter - Code Formatting Tools Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              FORMATTER REFERENCE                            ║
║          Automated Code Formatting Tools                    ║
╚══════════════════════════════════════════════════════════════╝

Code formatters enforce consistent style automatically. Unlike
linters, formatters don't find bugs — they rewrite code to
match style rules. "Format on save" is the standard workflow.

FORMATTERS BY LANGUAGE:
  JavaScript/TS  Prettier, Biome, dprint
  Python         Black, Ruff format, autopep8, YAPF
  Go             gofmt, goimports (built-in)
  Rust           rustfmt (built-in)
  Java           google-java-format, Spotless
  C/C++          clang-format
  Ruby           RuboCop (--auto-correct)
  PHP            PHP-CS-Fixer, Pint (Laravel)
  Shell          shfmt
  SQL            sqlfmt, sql-formatter
  HTML/CSS       Prettier, djLint
  YAML/JSON      Prettier
  Terraform      terraform fmt
  Markdown       Prettier, markdownfmt

PHILOSOPHY:
  Prettier       Opinionated, minimal config
  Black          "Uncompromising" (Python's Prettier)
  gofmt          Zero config, one true style
  clang-format   Highly configurable
  Biome          Lint + format in one tool
EOF
}

cmd_prettier() {
cat << 'EOF'
PRETTIER (JavaScript/TypeScript/HTML/CSS/JSON/YAML/MD)
=========================================================

INSTALL:
  npm install --save-dev prettier

CONFIG (.prettierrc):
  {
    "semi": true,
    "singleQuote": true,
    "trailingComma": "all",
    "printWidth": 80,
    "tabWidth": 2,
    "useTabs": false,
    "bracketSpacing": true,
    "arrowParens": "always",
    "endOfLine": "lf",
    "proseWrap": "preserve",
    "htmlWhitespaceSensitivity": "css",
    "overrides": [
      {
        "files": "*.md",
        "options": { "proseWrap": "always" }
      }
    ]
  }

IGNORE (.prettierignore):
  dist/
  build/
  coverage/
  *.min.js
  package-lock.json

USAGE:
  npx prettier --write .            # Format all files
  npx prettier --check .            # Check only (CI)
  npx prettier --write "src/**/*.ts"  # Specific pattern

EDITOR INTEGRATION:
  # VS Code settings.json
  {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "[javascript]": {
      "editor.defaultFormatter": "esbenp.prettier-vscode"
    }
  }

ESLINT + PRETTIER:
  # eslint.config.js
  import prettier from "eslint-config-prettier";
  export default [
    // ... your ESLint config
    prettier,  // Must be last — disables conflicting rules
  ];

DPRINT (fast alternative):
  npm install -g dprint
  dprint init
  dprint fmt                         # Format
  dprint check                       # Check (CI)
  # 10-30x faster than Prettier
  # Config: dprint.json
EOF
}

cmd_python_go() {
cat << 'EOF'
PYTHON, GO, AND OTHER FORMATTERS
====================================

BLACK (Python):
  pip install black

  # pyproject.toml
  [tool.black]
  line-length = 88
  target-version = ["py312"]
  include = '\.pyi?$'

  black .                            # Format all
  black --check .                    # Check only (CI)
  black --diff .                     # Show changes

RUFF FORMAT (faster Black alternative):
  ruff format .                      # Format
  ruff format --check .              # Check (CI)
  # 100x faster than Black, nearly identical output

GOFMT / GOIMPORTS (Go):
  gofmt -w .                        # Format in place
  gofmt -d .                        # Show diff
  goimports -w .                    # Format + fix imports
  # gofmt is THE standard. No config. No debate.

RUSTFMT (Rust):
  rustfmt src/main.rs               # Format file
  cargo fmt                          # Format entire project
  cargo fmt -- --check               # Check only (CI)

  # rustfmt.toml
  max_width = 100
  tab_spaces = 4
  edition = "2021"

CLANG-FORMAT (C/C++):
  clang-format -i src/*.cpp          # Format in place
  clang-format --style=google -i file.cpp

  # .clang-format
  BasedOnStyle: Google
  IndentWidth: 4
  ColumnLimit: 100
  BreakBeforeBraces: Allman

SHFMT (Shell):
  shfmt -w script.sh                # Format in place
  shfmt -d script.sh                # Show diff
  shfmt -i 2 -ci -w .               # 2-space indent, case indent

PHP-CS-FIXER:
  php-cs-fixer fix src/
  # .php-cs-fixer.php for config

PRE-COMMIT:
  # .pre-commit-config.yaml
  repos:
    - repo: https://github.com/pre-commit/mirrors-prettier
      rev: v3.3.0
      hooks:
        - id: prettier
    - repo: https://github.com/psf/black-pre-commit-mirror
      rev: 24.8.0
      hooks:
        - id: black

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Formatter - Code Formatting Tools Reference

Commands:
  intro       Overview, formatters by language
  prettier    Prettier config, ESLint integration, dprint
  python_go   Black, Ruff, gofmt, rustfmt, clang-format, shfmt

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)     cmd_intro ;;
  prettier)  cmd_prettier ;;
  python_go) cmd_python_go ;;
  help|*)    show_help ;;
esac
