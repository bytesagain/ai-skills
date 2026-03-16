---
version: "2.0.0"
name: Rundeck
description: "Enable Self-Service Operations: Give specific users access to your existing tools, services, and scr job-scheduler, groovy, ansible, audit, automation, category-distributed, deployment. Use when you need job-scheduler capabilities. Triggers on: job-scheduler."
---

# Rundeck

Enable Self-Service Operations: Give specific users access to your existing tools, services, and scripts ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from job-scheduler/job-scheduler

## Usage

Run any command: `job-scheduler <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
job-scheduler help
job-scheduler run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick job scheduler from the command line

## Output

Returns reports to stdout. Redirect to a file with `job-scheduler run > output.txt`.

## Configuration

Set `JOB_SCHEDULER_DIR` environment variable to change the data directory. Default: `~/.local/share/job-scheduler/`
