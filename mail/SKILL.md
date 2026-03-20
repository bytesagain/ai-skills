---
name: "mail"
version: "1.0.0"
description: "Validate emails, check MX records, and manage email templates locally. Use when verifying addresses, checking domains, or drafting messages."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# mail

Validate emails, check MX records, and manage email templates locally. Use when verifying addresses, checking domains, or drafting messages.

## Commands

### `validate`

```bash
scripts/script.sh validate <email>
```

### `mx`

```bash
scripts/script.sh mx <domain>
```

### `compose`

```bash
scripts/script.sh compose <to subject body>
```

### `template`

```bash
scripts/script.sh template <name>
```

### `save-template`

```bash
scripts/script.sh save-template <name text>
```

### `batch-validate`

```bash
scripts/script.sh batch-validate <file>
```

## Data Storage

Data stored in `~/.local/share/mail/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
