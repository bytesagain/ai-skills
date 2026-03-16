---
version: "2.0.0"
name: Onchain Analyzer
description: "Analyze wallet addresses and on-chain activity — transaction history, token holdings, DeFi positions, and trading patterns across EVM chains and Solana. Use when you need onchain analyzer capabilities. Triggers on: onchain analyzer."
author: BytesAgain
---

# Onchain Analyzer

Deep-dive into any wallet's on-chain activity.

## Quick Reference

| Command | Description |
|---------|-------------|
| `profile <addr>` | Wallet overview and stats |
| `tokens <addr>` | Token holdings breakdown |
| `txns <addr> [limit]` | Recent transactions |
| `defi <addr>` | DeFi positions and yields |
| `patterns <addr>` | Trading pattern analysis |
| `compare <addr1> <addr2>` | Compare two wallets |

## Supported Chains

Ethereum, BSC, Polygon, Arbitrum, Base, Optimism, Avalanche, Solana

## Use Cases

- **Research**: Analyze whale wallets and smart money
- **Security**: Verify counterparty wallet history
- **Tracking**: Monitor wallets for copy-trading
- **Compliance**: Transaction history for tax/audit
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Examples

```bash
# Show help
onchain-analyzer help

# Run
onchain-analyzer run
```

## Commands

Run `onchain-analyzer help` to see all available commands.
