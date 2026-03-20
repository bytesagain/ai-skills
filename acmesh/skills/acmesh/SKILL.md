---
name: "acmesh"
version: "3.0.0"
description: "Manage ACME/SSL certificates with issuance, renewal, and revocation. Use when provisioning certs or checking SSL status."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# acmesh

Manage ACME/SSL certificates with issuance, renewal, and revocation. Use when provisioning certs or checking SSL status.

## Commands

### `issue`

```bash
scripts/script.sh issue <domain>
```

### `list`

```bash
scripts/script.sh list
```

### `info`

```bash
scripts/script.sh info <domain>
```

### `renew`

```bash
scripts/script.sh renew <domain>
```

### `revoke`

```bash
scripts/script.sh revoke <domain>
```

### `check`

```bash
scripts/script.sh check <domain>
```

## Data Storage

Data stored in `~/.local/share/acmesh/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
