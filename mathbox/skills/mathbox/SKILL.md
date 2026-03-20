---
name: MathBox
description: "Solve math — statistics, primes, sequences, formulas — in the terminal. Use when computing stats, checking primes, evaluating formulas, exploring sequences."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["math","statistics","calculator","numbers","prime","fibonacci","formula","developer"]
categories: ["Developer Tools", "Utility", "Education"]
---
# MathBox

Education toolkit for studying, quizzing, reviewing, and tracking learning progress. MathBox provides a structured study workflow — create flashcards, take quizzes, set goals, track progress, schedule study sessions, and bookmark important material. All entries are timestamped and stored locally for full traceability.

## Commands

### Study & Learning
| Command | Description |
|---------|-------------|
| `mathbox study <input>` | Log a study session or topic. Run without args to view recent study entries |
| `mathbox quiz <input>` | Create or record quiz questions/answers. Run without args to view recent quizzes |
| `mathbox practice <input>` | Log practice problems or exercises. Run without args to view recent practice entries |
| `mathbox test <input>` | Record test results or create test items. Run without args to view recent test entries |
| `mathbox flashcard <input>` | Create flashcard entries for review. Run without args to view recent flashcards |

### Understanding & Review
| Command | Description |
|---------|-------------|
| `mathbox explain <input>` | Record explanations of concepts. Run without args to view recent explanations |
| `mathbox summarize <input>` | Create summaries of material. Run without args to view recent summaries |
| `mathbox review <input>` | Log review sessions. Run without args to view recent reviews |
| `mathbox bookmark <input>` | Bookmark important topics or resources. Run without args to view recent bookmarks |

### Planning & Tracking
| Command | Description |
|---------|-------------|
| `mathbox goal <input>` | Set learning goals. Run without args to view recent goals |
| `mathbox progress <input>` | Track learning progress. Run without args to view recent progress entries |
| `mathbox schedule <input>` | Schedule study sessions. Run without args to view recent schedules |

### Utility Commands
| Command | Description |
|---------|-------------|
| `mathbox stats` | Show summary statistics across all entry types |
| `mathbox export <fmt>` | Export all data (formats: `json`, `csv`, `txt`) |
| `mathbox search <term>` | Search across all entries by keyword |
| `mathbox recent` | Show the 20 most recent activity log entries |
| `mathbox status` | Health check — version, data dir, entry count, disk usage |
| `mathbox help` | Show usage information and available commands |
| `mathbox version` | Show version (v2.0.0) |

## Data Storage

All data is stored locally in `~/.local/share/mathbox/`:

- Each command type has its own log file (e.g., `study.log`, `quiz.log`, `flashcard.log`)
- Entries are timestamped in `YYYY-MM-DD HH:MM|value` format
- A unified `history.log` tracks all activity across commands
- Export supports JSON, CSV, and plain text formats
- No external services or API keys required

## Requirements

- Bash 4.0+ (uses `set -euo pipefail`)
- Standard UNIX utilities (`wc`, `du`, `grep`, `tail`, `sed`, `date`)
- No external dependencies — works on any POSIX-compatible system

## When to Use

1. **Self-study workflow** — Log study sessions, create flashcards, and track progress across subjects or topics
2. **Exam preparation** — Build quizzes, practice problems, and test entries to prepare for assessments with full history
3. **Learning goal tracking** — Set goals, schedule study sessions, and monitor progress over time
4. **Knowledge management** — Bookmark resources, summarize material, and explain concepts for future reference
5. **Study analytics** — Use `stats`, `search`, and `export` to analyze study patterns, review frequency, and topic coverage

## Examples

```bash
# Log a study session
mathbox study "Completed Chapter 5 — Linear Algebra: eigenvalues and eigenvectors"

# Create a flashcard
mathbox flashcard "Q: What is the derivative of e^x? A: e^x"

# Record a quiz question
mathbox quiz "Integration by parts: ∫x·e^x dx = x·e^x - e^x + C — correct"

# Set a learning goal
mathbox goal "Complete all calculus chapters by end of March"

# Track progress
mathbox progress "Finished 8/12 chapters in the statistics textbook"

# Export all data as CSV for spreadsheet analysis
mathbox export csv

# Search for entries about a specific topic
mathbox search eigenvalue
```

## How It Works

Each learning command (study, quiz, flashcard, etc.) works the same way:
- **With arguments**: Saves the input as a new timestamped entry and logs it to history
- **Without arguments**: Displays the 20 most recent entries for that command type

This makes MathBox both a study tool and a searchable learning journal.

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
