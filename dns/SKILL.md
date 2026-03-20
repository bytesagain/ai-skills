---
name: "dns"
version: "1.0.0"
description: "Query DNS records with A, MX, NS, and TXT lookups. Use when debugging DNS or checking propagation."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# dns

Query DNS records with A, MX, NS, and TXT lookups. Use when debugging DNS or checking propagation.

## Commands

### `lookup`

```bash
scripts/script.sh lookup <domain>
```

### `mx`

```bash
scripts/script.sh mx <domain>
```

### `ns`

```bash
scripts/script.sh ns <domain>
```

### `txt`

```bash
scripts/script.sh txt <domain>
```

### `all`

```bash
scripts/script.sh all <domain>
```

### `reverse`

```bash
scripts/script.sh reverse <ip>
```

## Data Storage

Data stored in `~/.local/share/dns/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
