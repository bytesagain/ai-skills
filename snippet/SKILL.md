---
name: Snippet
description: "Code snippet manager for your terminal. Save, organize, search, and recall frequently used code snippets, shell commands, and text templates. Tag and categorize snippets for quick retrieval. Build your personal code library without leaving the terminal."
version: "2.0.0"
author: "BytesAgain"
tags: ["snippet","code","manager","clipboard","template","cheatsheet","developer"]
categories: ["Developer Tools", "Productivity"]
---
# Snippet
Save code snippets. Find them instantly. Your personal code vault.
## Commands
- `save <name> <language> <code>` — Save a snippet
- `get <name>` — Retrieve a snippet
- `list [language]` — List saved snippets
- `search <keyword>` — Search snippets
- `delete <name>` — Remove a snippet
- `tags` — Show all languages/tags
## Usage Examples
```bash
snippet save "docker-cleanup" bash "docker system prune -af"
snippet get "docker-cleanup"
snippet list bash
snippet search "docker"
```
---
Powered by BytesAgain | bytesagain.com

- Run `snippet help` for all commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
