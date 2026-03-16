---
name: The Silver Searcher
description: "A code-searching tool similar to ack, but faster. Based on ggreer/the_silver_searcher (27,234+ GitHub stars). the silver searcher, c, ag, c, command-line-tool, pcre, search-in-text"
version: "2.0.0"
license: Apache-2.0
runtime: python3
---

# The Silver Searcher

A code-searching tool similar to ack, but faster.

Inspired by [ggreer/the_silver_searcher]([configured-endpoint]) (27,234+ GitHub stars).

## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from ggreer/the_silver_searcher

## Usage

Run any command: `the-silver-searcher <command> [args]`

---
Powered by BytesAgain | bytesagain.com | hello@bytesagain.com


## Examples

```bash
the-silver-searcher help
the-silver-searcher run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick the silver searcher from the command line

## Output

Returns formatted output to stdout. Redirect to a file with `the-silver-searcher run > output.txt`.

## Configuration

Set `THE_SILVER_SEARCHER_DIR` environment variable to change the data directory. Default: `~/.local/share/the-silver-searcher/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
