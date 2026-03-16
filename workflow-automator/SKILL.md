---
name: workflow-automator
version: "2.0.0"
author: BytesAgain
license: MIT-0
description: "Workflow Automator - command-line tool for everyday use"
---

# Workflow Automator

> OpenClaw-native workflow automation engine — define, run, schedule, and manage task pipelines from the CLI.

## Description

Workflow Automator is a lightweight, zero-dependency workflow engine built entirely in Bash. It lets AI agents and humans define multi-step task pipelines using a simplified YAML format, then run them sequentially with built-in logging, error handling, retry logic, conditional branching, and cron-based scheduling.

Unlike heavier orchestration tools that require Python, Node.js, or Docker, Workflow Automator runs anywhere Bash runs — your laptop, a VPS, a Raspberry Pi, or a CI/CD runner. It's designed to be the native automation backbone for OpenClaw deployments.

## Use When

- Defining repeatable multi-step task pipelines (backup, deploy, monitor, report)
- Scheduling automated workflows via cron
- Running sequential commands with logging and error tracking
- Managing workflow execution history and status
- Generating workflow templates for common operations
- Exporting workflows to share with teammates or across machines
- Validating workflow files before execution
- Any automation task that would otherwise be a messy collection of shell scripts

## Commands

| Command | Description |
|---------|-------------|
| `init` | Initialize a workflow project — creates directory structure, sample workflow file, and configuration |
| `run <file>` | Execute a workflow file step-by-step with full logging, retry on failure, and status tracking |
| `validate <file>` | Validate workflow file syntax — checks structure, required fields, and step definitions |
| `list` | List all workflow files in the current project with name, step count, and last-run status |
| `status [run_id]` | Show current running workflows or details of a specific run |
| `log [run_id]` | View execution logs — latest run by default, or specify a run ID |
| `schedule <file> <cron>` | Schedule a workflow to run on a cron expression (e.g., `0 2 * * *` for daily at 2 AM) |
| `template <type>` | Generate a workflow template: `backup`, `deploy`, `monitor`, `report` |
| `export <file>` | Export a workflow as a self-contained shareable bundle (base64-encoded archive) |
| `history [n]` | Show execution history — last 10 runs by default, or specify count |

## Workflow File Format

Workflows use a simplified YAML format that can be parsed by Bash without external dependencies:

```yaml
name: daily-backup
description: "Back up database and notify team. Use when you need workflow automator capabilities. Triggers on: workflow automator."
retry: 2
on_failure: notify

steps:
  - name: check-disk
    run: df -h | head -5
  - name: backup-db
    run: pg_dump mydb > /backups/backup-$(date +%Y%m%d).sql
    retry: 3
  - name: compress
    run: gzip /backups/backup-$(date +%Y%m%d).sql
    condition: test -f /backups/backup-$(date +%Y%m%d).sql
  - name: notify
    run: echo "Backup completed successfully at $(date)"
```

### Supported Fields

- **name** (required): Workflow name identifier
- **description**: Human-readable description
- **retry**: Default retry count for all steps (default: 0)
- **on_failure**: Command to run if workflow fails
- **steps**: Ordered list of execution steps
  - **name** (required): Step identifier
  - **run** (required): Shell command to execute
  - **retry**: Per-step retry override
  - **condition**: Shell expression — step runs only if this returns 0
  - **timeout**: Maximum seconds for this step (default: 300)
  - **on_failure**: Per-step failure handler

## Project Structure

After `init`, your workflow project looks like:

```
workflows/
├── .workflow/
│   ├── config          # Project configuration
│   ├── runs/           # Execution history and logs
│   └── schedules/      # Cron schedule definitions
├── templates/          # Generated templates
└── example.yml         # Sample workflow
```

## Features

- **Zero dependencies** — pure Bash, no Python/Node/Ruby required
- **Step-by-step execution** — each step logged with timestamps and exit codes
- **Error retry** — configurable retry count per step or globally
- **Conditional steps** — skip steps based on shell conditions
- **Cron scheduling** — native crontab integration for recurring workflows
- **Execution history** — full audit trail of every run
- **Templates** — quick-start templates for backup, deploy, monitor, report
- **Export/share** — bundle workflows for sharing across machines
- **Colored output** — clear visual feedback during execution
- **Parallel-safe** — lock files prevent concurrent runs of the same workflow

## Integration with OpenClaw

The agent can use Workflow Automator to:

1. **Automate repetitive tasks** — define once, run forever
2. **Schedule maintenance** — backups, cleanups, health checks via cron
3. **Build deployment pipelines** — multi-step deploy with rollback
4. **Monitor systems** — periodic checks with alerting on failure
5. **Generate reports** — scheduled data collection and formatting

## Script

The main script is located at:

```
scripts/main.sh
```

Run commands via: `bash scripts/main.sh <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
