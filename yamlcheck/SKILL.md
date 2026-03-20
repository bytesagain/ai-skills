---
name: YAMLCheck
description: "Validate YAML syntax using python3, lint configs, and convert YAML to JSON. Use when checking syntax, finding errors, or converting formats."
version: "3.0.2"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["yaml","validator","lint","formatter","json","developer"]
categories: ["Developer Tools", "Utility"]
---

# YAMLCheck

A real YAML validator and toolkit. Check syntax, convert YAML to JSON, lint for style issues, and list top-level keys. Uses PyYAML when available, falls back to basic parsing when not.

## Commands

| Command | Description |
|---------|-------------|
| `yamlcheck validate <file>` | Validate YAML syntax — reports document count, types, key counts, file size. Falls back to basic tab/colon checks without PyYAML |
| `yamlcheck to-json <file>` | Convert YAML to formatted JSON output. Handles multi-document YAML files |
| `yamlcheck lint <file>` | Check for common style issues: tabs, trailing whitespace, Windows line endings, odd indentation, missing spaces after colons, long lines |
| `yamlcheck keys <file>` | List top-level keys with types and value previews |

## Requirements

- `python3` (required)
- `PyYAML` (optional — enables full parsing; install with `pip3 install pyyaml`)

Without PyYAML, the tool still works but uses basic regex-based checks instead of full YAML parsing.

## Examples

```bash
# Validate a docker-compose file
yamlcheck validate docker-compose.yml

# Convert YAML config to JSON
yamlcheck to-json values.yaml

# Check for style issues
yamlcheck lint playbook.yml

# See what keys are defined
yamlcheck keys config.yaml
```
