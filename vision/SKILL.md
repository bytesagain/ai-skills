---
name: vision
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [vision, tool, utility]
description: "Vision - command-line tool for everyday use"
---

# Vision

Computer vision toolkit — image analysis, object detection descriptions, OCR text extraction, image comparison, metadata reading, and format conversion.

## Commands

| Command | Description |
|---------|-------------|
| `vision analyze` | <image> |
| `vision ocr` | <image> |
| `vision compare` | <img1> <img2> |
| `vision metadata` | <image> |
| `vision convert` | <image> <format> |
| `vision resize` | <image> <WxH> |

## Usage

```bash
# Show help
vision help

# Quick start
vision analyze <image>
```

## Examples

```bash
# Example 1
vision analyze <image>

# Example 2
vision ocr <image>
```

- Run `vision help` for all available commands

## When to Use

- to automate vision tasks in your workflow
- for batch processing vision operations

## Output

Returns formatted output to stdout. Redirect to a file with `vision run > output.txt`.

## Configuration

Set `VISION_DIR` environment variable to change the data directory. Default: `~/.local/share/vision/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

- Run `vision help` for all commands
