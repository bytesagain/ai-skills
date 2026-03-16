---
version: "2.0.0"
name: Labelimg
description: "LabelImg is now part of the Label Studio community. The popular image annotation tool created by Tzu image-labeler, python, annotations, deep-learning, detection, image-classification, imagenet. Use when you need image-labeler capabilities. Triggers on: image-labeler."
---

# Labelimg

LabelImg is now part of the Label Studio community. The popular image annotation tool created by Tzutalin is no longer actively being developed, but you can check out Label Studio, the open source data labeling tool for images, text, hypertext, audio, video and time-series data. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from HumanSignal/labelImg

## Usage

Run any command: `image-labeler <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
image-labeler help
image-labeler run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick image labeler from the command line

## Output

Returns structured data to stdout. Redirect to a file with `image-labeler run > output.txt`.

## Configuration

Set `IMAGE_LABELER_DIR` environment variable to change the data directory. Default: `~/.local/share/image-labeler/`
