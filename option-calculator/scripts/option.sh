#!/usr/bin/env bash
# option.sh — Black-Scholes期权计算器
# Usage: bash option.sh <command> [args...]
# Commands: price, greeks, chain, iv, parity, strategy
# Powered by BytesAgain | bytesagain.com

set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

# ═══════════════════════════════════════════════════
# Python Black-Scholes 期权定价核心
# ═══════════════════════════════════════════════════

OPTION_CALC_PY='
import sys, math

def norm_cdf(x):
    """标准正态分布CDF（纯数学实现）"""
    a1 = 0.254829592
    a2 = -0.284496736
    a3 = 1.421413741
    a4 = -1.453152027
    a5 = 1.061405429
    p  = 0.3275911
    sign = 1 if x >= 0 else -1
    x = abs(x) / math.sqrt(2)
    t = 1.0 / (1.0 + p * x)
    y = 1.0 - (((((a5*t + a4)*t) + a3)*t + a2)*t + a1)*t * math.exp(-x*x)
    return 0.5 * (1.0 + sign * y)

def norm_pdf(x):
    """标准正态分布PDF"""
    return math.exp(-0.5 * x * x) / math.sqrt(2 * math.pi)

def bs_d1(S, K, T, r, sigma):
    return (math.log(S/K) + (r + 0.5 * sigma**2) * T) / (sigma * math.sqrt(T))

def bs_d2(S, K, T, r, sigma):
    return bs_d1(S, K, T, r, sigma) - sigma * math.sqrt(T)

def bs_call(S, K, T, r, sigma):
    """Black-Scholes看涨期权价格"""
    if T <= 0:
        return max(S - K, 0)
    d1 = bs_d1(S, K, T, r, sigma)
    d2 = bs_d2(S, K, T, r, sigma)
    return S * norm_cdf(d1) - K * math.exp(-r * T) * norm_cdf(d2)

def bs_put(S, K, T, r, sigma):
    """Black-Scholes看跌期权价格"""
    if T <= 0:
        return max(K - S, 0)
    d1 = bs_d1(S, K, T, r, sigma)
    d2 = bs_d2(S, K, T, r, sigma)
    return K * math.exp(-r * T) * norm_cdf(-d2) - S * norm_cdf(-d1)

def greeks(S, K, T, r, sigma, option_type="call"):
    """计算所有Greeks"""
    if T <= 0:
        return {"delta": 0, "gamma": 0, "theta": 0, "vega": 0, "rho": 0}
    d1 = bs_d1(S, K, T, r, sigma)
    d2 = bs_d2(S, K, T, r, sigma)

    # Delta
    if option_type == "call":
        delta = norm_cdf(d1)
    else:
        delta = norm_cdf(d1) - 1

    # Gamma
    gamma = norm_pdf(d1) / (S * sigma * math.sqrt(T))

    # Theta (per day)
    theta_common = -(S * norm_pdf(d1) * sigma) / (2 * math.sqrt(T))
    if option_type == "call":
        theta = theta_common - r * K * math.exp(-r * T) * norm_cdf(d2)
    else:
        theta = theta_common + r * K * math.exp(-r * T) * norm_cdf(-d2)
    theta = theta / 365  # 转为每日

    # Vega (per 1% move)
    vega = S * math.sqrt(T) * norm_pdf(d1) / 100

    # Rho (per 1% move)
    if option_type == "call":
        rho = K * T * math.exp(-r * T) * norm_cdf(d2) / 100
    else:
        rho = -K * T * math.exp(-r * T) * norm_cdf(-d2) / 100

    return {
        "delta": delta,
        "gamma": gamma,
        "theta": theta,
        "vega": vega,
        "rho": rho
    }

def implied_vol(market_price, S, K, T, r, option_type="call", max_iter=100, tol=1e-6):
    """牛顿法求隐含波动率"""
    sigma = 0.3  # 初始猜测
    for _ in range(max_iter):
        if option_type == "call":
            price = bs_call(S, K, T, r, sigma)
        else:
            price = bs_put(S, K, T, r, sigma)
        d1 = bs_d1(S, K, T, r, sigma)
        vega = S * math.sqrt(T) * norm_pdf(d1)
        if abs(vega) < 1e-12:
            break
        sigma = sigma - (price - market_price) / vega
        if sigma <= 0:
            sigma = 0.001
        if abs(price - market_price) < tol:
            break
    return sigma

