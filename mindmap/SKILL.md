---
name: MindMap
description: "Text-based mind mapping tool. Create, organize, and visualize ideas as tree structures. Export to markdown. No GUI needed."
version: "2.0.0"
author: "BytesAgain"
tags: ["mindmap","brainstorm","ideas","organize","thinking","productivity"]
---
# MindMap
Create and visualize mind maps in your terminal.
## Commands
- `create <name>` — Create new mind map
- `add <map> <parent> <node>` — Add node (use 'root' for top-level)
- `show <name>` — Display mind map tree
- `list` — List all maps
- `export <name>` — Export as markdown
---
Powered by BytesAgain | bytesagain.com

## Examples

```bash
# Show help
mindmap help

# Run
mindmap run
```

- Run `mindmap help` for commands
- No API keys needed

- Run `mindmap help` for all commands

- Run `mindmap help` for all commands

## When to Use

- Quick mindmap tasks from terminal
- Automation pipelines

## Output

Results go to stdout. Save with `mindmap run > output.txt`.

## Configuration

Set `MINDMAP_DIR` to change data directory. Default: `~/.local/share/mindmap/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
