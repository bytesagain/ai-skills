---
name: leads
description: "Manage sales leads locally. Use when adding prospects, scoring leads, setting follow-ups, tracking conversions, or viewing funnels."
version: "3.4.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags:
  - sales
  - crm
  - leads
  - pipeline
  - follow-up
---

# Leads — Sales Lead CRM

Manage sales leads through their lifecycle: add, score, follow up, convert, and report on your pipeline.

## Commands

### add — Add a new lead

```bash
bash scripts/script.sh add "<name>" "<email>" "<company>" "[source]"
```

Creates a new lead with status `new`. Source defaults to `direct`.

### list — View leads

```bash
bash scripts/script.sh list [status] [--sort score|date]
```

Lists all leads, optionally filtered by status (`new`, `contacted`, `qualified`, `converted`, `lost`). Sort by score or date.

### score — Score a lead

```bash
bash scripts/script.sh score "<lead_id>" <points> "[reason]"
```

Assigns or adds score points to a lead. Score range: 0–100. Higher = more likely to convert.

### follow-up — Set follow-up reminder

```bash
bash scripts/script.sh follow-up "<lead_id>" "<YYYY-MM-DD>" "<note>"
```

Schedules a follow-up action for a lead on the specified date with a note.

### convert — Mark lead as converted

```bash
bash scripts/script.sh convert "<lead_id>" "[deal_value]"
```

Changes lead status to `converted` and optionally records deal value.

### pipeline — Sales funnel report

```bash
bash scripts/script.sh pipeline [YYYY-MM]
```

Shows a funnel breakdown of leads by status with counts and conversion rates. Defaults to current month.

## Output

All commands print plain text to stdout. Data is stored in `~/.leads/leads.json`.


## Requirements
- bash 4+
- python3 (standard library only)

## Feedback

Report issues or suggestions: [https://bytesagain.com/feedback/](https://bytesagain.com/feedback/)

---

Powered by BytesAgain | bytesagain.com