def parse_params(args):
    """解析参数: S=100 K=105 T=0.25 r=0.05 sigma=0.2 type=call"""
    params = {}
    for a in args:
        if "=" in a:
            k, v = a.split("=", 1)
            k = k.lower().strip()
            try:
                params[k] = float(v)
            except:
                params[k] = v.strip()
    return params

def cmd_price(args):
    p = parse_params(args)
    S = p.get("s", 100)
    K = p.get("k", 100)
    T = p.get("t", 0.25)
    r = p.get("r", 0.05)
    sigma = p.get("sigma", p.get("vol", 0.2))
    otype = str(p.get("type", "both"))

    print("━" * 50)
    print("  📊 Black-Scholes 期权定价")
    print("━" * 50)
    print(f"  标的价格 (S):    ${S:.2f}")
    print(f"  行权价格 (K):    ${K:.2f}")
    print(f"  到期时间 (T):    {T:.4f}年 ({T*365:.0f}天)")
    print(f"  无风险利率 (r):  {r*100:.2f}%")
    print(f"  波动率 (σ):      {sigma*100:.2f}%")
    print("━" * 50)

    c = bs_call(S, K, T, r, sigma)
    p_val = bs_put(S, K, T, r, sigma)

    if otype in ("call", "both"):
        print(f"\n  📈 看涨期权 (Call)")
        print(f"     理论价格:  ${c:.4f}")
        print(f"     内在价值:  ${max(S-K, 0):.4f}")
        print(f"     时间价值:  ${c - max(S-K, 0):.4f}")
        status = "实值 (ITM)" if S > K else ("虚值 (OTM)" if S < K else "平值 (ATM)")
        print(f"     状态:      {status}")

    if otype in ("put", "both"):
        print(f"\n  📉 看跌期权 (Put)")
        print(f"     理论价格:  ${p_val:.4f}")
        print(f"     内在价值:  ${max(K-S, 0):.4f}")
        print(f"     时间价值:  ${p_val - max(K-S, 0):.4f}")
        status = "实值 (ITM)" if S < K else ("虚值 (OTM)" if S > K else "平值 (ATM)")
        print(f"     状态:      {status}")

    # Put-Call Parity验证
    parity = c - p_val - S + K * math.exp(-r * T)
    print(f"\n  🔄 Put-Call Parity: {abs(parity):.8f} ≈ 0 ✅")
    print("━" * 50)

def cmd_greeks(args):
    p = parse_params(args)
    S = p.get("s", 100)
    K = p.get("k", 100)
    T = p.get("t", 0.25)
    r = p.get("r", 0.05)
    sigma = p.get("sigma", p.get("vol", 0.2))
    otype = str(p.get("type", "call"))

    g = greeks(S, K, T, r, sigma, otype)
    price = bs_call(S, K, T, r, sigma) if otype == "call" else bs_put(S, K, T, r, sigma)

    print("━" * 50)
    g_type = "Call" if otype == "call" else "Put"
    print("  📐 Greeks — {}期权".format(g_type))
    print("━" * 50)
    print(f"  标的 S=${S:.2f}  行权 K=${K:.2f}  T={T:.4f}年")
    print(f"  r={r*100:.2f}%  σ={sigma*100:.2f}%")
    print(f"  期权价格: ${price:.4f}")
    print("━" * 50)
    print(f"  Δ Delta:   {g['delta']:+.6f}   (价格变动$1时期权变化)")
    print(f"  Γ Gamma:   {g['gamma']:+.6f}   (Delta的变化率)")
    print(f"  Θ Theta:   {g['theta']:+.6f}   (每天时间衰减)")
    print(f"  ν Vega:    {g['vega']:+.6f}   (波动率变化1%时期权变化)")
    print(f"  ρ Rho:     {g['rho']:+.6f}   (利率变化1%时期权变化)")
    print()

    # 灵敏度分析
    print("  📊 灵敏度分析 (标的价格 ±10%):")
    print("  {:>8s} {:>10s} {:>10s} {:>10s}".format("价格", "Call", "Put", "Delta(C)"))
    for pct in [-10, -5, -2, 0, 2, 5, 10]:
        s2 = S * (1 + pct/100)
        c2 = bs_call(s2, K, T, r, sigma)
        p2 = bs_put(s2, K, T, r, sigma)
        d2 = greeks(s2, K, T, r, sigma, "call")["delta"]
        marker = " ◀" if pct == 0 else ""
        print(f"  ${s2:>7.2f} ${c2:>9.4f} ${p2:>9.4f}  {d2:>+9.6f}{marker}")
    print("━" * 50)

