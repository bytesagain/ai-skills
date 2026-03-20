---
name: "onchain-analyzer"
version: "3.0.0"
description: "Analyze blockchain data with address lookups and transaction inspection. Use when investigating on-chain activity. Requires curl."
author: "BytesAgain"
homepage: "https://bytesagain.com"
---

# onchain-analyzer

Analyze blockchain data with address lookups and transaction inspection. Use when investigating on-chain activity. Requires curl.

## Commands

### `balance`

```bash
scripts/script.sh balance <addr>
```

### `tx`

```bash
scripts/script.sh tx <hash>
```

### `address`

```bash
scripts/script.sh address <addr>
```

### `gas`

```bash
scripts/script.sh gas
```

### `block`

```bash
scripts/script.sh block <number>
```

### `token`

```bash
scripts/script.sh token <addr>
```

## Data Storage

Data stored in `~/.local/share/onchain-analyzer/`.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
