---
name: "clone"
version: "1.0.0"
description: "Clone and mirror directories with snapshots. Use when creating backups or syncing folders."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# clone

Clone and mirror directories with snapshots. Use when creating backups or syncing folders.

## Commands

### `dir`

```bash
scripts/script.sh dir <src dest>
```

### `mirror`

```bash
scripts/script.sh mirror <src dest>
```

### `diff`

```bash
scripts/script.sh diff <dir1 dir2>
```

### `snapshot`

```bash
scripts/script.sh snapshot <dir>
```

### `list`

```bash
scripts/script.sh list
```

### `restore`

```bash
scripts/script.sh restore <snapshot dest>
```

## Data Storage

Data stored in `~/.local/share/clone/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
