---
version: "3.0.1"
name: task-planner
description: "Plan and prioritize tasks with due dates and reminders. Use when adding tasks, listing priorities, tracking completion, planning schedules."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# task-planner

CLI tool for task planner

## Commands

### `add`

```bash
scripts/script.sh add
```

### `list`

```bash
scripts/script.sh list
```

### `done`

```bash
scripts/script.sh done
```

### `remove`

```bash
scripts/script.sh remove
```

### `edit`

```bash
scripts/script.sh edit
```

### `search`

```bash
scripts/script.sh search
```

### `today`

```bash
scripts/script.sh today
```

### `overdue`

```bash
scripts/script.sh overdue
```

### `stats`

```bash
scripts/script.sh stats
```

### `export`

```bash
scripts/script.sh export
```

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Examples

```bash
scripts/script.sh help
scripts/script.sh add
```

## Configuration

| Variable | Required | Description |
|----------|----------|-------------|
| `TASK_PLANNER_DIR` | No | Data directory (default: `~/.task-planner/`) |

## Data Storage

All data saved in `~/.task-planner/`. Runs on your machine without external calls.

## Requirements

- bash 4.0+

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
