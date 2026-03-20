---
name: "credential-tester"
version: "3.0.0"
description: "Test authentication credentials against HTTP, SSH, and FTP services. Use when validating access credentials."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# credential-tester

Test authentication credentials against HTTP, SSH, and FTP services. Use when validating access credentials.

## Commands

### `http`

```bash
scripts/script.sh http <url user pass>
```

### `ssh`

```bash
scripts/script.sh ssh <host user>
```

### `check-env`

```bash
scripts/script.sh check-env
```

### `report`

```bash
scripts/script.sh report
```

### `ports`

```bash
scripts/script.sh ports <host>
```

### `validate`

```bash
scripts/script.sh validate <token>
```

## Data Storage

Data stored in `~/.local/share/credential-tester/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
