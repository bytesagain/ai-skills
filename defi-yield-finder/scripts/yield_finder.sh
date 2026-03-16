#!/usr/bin/env bash
# defi-yield-finder — Search DeFi yields using DeFiLlama API
# Usage: bash yield_finder.sh [OPTIONS]
# Requires: python3 (3.6+), curl

set -euo pipefail

CHAIN=""
PROTOCOL=""
MIN_APY="0"
MAX_APY="10000"
MIN_TVL="0"
STABLECOIN="false"
RISK=""
TOP="20"
SORT="apy"
FORMAT="text"
OUTPUT=""
COMPARE=""

usage() {
    cat << 'USAGE'
Usage: yield_finder.sh [OPTIONS]

Options:
  --chain CHAIN        Filter by blockchain (ethereum, bsc, polygon, arbitrum, etc.)
  --protocol NAME      Filter by protocol name
  --min-apy NUM        Minimum APY percentage (default: 0)
  --max-apy NUM        Maximum APY percentage (default: 10000)
  --min-tvl NUM        Minimum TVL in USD (default: 0)
  --stablecoin         Only show stablecoin pools
  --risk LEVEL         Risk filter: low, medium, high, degen
  --top NUM            Number of results (default: 20)
  --sort FIELD         Sort by: apy, tvl, risk (default: apy)
  --format FMT         Output: text, json, csv, html (default: text)
  --output FILE        Output file (default: stdout)
  --compare PROTOS     Compare protocols (comma-separated)
  -h, --help           Show help

Examples:
  yield_finder.sh --chain ethereum --min-apy 10 --min-tvl 1000000
  yield_finder.sh --stablecoin --risk low --top 10
  yield_finder.sh --compare "aave,compound,morpho" --format html --output compare.html
USAGE
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --chain) CHAIN="$2"; shift 2 ;;
        --protocol) PROTOCOL="$2"; shift 2 ;;
        --min-apy) MIN_APY="$2"; shift 2 ;;
        --max-apy) MAX_APY="$2"; shift 2 ;;
        --min-tvl) MIN_TVL="$2"; shift 2 ;;
        --stablecoin) STABLECOIN="true"; shift ;;
        --risk) RISK="$2"; shift 2 ;;
        --top) TOP="$2"; shift 2 ;;
        --sort) SORT="$2"; shift 2 ;;
        --format) FORMAT="$2"; shift 2 ;;
        --output) OUTPUT="$2"; shift 2 ;;
        --compare) COMPARE="$2"; shift 2 ;;
        -h|--help) usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

command -v python3 >/dev/null 2>&1 || { echo "Error: python3 required"; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "Error: curl required"; exit 1; }

export CHAIN PROTOCOL MIN_APY MAX_APY MIN_TVL STABLECOIN RISK TOP SORT FORMAT OUTPUT COMPARE

python3 << 'PYEOF'
import sys
import json
import os
import subprocess
import datetime
import time

# Config from env
CHAIN = os.environ.get("CHAIN", "").lower()
PROTOCOL = os.environ.get("PROTOCOL", "").lower()
MIN_APY = float(os.environ.get("MIN_APY", "0"))
MAX_APY = float(os.environ.get("MAX_APY", "10000"))
MIN_TVL = float(os.environ.get("MIN_TVL", "0"))
STABLECOIN = os.environ.get("STABLECOIN", "false") == "true"
RISK = os.environ.get("RISK", "").lower()
TOP = int(os.environ.get("TOP", "20"))
SORT = os.environ.get("SORT", "apy")
FORMAT = os.environ.get("FORMAT", "text")
OUTPUT = os.environ.get("OUTPUT", "")
COMPARE = os.environ.get("COMPARE", "")

# Stablecoin tokens for detection
STABLECOINS = {
    "usdt", "usdc", "dai", "busd", "frax", "tusd", "usdp",
    "lusd", "susd", "gusd", "eur", "usdd", "crvusd", "gho",
    "pyusd", "eusd", "mkusd", "dola", "alusd",
}

# Well-known audited protocols
AUDITED_PROTOCOLS = {
    "aave", "compound", "makerdao", "lido", "curve", "convex",
    "uniswap", "sushiswap", "yearn", "balancer", "morpho",
    "spark", "frax", "instadapp", "euler", "benqi", "venus",
    "rocketpool", "pancakeswap", "trader-joe", "gmx", "stargate",
    "pendle", "radiant", "aerodrome",
}

