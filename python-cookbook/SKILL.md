---
name: "python-cookbook"
description: "Python code patterns and recipes for everyday tasks. Use when you need file I/O snippets, list comprehensions, decorators, async functions, regex patterns, datetime handling, or need to lint and format Python files."
---

# python-cookbook

## Triggers on
python snippet, python code pattern, file io python, list comprehension, decorator, async python, python regex, debug python, lint python, format python

## What This Skill Does
Search and display common Python code recipes, run code snippets, check syntax, auto-format files, and look up solutions for common Python errors.

## Commands

### snippet
Search or browse built-in code snippets (file-read, file-write, json, list, dict, decorator, async, regex, date, and more).
```bash
bash scripts/script.sh snippet [keyword]
bash scripts/script.sh snippet decorator
```

### run
Execute a Python code snippet inline or from a file.
```bash
bash scripts/script.sh run 'print("hello world")'
bash scripts/script.sh run @script.py
```

### lint
Check Python file syntax using py_compile.
```bash
bash scripts/script.sh lint <file.py>
```

### format
Auto-format a Python file using black (falls back to autopep8).
```bash
bash scripts/script.sh format <file.py>
```

### debug
Show solutions for common Python errors (NameError, TypeError, IndexError, etc.).
```bash
bash scripts/script.sh debug [ErrorName]
bash scripts/script.sh debug TypeError
```

### help
Show all available commands.
```bash
bash scripts/script.sh help
```

## Requirements
- bash 4+
- python3 (standard library)
- black or autopep8 (optional, for format command)

Powered by BytesAgain | bytesagain.com
