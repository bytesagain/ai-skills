---
version: "1.0.0"
name: Krillinai
description: "Video translation and dubbing tool powered by LLMs. The video translator offers 100 language transla subtitle-translator, go, dubbing, localization, tts."
---
# Subtitle Translator

Subtitle Translator v2.0.0 — a versatile utility toolkit for logging, tracking, and managing subtitle translation entries from the command line. Each command logs timestamped entries to individual log files, provides history viewing, summary statistics, data export, and full-text search across all records.

## Commands

Run `subtitle-translator <command> [args]` to use.

| Command | Description |
|---------|-------------|
| `run <input>` | Log a run entry (or view recent run entries if no input given) |
| `check <input>` | Log a check entry (or view recent check entries if no input given) |
| `convert <input>` | Log a convert entry (or view recent convert entries if no input given) |
| `analyze <input>` | Log an analyze entry (or view recent analyze entries if no input given) |
| `generate <input>` | Log a generate entry (or view recent generate entries if no input given) |
| `preview <input>` | Log a preview entry (or view recent preview entries if no input given) |
| `batch <input>` | Log a batch entry (or view recent batch entries if no input given) |
| `compare <input>` | Log a compare entry (or view recent compare entries if no input given) |
| `export <input>` | Log an export entry (or view recent export entries if no input given) |
| `config <input>` | Log a config entry (or view recent config entries if no input given) |
| `status <input>` | Log a status entry (or view recent status entries if no input given) |
| `report <input>` | Log a report entry (or view recent report entries if no input given) |
| `stats` | Show summary statistics across all log files (entry counts, data size) |
| `export <fmt>` | Export all data in json, csv, or txt format |
| `search <term>` | Full-text search across all log entries (case-insensitive) |
| `recent` | Show the 20 most recent entries from history.log |
| `help` | Show usage help |
| `version` | Show version (v2.0.0) |

## How It Works

Every command (run, check, convert, analyze, etc.) works the same way:

- **With arguments:** Saves a timestamped entry (`YYYY-MM-DD HH:MM|input`) to `<command>.log` and writes to `history.log`.
- **Without arguments:** Displays the 20 most recent entries from that command's log file.

This gives you a lightweight, file-based logging system for tracking subtitle translation tasks, conversion jobs, and localization workflows.

## Data Storage

All data is stored locally in `~/.local/share/subtitle-translator/`:

```
~/.local/share/subtitle-translator/
├── run.log          # Run entries (timestamp|value)
├── check.log        # Check entries
├── convert.log      # Convert entries
├── analyze.log      # Analyze entries
├── generate.log     # Generate entries
├── preview.log      # Preview entries
├── batch.log        # Batch entries
├── compare.log      # Compare entries
├── export.log       # Export entries
├── config.log       # Config entries
├── status.log       # Status entries
├── report.log       # Report entries
├── history.log      # Master activity log
└── export.<fmt>     # Exported data files
```

## Requirements

- Bash (4.0+)
- Standard POSIX utilities: `date`, `wc`, `du`, `tail`, `grep`, `sed`, `cat`
- No external dependencies — works on any Linux or macOS system out of the box

## When to Use

1. **Tracking subtitle translation jobs** — Use `subtitle-translator run "video_01.srt EN→ZH"` to log each translation task with timestamps.
2. **Converting subtitle formats** — Use `subtitle-translator convert "SRT to VTT for episode 5"` to record format conversion tasks.
3. **Batch processing multiple files** — Use `subtitle-translator batch "Season 2 episodes 1-10 translated"` to log bulk operations.
4. **Analyzing translation quality** — Use `subtitle-translator analyze "QA review pass 2"` to log quality reviews, then `search` to find specific entries.
5. **Generating translation reports** — Use `subtitle-translator report "Monthly output: 45 files"` to log milestones, then `export csv` for client reports.

## Examples

```bash
# Log a translation run
subtitle-translator run "movie_trailer.srt EN to JP"

# Log a format conversion
subtitle-translator convert "batch SRT→VTT for season 3"

# Preview recent entries
subtitle-translator preview

# Check recent activity
subtitle-translator recent

# Search for Japanese translation entries
subtitle-translator search "JP"

# Get summary statistics
subtitle-translator stats

# Export all records to JSON
subtitle-translator export json
```

## Output

All commands output to stdout. Redirect to a file if needed:

```bash
subtitle-translator stats > summary.txt
subtitle-translator export csv  # writes to ~/.local/share/subtitle-translator/export.csv
```

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