def cmd_chain(args):
    """生成期权链"""
    p = parse_params(args)
    S = p.get("s", 100)
    T = p.get("t", 0.25)
    r = p.get("r", 0.05)
    sigma = p.get("sigma", p.get("vol", 0.2))
    spread = p.get("spread", 5)  # 行权价间距

    print("━" * 70)
    print(f"  📋 期权链 — S=${S:.2f}  T={T:.4f}年  σ={sigma*100:.1f}%  r={r*100:.1f}%")
    print("━" * 70)
    print("  {:>8s} │ {:>8s} {:>7s} {:>7s} │ {:>8s} {:>7s} {:>7s} │ Status".format("Strike", "Call$", "C.Δ", "C.Γ", "Put$", "P.Δ", "P.Γ"))
    print("  " + "─" * 66)

    base = int(S / spread) * spread
    strikes = [base + i * spread for i in range(-5, 6)]

    for K in strikes:
        if K <= 0:
            continue
        c = bs_call(S, K, T, r, sigma)
        p_val = bs_put(S, K, T, r, sigma)
        gc = greeks(S, K, T, r, sigma, "call")
        gp = greeks(S, K, T, r, sigma, "put")
        if S > K * 1.02:
            status = "ITM/OTM"
        elif S < K * 0.98:
            status = "OTM/ITM"
        else:
            status = " ATM  "
        marker = " ◀" if abs(K - S) < spread/2 else ""
        print(f"  ${K:>7.2f} │ ${c:>7.4f} {gc['delta']:>+6.3f} {gc['gamma']:>6.4f} │ ${p_val:>7.4f} {gp['delta']:>+6.3f} {gp['gamma']:>6.4f} │ {status}{marker}")
    print("━" * 70)

def cmd_iv(args):
    """隐含波动率计算"""
    p = parse_params(args)
    S = p.get("s", 100)
    K = p.get("k", 100)
    T = p.get("t", 0.25)
    r = p.get("r", 0.05)
    market = p.get("price", p.get("market", 5.0))
    otype = str(p.get("type", "call"))

    iv = implied_vol(market, S, K, T, r, otype)
    # 验证
    if otype == "call":
        calc_price = bs_call(S, K, T, r, iv)
    else:
        calc_price = bs_put(S, K, T, r, iv)

    print("━" * 50)
    print(f"  🔍 隐含波动率 (IV) 计算")
    print("━" * 50)
    print(f"  市场价格:     ${market:.4f} ({otype})")
    print(f"  标的价格:     ${S:.2f}")
    print(f"  行权价格:     ${K:.2f}")
    print(f"  到期时间:     {T:.4f}年")
    print(f"  无风险利率:   {r*100:.2f}%")
    print("━" * 50)
    print(f"  隐含波动率:   {iv*100:.4f}%")
    print(f"  验证价格:     ${calc_price:.4f} (误差: ${abs(calc_price - market):.8f})")
    print()

    # IV对应的年化标准差
    print(f"  📊 波动率解读:")
    print(f"     年化波动:   ±{iv*100:.2f}% (即 ${S*iv:.2f})")
    print(f"     月度波动:   ±{iv/math.sqrt(12)*100:.2f}% (即 ${S*iv/math.sqrt(12):.2f})")
    print(f"     每日波动:   ±{iv/math.sqrt(252)*100:.2f}% (即 ${S*iv/math.sqrt(252):.2f})")
    print("━" * 50)

