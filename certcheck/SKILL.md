---
name: CertCheck
description: "SSL/TLS certificate checker and analyzer. Inspect SSL certificates for any domain, check expiration dates, verify certificate chain, detect security issues, and monitor certificate validity. Get alerted before your SSL certificates expire."
version: "2.0.0"
author: "BytesAgain"
tags: ["ssl","tls","certificate","security","https","expiry","domain","devops"]
categories: ["Security", "System Tools", "Developer Tools"]
---
# CertCheck
Check SSL certificates. Catch expiring certs before they break your site.
## Commands
- `check <domain>` — Full certificate inspection
- `expiry <domain>` — Days until expiration
- `chain <domain>` — Show certificate chain
- `batch <file>` — Check multiple domains from file
## Usage Examples
```bash
certcheck check google.com
certcheck expiry github.com
certcheck chain example.com
```
---
Powered by BytesAgain | bytesagain.com

- Run `certcheck help` for all commands

## When to Use

- to automate certcheck tasks in your workflow
- for batch processing certcheck operations

## Output

Returns results to stdout. Redirect to a file with `certcheck run > output.txt`.

## Configuration

Set `CERTCHECK_DIR` environment variable to change the data directory. Default: `~/.local/share/certcheck/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
