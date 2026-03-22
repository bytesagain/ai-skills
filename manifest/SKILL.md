---
name: "manifest"
version: "1.0.0"
description: "Shipping manifest reference — bill of lading, packing lists, cargo documentation, EDI formats. Use when preparing shipment paperwork, validating manifest data, or troubleshooting customs documentation."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [manifest, shipping, bill-of-lading, cargo, customs, packing-list, logistics]
category: "logistics"
---

# Manifest — Shipping Manifest Reference

Quick-reference skill for cargo manifests, bills of lading, and shipping documentation.

## When to Use

- Preparing cargo manifests for ocean, air, or land shipments
- Understanding bill of lading types and requirements
- Creating packing lists that match manifest data
- Filing electronic manifests (AMS/ACI) with customs
- Resolving manifest discrepancies and holds

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of shipping manifests — purpose, legal requirements, document hierarchy.

### `bol`

```bash
scripts/script.sh bol
```

Bill of Lading — types, fields, negotiable vs non-negotiable, switch B/L.

### `packing`

```bash
scripts/script.sh packing
```

Packing lists — contents, format, harmonization with commercial invoice.

### `air`

```bash
scripts/script.sh air
```

Air cargo manifests — AWB, HAWB, MAWB, e-freight requirements.

### `ocean`

```bash
scripts/script.sh ocean
```

Ocean manifests — container manifest, stowage plan, ISF 10+2 filing.

### `electronic`

```bash
scripts/script.sh electronic
```

Electronic manifests — AMS, ACI, ENS, EDI/XML formats, filing deadlines.

### `discrepancies`

```bash
scripts/script.sh discrepancies
```

Manifest discrepancies — shorts, overs, damages, amendment procedures.

### `checklist`

```bash
scripts/script.sh checklist
```

Manifest preparation checklist — completeness, accuracy, compliance.

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Configuration

| Variable | Description |
|----------|-------------|
| `MANIFEST_DIR` | Data directory (default: ~/.manifest/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
