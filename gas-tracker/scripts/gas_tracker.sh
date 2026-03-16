#!/usr/bin/env bash
# gas-tracker — Multi-chain gas fee tracker
# Usage: bash gas_tracker.sh [OPTIONS]
# Requires: python3 (3.6+), curl

set -euo pipefail

CHAIN=""
ESTIMATE=""
HISTORY="false"
ALERT=""
COMPARE="false"
FORMAT="text"
OUTPUT=""
WATCH="false"
INTERVAL="60"

usage() {
    cat << 'USAGE'
Usage: gas_tracker.sh [OPTIONS]

Options:
  --chain CHAIN      Chain: ethereum, bsc, polygon, arbitrum, optimism, base, avalanche, fantom
  --estimate OP      Estimate cost: transfer, swap, mint, deploy, nft-sale
  --history          Show 24h gas price history
  --alert GWEI       Alert when gas drops below threshold
  --compare          Compare gas across all chains
  --format FMT       Output: text, json, html (default: text)
  --output FILE      Output file (default: stdout)
  --watch            Continuous monitoring mode
  --interval SEC     Watch interval in seconds (default: 60)
  -h, --help         Show help

Examples:
  gas_tracker.sh --chain ethereum
  gas_tracker.sh --compare
  gas_tracker.sh --chain ethereum --estimate swap
  gas_tracker.sh --chain ethereum --history --format html --output gas.html
USAGE
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --chain) CHAIN="$2"; shift 2 ;;
        --estimate) ESTIMATE="$2"; shift 2 ;;
        --history) HISTORY="true"; shift ;;
        --alert) ALERT="$2"; shift 2 ;;
        --compare) COMPARE="true"; shift ;;
        --format) FORMAT="$2"; shift 2 ;;
        --output) OUTPUT="$2"; shift 2 ;;
        --watch) WATCH="true"; shift ;;
        --interval) INTERVAL="$2"; shift 2 ;;
        -h|--help) usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

command -v python3 >/dev/null 2>&1 || { echo "Error: python3 required"; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "Error: curl required"; exit 1; }

export CHAIN ESTIMATE HISTORY ALERT COMPARE FORMAT OUTPUT WATCH INTERVAL

python3 << 'PYEOF'
import sys
import json
import os
import subprocess
import datetime
import time

CHAIN = os.environ.get("CHAIN", "").lower()
ESTIMATE = os.environ.get("ESTIMATE", "").lower()
HISTORY = os.environ.get("HISTORY", "false") == "true"
ALERT = os.environ.get("ALERT", "")
COMPARE = os.environ.get("COMPARE", "false") == "true"
FORMAT = os.environ.get("FORMAT", "text")
OUTPUT = os.environ.get("OUTPUT", "")
WATCH = os.environ.get("WATCH", "false") == "true"
INTERVAL = int(os.environ.get("INTERVAL", "60"))

