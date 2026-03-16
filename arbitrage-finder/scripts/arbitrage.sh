#!/usr/bin/env bash
# Arbitrage Finder — Scan price differences across crypto exchanges
# Usage: bash arbitrage.sh <command> [options]
set -euo pipefail

COMMAND="${1:-help}"
shift 2>/dev/null || true

DATA_DIR="${HOME}/.arbitrage-finder"
mkdir -p "$DATA_DIR"

case "$COMMAND" in
  scan)
    ASSET="${1:-BTC}"
    
    python3 << 'PYEOF'
import sys, os, json, time
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

asset = sys.argv[1] if len(sys.argv) > 1 else "BTC"

# CoinGecko free API for multi-exchange prices
coin_map = {
    "BTC": "bitcoin", "ETH": "ethereum", "SOL": "solana",
    "BNB": "binancecoin", "XRP": "ripple", "ADA": "cardano",
    "DOGE": "dogecoin", "AVAX": "avalanche-2", "DOT": "polkadot",
    "MATIC": "matic-network", "LINK": "chainlink", "UNI": "uniswap",
    "ATOM": "cosmos", "LTC": "litecoin", "ARB": "arbitrum",
    "OP": "optimism", "NEAR": "near", "APT": "aptos",
    "SUI": "sui", "SEI": "sei-network"
}

coin_id = coin_map.get(asset.upper(), asset.lower())

