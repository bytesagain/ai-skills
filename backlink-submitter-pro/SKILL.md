---
name: "backlink-submitter-pro"
version: "1.0.0"
description: "Automated backlink submission to 8+ directory sites (SaaSHub, Uneed, Dang.ai, SubmitAITools, 600.tools, Startup88, Toolverto, Bai.tools). Configures product info once, then submits to multiple directories with one command. Includes rate limiting, retry logic, and submission tracking."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [backlink, seo, directory, submission, marketing, automation, indie-hacker]
category: "marketing"
---

# Backlink Submitter Pro

Automated directory site submission toolkit for indie hackers and product makers. Configure your product info once, then submit to 8+ free directory sites with a single command.

## Commands

| Command | Description |
|---------|-------------|
| `setup` | Configure product info (name, URL, description, email) |
| `submit-all` | Submit to all supported directory sites |
| `submit-site` | Submit to a specific directory site |
| `scout` | Discover submit pages and form fields on any website |
| `check-status` | Check submission status across all sites |
| `site-list` | Show all supported directory sites with details |
| `rate-guide` | Submission pacing and rate limit guidelines |
| `troubleshoot` | Common issues and solutions for each site |

## Supported Directory Sites

| Site | DA/DR | Auth Required | Review Time | CAPTCHA |
|------|-------|---------------|-------------|---------|
| SaaSHub | High | Email login | Same day | None |
| SubmitAITools | DA 73 | None | 1-3 days | Color CAPTCHA (auto) |
| Toolverto | Medium | None | 1-3 days | None |
| Uneed | DR 72 | Email login | Queued | None |
| 600.tools | Medium | None | 1-3 days | Turnstile |
| Dang.ai | DA 35 | None | 3-4 weeks | None |
| Startup88 | DA 34 | None | 1-2 weeks | Typeform |
| Bai.tools | Medium | Google OAuth | ~30 days | None |

## Requirements

- Node.js 18+
- rebrowser-playwright (Chromium installed)
- config.yaml with product details
