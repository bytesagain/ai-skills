---
name: LinkBox
description: "Bookmark and link manager for saving, organizing, and searching your favorite URLs. Tag links by category, add descriptions, search across your collection, view most-used links, and export your bookmark library. Never lose an important link again."
version: "2.0.0"
author: "BytesAgain"
tags: ["bookmarks","links","url","organize","save","browser","web","reference"]
categories: ["Productivity", "Utility"]
---
# LinkBox
Save links. Find them later. Your personal bookmark manager.
## Commands
- `save <url> [tag] [description]` — Save a link
- `list [tag]` — List saved links
- `search <keyword>` — Search links
- `tags` — Show all tags
- `delete <url>` — Remove a link
- `export` — Export as markdown
## Usage Examples
```bash
linkbox save https://example.com dev "Great tutorial"
linkbox list dev
linkbox search tutorial
```
---
Powered by BytesAgain | bytesagain.com

- Run `linkbox help` for all commands

## Configuration

Set `LINKBOX_DIR` to change data directory. Default: `~/.local/share/linkbox/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
