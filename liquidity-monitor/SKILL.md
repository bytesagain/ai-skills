---
name: "liquidity-monitor"
version: "3.0.0"
description: "Monitor DeFi liquidity pools and TVL using DeFiLlama API. Use when tracking DeFi yields. Requires curl."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# liquidity-monitor

Monitor DeFi liquidity pools and TVL using DeFiLlama API. Use when tracking DeFi yields. Requires curl.

## Commands

### `tvl`

```bash
scripts/script.sh tvl <protocol>
```

### `top`

```bash
scripts/script.sh top <count>
```

### `pool`

```bash
scripts/script.sh pool <pair>
```

### `alerts`

```bash
scripts/script.sh alerts
```

### `history`

```bash
scripts/script.sh history <pool>
```

### `yield`

```bash
scripts/script.sh yield <pool>
```

## Data Storage

Data stored in `~/.local/share/liquidity-monitor/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
