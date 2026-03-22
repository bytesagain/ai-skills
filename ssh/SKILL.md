---
name: "ssh"
version: "1.0.0"
description: "SSH reference — key management, tunneling, hardening, config patterns. Use when configuring SSH access, setting up tunnels, debugging connections, or hardening SSH servers."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [ssh, security, tunneling, keys, openssh, sshd, remote-access]
category: "general"
---

# SSH — Secure Shell Reference

Quick-reference skill for SSH configuration, key management, tunneling, and security hardening.

## When to Use

- Setting up SSH key pairs and agent forwarding
- Configuring SSH client config (~/.ssh/config) patterns
- Creating port forwards, reverse tunnels, and SOCKS proxies
- Hardening sshd_config for production servers
- Debugging SSH connection failures

## Commands

### `intro`

```bash
scripts/script.sh intro
```

SSH fundamentals — protocol overview, authentication methods, connection flow.

### `keys`

```bash
scripts/script.sh keys
```

Key management — generating, converting, and distributing SSH keys.

### `config`

```bash
scripts/script.sh config
```

SSH client config patterns — ~/.ssh/config examples, ProxyJump, multiplexing.

### `tunnels`

```bash
scripts/script.sh tunnels
```

Port forwarding — local, remote, dynamic (SOCKS), and tunnel use cases.

### `hardening`

```bash
scripts/script.sh hardening
```

Server hardening — sshd_config best practices, fail2ban, key-only auth.

### `agent`

```bash
scripts/script.sh agent
```

SSH agent — agent forwarding, ssh-add, agent socket, security considerations.

### `troubleshoot`

```bash
scripts/script.sh troubleshoot
```

Debugging SSH — verbose mode, common errors, permission issues.

### `escapes`

```bash
scripts/script.sh escapes
```

SSH escape sequences — session control, on-the-fly port forwards.

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
