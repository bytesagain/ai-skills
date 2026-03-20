---
version: "1.0.0"
name: Hacker Roadmap
description: "A collection of hacking tools, resources and references to practice ethical hacking. hacker roadmap, python, exploitation, frameworks, hacking, hacking-tool."
---

# Security Roadmap

A content toolkit for security roadmap planning. Draft, edit, optimize, and manage security-focused content from the command line with timestamped logging and full export support.

## Commands

| Command | Description |
|---------|-------------|
| `security-roadmap draft <input>` | Draft new security content (or view recent drafts with no args) |
| `security-roadmap edit <input>` | Edit and refine existing content entries |
| `security-roadmap optimize <input>` | Optimize content for clarity and impact |
| `security-roadmap schedule <input>` | Schedule content for future publishing |
| `security-roadmap hashtags <input>` | Generate or store relevant hashtags |
| `security-roadmap hooks <input>` | Create attention-grabbing hooks for content |
| `security-roadmap cta <input>` | Craft call-to-action messages |
| `security-roadmap rewrite <input>` | Rewrite content with a fresh perspective |
| `security-roadmap translate <input>` | Log translation tasks or translated content |
| `security-roadmap tone <input>` | Adjust or record tone preferences |
| `security-roadmap headline <input>` | Generate and store headlines |
| `security-roadmap outline <input>` | Create structured outlines for articles |
| `security-roadmap stats` | Show summary statistics across all categories |
| `security-roadmap export <fmt>` | Export all data (formats: json, csv, txt) |
| `security-roadmap search <term>` | Search across all logged entries |
| `security-roadmap recent` | Show the 20 most recent activity log entries |
| `security-roadmap status` | Health check — version, data dir, entry count, disk usage |
| `security-roadmap help` | Show full usage information |
| `security-roadmap version` | Show version (v2.0.0) |

Each content command works in two modes:
- **With arguments:** saves the input with a timestamp to `<command>.log` and logs to history
- **Without arguments:** displays the 20 most recent entries for that command

## Data Storage

All data is stored locally in `~/.local/share/security-roadmap/`. Each command writes to its own log file (e.g., `draft.log`, `edit.log`, `hashtags.log`). A unified `history.log` tracks all activity with timestamps. Data never leaves your machine.

Directory structure:
```
~/.local/share/security-roadmap/
├── draft.log
├── edit.log
├── optimize.log
├── schedule.log
├── hashtags.log
├── hooks.log
├── cta.log
├── rewrite.log
├── translate.log
├── tone.log
├── headline.log
├── outline.log
└── history.log
```

## Requirements

- Bash (with `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or network access required

## When to Use

1. **Building a security content calendar** — use `schedule`, `draft`, and `headline` to plan and organize upcoming posts or articles about security topics
2. **Creating social media content for security awareness** — use `hashtags`, `hooks`, and `cta` to craft engaging social posts with strong calls to action
3. **Drafting and refining security blog posts** — use `draft`, `edit`, `optimize`, and `rewrite` to iterate on long-form security content
4. **Managing multilingual security documentation** — use `translate` and `tone` to track translations and maintain consistent voice across languages
5. **Auditing your content pipeline** — use `stats`, `recent`, and `search` to review activity, find past entries, and export everything for reporting

## Examples

```bash
# Draft a new security article idea
security-roadmap draft "Zero-trust architecture: 5 steps for SMBs"

# Generate hashtags for a security awareness post
security-roadmap hashtags "#cybersecurity #zerotrust #infosec #datasecurity"

# Create a compelling hook for a newsletter
security-roadmap hooks "Did you know 80% of breaches start with a phishing email?"

# Export all content data as JSON for backup
security-roadmap export json

# Search for all entries mentioning "phishing"
security-roadmap search phishing
```

## Configuration

Set the `SECURITY_ROADMAP_DIR` environment variable to change the data directory. Default: `~/.local/share/security-roadmap/`

## Output

All commands output results to stdout. Redirect to a file with `> output.txt` if needed. The `export` command writes directly to `~/.local/share/security-roadmap/export.<fmt>`.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
