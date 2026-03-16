---
name: HashGen
description: "Hash generator and file integrity verifier. Generate MD5, SHA1, SHA256, SHA512 hashes for text and files, verify file integrity against expected hashes, compare two files by hash, and view all hash algorithms at once. Essential security and verification tool."
version: "2.0.0"
author: "BytesAgain"
tags: ["hash","md5","sha256","checksum","security","verify","integrity","crypto"]
categories: ["Security", "Developer Tools", "Utility"]
---

# HashGen

Hash anything. Verify everything. Your integrity checking toolkit.

## Commands

- `text [algo] <text>` — Hash text string (default: sha256)
- `file [algo] <file>` — Hash a file
- `verify <file> <expected_hash> [algo]` — Verify file against expected hash
- `compare <file1> <file2> [algo]` — Compare two files by hash
- `all <text>` — Show all hash algorithms for a text
- `help` — Show commands

## Usage Examples

```bash
hashgen text sha256 "hello world"
hashgen file sha256 download.iso
hashgen verify package.tar.gz abc123def456
hashgen compare file1.txt file2.txt
hashgen all "my secret"
```

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

- Run `hashgen help` for all commands