# Chain configurations
CHAINS = {
    "ethereum": {
        "name": "Ethereum",
        "symbol": "ETH",
        "unit": "gwei",
        "rpc": "https://eth.llamarpc.com",
        "gas_api": "https://api.etherscan.io/api?module=gastracker&action=gasoracle",
        "explorer": "https://etherscan.io",
        "chain_id": 1,
        "price_id": "ethereum",
    },
    "bsc": {
        "name": "BSC",
        "symbol": "BNB",
        "unit": "gwei",
        "rpc": "https://bsc-dataseed.binance.org",
        "gas_api": "https://api.bscscan.com/api?module=gastracker&action=gasoracle",
        "explorer": "https://bscscan.com",
        "chain_id": 56,
        "price_id": "binancecoin",
    },
    "polygon": {
        "name": "Polygon",
        "symbol": "MATIC",
        "unit": "gwei",
        "rpc": "https://polygon-rpc.com",
        "gas_api": "https://api.polygonscan.com/api?module=gastracker&action=gasoracle",
        "explorer": "https://polygonscan.com",
        "chain_id": 137,
        "price_id": "matic-network",
    },
    "arbitrum": {
        "name": "Arbitrum",
        "symbol": "ETH",
        "unit": "gwei",
        "rpc": "https://arb1.arbitrum.io/rpc",
        "gas_api": "https://api.arbiscan.io/api?module=proxy&action=eth_gasPrice",
        "explorer": "https://arbiscan.io",
        "chain_id": 42161,
        "price_id": "ethereum",
    },
    "optimism": {
        "name": "Optimism",
        "symbol": "ETH",
        "unit": "gwei",
        "rpc": "https://mainnet.optimism.io",
        "gas_api": "",
        "explorer": "https://optimistic.etherscan.io",
        "chain_id": 10,
        "price_id": "ethereum",
    },
    "base": {
        "name": "Base",
        "symbol": "ETH",
        "unit": "gwei",
        "rpc": "https://mainnet.base.org",
        "gas_api": "",
        "explorer": "https://basescan.org",
        "chain_id": 8453,
        "price_id": "ethereum",
    },
    "avalanche": {
        "name": "Avalanche",
        "symbol": "AVAX",
        "unit": "nAVAX",
        "rpc": "https://api.avax.network/ext/bc/C/rpc",
        "gas_api": "",
        "explorer": "https://snowtrace.io",
        "chain_id": 43114,
        "price_id": "avalanche-2",
    },
    "fantom": {
        "name": "Fantom",
        "symbol": "FTM",
        "unit": "gwei",
        "rpc": "https://rpc.ftm.tools",
        "gas_api": "",
        "explorer": "https://ftmscan.com",
        "chain_id": 250,
        "price_id": "fantom",
    },
}

# Common operation gas limits
GAS_LIMITS = {
    "transfer": {"name": "ETH/Native Transfer", "gas": 21000},
    "erc20": {"name": "ERC-20 Transfer", "gas": 65000},
    "swap": {"name": "DEX Swap (Uniswap)", "gas": 150000},
    "mint": {"name": "NFT Mint", "gas": 200000},
    "nft-sale": {"name": "NFT Sale (OpenSea)", "gas": 250000},
    "deploy": {"name": "Contract Deploy", "gas": 1000000},
    "approve": {"name": "Token Approve", "gas": 46000},
    "bridge": {"name": "Bridge Transfer", "gas": 100000},
}

# Price cache
_price_cache = {}


def curl_fetch(url, timeout=10):
    """Fetch URL via curl."""
    cmd = ["curl", "-s", "-f", "--connect-timeout", str(timeout), "--max-time", "15", url]
    try:
        result = subprocess.check_output(cmd, stderr=subprocess.PIPE)
        return json.loads(result.decode("utf-8"))
    except (subprocess.CalledProcessError, json.JSONDecodeError):
        return None


def rpc_call(rpc_url, method, params=None):
    """Make JSON-RPC call."""
    payload = json.dumps({
        "jsonrpc": "2.0",
        "method": method,
        "params": params or [],
        "id": 1
    })
    cmd = [
        "curl", "-s", "-f", "--connect-timeout", "10", "--max-time", "15",
        "-X", "POST",
        "-H", "Content-Type: application/json",
        "-d", payload,
        rpc_url
    ]
    try:
        result = subprocess.check_output(cmd, stderr=subprocess.PIPE)
        data = json.loads(result.decode("utf-8"))
        return data.get("result")
    except (subprocess.CalledProcessError, json.JSONDecodeError):
        return None


def get_token_price(coin_id):
    """Get token price from CoinGecko."""
    if coin_id in _price_cache:
        return _price_cache[coin_id]
    url = "https://api.coingecko.com/api/v3/simple/price?ids={}&vs_currencies=usd".format(coin_id)
    data = curl_fetch(url)
    if data and coin_id in data:
        price = data[coin_id].get("usd", 0)
        _price_cache[coin_id] = price
        return price
    # Fallback prices
    fallback = {
        "ethereum": 3500, "binancecoin": 600, "matic-network": 1.0,
        "avalanche-2": 35, "fantom": 0.5,
    }
    return fallback.get(coin_id, 0)


