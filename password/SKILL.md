---
name: password
version: "3.0.1"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
license: MIT-0
tags: [password, tool, utility]
description: "Manage passwords with generation, strength checks, and storage. Use when creating credentials, auditing strength, rotating secrets, checking breaches."
---

# password

Generate, check, and analyze passwords.

## Commands

### `generate`

Generate a random password (default: 16 chars)

```bash
scripts/script.sh generate
```

### `strength`

Rate password strength (weak/fair/good/strong/excellent)

```bash
scripts/script.sh strength
```

### `entropy`

Calculate Shannon entropy in bits

```bash
scripts/script.sh entropy
```

### `batch`

Generate multiple passwords at once

```bash
scripts/script.sh batch
```

### `diceware`

Generate a diceware-style passphrase

```bash
scripts/script.sh diceware
```

### `pin`

Generate a numeric PIN

```bash
scripts/script.sh pin
```

## Requirements

- curl

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
