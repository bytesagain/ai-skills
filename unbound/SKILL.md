---
name: unbound
description: "Validating recursive DNS resolver with DNSSEC support. Use when setting up private recursive DNS, validating DNSSEC signature chains, configuring DNS-over-TLS forwarding, serving as Pi-hole upstream resolver, or managing local DNS zones."
version: "1.0.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: [unbound, dns, resolver, dnssec, privacy, networking]
---

# Unbound Reference

Validating recursive DNS resolver that queries root servers directly without forwarding to third-party DNS providers. Unbound validates DNSSEC signatures to protect against DNS spoofing and runs with minimal resources on any Linux system or Raspberry Pi.

## When to Use

- Setting up a private recursive DNS resolver (no forwarding to Google/Cloudflare)
- Validating DNSSEC signature chains for DNS security
- Configuring DNS-over-TLS for encrypted upstream forwarding
- Using as Pi-hole upstream resolver for ad blocking with full privacy
- Managing local DNS zones and custom DNS records
- Monitoring DNS cache performance and query statistics

## Commands

| Command | Description |
|---------|-------------|
| `intro` | Architecture overview, Unbound vs BIND vs Pi-hole comparison, installation |
| `config` | unbound.conf directives, recursive vs forwarding mode, local zones, Pi-hole integration |
| `operations` | unbound-control CLI, DNSSEC testing and validation, cache management, Prometheus monitoring |

## Requirements

- No external dependencies — outputs reference documentation only
- No API keys required

## Feedback

https://bytesagain.com/feedback/