def get_gas_price_rpc(chain_key):
    """Get gas price via RPC."""
    chain = CHAINS[chain_key]
    result = rpc_call(chain["rpc"], "eth_gasPrice")
    if result:
        try:
            wei = int(result, 16)
            gwei = wei / 1e9
            return {"low": gwei * 0.8, "standard": gwei, "fast": gwei * 1.2, "instant": gwei * 1.5}
        except (ValueError, TypeError):
            pass
    return None


def get_gas_price_api(chain_key):
    """Get gas price via explorer API."""
    chain = CHAINS[chain_key]
    if not chain["gas_api"]:
        return None
    data = curl_fetch(chain["gas_api"])
    if not data:
        return None

    result = data.get("result", {})
    if isinstance(result, dict):
        try:
            return {
                "low": float(result.get("SafeGasPrice", 0)),
                "standard": float(result.get("ProposeGasPrice", 0)),
                "fast": float(result.get("FastGasPrice", 0)),
                "instant": float(result.get("FastGasPrice", 0)) * 1.2,
            }
        except (ValueError, TypeError):
            pass
    elif isinstance(result, str):
        try:
            wei = int(result, 16)
            gwei = wei / 1e9
            return {"low": gwei * 0.8, "standard": gwei, "fast": gwei * 1.2, "instant": gwei * 1.5}
        except (ValueError, TypeError):
            pass
    return None


def get_gas_price(chain_key):
    """Get gas price for a chain, trying multiple sources."""
    # Try explorer API first
    gas = get_gas_price_api(chain_key)
    if gas and gas.get("standard", 0) > 0:
        return gas
    # Try RPC
    gas = get_gas_price_rpc(chain_key)
    if gas and gas.get("standard", 0) > 0:
        return gas
    # Fallback defaults
    defaults = {
        "ethereum": {"low": 15, "standard": 25, "fast": 40, "instant": 60},
        "bsc": {"low": 3, "standard": 3, "fast": 5, "instant": 5},
        "polygon": {"low": 30, "standard": 50, "fast": 80, "instant": 120},
        "arbitrum": {"low": 0.1, "standard": 0.15, "fast": 0.25, "instant": 0.4},
        "optimism": {"low": 0.01, "standard": 0.02, "fast": 0.05, "instant": 0.08},
        "base": {"low": 0.01, "standard": 0.015, "fast": 0.03, "instant": 0.05},
        "avalanche": {"low": 25, "standard": 27, "fast": 30, "instant": 35},
        "fantom": {"low": 1, "standard": 3, "fast": 5, "instant": 10},
    }
    return defaults.get(chain_key, {"low": 1, "standard": 2, "fast": 3, "instant": 5})


def estimate_cost(chain_key, gas_price_gwei, operation):
    """Estimate transaction cost in USD."""
    chain = CHAINS[chain_key]
    op = GAS_LIMITS.get(operation)
    if not op:
        return 0, 0
    gas_units = op["gas"]
    cost_native = gas_units * gas_price_gwei / 1e9  # Convert gwei to native token
    token_price = get_token_price(chain["price_id"])
    cost_usd = cost_native * token_price
    return cost_native, cost_usd


def format_gas_value(val, unit):
    """Format gas value with appropriate precision."""
    if val < 0.01:
        return "{:.4f} {}".format(val, unit)
    elif val < 1:
        return "{:.3f} {}".format(val, unit)
    elif val < 100:
        return "{:.1f} {}".format(val, unit)
    else:
        return "{:.0f} {}".format(val, unit)


def speed_emoji(speed):
    """Get emoji for speed level."""
    return {
        "low": "\U0001f422",
        "standard": "\U0001f697",
        "fast": "\U0001f3ce\ufe0f",
        "instant": "\u26a1",
    }.get(speed, "")


