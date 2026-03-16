---
version: "2.0.0"
name: Skill Tester
description: "OpenClaw skill testing and debugging tool. Validate skill structure, lint SKILL.md, dry-run publish simulation, check file sizes, dependency analysis, compare two skills, benchmark performance, generate quality reports. openclaw, skill-development, linting, validation, developer-tools. Use when you need skill tester capabilities. Triggers on: skill tester."
---

# Skill Tester — OpenClaw Skill QA Tool

> Validate, lint, and benchmark your skills before publishing

## Workflow

```
1. validate  →  Structure check (required files exist?)
2. lint      →  SKILL.md spec compliance
3. size      →  File size limits
4. deps      →  Dependency audit
5. benchmark →  Performance estimate
6. report    →  Full quality report
7. dry-run   →  Simulated publish
8. compare   →  Diff two skills side by side
```

## Commands

```bash
bash scripts/skill-tester.sh validate ./skills/my-skill
bash scripts/skill-tester.sh lint ./skills/my-skill
bash scripts/skill-tester.sh size ./skills/my-skill
bash scripts/skill-tester.sh deps ./skills/my-skill
bash scripts/skill-tester.sh compare ./skills/skill-a ./skills/skill-b
bash scripts/skill-tester.sh report ./skills/my-skill
```

## What Gets Checked

- **validate** — SKILL.md exists, frontmatter present, scripts/ directory, required fields
- **lint** — Name/description length, frontmatter format, markdown structure
- **size** — Individual files, total skill size, warn on oversized assets
- **deps** — External commands used in scripts, missing tool detection
- **benchmark** — Script execution time, output size estimation
- **report** — Combined scorecard with pass/warn/fail grades
- **dry-run** — Full publish simulation without side effects
- **compare** — Side-by-side structure and quality comparison
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
