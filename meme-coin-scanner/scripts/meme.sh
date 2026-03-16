#!/usr/bin/env bash
# Meme Coin Scanner — Detect scams and analyze new tokens
set -euo pipefail
COMMAND="${1:-help}"; shift 2>/dev/null || true
DATA_DIR="${HOME}/.meme-scanner"; mkdir -p "$DATA_DIR"

case "$COMMAND" in
  scan)
    TOKEN="${1:-}"; CHAIN="${2:-ethereum}"
    python3 << 'PYEOF'
import sys, os, json, time
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

token = sys.argv[1] if len(sys.argv) > 1 else ""
chain = sys.argv[2] if len(sys.argv) > 2 else "ethereum"

if not token:
    print("Usage: bash meme.sh scan <token_address> [chain]")
    print("Chains: ethereum, bsc, polygon, arbitrum, base, solana")
    sys.exit(1)

chain_ids = {"ethereum": "ethereum", "bsc": "bsc", "polygon": "polygon", "arbitrum": "arbitrum", "base": "base", "solana": "solana"}
chain_id = chain_ids.get(chain, chain)

print("=" * 65)
print("MEME COIN SECURITY SCAN")
print("=" * 65)
print("")
print("Token: {}".format(token))
print("Chain: {}".format(chain))
print("Time: {}".format(time.strftime("%Y-%m-%d %H:%M")))
print("")

# Try DexScreener for basic info
try:
    url = "https://api.dexscreener.com/latest/dex/tokens/{}".format(token)
    req = Request(url)
    req.add_header("User-Agent", "MemeCoinScanner/1.0")
    resp = urlopen(req, timeout=15)
    data = json.loads(resp.read().decode("utf-8"))
    pairs = data.get("pairs", [])
    
    if pairs:
        pair = pairs[0]
        base = pair.get("baseToken", {})
        quote = pair.get("quoteToken", {})
        
        print("TOKEN INFO:")
        print("  Name: {}".format(base.get("name", "?")))
        print("  Symbol: {}".format(base.get("symbol", "?")))
        print("  Address: {}".format(base.get("address", "?")))
        print("")
        
        price = pair.get("priceUsd", "?")
        print("PRICE DATA:")
        print("  Current: ${}".format(price))
        
        price_change = pair.get("priceChange", {})
        for period in ["m5", "h1", "h6", "h24"]:
            pct = price_change.get(period, 0)
            if pct:
                direction = "+" if float(pct) > 0 else ""
                print("  {}: {}{}%".format(period, direction, pct))
        
        print("")
        print("LIQUIDITY:")
        liq = pair.get("liquidity", {})
        liq_usd = liq.get("usd", 0)
        print("  Total: ${:,.0f}".format(liq_usd) if liq_usd else "  Total: Unknown")
        
        vol = pair.get("volume", {})
        vol_24h = vol.get("h24", 0)
        print("  24h Volume: ${:,.0f}".format(vol_24h) if vol_24h else "  24h Volume: Unknown")
        
        txns = pair.get("txns", {})
        h24 = txns.get("h24", {})
        buys = h24.get("buys", 0)
        sells = h24.get("sells", 0)
        print("  24h Txns: {} buys / {} sells".format(buys, sells))
        
        if buys > 0 and sells > 0:
            ratio = buys / sells
            if ratio > 3:
                print("  ⚠️ Buy/sell ratio very high ({:.1f}x) — possible bot activity".format(ratio))
            elif sells > buys * 3:
                print("  🔴 More sells than buys — possible dump in progress")
        
        print("")
        
        # Risk assessment
        print("-" * 65)
        print("RISK ASSESSMENT:")
        print("-" * 65)
        risks = []
        
        if liq_usd and liq_usd < 10000:
            risks.append(("🔴 CRITICAL", "Liquidity under $10K — high rug pull risk"))
        elif liq_usd and liq_usd < 50000:
            risks.append(("🟡 WARNING", "Low liquidity under $50K — high slippage"))
        else:
            risks.append(("🟢 OK", "Reasonable liquidity"))
        
        if vol_24h and liq_usd and vol_24h > liq_usd * 10:
            risks.append(("🟡 WARNING", "Volume/liquidity ratio very high — volatile"))
        
        fdv = pair.get("fdv", 0)
        if fdv and fdv > 100000000:
            risks.append(("🟡 WARNING", "FDV over $100M — may be overvalued for a meme coin"))
        
        age_str = pair.get("pairCreatedAt", "")
        if age_str:
            try:
                created_ms = int(age_str)
                age_hours = (time.time() * 1000 - created_ms) / (1000 * 3600)
                if age_hours < 24:
                    risks.append(("🔴 CRITICAL", "Pair created less than 24h ago ({:.0f}h)".format(age_hours)))
                elif age_hours < 168:
                    risks.append(("🟡 WARNING", "Pair less than 1 week old ({:.0f}h)".format(age_hours)))
                else:
                    risks.append(("🟢 OK", "Pair age: {:.0f} days".format(age_hours / 24)))
            except (ValueError, TypeError):
                pass
        
        for risk_level, msg in risks:
            print("  {} {}".format(risk_level, msg))
        
        print("")
        print("EXTERNAL CHECKS (do these manually):")
        checkers = [
            "TokenSniffer: https://tokensniffer.com/token/{}{}".format("" if chain == "ethereum" else chain + "/", token),
            "GoPlus: https://gopluslabs.io/token-security/{}/{}".format(chain_id, token),
            "Honeypot.is: https://honeypot.is/?address={}".format(token),
            "DEXScreener: https://dexscreener.com/{}/{}".format(chain_id, token)
        ]
        if chain == "solana":
            checkers.append("RugCheck: https://rugcheck.xyz/tokens/{}".format(token))
        
        for c in checkers:
            print("  • {}".format(c))
    else:
        print("No trading pairs found for this token.")
        print("It may not be listed on any DEX yet, or the address is incorrect.")

