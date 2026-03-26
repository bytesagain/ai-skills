---
name: squid
description: "Forward proxy server and web cache with ACL-based content filtering. Use when setting up corporate internet proxy, blocking websites by domain or URL pattern, caching HTTP traffic, authenticating proxy users via LDAP, or inspecting HTTPS with SSL bump."
version: "1.0.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: [squid, proxy, cache, content-filter, network, security]
---

# Squid Reference

Forward proxy server, web cache, and content filter. Squid sits between users and the internet, providing access control, caching, bandwidth management, and HTTPS inspection for corporate and institutional networks.

## When to Use

- Setting up a corporate forward proxy for internet access control
- Blocking websites by domain, URL pattern, or file type
- Implementing time-based access rules for social media
- Caching frequently accessed web content to save bandwidth
- Authenticating users via LDAP, RADIUS, or htpasswd
- Inspecting HTTPS traffic with SSL bump for content filtering

## Commands

| Command | Description |
|---------|-------------|
| `intro` | Architecture overview, Squid vs Varnish comparison, use cases, installation |
| `config` | squid.conf directives, ACL rules, cache settings, content filtering, time-based access |
| `operations` | Authentication setup (LDAP/htpasswd), SSL bump HTTPS inspection, monitoring and log analysis |

## Requirements

- No external dependencies — outputs reference documentation only
- No API keys required

## Feedback

https://bytesagain.com/feedback/