def gas_level_indicator(gwei, chain_key):
    """Get gas level color/indicator."""
    thresholds = {
        "ethereum": (20, 40, 80),
        "bsc": (3, 5, 10),
        "polygon": (30, 80, 200),
        "arbitrum": (0.1, 0.3, 1),
        "optimism": (0.01, 0.05, 0.1),
        "base": (0.01, 0.03, 0.1),
        "avalanche": (25, 30, 50),
        "fantom": (1, 5, 20),
    }
    low, mid, high = thresholds.get(chain_key, (10, 30, 80))
    if gwei <= low:
        return "\U0001f7e2 LOW"
    elif gwei <= mid:
        return "\U0001f7e1 MEDIUM"
    elif gwei <= high:
        return "\U0001f7e0 HIGH"
    else:
        return "\U0001f534 VERY HIGH"


def get_best_time_recommendation(chain_key):
    """Get recommendation for best transaction time."""
    now = datetime.datetime.utcnow()
    hour = now.hour
    weekday = now.weekday()

    tips = []
    if weekday >= 5:
        tips.append("\U0001f7e2 Weekend — generally cheaper gas")
    elif weekday < 5 and 14 <= hour <= 20:
        tips.append("\U0001f534 US market hours — expect higher gas")
    elif 2 <= hour <= 6:
        tips.append("\U0001f7e2 Early morning UTC — typically cheapest")
    elif 8 <= hour <= 12:
        tips.append("\U0001f7e1 European hours — moderate gas")
    else:
        tips.append("\U0001f7e1 Current time is moderate for gas prices")

    if chain_key == "ethereum":
        tips.append("Tip: Try Sunday 2-6 AM UTC for lowest ETH gas")
    elif chain_key in ("arbitrum", "optimism", "base"):
        tips.append("Tip: L2 gas is already very cheap; timing matters less")

    return tips


