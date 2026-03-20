---
version: "2.0.0"
name: Trivia Quiz
description: "Play knowledge quizzes with facts, categories, and daily challenges. Use when learning topics, drilling flashcards, reviewing answers, tracking progress."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# Trivia Quiz

A learning and study assistant for self-paced education. Start learning sessions on any topic, run quick quizzes, drill with flashcards, review via spaced repetition, track your progress, build learning roadmaps, find resources, take notes, summarize topics, and test your knowledge.

## Commands

| Command | Description |
|---------|-------------|
| `learn <topic> [hours]` | Start a learning session on a topic with optional time estimate |
| `quiz <topic>` | Run a quick 3-question quiz on a topic |
| `flashcard <term>` | Create a flashcard with a front term (answer saved to data dir) |
| `review` | Launch a spaced repetition review session (1d, 3d, 7d, 14d, 30d intervals) |
| `progress` | Show total number of logged study sessions |
| `roadmap` | Generate a multi-week learning roadmap (basics → practice → projects) |
| `resource` | List resource categories: books, videos, courses, practice sites |
| `note <text>` | Save a timestamped note to the data log |
| `summary <topic>` | Get a summary of a topic |
| `test <topic>` | Self-test your knowledge on a topic |
| `help` | Show all available commands and usage info |
| `version` | Display current version (v2.0.0) |

## Data Storage

All data is stored locally in `$TRIVIA_QUIZ_DIR` (defaults to `~/.local/share/trivia-quiz/`):

- **`data.log`** — Notes and general entries saved with `note` command
- **`history.log`** — Timestamped log of every command executed (learn, quiz, flashcard, etc.)

The data directory is created automatically on first run. No cloud sync — everything stays on your machine.

## Requirements

- **Bash** ≥ 4.0 (uses `set -euo pipefail`)
- **coreutils** — `date`, `wc`, `mkdir` (standard on Linux/macOS)
- No API keys, no internet connection, no external dependencies

## When to Use

1. **Self-study sessions** — Use `learn` and `roadmap` to structure your study of a new programming language, framework, or any topic
2. **Exam prep** — Use `quiz` and `test` to drill yourself, then `review` for spaced repetition before an exam
3. **Daily flashcard habit** — Use `flashcard` to build a deck and `review` to maintain a daily spaced repetition routine
4. **Meeting/lecture notes** — Use `note` to quickly capture timestamped insights during a meeting, class, or conference talk
5. **Learning progress tracking** — Use `progress` to see how many sessions you've logged and stay motivated over time

## Examples

```bash
# Start learning a topic with estimated time
trivia-quiz learn python 2

# Run a quick quiz on Docker
trivia-quiz quiz docker

# Create a flashcard
trivia-quiz flashcard "What is a closure?"

# Review with spaced repetition
trivia-quiz review

# Check how many sessions you've completed
trivia-quiz progress

# Generate a learning roadmap
trivia-quiz roadmap

# Find study resources
trivia-quiz resource

# Save a quick note
trivia-quiz note "Remember: Python decorators are syntactic sugar for higher-order functions"

# Get a topic summary
trivia-quiz summary kubernetes

# Self-test on a topic
trivia-quiz test algorithms

# Show help
trivia-quiz help
```

## Tips

- Combine `learn` → `note` → `quiz` → `review` for a complete study cycle
- Use `roadmap` at the start of a new subject to plan your weeks
- Check `progress` regularly to maintain accountability
- All history is logged — you can `grep` through `~/.local/share/trivia-quiz/history.log` for past activity

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
