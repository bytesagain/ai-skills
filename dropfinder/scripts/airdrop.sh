#!/usr/bin/env bash
# Airdrop Hunter — Track and qualify for crypto airdrops
set -euo pipefail
COMMAND="${1:-help}"; shift 2>/dev/null || true
DATA_DIR="${HOME}/.airdrop-hunter"; mkdir -p "$DATA_DIR"

case "$COMMAND" in
  list)
    CHAIN="${1:-all}"
    python3 << 'PYEOF'
import sys, os, json, time

chain = sys.argv[1] if len(sys.argv) > 1 else "all"

airdrops = [
    {"name": "LayerZero", "chain": "Multi-chain", "type": "Retroactive", "status": "Confirmed", "est_value": "$500-5000", "deadline": "TBD",
     "requirements": ["Bridge via Stargate", "Use OFT tokens", "Message across chains"], "risk": "Low"},
    {"name": "zkSync", "chain": "Ethereum L2", "type": "Retroactive", "status": "Likely", "est_value": "$1000-10000", "deadline": "TBD",
     "requirements": ["Bridge to zkSync Era", "Use DEXes (SyncSwap)", "Mint NFTs", "Deploy contracts"], "risk": "Low"},
    {"name": "Scroll", "chain": "Ethereum L2", "type": "Retroactive", "status": "Likely", "est_value": "$500-3000", "deadline": "TBD",
     "requirements": ["Bridge to Scroll", "Swap on DEXes", "Provide liquidity", "Use lending protocols"], "risk": "Low"},
    {"name": "Linea", "chain": "Ethereum L2", "type": "Retroactive", "status": "Likely", "est_value": "$200-2000", "deadline": "TBD",
     "requirements": ["Bridge via official bridge", "Use DeFi dApps", "Complete Linea Voyage quests"], "risk": "Low"},
    {"name": "Monad", "chain": "EVM-compatible", "type": "Testnet", "status": "Early", "est_value": "$1000+", "deadline": "2025+",
     "requirements": ["Join testnet when live", "Deploy contracts", "Community participation"], "risk": "Medium"},
    {"name": "Berachain", "chain": "EVM-compatible", "type": "Testnet", "status": "Active", "est_value": "$500-5000", "deadline": "TBD",
     "requirements": ["Use Berachain testnet", "Proof of Liquidity", "Provide BGT liquidity"], "risk": "Low"},
    {"name": "EigenLayer", "chain": "Ethereum", "type": "Restaking", "status": "Confirmed", "est_value": "$1000-20000", "deadline": "TBD",
     "requirements": ["Restake ETH/LSTs", "Use EigenLayer operators", "Early depositors preferred"], "risk": "Medium"},
    {"name": "Hyperlane", "chain": "Multi-chain", "type": "Retroactive", "status": "Likely", "est_value": "$200-2000", "deadline": "TBD",
     "requirements": ["Send cross-chain messages", "Use Hyperlane-powered bridges"], "risk": "Low"},
    {"name": "StarkNet", "chain": "Ethereum L2", "type": "Retroactive", "status": "Ongoing", "est_value": "$300-3000", "deadline": "TBD",
     "requirements": ["Bridge to StarkNet", "Use DEXes (JediSwap, mySwap)", "Provide liquidity"], "risk": "Low"},
    {"name": "Grass", "chain": "Solana", "type": "Node", "status": "Active", "est_value": "$100-1000", "deadline": "TBD",
     "requirements": ["Run Grass node (browser extension)", "Accumulate points", "Referral program"], "risk": "Low"}
]

if chain != "all":
    airdrops = [a for a in airdrops if chain.lower() in a["chain"].lower()]

print("=" * 75)
print("AIRDROP OPPORTUNITIES — {} ({})".format(
    "All Chains" if chain == "all" else chain, time.strftime("%Y-%m-%d")))
print("=" * 75)
print("")

