# Deploy Helper Tips

1. **Multi-stage builds** — Use Docker multi-stage builds. Production image carries only runtime deps, halving image size
2. **Don't forget .dockerignore** — Keep `node_modules`, `.git`, and test files out of your image
3. **Run as non-root** — Add `USER node` or `USER appuser` at the end of your Dockerfile. Security 101
4. **Nginx caching** — Set `expires 30d` for static assets, `proxy_pass` for API routes. Clean separation
5. **Auto-renew SSL** — Let's Encrypt certs expire in 90 days. Set up a certbot cron job for auto-renewal
6. **Cache CI dependencies** — Use `actions/cache` in GitHub Actions for node_modules. Cuts build time 60%
7. **K8s health probes** — Always configure `readinessProbe` and `livenessProbe`. Rolling updates break without them
8. **Secrets over env files** — Use platform secrets for sensitive values, not `.env` files in production
