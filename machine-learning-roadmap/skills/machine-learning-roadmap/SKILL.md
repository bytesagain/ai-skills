---
name: Machine Learning Roadmap
description: "Follow a structured ML roadmap connecting concepts, tools, and learning resources. Use when planning study paths, discovering resources, mapping skills."
version: "1.0.0"
license: MIT
runtime: python3
---

# Machine Learning Roadmap

Machine Learning Roadmap v2.0.0 — a content toolkit for drafting, editing, optimizing, and managing machine learning content. Create outlines, write headlines, generate CTAs, manage hashtags, rewrite content, translate text, and adjust tone — all tracked with timestamped entries stored locally.

## Commands

Run `scripts/script.sh <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `draft <input>` | Record a draft entry. Without args, shows the 20 most recent draft entries. |
| `edit <input>` | Record an edit entry. Without args, shows recent edit entries. |
| `optimize <input>` | Record an optimization entry. Without args, shows recent optimize entries. |
| `schedule <input>` | Record a scheduling entry. Without args, shows recent schedule entries. |
| `hashtags <input>` | Record a hashtags entry. Without args, shows recent hashtags entries. |
| `hooks <input>` | Record a hooks entry. Without args, shows recent hooks entries. |
| `cta <input>` | Record a call-to-action entry. Without args, shows recent CTA entries. |
| `rewrite <input>` | Record a rewrite entry. Without args, shows recent rewrite entries. |
| `translate <input>` | Record a translation entry. Without args, shows recent translate entries. |
| `tone <input>` | Record a tone adjustment entry. Without args, shows recent tone entries. |
| `headline <input>` | Record a headline entry. Without args, shows recent headline entries. |
| `outline <input>` | Record an outline entry. Without args, shows recent outline entries. |
| `stats` | Show summary statistics across all entry types (counts, data size). |
| `export <fmt>` | Export all data in `json`, `csv`, or `txt` format. |
| `search <term>` | Search all log files for a term (case-insensitive). |
| `recent` | Show the 20 most recent entries from the activity history. |
| `status` | Health check — version, data directory, entry count, disk usage. |
| `help` | Show help message with all available commands. |
| `version` | Show version string (`machine-learning-roadmap v2.0.0`). |

## Data Storage

All data is stored in `~/.local/share/machine-learning-roadmap/`:

- Each command type writes to its own `.log` file (e.g., `draft.log`, `headline.log`, `translate.log`)
- Entries are timestamped in `YYYY-MM-DD HH:MM|<value>` format
- A unified `history.log` tracks all actions across command types
- Export files are written to the same directory as `export.json`, `export.csv`, or `export.txt`

## Requirements

- Bash 4+ with `set -euo pipefail`
- Standard Unix utilities (`date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`)
- No external dependencies — works out of the box on Linux and macOS

## When to Use

1. **Drafting ML content** — use `draft` and `outline` to capture ideas and structure articles, blog posts, or course materials about machine learning topics
2. **Headline and hook creation** — record `headline` and `hooks` entries to brainstorm attention-grabbing titles and opening lines for ML content
3. **Content optimization** — use `optimize`, `rewrite`, and `tone` to track iterations as you refine ML tutorials, documentation, or marketing copy
4. **Multi-language content** — record `translate` entries when adapting ML learning materials for different language audiences
5. **Content scheduling and CTAs** — use `schedule` and `cta` to plan publication timelines and track call-to-action variations for ML courses or newsletters

## Examples

```bash
# Draft a new ML blog post idea
machine-learning-roadmap draft "Introduction to Neural Networks: A Beginner's Guide"

# Create an outline for a tutorial
machine-learning-roadmap outline "1. What is ML? 2. Supervised vs Unsupervised 3. Tools 4. Practice Projects"

# Record a headline variation
machine-learning-roadmap headline "5 Python Libraries Every ML Engineer Must Know in 2025"

# Generate hashtags for social media
machine-learning-roadmap hashtags "#MachineLearning #AI #DeepLearning #Python #DataScience"

# Export all content data as CSV
machine-learning-roadmap export csv

# Search for entries mentioning a topic
machine-learning-roadmap search "neural"

# View summary statistics
machine-learning-roadmap stats
```

## Output

All commands print results to stdout. Each recording command confirms the save and shows the total entry count for that category. Redirect output to a file with:

```bash
machine-learning-roadmap stats > report.txt
```

## Configuration

Set the `DATA_DIR` inside the script or modify the default path `~/.local/share/machine-learning-roadmap/` to change where data is stored.

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
