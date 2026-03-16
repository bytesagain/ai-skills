---
version: "2.0.0"
name: clawhub-manager
description: "Clawhub Manager — Clawhub Manager tool. Use when you need clawhub manager capabilities. Triggers on: clawhub manager."
---

# ClawHub Skill Manager

All-in-one dashboard for managing your ClawHub skills portfolio. Track downloads, manage multi-account publishing, sync with your website, monitor quality, and generate reports — all from one command.

Multi-account ClawHub management, skill portfolio tracker, download analytics, publishing queue, website sync, quality audit, hourly stats, growth trends, account quota tracker, skill inventory, bulk operations, report generator.

## Commands

- `accounts` — List all configured accounts with token status, skill count, and quota remaining
- `stats` — Fetch download stats for all your skills across all accounts with TOP rankings and growth trends
- `publish-queue` — Show pending skills, priority order, estimated time to complete, and per-account quota usage
- `publish` — Publish next batch of skills with smart account rotation and rate limit awareness
- `sync-website` — Generate HTML snippet for your website with skill cards, download badges, and search functionality
- `audit` — Run quality checks: syntax validation, prompt-shell detection, missing files, empty input handling
- `report` — Generate a complete portfolio report (text or HTML) with charts and trends
- `inventory` — Full skill inventory: slug, account, version, downloads, status, last updated
- `verify-slugs` — Check which slugs you own vs taken by others, with owner identification
- `growth` — Show download growth trends: hourly, daily, weekly with projections
- `backup` — Export full skill data (metadata + stats) to JSON for archival
- `health` — System health check: token validity, API connectivity, cron status, data freshness
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
clawhub-manager help
clawhub-manager run
```
