#!/usr/bin/env bash
# Polymarket Screener — Screen and monitor prediction markets
# Usage: bash polymarket.sh <command> [options]
set -euo pipefail

COMMAND="${1:-help}"
shift 2>/dev/null || true

DATA_DIR="${HOME}/.polymarket-screener"
mkdir -p "$DATA_DIR"

case "$COMMAND" in
  markets)
    CATEGORY="${1:-all}"
    SORT="${2:-volume}"
    LIMIT="${3:-20}"
    
    python3 << 'PYEOF'
import sys, os, json, time
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

category = sys.argv[1] if len(sys.argv) > 1 else "all"
sort_by = sys.argv[2] if len(sys.argv) > 2 else "volume"
limit = int(sys.argv[3]) if len(sys.argv) > 3 else 20

# Polymarket CLOB API (public, no auth needed for reads)
try:
    url = "https://gamma-api.polymarket.com/markets?closed=false&limit={}&order={}".format(limit * 2, sort_by)
    req = Request(url)
    req.add_header("User-Agent", "PolymarketScreener/1.0")
    resp = urlopen(req, timeout=15)
    markets = json.loads(resp.read().decode("utf-8"))
    
    if not isinstance(markets, list):
        markets = markets.get("data", markets.get("markets", []))
    
    # Filter by category
    if category != "all":
        markets = [m for m in markets if category.lower() in (m.get("category", "") or "").lower() or
                   category.lower() in (m.get("question", "") or "").lower()]
    
    markets = markets[:limit]
    
    print("=" * 80)
    print("POLYMARKET — Active Markets (sorted by {})".format(sort_by))
    print("Time: {}".format(time.strftime("%Y-%m-%d %H:%M")))
    print("=" * 80)
    print("")
    
    for i, m in enumerate(markets, 1):
        question = m.get("question", m.get("title", "?"))[:70]
        volume = m.get("volume", m.get("volumeNum", 0)) or 0
        liquidity = m.get("liquidity", m.get("liquidityNum", 0)) or 0
        end_date = (m.get("endDate", m.get("end_date_iso", "")) or "")[:10]
        
        # Get outcome prices
        outcomes = m.get("outcomes", m.get("tokens", []))
        yes_price = None
        no_price = None
        
        if isinstance(outcomes, list) and len(outcomes) >= 2:
            for o in outcomes:
                if isinstance(o, dict):
                    name = (o.get("outcome", o.get("name", "")) or "").lower()
                    price = o.get("price", o.get("lastTradePrice", 0))
                    if price and isinstance(price, (int, float)):
                        if "yes" in name:
                            yes_price = float(price)
                        elif "no" in name:
                            no_price = float(price)
        
        # Also try outcomePrices field
        if yes_price is None:
            try:
                prices_str = m.get("outcomePrices", "")
                if prices_str:
                    prices = json.loads(prices_str) if isinstance(prices_str, str) else prices_str
                    if len(prices) >= 2:
                        yes_price = float(prices[0])
                        no_price = float(prices[1])
            except (json.JSONDecodeError, ValueError, IndexError, TypeError):
                pass
        
        vol_str = "${:,.0f}".format(volume) if volume < 1000000 else "${:.1f}M".format(volume / 1000000)
        liq_str = "${:,.0f}".format(liquidity) if liquidity < 1000000 else "${:.1f}M".format(liquidity / 1000000)
        
        print("{}. {}".format(i, question))
        
        price_line = "   "
        if yes_price is not None:
            price_line += "YES: {:.0f}¢".format(yes_price * 100 if yes_price < 1 else yes_price)
        if no_price is not None:
            price_line += "  NO: {:.0f}¢".format(no_price * 100 if no_price < 1 else no_price)
        price_line += "  Vol: {}  Liq: {}".format(vol_str, liq_str)
        if end_date:
            price_line += "  Ends: {}".format(end_date)
        print(price_line)
        print("")
    
    # Cache
    cache = {"timestamp": time.strftime("%Y-%m-%d %H:%M:%S"), "markets": markets}
    cache_file = os.path.join(os.path.expanduser("~/.polymarket-screener"), "markets.json")
    with open(cache_file, "w") as f:
        json.dump(cache, f, indent=2, default=str)
    
except Exception as e:
    print("Error fetching markets: {}".format(str(e)))
    print("")
    print("Polymarket API may be temporarily unavailable.")
    print("Alternatively, visit: https://polymarket.com")
