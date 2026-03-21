---
name: "node"
version: "1.0.0"
description: "Node.js runtime reference — event loop, modules, npm workflows, streams, cluster, debugging. Use when managing Node.js projects, troubleshooting runtime issues, or optimizing server performance."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [node, nodejs, npm, javascript, runtime, event-loop, streams, devtools]
category: "devtools"
---

# Node — Node.js Runtime Reference

Quick-reference skill for Node.js runtime internals, npm workflows, and server-side JavaScript.

## When to Use

- Understanding the Node.js event loop and async model
- Managing npm packages and resolving dependency issues
- Working with streams, buffers, and file system APIs
- Debugging Node.js applications and memory leaks
- Scaling Node.js with cluster and worker threads

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of Node.js — architecture, V8, libuv, use cases.

### `eventloop`

```bash
scripts/script.sh eventloop
```

Event loop phases — timers, I/O, check, close, microtasks, nextTick.

### `modules`

```bash
scripts/script.sh modules
```

Module systems — CommonJS vs ESM, resolution algorithm, package.json fields.

### `npm`

```bash
scripts/script.sh npm
```

npm workflows — install, audit, scripts, lockfile, publishing, workspaces.

### `streams`

```bash
scripts/script.sh streams
```

Streams API — readable, writable, transform, pipeline, backpressure.

### `debugging`

```bash
scripts/script.sh debugging
```

Debugging — inspect, Chrome DevTools, heap snapshots, CPU profiling.

### `performance`

```bash
scripts/script.sh performance
```

Performance — cluster, worker threads, memory management, benchmarking.

### `checklist`

```bash
scripts/script.sh checklist
```

Node.js production readiness checklist.

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Configuration

| Variable | Description |
|----------|-------------|
| `NODE_DIR` | Data directory (default: ~/.node/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
