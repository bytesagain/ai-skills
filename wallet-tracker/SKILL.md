---
version: "2.0.0"
name: Wallet Tracker
description: "Multi-chain wallet asset tracker — monitor EVM and Solana wallets, aggregate portfolio, and detect holding changes. Use when you need wallet tracker capabilities. Triggers on: wallet tracker."
author: BytesAgain
---

# Wallet Tracker 👛

Track multiple wallets across EVM chains and Solana. Aggregate your portfolio, monitor holding changes, and get alerts when significant movements happen.

## Scenarios & Use Cases

### Scenario 1: Personal Portfolio Overview

You hold assets across 5 wallets on Ethereum, Polygon, and Solana. You want a single dashboard.

```bash
bash scripts/wallet-tracker.sh portfolio \
  --wallets "0xABC123...,0xDEF456...,5KtPn1..." \
  --chains "ethereum,polygon,solana"
```

**Output:** An HTML report showing total value, per-chain breakdown, and per-wallet holdings.

---

### Scenario 2: Whale Watching

Track a known whale wallet for large movements:

```bash
bash scripts/wallet-tracker.sh watch \
  --wallet "0xWhale..." \
  --chain ethereum \
  --threshold 100000 \
  --interval 300
```

**Output:** Console alerts when transfers exceed $100K threshold.

---

### Scenario 3: Airdrop Farming Tracker

You're farming airdrops across multiple wallets. Track activity and eligibility:

```bash
bash scripts/wallet-tracker.sh activity \
  --wallets-file my-wallets.txt \
  --chain ethereum \
  --since 2024-01-01
```

**Output:** Transaction count, unique contracts interacted, active days, and volume per wallet.

---

### Scenario 4: Team Treasury Monitoring

Monitor a DAO treasury wallet for unauthorized withdrawals:

```bash
bash scripts/wallet-tracker.sh monitor \
  --wallet "0xTreasury..." \
  --chain ethereum \
  --alert-on decrease \
  --output treasury-report.html
```

---

### Scenario 5: Cross-Chain Balance Snapshot

Take a point-in-time snapshot across all chains for accounting:

```bash
bash scripts/wallet-tracker.sh snapshot \
  --wallets-file all-wallets.txt \
  --output snapshot-2024-Q1.json
```

## Supported Chains

| Chain | Type | Native Token | RPC Default |
|-------|------|-------------|-------------|
| Ethereum | EVM | ETH | Public RPC |
| Polygon | EVM | MATIC | Public RPC |
| Arbitrum | EVM | ETH | Public RPC |
| Optimism | EVM | ETH | Public RPC |
| BSC | EVM | BNB | Public RPC |
| Avalanche | EVM | AVAX | Public RPC |
| Solana | SVM | SOL | Public RPC |

> 💡 **Tip:** Set custom RPCs via environment variable `WALLET_TRACKER_RPC_<CHAIN>=https://...` for better rate limits.

## Configuration File

Create `~/.wallet-tracker.json` for persistent config:

```json
{
  "wallets": [
    {"address": "0xABC...", "label": "Main ETH", "chains": ["ethereum", "polygon"]},
    {"address": "5KtPn...", "label": "Solana Hot", "chains": ["solana"]}
  ],
  "refresh_interval": 600,
  "alert_threshold_usd": 1000,
  "output_dir": "./wallet-reports"
}
```

## Commands

| Command | Description |
|---------|-------------|
| `add` | Add |
| `list` | List |
| `check` | Check |
| `remove` | Remove |
| `history` | History |
| `export` | Export |

## Privacy Note

This tool queries **public blockchain data only**. No private keys are ever required or requested. All data is processed locally.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