for i, a in enumerate(airdrops, 1):
    status_icon = {"Confirmed": "✅", "Likely": "🔶", "Active": "🟢", "Early": "🔵"}.get(a["status"], "❓")
    print("{}. {} {} — {} ({})".format(i, status_icon, a["name"], a["type"], a["chain"]))
    print("   Est. Value: {}  |  Risk: {}  |  Status: {}".format(a["est_value"], a["risk"], a["status"]))
    print("   Requirements:")
    for req in a["requirements"]:
        print("     • {}".format(req))
    if a["deadline"] != "TBD":
        print("   ⏰ Deadline: {}".format(a["deadline"]))
    print("")

print("Total: {} airdrops listed".format(len(airdrops)))
print("")
print("⚠️  Airdrop values are estimates based on similar past drops.")
print("   Never invest more than you can afford to lose.")

data_dir = os.path.expanduser("~/.airdrop-hunter")
with open(os.path.join(data_dir, "airdrops-cache.json"), "w") as f:
    json.dump({"timestamp": time.strftime("%Y-%m-%d %H:%M"), "airdrops": airdrops}, f, indent=2)
PYEOF
    ;;

  check)
    WALLET="${1:-}"
    python3 << 'PYEOF'
import sys, os, json
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

wallet = sys.argv[1] if len(sys.argv) > 1 else ""
if not wallet:
    print("Usage: bash airdrop.sh check <wallet_address>")
    sys.exit(1)

print("=" * 60)
print("WALLET AIRDROP ELIGIBILITY CHECK")
print("=" * 60)
print("")
print("Wallet: {}".format(wallet))
print("")

checks = [
    {"protocol": "LayerZero", "check": "Cross-chain transactions", "api": "etherscan"},
    {"protocol": "zkSync Era", "check": "zkSync bridge & DEX activity", "api": "zksync"},
    {"protocol": "Scroll", "check": "Scroll bridge & DeFi", "api": "scrollscan"},
    {"protocol": "Linea", "check": "Linea bridge & DeFi", "api": "lineascan"},
    {"protocol": "StarkNet", "check": "StarkNet transactions", "api": "starkscan"},
    {"protocol": "EigenLayer", "check": "ETH restaking", "api": "etherscan"},
    {"protocol": "Base", "check": "Base chain activity", "api": "basescan"},
    {"protocol": "Arbitrum", "check": "Already claimed (ARB)", "api": "arbiscan"}
]

# Check EVM transaction count as proxy
is_evm = wallet.startswith("0x") and len(wallet) == 42

if is_evm:
    chains_to_check = {
        "Ethereum": "https://api.etherscan.io/api?module=account&action=txlist&address={}&startblock=0&endblock=99999999&page=1&offset=1&sort=desc".format(wallet),
        "Arbitrum": "https://api.arbiscan.io/api?module=account&action=txlist&address={}&startblock=0&endblock=99999999&page=1&offset=1&sort=desc".format(wallet),
        "Base": "https://api.basescan.org/api?module=account&action=txlist&address={}&startblock=0&endblock=99999999&page=1&offset=1&sort=desc".format(wallet)
    }
    
    print("Checking on-chain activity...")
    print("")
    for chain_name, url in chains_to_check.items():
        try:
            req = Request(url)
            req.add_header("User-Agent", "AirdropHunter/1.0")
            resp = urlopen(req, timeout=10)
            data = json.loads(resp.read().decode("utf-8"))
            has_tx = data.get("status") == "1" and len(data.get("result", [])) > 0
            icon = "✅" if has_tx else "❌"
            print("  {} {} — {}".format(icon, chain_name, "Active" if has_tx else "No activity"))
        except Exception:
            print("  ❓ {} — Unable to check (API rate limit)".format(chain_name))
    
    print("")
    print("RECOMMENDATIONS:")
    print("  1. Bridge ETH to any L2s you haven't used")
    print("  2. Do at least 5 transactions on each chain")
    print("  3. Use a DEX swap on each chain")
    print("  4. Interact with 3+ unique contracts per chain")
    print("  5. Have activity across multiple months")
