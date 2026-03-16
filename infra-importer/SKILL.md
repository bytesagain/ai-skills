---
version: "2.0.0"
name: Terraformer
description: "CLI tool to generate terraform files from existing infrastructure (reverse Terraform). Infrastructur infra-importer, go, aws, cloud, gcp, golang, google-cloud. Use when you need infra-importer capabilities. Triggers on: infra-importer."
---

# Terraformer

CLI tool to generate terraform files from existing infrastructure (reverse Terraform). Infrastructure to Code ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from GoogleCloudPlatform/infra-importer

## Usage

Run any command: `infra-importer <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
infra-importer help
infra-importer run
```

## When to Use

- for batch processing importer operations
- as part of a larger automation pipeline

## Output

Returns summaries to stdout. Redirect to a file with `infra-importer run > output.txt`.
