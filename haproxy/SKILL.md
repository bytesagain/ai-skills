---
name: "haproxy"
version: "1.0.0"
description: "HAProxy load balancer reference. Frontend binds with ACL routing, backend server pools with health checks, balance algorithms (roundrobin/leastconn/source), SSL termination with SNI, stick-table rate limiting, and stats/Prometheus monitoring."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [haproxy, loadbalancer, proxy, http, ssl, sysops]
category: "sysops"
---

# HAProxy

HAProxy high-performance load balancer reference.

## Commands

| Command | Description |
|---------|-------------|
| `intro` | HAProxy overview, L4/L7, architecture |
| `config` | Config structure: global/defaults/frontend/backend |
| `frontend` | Binds, ACLs, routing, request manipulation |
| `backend` | Servers, balance algorithms, sticky sessions |
| `health` | Health check options, agent checks |
| `ssl` | SSL termination, SNI, ciphers, HSTS |
| `stick-tables` | Rate limiting, connection tracking |
| `stats` | Stats page, Prometheus, runtime management |
