# Tips for makefile-generator

## Quick Start
- Use `generate` to create a complete Makefile for your project
- Run `make help` to see all available targets
- Start with a language-specific template, then customize

## Best Practices
- **Self-documenting targets** — Add `## description` after each target
- **Use .PHONY** — Declare all non-file targets as .PHONY
- **Variables at top** — Define all configurable values as variables
- **Default target** — First target should be `help` or `all`
- **Include guards** — Use `-include` for optional config files
- **Tab indentation** — Makefiles require tabs, not spaces (this tool handles it)

## Common Patterns
- `generate --lang node` — npm/yarn/pnpm build targets
- `generate --lang python` — pip/poetry/pipenv targets
- `generate --lang go` — Go build, test, vet, lint targets
- `docker` — Add container lifecycle targets to any project
- `monorepo` — Orchestrate builds across sub-projects

## Useful Targets to Include
- `make dev` — Start development server
- `make test` — Run all tests
- `make lint` — Run linters
- `make build` — Build for production
- `make clean` — Remove build artifacts
- `make docker-build` — Build Docker image
- `make help` — Show all targets with descriptions

## Troubleshooting
- "Missing separator" → Ensure tabs (not spaces) for recipe lines
- Variables not expanding → Use `$$` for shell variables in recipes
- Target not running → Check if a file with that name exists (use .PHONY)

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