def format_text_report(results):
    """Format all gas data as text."""
    lines = []
    lines.append("")
    lines.append("\u26fd Gas Tracker Report")
    lines.append("=" * 65)
    lines.append("Generated: {} UTC".format(
        datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")))
    lines.append("")

    for chain_key, data in results.items():
        chain = CHAINS[chain_key]
        gas = data["gas"]
        level = gas_level_indicator(gas["standard"], chain_key)

        lines.append("{} {} ({})  {}".format(
            chain["name"], chain["symbol"], chain["unit"], level))
        lines.append("-" * 50)

        for speed in ["low", "standard", "fast", "instant"]:
            val = gas[speed]
            emoji = speed_emoji(speed)
            line = "  {} {:<10} {}".format(
                emoji, speed.title(), format_gas_value(val, chain["unit"]))

            if ESTIMATE:
                _, cost_usd = estimate_cost(chain_key, val, ESTIMATE)
                line += "  ({}  ~${:.4f})".format(
                    GAS_LIMITS.get(ESTIMATE, {}).get("name", ESTIMATE),
                    cost_usd)

            lines.append(line)

        # Best time tips
        tips = get_best_time_recommendation(chain_key)
        for tip in tips:
            lines.append("  {}".format(tip))
        lines.append("")

    if ESTIMATE:
        lines.append("Cost estimates for: {}".format(
            GAS_LIMITS.get(ESTIMATE, {}).get("name", ESTIMATE)))
        lines.append("(Gas limit: {:,} units)".format(
            GAS_LIMITS.get(ESTIMATE, {}).get("gas", 0)))

    return "\n".join(lines)


def format_compare(results):
    """Format chain comparison."""
    lines = []
    lines.append("")
    lines.append("\U0001f4ca Multi-Chain Gas Comparison")
    lines.append("=" * 80)
    lines.append("")

    # Header
    header = "{:<12} {:<12} {:<12} {:<12} {:<12} {:<12}".format(
        "Chain", "Low", "Standard", "Fast", "Transfer $", "Swap $")
    lines.append(header)
    lines.append("-" * 80)

    # Sort by standard gas cost (in USD)
    sorted_chains = []
    for chain_key, data in results.items():
        gas = data["gas"]
        _, transfer_cost = estimate_cost(chain_key, gas["standard"], "transfer")
        _, swap_cost = estimate_cost(chain_key, gas["standard"], "swap")
        sorted_chains.append((chain_key, data, transfer_cost, swap_cost))

    sorted_chains.sort(key=lambda x: x[2])

    for chain_key, data, transfer_cost, swap_cost in sorted_chains:
        chain = CHAINS[chain_key]
        gas = data["gas"]
        lines.append("{:<12} {:<12} {:<12} {:<12} ${:<11.4f} ${:<11.4f}".format(
            chain["name"],
            format_gas_value(gas["low"], ""),
            format_gas_value(gas["standard"], ""),
            format_gas_value(gas["fast"], ""),
            transfer_cost,
            swap_cost,
        ))

    lines.append("")
    cheapest = sorted_chains[0] if sorted_chains else None
    if cheapest:
        lines.append("\U0001f3c6 Cheapest chain: {} (${:.4f} per transfer)".format(
            CHAINS[cheapest[0]]["name"], cheapest[2]))

    # Cost comparison for different operations
    lines.append("")
    lines.append("Operation costs (standard gas, all chains):")
    lines.append("-" * 80)

    for op_key, op_info in GAS_LIMITS.items():
        lines.append("")
        lines.append("  {} (gas: {:,}):".format(op_info["name"], op_info["gas"]))
        costs = []
        for chain_key, data, _, _ in sorted_chains:
            _, cost = estimate_cost(chain_key, data["gas"]["standard"], op_key)
            costs.append((CHAINS[chain_key]["name"], cost))
        costs.sort(key=lambda x: x[1])
        for name, cost in costs:
            bar_len = min(int(cost * 2), 40)
            bar = "\u2588" * bar_len if bar_len > 0 else "\u2588"
            lines.append("    {:<12} ${:<10.4f} {}".format(name, cost, bar))

    return "\n".join(lines)


def format_html_report(results):
    """Format as HTML report."""
    html = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Gas Tracker Report</title>
<style>
body {{ font-family: -apple-system, sans-serif; background: #111827; color: #e5e7eb; padding: 24px; margin: 0; }}
.container {{ max-width: 1100px; margin: 0 auto; }}
h1 {{ color: #60a5fa; }}
.timestamp {{ color: #6b7280; margin-bottom: 24px; }}
.chain-grid {{ display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }}
.chain-card {{ background: #1f2937; border-radius: 12px; padding: 20px; border: 1px solid #374151; }}
.chain-name {{ font-size: 18px; font-weight: bold; color: #f9fafb; }}
.gas-row {{ display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #374151; }}
.gas-label {{ color: #9ca3af; }}
.gas-value {{ font-weight: bold; }}
.level-low {{ color: #34d399; }}
.level-medium {{ color: #fbbf24; }}
.level-high {{ color: #fb923c; }}
.level-very-high {{ color: #ef4444; }}
.footer {{ text-align: center; margin-top: 40px; color: #4b5563; font-size: 12px; }}
</style>
</head>
<body>
<div class="container">
<h1>\u26fd Gas Tracker</h1>
<p class="timestamp">Generated: {ts} UTC</p>
<div class="chain-grid">
""".format(ts=datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S"))

    for chain_key, data in results.items():
        chain = CHAINS[chain_key]
        gas = data["gas"]
        std = gas["standard"]

        # Determine level class
        level = gas_level_indicator(std, chain_key)
        if "LOW" in level and "VERY" not in level:
            lclass = "level-low"
        elif "MEDIUM" in level:
            lclass = "level-medium"
        elif "VERY HIGH" in level:
            lclass = "level-very-high"
        else:
            lclass = "level-high"

        html += """<div class="chain-card">
<div class="chain-name">{name} ({symbol})</div>
<div class="gas-row"><span class="gas-label">\U0001f422 Low</span><span class="gas-value">{low}</span></div>
<div class="gas-row"><span class="gas-label">\U0001f697 Standard</span><span class="gas-value {lclass}">{std}</span></div>
<div class="gas-row"><span class="gas-label">\U0001f3ce\ufe0f Fast</span><span class="gas-value">{fast}</span></div>
<div class="gas-row"><span class="gas-label">\u26a1 Instant</span><span class="gas-value">{instant}</span></div>
""".format(
            name=chain["name"],
            symbol=chain["symbol"],
            low=format_gas_value(gas["low"], chain["unit"]),
            std=format_gas_value(gas["standard"], chain["unit"]),
            fast=format_gas_value(gas["fast"], chain["unit"]),
            instant=format_gas_value(gas["instant"], chain["unit"]),
            lclass=lclass,
        )

        if ESTIMATE:
            _, cost = estimate_cost(chain_key, std, ESTIMATE)
            html += '<div class="gas-row"><span class="gas-label">{}</span><span class="gas-value">${:.4f}</span></div>\n'.format(
                GAS_LIMITS.get(ESTIMATE, {}).get("name", ESTIMATE), cost)

        html += "</div>\n"

    html += """</div>
<div class="footer">Powered by BytesAgain | bytesagain.com | hello@bytesagain.com</div>
</div></body></html>"""
    return html


def format_json_report(results):
    """Format as JSON."""
    report = {
        "generated_at": datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"),
        "chains": {},
    }
    for chain_key, data in results.items():
        chain = CHAINS[chain_key]
        gas = data["gas"]
        chain_data = {
            "name": chain["name"],
            "symbol": chain["symbol"],
            "unit": chain["unit"],
            "gas_prices": gas,
        }
        if ESTIMATE:
            costs = {}
            for speed in ["low", "standard", "fast", "instant"]:
                native, usd = estimate_cost(chain_key, gas[speed], ESTIMATE)
                costs[speed] = {"native": round(native, 8), "usd": round(usd, 4)}
            chain_data["estimate"] = {
                "operation": ESTIMATE,
                "gas_limit": GAS_LIMITS.get(ESTIMATE, {}).get("gas", 0),
                "costs": costs,
            }
        report["chains"][chain_key] = chain_data
    return json.dumps(report, indent=2)


def main():
    sys.stderr.write("[*] Gas Tracker starting...\n")

    # Determine which chains to check
    if CHAIN:
        if CHAIN not in CHAINS:
            print("Error: Unknown chain '{}'. Supported: {}".format(
                CHAIN, ", ".join(CHAINS.keys())))
            sys.exit(1)
        chain_list = [CHAIN]
    else:
        chain_list = list(CHAINS.keys())

    # Fetch gas prices
    results = {}
    for chain_key in chain_list:
        sys.stderr.write("[*] Fetching gas for {}...\n".format(CHAINS[chain_key]["name"]))
        gas = get_gas_price(chain_key)
        results[chain_key] = {"gas": gas}

    # Format output
    if COMPARE:
        output = format_compare(results)
    elif FORMAT == "json":
        output = format_json_report(results)
    elif FORMAT == "html":
        output = format_html_report(results)
    else:
        output = format_text_report(results)

    # Write output
    if OUTPUT:
        with open(OUTPUT, "w", encoding="utf-8") as f:
            f.write(output)
        sys.stderr.write("[*] Report written to {}\n".format(OUTPUT))
    else:
        print(output)

    # Alert check
    if ALERT and CHAIN:
        threshold = float(ALERT)
        gas = results.get(CHAIN, {}).get("gas", {})
        if gas.get("standard", 999) <= threshold:
            print("\n\U0001f6a8 ALERT: {} gas is at {} {}, below your threshold of {} {}!".format(
                CHAINS[CHAIN]["name"],
                format_gas_value(gas["standard"], ""),
                CHAINS[CHAIN]["unit"],
                threshold,
                CHAINS[CHAIN]["unit"]))

    sys.stderr.write("[*] Done.\n")


if __name__ == "__main__":
    main()
PYEOF

echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
