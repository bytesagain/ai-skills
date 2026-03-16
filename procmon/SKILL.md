---
name: ProcMon
description: "Process monitor and manager. List running processes with resource usage, search processes by name, monitor specific process CPU and memory over time, send signals to processes, and view process trees. System process management made simple."
version: "2.0.0"
author: "BytesAgain"
tags: ["process","monitor","manager","kill","system","admin","top","htop"]
categories: ["System Tools", "Developer Tools"]
---
# ProcMon
Monitor and manage processes. Find, watch, and control what's running.
## Commands
- `list [filter]` — List processes (optional name filter)
- `top [n]` — Top N processes by CPU
- `mem [n]` — Top N processes by memory
- `watch <pid>` — Monitor a process over time
- `tree` — Show process tree
- `find <name>` — Find processes by name
- `signal <pid> <signal>` — Send signal to process
## Usage Examples
```bash
procmon list python
procmon top 10
procmon find nginx
procmon watch 1234
procmon tree
```
---
Powered by BytesAgain | bytesagain.com

## When to Use

- as part of a larger automation pipeline
- when you need quick procmon from the command line

## Output

Returns results to stdout. Redirect to a file with `procmon run > output.txt`.

## Configuration

Set `PROCMON_DIR` environment variable to change the data directory. Default: `~/.local/share/procmon/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