def cmd_parity(args):
    """Put-Call Parity检查"""
    p = parse_params(args)
    S = p.get("s", 100)
    K = p.get("k", 100)
    T = p.get("t", 0.25)
    r = p.get("r", 0.05)
    call_price = p.get("call", None)
    put_price = p.get("put", None)
    sigma = p.get("sigma", p.get("vol", 0.2))

    if call_price is None:
        call_price = bs_call(S, K, T, r, sigma)
    if put_price is None:
        put_price = bs_put(S, K, T, r, sigma)

    pv_k = K * math.exp(-r * T)
    # C - P = S - PV(K)
    lhs = call_price - put_price
    rhs = S - pv_k

    print("━" * 50)
    print("  🔄 Put-Call Parity 验证")
    print("━" * 50)
    print(f"  C - P = S - K·e^(-rT)")
    print(f"  {call_price:.4f} - {put_price:.4f} = {S:.2f} - {pv_k:.4f}")
    print(f"  {lhs:.4f} ≈ {rhs:.4f}")
    print(f"  差异: {abs(lhs - rhs):.8f}")
    if abs(lhs - rhs) < 0.01:
        print("  ✅ Parity成立！无套利机会。")
    else:
        print("  ⚠️ Parity不成立！可能存在套利机会。")
        if lhs > rhs:
            print("  策略: 卖出Call + 买入Put + 买入标的")
        else:
            print("  策略: 买入Call + 卖出Put + 卖空标的")
    print("━" * 50)

def cmd_strategy(args):
    """常见期权策略计算"""
    p = parse_params(args)
    S = p.get("s", 100)
    T = p.get("t", 0.25)
    r = p.get("r", 0.05)
    sigma = p.get("sigma", p.get("vol", 0.2))
    name = str(p.get("name", "straddle"))

    print("━" * 55)
    print(f"  📋 期权策略: {name.upper()}")
    print("━" * 55)
    print(f"  S=${S:.2f}  T={T:.4f}年  σ={sigma*100:.1f}%  r={r*100:.1f}%")
    print()

    K = S  # ATM
    c = bs_call(S, K, T, r, sigma)
    p_val = bs_put(S, K, T, r, sigma)

    if name == "straddle":
        cost = c + p_val
        be_up = K + cost
        be_down = K - cost
        print(f"  买入跨式 (Long Straddle)")
        print(f"  买入 Call K=${K:.2f}: -${c:.4f}")
        print(f"  买入 Put  K=${K:.2f}: -${p_val:.4f}")
        print(f"  总成本: ${cost:.4f}")
        print(f"  上方盈亏平衡: ${be_up:.4f}")
        print(f"  下方盈亏平衡: ${be_down:.4f}")
        print(f"  最大亏损: ${cost:.4f} (标的不动)")
        print(f"  最大盈利: 无限 (上方) / ${be_down:.4f} (下方)")
    elif name == "strangle":
        K1 = S * 0.95
        K2 = S * 1.05
        c2 = bs_call(S, K2, T, r, sigma)
        p2 = bs_put(S, K1, T, r, sigma)
        cost = c2 + p2
        print(f"  买入宽跨式 (Long Strangle)")
        print(f"  买入 Put  K=${K1:.2f}: -${p2:.4f}")
        print(f"  买入 Call K=${K2:.2f}: -${c2:.4f}")
        print(f"  总成本: ${cost:.4f}")
        print(f"  上方盈亏平衡: ${K2 + cost:.4f}")
        print(f"  下方盈亏平衡: ${K1 - cost:.4f}")
    elif name == "bull-spread":
        K1 = S
        K2 = S * 1.05
        c1 = bs_call(S, K1, T, r, sigma)
        c2 = bs_call(S, K2, T, r, sigma)
        cost = c1 - c2
        print(f"  牛市价差 (Bull Call Spread)")
        print(f"  买入 Call K=${K1:.2f}: -${c1:.4f}")
        print(f"  卖出 Call K=${K2:.2f}: +${c2:.4f}")
        print(f"  净成本: ${cost:.4f}")
        print(f"  最大盈利: ${K2 - K1 - cost:.4f}")
        print(f"  最大亏损: ${cost:.4f}")
    elif name == "iron-condor":
        K1, K2, K3, K4 = S*0.9, S*0.95, S*1.05, S*1.1
        p1 = bs_put(S, K1, T, r, sigma)
        p2 = bs_put(S, K2, T, r, sigma)
        c3 = bs_call(S, K3, T, r, sigma)
        c4 = bs_call(S, K4, T, r, sigma)
        credit = (p2 - p1) + (c3 - c4)
        print(f"  铁鹰策略 (Iron Condor)")
        print(f"  买入 Put  K=${K1:.2f}: -${p1:.4f}")
        print(f"  卖出 Put  K=${K2:.2f}: +${p2:.4f}")
        print(f"  卖出 Call K=${K3:.2f}: +${c3:.4f}")
        print(f"  买入 Call K=${K4:.2f}: -${c4:.4f}")
        print(f"  净收入: ${credit:.4f}")
        print(f"  最大盈利: ${credit:.4f} (标的在${K2:.0f}-${K3:.0f}之间)")
        print(f"  最大亏损: ${K2 - K1 - credit:.4f}")
    else:
        print(f"  支持策略: straddle, strangle, bull-spread, iron-condor")
        return

    print()
    # 到期盈亏表
    print("  📊 到期盈亏:")
    print("  {:>10s} {:>10s}".format("标的价格", "盈亏"))
    for pct in [-20, -15, -10, -5, -2, 0, 2, 5, 10, 15, 20]:
        s2 = S * (1 + pct/100)
        if name == "straddle":
            pnl = max(s2 - K, 0) + max(K - s2, 0) - cost
        elif name == "strangle":
            pnl = max(s2 - K2, 0) + max(K1 - s2, 0) - cost
        elif name == "bull-spread":
            pnl = max(s2 - K1, 0) - max(s2 - K2, 0) - cost
        elif name == "iron-condor":
            pnl = credit - max(K2 - s2, 0) + max(K1 - s2, 0) - max(s2 - K3, 0) + max(s2 - K4, 0)
        else:
            pnl = 0
        marker = " ◀" if pct == 0 else ""
        color = "📈" if pnl > 0 else "📉"
        print(f"  ${s2:>9.2f} {color} ${pnl:>+9.4f}{marker}")
    print("━" * 55)

