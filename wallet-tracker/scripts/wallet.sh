#!/usr/bin/env bash
# Wallet Tracker — Track multiple crypto wallets across chains
# Usage: bash wallet.sh <command> [options]
set -euo pipefail

COMMAND="${1:-help}"
shift 2>/dev/null || true

DATA_DIR="${HOME}/.wallet-tracker"
mkdir -p "$DATA_DIR"

case "$COMMAND" in
  add)
    ADDRESS="${1:-}"
    CHAIN="${2:-ethereum}"
    LABEL="${3:-wallet}"

    export WALLET_ADDRESS="$ADDRESS"
    export WALLET_CHAIN="$CHAIN"
    export WALLET_LABEL="$LABEL"

    python3 << 'PYEOF'
import json, os, time

data_dir = os.path.expanduser("~/.wallet-tracker")
address = os.environ.get("WALLET_ADDRESS", "")
chain = os.environ.get("WALLET_CHAIN", "ethereum")
label = os.environ.get("WALLET_LABEL", "wallet")

if not address:
    print("Usage: bash wallet.sh add <address> [chain] [label]")
    print("Chains: ethereum, bsc, polygon, arbitrum, base, solana, avalanche, optimism")
    import sys
    sys.exit(1)

wallets_file = os.path.join(data_dir, "wallets.json")
wallets = []
if os.path.exists(wallets_file):
    with open(wallets_file, "r") as f:
        wallets = json.load(f)

# Check duplicate
for w in wallets:
    if w["address"].lower() == address.lower() and w["chain"] == chain:
        print("Wallet already tracked: {} ({})".format(address[:10] + "...", chain))
        import sys
        sys.exit(0)

wallets.append({
    "address": address,
    "chain": chain,
    "label": label,
    "added": time.strftime("%Y-%m-%d %H:%M:%S")
})

with open(wallets_file, "w") as f:
    json.dump(wallets, f, indent=2)

print("Added wallet: {} ({}) — {}".format(label, chain, address))
print("Total tracked wallets: {}".format(len(wallets)))
PYEOF
    ;;

  list)
    python3 << 'PYEOF'
import json, os

data_dir = os.path.expanduser("~/.wallet-tracker")
wallets_file = os.path.join(data_dir, "wallets.json")

if not os.path.exists(wallets_file):
    print("No wallets tracked. Use 'bash wallet.sh add <address> [chain] [label]'")
    exit(0)

with open(wallets_file, "r") as f:
    wallets = json.load(f)

print("=" * 70)
print("TRACKED WALLETS ({})".format(len(wallets)))
print("=" * 70)
print("")
print("{:<4} {:<15} {:<12} {:<44}".format("#", "Label", "Chain", "Address"))
print("-" * 70)
for i, w in enumerate(wallets, 1):
    addr = w["address"]
    short = addr[:6] + "..." + addr[-4:] if len(addr) > 14 else addr
    print("{:<4} {:<15} {:<12} {}".format(i, w["label"][:14], w["chain"], short))
PYEOF
    ;;

  check)
    ADDRESS="${1:-all}"
    export WALLET_TARGET="$ADDRESS"

    python3 << 'PYEOF'
import json, os, time
try:
    from urllib2 import urlopen, Request
    from urllib import urlencode
except ImportError:
    from urllib.request import urlopen, Request
    from urllib.parse import urlencode

data_dir = os.path.expanduser("~/.wallet-tracker")
target = os.environ.get("WALLET_TARGET", "all")

wallets_file = os.path.join(data_dir, "wallets.json")
if not os.path.exists(wallets_file):
    print("No wallets tracked. Use 'bash wallet.sh add <address>' first.")
    import sys
    sys.exit(1)

with open(wallets_file, "r") as f:
    wallets = json.load(f)

if target != "all":
    wallets = [w for w in wallets if target.lower() in w["address"].lower() or target.lower() in w["label"].lower()]

