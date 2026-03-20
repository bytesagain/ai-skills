---
name: TokenCount
description: "Count words, characters, and estimate GPT tokens with readability. Use when tracking length, checking budgets, comparing complexity."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["token","word","count","text","nlp","ai","gpt"]
categories: ["Developer Tools", "Utility"]
---

# TokenCount

A real text and token counter for the terminal. Count words, lines, characters, and sentences. Estimate LLM token usage with cost projections. Analyze word frequency and compare files side by side.

## Commands

| Command | Description |
|---------|-------------|
| `tokencount count <file\|text>` | Count words, lines, characters, sentences, paragraphs, avg word length, and reading time. Works with files or inline text |
| `tokencount tokens <file>` | Estimate LLM token count using 3 methods (chars÷4, words×1.33, bytes÷3.5), shows cost estimates for GPT-4 class models and context window usage bars |
| `tokencount freq <file>` | Full word frequency analysis — ranked table with counts, percentages, bar chart, and vocabulary richness score |
| `tokencount top <file> [n]` | Show top N most common words (default: 20) |
| `tokencount diff <file1> <file2>` | Compare two files — side-by-side word/line/char/token counts, unique words in each, common vocabulary |

## Requirements

- Standard Unix tools: `wc`, `awk`, `sort`, `tr`, `grep`, `comm`

## Examples

```bash
# Count everything in a file
tokencount count README.md

# Count inline text
tokencount count "Hello world, this is a test."

# Estimate tokens and costs
tokencount tokens article.txt

# Word frequency analysis
tokencount freq novel.txt

# Top 10 words
tokencount top essay.txt 10

# Compare two drafts
tokencount diff draft-v1.txt draft-v2.txt
```
