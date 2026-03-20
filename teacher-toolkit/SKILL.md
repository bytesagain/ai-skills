---
version: "2.0.0"
name: teacher-toolkit
description: "教师工具箱。教案设计、评分标准(Rubric)、课堂活动、评估设计、学生反馈、家长沟通。Teacher toolkit with lesson planning, rubrics, activities, assessments, student feedback."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Teacher Toolkit

A terminal-based learning and study assistant for students, teachers, and self-learners. Start learning sessions, generate quizzes, create flashcards, track progress, build learning roadmaps, find resources, take notes, generate topic summaries, and test yourself — all from the command line.

## Commands

| Command | Description |
|---------|-------------|
| `teacher-toolkit learn <topic> [hours]` | Start a learning session on a topic with estimated duration (default: 1 hour) |
| `teacher-toolkit quiz <topic>` | Generate a quick 3-question quiz on a topic |
| `teacher-toolkit flashcard <term>` | Create a flashcard with the given term (front side), saved to data directory |
| `teacher-toolkit review` | Start a spaced repetition review session (1d, 3d, 7d, 14d, 30d intervals) |
| `teacher-toolkit progress` | Track learning progress — shows total number of sessions logged |
| `teacher-toolkit roadmap` | Generate a structured learning roadmap (Basics → Practice → Projects) |
| `teacher-toolkit resource` | Find learning resources — lists books, videos, courses, and practice sites |
| `teacher-toolkit note <text>` | Take a timestamped note, appended to the data log |
| `teacher-toolkit summary <topic>` | Generate a summary for a given topic |
| `teacher-toolkit test <topic>` | Start a self-test on a given topic to assess knowledge |
| `teacher-toolkit help` | Show help message with all available commands |
| `teacher-toolkit version` | Show current version (v2.0.0) |

## Data Storage

- **Default location:** `~/.local/share/teacher-toolkit/`
- **Override:** Set the `TEACHER_TOOLKIT_DIR` environment variable, or `XDG_DATA_HOME` to customize the base path
- **Data file:** `data.log` — stores notes and session data with timestamps
- **History file:** `history.log` — timestamped record of every command executed for full traceability
- All data is stored locally on your machine. No cloud sync, no accounts, no network calls.

## Requirements

- Bash 4+ (uses `set -euo pipefail`)
- Standard Unix utilities: `date`, `wc`, `cat`
- No external dependencies or API keys required

## When to Use

1. **Self-directed learning** — Use `learn` to start structured study sessions, `roadmap` to plan your learning path, and `progress` to track how far you've come
2. **Exam preparation** — Generate quizzes with `quiz`, create flashcards for key terms with `flashcard`, and use `review` for spaced repetition before tests
3. **Classroom teaching support** — Teachers can use `summary` to quickly outline topics, `quiz` to generate discussion questions, and `resource` to find supplementary materials
4. **Note-taking during study** — Capture insights and key points with `note` as you study, building a timestamped knowledge log you can review later
5. **Knowledge self-assessment** — Use `test` to evaluate your understanding of a topic and identify areas that need more work

## Examples

```bash
# Start a learning session on Python (estimated 2 hours)
teacher-toolkit learn Python 2

# Generate a quick quiz on machine learning
teacher-toolkit quiz "machine learning"

# Create a flashcard for a key concept
teacher-toolkit flashcard "Binary Search"

# Start a spaced repetition review
teacher-toolkit review

# Check your learning progress
teacher-toolkit progress

# Generate a learning roadmap
teacher-toolkit roadmap

# Find learning resources
teacher-toolkit resource

# Take a study note
teacher-toolkit note "Key insight: recursion requires a base case to prevent infinite loops"

# Generate a topic summary
teacher-toolkit summary "data structures"

# Test your knowledge
teacher-toolkit test "algorithms"

# View all available commands
teacher-toolkit help
```

## How It Works

Teacher Toolkit provides a simple command-line interface for managing your learning workflow. Each command handles a specific aspect of the study process:

- **Learning sessions** (`learn`) display the topic and estimated duration, logging the activity for progress tracking
- **Quizzes** (`quiz`) generate three reflective questions about a topic: what it is, how it works, and when to use it
- **Flashcards** (`flashcard`) create front/back card entries saved to the data directory for later review
- **Spaced repetition** (`review`) follows a proven schedule of increasing intervals (1, 3, 7, 14, 30 days) for long-term retention
- **Notes** (`note`) are timestamped and appended to the data log, building a chronological study journal
- **Roadmaps** (`roadmap`) provide a structured 5+ week plan: Basics → Practice → Projects

Every command is logged to `history.log` with timestamps, giving you complete visibility into your study habits.

## Tips

- Combine with grep to find specific notes: `cat ~/.local/share/teacher-toolkit/data.log | grep "Python"`
- Export your study notes: `teacher-toolkit note` entries accumulate in `data.log` — back it up regularly
- Use in a study script: chain commands like `teacher-toolkit learn "Bash" 1 && teacher-toolkit quiz "Bash"`
- Customize data location: `export TEACHER_TOOLKIT_DIR=/path/to/study/data`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