# API endpoints for balance checking
api_configs = {
    "ethereum": {
        "api": "https://api.etherscan.io/api",
        "explorer": "https://etherscan.io/address/{}",
        "native": "ETH",
        "decimals": 18
    },
    "bsc": {
        "api": "https://api.bscscan.com/api",
        "explorer": "https://bscscan.com/address/{}",
        "native": "BNB",
        "decimals": 18
    },
    "polygon": {
        "api": "https://api.polygonscan.com/api",
        "explorer": "https://polygonscan.com/address/{}",
        "native": "MATIC",
        "decimals": 18
    },
    "arbitrum": {
        "api": "https://api.arbiscan.io/api",
        "explorer": "https://arbiscan.io/address/{}",
        "native": "ETH",
        "decimals": 18
    },
    "base": {
        "api": "https://api.basescan.org/api",
        "explorer": "https://basescan.org/address/{}",
        "native": "ETH",
        "decimals": 18
    },
    "optimism": {
        "api": "https://api-optimistic.etherscan.io/api",
        "explorer": "https://optimistic.etherscan.io/address/{}",
        "native": "ETH",
        "decimals": 18
    },
    "avalanche": {
        "api": "https://api.snowtrace.io/api",
        "explorer": "https://snowtrace.io/address/{}",
        "native": "AVAX",
        "decimals": 18
    },
    "solana": {
        "api": "https://api.mainnet-beta.solana.com",
        "explorer": "https://solscan.io/account/{}",
        "native": "SOL",
        "decimals": 9
    }
}

print("=" * 70)
print("WALLET PORTFOLIO CHECK — {}".format(time.strftime("%Y-%m-%d %H:%M")))
print("=" * 70)

results = []

for w in wallets:
    chain = w["chain"]
    addr = w["address"]
    label = w["label"]
    config = api_configs.get(chain, {})

    balance = None

    if chain == "solana":
        try:
            import json as j
            payload = j.dumps({
                "jsonrpc": "2.0",
                "id": 1,
                "method": "getBalance",
                "params": [addr]
            })
            req = Request(config["api"], data=payload.encode("utf-8"))
            req.add_header("Content-Type", "application/json")
            resp = urlopen(req, timeout=10)
            data = j.loads(resp.read().decode("utf-8"))
            lamports = data.get("result", {}).get("value", 0)
            balance = lamports / (10 ** config["decimals"])
        except Exception:
            balance = None
    else:
        try:
            api_key = os.environ.get("ETHERSCAN_API_KEY", "")
            params = {
                "module": "account",
                "action": "balance",
                "address": addr,
                "tag": "latest"
            }
            if api_key:
                params["apikey"] = api_key
            url = "{}?{}".format(config.get("api", ""), urlencode(params))
            req = Request(url)
            resp = urlopen(req, timeout=10)
            data = json.loads(resp.read().decode("utf-8"))
            if data.get("status") == "1":
                wei = int(data.get("result", 0))
                balance = wei / (10 ** config["decimals"])
        except Exception:
            balance = None

    short_addr = addr[:8] + "..." + addr[-6:] if len(addr) > 18 else addr
    explorer_url = config.get("explorer", "").format(addr)

    result = {
        "label": label,
        "chain": chain,
        "address": short_addr,
        "native": config.get("native", "?"),
        "balance": balance,
        "explorer": explorer_url
    }
    results.append(result)

print("")
for r in results:
    print("{} ({} on {}):".format(r["label"], r["address"], r["chain"]))
    if r["balance"] is not None:
        print("  Balance: {:.6f} {}".format(r["balance"], r["native"]))
    else:
        print("  Balance: Unable to fetch (API key may be required)")
    print("  Explorer: {}".format(r["explorer"]))
    print("")

# Summary
print("-" * 70)
print("SUMMARY")
print("-" * 70)
print("  Wallets checked: {}".format(len(results)))
fetched = [r for r in results if r["balance"] is not None]
if fetched:
    by_native = {}
    for r in fetched:
        key = r["native"]
        if key not in by_native:
            by_native[key] = 0
        by_native[key] += r["balance"]
    for native, total in sorted(by_native.items()):
        print("  Total {}: {:.6f}".format(native, total))
else:
    print("  Set ETHERSCAN_API_KEY env var for EVM balance queries")
    print("  Solana queries work without API key")

# Save snapshot
snapshot = {
    "timestamp": time.strftime("%Y-%m-%d %H:%M:%S"),
    "wallets": results
}
snap_file = os.path.join(data_dir, "snapshot-{}.json".format(time.strftime("%Y%m%d-%H%M")))
with open(snap_file, "w") as f:
    json.dump(snapshot, f, indent=2, default=str)
