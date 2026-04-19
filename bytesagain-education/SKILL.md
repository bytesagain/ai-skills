# education

**Learning Plan Generator** — Generate structured learning paths, quizzes, and track your study progress — all stored locally, no account required.

## Commands

| Command | Description | Example |
|---------|-------------|---------|
| `plan` | Generate a structured learning plan for a topic | `plan "Python for Data Science"` |
| `quiz` | Generate quiz questions to test your knowledge | `quiz "Python for Data Science" 5` |
| `progress` | Track and display your study progress | `progress show` / `progress done "Day 1"` |

## Usage

```bash
bash script.sh plan "topic name"
bash script.sh quiz "topic name" [num_questions]
bash script.sh progress show
bash script.sh progress done "milestone name"
bash script.sh progress reset
```

## Features

- Generates 7-day learning plans with daily goals and curated free resources
- Covers 20+ topic areas: programming languages, frameworks, DevOps, math, and more
- Quiz generator with multiple-choice and open-ended questions
- Local JSON progress tracking (stored in `~/.local/share/education-skill/progress.json`)
- No internet required — all content is built-in

## Requirements

- `bash` >= 4.0
- `python3` >= 3.7
- No external packages required (uses only stdlib)

## Examples

```
$ bash script.sh plan "Docker"

📚 Learning Plan: Docker
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Duration  : 7 days
Level     : Beginner → Intermediate

Day 1: Introduction to Containers
  Goals:
    • Understand what containers are vs VMs
    • Install Docker Desktop / Docker Engine
    • Run your first container: docker run hello-world
  Resources:
    • Docker Official Docs — Get Started: https://docs.docker.com/get-started/
    • Play with Docker (free browser sandbox): https://labs.play-with-docker.com/
...
```

```
$ bash script.sh quiz "Python" 3

📝 Quiz: Python  (3 questions)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Q1. What is the output of: print(type([]))
  A) <class 'tuple'>
  B) <class 'list'>   ✓
  C) <class 'array'>
  D) <class 'dict'>

Q2. Which keyword is used to define a function in Python?
  A) function
  B) fn
  C) def   ✓
  D) lambda
...
```

```
$ bash script.sh progress show

📊 Study Progress
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Topic     : Docker
Started   : 2024-01-15
Completed : Day 1, Day 2
Remaining : Day 3, Day 4, Day 5, Day 6, Day 7
Progress  : ██████░░░░░░░░░░░░░░  2/7 days (29%)
```