try:
    url = "https://api.coingecko.com/api/v3/coins/{}/tickers?include_exchange_logo=false&depth=true".format(coin_id)
    req = Request(url)
    req.add_header("User-Agent", "ArbitrageFinder/1.0")
    resp = urlopen(req, timeout=15)
    data = json.loads(resp.read().decode("utf-8"))
    
    tickers = data.get("tickers", [])
    
    # Filter for USD/USDT/USDC pairs
    usd_tickers = []
    for t in tickers:
        target = t.get("target", "").upper()
        if target in ["USD", "USDT", "USDC", "BUSD", "DAI"]:
            exchange = t.get("market", {}).get("name", "?")
            price = t.get("last", 0)
            volume = t.get("converted_volume", {}).get("usd", 0)
            spread = t.get("bid_ask_spread_percentage", 0) or 0
            trust = t.get("trust_score", "?")
            
            if price > 0 and volume > 10000:
                usd_tickers.append({
                    "exchange": exchange,
                    "price": price,
                    "volume_24h": volume,
                    "spread": spread,
                    "target": target,
                    "trust": trust
                })
    
    # Sort by price
    usd_tickers.sort(key=lambda x: x["price"])
    
    if len(usd_tickers) < 2:
        print("Not enough exchange data for {}. Try a major coin.".format(asset))
        sys.exit(1)
    
    lowest = usd_tickers[0]
    highest = usd_tickers[-1]
    spread = highest["price"] - lowest["price"]
    spread_pct = (spread / lowest["price"]) * 100 if lowest["price"] > 0 else 0
    
    print("=" * 75)
    print("ARBITRAGE SCAN — {} ({})".format(asset.upper(), coin_id))
    print("Time: {}".format(time.strftime("%Y-%m-%d %H:%M")))
    print("=" * 75)
    print("")
    print("{:<25} {:>12} {:>12} {:>10} {:>8}".format(
        "Exchange", "Price", "24h Volume", "Spread%", "Trust"))
    print("-" * 75)
    
    for t in usd_tickers[:15]:
        vol_str = "${:.0f}K".format(t["volume_24h"] / 1000) if t["volume_24h"] >= 1000 else "${:.0f}".format(t["volume_24h"])
        if t["volume_24h"] >= 1000000:
            vol_str = "${:.1f}M".format(t["volume_24h"] / 1000000)
        
        marker = ""
        if t == lowest:
            marker = " ← BUY"
        elif t == highest:
            marker = " ← SELL"
        
        print("{:<25} ${:>11,.2f} {:>12} {:>9.2f}% {:>8}{}".format(
            t["exchange"][:24], t["price"], vol_str, t["spread"], t["trust"] or "?", marker))
    
    print("")
    print("-" * 75)
    print("ARBITRAGE OPPORTUNITY:")
    print("  Buy on:  {} @ ${:,.2f}".format(lowest["exchange"], lowest["price"]))
    print("  Sell on: {} @ ${:,.2f}".format(highest["exchange"], highest["price"]))
    print("  Spread:  ${:,.2f} ({:.3f}%)".format(spread, spread_pct))
    print("")
    
    # Profitability analysis
    trade_amounts = [1000, 5000, 10000, 50000]
    print("  PROFIT ESTIMATE (before fees):")
    print("  {:>12} {:>12} {:>12} {:>12}".format("Trade Size", "Gross", "~Fees (0.2%)", "Net"))
    print("  " + "-" * 50)
    for amount in trade_amounts:
        gross = amount * spread_pct / 100
        fees = amount * 0.004  # 0.2% each side
        net = gross - fees
        profitable = "✅" if net > 0 else "❌"
        print("  {:>11,} {:>11,.2f} {:>11,.2f} {:>11,.2f} {}".format(
            amount, gross, fees, net, profitable))
    
    print("")
    min_profitable = (0.004 * lowest["price"]) / spread * 100 if spread > 0 else float("inf")
    if spread_pct > 0.4:
        print("  ✅ Potentially profitable after typical fees (0.2% each side)")
    else:
        print("  ⚠️  Spread ({:.3f}%) may not cover fees. Monitor for wider spreads.".format(spread_pct))
    
    print("")
    print("  RISKS:")
    print("  - Price can change during transfer between exchanges")
    print("  - Withdrawal fees vary by exchange and chain")
    print("  - Transfer time: 1-60 min depending on chain")
    print("  - Volume/liquidity may not support large trades")
    print("  - KYC requirements may limit exchange access")
    
    # Save results
    result = {
        "asset": asset,
        "timestamp": time.strftime("%Y-%m-%d %H:%M:%S"),
        "lowest": {"exchange": lowest["exchange"], "price": lowest["price"]},
        "highest": {"exchange": highest["exchange"], "price": highest["price"]},
        "spread_pct": spread_pct,
        "exchanges_checked": len(usd_tickers)
    }
    result_file = os.path.join(os.path.expanduser("~/.arbitrage-finder"), "scan-{}.json".format(asset.lower()))
    with open(result_file, "w") as f:
        json.dump(result, f, indent=2)

except Exception as e:
    print("Error: {}".format(str(e)))
    print("CoinGecko may be rate-limited. Wait a minute and try again.")
PYEOF
    ;;

  multi)
    python3 << 'PYEOF'
import sys, os, json, time
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

assets = ["bitcoin", "ethereum", "solana", "binancecoin", "ripple", "cardano", 
          "dogecoin", "avalanche-2", "polkadot", "chainlink"]
symbols = ["BTC", "ETH", "SOL", "BNB", "XRP", "ADA", "DOGE", "AVAX", "DOT", "LINK"]

print("=" * 65)
print("MULTI-ASSET ARBITRAGE SCAN")
print("Time: {}".format(time.strftime("%Y-%m-%d %H:%M")))
print("=" * 65)
print("")
print("{:<8} {:>12} {:>12} {:>10} {:>20}".format(
    "Asset", "Low Price", "High Price", "Spread%", "Exchanges"))
print("-" * 65)

opportunities = []

