---
name: "coppa"
version: "1.0.0"
description: "COPPA compliance reference — children's online privacy, parental consent, data collection rules, FTC enforcement. Use when building apps for children under 13 or reviewing COPPA obligations."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [coppa, privacy, children, ftc, parental-consent, online-safety, legal]
category: "legal"
---

# COPPA — Children's Online Privacy Protection Act Reference

Quick-reference skill for COPPA compliance, parental consent mechanisms, and FTC enforcement guidelines.

## When to Use

- Building websites or apps directed at children under 13
- Reviewing data collection practices for COPPA compliance
- Implementing verifiable parental consent mechanisms
- Understanding FTC enforcement actions and penalties
- Auditing third-party SDKs for child-directed services

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of COPPA — history, purpose, scope, and the FTC's role.

### `scope`

```bash
scripts/script.sh scope
```

Who COPPA applies to — operators, child-directed services, mixed-audience sites, and actual knowledge standard.

### `data`

```bash
scripts/script.sh data
```

Personal information defined under COPPA — what counts as PI for children.

### `consent`

```bash
scripts/script.sh consent
```

Verifiable Parental Consent (VPC) methods approved by the FTC.

### `notice`

```bash
scripts/script.sh notice
```

Privacy notice requirements — what must be disclosed and how.

### `safeharbor`

```bash
scripts/script.sh safeharbor
```

COPPA Safe Harbor programs and self-regulatory frameworks.

### `enforcement`

```bash
scripts/script.sh enforcement
```

FTC enforcement actions, penalties, and notable COPPA cases.

### `checklist`

```bash
scripts/script.sh checklist
```

COPPA compliance checklist for app and website developers.

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
| `COPPA_DIR` | Data directory (default: ~/.coppa/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
