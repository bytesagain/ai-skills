---
name: "indexnow-pro"
version: "1.0.0"
description: "Instant search engine notification via IndexNow protocol. Ping Bing, Yandex, and IndexNow API to index new or updated pages within minutes instead of days. Supports single URL, batch URLs, sitemap submission, and key management."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [indexnow, seo, search-engine, bing, yandex, indexing, sitemap]
category: "marketing"
---

# IndexNow Pro

Notify search engines about new or updated pages instantly using the IndexNow protocol. Instead of waiting days for crawlers to discover changes, tell Bing, Yandex, and other engines directly.

## Commands

| Command | Description |
|---------|-------------|
| `ping-url` | Notify search engines about a single URL |
| `ping-batch` | Submit multiple URLs at once (up to 10,000) |
| `ping-sitemap` | Extract URLs from sitemap.xml and submit all |
| `key-setup` | Generate and host your IndexNow API key |
| `verify` | Check if your key is properly hosted |
| `engines` | List all supported search engines |
| `protocol` | IndexNow protocol specification reference |
| `best-practices` | When and how to use IndexNow effectively |

## Requirements

- A website you own
- An IndexNow key file hosted at your domain root
- curl or Node.js for API calls
