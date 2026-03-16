---
name: student
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [student, tool, utility]
description: "Student - command-line tool for everyday use"
---

# Student

Student productivity toolkit — assignment tracking, study timer, GPA calculator, note organizer, exam scheduler, and study group coordination.

## Commands

| Command | Description |
|---------|-------------|
| `student assignments` | Assignments |
| `student timer` | [minutes] |
| `student gpa` | Gpa |
| `student notes` | <subject> |
| `student exams` | Exams |
| `student groups` | Groups |

## Usage

```bash
# Show help
student help

# Quick start
student assignments
```

## Examples

```bash
# Example 1
student assignments

# Example 2
student timer [minutes]
```

- Run `student help` for all available commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

## When to Use

- Quick student tasks from terminal
- Automation pipelines

## Output

Results go to stdout. Save with `student run > output.txt`.

## Configuration

Set `STUDENT_DIR` to change data directory. Default: `~/.local/share/student/`