# Protocol launch dates (approximate years)
PROTOCOL_AGES = {
    "aave": 2020, "compound": 2018, "makerdao": 2017, "lido": 2020,
    "curve": 2020, "convex": 2021, "uniswap": 2018, "sushiswap": 2020,
    "yearn": 2020, "balancer": 2020, "pancakeswap": 2020,
    "gmx": 2021, "stargate": 2022, "pendle": 2021, "morpho": 2022,
    "radiant": 2022, "aerodrome": 2023,
}


def curl_fetch(url):
    """Fetch URL content via curl."""
    cmd = ["curl", "-s", "-f", "--connect-timeout", "15", "--max-time", "60", url]
    try:
        result = subprocess.check_output(cmd, stderr=subprocess.PIPE)
        return json.loads(result.decode("utf-8"))
    except (subprocess.CalledProcessError, json.JSONDecodeError):
        return None


def fetch_pools():
    """Fetch all yield pools from DeFiLlama."""
    sys.stderr.write("[*] Fetching yield pools from DeFiLlama...\n")
    data = curl_fetch("https://yields.llama.fi/pools")
    if data and "data" in data:
        sys.stderr.write("[*] Fetched {} pools\n".format(len(data["data"])))
        return data["data"]
    sys.stderr.write("[!] Failed to fetch from DeFiLlama\n")
    return []


def fetch_protocols():
    """Fetch protocol list from DeFiLlama."""
    data = curl_fetch("https://api.llama.fi/protocols")
    if data:
        return {p.get("slug", "").lower(): p for p in data if isinstance(p, dict)}
    return {}


def is_stablecoin_pool(pool):
    """Check if a pool contains only stablecoins."""
    symbol = pool.get("symbol", "").lower()
    parts = [s.strip() for s in symbol.replace("/", "-").replace("+", "-").split("-")]
    if not parts:
        return False
    return all(any(stable in p for stable in STABLECOINS) for p in parts if p)


def assess_risk(pool, protocol_info=None):
    """Assess risk level of a pool."""
    tvl = pool.get("tvlUsd", 0) or 0
    apy = pool.get("apy", 0) or 0
    project = pool.get("project", "").lower()
    il_risk = pool.get("ilRisk", "no")
    is_stable = is_stablecoin_pool(pool)

    score = 0  # Lower is safer

    # TVL scoring
    if tvl > 100_000_000:
        score += 0
    elif tvl > 10_000_000:
        score += 1
    elif tvl > 1_000_000:
        score += 2
    elif tvl > 100_000:
        score += 3
    else:
        score += 5

    # Protocol reputation
    if project in AUDITED_PROTOCOLS:
        score += 0
    else:
        score += 2

    # Protocol age
    launch_year = PROTOCOL_AGES.get(project, 2024)
    age = 2025 - launch_year
    if age >= 3:
        score += 0
    elif age >= 1:
        score += 1
    else:
        score += 3

    # IL risk
    if is_stable:
        score += 0
    elif il_risk == "yes" or il_risk == "high":
        score += 3
    else:
        score += 1

    # Suspiciously high APY
    if apy > 1000:
        score += 4
    elif apy > 200:
        score += 2
    elif apy > 50:
        score += 1

    # Map score to level
    if score <= 2:
        return "low"
    elif score <= 5:
        return "medium"
    elif score <= 8:
        return "high"
    else:
        return "degen"


def risk_emoji(level):
    """Get risk level emoji."""
    return {
        "low": "\U0001f7e2",
        "medium": "\U0001f7e1",
        "high": "\U0001f7e0",
        "degen": "\U0001f534",
    }.get(level, "\u26aa")


def format_usd(val):
    """Format USD value."""
    if val >= 1e9:
        return "${:.2f}B".format(val / 1e9)
    elif val >= 1e6:
        return "${:.2f}M".format(val / 1e6)
    elif val >= 1e3:
        return "${:.1f}K".format(val / 1e3)
    else:
        return "${:.0f}".format(val)


