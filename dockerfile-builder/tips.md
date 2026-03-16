# Tips for dockerfile-builder

## Quick Start
- Use `generate` for simple single-stage Dockerfiles
- Use `multistage` for production builds that need minimal image sizes
- Always generate a `.dockerignore` alongside your Dockerfile

## Best Practices
- **Always pin versions** — Use specific tags like `node:20-alpine` not `node:latest`
- **Use Alpine images** — They're ~5MB vs ~100MB for Debian-based
- **Multi-stage builds** — Separate build dependencies from runtime
- **Non-root users** — Never run containers as root in production
- **Layer ordering** — Put rarely-changing layers first for cache efficiency
- **.dockerignore** — Always create one to reduce build context size

## Common Patterns
- `generate --lang node` — Express/Fastify/NestJS apps
- `generate --lang python` — Django/Flask/FastAPI apps
- `multistage --lang go` — Go binaries (final image can be <10MB)
- `multistage --lang rust` — Rust binaries with minimal runtime
- `compose --services "app,db,cache"` — Full stack setups

## Troubleshooting
- If build is slow, check your `.dockerignore` — `node_modules/` and `.git/` should be excluded
- For permission issues, ensure the non-root user owns the app directory
- Use `--no-cache` flag when debugging layer caching issues

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
