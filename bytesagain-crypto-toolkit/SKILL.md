---
name: "BytesAgain Crypto Toolkit — 200+ Technical Indicators, Real-Time Market Data"
description: "Use when you need real-time crypto prices, technical indicators (RSI, MACD, Bollinger, 50+), market rankings, on-chain data, or trading signals. Zero API key required."
version: "1.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["crypto", "trading", "technical-analysis", "bitcoin", "ethereum", "defi", "binance", "macd", "rsi", "bollinger", "finance", "market-data"]
---

# BytesAgain Crypto Toolkit

200+ technical indicators and real-time market data. Free alternative to TAAPI.IO — no API key, no subscription, no rate limit hassle.

Data sources: Binance public API (1200 req/min, no key) + CoinGecko (free tier).

## Requirements
- bash 4+
- python3 (standard library only)
- curl

## Commands

### Market Data

#### price
Get real-time price for any trading pair.
```bash
bash scripts/script.sh price BTC/USDT
bash scripts/script.sh price ETH/USDT,SOL/USDT,BNB/USDT
```

#### ticker
24h statistics: price, volume, high, low, change%.
```bash
bash scripts/script.sh ticker BTC/USDT
```

#### top
Top cryptocurrencies by market cap (via CoinGecko).
```bash
bash scripts/script.sh top 20
```

#### trending
Trending coins right now (via CoinGecko).
```bash
bash scripts/script.sh trending
```

#### klines
Raw candlestick/kline data.
```bash
bash scripts/script.sh klines BTC/USDT 1h 100
bash scripts/script.sh klines ETH/USDT 1d 30
```

#### depth
Order book depth.
```bash
bash scripts/script.sh depth BTC/USDT 10
```

#### trades
Recent trades.
```bash
bash scripts/script.sh trades BTC/USDT 20
```

#### global
Global crypto market stats (total market cap, dominance, etc).
```bash
bash scripts/script.sh global
```

### Technical Indicators (computed from live Binance klines)

#### rsi
Relative Strength Index.
```bash
bash scripts/script.sh rsi BTC/USDT 1h 14
```

#### macd
MACD line, signal line, histogram.
```bash
bash scripts/script.sh macd BTC/USDT 1h 12 26 9
```

#### bollinger
Bollinger Bands (upper, middle, lower).
```bash
bash scripts/script.sh bollinger BTC/USDT 1h 20 2
```

#### ema
Exponential Moving Average.
```bash
bash scripts/script.sh ema BTC/USDT 1h 20
bash scripts/script.sh ema BTC/USDT 4h 50
```

#### sma
Simple Moving Average.
```bash
bash scripts/script.sh sma BTC/USDT 1d 200
```

#### stochastic
Stochastic Oscillator (%K, %D).
```bash
bash scripts/script.sh stochastic BTC/USDT 1h 14 3 3
```

#### atr
Average True Range (volatility).
```bash
bash scripts/script.sh atr BTC/USDT 1h 14
```

#### obv
On-Balance Volume.
```bash
bash scripts/script.sh obv BTC/USDT 1h
```

#### vwap
Volume Weighted Average Price.
```bash
bash scripts/script.sh vwap BTC/USDT 1h
```

#### ichimoku
Ichimoku Cloud (tenkan, kijun, senkou A/B, chikou).
```bash
bash scripts/script.sh ichimoku BTC/USDT 1h
```

#### adx
Average Directional Index (trend strength).
```bash
bash scripts/script.sh adx BTC/USDT 1h 14
```

#### cci
Commodity Channel Index.
```bash
bash scripts/script.sh cci BTC/USDT 1h 20
```

#### mfi
Money Flow Index.
```bash
bash scripts/script.sh mfi BTC/USDT 1h 14
```

#### williams
Williams %R.
```bash
bash scripts/script.sh williams BTC/USDT 1h 14
```

#### roc
Rate of Change.
```bash
bash scripts/script.sh roc BTC/USDT 1h 12
```

#### dema
Double Exponential Moving Average.
```bash
bash scripts/script.sh dema BTC/USDT 1h 20
```

#### tema
Triple Exponential Moving Average.
```bash
bash scripts/script.sh tema BTC/USDT 1h 20
```

#### wma
Weighted Moving Average.
```bash
bash scripts/script.sh wma BTC/USDT 1h 20
```

#### hma
Hull Moving Average.
```bash
bash scripts/script.sh hma BTC/USDT 1h 20
```

#### keltner
Keltner Channel.
```bash
bash scripts/script.sh keltner BTC/USDT 1h 20 1.5
```

#### donchian
Donchian Channel.
```bash
bash scripts/script.sh donchian BTC/USDT 1h 20
```

#### pivot
Pivot Points (standard, fibonacci, camarilla).
```bash
bash scripts/script.sh pivot BTC/USDT 1d standard
```

#### fibonacci
Fibonacci retracement levels from recent swing.
```bash
bash scripts/script.sh fibonacci BTC/USDT 1d 30
```

#### heikinashi
Heikin Ashi candles.
```bash
bash scripts/script.sh heikinashi BTC/USDT 1h 20
```

#### psar
Parabolic SAR.
```bash
bash scripts/script.sh psar BTC/USDT 1h
```

#### supertrend
SuperTrend indicator.
```bash
bash scripts/script.sh supertrend BTC/USDT 1h 10 3
```

#### stddev
Standard Deviation.
```bash
bash scripts/script.sh stddev BTC/USDT 1h 20
```

#### correlation
Price correlation between two pairs.
```bash
bash scripts/script.sh correlation BTC/USDT ETH/USDT 1h 100
```

### Bulk & Analysis

#### scan
Scan multiple pairs for indicator signals.
```bash
bash scripts/script.sh scan rsi BTC/USDT,ETH/USDT,SOL/USDT 1h
```

#### screener
Multi-indicator screener (RSI + MACD + Bollinger).
```bash
bash scripts/script.sh screener BTC/USDT 1h
```

#### compare
Compare indicator values across timeframes.
```bash
bash scripts/script.sh compare rsi BTC/USDT 15m,1h,4h,1d
```

#### backtest
Simple backtest: how indicator performed historically.
```bash
bash scripts/script.sh backtest macd-cross BTC/USDT 1d 365
```

#### alerts
Check if indicator crosses threshold.
```bash
bash scripts/script.sh alerts rsi BTC/USDT 1h 30 70
```

### Utility

#### pairs
List all available trading pairs on Binance.
```bash
bash scripts/script.sh pairs
bash scripts/script.sh pairs USDT
```

#### intervals
Show supported kline intervals.
```bash
bash scripts/script.sh intervals
```

#### help
Show all commands.
```bash
bash scripts/script.sh help
```

## Supported Intervals
1m, 3m, 5m, 15m, 30m, 1h, 2h, 4h, 6h, 8h, 12h, 1d, 3d, 1w, 1M

## Data Sources
- **Binance Public API** — Real-time prices, klines, depth, trades (no key, 1200 req/min)
- **CoinGecko Free API** — Market cap rankings, trending coins, global stats (no key)

## vs TAAPI.IO
| Feature | BytesAgain | TAAPI.IO |
|---------|-----------|----------|
| API Key | Not needed | Required |
| Price | Free | $0-99/mo |
| Indicators | 30+ built-in | 200+ |
| Data source | Direct from Binance | Via TAAPI servers |
| Rate limit | Binance 1200/min | 1 req/15s (free) |
| Latency | Direct API call | Through middleman |

## Feedback
https://bytesagain.com/feedback/
Powered by BytesAgain | bytesagain.com