def filter_pools(pools):
    """Apply user filters to pools."""
    filtered = []
    for pool in pools:
        apy = pool.get("apy", 0) or 0
        tvl = pool.get("tvlUsd", 0) or 0
        chain = (pool.get("chain", "") or "").lower()
        project = (pool.get("project", "") or "").lower()

        # Basic filters
        if apy < MIN_APY or apy > MAX_APY:
            continue
        if tvl < MIN_TVL:
            continue
        if CHAIN and chain != CHAIN:
            continue
        if PROTOCOL and PROTOCOL not in project:
            continue
        if STABLECOIN and not is_stablecoin_pool(pool):
            continue

        # Assess risk
        pool["_risk"] = assess_risk(pool)

        if RISK and pool["_risk"] != RISK:
            continue

        filtered.append(pool)

    # Sort
    if SORT == "tvl":
        filtered.sort(key=lambda p: p.get("tvlUsd", 0) or 0, reverse=True)
    elif SORT == "risk":
        risk_order = {"low": 0, "medium": 1, "high": 2, "degen": 3}
        filtered.sort(key=lambda p: risk_order.get(p.get("_risk", "degen"), 4))
    else:  # apy
        filtered.sort(key=lambda p: p.get("apy", 0) or 0, reverse=True)

    return filtered[:TOP]


