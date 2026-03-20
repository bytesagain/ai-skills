---
name: ProcMon
description: "Watch and control running processes in real time. Use when scanning active PIDs, monitoring resource spikes, reporting trees, alerting on crashes."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["process","monitor","manager","kill","system","admin","top","htop"]
categories: ["System Tools", "Developer Tools"]
---

# ProcMon

Process monitor: list, filter, and watch processes, find zombies, identify CPU/memory hogs, count by state, and log process stats.

## Commands

| Command | Description |
|---------|-------------|
| `procmon list [filter]` | List processes (optionally filter by name) |
| `procmon watch <name>` | Monitor a named process (5 snapshots, 2s interval) |
| `procmon zombie` | Find zombie processes with parent info |
| `procmon heavy` | Show top 10 CPU and top 10 memory processes |
| `procmon count` | Count processes by state (running, sleeping, zombie, etc.) |
| `procmon log <name>` | Log matching process stats to `~/.procmon/<name>.log` |
| `procmon tree [pid]` | Show process tree (full or rooted at PID) |
| `procmon ports` | Show processes listening on network ports |
| `procmon version` | Show version |

## Examples

```bash
procmon list               # → top 25 processes by CPU
procmon list nginx         # → filter for nginx processes
procmon watch sshd         # → 5 snapshots of sshd, 2s apart
procmon zombie             # → find zombie processes
procmon heavy              # → top 10 by CPU + top 10 by memory
procmon count              # → process state breakdown
procmon log node           # → log node process stats to file
procmon tree               # → full process tree
procmon tree 1             # → tree rooted at PID 1
procmon ports              # → listening ports with PIDs
```

## Requirements

- `ps` (standard)
- `pstree` (optional, for tree view)
- `ss` or `netstat` (optional, for port listing)
