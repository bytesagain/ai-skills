---
name: "rebase"
version: "1.0.0"
description: "Git rebase reference — interactive rebase, squash, fixup, rebase vs merge, conflict resolution, and history rewriting. Use when cleaning commit history, integrating branches, or understanding rebase workflows."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [rebase, git, version-control, history, merge, devtools]
category: "devtools"
---

# Rebase — Git Rebase Reference

Quick-reference skill for git rebase operations, interactive history editing, and branch integration strategies.

## When to Use

- Cleaning up commit history before merging a feature branch
- Using interactive rebase to squash, reorder, or edit commits
- Understanding rebase vs merge trade-offs
- Resolving rebase conflicts
- Safely rewriting shared history

## Commands

### \`intro\`

\`\`\`bash
scripts/script.sh intro
\`\`\`

Overview of git rebase — what it does, when to use it, and mental model.

### \`interactive\`

\`\`\`bash
scripts/script.sh interactive
\`\`\`

Interactive rebase — pick, squash, fixup, reword, edit, drop.

### \`vs_merge\`

\`\`\`bash
scripts/script.sh vs_merge
\`\`\`

Rebase vs merge — trade-offs, team workflows, and when to use each.

### \`conflicts\`

\`\`\`bash
scripts/script.sh conflicts
\`\`\`

Conflict resolution during rebase — step by step, abort, and rerere.

### \`onto\`

\`\`\`bash
scripts/script.sh onto
\`\`\`

Rebase --onto — transplanting commit ranges between branches.

### \`autosquash\`

\`\`\`bash
scripts/script.sh autosquash
\`\`\`

Autosquash workflow — fixup! and squash! commits for clean history.

### \`safety\`

\`\`\`bash
scripts/script.sh safety
\`\`\`

Rebase safety — golden rule, reflog recovery, force-push etiquette.

### \`workflows\`

\`\`\`bash
scripts/script.sh workflows
\`\`\`

Rebase workflows — trunk-based, feature branch, and stacked PRs.

### \`help\`

\`\`\`bash
scripts/script.sh help
\`\`\`

### \`version\`

\`\`\`bash
scripts/script.sh version
\`\`\`

## Configuration

| Variable | Description |
|----------|-------------|
| \`REBASE_DIR\` | Data directory (default: ~/.rebase/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
