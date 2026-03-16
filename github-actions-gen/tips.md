# Tips for github-actions-gen

## Quick Start
- Use `ci` for pull request checks (test, lint, build)
- Use `cd` for deployment pipelines triggered on merge
- Use `docker` for container build and push workflows

## Best Practices
- **Pin action versions** — Use SHA hashes, not tags: `actions/checkout@v4` → `actions/checkout@abcdef`
- **Use caching** — Always enable dependency caching to speed up builds
- **Minimal permissions** — Use `permissions:` block to restrict GITHUB_TOKEN scope
- **Matrix builds** — Test across versions to catch compatibility issues early
- **Concurrency** — Use `concurrency:` to cancel redundant runs
- **Reusable workflows** — Extract common patterns into callable workflows

## Common Patterns
- `ci --lang node` — Standard Node.js test/lint/build pipeline
- `cd --target aws --service ecs` — Deploy to AWS ECS on merge
- `docker --registry ghcr --cache` — Build and push with layer caching
- `terraform --provider aws` — Plan on PR, apply on main merge
- `release --lang node --registry npm` — Automated npm publishing

## Performance Tips
- Enable dependency caching to save 30-60s per run
- Use matrix strategy for parallel testing
- Set `concurrency` groups to avoid wasted compute
- Use `paths:` filter to skip workflows when irrelevant files change

## Security
- Never hardcode secrets in workflow files
- Use environment-level secrets for production deployments
- Enable required status checks on protected branches
- Use `pull_request_target` carefully — it has write permissions

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
