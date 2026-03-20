---
name: "wp-manager"
version: "4.0.0"
description: "Manage WordPress sites with cookie auth, page CRUD, duplicate detection, and batch cleanup. Requires curl."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# wp-manager

Manage WordPress sites with cookie-based authentication, content CRUD, duplicate page detection, and batch cleanup. Use when managing WordPress pages, cleaning duplicates, or syncing content.

## Requirements

- curl (HTTP requests)
- python3 (JSON parsing)
- WordPress site with REST API enabled

## Configuration

Set `WP_URL` environment variable or defaults to `https://bytesagain.com`.
WordPress credentials read from `.env` file automatically.

## Commands

### `login`

```bash
scripts/script.sh login [password]
# Auto-reads WP_PASS from .env if no password given
```

### `status`

```bash
scripts/script.sh status
# Shows site health + session age
```

### `list-pages`

```bash
scripts/script.sh list-pages [count] [page]
# Paginated page listing with ID, slug, date, status
```

### `list-all-pages`

```bash
scripts/script.sh list-all-pages
# Fetches ALL pages to local cache (all-pages.jsonl)
```

### `create-page`

```bash
scripts/script.sh create-page "Title" "Content" "slug" "publish"
```

### `delete-page`

```bash
scripts/script.sh delete-page <page-id>
```

### `delete-batch`

```bash
scripts/script.sh delete-batch <ids-file>
# Delete multiple pages from a file of IDs (one per line)
```

### `find-duplicates`

```bash
scripts/script.sh find-duplicates
# Scans all pages, finds slug-2/slug-3 copies, saves IDs for deletion
```

### `clean-duplicates`

```bash
scripts/script.sh clean-duplicates
# Interactive: deletes duplicate pages found by find-duplicates
```

### `clean-blacklisted`

```bash
scripts/script.sh clean-blacklisted [blacklist-file]
# Finds WP pages matching blacklisted skill slugs
```

### `search`

```bash
scripts/script.sh search <query>
```

## Data Storage

Session cookies and page cache stored in `~/.local/share/wp-manager/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
