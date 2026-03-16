---
name: DupFinder
description: "Duplicate file finder and cleaner. Scan directories for duplicate files by content hash (MD5/SHA256), find files with identical names, compare file sizes, and identify wasted disk space from duplicates. Clean up storage without losing unique files."
version: "2.0.0"
author: "BytesAgain"
tags: ["duplicate","finder","files","cleanup","storage","hash","disk","dedup"]
categories: ["System Tools", "Utility"]
---
# DupFinder
Find duplicate files. Reclaim wasted disk space. Keep your storage clean.
## Commands
- `scan [dir]` — Scan for duplicate files
- `names [dir]` — Find files with same names
- `size [dir]` — Find files with same sizes
- `report [dir]` — Detailed duplicate report with space savings
## Usage Examples
```bash
dupfinder scan ~/Documents
dupfinder names ~/Downloads
dupfinder report /home
```
---
Powered by BytesAgain | bytesagain.com

- Run `dupfinder help` for all commands

## When to Use

- when you need quick dupfinder from the command line
- to automate dupfinder tasks in your workflow

## Output

Returns results to stdout. Redirect to a file with `dupfinder run > output.txt`.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
