# Web Scraper Pro - Tips

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

## Quick Tips

1. **Start with `text`** — Use `text` command first to understand page structure before using selectors
2. **Use JSON for pipelines** — JSON output (`--format json`) is easiest to pipe into other tools like `jq`
3. **Respect robots.txt** — Always check a site's robots.txt before scraping; be a good netizen
4. **Set timeouts** — Use `--timeout 5` for faster fails on slow sites
5. **Custom User-Agent** — Some sites block default agents; use `--user-agent "Mozilla/5.0..."` for better results
6. **Save large outputs** — Use `--output file.json` to save results instead of flooding stdout
7. **CSS selectors** — The `select` command supports tag names (`p`, `div`), classes (`.article`), and IDs (`#content`)
8. **Combine with jq** — Pipe JSON output to `jq` for filtering: `... --format json | jq '.data[] | select(.tag=="a")'`
9. **Rate limiting** — Add delays between requests when scraping multiple pages to avoid being blocked
10. **Check headers first** — Use `headers` command to check content-type and encoding before scraping
