# ClawHub Skill Manager — Tips

## Setup

Before using, configure your accounts in `~/.clawhub-manager/config.json`:

```json
{
  "accounts": [
    {"name": "my-account-1", "token": "clh_xxx..."},
    {"name": "my-account-2", "token": "clh_yyy..."}
  ],
  "skills_dir": "/path/to/your/skills",
  "website": {
    "wp_url": "https://yoursite.com",
    "wp_user": "admin",
    "wp_pass": "your-app-password",
    "page_id": 64
  },
  "email": {
    "smtp_host": "smtp.gmail.com",
    "smtp_port": 587,
    "from": "you@gmail.com",
    "to": "you@gmail.com",
    "app_pass": "your-app-password"
  },
  "data_dir": "~/.clawhub-manager/data"
}
```

## Rate Limits

- ClawHub allows 5 new skills/hour, 20/day per account
- Version updates are exempt from rate limits
- The tool tracks quota per account and rotates automatically

## Multi-Account Strategy

- Spread skills across accounts to maximize daily publishing capacity
- Each account has independent rate limits
- The publish command auto-rotates through accounts with available quota

## Data Files

All data is stored in `~/.clawhub-manager/data/`:
- `stats-YYYY-MM-DD.json` — Daily download snapshots
- `inventory.json` — Full skill inventory with account mapping
- `publish-queue.json` — Publishing queue state
- `audit-results.json` — Latest quality audit results

## Cron Setup

For automated hourly tracking:
```
17 * * * * /path/to/clawhub-manager.sh stats --auto >> /var/log/clawhub-manager.log 2>&1
```

## Website Sync

The `sync-website` command generates a complete HTML page with:
- Categorized skill cards with download badges
- Search/filter functionality
- Featured section for top performers
- Mobile-responsive design
- Auto-updating download counts

## Quality Audit Checks

The `audit` command checks for:
1. Bash syntax errors (`bash -n`)
2. SKILL.md exists and is >500 bytes
3. tips.md exists
4. Script files exist in scripts/
5. No hardcoded credentials
6. Prompt-only detection (scripts that just echo without computation)
7. User input validation
8. Brand footer present
