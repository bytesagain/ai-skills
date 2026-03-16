---
version: "2.0.0"
name: Imagemagick
description: "ImageMagick is a free, open-source software suite for creating, editing, converting, and displaying image-processor, c, command-line-image-tool, digital-image-editing, image-conversion, image-manipulation, image-processing. Use when you need image-processor capabilities. Triggers on: image-processor."
---

# Imagemagick

ImageMagick is a free, open-source software suite for creating, editing, converting, and displaying images. It supports 200+ formats and offers powerful command-line tools and APIs for automation, scripting, and integration across platforms. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from ImageMagick/ImageMagick

## Usage

Run any command: `image-processor <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
image-processor help
image-processor run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick image processor from the command line

## Output

Returns logs to stdout. Redirect to a file with `image-processor run > output.txt`.

## Configuration

Set `IMAGE_PROCESSOR_DIR` environment variable to change the data directory. Default: `~/.local/share/image-processor/`
