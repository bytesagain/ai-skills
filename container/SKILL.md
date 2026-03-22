---
name: "container"
version: "1.0.0"
description: "Container technology reference — Docker, OCI images, namespaces, cgroups, and container runtime internals. Use when understanding container isolation, image layering, or debugging container issues."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [container, docker, oci, cgroups, namespaces, runtime, devops]
category: "devtools"
---

# Container — Container Technology Reference

Quick-reference skill for container internals, image formats, and runtime mechanics.

## When to Use

- Understanding how containers provide process isolation
- Debugging container networking, storage, or resource issues
- Learning OCI image specification and layer mechanics
- Comparing container runtimes (runc, containerd, CRI-O)
- Optimizing Dockerfile builds for smaller, faster images

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of container technology — history, OCI standards, and architecture.

### `namespaces`

```bash
scripts/script.sh namespaces
```

Linux namespaces — the isolation mechanism behind containers.

### `cgroups`

```bash
scripts/script.sh cgroups
```

Control groups — resource limiting for CPU, memory, I/O, and PIDs.

### `images`

```bash
scripts/script.sh images
```

OCI image format — layers, manifests, and union filesystems.

### `networking`

```bash
scripts/script.sh networking
```

Container networking — bridge, host, overlay, and CNI plugins.

### `storage`

```bash
scripts/script.sh storage
```

Container storage — volumes, bind mounts, and storage drivers.

### `runtimes`

```bash
scripts/script.sh runtimes
```

Container runtimes compared: runc, containerd, CRI-O, Kata, gVisor.

### `security`

```bash
scripts/script.sh security
```

Container security — capabilities, seccomp, AppArmor, rootless mode.

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
| `CONTAINER_DIR` | Data directory (default: ~/.container/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
