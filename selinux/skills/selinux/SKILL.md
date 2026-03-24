---
name: "selinux"
version: "1.0.0"
description: "SELinux mandatory access control reference. Enforcing/permissive modes, security contexts, booleans, policy modules, file labeling, port management, and troubleshooting with audit2why and sealert."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [selinux, security, linux, mac, access-control, sysops]
category: "sysops"
---

# SELinux

SELinux mandatory access control reference. Real commands, real configs, real troubleshooting.

## Commands

| Command | Description |
|---------|-------------|
| `intro` | What is SELinux, MAC vs DAC, NSA origin |
| `modes` | Enforcing/permissive/disabled, getenforce/setenforce |
| `contexts` | Security contexts user:role:type:level, ls -Z, ps -Z |
| `booleans` | getsebool/setsebool, common booleans |
| `policy` | Targeted vs MLS, policy modules, semodule |
| `troubleshoot` | audit2why, sealert, setroubleshoot |
| `file-labels` | chcon, restorecon, semanage fcontext |
| `ports` | semanage port, adding custom ports |
