---
name: "geoip"
version: "3.0.0"
description: "Look up geographic location of IP addresses using ip-api.com. Use when tracing IPs. Requires curl."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# geoip

Look up geographic location of IP addresses using ip-api.com. Use when tracing IPs. Requires curl.

## Commands

### `lookup`

```bash
scripts/script.sh lookup <ip>
```

### `self`

```bash
scripts/script.sh self
```

### `batch`

```bash
scripts/script.sh batch <file>
```

### `whois`

```bash
scripts/script.sh whois <ip>
```

### `dns`

```bash
scripts/script.sh dns <domain>
```

### `trace`

```bash
scripts/script.sh trace <ip>
```

## Data Storage

Data stored in `~/.local/share/geoip/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
