---
name: UUIDGen
description: "Generate UUIDs, short IDs, and nano IDs. Use when creating database keys, minting session tokens, generating unique filenames, or producing batch IDs."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["uuid","generator","random","id","unique","developer","utility"]
categories: ["Developer Tools", "Utility"]
---

# UUIDGen

A real UUID generator and validator. Generate v4 UUIDs, batch-create multiple IDs, validate UUID format, extract UUIDs from text, and generate short 8-character IDs. Uses `/proc/sys/kernel/random/uuid` on Linux or falls back to `python3 uuid` module.

## Commands

| Command | Description |
|---------|-------------|
| `uuidgen v4` | Generate a single random UUID v4 (with compact, uppercase, and URN formats) |
| `uuidgen batch <count>` | Generate multiple UUIDs (default: 5, max: 1000) |
| `uuidgen validate <uuid>` | Check if a string is a valid UUID (shows version, variant, and format details) |
| `uuidgen extract <text>` | Find and extract all UUIDs from a text string |
| `uuidgen short` | Generate a short 8-character UUID (plus 3 alternatives) |
| `uuidgen version` | Show version |
| `uuidgen help` | Show available commands and usage |

## Requirements

- Bash 4+ (`set -euo pipefail`)
- One of: `/proc/sys/kernel/random/uuid` (Linux), `python3`, or `/dev/urandom`
- No external dependencies or API keys

## When to Use

1. **Generate database keys** — `uuidgen v4` for a single ID, `uuidgen batch 100` for bulk
2. **Validate user-supplied UUIDs** — `uuidgen validate <uuid>` checks format, detects version and variant
3. **Extract IDs from logs/text** — `uuidgen extract "Error for session 550e8400-e29b-..."` pulls out all UUIDs
4. **Short identifiers** — `uuidgen short` for 8-char IDs suitable for URLs or display
5. **Batch ID generation** — `uuidgen batch 50` creates 50 UUIDs numbered for easy reference

## Examples

```bash
# Generate a single UUID v4
uuidgen v4

# Generate 10 UUIDs
uuidgen batch 10

# Validate a UUID
uuidgen validate '550e8400-e29b-41d4-a716-446655440000'

# Extract UUIDs from text
uuidgen extract 'User 550e8400-e29b-41d4-a716-446655440000 created session abc12345-dead-beef-cafe-123456789012'

# Generate a short 8-char UUID
uuidgen short
```

### Example Output

```
$ uuidgen v4
┌──────────────────────────────────────────────────┐
│  UUID v4 Generated                               │
├──────────────────────────────────────────────────┤
│  UUID:     1a28540e-25e6-4efe-86a8-93f41e16dad8   │
│  Compact:  1a28540e25e64efe86a893f41e16dad8       │
│  Upper:    1A28540E-25E6-4EFE-86A8-93F41E16DAD8   │
│  URN:      urn:uuid:1a28540e-25e6-4efe-86a8-...   │
└──────────────────────────────────────────────────┘

$ uuidgen validate '550e8400-e29b-41d4-a716-446655440000'
┌──────────────────────────────────────────────────┐
│  UUID Validation                                 │
├──────────────────────────────────────────────────┤
│  Input:    550e8400-e29b-41d4-a716-446655440000   │
│  Valid:    ✅ YES                                 │
│  Version:  v4 (random)                            │
│  Variant:  RFC 4122 / DCE                         │
│  Compact:  550e8400e29b41d4a716446655440000       │
└──────────────────────────────────────────────────┘

$ uuidgen batch 3
═══════════════════════════════════════════════════════
  Generating 3 UUIDs
═══════════════════════════════════════════════════════

   1. b54a201e-47d7-463e-9539-86e08201b4f0
   2. 7fa328ef-fba4-4a7a-94c2-2dc431079aae
   3. 0d382fb3-0c52-424b-a7cd-416f6c29ad49

Generated 3 UUID(s).
```

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
