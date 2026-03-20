---
name: SSLGen
description: "Generate self-signed SSL certs and CAs for dev environments. Use when creating certs, validating CSRs, generating chains, formatting PEM."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["ssl","certificate","tls","openssl","security","developer"]
categories: ["Developer Tools", "Utility"]
---

# SSLGen — SSL Certificate Generator

Generate, inspect, and verify SSL/TLS certificates from the command line. Powered by OpenSSL.

## Commands

| Command | Description |
|---------|-------------|
| `self-signed <domain>` | Generate a self-signed certificate + private key (RSA 2048, 365 days, with SANs) |
| `csr <domain>` | Generate a Certificate Signing Request + private key |
| `info <certfile>` | Show full certificate details (subject, issuer, SANs, fingerprint, algorithm) |
| `verify <certfile>` | Verify certificate validity and check expiration status |
| `chain <certfile>` | Display the certificate chain (splits PEM bundles) |
| `expiry <certfile>` | Check certificate expiry date with color-coded warnings |

## Examples

```bash
# Generate a self-signed cert for local dev
sslgen self-signed myapp.local
# → Creates myapp.local.key + myapp.local.crt

# Generate a CSR for production
sslgen csr example.com
# → Creates example.com.key + example.com.csr

# Inspect a certificate
sslgen info /etc/ssl/certs/server.crt

# Check if cert is expiring soon
sslgen expiry server.crt

# Verify a certificate
sslgen verify server.crt

# View cert chain
sslgen chain fullchain.pem
```

## Requirements

- `openssl` — must be installed and in PATH

## Output

- `self-signed` and `csr` create files in the current directory named `<domain>.key`, `<domain>.crt`, or `<domain>.csr`
- All other commands output to stdout with color-coded status indicators
- Expiry warnings: green (90+ days), yellow (30-90 days), red (<30 days), expired
