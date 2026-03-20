---
name: SSHKey
description: "Generate, list, copy, and test SSH keys without complex flags. Use when scanning keys, monitoring expiry, reporting fingerprints, alerting weak algorithms."
version: "3.0.1"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["ssh","key","security","authentication","crypto","server","admin","devops"]
categories: ["Security", "System Tools", "Developer Tools"]
---

# sshkey

SSH key manager.

## Commands

### `generate`

Generate new SSH key (ed25519/rsa/ecdsa)

```bash
scripts/script.sh generate [type] [bits]
```

### `list`

List all SSH keys

```bash
scripts/script.sh list
```

### `fingerprint`

Show key fingerprint (MD5 + SHA256)

```bash
scripts/script.sh fingerprint <keyfile>
```

### `info`

Detailed key information

```bash
scripts/script.sh info <keyfile>
```

### `copy`

Copy public key to remote host

```bash
scripts/script.sh copy <user@host> [keyfile]
```

### `test`

Test SSH connection

```bash
scripts/script.sh test <user@host>
```

### `authorized-list`

List authorized keys

```bash
scripts/script.sh authorized-list
```

### `authorized-add`

Add key to authorized_keys

```bash
scripts/script.sh authorized-add <pubkey>
```

### `audit`

Security audit of SSH keys and permissions

```bash
scripts/script.sh audit
```

## Requirements

- ssh-keygen

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
