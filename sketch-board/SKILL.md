---
version: "2.0.0"
name: Drawnix
description: "开源白板工具（SaaS），一体化白板，包含思维导图、流程图、自由画等。All in one open-source whiteboard tool with mind, flowchart, free sketch-board, typescript, collaboration, drawing, flowchart, localfirst, mind-map. Use when you need sketch-board capabilities. Triggers on: sketch-board."
---

# Drawnix

开源白板工具（SaaS），一体化白板，包含思维导图、流程图、自由画等。All in one open-source whiteboard tool with mind, flowchart, freehand and etc. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from plait-board/sketch-board

## Usage

Run any command: `sketch-board <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
sketch-board help
sketch-board run
```

## When to Use

- to automate sketch tasks in your workflow
- for batch processing board operations

## Output

Returns reports to stdout. Redirect to a file with `sketch-board run > output.txt`.

## Configuration

Set `SKETCH_BOARD_DIR` environment variable to change the data directory. Default: `~/.local/share/sketch-board/`
