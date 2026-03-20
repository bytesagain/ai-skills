---
name: "perftest"
version: "3.0.0"
description: "Run HTTP performance tests with latency and throughput measurement. Use when benchmarking web services. Requires curl."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# perftest

Run HTTP performance tests with latency and throughput measurement. Use when benchmarking web services. Requires curl.

## Commands

### `http`

```bash
scripts/script.sh http <url count>
```

### `latency`

```bash
scripts/script.sh latency <host>
```

### `throughput`

```bash
scripts/script.sh throughput <url>
```

### `stress`

```bash
scripts/script.sh stress <url concurrent>
```

### `report`

```bash
scripts/script.sh report <logfile>
```

### `compare`

```bash
scripts/script.sh compare <f1 f2>
```

## Data Storage

Data stored in `~/.local/share/perftest/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
