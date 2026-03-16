# Workflow Automator — Tips & Best Practices

> Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

## Quick Start

```bash
# Initialize a workflow project
bash scripts/main.sh init

# Generate a backup template
bash scripts/main.sh template backup

# Validate before running
bash scripts/main.sh validate workflows/backup.yml

# Run it
bash scripts/main.sh run workflows/backup.yml

# Check the logs
bash scripts/main.sh log

# Schedule it daily at 2 AM
bash scripts/main.sh schedule workflows/backup.yml "0 2 * * *"
```

## Usage Examples

### 1. Create a Custom Workflow

```yaml
# workflows/deploy-app.yml
name: deploy-app
description: Deploy application to production
retry: 1

steps:
  - name: pull-latest
    run: cd /opt/myapp && git pull origin main
  - name: install-deps
    run: cd /opt/myapp && npm install --production
  - name: build
    run: cd /opt/myapp && npm run build
    timeout: 120
  - name: restart-service
    run: systemctl restart myapp
  - name: health-check
    run: curl -sf http://localhost:3000/health || exit 1
    retry: 5
  - name: notify
    run: echo "Deploy complete at $(date)"
```

### 2. Conditional Steps

```yaml
name: smart-backup
steps:
  - name: check-space
    run: echo "Checking disk space..."
  - name: backup-if-space
    run: tar czf /backups/data.tar.gz /data
    condition: test $(df /backups --output=pcent | tail -1 | tr -d ' %') -lt 90
  - name: skip-message
    run: echo "Skipped backup — disk usage too high"
    condition: test $(df /backups --output=pcent | tail -1 | tr -d ' %') -ge 90
```

### 3. View Execution History

```bash
# Show last 10 runs
bash scripts/main.sh history

# Show last 20 runs
bash scripts/main.sh history 20

# Show status of a specific run
bash scripts/main.sh status <run_id>

# View detailed log
bash scripts/main.sh log <run_id>
```

### 4. Export and Share

```bash
# Export a workflow as a shareable bundle
bash scripts/main.sh export workflows/deploy-app.yml

# The output is a base64 archive you can share via chat/email
# Recipient decodes with: base64 -d < bundle.b64 | tar xzf -
```

### 5. List All Workflows

```bash
bash scripts/main.sh list
# Output:
#   example.yml          — example-workflow       (3 steps)  [last: success]
#   deploy-app.yml       — deploy-app             (5 steps)  [never run]
#   smart-backup.yml     — smart-backup           (3 steps)  [last: failed]
```

## Best Practices

### 1. Always Validate First
Run `validate` before `run` — catches missing fields, bad structure, and syntax errors before they cause runtime failures.

### 2. Use Retry for Flaky Steps
Network requests, service restarts, and health checks can be flaky. Set `retry: 3` or higher for these steps.

### 3. Add Health Checks
After deploying or restarting services, always include a health check step with retries.

### 4. Use Conditions for Safety
Add disk space checks, service status checks, or environment variable guards to prevent dangerous operations.

### 5. Keep Workflows Small
Break large workflows into focused ones. "deploy" and "rollback" should be separate workflows rather than one mega-flow.

### 6. Review Logs Regularly
Check `history` and `log` periodically. Failed runs that nobody notices are worse than no automation.

### 7. Test in Staging First
Before scheduling a workflow, run it manually a few times. Then schedule with confidence.

### 8. Use Templates as Starting Points
The built-in templates (`backup`, `deploy`, `monitor`, `report`) cover common patterns. Customize them rather than starting from scratch.

### 9. Schedule During Off-Peak Hours
Heavy workflows (backups, reports) should run during low-traffic periods. Use cron expressions like `0 3 * * *` (3 AM).

### 10. Clean Up Old Runs
Execution history accumulates over time. Periodically review and archive old run data from `.workflow/runs/`.

## Cron Expression Cheat Sheet

| Expression | Meaning |
|-----------|---------|
| `* * * * *` | Every minute |
| `0 * * * *` | Every hour |
| `0 2 * * *` | Daily at 2 AM |
| `0 9 * * 1` | Every Monday at 9 AM |
| `0 0 1 * *` | First day of every month |
| `*/5 * * * *` | Every 5 minutes |
| `0 2 * * 0` | Every Sunday at 2 AM |

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Workflow is locked" | Another instance is running. Wait or remove the lock file in `.workflow/runs/` |
| Step keeps failing | Check the log with `log <run_id>`, look for exit codes and stderr output |
| Cron not running | Verify with `crontab -l`, check system cron daemon is running |
| Condition always skips | Test your condition manually in the shell first |
| Permission denied | Ensure the `run` commands have appropriate permissions |

## File Structure Reference

```
workflows/
├── .workflow/
│   ├── config              # Project config (created by init)
│   ├── runs/
│   │   └── <run_id>/
│   │       ├── status      # success|failed|running
│   │       ├── workflow     # Which workflow ran
│   │       ├── started      # Start timestamp
│   │       ├── finished     # End timestamp
│   │       └── log          # Full execution log
│   └── schedules/
│       └── <workflow>.cron  # Cron expression for scheduled workflows
├── templates/              # Generated templates live here
├── example.yml             # Sample workflow (created by init)
└── your-workflow.yml       # Your custom workflows
```
