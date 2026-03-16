---
name: portfolio
version: "2.0.0"
author: BytesAgain
license: MIT-0
tags: [portfolio, tool, utility]
description: "Portfolio - command-line tool for everyday use"
---

# Portfolio

Investment portfolio tracker — track holdings, calculate returns, asset allocation analysis, dividend tracking, rebalancing suggestions, and performance reports.

## Commands

| Command | Description |
|---------|-------------|
| `portfolio add` | <ticker> <qty> <price> |
| `portfolio holdings` | Holdings |
| `portfolio returns` | Returns |
| `portfolio allocation` | Allocation |
| `portfolio dividends` | Dividends |
| `portfolio rebalance` | Rebalance |

## Usage

```bash
# Show help
portfolio help

# Quick start
portfolio add <ticker> <qty> <price>
```

## Examples

```bash
# Example 1
portfolio add <ticker> <qty> <price>

# Example 2
portfolio holdings
```

- Run `portfolio help` for all available commands

## When to Use

- for batch processing portfolio operations
- as part of a larger automation pipeline

## Output

Returns logs to stdout. Redirect to a file with `portfolio run > output.txt`.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*

- Run `portfolio help` for all commands
