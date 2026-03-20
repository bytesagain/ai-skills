---
name: slug-checker
version: 1.0.0
description: "Check ClawHub slug availability in bulk. Handles API rate limits by falling back to headless browser verification."
category: developer-tools
author: BytesAgain
---

# slug-checker

Batch check slug availability on ClawHub with automatic fallback.

## Why This Exists

ClawHub API has aggressive rate limiting (429 after ~50 requests). Browser-based checking bypasses this but needs correct page-state detection.

## Key Lessons (Hard-Won)

1. **API 429 ≠ "slug taken"** — Never assume. 429 means "rate limited, unknown status"
2. **"Loading skill…" = slug is FREE** — ClawHub shows this placeholder for non-existent slugs, NOT a 404 page
3. **Page with real content = slug EXISTS** — Look for description text, author info, download counts
4. **Check page text length** — Free slugs have <200 chars of meaningful text, taken slugs have 500+
5. **Owner detection** — Search for `@username` pattern in page text
6. **Our accounts** — Match against: bytesagain, BytesAgain2, ckchzh, xueyetianya, bytesagain1, bytesagain3, bytesagain4

## Detection Logic

```
IF page contains "Loading skill" OR text length < 200:
    → SLUG IS FREE
ELIF page contains our account names:
    → SLUG IS OURS
ELSE:
    → SLUG IS TAKEN (extract @owner)
```

## Commands

```bash
slug-checker check <slug>           # Check single slug
slug-checker batch <file>           # Check list from file (one slug per line)
slug-checker report                 # Show last batch results
slug-checker free                   # List only free slugs from last batch
slug-checker taken                  # List only taken slugs from last batch
```

## Usage

```bash
# Check a single slug
slug-checker check robot

# Batch check from file
echo -e "pdps\nplc\nscada" > /tmp/slugs.txt
slug-checker batch /tmp/slugs.txt

# View results
slug-checker free
slug-checker taken
```

## Strategy: API First, Browser Fallback

1. Try API (`/api/v1/skills/{slug}`) — fast, 0.3s/slug
2. If 429 rate limited → queue for browser check
3. Browser check — slower (1s/slug) but no rate limit
4. Cache results to avoid re-checking

## Anti-Patterns (Don't Do This)

- ❌ Treating 429 as "taken" — loses free slugs
- ❌ Checking `not found` / `404` text only — ClawHub shows "Loading skill…" for free slugs
- ❌ Assuming API status 200 body has owner info — `owner` field sometimes returns `unknown`
- ❌ Running 200+ API calls without delay — triggers 429 after ~50

## Rate Limit Reference

- API: ~50 requests before 429, needs 5-10 min cooldown
- Browser: no limit observed, but 0.8-1s delay recommended
- Mixed strategy: API for first 40, browser for rest

Built by BytesAgain | bytesagain.com
