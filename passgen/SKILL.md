---
name: PassGen
description: "Secure password generator with multiple modes. Generate strong random passwords with customizable length, create numeric PINs, build memorable passphrases from word lists, and check existing password strength with detailed scoring. Uses cryptographically secure randomness."
version: "2.0.0"
author: "BytesAgain"
tags: ["password","security","generator","random","pin","passphrase","crypto","privacy"]
categories: ["Security", "Utility", "Developer Tools"]
---

# PassGen

Generate strong passwords. Check weak ones. Stay secure.

## Commands

- `generate [length] [count]` — Generate random passwords (default: 16 chars, 1 password)
- `pin [length]` — Generate numeric PIN (default: 6 digits)
- `phrase [words]` — Generate memorable passphrase (default: 4 words)
- `check <password>` — Check password strength with detailed scoring
- `help` — Show commands

## Usage Examples

```bash
passgen generate 20 5
passgen pin 8
passgen phrase 5
passgen check MyP@ssw0rd123
```

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

- Run `passgen help` for all commands
