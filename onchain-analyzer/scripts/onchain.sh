#!/usr/bin/env bash
# Onchain Analyzer — Analyze wallet addresses across chains
set -euo pipefail
COMMAND="${1:-help}"; shift 2>/dev/null || true
DATA_DIR="${HOME}/.onchain-analyzer"; mkdir -p "$DATA_DIR"

case "$COMMAND" in
  profile)
    ADDRESS="${1:-}"; CHAIN="${2:-ethereum}"
    python3 << 'PYEOF'
import sys, os, json, time
try:
    from urllib2 import urlopen, Request
    from urllib import urlencode
except ImportError:
    from urllib.request import urlopen, Request
    from urllib.parse import urlencode

address = sys.argv[1] if len(sys.argv) > 1 else ""
chain = sys.argv[2] if len(sys.argv) > 2 else "ethereum"

if not address:
    print("Usage: bash onchain.sh profile <address> [chain]")
    sys.exit(1)

apis = {
    "ethereum": {"url": "https://api.etherscan.io/api", "native": "ETH", "explorer": "https://etherscan.io/address/{}"},
    "bsc": {"url": "https://api.bscscan.com/api", "native": "BNB", "explorer": "https://bscscan.com/address/{}"},
    "polygon": {"url": "https://api.polygonscan.com/api", "native": "MATIC", "explorer": "https://polygonscan.com/address/{}"},
    "arbitrum": {"url": "https://api.arbiscan.io/api", "native": "ETH", "explorer": "https://arbiscan.io/address/{}"},
    "base": {"url": "https://api.basescan.org/api", "native": "ETH", "explorer": "https://basescan.org/address/{}"},
    "optimism": {"url": "https://api-optimistic.etherscan.io/api", "native": "ETH", "explorer": "https://optimistic.etherscan.io/address/{}"}
}

config = apis.get(chain, apis["ethereum"])
api_key = os.environ.get("ETHERSCAN_API_KEY", "")

print("=" * 70)
print("WALLET PROFILE — {}".format(address[:10] + "..." + address[-6:]))
print("Chain: {} | Time: {}".format(chain.upper(), time.strftime("%Y-%m-%d %H:%M")))
print("=" * 70)
print("")
print("Explorer: {}".format(config["explorer"].format(address)))
print("")

# Get balance
try:
    params = {"module": "account", "action": "balance", "address": address, "tag": "latest"}
    if api_key:
        params["apikey"] = api_key
    url = "{}?{}".format(config["url"], urlencode(params))
    req = Request(url)
    resp = urlopen(req, timeout=10)
    data = json.loads(resp.read().decode("utf-8"))
    
    if data.get("status") == "1":
        balance_wei = int(data.get("result", 0))
        balance = balance_wei / 1e18
        print("💰 {} Balance: {:.6f} {}".format(config["native"], balance, config["native"]))
    else:
        print("💰 Balance: Unable to fetch")
except Exception as e:
    print("Balance error: {}".format(str(e)[:50]))

# Get transaction count
try:
    params = {"module": "proxy", "action": "eth_getTransactionCount", "address": address, "tag": "latest"}
    if api_key:
        params["apikey"] = api_key
    url = "{}?{}".format(config["url"], urlencode(params))
    req = Request(url)
    resp = urlopen(req, timeout=10)
    data = json.loads(resp.read().decode("utf-8"))
    nonce = int(data.get("result", "0x0"), 16)
    print("📊 Transaction count (nonce): {}".format(nonce))
except Exception:
    pass

# Get recent transactions
try:
    params = {"module": "account", "action": "txlist", "address": address, "startblock": 0, "endblock": 99999999, "page": 1, "offset": 10, "sort": "desc"}
    if api_key:
        params["apikey"] = api_key
    url = "{}?{}".format(config["url"], urlencode(params))
    req = Request(url)
    resp = urlopen(req, timeout=10)
    data = json.loads(resp.read().decode("utf-8"))
    
    txns = data.get("result", [])
    if isinstance(txns, list) and txns:
        print("")
        print("📋 RECENT TRANSACTIONS (last 10):")
        print("-" * 70)
        
        total_in = 0
        total_out = 0
        unique_contracts = set()
        
        for tx in txns[:10]:
            ts = int(tx.get("timeStamp", 0))
            date = time.strftime("%Y-%m-%d %H:%M", time.localtime(ts)) if ts else "?"
            value = int(tx.get("value", 0)) / 1e18
            gas_used = int(tx.get("gasUsed", 0))
            gas_price = int(tx.get("gasPrice", 0))
            fee = (gas_used * gas_price) / 1e18
            
            is_outgoing = tx.get("from", "").lower() == address.lower()
            direction = "→ OUT" if is_outgoing else "← IN"
            to_addr = tx.get("to", "")[:10] + "..." if tx.get("to") else "Contract"
            
            if is_outgoing:
                total_out += value
            else:
                total_in += value
            
            if tx.get("to"):
                unique_contracts.add(tx["to"].lower())
            
            status = "✅" if tx.get("isError", "0") == "0" else "❌"
            
            if value > 0:
                print("  {} {} {} {:.4f} {} {} (fee: {:.6f})".format(
                    status, date, direction, value, config["native"], to_addr, fee))
            else:
                method = tx.get("functionName", "")[:30] or "transfer"
                print("  {} {} {} {} → {}".format(status, date, direction, method, to_addr))
        
        print("")
        print("SUMMARY:")
        print("  Total received: {:.4f} {}".format(total_in, config["native"]))
        print("  Total sent: {:.4f} {}".format(total_out, config["native"]))
        print("  Unique addresses interacted: {}".format(len(unique_contracts)))
        
        # Wallet type guess
        if nonce > 1000:
            print("  Wallet type: 🐋 High-activity (possible bot/whale)")
        elif nonce > 100:
            print("  Wallet type: 👤 Active user")
        elif nonce > 10:
            print("  Wallet type: 🌱 Moderate user")
        else:
            print("  Wallet type: 🆕 New/dormant wallet")
    else:
        print("")
        print("No transactions found. Wallet may be empty or API key needed.")
        
