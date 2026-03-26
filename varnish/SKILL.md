---
name: varnish
description: "HTTP accelerator and reverse proxy cache with VCL configuration language. Use when caching dynamic web pages, writing VCL rules for cache control, purging stale content, load balancing backends, or speeding up WordPress and high-traffic sites."
version: "1.0.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: [varnish, cache, http, reverse-proxy, performance, vcl]
---

# Varnish Reference

HTTP accelerator and caching reverse proxy that serves cached content from memory in sub-millisecond response times. Varnish uses VCL (Varnish Configuration Language), a domain-specific language that compiles to C for maximum performance.

## When to Use

- Accelerating dynamic websites by caching responses in RAM
- Writing VCL rules for fine-grained cache control and routing
- Purging or banning cached content by URL or pattern
- Load balancing across multiple backend servers with health checks
- Implementing ESI (Edge Side Includes) for partial page caching
- Optimizing WordPress or CMS performance at the edge

## Commands

| Command | Description |
|---------|-------------|
| `intro` | Architecture overview, Varnish vs Nginx caching vs CDN comparison, installation |
| `vcl` | VCL configuration language, caching rules, backend setup, load balancing, grace mode |
| `operations` | CLI tools (varnishstat/varnishlog), purge and ban patterns, ESI, WordPress integration |

## Requirements

- No external dependencies — outputs reference documentation only
- No API keys required

## Feedback

https://bytesagain.com/feedback/
