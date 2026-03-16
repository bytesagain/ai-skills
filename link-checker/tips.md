# Link Checker - Tips

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

## Quick Tips

1. **Start with `summary`** — Get a quick overview before diving into details
2. **Fix broken links first** — Use `broken` command to focus on 404s that hurt SEO
3. **Check redirects** — Use `redirects` to find 301/302 chains that slow down your site
4. **Limit depth** — Use `--depth 1` for quick checks; increase for thorough crawls
5. **External only** — Use `--external-only` to focus on links you can't control
6. **HTML reports** — Use `report` command for shareable HTML reports
7. **Exclude patterns** — Use `--exclude` to skip known-good URLs like CDN assets
8. **Timeout tuning** — Reduce `--timeout` for faster checks, increase for slow external sites
9. **JSON for CI/CD** — Use `--format json` to integrate link checking into build pipelines
10. **Regular scans** — Schedule weekly link checks to catch broken links early
