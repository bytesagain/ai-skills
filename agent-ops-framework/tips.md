# Agent Ops Framework — Tips & Usage Guide

## Quick Setup for BytesAgain

```bash
# Initialize
export OPS_STATE_DIR="$HOME/.openclaw/workspace/.ops"
OPS="bash $HOME/.openclaw/workspace/skills/agent-ops-framework/scripts/ops.sh"

$OPS init --project "bytesagain-skills"

# Register our team
$OPS agent add --name "dev" --role "developer" --desc "Builds new skills and upgrades"
$OPS agent add --name "qa" --role "reviewer" --desc "Tests syntax, completeness, quality"
$OPS agent add --name "publisher" --role "deployer" --desc "Publishes to ClawHub"
$OPS agent add --name "webmaster" --role "webmaster" --desc "Syncs bytesagain.com"
$OPS agent add --name "monitor" --role "observer" --desc "Tracks downloads and alerts"

# Set quotas
$OPS quota set --name "clawhub-publish" --limit 100 --period "daily"
$OPS quota set --name "api-requests" --limit 300 --period "hourly"
```

## Daily Workflow

1. **Morning**: `$OPS dashboard` — see where things stand
2. **Dev builds**: `$OPS task move --id X --to in-progress`
3. **QA reviews**: `$OPS task move --id X --to review --output /path/`
4. **QA approves**: `$OPS task move --id X --to done --approved-by qa`
5. **Publisher ships**: `$OPS task move --id X --to deployed --deploy-ref v1.0.0`
6. **Evening**: `$OPS report` — daily summary

## Cron Integration

```bash
# Every hour: monitor check
17 * * * * bash /path/to/ops.sh monitor >> /tmp/ops-monitor.log 2>&1

# Every 6 hours: report
0 */6 * * * bash /path/to/ops.sh report >> /tmp/ops-report.log 2>&1
```

## Key Principle

**The orchestrator (楼台) never implements.**
Delegate everything, track everything, decide everything.