print("")
print("Snapshot saved to: {}".format(snap_file))
PYEOF
    ;;

  remove)
    TARGET="${1:-}"
    export WALLET_TARGET="$TARGET"
    python3 << 'PYEOF'
import json, sys, os

data_dir = os.path.expanduser("~/.wallet-tracker")
target = os.environ.get("WALLET_TARGET", "")

if not target:
    print("Usage: bash wallet.sh remove <address_or_label>")
    sys.exit(1)

wallets_file = os.path.join(data_dir, "wallets.json")
if not os.path.exists(wallets_file):
    print("No wallets to remove.")
    sys.exit(0)

with open(wallets_file, "r") as f:
    wallets = json.load(f)

before = len(wallets)
wallets = [w for w in wallets if target.lower() not in w["address"].lower() and target.lower() != w["label"].lower()]
after = len(wallets)

with open(wallets_file, "w") as f:
    json.dump(wallets, f, indent=2)

removed = before - after
if removed > 0:
    print("Removed {} wallet(s). {} remaining.".format(removed, after))
else:
    print("No matching wallet found for: {}".format(target))
PYEOF
    ;;

  history)
    python3 << 'PYEOF'
import json, os, glob

data_dir = os.path.expanduser("~/.wallet-tracker")
snapshots = sorted(glob.glob(os.path.join(data_dir, "snapshot-*.json")))

if not snapshots:
    print("No snapshots found. Run 'bash wallet.sh check' first.")
    exit(0)

print("=" * 50)
print("WALLET SNAPSHOTS")
print("=" * 50)
print("")
for snap_file in snapshots[-10:]:
    with open(snap_file, "r") as f:
        snap = json.load(f)
    ts = snap.get("timestamp", "?")
    wallets = snap.get("wallets", [])
    print("{} — {} wallets".format(ts, len(wallets)))
    for w in wallets:
        if w.get("balance") is not None:
            print("  {}: {:.4f} {} ({})".format(w["label"], w["balance"], w["native"], w["chain"]))
    print("")

if len(snapshots) > 10:
    print("... {} more snapshots".format(len(snapshots) - 10))
PYEOF
    ;;

  export)
    FORMAT="${1:-json}"
    export WALLET_FORMAT="$FORMAT"

    python3 << 'PYEOF'
import json, os, csv, sys

data_dir = os.path.expanduser("~/.wallet-tracker")
fmt = os.environ.get("WALLET_FORMAT", "json")
wallets_file = os.path.join(data_dir, "wallets.json")

if not os.path.exists(wallets_file):
    print("No wallets to export.")
    sys.exit(0)

with open(wallets_file, "r") as f:
    wallets = json.load(f)

if fmt == "csv":
    out_file = os.path.join(data_dir, "wallets-export.csv")
    with open(out_file, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=["label", "chain", "address", "added"])
        writer.writeheader()
        writer.writerows(wallets)
    print("Exported {} wallets to {}".format(len(wallets), out_file))
else:
    out_file = os.path.join(data_dir, "wallets-export.json")
    with open(out_file, "w") as f:
        json.dump(wallets, f, indent=2)
    print("Exported {} wallets to {}".format(len(wallets), out_file))
PYEOF
    ;;

  help|*)
    cat << 'HELPEOF'
Wallet Tracker — Monitor multiple crypto wallets across chains

COMMANDS:
  add <address> [chain] [label]
         Add a wallet to track

  list
         List all tracked wallets

  check [address_or_label]
         Check balances (all or specific wallet)

  remove <address_or_label>
         Remove a tracked wallet

  history
         View balance snapshots over time

  export [format]
         Export wallet list (json|csv)

SUPPORTED CHAINS:
  ethereum, bsc, polygon, arbitrum, base, optimism, avalanche, solana

ENV VARS:
  ETHERSCAN_API_KEY — For EVM chain balance queries (free tier available)

EXAMPLES:
  bash wallet.sh add 0x1234...abcd ethereum main-wallet
  bash wallet.sh add 5Yz3...sol solana hot-wallet
  bash wallet.sh check
  bash wallet.sh history
  bash wallet.sh export csv
HELPEOF
    ;;
esac

echo ""
echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
