---
version: "2.0.0"
name: skill-template
description: "OpenClaw Skill template generator. Create skill scaffolds, validate structure, enhance SKILL.md, generate command frameworks, tips, publish checklists, and example skills. Commands: create, validate, enhance, commands, tips, publish, examples. Use for skill development, AgentSkill authoring, skill creation. Use when you need skill template capabilities. Triggers on: skill template."
author: BytesAgain
---

# 🧩 Skill Template

> Purpose-built for OpenClaw Skill developers. Competing with skill-creator (30K+ downloads).

## Why This Skill?

Building an OpenClaw Skill requires a specific directory structure and conventions.
Doing it manually means missing critical parts. Skill Template automates the entire
flow — from scaffold generation to publish-readiness checks.

## Commands

```bash
bash scripts/skill-tmpl.sh <command> <skill_name> [options]
```

### 🚀 Create Phase
| Command | Purpose |
|---------|---------|
| `create <name>` | Generate full skill directory (SKILL.md + tips.md + scripts/) |
| `commands <name>` | Generate bash case-statement command framework |
| `tips <name>` | Generate tips.md template |
| `examples` | Show example skills for reference |

### ✅ Verify Phase
| Command | Purpose |
|---------|---------|
| `validate <dir>` | Check skill structure against spec |
| `enhance <dir>` | Analyze and suggest SKILL.md improvements |
| `publish <dir>` | Full pre-publish checklist |

## Recommended Workflow

1. `create` to scaffold → `commands` to fill logic → `tips` to add advice
2. When done: `validate` → `enhance` → `publish`
3. Study `examples` to learn from well-crafted skills

## Standard Skill Structure

```
my-skill/
├── SKILL.md          # Required: frontmatter + docs
├── tips.md           # Recommended: usage tips
└── scripts/
    └── main.sh       # Recommended: executable script
```
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
