---
version: "3.0.3"
name: brand-namer
description: "Generate brand names with domain checks and analysis. Use when naming a startup, checking domain availability, or brainstorming product names."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# brand-namer

Brand name generator — create name candidates by industry, check domain availability via DNS lookup, analyze name quality, and combine words into brand variants.

## Commands

### `generate`

Generate brand name candidates for an industry. Uses built-in word banks with prefix + root + suffix combinations.

```bash
scripts/script.sh generate tech 10
```

Industries: tech, food, fashion, health, finance.

### `check`

Check domain availability by running DNS A-record lookups for .com, .io, and .co TLDs.

```bash
scripts/script.sh check "nexaflow"
```

Requires: `dig` command (part of bind-utils / dnsutils).

### `analyze`

Analyze a brand name — character count, estimated syllable count, readability score (1-10), and language adaptability notes.

```bash
scripts/script.sh analyze "ByteForge"
```

### `combine`

Combine two words into brand name variants using CamelCase, blending, separators, abbreviations, and overlap detection.

```bash
scripts/script.sh combine "cloud" "forge"
```

### `prefix`

Generate variants with common brand prefixes (re, un, pro, super, meta, neo, hyper, ultra, omni, zen).

```bash
scripts/script.sh prefix "launch"
```

### `suffix`

Generate variants with common brand suffixes (ly, ify, hub, lab, io, ai, ful, ist, ware, bit).

```bash
scripts/script.sh suffix "code"
```

### `save`

Save a name to your shortlist for later review.

```bash
scripts/script.sh save "NexaFlow"
```

### `list`

Show all names on your shortlist.

```bash
scripts/script.sh list
```

### `export`

Export your shortlist in txt, csv, or json format.

```bash
scripts/script.sh export csv
```

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Examples

```bash
# Full naming workflow
scripts/script.sh generate tech 10
scripts/script.sh analyze "CodeNova"
scripts/script.sh check "codenova"
scripts/script.sh combine "byte" "stream"
scripts/script.sh save "ByteStream"
scripts/script.sh export csv
```

## Configuration

| Variable | Required | Description |
|----------|----------|-------------|
| `BRAND_NAMER_DIR` | No | Data directory (default: `~/.brand-namer/`) |

## Data Storage

All data saved in `~/.brand-namer/`:
- `shortlist.json` — Saved name candidates

## Requirements

- bash 4.0+
- dig (from `bind-utils` or `dnsutils` package, used by the `check` command for DNS A-record lookups)

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