except Exception as e:
    print("Error fetching data: {}".format(str(e)))
    print("DexScreener may be rate limited. Try again in a moment.")

print("")
print("⚠️ DISCLAIMER: This is not financial advice. Always DYOR.")
print("   Start with tiny test amounts before committing real funds.")
PYEOF
    ;;

  trending)
    CHAIN="${1:-all}"
    python3 << 'PYEOF'
import sys, os, json, time
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

chain = sys.argv[1] if len(sys.argv) > 1 else "all"

print("=" * 70)
print("TRENDING MEME COINS — {}".format(time.strftime("%Y-%m-%d %H:%M")))
print("=" * 70)
print("")

try:
    url = "https://api.dexscreener.com/token-boosts/latest/v1"
    req = Request(url)
    req.add_header("User-Agent", "MemeCoinScanner/1.0")
    resp = urlopen(req, timeout=15)
    data = json.loads(resp.read().decode("utf-8"))
    
    tokens = data if isinstance(data, list) else data.get("tokens", data.get("data", []))
    
    if chain != "all":
        tokens = [t for t in tokens if chain.lower() in (t.get("chainId", "") or "").lower()]
    
    print("{:<4} {:<12} {:<10} {:<15} {:>12}".format("#", "Symbol", "Chain", "Name", "Boost"))
    print("-" * 60)
    
    for i, t in enumerate(tokens[:20], 1):
        symbol = t.get("tokenAddress", t.get("symbol", "?"))[:11]
        chain_id = t.get("chainId", "?")[:9]
        name = (t.get("description", t.get("name", "?")) or "?")[:14]
        amount = t.get("totalAmount", t.get("amount", 0))
        
        print("{:<4} {:<12} {:<10} {:<15} {:>12}".format(i, symbol, chain_id, name, amount))
    
    print("")
    print("Note: Boosted tokens have paid for promotion — exercise extra caution!")
    
except Exception as e:
    print("Error: {}".format(str(e)))
    print("")
    print("Alternative: Check trending on")
    print("  • dexscreener.com/trending")
    print("  • dextools.io/trending")
    print("  • birdeye.so/trending (Solana)")
PYEOF
    ;;

  checklist)
    python3 << 'PYEOF'
print("=" * 60)
print("MEME COIN SAFETY CHECKLIST")
print("=" * 60)
print("")