PYEOF
    ;;

  odds)
    QUERY="${1:-}"
    
    python3 << 'PYEOF'
import sys, os, json, time
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

query = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else ""

if not query:
    print("Usage: bash polymarket.sh odds <search_query>")
    print("Example: bash polymarket.sh odds trump election")
    sys.exit(1)

try:
    from urllib.parse import quote
except ImportError:
    from urllib import quote

try:
    url = "https://gamma-api.polymarket.com/markets?closed=false&limit=10"
    req = Request(url)
    req.add_header("User-Agent", "PolymarketScreener/1.0")
    resp = urlopen(req, timeout=15)
    markets = json.loads(resp.read().decode("utf-8"))
    
    if not isinstance(markets, list):
        markets = markets.get("data", markets.get("markets", []))
    
    # Search filter
    matches = []
    for m in markets:
        question = (m.get("question", m.get("title", "")) or "").lower()
        desc = (m.get("description", "") or "").lower()
        if query.lower() in question or query.lower() in desc:
            matches.append(m)
    
    if not matches:
        print("No markets found matching '{}'. Try broader terms.".format(query))
        sys.exit(0)
    
    print("=" * 70)
    print("SEARCH: '{}' — {} results".format(query, len(matches)))
    print("=" * 70)
    print("")
    
    for m in matches[:5]:
        question = m.get("question", m.get("title", "?"))
        print("Q: {}".format(question))
        
        # Parse outcomes
        try:
            prices_str = m.get("outcomePrices", "")
            if prices_str:
                prices = json.loads(prices_str) if isinstance(prices_str, str) else prices_str
                outcomes_str = m.get("outcomes", "")
                outcomes = json.loads(outcomes_str) if isinstance(outcomes_str, str) else outcomes_str
                
                if isinstance(outcomes, list) and isinstance(prices, list):
                    for name, price in zip(outcomes, prices):
                        pct = float(price) * 100 if float(price) < 2 else float(price)
                        bar_len = int(pct / 2)
                        bar = "█" * bar_len + "░" * (50 - bar_len)
                        print("   {:<10} {:.1f}% {}".format(name, pct, bar))
        except (json.JSONDecodeError, ValueError, TypeError):
            pass
        
        volume = m.get("volume", m.get("volumeNum", 0)) or 0
        if isinstance(volume, (int, float)) and volume > 0:
            vol_str = "${:,.0f}".format(volume) if volume < 1e6 else "${:.1f}M".format(volume / 1e6)
            print("   Volume: {}".format(vol_str))
        
        slug = m.get("slug", m.get("id", ""))
        if slug:
            print("   URL: https://polymarket.com/event/{}".format(slug))
        print("")

except Exception as e:
    print("Error: {}".format(str(e)))
PYEOF
    ;;

  value-bets)
    THRESHOLD="${1:-0.15}"
    
    python3 << 'PYEOF'
import sys, os, json, time
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

threshold = float(sys.argv[1]) if len(sys.argv) > 1 else 0.15

print("=" * 70)
print("VALUE BET FINDER (extreme odds)")
print("Looking for YES < {:.0f}¢ or YES > {:.0f}¢".format(threshold * 100, (1 - threshold) * 100))
print("=" * 70)
print("")

