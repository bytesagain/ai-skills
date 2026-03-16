---
version: "2.0.0"
name: Token Launcher
description: "Token launch toolkit for Pump.fun/Solana — generate token configs, liquidity guides, and security checklists. Use when you need token launcher capabilities. Triggers on: token launcher."
---

# Token Launcher 🚀

Launch meme tokens and SPL tokens on Solana with confidence. This skill generates token configurations, walks you through the Pump.fun launch flow, checks contract security, and provides liquidity addition guidance.

## Frequently Asked Questions

### Q: What does this tool actually do?

It generates a complete token launch package:
- **Token configuration JSON** with name, symbol, decimals, supply, tax settings
- **Security checklist** to audit before deploying
- **Liquidity plan** with pool sizing recommendations
- **Launch timeline** with pre-launch, launch, and post-launch steps

### Q: Which platforms are supported?

| Platform | Chain | Token Standard | Status |
|----------|-------|---------------|--------|
| Pump.fun | Solana | SPL Token | ✅ Full |
| Raydium | Solana | SPL Token | ✅ Full |
| Jupiter | Solana | SPL Token | ✅ Listing guide |
| Custom SPL | Solana | SPL Token 2022 | ✅ Config gen |

### Q: How do I launch a token?

Run the script with the `launch` command:

```bash
bash scripts/token-launcher.sh launch \
  --name "MyCoin" \
  --symbol "MYC" \
  --supply 1000000000 \
  --decimals 9
```

### Q: Can I simulate before deploying?

Yes. Use `--dry-run` mode to generate all configs without any on-chain interaction:

```bash
bash scripts/token-launcher.sh launch --name "TestToken" --symbol "TST" --supply 1000000 --dry-run
```

### Q: What security checks are performed?

The `audit` command runs through:
1. Mint authority status (should be revoked post-launch)
2. Freeze authority status (should be revoked)
3. Supply concentration (top holder %)
4. Tax rate reasonableness (flags >5%)
5. Liquidity lock status
6. Metadata mutability

### Q: How do I add liquidity?

```bash
bash scripts/token-launcher.sh liquidity \
  --token-address <ADDRESS> \
  --sol-amount 10 \
  --token-percent 80
```

This generates the liquidity addition config and step-by-step instructions for Raydium.

### Q: What about tokenomics planning?

Use the `tokenomics` command to model distribution:

```bash
bash scripts/token-launcher.sh tokenomics \
  --supply 1000000000 \
  --team-percent 5 \
  --lp-percent 80 \
  --marketing-percent 10 \
  --airdrop-percent 5
```

## Commands Reference

| Command | Description |
|---------|-------------|
| `launch` | Generate full token launch config |
| `audit` | Run security checklist on token config |
| `liquidity` | Generate liquidity addition plan |
| `tokenomics` | Model token distribution |
| `timeline` | Generate launch timeline |
| `pumpfun` | Pump.fun specific launch guide |

## File Output

All generated files are saved to `./token-launch-output/`:
- `token-config.json` — Token parameters
- `security-checklist.md` — Audit results
- `liquidity-plan.md` — LP strategy
- `tokenomics.html` — Visual distribution chart
- `launch-timeline.md` — Step-by-step schedule

## Risk Warnings

⚠️ **This tool generates configurations only.** It does NOT deploy tokens or interact with any blockchain. Always review generated configs with a qualified developer before deploying.

⚠️ Token launches carry significant financial and legal risk. Consult legal counsel in your jurisdiction.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