def format_text(pools):
    """Format as text report."""
    lines = []
    lines.append("")
    lines.append("\U0001f4b0 DeFi Yield Finder Report")
    lines.append("=" * 70)
    filters = []
    if CHAIN:
        filters.append("Chain: {}".format(CHAIN.title()))
    if PROTOCOL:
        filters.append("Protocol: {}".format(PROTOCOL))
    if STABLECOIN:
        filters.append("Stablecoins only")
    if RISK:
        filters.append("Risk: {}".format(RISK))
    if MIN_TVL > 0:
        filters.append("Min TVL: {}".format(format_usd(MIN_TVL)))
    if filters:
        lines.append("Filters: {}".format(" | ".join(filters)))
    lines.append("Generated: {} UTC".format(
        datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M")))
    lines.append("")

    header = "{:<4} {:<20} {:<12} {:<15} {:<12} {:<8} {}".format(
        "#", "Protocol", "Chain", "Pool", "APY", "TVL", "Risk")
    lines.append(header)
    lines.append("-" * 80)

    for i, pool in enumerate(pools, 1):
        apy = pool.get("apy", 0) or 0
        tvl = pool.get("tvlUsd", 0) or 0
        risk = pool.get("_risk", "?")
        emoji = risk_emoji(risk)

        symbol = pool.get("symbol", "?")
        if len(symbol) > 14:
            symbol = symbol[:12] + ".."

        project = pool.get("project", "?")
        if len(project) > 18:
            project = project[:16] + ".."

        chain = pool.get("chain", "?")
        if len(chain) > 10:
            chain = chain[:8] + ".."

        lines.append("{:<4} {:<20} {:<12} {:<15} {:<12} {:<8} {} {}".format(
            i, project, chain, symbol,
            "{:.2f}%".format(apy), format_usd(tvl),
            emoji, risk))

    lines.append("")
    lines.append("Total pools found: {}".format(len(pools)))
    avg_apy = sum(p.get("apy", 0) or 0 for p in pools) / len(pools) if pools else 0
    total_tvl = sum(p.get("tvlUsd", 0) or 0 for p in pools)
    lines.append("Average APY: {:.2f}%".format(avg_apy))
    lines.append("Total TVL: {}".format(format_usd(total_tvl)))
    return "\n".join(lines)


def format_json_output(pools):
    """Format as JSON."""
    cleaned = []
    for p in pools:
        cleaned.append({
            "protocol": p.get("project", ""),
            "chain": p.get("chain", ""),
            "symbol": p.get("symbol", ""),
            "apy": round(p.get("apy", 0) or 0, 2),
            "apy_base": round(p.get("apyBase", 0) or 0, 2),
            "apy_reward": round(p.get("apyReward", 0) or 0, 2),
            "tvl_usd": round(p.get("tvlUsd", 0) or 0, 2),
            "risk": p.get("_risk", "unknown"),
            "stablecoin": is_stablecoin_pool(p),
            "pool_id": p.get("pool", ""),
        })
    report = {
        "generated_at": datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"),
        "filters": {
            "chain": CHAIN or "all",
            "protocol": PROTOCOL or "all",
            "min_apy": MIN_APY,
            "max_apy": MAX_APY,
            "min_tvl": MIN_TVL,
            "stablecoin_only": STABLECOIN,
            "risk": RISK or "all",
        },
        "total_results": len(cleaned),
        "pools": cleaned,
    }
    return json.dumps(report, indent=2)


def format_csv_output(pools):
    """Format as CSV."""
    lines = ["protocol,chain,symbol,apy,apy_base,apy_reward,tvl_usd,risk,stablecoin"]
    for p in pools:
        lines.append("{},{},{},{:.2f},{:.2f},{:.2f},{:.0f},{},{}".format(
            p.get("project", ""),
            p.get("chain", ""),
            p.get("symbol", "").replace(",", ";"),
            p.get("apy", 0) or 0,
            p.get("apyBase", 0) or 0,
            p.get("apyReward", 0) or 0,
            p.get("tvlUsd", 0) or 0,
            p.get("_risk", "unknown"),
            is_stablecoin_pool(p),
        ))
    return "\n".join(lines)


def format_html_output(pools):
    """Format as HTML report."""
    avg_apy = sum(p.get("apy", 0) or 0 for p in pools) / len(pools) if pools else 0
    total_tvl = sum(p.get("tvlUsd", 0) or 0 for p in pools)

    html = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>DeFi Yield Report</title>
<style>
* {{ margin: 0; padding: 0; box-sizing: border-box; }}
body {{ font-family: 'Inter', -apple-system, sans-serif; background: #0f0f1a; color: #e0e0e0; padding: 24px; }}
.container {{ max-width: 1200px; margin: 0 auto; }}
h1 {{ color: #00d4aa; margin-bottom: 8px; }}
.subtitle {{ color: #888; margin-bottom: 24px; }}
.grid {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 16px; margin: 24px 0; }}
.card {{ background: #1a1a2e; border-radius: 12px; padding: 20px; border: 1px solid #2a2a4a; }}
.card-label {{ color: #888; font-size: 12px; text-transform: uppercase; letter-spacing: 1px; }}
.card-value {{ font-size: 28px; font-weight: bold; color: #fff; margin-top: 8px; }}
.card-value.green {{ color: #00d4aa; }}
table {{ width: 100%; border-collapse: collapse; margin: 24px 0; }}
th {{ background: #1a1a2e; color: #888; padding: 12px 16px; text-align: left; font-size: 12px; text-transform: uppercase; letter-spacing: 1px; }}
td {{ padding: 12px 16px; border-bottom: 1px solid #1a1a2e; }}
tr:hover {{ background: #1a1a2e; }}
.risk-low {{ color: #00d4aa; }}
.risk-medium {{ color: #f0c040; }}
.risk-high {{ color: #f08040; }}
.risk-degen {{ color: #f04040; }}
.apy {{ color: #00d4aa; font-weight: bold; }}
.footer {{ text-align: center; color: #555; margin-top: 40px; padding: 20px; font-size: 12px; }}
</style>
</head>
<body>
<div class="container">
<h1>\U0001f4b0 DeFi Yield Report</h1>
<p class="subtitle">Generated: {ts} UTC | Pools: {count} | Avg APY: {avg_apy:.2f}%</p>

<div class="grid">
<div class="card">
  <div class="card-label">Pools Found</div>
  <div class="card-value">{count}</div>
</div>
<div class="card">
  <div class="card-label">Avg APY</div>
  <div class="card-value green">{avg_apy:.1f}%</div>
</div>
<div class="card">
  <div class="card-label">Total TVL</div>
  <div class="card-value">{total_tvl}</div>
</div>
<div class="card">
  <div class="card-label">Best Yield</div>
  <div class="card-value green">{best_apy:.1f}%</div>
</div>
</div>

<table>
<thead>
<tr><th>#</th><th>Protocol</th><th>Chain</th><th>Pool</th><th>APY</th><th>Base APY</th><th>Reward APY</th><th>TVL</th><th>Risk</th></tr>
</thead>
<tbody>
""".format(
        ts=datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M"),
        count=len(pools),
        avg_apy=avg_apy,
        total_tvl=format_usd(total_tvl),
        best_apy=max((p.get("apy", 0) or 0 for p in pools), default=0),
    )

    for i, p in enumerate(pools, 1):
        apy = p.get("apy", 0) or 0
        base_apy = p.get("apyBase", 0) or 0
        reward_apy = p.get("apyReward", 0) or 0
        tvl = p.get("tvlUsd", 0) or 0
        risk = p.get("_risk", "unknown")

        html += """<tr>
<td>{i}</td>
<td>{project}</td>
<td>{chain}</td>
<td>{symbol}</td>
<td class="apy">{apy:.2f}%</td>
<td>{base:.2f}%</td>
<td>{reward:.2f}%</td>
<td>{tvl}</td>
<td class="risk-{risk}">{risk_upper}</td>
</tr>
""".format(
            i=i,
            project=p.get("project", "?"),
            chain=p.get("chain", "?"),
            symbol=p.get("symbol", "?"),
            apy=apy,
            base=base_apy,
            reward=reward_apy,
            tvl=format_usd(tvl),
            risk=risk,
            risk_upper=risk.upper(),
        )

    html += """</tbody></table>
<div class="footer">Powered by BytesAgain | bytesagain.com | hello@bytesagain.com<br>Data: DeFiLlama API</div>
</div></body></html>"""
    return html


def compare_protocols(pools, protocol_names):
    """Compare specific protocols side by side."""
    names = [n.strip().lower() for n in protocol_names.split(",")]
    lines = []
    lines.append("\n\U0001f4ca Protocol Comparison")
    lines.append("=" * 70)

    for name in names:
        proto_pools = [p for p in pools if name in p.get("project", "").lower()]
        if not proto_pools:
            lines.append("\n{}: No pools found".format(name.title()))
            continue

        apys = [p.get("apy", 0) or 0 for p in proto_pools]
        tvls = [p.get("tvlUsd", 0) or 0 for p in proto_pools]

        lines.append("\n{} ({} pools)".format(name.title(), len(proto_pools)))
        lines.append("  APY range: {:.2f}% - {:.2f}%".format(min(apys), max(apys)))
        lines.append("  Avg APY:   {:.2f}%".format(sum(apys) / len(apys)))
        lines.append("  Total TVL: {}".format(format_usd(sum(tvls))))
        lines.append("  Chains:    {}".format(
            ", ".join(set(p.get("chain", "?") for p in proto_pools))))

        # Top 3 pools
        proto_pools.sort(key=lambda p: p.get("apy", 0) or 0, reverse=True)
        lines.append("  Top pools:")
        for p in proto_pools[:3]:
            lines.append("    - {} {:.2f}% APY (TVL: {})".format(
                p.get("symbol", "?"),
                p.get("apy", 0) or 0,
                format_usd(p.get("tvlUsd", 0) or 0)))

    return "\n".join(lines)


def main():
    sys.stderr.write("[*] DeFi Yield Finder starting...\n")

    pools = fetch_pools()
    if not pools:
        sys.stderr.write("[!] Could not fetch pool data. Check network connection.\n")
        print("Error: Unable to fetch DeFi pool data from DeFiLlama API.")
        print("Please check your internet connection and try again.")
        sys.exit(1)

    sys.stderr.write("[*] Applying filters...\n")

    # Handle compare mode
    if COMPARE:
        result = compare_protocols(pools, COMPARE)
        if OUTPUT:
            with open(OUTPUT, "w") as f:
                f.write(result)
            sys.stderr.write("[*] Comparison written to {}\n".format(OUTPUT))
        else:
            print(result)
        return

    filtered = filter_pools(pools)
    sys.stderr.write("[*] {} pools match filters\n".format(len(filtered)))

    if not filtered:
        print("No pools found matching your criteria. Try relaxing filters.")
        return

    if FORMAT == "json":
        output = format_json_output(filtered)
    elif FORMAT == "csv":
        output = format_csv_output(filtered)
    elif FORMAT == "html":
        output = format_html_output(filtered)
    else:
        output = format_text(filtered)

    if OUTPUT:
        with open(OUTPUT, "w", encoding="utf-8") as f:
            f.write(output)
        sys.stderr.write("[*] Report written to {}\n".format(OUTPUT))
    else:
        print(output)

    sys.stderr.write("[*] Done.\n")


if __name__ == "__main__":
    main()
PYEOF

echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
