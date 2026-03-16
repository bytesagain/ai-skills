#!/usr/bin/env bash
# investment-portfolio — 投资组合分析器
# Usage: bash portfolio.sh <command> [args]
# Powered by BytesAgain | bytesagain.com
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

run_python() {
python3 << 'PYEOF'
import sys, math, json, hashlib
from datetime import datetime

cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
inp = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

# ============ Asset Database ============
ASSETS = {
    "stocks": {"name": "股票/Stocks", "risk": 8, "return_range": (6, 15), "liquidity": 9},
    "bonds": {"name": "债券/Bonds", "risk": 3, "return_range": (2, 5), "liquidity": 7},
    "gold": {"name": "黄金/Gold", "risk": 5, "return_range": (3, 8), "liquidity": 8},
    "realestate": {"name": "房地产/Real Estate", "risk": 6, "return_range": (4, 10), "liquidity": 3},
    "crypto": {"name": "加密货币/Crypto", "risk": 10, "return_range": (10, 50), "liquidity": 9},
    "cash": {"name": "现金/Cash", "risk": 1, "return_range": (0.5, 2), "liquidity": 10},
    "index": {"name": "指数基金/Index Fund", "risk": 6, "return_range": (5, 12), "liquidity": 8},
    "commodities": {"name": "大宗商品/Commodities", "risk": 7, "return_range": (3, 12), "liquidity": 6},
    "p2p": {"name": "P2P借贷/P2P", "risk": 9, "return_range": (5, 15), "liquidity": 4},
    "savings": {"name": "定期存款/Savings", "risk": 1, "return_range": (1.5, 3.5), "liquidity": 5},
}

PROFILES = {
    "conservative": {"name": "保守型", "max_risk": 3, "alloc": {"bonds": 40, "savings": 25, "gold": 15, "index": 10, "cash": 10}},
    "moderate": {"name": "稳健型", "max_risk": 5, "alloc": {"index": 30, "bonds": 25, "stocks": 20, "gold": 10, "realestate": 10, "cash": 5}},
    "balanced": {"name": "平衡型", "max_risk": 7, "alloc": {"stocks": 35, "index": 25, "bonds": 15, "gold": 10, "realestate": 10, "cash": 5}},
    "aggressive": {"name": "进取型", "max_risk": 9, "alloc": {"stocks": 45, "crypto": 15, "index": 20, "commodities": 10, "gold": 5, "cash": 5}},
    "speculative": {"name": "激进型", "max_risk": 10, "alloc": {"crypto": 35, "stocks": 30, "commodities": 15, "p2p": 10, "index": 10}},
}

def cmd_allocate():
    if not inp:
        print("Usage: allocate <profile> [amount]")
        print("Profiles: conservative, moderate, balanced, aggressive, speculative")
        print("Example: allocate balanced 100000")
        return
    parts = inp.split()
    profile = parts[0].lower()
    amount = float(parts[1]) if len(parts) > 1 else 100000

    if profile not in PROFILES:
        print("Unknown profile: {}".format(profile))
        print("Available: {}".format(", ".join(PROFILES.keys())))
        return

    p = PROFILES[profile]
    print("=" * 55)
    print("  {} 投资组合 — {}".format(p["name"], profile.upper()))
    print("  Total: {:,.0f}".format(amount))
    print("=" * 55)
    print("")
    print("  {:20s} {:>6s} {:>12s} {:>6s}".format("Asset", "Pct", "Amount", "Risk"))
    print("  " + "-" * 48)

    total_risk = 0
    exp_return_lo = 0
    exp_return_hi = 0
    for asset, pct in sorted(p["alloc"].items(), key=lambda x: -x[1]):
        a = ASSETS[asset]
        amt = amount * pct / 100
        total_risk += a["risk"] * pct / 100
        exp_return_lo += a["return_range"][0] * pct / 100
        exp_return_hi += a["return_range"][1] * pct / 100
        print("  {:20s} {:>5.0f}% {:>12,.0f} {:>5}/10".format(a["name"], pct, amt, a["risk"]))

    print("  " + "-" * 48)
    print("  综合风险: {:.1f}/10".format(total_risk))
    print("  预期年化: {:.1f}% ~ {:.1f}%".format(exp_return_lo, exp_return_hi))
    print("  预期收益: {:,.0f} ~ {:,.0f}/年".format(amount * exp_return_lo / 100, amount * exp_return_hi / 100))

def cmd_risk():
    if not inp:
        print("Usage: risk <asset1:pct,asset2:pct,...> [amount]")
        print("Example: risk stocks:50,bonds:30,gold:20 500000")
        return
    parts = inp.split()
    alloc_str = parts[0]
    amount = float(parts[1]) if len(parts) > 1 else 100000

    allocations = {}
    for item in alloc_str.split(","):
        kv = item.split(":")
        if len(kv) == 2:
            allocations[kv[0].strip()] = float(kv[1].strip())

    total_pct = sum(allocations.values())
    if abs(total_pct - 100) > 0.1:
        print("Warning: allocations sum to {:.1f}% (should be 100%)".format(total_pct))

    print("=" * 55)
    print("  自定义组合风险分析")
    print("  Total: {:,.0f}".format(amount))
    print("=" * 55)
    print("")

    total_risk = 0
    exp_lo = 0
    exp_hi = 0
    liquidity_score = 0
    for asset, pct in sorted(allocations.items(), key=lambda x: -x[1]):
        if asset not in ASSETS:
            print("  Warning: unknown asset {}".format(asset))
            continue
        a = ASSETS[asset]
        total_risk += a["risk"] * pct / 100
        exp_lo += a["return_range"][0] * pct / 100
        exp_hi += a["return_range"][1] * pct / 100
        liquidity_score += a["liquidity"] * pct / 100
        amt = amount * pct / 100
        print("  {:20s} {:>5.0f}% {:>12,.0f}  risk={}/10".format(a["name"], pct, amt, a["risk"]))

    print("")
    print("  综合风险: {:.1f}/10".format(total_risk))
    print("  流动性: {:.1f}/10".format(liquidity_score))
    print("  预期年化: {:.1f}% ~ {:.1f}%".format(exp_lo, exp_hi))

    # Risk rating
    if total_risk <= 3:
        rating = "低风险 (适合保守投资者)"
    elif total_risk <= 5:
        rating = "中低风险 (适合稳健投资者)"
    elif total_risk <= 7:
        rating = "中高风险 (适合平衡型投资者)"
    else:
        rating = "高风险 (适合激进投资者)"
    print("  风险等级: {}".format(rating))

def cmd_simulate():
    if not inp:
        print("Usage: simulate <amount> <years> [annual_return] [annual_contrib]")
        print("Example: simulate 100000 10 8 12000")
        return
    parts = inp.split()
    principal = float(parts[0])
    years = int(parts[1])
    annual_return = float(parts[2]) if len(parts) > 2 else 7.0
    annual_contrib = float(parts[3]) if len(parts) > 3 else 0

    print("=" * 55)
    print("  投资收益模拟")
    print("=" * 55)
    print("")
    print("  初始本金: {:>12,.0f}".format(principal))
    print("  年化收益: {:>11.1f}%".format(annual_return))
    print("  每年追加: {:>12,.0f}".format(annual_contrib))
    print("  投资年限: {:>10d}年".format(years))
    print("")
    print("  {:>4s} {:>14s} {:>14s} {:>12s}".format("Year", "Balance", "Contrib", "Gain"))
    print("  " + "-" * 48)

    balance = principal
    total_contrib = principal
    for y in range(1, years + 1):
        gain = balance * annual_return / 100
        balance += gain + annual_contrib
        total_contrib += annual_contrib
        if y <= 5 or y == years or y % 5 == 0:
            print("  {:>4d} {:>14,.0f} {:>14,.0f} {:>12,.0f}".format(y, balance, total_contrib, balance - total_contrib))

    print("")
    print("  最终价值: {:>14,.0f}".format(balance))
    print("  总投入:   {:>14,.0f}".format(total_contrib))
    print("  总收益:   {:>14,.0f}".format(balance - total_contrib))
    print("  收益率:   {:>13.1f}%".format((balance - total_contrib) / total_contrib * 100))

def cmd_rebalance():
    if not inp:
        print("Usage: rebalance <asset1:current_val,asset2:current_val> <target_profile>")
        print("Example: rebalance stocks:60000,bonds:25000,gold:15000 balanced")
        return
    parts = inp.split()
    current_str = parts[0]
    target = parts[1] if len(parts) > 1 else "balanced"

    if target not in PROFILES:
        print("Unknown profile: {}".format(target))
        return

    current = {}
    for item in current_str.split(","):
        kv = item.split(":")
        if len(kv) == 2:
            current[kv[0].strip()] = float(kv[1].strip())

    total = sum(current.values())
    target_alloc = PROFILES[target]["alloc"]

    print("=" * 60)
    print("  再平衡建议 — 目标: {} ({})".format(PROFILES[target]["name"], target))
    print("  总资产: {:,.0f}".format(total))
    print("=" * 60)
    print("")
    print("  {:20s} {:>10s} {:>8s} {:>10s} {:>8s} {:>10s}".format(
        "Asset", "Current", "Cur%", "Target", "Tgt%", "Action"))
    print("  " + "-" * 70)

    all_assets = set(list(current.keys()) + list(target_alloc.keys()))
    for asset in sorted(all_assets):
        cur_val = current.get(asset, 0)
        cur_pct = cur_val / total * 100 if total > 0 else 0
        tgt_pct = target_alloc.get(asset, 0)
        tgt_val = total * tgt_pct / 100
        diff = tgt_val - cur_val
        name = ASSETS.get(asset, {}).get("name", asset)

        action = ""
        if diff > 100:
            action = "+{:,.0f}".format(diff)
        elif diff < -100:
            action = "{:,.0f}".format(diff)
        else:
            action = "OK"

        print("  {:20s} {:>10,.0f} {:>7.1f}% {:>10,.0f} {:>7.1f}% {:>10s}".format(
            name, cur_val, cur_pct, tgt_val, tgt_pct, action))

def cmd_sharpe():
    if not inp:
        print("Usage: sharpe <return_pct> <risk_free_rate> <volatility>")
        print("Example: sharpe 12 3 15")
        print("  return=12%, risk-free=3%, volatility=15%")
        return
    parts = inp.split()
    ret = float(parts[0])
    rf = float(parts[1]) if len(parts) > 1 else 3.0
    vol = float(parts[2]) if len(parts) > 2 else 15.0

    sharpe = (ret - rf) / vol if vol > 0 else 0

    print("=" * 45)
    print("  夏普比率计算")
    print("=" * 45)
    print("")
    print("  投资收益率: {:.1f}%".format(ret))
    print("  无风险利率: {:.1f}%".format(rf))
    print("  波动率:     {:.1f}%".format(vol))
    print("  超额收益:   {:.1f}%".format(ret - rf))
    print("")
    print("  夏普比率:   {:.2f}".format(sharpe))
    print("")
    if sharpe >= 2:
        print("  评价: 优秀 — 每单位风险获得很高回报")
    elif sharpe >= 1:
        print("  评价: 良好 — 风险回报合理")
    elif sharpe >= 0.5:
        print("  评价: 一般 — 回报不足以补偿风险")
    else:
        print("  评价: 较差 — 风险过高或回报过低")

def cmd_compare():
    print("=" * 55)
    print("  资产类别对比")
    print("=" * 55)
    print("")
    print("  {:20s} {:>6s} {:>10s} {:>6s}".format("Asset", "Risk", "Return", "Liqd"))
    print("  " + "-" * 46)
    for key in sorted(ASSETS, key=lambda x: ASSETS[x]["risk"]):
        a = ASSETS[key]
        ret = "{}-{}%".format(a["return_range"][0], a["return_range"][1])
        print("  {:20s} {:>5}/10 {:>10s} {:>5}/10".format(a["name"], a["risk"], ret, a["liquidity"]))

def cmd_questionnaire():
    print("=" * 50)
    print("  风险偏好评估问卷")
    print("=" * 50)
    print("")
    questions = [
        ("1. 投资期限?", ["A. <1年", "B. 1-3年", "C. 3-5年", "D. 5-10年", "E. >10年"]),
        ("2. 亏损承受?", ["A. 不能亏", "B. <5%", "C. <10%", "D. <20%", "E. >20%也行"]),
        ("3. 投资经验?", ["A. 无", "B. 存款为主", "C. 基金", "D. 股票", "E. 期货/crypto"]),
        ("4. 收入稳定性?", ["A. 不稳定", "B. 较稳定", "C. 稳定", "D. 很稳定+储蓄多"]),
        ("5. 主要目标?", ["A. 保值", "B. 跑赢通胀", "C. 稳健增长", "D. 高回报", "E. 财务自由"]),
    ]
    score_map = {"A": 1, "B": 2, "C": 3, "D": 4, "E": 5}
    total = 0
    for q, opts in questions:
        print("  {}".format(q))
        for o in opts:
            print("    {}".format(o))
        print("")

    print("  评分标准: A=1, B=2, C=3, D=4, E=5")
    print("  5-9分: conservative | 10-14: moderate | 15-19: balanced")
    print("  20-22: aggressive | 23-25: speculative")

# Dispatch
commands = {
    "allocate": cmd_allocate,
    "risk": cmd_risk,
    "simulate": cmd_simulate,
    "rebalance": cmd_rebalance,
    "sharpe": cmd_sharpe,
    "compare": cmd_compare,
    "questionnaire": cmd_questionnaire,
}

if cmd == "help":
    print("Investment Portfolio Analyzer")
    print("")
    print("Commands:")
    print("  allocate <profile> [amount]        — Portfolio allocation by risk profile")
    print("  risk <asset:pct,...> [amount]       — Custom portfolio risk analysis")
    print("  simulate <amount> <years> [return]  — Compound growth simulation")
    print("  rebalance <asset:val,...> <profile>  — Rebalancing recommendations")
    print("  sharpe <return> <rf> <vol>          — Sharpe ratio calculation")
    print("  compare                             — Asset class comparison table")
    print("  questionnaire                       — Risk tolerance assessment")
    print("")
    print("Profiles: conservative, moderate, balanced, aggressive, speculative")
elif cmd in commands:
    commands[cmd]()
else:
    print("Unknown command: {}. Run with 'help' for usage.".format(cmd))

print("")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
}

run_python "$CMD" $INPUT