categories = {
    "Before Buying": [
        ("Check contract on block explorer", "CRITICAL"),
        ("Verify on TokenSniffer (score > 70)", "CRITICAL"),
        ("Check honeypot.is for sell ability", "CRITICAL"),
        ("Liquidity locked? (check locker)", "CRITICAL"),
        ("Ownership renounced?", "HIGH"),
        ("Top 10 holders < 30% total supply", "HIGH"),
        ("Contract verified and readable", "HIGH"),
        ("No mint function", "CRITICAL"),
        ("No blacklist function", "MEDIUM"),
        ("Tax < 10% each way", "HIGH")
    ],
    "Red Flags": [
        ("Dev holds > 10% of supply", "🔴"),
        ("Liquidity < $10,000", "🔴"),
        ("Token < 24 hours old", "🔴"),
        ("No social media presence", "🟡"),
        ("Copy of another token name", "🟡"),
        ("Promises guaranteed returns", "🔴"),
        ("Telegram/Discord admin-only posting", "🟡"),
        ("No website or one-page site", "🟡")
    ],
    "After Buying": [
        ("Set stop-loss mentally", "HIGH"),
        ("Take profit in stages (25/25/25/25)", "MEDIUM"),
        ("Monitor liquidity changes", "HIGH"),
        ("Watch for large holder sells", "MEDIUM"),
        ("Don't invest more than 1-2% of portfolio", "HIGH")
    ]
}

for cat, items in categories.items():
    print("{}:".format(cat))
    for item, level in items:
        print("  [ ] {} [{}]".format(item, level))
    print("")

print("SAFE APPROACH:")
print("  1. Only risk money you can 100% lose")
print("  2. Test with $10-50 first")
print("  3. If you can't sell the test amount — it's a honeypot")
print("  4. Take initial investment out after 2-3x")
print("  5. Let profits ride with zero risk")
PYEOF
    ;;

  new)
    CHAIN="${1:-solana}"
    python3 << 'PYEOF'
import sys, json, time
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

chain = sys.argv[1] if len(sys.argv) > 1 else "solana"

print("=" * 65)
print("NEW TOKEN LISTINGS — {} Chain".format(chain.upper()))
print("=" * 65)
print("")

try:
    url = "https://api.dexscreener.com/latest/dex/search?q=new%20{}".format(chain)
    req = Request(url)
    req.add_header("User-Agent", "MemeCoinScanner/1.0")
    resp = urlopen(req, timeout=15)
    data = json.loads(resp.read().decode("utf-8"))
    pairs = data.get("pairs", [])
    
    pairs = [p for p in pairs if chain.lower() in (p.get("chainId", "") or "").lower()]
    pairs.sort(key=lambda x: x.get("pairCreatedAt", 0) or 0, reverse=True)
    
    for i, p in enumerate(pairs[:15], 1):
        base = p.get("baseToken", {})
        name = base.get("name", "?")[:20]
        symbol = base.get("symbol", "?")[:8]
        price = p.get("priceUsd", "?")
        liq = p.get("liquidity", {}).get("usd", 0)
        vol = p.get("volume", {}).get("h24", 0)
        
        liq_str = "${:,.0f}".format(liq) if liq else "?"
        vol_str = "${:,.0f}".format(vol) if vol else "?"
        
        created = p.get("pairCreatedAt", 0)
        if created:
            try:
                age_h = (time.time() * 1000 - int(created)) / (1000 * 3600)
                age_str = "{:.0f}h ago".format(age_h) if age_h < 48 else "{:.0f}d ago".format(age_h / 24)
            except (ValueError, TypeError):
                age_str = "?"
        else:
            age_str = "?"
        
        warn = "⚠️" if (liq and liq < 10000) else "  "
        print("{}{:>2}. {} ({}) — ${}".format(warn, i, name, symbol, price))
        print("    Liq: {}  Vol: {}  Age: {}".format(liq_str, vol_str, age_str))
        print("")

except Exception as e:
    print("Error: {}".format(str(e)))
PYEOF
    ;;

  help|*)
    cat << 'HELPEOF'
Meme Coin Scanner — Detect scams, analyze new tokens

COMMANDS:
  scan <token_addr> [chain]   Deep security scan
  trending [chain]            Trending/boosted tokens
  new [chain]                 Newly listed tokens
  checklist                   Safety checklist

EXAMPLES:
  bash meme.sh scan 0x1234...abcd ethereum
  bash meme.sh trending solana
  bash meme.sh new base
  bash meme.sh checklist
HELPEOF
    ;;
esac
echo ""
echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