for coin_id, symbol in zip(assets, symbols):
    try:
        url = "https://api.coingecko.com/api/v3/coins/{}/tickers?include_exchange_logo=false".format(coin_id)
        req = Request(url)
        req.add_header("User-Agent", "ArbitrageFinder/1.0")
        resp = urlopen(req, timeout=10)
        data = json.loads(resp.read().decode("utf-8"))
        
        tickers = data.get("tickers", [])
        usd_prices = []
        for t in tickers:
            target = t.get("target", "").upper()
            if target in ["USD", "USDT", "USDC"]:
                price = t.get("last", 0)
                vol = t.get("converted_volume", {}).get("usd", 0)
                exchange = t.get("market", {}).get("name", "?")
                if price > 0 and vol > 50000:
                    usd_prices.append({"price": price, "exchange": exchange})
        
        if len(usd_prices) >= 2:
            usd_prices.sort(key=lambda x: x["price"])
            low = usd_prices[0]
            high = usd_prices[-1]
            spread_pct = ((high["price"] - low["price"]) / low["price"]) * 100
            
            profitable = "✅" if spread_pct > 0.4 else "  "
            print("{}{:<7} ${:>11,.2f} ${:>11,.2f} {:>9.3f}% {}/{}".format(
                profitable, symbol, low["price"], high["price"], spread_pct,
                low["exchange"][:8], high["exchange"][:8]))
            
            if spread_pct > 0.3:
                opportunities.append({
                    "symbol": symbol,
                    "spread_pct": spread_pct,
                    "buy": low["exchange"],
                    "sell": high["exchange"],
                    "buy_price": low["price"],
                    "sell_price": high["price"]
                })
        
        time.sleep(1.5)  # Rate limiting
    except Exception:
        print("{:<8} Error fetching data".format(symbol))

print("")
if opportunities:
    opportunities.sort(key=lambda x: x["spread_pct"], reverse=True)
    print("TOP OPPORTUNITIES:")
    for i, opp in enumerate(opportunities[:5], 1):
        print("  {}. {} — {:.3f}% spread (Buy@{}, Sell@{})".format(
            i, opp["symbol"], opp["spread_pct"], opp["buy"], opp["sell"]))
else:
    print("No significant arbitrage opportunities found at this time.")
    print("Markets are efficiently priced. Check again during high volatility.")
PYEOF
    ;;

  history)
    ASSET="${1:-BTC}"
    
    python3 << 'PYEOF'
import json, os, glob, sys

asset = sys.argv[1] if len(sys.argv) > 1 else "BTC"
data_dir = os.path.expanduser("~/.arbitrage-finder")
scan_file = os.path.join(data_dir, "scan-{}.json".format(asset.lower()))

if os.path.exists(scan_file):
    with open(scan_file, "r") as f:
        data = json.load(f)
    print("Last scan for {}:".format(asset.upper()))
    print("  Time: {}".format(data.get("timestamp", "?")))
    print("  Lowest: {} @ ${:,.2f}".format(data["lowest"]["exchange"], data["lowest"]["price"]))
    print("  Highest: {} @ ${:,.2f}".format(data["highest"]["exchange"], data["highest"]["price"]))
    print("  Spread: {:.3f}%".format(data.get("spread_pct", 0)))
    print("  Exchanges checked: {}".format(data.get("exchanges_checked", 0)))
else:
    print("No scan history for {}. Run 'bash arbitrage.sh scan {}' first.".format(asset, asset))
PYEOF
    ;;

  help|*)
    cat << 'HELPEOF'
Arbitrage Finder — Scan price differences across crypto exchanges

COMMANDS:
  scan <asset>     Scan single asset across exchanges
  multi            Scan top 10 assets for opportunities  
  history [asset]  View last scan results

ASSETS: BTC, ETH, SOL, BNB, XRP, ADA, DOGE, AVAX, DOT, LINK, etc.

EXAMPLES:
  bash arbitrage.sh scan BTC
  bash arbitrage.sh scan ETH
  bash arbitrage.sh multi
  bash arbitrage.sh history BTC

NOTE: Uses CoinGecko free API (rate limited to ~10 req/min)
HELPEOF
    ;;
esac

echo ""
echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
