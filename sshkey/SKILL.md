---
name: SSHKey
description: "SSH key pair manager. Generate new SSH key pairs, list existing keys, copy public keys to clipboard, check key fingerprints, add keys to ssh-agent, convert key formats, and test SSH connections. Simplify SSH key management from your terminal."
version: "2.0.0"
author: "BytesAgain"
tags: ["ssh","key","security","authentication","crypto","server","admin","devops"]
categories: ["Security", "System Tools", "Developer Tools"]
---
# SSHKey
Manage SSH keys without remembering flags. Generate, list, copy, test.
## Commands
- `generate [name] [type]` — Generate new key pair (ed25519/rsa)
- `list` — List existing SSH keys
- `fingerprint [keyfile]` — Show key fingerprint
- `copy [keyfile]` — Show public key for copying
- `test <host>` — Test SSH connection
## Usage Examples
```bash
sshkey generate myserver ed25519
sshkey list
sshkey fingerprint ~/.ssh/id_ed25519
sshkey copy
sshkey test github.com
```
---
Powered by BytesAgain | bytesagain.com

## When to Use

- when you need quick sshkey from the command line
- to automate sshkey tasks in your workflow

## Output

Returns summaries to stdout. Redirect to a file with `sshkey run > output.txt`.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
