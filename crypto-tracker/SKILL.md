---
version: "2.0.0"
name: crypto-tracker
description: "Track cryptocurrency markets in real-time. 加密货币行情追踪、比特币价格、以太坊ETH、市值排行、DeFi数据、恐惧贪婪指数、趋势币种、空投信息、RSI技术分析、均线分析、金叉死叉、DeFi收益率对比、Gas费查询。Use when checking crypto prices, market sentiment, DeFi TVL, trending coins, meme coins, RSI indicators, moving averages, DeFi yield comparison, or Ethereum gas fees. Free APIs (CoinGecko, DefiLlama) — no API keys needed. 实时行情、涨跌幅、市场情绪分析、技术指标。 Triggers on: crypto tracker."
---

# Crypto Tracker

Real-time cryptocurrency market data via free APIs. No API keys needed.

## Quick Commands

### Price Check
```bash
scripts/crypto.sh price bitcoin ethereum solana
```

### Market Overview
```bash
scripts/crypto.sh market
```

### Trending Coins
```bash
scripts/crypto.sh trending
```

### Fear & Greed Index
```bash
scripts/crypto.sh fear
```

### DeFi TVL Rankings
```bash
scripts/crypto.sh defi
```

### Top Meme Coins
```bash
scripts/crypto.sh memes
```

### Coin Details
```bash
scripts/crypto.sh info bitcoin
```

### 📈 RSI Indicator (14-day)
```bash
scripts/crypto.sh rsi bitcoin
scripts/crypto.sh rsi ethereum
```
Calculates 14-day RSI from CoinGecko historical prices. Shows overbought (>70) / oversold (<30) / neutral signals with trading suggestions.

### 📊 Moving Average Analysis
```bash
scripts/crypto.sh ma bitcoin
scripts/crypto.sh ma solana
```
Calculates 7/14/30-day moving averages. Detects golden cross (金叉) / death cross (死叉) patterns and overall trend direction.

### 🌾 DeFi Yield Comparison
```bash
scripts/crypto.sh defi-yield
```
Fetches top 20 high-yield DeFi pools (TVL > $1M) from DefiLlama. Shows protocol, pool, APY, TVL, and chain. Sorted by APY.

### ⛽ Ethereum Gas Tracker
```bash
scripts/crypto.sh gas
```
Shows current Ethereum gas prices (low/medium/fast) with transaction cost estimates and gas-saving tips. Falls back to reference guide if API is unavailable.

## API Reference

All endpoints are free, no auth required. Rate limit: ~10-30 req/min.

### CoinGecko (prices, trending, market data)
- Base: `[configured-endpoint]
- Price: `/simple/price?ids={ids}&vs_currencies=usd&include_24hr_change=true`
- Trending: `/search/trending`
- Global: `/global`
- Markets: `/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20`
- Coin detail: `/coins/{id}`
- Categories: `/coins/categories`
- Memes: `/coins/markets?vs_currency=usd&category=meme-token&order=volume_desc&per_page=20`

### DefiLlama (DeFi data)
- Base: `[configured-endpoint]
- TVL: `/protocols`
- Chain TVL: `/v2/chains`
- Yields: `[configured-endpoint] (high-yield pool data)

### Fear & Greed Index
- `[configured-endpoint]

### Etherscan (Gas prices)
- Gas Oracle: `[configured-endpoint]

## Output Formats

Default: human-readable table. Add `--json` for raw JSON output.

## Notes

- CoinGecko free tier: ~30 calls/min. Add 2s delay between batch requests.
- Coin IDs use CoinGecko slugs (e.g., `bitcoin`, `ethereum`, `solana`).
- For historical data: `/coins/{id}/market_chart?vs_currency=usd&days={days}`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com

## Commands

| Command | Description |
|---------|-------------|
| `crypto-tracker help` | Show usage info |
| `crypto-tracker run` | Run main task |