except Exception as e:
    print("Transaction error: {}".format(str(e)[:80]))

# Get token transfers
try:
    time.sleep(0.5)
    params = {"module": "account", "action": "tokentx", "address": address, "page": 1, "offset": 5, "sort": "desc"}
    if api_key:
        params["apikey"] = api_key
    url = "{}?{}".format(config["url"], urlencode(params))
    req = Request(url)
    resp = urlopen(req, timeout=10)
    data = json.loads(resp.read().decode("utf-8"))
    
    tokens = data.get("result", [])
    if isinstance(tokens, list) and tokens:
        print("")
        print("🪙 RECENT TOKEN TRANSFERS:")
        print("-" * 70)
        seen_tokens = set()
        for tx in tokens[:5]:
            token_name = tx.get("tokenName", "?")
            token_symbol = tx.get("tokenSymbol", "?")
            decimals = int(tx.get("tokenDecimal", 18))
            value = int(tx.get("value", 0)) / (10 ** decimals)
            is_out = tx.get("from", "").lower() == address.lower()
            direction = "→" if is_out else "←"
            
            if value > 0:
                print("  {} {:.4f} {} ({})".format(direction, value, token_symbol, token_name))
            seen_tokens.add(token_symbol)
        
        print("  Unique tokens interacted: {}".format(len(seen_tokens)))
except Exception:
    pass

# Save profile
profile = {
    "address": address,
    "chain": chain,
    "checked": time.strftime("%Y-%m-%d %H:%M:%S")
}
prof_file = os.path.join(os.path.expanduser("~/.onchain-analyzer"), "profile-{}.json".format(address[:10]))
with open(prof_file, "w") as f:
    json.dump(profile, f, indent=2)
PYEOF
    ;;

  tokens)
    ADDRESS="${1:-}"; CHAIN="${2:-ethereum}"
    python3 << 'PYEOF'
import sys, os, json, time
try:
    from urllib2 import urlopen, Request
    from urllib import urlencode
except ImportError:
    from urllib.request import urlopen, Request
    from urllib.parse import urlencode

address = sys.argv[1] if len(sys.argv) > 1 else ""
chain = sys.argv[2] if len(sys.argv) > 2 else "ethereum"

if not address:
    print("Usage: bash onchain.sh tokens <address> [chain]")
    sys.exit(1)

apis = {
    "ethereum": "https://api.etherscan.io/api",
    "bsc": "https://api.bscscan.com/api",
    "polygon": "https://api.polygonscan.com/api",
    "arbitrum": "https://api.arbiscan.io/api",
    "base": "https://api.basescan.org/api"
}

api_url = apis.get(chain, apis["ethereum"])
api_key = os.environ.get("ETHERSCAN_API_KEY", "")

print("=" * 60)
print("TOKEN HOLDINGS — {}...{}".format(address[:8], address[-6:]))
print("Chain: {}".format(chain.upper()))
print("=" * 60)
print("")