else:
    print("Non-EVM wallet detected. Check Solana-specific airdrops.")
    print("  - Use phantom.app to check Solana activity")
    print("  - Check Jupiter, Marinade, Tensor for past airdrops")
PYEOF
    ;;

  strategy)
    python3 << 'PYEOF'
print("=" * 65)
print("AIRDROP FARMING STRATEGY GUIDE")
print("=" * 65)
print("")

strategies = [
    {
        "name": "L2 Bridge Strategy",
        "difficulty": "Easy",
        "cost": "$50-200",
        "time": "1-2 hours/week",
        "steps": [
            "Bridge ETH to zkSync, Scroll, Linea, Base, Blast",
            "Swap tokens on each chain's main DEX",
            "Provide small liquidity positions",
            "Interact weekly to build transaction history",
            "Use official bridges (not 3rd party)"
        ]
    },
    {
        "name": "Testnet Grinder",
        "difficulty": "Medium",
        "cost": "Free (gas from faucets)",
        "time": "2-3 hours/week",
        "steps": [
            "Join testnets early (Monad, Berachain, etc.)",
            "Complete all available quests/tasks",
            "Deploy simple contracts",
            "Run validator/node if possible",
            "Document everything for proof"
        ]
    },
    {
        "name": "DeFi Power User",
        "difficulty": "Advanced",
        "cost": "$500-5000",
        "time": "3-5 hours/week",
        "steps": [
            "Restake ETH on EigenLayer",
            "Use lending protocols (Aave, Compound forks)",
            "Provide concentrated liquidity",
            "Use governance (vote on proposals)",
            "Cross-chain messaging (LayerZero, Hyperlane)"
        ]
    },
    {
        "name": "Social/Community Farming",
        "difficulty": "Easy",
        "cost": "Free",
        "time": "30 min/day",
        "steps": [
            "Join Discord servers of upcoming projects",
            "Earn roles (active member, contributor)",
            "Follow and engage on Twitter/X",
            "Complete Galxe/Zealy quests",
            "Write content about protocols"
        ]
    }
]

for s in strategies:
    print("{}:".format(s["name"]))
    print("  Difficulty: {} | Cost: {} | Time: {}".format(s["difficulty"], s["cost"], s["time"]))
    for step in s["steps"]:
        print("    • {}".format(step))
    print("")

print("-" * 65)
print("GOLDEN RULES:")
rules = [
    "Never share private keys or seed phrases",
    "Use a dedicated wallet for airdrop farming",
    "Spread activity over multiple months (not just 1 day)",
    "Quality > quantity — deep usage beats many tiny transactions",
    "Keep gas costs below expected airdrop value",
    "Sybil detection is real — don't use too many wallets",
    "Early users typically get larger allocations"
]
for i, r in enumerate(rules, 1):
    print("  {}. {}".format(i, r))
PYEOF
    ;;

  calendar)
    python3 << 'PYEOF'
import time

print("=" * 60)
print("AIRDROP CALENDAR — {}".format(time.strftime("%Y-%m-%d")))
print("=" * 60)
print("")

events = [
    {"month": "Ongoing", "items": [
        "Berachain testnet — Farm BGT",
        "EigenLayer — Continue restaking",
        "Grass — Run node for points",
        "Scroll/Linea — Weekly DeFi activity"
    ]},
    {"month": "Q1 2025", "items": [
        "LayerZero Season 2 — Cross-chain activity",
        "zkSync — Possible token launch",
        "StarkNet Round 3 — Additional allocation"
    ]},
    {"month": "Q2 2025", "items": [
        "Monad — Testnet expected",
        "Scroll — Possible TGE",
        "Hyperlane — Token launch expected"
    ]},
    {"month": "H2 2025", "items": [
        "Linea — Token expected",
        "Blast Season 3 — Ongoing",
        "Multiple L2s maturing"
    ]}
]

