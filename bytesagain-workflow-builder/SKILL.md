---
description: "Create and run multi-step shell workflows with status tracking. Use when automating deployment sequences, chaining build steps, running CI pipelines locally, or tracking multi-stage task execution."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# bytesagain-workflow-builder

Build, run, and track multi-step workflows from the terminal. Define pipeline steps with shell commands, execute them in sequence, and monitor status with detailed progress tracking.

## Usage

```
bytesagain-workflow-builder create "<name>"
bytesagain-workflow-builder add-step <id> "<step_name>" "<command>"
bytesagain-workflow-builder run <id>
bytesagain-workflow-builder status <id>
bytesagain-workflow-builder list
bytesagain-workflow-builder export <id>
bytesagain-workflow-builder template <type>
```

## Commands

- `create` — Create a new named workflow and get its ID
- `add-step` — Add a shell command step to a workflow
- `run` — Execute all steps in sequence, stopping on failure
- `status` — Show per-step execution status and output
- `list` — List all workflows with step counts and last run time
- `export` — Export workflow definition as JSON
- `template` — Show starter templates (ci, deploy)

## Examples

```bash
bytesagain-workflow-builder create "Release Pipeline"
bytesagain-workflow-builder add-step wf001 "Run Tests" "npm test"
bytesagain-workflow-builder add-step wf001 "Build" "npm run build"
bytesagain-workflow-builder add-step wf001 "Deploy" "rsync -av dist/ server:/var/www/"
bytesagain-workflow-builder run wf001
bytesagain-workflow-builder status wf001
```

## Requirements

- bash
- python3

## When to Use

Use when automating multi-step processes, building CI-like pipelines locally, tracking deployment steps, or managing repeatable task sequences with clear pass/fail status.
