---
version: "2.0.0"
name: bytesagain-sleep-tracker
description: "睡眠改善工具。睡眠分析、改善建议、作息规划、睡眠环境优化、小睡指南、睡眠日记。Sleep tracker with analysis, improvement tips, schedule planning, environment optimization, nap guide."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# sleep-tracker

Health and wellness tracker for logging daily activities, tracking streaks, viewing statistics, setting reminders and goals, and getting health tips. A versatile CLI tool for building and maintaining healthy habits.

## Commands

| Command | Description |
|---------|-------------|
| `sleep-tracker log <entry>` | Log a new entry with today's date |
| `sleep-tracker today` | Show all entries logged today |
| `sleep-tracker streak` | Check your current streak of consecutive days |
| `sleep-tracker stats` | Show total number of entries in the data log |
| `sleep-tracker reminder <task> [time]` | Set a reminder for a task (default time: 8:00) |
| `sleep-tracker tips` | Get health tips (hydration, movement, sleep) |
| `sleep-tracker goal <goal> [frequency]` | Set a goal with optional frequency (default: daily) |
| `sleep-tracker history` | View the last 14 entries from the data log |
| `sleep-tracker export` | Export all data to stdout |
| `sleep-tracker reset` | Reset tracker (requires `--confirm` flag to actually clear data) |
| `sleep-tracker help` | Show help message with all available commands |
| `sleep-tracker version` | Show version number |

## How It Works

`sleep-tracker` manages a simple text-based data log (`data.log`) where each entry is automatically stamped with the current date. It provides a lightweight way to track health activities, build streaks, and review your history.

### Daily Workflow

1. **Log activities**: Record what you did — exercise, meals, sleep times, etc.
2. **Check today**: Review everything logged today with `sleep-tracker today`
3. **Track progress**: Use `streak` to see consecutive days and `stats` for totals
4. **Set goals and reminders**: Keep yourself accountable with `goal` and `reminder`
5. **Review history**: Look at the last 2 weeks with `history`

## Data Storage

All data is stored in `$SLEEP_TRACKER_DIR` or defaults to `~/.local/share/sleep-tracker/`. The directory contains:

- `data.log` — main data file with date-stamped entries
- `history.log` — timestamped log of all commands executed for auditing

The tool automatically creates the data directory on first run. You can override the storage location by setting the `SLEEP_TRACKER_DIR` environment variable.

## Requirements

- **Shell**: Bash 4+
- **No external dependencies** — uses only standard Unix utilities (`date`, `grep`, `wc`, `tail`, `cat`)
- **Works on**: Linux, macOS, any POSIX-compatible system

## When to Use

1. **Daily health logging** — Run `sleep-tracker log "8h sleep, felt rested"` each morning to build a habit history
2. **Tracking exercise streaks** — Log workouts daily and check `sleep-tracker streak` to stay motivated with consecutive-day tracking
3. **Setting health reminders** — Use `sleep-tracker reminder "drink water" 14:00` to record reminder notes for key health tasks
4. **Reviewing weekly patterns** — Run `sleep-tracker history` to see the last 14 entries and spot trends in your health data
5. **Exporting data for analysis** — Use `sleep-tracker export > health-data.txt` to get all records into a file for spreadsheet analysis or sharing with a health professional

## Examples

```bash
# Log a sleep entry
sleep-tracker log "Slept 7.5 hours, quality 4/5"

# Log exercise
sleep-tracker log "30 min jog, 5km"

# Log meals
sleep-tracker log "Healthy breakfast: oatmeal, fruit, coffee"

# Check what you logged today
sleep-tracker today

# View your streak
sleep-tracker streak

# Get overall statistics
sleep-tracker stats

# Set a daily water reminder
sleep-tracker reminder "drink 2L water" 10:00

# Set a fitness goal
sleep-tracker goal "run 5km" weekly

# Get health tips
sleep-tracker tips

# View the last 14 entries
sleep-tracker history

# Export all data to a file
sleep-tracker export > my-health-log.txt

# Reset (dry run — shows instructions)
sleep-tracker reset
```

## Health Tips (Built-in)

The `tips` command provides three core health reminders:

1. **Stay hydrated** — drink water throughout the day
2. **Move every hour** — take short breaks from sitting
3. **Sleep 7-8 hours** — prioritize consistent rest

## Configuration

Set the `SLEEP_TRACKER_DIR` environment variable to change the data directory:

```bash
export SLEEP_TRACKER_DIR="$HOME/my-health-data"
```

Default location: `~/.local/share/sleep-tracker/`

## Output

All output goes to stdout in plain text. Use shell redirection to save results:

```bash
sleep-tracker history > weekly-review.txt
sleep-tracker export | grep "2024-03"
```

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