try:
    url = "https://gamma-api.polymarket.com/markets?closed=false&limit=100"
    req = Request(url)
    req.add_header("User-Agent", "PolymarketScreener/1.0")
    resp = urlopen(req, timeout=15)
    markets = json.loads(resp.read().decode("utf-8"))
    
    if not isinstance(markets, list):
        markets = markets.get("data", markets.get("markets", []))
    
    low_odds = []
    high_odds = []
    
    for m in markets:
        try:
            prices_str = m.get("outcomePrices", "")
            if not prices_str:
                continue
            prices = json.loads(prices_str) if isinstance(prices_str, str) else prices_str
            if not prices or len(prices) < 1:
                continue
            
            yes_price = float(prices[0])
            volume = m.get("volume", m.get("volumeNum", 0)) or 0
            
            if isinstance(volume, (int, float)) and volume < 10000:
                continue
            
            question = m.get("question", m.get("title", "?"))
            
            if yes_price < threshold:
                low_odds.append({"question": question, "yes": yes_price, "volume": volume})
            elif yes_price > (1 - threshold):
                high_odds.append({"question": question, "yes": yes_price, "volume": volume})
        except (ValueError, TypeError, json.JSONDecodeError):
            continue
    
    print("LONGSHOTS (YES < {:.0f}¢ — potential high payoff):".format(threshold * 100))
    print("-" * 70)
    low_odds.sort(key=lambda x: x["yes"])
    for i, m in enumerate(low_odds[:10], 1):
        payout = (1 / m["yes"]) if m["yes"] > 0 else 0
        print("  {}. YES: {:.0f}¢ ({}x payout)".format(i, m["yes"] * 100, int(payout)))
        print("     {}".format(m["question"][:65]))
        print("")
    
    if not low_odds:
        print("  No longshot opportunities found.")
    
    print("")
    print("NEAR-CERTAIN (YES > {:.0f}¢ — low risk):".format((1 - threshold) * 100))
    print("-" * 70)
    high_odds.sort(key=lambda x: x["yes"], reverse=True)
    for i, m in enumerate(high_odds[:10], 1):
        print("  {}. YES: {:.0f}¢ ({:.1f}% return if correct)".format(
            i, m["yes"] * 100, (1 - m["yes"]) * 100))
        print("     {}".format(m["question"][:65]))
        print("")
    
    if not high_odds:
        print("  No near-certain bets found.")
    
    print("")
    print("⚠️  DISCLAIMER: Prediction markets involve real money risk.")
    print("   Past performance does not guarantee future results.")
    print("   Only bet what you can afford to lose.")

except Exception as e:
    print("Error: {}".format(str(e)))
PYEOF
    ;;

  watchlist)
    ACTION="${1:-list}"
    MARKET="${2:-}"
    
    python3 << 'PYEOF'
import json, sys, os

data_dir = os.path.expanduser("~/.polymarket-screener")
action = sys.argv[1] if len(sys.argv) > 1 else "list"
market = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

wl_file = os.path.join(data_dir, "watchlist.json")
watchlist = []
if os.path.exists(wl_file):
    with open(wl_file, "r") as f:
        watchlist = json.load(f)

if action == "add":
    if not market:
        print("Usage: bash polymarket.sh watchlist add <market_question>")
        sys.exit(1)
    watchlist.append({"question": market, "added": __import__("time").strftime("%Y-%m-%d")})
    with open(wl_file, "w") as f:
        json.dump(watchlist, f, indent=2)
    print("Added to watchlist: {}".format(market))

elif action == "remove":
    if not market:
        print("Usage: bash polymarket.sh watchlist remove <index>")
        sys.exit(1)
    try:
        idx = int(market) - 1
        if 0 <= idx < len(watchlist):
            removed = watchlist.pop(idx)
            with open(wl_file, "w") as f:
                json.dump(watchlist, f, indent=2)
            print("Removed: {}".format(removed["question"][:60]))
        else:
            print("Invalid index.")
    except ValueError:
        print("Use index number, not text.")

else:
    print("=" * 60)
    print("POLYMARKET WATCHLIST ({} items)".format(len(watchlist)))
    print("=" * 60)
    if watchlist:
        for i, item in enumerate(watchlist, 1):
            print("  {}. {} (added: {})".format(i, item["question"][:55], item.get("added", "?")))
    else:
        print("  Empty. Add markets with: bash polymarket.sh watchlist add <question>")
PYEOF
    ;;

  help|*)
    cat << 'HELPEOF'
Polymarket Screener — Screen and monitor prediction markets

COMMANDS:
  markets [category] [sort] [limit]
         List active markets (sort: volume|liquidity)

  odds <search_query>
         Search markets and show current odds

  value-bets [threshold]
         Find extreme odds (longshots and near-certain)

  watchlist [add|remove|list] [market]
         Manage your market watchlist

CATEGORIES: all, politics, crypto, sports, science, culture

EXAMPLES:
  bash polymarket.sh markets
  bash polymarket.sh markets politics volume 10
  bash polymarket.sh odds "president 2028"
  bash polymarket.sh value-bets 0.10
  bash polymarket.sh watchlist add "Will BTC reach 100k in 2025?"
  bash polymarket.sh watchlist

NOTE: Uses Polymarket public API (no authentication required)
HELPEOF
    ;;
esac

echo ""
echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
