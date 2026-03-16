---
name: TidyUp
description: "File organizer and disk cleanup toolkit. Auto-sort files into categories (Images, Documents, Videos, Code, etc.), find duplicate files by content hash, discover largest files eating disk space, locate empty directories, and view recently modified files. Essential disk hygiene tool."
version: "2.0.0"
author: "BytesAgain"
tags: ["files","organize","cleanup","disk","duplicates","sort","storage","utility"]
categories: ["Utility", "System Tools", "Productivity"]
---

# TidyUp

Clean up your files. Find duplicates. Reclaim disk space. TidyUp is your disk hygiene toolkit.

## Why TidyUp?

- **Auto-sort**: Organize files into categories by extension
- **Duplicate finder**: Find identical files by content hash
- **Space analyzer**: Discover your largest files
- **Empty dir finder**: Locate empty directories
- **Recent files**: See what changed recently

## Commands

- `sort [directory]` — Auto-sort files into categories (Images, Documents, Videos, Audio, Archives, Code, Other)
- `duplicates [directory]` — Find duplicate files by MD5 hash
- `size [directory] [n]` — Show top n largest files (default: 20)
- `empty [directory]` — Find empty directories
- `recent [directory] [n]` — Show n most recently modified files (default: 10)
- `info` — Version info
- `help` — Show commands

## Usage Examples

```bash
tidyup sort ~/Downloads
tidyup duplicates ~/Documents
tidyup size /home 30
tidyup empty ~/projects
tidyup recent . 15
```

## Sort Categories

Files are sorted by extension into: Images (.jpg, .png, .gif...), Documents (.pdf, .doc, .txt...), Videos (.mp4, .avi...), Audio (.mp3, .wav...), Archives (.zip, .tar...), Code (.py, .js, .sh...), Other.

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
