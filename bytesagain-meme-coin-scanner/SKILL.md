---
version: "2.0.0"
name: bytesagain-meme-coin-scanner
description: "Scan meme coins for scam signals, rug-pull risk, and on-chain audit flags. Use when evaluating tokens, auditing contracts, checking liquidity lock status."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Meme Coin Scanner

Detect scams and find gems in the meme coin market.

## Commands

```bash
bash scripts/meme.sh scan <token_address> [chain]   # Deep scan a token
bash scripts/meme.sh new [chain]                     # New token listings
bash scripts/meme.sh trending                        # Trending meme coins
bash scripts/meme.sh checklist                       # Safety checklist
```

## Risk Indicators

- 🔴 **Honeypot**: Can't sell after buying
- 🔴 **Rug Pull**: Dev can drain liquidity
- 🟡 **High Tax**: >10% buy/sell tax
- 🟡 **Concentrated**: Top holder >20% supply
- 🟢 **Locked LP**: Liquidity locked >6 months
- 🟢 **Renounced**: Ownership given up

## Safety First

1. Never invest more than you can afford to lose
2. Always check contract before buying
3. Start with tiny amounts to test selling
4. Verify on multiple scanners (TokenSniffer, GoPlus)
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Requirements
- bash 4+
- python3 (standard library only)
