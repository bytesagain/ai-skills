---
name: HashGen
description: "Hash files and strings, verify checksums, and run integrity checks fast. Use when generating SHA hashes, verifying files, or comparing digest values."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["hash","md5","sha256","checksum","security","verify","integrity","crypto"]
categories: ["Security", "Developer Tools", "Utility"]
---

# HashGen

Quick hash generator for strings and files. Supports MD5, SHA1, SHA256, SHA512 with auto-detection, comparison, and verification.

## Commands

| Command | Description |
|---------|-------------|
| `hashgen md5 <text>` | MD5 hash of text |
| `hashgen sha1 <text>` | SHA1 hash of text |
| `hashgen sha256 <text>` | SHA256 hash of text |
| `hashgen sha512 <text>` | SHA512 hash of text |
| `hashgen all <text>` | Show all hash algorithms for text |
| `hashgen file <path> [algo]` | Hash a file (default: sha256) |
| `hashgen compare <hash1> <hash2>` | Compare two hashes |
| `hashgen verify <text> <hash>` | Verify text matches hash (auto-detects algorithm) |
| `hashgen version` | Show version |

## Examples

```bash
hashgen md5 "hello world"       # → MD5: 5eb63bbbe01...
hashgen sha256 "my secret"      # → SHA256: 40e1b17...
hashgen all "test"              # → shows MD5, SHA1, SHA256, SHA512
hashgen file /etc/hostname      # → SHA256 of file
hashgen file /etc/hostname md5  # → MD5 of file
hashgen compare abc123 abc123   # → ✅ MATCH
hashgen verify "hello" 5d41...  # → auto-detects algo, verifies
```

## Requirements

- `md5sum`, `sha1sum`, `sha256sum`, `sha512sum` (standard coreutils)
