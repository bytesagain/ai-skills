---
name: MemWatch
description: "Monitor RAM usage in real time and alert on high memory consumption thresholds. Use when tracking memory, identifying RAM hogs, setting alert thresholds."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["memory","ram","monitor","system","process","swap","admin","performance"]
categories: ["System Tools", "Developer Tools"]
---

# MemWatch

Memory monitor: view usage, find top consumers, watch trends, inspect per-process memory, check swap, and alert on thresholds.

## Commands

| Command | Description |
|---------|-------------|
| `memwatch status` | Current memory usage with visual bar and breakdown |
| `memwatch top [n]` | Top N memory-consuming processes (default: 10) |
| `memwatch watch` | Snapshot memory every 2s for 10 iterations |
| `memwatch process <pid>` | Memory details for a specific PID (VmRSS, VmSize, PSS, etc.) |
| `memwatch swap` | Swap usage details with top swap consumers |
| `memwatch alert <threshold>` | Check if memory usage exceeds threshold % |
| `memwatch detailed` | Full `/proc/meminfo` dump |
| `memwatch compare` | Compare memory now vs 30 seconds later (delta) |
| `memwatch version` | Show version |

## Examples

```bash
memwatch status         # → usage %, visual bar, total/avail/cached
memwatch top 5          # → top 5 RAM consumers (PID, %MEM, RSS, CMD)
memwatch watch          # → 10 snapshots, 2s apart
memwatch process 1234   # → VmSize, VmRSS, VmSwap, PSS, threads
memwatch swap           # → swap devices, usage, top swap consumers
memwatch alert 80       # → 🚨 if usage > 80%, ✅ if under
memwatch detailed       # → full /proc/meminfo
memwatch compare        # → two snapshots 30s apart with delta
```

## Requirements

- `free`, `ps` (standard)
- `/proc/meminfo`, `/proc/[pid]/status` (Linux)