try:
    params = {"module": "account", "action": "tokentx", "address": address, "page": 1, "offset": 100, "sort": "desc"}
    if api_key:
        params["apikey"] = api_key
    url = "{}?{}".format(api_url, urlencode(params))
    req = Request(url)
    resp = urlopen(req, timeout=15)
    data = json.loads(resp.read().decode("utf-8"))
    
    txns = data.get("result", [])
    if isinstance(txns, list):
        # Calculate net holdings per token
        holdings = {}
        for tx in txns:
            symbol = tx.get("tokenSymbol", "?")
            name = tx.get("tokenName", "?")
            decimals = int(tx.get("tokenDecimal", 18))
            value = int(tx.get("value", 0)) / (10 ** decimals)
            contract = tx.get("contractAddress", "")
            
            if symbol not in holdings:
                holdings[symbol] = {"name": name, "net": 0, "contract": contract, "in": 0, "out": 0}
            
            if tx.get("to", "").lower() == address.lower():
                holdings[symbol]["net"] += value
                holdings[symbol]["in"] += value
            else:
                holdings[symbol]["net"] -= value
                holdings[symbol]["out"] += value
        
        # Show tokens with positive balance
        positive = {k: v for k, v in holdings.items() if v["net"] > 0.001}
        
        print("{:<10} {:<25} {:>15} {:>15}".format("Symbol", "Name", "Balance", "Total In"))
        print("-" * 60)
        for sym, data in sorted(positive.items(), key=lambda x: x[1]["net"], reverse=True):
            print("{:<10} {:<25} {:>15,.4f} {:>15,.4f}".format(
                sym[:9], data["name"][:24], data["net"], data["in"]))
        
        print("")
        print("Unique tokens: {}".format(len(positive)))
        print("")
        print("Note: Balances are estimates from transfer history.")
        print("      For exact balances, use direct contract calls.")
    else:
        print("No token data available. API key may be required.")
        
except Exception as e:
    print("Error: {}".format(str(e)[:80]))
PYEOF
    ;;

  patterns)
    ADDRESS="${1:-}"
    python3 << 'PYEOF'
import sys

address = sys.argv[1] if len(sys.argv) > 1 else ""
if not address:
    print("Usage: bash onchain.sh patterns <address>")
    sys.exit(1)

print("=" * 60)
print("TRADING PATTERN ANALYSIS")
print("=" * 60)
print("")
print("Wallet: {}...{}".format(address[:8], address[-6:]))
print("")
print("Analysis requires historical transaction data.")
print("Fetch with: bash onchain.sh profile {} ethereum".format(address))
print("")
print("COMMON PATTERNS TO LOOK FOR:")
print("")
patterns = [
    ("DCA Buyer", "Regular purchases at fixed intervals", "🟢 Low risk"),
    ("Swing Trader", "Buy dips, sell rallies over weeks", "🟡 Medium risk"),
    ("Day Trader", "Multiple trades per day", "🔴 High risk"),
    ("Whale", "Large single transactions >$100K", "👀 Watch closely"),
    ("Airdrop Farmer", "Interacts with many new protocols", "🟢 Strategic"),
    ("NFT Collector", "Frequent NFT mints and trades", "🟡 Variable"),
    ("Bot", "Extremely high frequency, identical patterns", "⚠️ Automated"),
    ("Sniper", "Buys immediately after liquidity added", "🔴 MEV/front-running")
]

print("{:<18} {:<35} {}".format("Pattern", "Description", "Risk"))
print("-" * 60)
for name, desc, risk in patterns:
    print("{:<18} {:<35} {}".format(name, desc, risk))
PYEOF
    ;;

  compare)
    ADDR1="${1:-}"; ADDR2="${2:-}"
    python3 << 'PYEOF'
import sys
a1 = sys.argv[1] if len(sys.argv) > 1 else ""
a2 = sys.argv[2] if len(sys.argv) > 2 else ""
if not a1 or not a2:
    print("Usage: bash onchain.sh compare <address1> <address2>")
    sys.exit(1)

print("=" * 60)
print("WALLET COMPARISON")
print("=" * 60)
print("")
print("Wallet A: {}...{}".format(a1[:8], a1[-6:]))
print("Wallet B: {}...{}".format(a2[:8], a2[-6:]))
print("")
print("Run profile for each wallet first:")
print("  bash onchain.sh profile {} ethereum".format(a1))
print("  bash onchain.sh profile {} ethereum".format(a2))
print("")
print("Then compare:")
print("  • Transaction count and frequency")
print("  • Token overlap (shared holdings)")
print("  • Trading patterns")
print("  • Interaction with same contracts")
print("  • Timing correlation (sybil detection)")
PYEOF
    ;;

  help|*)
    cat << 'HELPEOF'
Onchain Analyzer — Deep wallet analysis across chains

COMMANDS:
  profile <addr> [chain]         Full wallet profile
  tokens <addr> [chain]          Token holdings
  patterns <addr>                Trading pattern analysis
  compare <addr1> <addr2>        Compare two wallets

CHAINS: ethereum, bsc, polygon, arbitrum, base, optimism

ENV VARS:
  ETHERSCAN_API_KEY — For enhanced API access (free tier at etherscan.io)

EXAMPLES:
  bash onchain.sh profile 0x1234...abcd ethereum
  bash onchain.sh tokens 0x1234...abcd bsc
  bash onchain.sh patterns 0x1234...abcd
  bash onchain.sh compare 0xAAAA 0xBBBB
HELPEOF
    ;;
esac
echo ""
echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
