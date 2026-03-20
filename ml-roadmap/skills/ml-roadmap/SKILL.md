---
version: "1.0.0"
name: Machine Learning Roadmap
description: "A roadmap connecting many of the most important concepts in machine learning, how to learn them and machine learning roadmap, python, data, data-science."
---

# Machine Learning Roadmap

A thorough content toolkit for planning and tracking your machine learning learning journey. Draft study plans, organize topics, create outlines, schedule learning sessions, and manage your ML education roadmap — all from the command line.

## Commands

| Command | Description |
|---------|-------------|
| `ml-roadmap draft <input>` | Draft a new ML learning plan or content entry |
| `ml-roadmap edit <input>` | Edit an existing entry or refine content |
| `ml-roadmap optimize <input>` | Optimize content for clarity or effectiveness |
| `ml-roadmap schedule <input>` | Schedule learning sessions or content publication |
| `ml-roadmap hashtags <input>` | Generate relevant hashtags for ML topics |
| `ml-roadmap hooks <input>` | Create engaging hooks for ML content |
| `ml-roadmap cta <input>` | Generate call-to-action text for ML resources |
| `ml-roadmap rewrite <input>` | Rewrite content with improved structure |
| `ml-roadmap translate <input>` | Translate ML content between languages |
| `ml-roadmap tone <input>` | Adjust the tone of ML content (formal, casual, etc.) |
| `ml-roadmap headline <input>` | Generate compelling headlines for ML topics |
| `ml-roadmap outline <input>` | Create structured outlines for ML subjects |
| `ml-roadmap stats` | Show summary statistics across all entry types |
| `ml-roadmap export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `ml-roadmap search <term>` | Search across all entries by keyword |
| `ml-roadmap recent` | Show the 20 most recent activity log entries |
| `ml-roadmap status` | Health check — version, disk usage, last activity |
| `ml-roadmap help` | Show the built-in help message |
| `ml-roadmap version` | Print the current version (v2.0.0) |

Each content command (draft, edit, optimize, etc.) works in two modes:
- **Without arguments** — displays the 20 most recent entries of that type
- **With arguments** — saves the input as a new timestamped entry

## Data Storage

All data is stored as plain-text log files in `~/.local/share/ml-roadmap/`:

- Each command type gets its own log file (e.g., `draft.log`, `edit.log`, `outline.log`)
- Entries are stored in `timestamp|value` format for easy parsing
- A unified `history.log` tracks all activity across command types
- Export to JSON, CSV, or TXT at any time with the `export` command

Set the `ML_ROADMAP_DIR` environment variable to override the default data directory.

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Planning your ML learning path** — use `outline` and `draft` to structure a study roadmap covering supervised learning, deep learning, NLP, computer vision, and more
2. **Creating ML educational content** — use `headline`, `hooks`, `cta`, and `hashtags` to craft engaging posts or articles about machine learning concepts
3. **Scheduling study sessions** — use `schedule` to log when you plan to study specific ML topics and track your progress over time
4. **Refining technical writing** — use `rewrite`, `tone`, and `optimize` to polish ML blog posts, documentation, or course materials
5. **Tracking content creation history** — use `stats`, `search`, and `recent` to review what you've written, find past entries, and measure productivity

## Examples

```bash
# Draft a new learning plan for deep learning fundamentals
ml-roadmap draft "Week 1: Neural network basics — perceptrons, activation functions, backprop"

# Create an outline for a blog post on model selection
ml-roadmap outline "Comparing Random Forest vs XGBoost: when to use each, key hyperparameters, pros/cons"

# Generate a headline for an ML tutorial
ml-roadmap headline "Beginner-friendly guide to building your first image classifier with PyTorch"

# Schedule a study session
ml-roadmap schedule "Saturday 10am: Work through Stanford CS229 Lecture 5 — Support Vector Machines"

# Export all your entries to JSON for backup
ml-roadmap export json
```

## Output

All commands print results to stdout. Redirect to a file if needed:

```bash
ml-roadmap stats > roadmap-report.txt
ml-roadmap export csv
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
