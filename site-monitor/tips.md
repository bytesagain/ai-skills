# Site Monitor - Tips

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

## Quick Tips

1. **Start with `check`** — Verify a single URL works before setting up batch monitoring
2. **Use `cron` for automation** — The `cron` command outputs single-line results perfect for cron jobs
3. **Set meaningful thresholds** — Tune `--warn-ms` and `--crit-ms` based on your site's normal response time
4. **Monitor SSL early** — Use `--ssl-warn-days 60` to catch expiring certificates well in advance
5. **Log everything** — Always use `--log` to keep history for trend analysis
6. **Exit codes matter** — 0=OK, 1=WARNING, 2=CRITICAL — use these in scripts for alerting
7. **Batch monitoring** — Put all your URLs in a file, one per line, and use `batch` command
8. **JSON for dashboards** — Use `--format json` for easy integration with monitoring dashboards
9. **Quiet mode for cron** — Use `--quiet` to only get output when something is wrong
10. **Combine with mail** — Pipe critical alerts to `mail` or webhook for notifications
