---
name: HtPasswd
description: "Generate htpasswd entries for Apache/Nginx basic auth password management. Use when creating credentials, managing password files, or verifying users."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["htpasswd","password","auth","apache","nginx","security"]
categories: ["Developer Tools", "Utility"]
---

# HtPasswd

A real htpasswd file manager for Apache/Nginx HTTP basic authentication. Create password files, add/remove users, verify passwords, and list users. Supports apr1 (Apache MD5), SHA-256, and SHA-512 hash algorithms via `openssl`.

## Commands

| Command | Description |
|---------|-------------|
| `htpasswd create <file> <user> <password>` | Create a new htpasswd file with the first user (fails if file exists) |
| `htpasswd add <file> <user> <password>` | Add a user to an existing file (or update password if user exists) |
| `htpasswd delete <file> <user>` | Remove a user from the htpasswd file |
| `htpasswd verify <file> <user> <password>` | Verify a user's password (supports apr1, sha256, sha512, sha1, crypt) |
| `htpasswd list <file>` | List all users with their hash algorithm type |
| `htpasswd version` | Show version |
| `htpasswd help` | Show available commands and usage |

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `HTPASSWD_ALGO` | `apr1` | Hash algorithm: `apr1`, `sha256`, or `sha512` |

## Requirements

- Bash 4+ (`set -euo pipefail`)
- `openssl` — for password hashing and verification
- `grep`, `sed` — standard text utilities
- No external dependencies or API keys

## When to Use

1. **Setting up basic auth** — `htpasswd create /etc/nginx/.htpasswd admin secret` to create a new file
2. **Managing users** — `htpasswd add` to add users, `htpasswd delete` to remove them
3. **Password verification** — `htpasswd verify` to check if a password is correct
4. **Security audits** — `htpasswd list` shows all users and their hash types
5. **Stronger hashing** — Set `HTPASSWD_ALGO=sha512` for SHA-512 instead of default apr1

## Examples

```bash
# Create a new htpasswd file
htpasswd create /etc/nginx/.htpasswd admin MySecretPass

# Add another user
htpasswd add /etc/nginx/.htpasswd editor AnotherPass

# Use SHA-512 for stronger hashing
HTPASSWD_ALGO=sha512 htpasswd add /etc/nginx/.htpasswd secure_user StrongPass

# List all users
htpasswd list /etc/nginx/.htpasswd

# Verify a password
htpasswd verify /etc/nginx/.htpasswd admin MySecretPass

# Delete a user
htpasswd delete /etc/nginx/.htpasswd editor
```

### Example Output

```
$ htpasswd create /tmp/.htpasswd admin secret123
┌──────────────────────────────────────────────────┐
│  htpasswd File Created                           │
├──────────────────────────────────────────────────┤
│  File:     /tmp/.htpasswd                         │
│  User:     admin                                  │
│  Algo:     apr1                                   │
│  Perms:    640 (owner rw, group r)                │
├──────────────────────────────────────────────────┤
│  ✅ File created with 1 user                     │
└──────────────────────────────────────────────────┘

$ htpasswd list /tmp/.htpasswd
┌──────────────────────────────────────────────────┐
│  htpasswd Users                                  │
├──────────────────────────────────────────────────┤
│  File:  /tmp/.htpasswd                            │
│  Users: 2                                         │
├──────────────────────────────────────────────────┤
│   1. admin                [apr1 (MD5)      ]      │
│   2. editor               [sha512          ]      │
└──────────────────────────────────────────────────┘

$ htpasswd verify /tmp/.htpasswd admin secret123
┌──────────────────────────────────────────────────┐
│  Password Verification                           │
├──────────────────────────────────────────────────┤
│  File:     /tmp/.htpasswd                         │
│  User:     admin                                  │
│  Result:   ✅ Password CORRECT                   │
└──────────────────────────────────────────────────┘
```

## Security Notes

- Files are created with `640` permissions (owner read/write, group read)
- Default algorithm is `apr1` (Apache MD5) — widely compatible
- Use `HTPASSWD_ALGO=sha512` for stronger hashing on modern systems
- Usernames cannot contain `:` or whitespace characters
- Existing users get their password replaced when using `add`

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
