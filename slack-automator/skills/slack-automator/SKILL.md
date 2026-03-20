---
version: "4.0.0"
name: slack-automator
description: "Automate Slack messaging, channels, and search with Block Kit. Use when sending scheduled messages, syncing channels, monitoring chats, notifying teams."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# slack-automator

Send messages to Slack channels via Incoming Webhooks. Supports direct messaging, channel notifications, message templates with variable substitution, scheduled messages, formatting helpers, and full send history with export.

## Requirements

- **bash** 4.0+
- **curl** (for HTTP requests to Slack)
- **python3** (for JSON handling — typically pre-installed)
- **Slack Incoming Webhook URL** — see setup below

### How to Get a Slack Webhook URL

1. Go to [https://api.slack.com/apps](https://api.slack.com/apps)
2. Click **Create New App** → **From scratch**
3. Name it (e.g., "Automator") and select your workspace
4. In the left sidebar, click **Incoming Webhooks**
5. Toggle **Activate Incoming Webhooks** to **On**
6. Click **Add New Webhook to Workspace**
7. Select the channel to post to and click **Allow**
8. Copy the webhook URL (starts with `https://hooks.slack.com/services/...`)

## Setup

Configure the webhook URL before sending messages:

```bash
scripts/script.sh connect https://hooks.slack.com/services/T00000/B00000/xxxxxxxx
```

Verify connectivity:

```bash
scripts/script.sh webhook test
```

## Commands

### `connect <webhook_url>`

Save a Slack Incoming Webhook URL to local configuration. The URL is stored in `~/.slack-automator/config.json`.

```bash
# Save your webhook URL
scripts/script.sh connect https://hooks.slack.com/services/T00000/B00000/xxxxxxxx
# ✅ Webhook URL saved.
```

### `send <message>`

Send a plain text message to Slack via the configured webhook.

```bash
# Send a simple message
scripts/script.sh send "Hello from Slack Automator!"

# Send a message with emoji
scripts/script.sh send "🚀 Deployment complete — v2.1.0 is live!"

# Send multi-word messages
scripts/script.sh send Build succeeded, all 142 tests passing.
```

### `notify <channel> <message>`

Send a message to a specific Slack channel. The channel name will be prefixed with `#` if not already present.

```bash
# Notify the alerts channel
scripts/script.sh notify alerts "⚠️ Server CPU at 95%!"

# Notify with # prefix (also works)
scripts/script.sh notify "#deployments" "v3.0.2 deployed to production"

# Notify the team channel
scripts/script.sh notify general "Standup in 5 minutes!"
```

### `schedule add <time> <message>`

Add a scheduled message. Time can be in `HH:MM` format (converted to daily cron) or a full cron expression. Schedules are saved to `~/.slack-automator/schedule.json`.

```bash
# Schedule a daily message at 9:00 AM
scripts/script.sh schedule add 09:00 "Good morning, team! ☀️"

# Schedule with cron expression (every Friday at 6 PM)
scripts/script.sh schedule add "0 18 * * 5" "Happy Friday! 🎉"

# Schedule hourly reminder
scripts/script.sh schedule add "0 * * * *" "Hourly status check"
```

> **Note:** Schedules are saved locally. To actually trigger them, set up a cron job that runs `slack-automator send` with the scheduled messages.

### `schedule list`

Display all scheduled messages with their IDs, cron expressions, and status.

```bash
scripts/script.sh schedule list
# === Scheduled Messages ===
#   ✅ [1710820800] 0 9 * * * — Good morning, team! ☀️
#   ✅ [1710820900] 0 18 * * 5 — Happy Friday! 🎉
```

### `schedule remove <id>`

Remove a scheduled message by its ID.

```bash
scripts/script.sh schedule remove 1710820900
# ✅ Removed schedule 1710820900.
```

### `template list`

List all saved message templates.

```bash
scripts/script.sh template list
# === Message Templates ===
#   📝 deploy — 🚀 Deployed *{{service}}* to production.
#   📝 alert — ⚠️ Alert: {{message}} (severity: {{level}})
```

### `template save <name> <message>`

Save a reusable message template. Use `{{variable}}` placeholders for dynamic values.

```bash
# Save a deploy notification template
scripts/script.sh template save deploy "🚀 Deployed *{{service}}* to production ({{version}})."

# Save an alert template
scripts/script.sh template save alert "⚠️ {{level}}: {{message}}"

# Save a welcome template
scripts/script.sh template save welcome "👋 Welcome to the team, {{name}}!"
```

### `template use <name> [var=value ...]`

Send a message using a saved template. Variables in `{{var}}` are replaced with provided `var=value` pairs.

```bash
# Use deploy template with variables
scripts/script.sh template use deploy service=api-server version=v2.1.0
# Sends: 🚀 Deployed *api-server* to production (v2.1.0).

# Use alert template
scripts/script.sh template use alert level=HIGH message="Database connection timeout"

# Use welcome template
scripts/script.sh template use welcome name=Alice
```

### `webhook test`

Send a test message to verify webhook connectivity. The test message includes a timestamp.

```bash
scripts/script.sh webhook test
# Testing webhook connectivity...
# ✅ Webhook is working! Test message sent.
```

### `webhook info`

Show the current webhook configuration. The URL is partially masked for security.

```bash
scripts/script.sh webhook info
# === Webhook Configuration ===
#   URL: https://hooks.slack.com/services/T0...xxxxxxxx
#   Full URL stored in: ~/.slack-automator/config.json
```

### `format <style> <message>`

Format a message using Slack's mrkdwn syntax and optionally send it. Available styles:

| Style       | Slack Syntax       | Example Output        |
|-------------|--------------------|-----------------------|
| `bold`      | `*text*`           | **text**              |
| `italic`    | `_text_`           | _text_                |
| `code`      | `` `text` ``       | `text`                |
| `codeblock` | `` ```text``` ``   | code block            |
| `quote`     | `> text`           | quoted text           |
| `strike`    | `~text~`           | ~~text~~              |
| `list`      | `• item`           | bulleted list         |

```bash
# Format as bold
scripts/script.sh format bold "Important announcement"
# Output: *Important announcement*

# Format as code block
scripts/script.sh format codeblock "const x = 42;"
# Output: ```const x = 42;```

# Format comma-separated items as bullet list
scripts/script.sh format list "Task 1, Task 2, Task 3"
# Output:
# • Task 1
# • Task 2
# • Task 3
```

### `history`

Show the 20 most recent messages from the send history, including timestamps, actions, status, and channels.

```bash
scripts/script.sh history
# === Message History ===
#   ✅ [2025-03-19 09:00:00] send: Good morning, team!
#   ✅ [2025-03-19 09:15:30] notify → #alerts: CPU alert cleared
#   ❌ [2025-03-19 10:00:00] send: Failed message (webhook down)
#   Total: 42 message(s)
```

### `stats`

Show usage statistics including message counts, success rate, action breakdown, and date range.

```bash
scripts/script.sh stats
# === Slack Automator Stats ===
#   Messages sent:    42
#   Successful:       40
#   Failed:           2
#   Success rate:     95.2%
#   Scheduled:        3
#   Templates:        5
#
#   Actions breakdown:
#     send: 30
#     notify: 8
#     template-use: 4
#
#   Period: 2025-01-15 → 2025-03-19
```

### `export <format>`

Export message history to a file. Supported formats: `json`, `csv`, `txt`.

```bash
# Export as JSON
scripts/script.sh export json
# ✅ Exported history to ~/.slack-automator/export.json

# Export as CSV (for spreadsheets)
scripts/script.sh export csv
# ✅ Exported 42 entries to ~/.slack-automator/export.csv

# Export as plain text
scripts/script.sh export txt
```

### `config [key] [value]`

View or set configuration values. Available keys: `webhook_url`, `default_channel`, `username`, `icon_emoji`.

```bash
# View all configuration
scripts/script.sh config
# === Slack Automator Configuration ===
#   webhook_url = https://hooks.slack.com/...
#   default_channel = #general

# Set a specific value
scripts/script.sh config default_channel "#engineering"
# ✅ Set default_channel = #engineering

# Get a specific value
scripts/script.sh config default_channel
# default_channel = #engineering
```

### `help`

Print usage information and the list of all available commands.

```bash
scripts/script.sh help
```

### `version`

Print the current version string.

```bash
scripts/script.sh version
# slack-automator v3.0.2
```

## Data Storage

All data is stored in `~/.slack-automator/`:

| File                  | Purpose                        |
|-----------------------|--------------------------------|
| `config.json`         | Webhook URL and settings       |
| `history.json`        | Complete message send history  |
| `schedule.json`       | Scheduled messages             |
| `templates/`          | Saved message templates (`.txt`) |

## Examples

### Quick Start

```bash
# 1. Connect your webhook
scripts/script.sh connect https://hooks.slack.com/services/T00/B00/xxx

# 2. Test it works
scripts/script.sh webhook test

# 3. Send your first message
scripts/script.sh send "Hello, Slack! 👋"
```

### CI/CD Integration

```bash
# Save a deploy template
scripts/script.sh template save deploy "🚀 *{{service}}* deployed to *{{env}}* ({{version}})"

# Use it in your pipeline
scripts/script.sh template use deploy service=web-app env=production version=v1.2.3
```

### Monitoring Alerts

```bash
# Direct alert to a channel
scripts/script.sh notify alerts "🔴 Database connection pool exhausted — 0/50 available"

# Formatted alert
scripts/script.sh format bold "CRITICAL: Payment service unreachable"
```

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
