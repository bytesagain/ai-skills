---
name: RegexPal
description: "Test and debug regex patterns against sample text. Use when checking match groups, validating patterns, generating replacements, linting syntax."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["regex","regular-expression","pattern","matcher","tester","developer","text"]
categories: ["Developer Tools", "Utility"]
---

# RegexPal

A real regex tester and toolkit for the terminal. Test patterns against text, find matches in files with highlighted output, perform replacements, extract capturing groups, and get human-readable explanations of regex syntax.

## Commands

| Command | Description |
|---------|-------------|
| `regexpal test <pattern> <text>` | Test if a regex matches text — reports full match, partial match, groups, and named groups |
| `regexpal match <pattern> <file>` | Find all matches in a file — highlights matches in red, shows line numbers and match count |
| `regexpal replace <pattern> <replacement> <file>` | Replace all matches in a file and output to stdout. Supports backreferences (`\1`, `\2`) |
| `regexpal extract <pattern> <file>` | Extract capturing groups from all matches in a file — shows each group value per match |
| `regexpal explain <pattern>` | Break down a regex pattern — lists character classes, groups, tokens, and quantifiers |

## Requirements

- `python3` (uses `re` stdlib module)

## Examples

```bash
# Test a pattern
regexpal test '^\d{3}-\d{4}$' '123-4567'

# Find emails in a file
regexpal match '\w+@[\w.-]+' contacts.txt

# Replace version numbers
regexpal replace 'v(\d+)\.(\d+)' 'v\1.$((\\2+1))' changelog.md

# Extract domain parts from emails
regexpal extract '(\w+)@(\w+\.\w+)' emails.txt

# Understand a complex pattern
regexpal explain '(?<=@)[\w.-]+'
```
