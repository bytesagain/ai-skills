---
version: "2.0.0"
name: keyvault
description: "Password generator and credential manager. Use when you need to generate strong passwords, PINs, passphrases, save and retrieve credentials, audit password strength, or manage login information securely. Triggers on: password, credential, PIN, passphrase, login, vault, security, generate password."
---

# Password Vault

Password Vault — generate & manage passwords

## Why This Skill?

- Designed for everyday personal use
- No external dependencies or accounts needed
- Simple commands, powerful results

## Commands

- `generate` — [len]        Generate strong password (default 16)
- `generate-pin` — [len]    Generate numeric PIN (default 6)
- `generate-phrase` — [n]   Generate passphrase (default 4 words)
- `save` — <site> <user>    Save credential (prompts for password)
- `list` —                  List saved sites
- `get` — <site>            Retrieve credential
- `search` — <query>        Search credentials
- `delete` — <site>         Remove credential
- `audit` —                 Password strength audit
- `export` —                Export as encrypted JSON
- `stats` —                 Vault statistics
- `info` —                  Version info

## Quick Start

```bash
password_vault.sh help
```

> **Note**: This is an original, independent implementation by BytesAgain. Not affiliated with or derived from any third-party project.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
