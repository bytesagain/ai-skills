# SSL Checker - Tips

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

## Quick Tips

1. **Check expiry regularly** — Use `expiry` command in cron to catch certificates before they expire
2. **Monitor batch domains** — Put all your domains in a file and use `monitor` for portfolio checks
3. **Verify the chain** — Use `chain` command to ensure intermediate certificates are properly configured
4. **Non-standard ports** — Use `--port` for checking mail servers (993, 587) or custom services
5. **SNI support** — Use `--sni` when checking domains behind shared hosting or CDNs
6. **Exit codes for alerting** — 0=OK, 1=WARN, 2=CRITICAL — perfect for Nagios/monitoring integration
7. **JSON for dashboards** — Use `--format json` to feed certificate data into monitoring dashboards
8. **Protocol checks** — Use `protocols` to verify old TLS 1.0/1.1 is disabled for security
9. **Cipher audit** — Use `ciphers` to check for weak cipher suites
10. **Set aggressive thresholds** — Use `--warn-days 60` for production sites to allow renewal time
