---
version: "2.0.0"
name: Doccano
description: "Open source annotation tool for machine learning practitioners. text-annotator, python, annotation-tool, data-labeling, dataset, datasets, machine-learning. Use when you need text-annotator capabilities. Triggers on: text-annotator."
---

# Doccano

Open source annotation tool for machine learning practitioners. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from text-annotator/text-annotator

## Usage

Run any command: `text-annotator <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
text-annotator help
text-annotator run
```

## When to Use

- to automate text tasks in your workflow
- for batch processing annotator operations

## Output

Returns logs to stdout. Redirect to a file with `text-annotator run > output.txt`.

## Configuration

Set `TEXT_ANNOTATOR_DIR` environment variable to change the data directory. Default: `~/.local/share/text-annotator/`