# 主入口
cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
args = sys.argv[2:]

if cmd == "price":
    cmd_price(args)
elif cmd == "greeks":
    cmd_greeks(args)
elif cmd == "chain":
    cmd_chain(args)
elif cmd == "iv":
    cmd_iv(args)
elif cmd == "parity":
    cmd_parity(args)
elif cmd == "strategy":
    cmd_strategy(args)
else:
    print("Unknown:", cmd)
'

show_help() {
  cat <<'HELP'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📊 Black-Scholes 期权计算器
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  price    S=100 K=105 T=0.25 r=0.05 sigma=0.2
           期权定价 (Call/Put价格、内在/时间价值)

  greeks   S=100 K=105 T=0.25 r=0.05 sigma=0.2 type=call
           Greeks计算 (Delta/Gamma/Theta/Vega/Rho)

  chain    S=100 T=0.25 sigma=0.2
           期权链 (多行权价的Call/Put价格和Greeks)

  iv       S=100 K=105 T=0.25 price=5.5 type=call
           隐含波动率 (牛顿法求解IV)

  parity   S=100 K=105 T=0.25 call=5.5 put=3.2
           Put-Call Parity检验

  strategy S=100 T=0.25 sigma=0.2 name=straddle
           策略分析 (straddle/strangle/bull-spread/iron-condor)

  参数说明:
    S     = 标的资产价格
    K     = 行权价格
    T     = 到期时间(年)，如0.25=3个月
    r     = 无风险利率，如0.05=5%
    sigma = 波动率，如0.2=20%
    type  = call或put

  Powered by BytesAgain | bytesagain.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
HELP
}

case "$CMD" in
  price|greeks|chain|iv|parity|strategy)
    python3 -c "$OPTION_CALC_PY" "$CMD" $INPUT
    ;;
  *)
    show_help
    ;;
esac
