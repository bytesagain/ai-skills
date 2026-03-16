# DNS Lookup - Tips

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

## Quick Tips

1. **Start with `lookup`** — Gets all common record types in one query
2. **Check propagation** — Use `--server` with different DNS servers (8.8.8.8, 1.1.1.1) to verify propagation
3. **MX for email issues** — `mx` command quickly diagnoses email delivery problems
4. **TXT for verification** — Check TXT records for SPF, DKIM, and domain verification entries
5. **Reverse lookups** — Use `ptr` to find the hostname associated with an IP address
6. **Zone file format** — Use `--format zone` for output compatible with DNS zone files
7. **Batch lookups** — Put multiple domains in a file for efficient bulk queries
8. **Compare DNS** — Use `compare` to spot differences when migrating between DNS providers
9. **JSON for scripts** — Use `--format json` when parsing results programmatically
10. **Custom timeout** — Reduce `--timeout` for faster batch lookups on reliable networks
