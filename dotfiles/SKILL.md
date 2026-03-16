---
name: Dotfiles
description: "Dotfiles manager and backup tool. Track, backup, restore, and sync your configuration files (.bashrc, .vimrc, .gitconfig, etc.) across machines. List managed dotfiles, create symlinks, diff local vs backed-up versions, and bootstrap new environments."
version: "2.0.0"
author: "BytesAgain"
tags: ["dotfiles","config","backup","sync","bashrc","vimrc","setup","developer"]
categories: ["Developer Tools", "System Tools", "Productivity"]
---
# Dotfiles
Manage your dotfiles. Backup. Sync. Never lose your configs again.
## Commands
- `track <file>` — Start tracking a dotfile
- `list` — List tracked dotfiles
- `backup [dir]` — Backup all tracked dotfiles
- `restore <backup_dir>` — Restore from backup
- `diff` — Show differences between tracked and current files
- `common` — Show common dotfiles to track
## Usage Examples
```bash
dotfiles track ~/.bashrc
dotfiles track ~/.gitconfig
dotfiles list
dotfiles backup ~/dotfiles-backup
dotfiles diff
```
---
Powered by BytesAgain | bytesagain.com

- Run `dotfiles help` for all commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
