---
name: Label Studio
description: "Label Studio is a multi-type data labeling and annotation tool with standardized output format Based on HumanSignal/label-studio (26,713+ GitHub stars). label studio, typescript, annotation, annotation-tool, annotations, boundingbox, computer-vision"
version: "2.0.0"
license: Apache-2.0
runtime: python3
---

# Label Studio

Label Studio is a multi-type data labeling and annotation tool with standardized output format

Inspired by [HumanSignal/label-studio]([configured-endpoint]) (26,713+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from HumanSignal/label-studio

## Usage

Run any command: `label-studio <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
label-studio help
label-studio run
```

## When to Use

- to automate label tasks in your workflow
- for batch processing studio operations

## Output

Returns summaries to stdout. Redirect to a file with `label-studio run > output.txt`.

## Configuration

Set `LABEL_STUDIO_DIR` environment variable to change the data directory. Default: `~/.local/share/label-studio/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