for period in events:
    print("📅 {}:".format(period["month"]))
    for item in period["items"]:
        print("   • {}".format(item))
    print("")

print("TIP: Check @aaborov, @ardizor, @Defi_Mochi on X for latest updates")
PYEOF
    ;;

  track)
    ACTION="${1:-list}"
    NAME="${2:-}"
    python3 << 'PYEOF'
import json, os, sys
action = sys.argv[1] if len(sys.argv) > 1 else "list"
name = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""
data_dir = os.path.expanduser("~/.airdrop-hunter")
track_file = os.path.join(data_dir, "tracked.json")
tracked = []
if os.path.exists(track_file):
    with open(track_file) as f:
        tracked = json.load(f)
if action == "add" and name:
    tracked.append({"name": name, "added": __import__("time").strftime("%Y-%m-%d")})
    with open(track_file, "w") as f:
        json.dump(tracked, f, indent=2)
    print("Tracking: {}".format(name))
elif action == "remove" and name:
    tracked = [t for t in tracked if name.lower() not in t["name"].lower()]
    with open(track_file, "w") as f:
        json.dump(tracked, f, indent=2)
    print("Removed: {}".format(name))
else:
    print("Tracked Airdrops ({})".format(len(tracked)))
    for t in tracked:
        print("  • {} (added: {})".format(t["name"], t.get("added", "?")))
    if not tracked:
        print("  None. Use: bash airdrop.sh track add <name>")
PYEOF
    ;;

  history)
    python3 << 'PYEOF'
print("=" * 65)
print("NOTABLE PAST AIRDROPS (for reference)")
print("=" * 65)
print("")
past = [
    ("Uniswap (UNI)", "Sep 2020", "$1,200", "400 UNI to all users"),
    ("ENS", "Nov 2021", "$2,000-20,000", "Based on registration history"),
    ("Optimism (OP)", "Jun 2022", "$300-3,000", "Bridge + usage criteria"),
    ("Aptos (APT)", "Oct 2022", "$200-500", "Testnet participation"),
    ("Arbitrum (ARB)", "Mar 2023", "$500-5,000", "Bridge + DeFi activity"),
    ("Celestia (TIA)", "Oct 2023", "$2,000-20,000", "Stakers of ATOM/ETH"),
    ("Jito (JTO)", "Dec 2023", "$1,000-10,000", "Solana MEV users"),
    ("Jupiter (JUP)", "Jan 2024", "$200-2,000", "Jupiter DEX users"),
    ("Wormhole (W)", "Apr 2024", "$300-3,000", "Cross-chain users"),
    ("Starknet (STRK)", "Feb 2024", "$100-1,000", "Ecosystem users")
]
print("{:<25} {:<12} {:<15} {}".format("Project", "Date", "Value", "Criteria"))
print("-" * 65)
for name, date, value, criteria in past:
    print("{:<25} {:<12} {:<15} {}".format(name, date, value, criteria))
print("")
print("Pattern: Bridge + DEX + LP + Governance = Best allocation")
PYEOF
    ;;

  help|*)
    cat << 'HELPEOF'
Airdrop Hunter — Find and track crypto airdrop opportunities

COMMANDS:
  list [chain]          Active airdrop opportunities
  check <wallet>        Check wallet eligibility
  calendar              Upcoming airdrop timeline
  strategy              Farming strategy guide
  track [add|remove|list] Manage tracked airdrops
  history               Past notable airdrops

EXAMPLES:
  bash airdrop.sh list
  bash airdrop.sh check 0x1234...abcd
  bash airdrop.sh strategy
  bash airdrop.sh track add "LayerZero"
HELPEOF
    ;;
esac
echo ""
echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
