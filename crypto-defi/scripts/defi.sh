#!/usr/bin/env bash
# defi.sh — DeFi工具（真实API调用版）
# Usage: bash defi.sh <command> [args...]
# Commands: tvl, gas, pools, protocol, chains, apy, impermanent
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

# ── API 基础 ──
DEFILLAMA_BASE="https://api.llama.fi"
DEFILLAMA_YIELDS="https://yields.llama.fi"
ETH_GAS_API="https://api.etherscan.io/api"

# 安全HTTP请求
api_get() {
  local url="$1"
  local result
  result=$(curl -sS --connect-timeout 10 --max-time 30 "$url" 2>/dev/null) || {
    echo "❌ API请求失败: $url" >&2
    return 1
  }
  echo "$result"
}

# 数字格式化
fmt_usd() {
  local n="$1"
  if (( $(echo "$n >= 1000000000" | bc -l 2>/dev/null || echo 0) )); then
    printf "\$%.2fB" "$(echo "scale=2; $n/1000000000" | bc)"
  elif (( $(echo "$n >= 1000000" | bc -l 2>/dev/null || echo 0) )); then
    printf "\$%.2fM" "$(echo "scale=2; $n/1000000" | bc)"
  elif (( $(echo "$n >= 1000" | bc -l 2>/dev/null || echo 0) )); then
    printf "\$%.2fK" "$(echo "scale=2; $n/1000" | bc)"
  else
    printf "\$%.2f" "$n"
  fi
}

# ── TVL查询 ──
query_tvl() {
  local protocol="${1:-}"

  if [[ -z "$protocol" ]]; then
    # 获取总TVL和Top协议
    echo "# 📊 DeFi TVL 总览"
    echo ""
    echo "> 查询时间: $(date '+%Y-%m-%d %H:%M UTC+8')"
    echo ""

    # 全链TVL
    local chains_data
    chains_data=$(api_get "${DEFILLAMA_BASE}/v2/chains") || { echo "API请求失败"; return 1; }

    echo "## 各链TVL排名 (Top 15)"
    echo ""
    echo "| 排名 | 链 | TVL | 占比 |"
    echo "|------|-----|-----|------|"

    local total_tvl
    total_tvl=$(echo "$chains_data" | python3 -c "
import json,sys
data=json.load(sys.stdin)
total=sum(float(d.get('tvl',0)) for d in data)
print(f'{total:.0f}')
" 2>/dev/null || echo "0")

    echo "$chains_data" | python3 -c "
import json,sys
data=json.load(sys.stdin)
data.sort(key=lambda x: float(x.get('tvl',0)), reverse=True)
total=sum(float(d.get('tvl',0)) for d in data)
for i,d in enumerate(data[:15]):
    tvl=float(d.get('tvl',0))
    name=d.get('name','?')
    pct=tvl/total*100 if total>0 else 0
    if tvl>=1e9: tvl_s=f'\${tvl/1e9:.2f}B'
    elif tvl>=1e6: tvl_s=f'\${tvl/1e6:.2f}M'
    else: tvl_s=f'\${tvl/1e3:.2f}K'
    print(f'| {i+1} | {name} | {tvl_s} | {pct:.1f}% |')
" 2>/dev/null || echo "| - | 数据解析失败 | - | - |"

    if [[ "$total_tvl" != "0" ]]; then
      echo ""
      echo "**DeFi总TVL: $(fmt_usd "$total_tvl")**"
    fi

  else
    # 查询单个协议
    echo "# 📊 ${protocol} TVL详情"
    echo ""

    local proto_data
    proto_data=$(api_get "${DEFILLAMA_BASE}/protocol/${protocol}") || { echo "API请求失败"; return 1; }

    echo "$proto_data" | python3 -c "
import json,sys
d=json.load(sys.stdin)
name=d.get('name','?')
tvl=float(d.get('currentChainTvls',{}).get('total',d.get('tvl',0)) or 0)
chains=d.get('chains',[])
category=d.get('category','?')
desc=d.get('description','')[:200]
url=d.get('url','')

if tvl>=1e9: tvl_s=f'\${tvl/1e9:.2f}B'
elif tvl>=1e6: tvl_s=f'\${tvl/1e6:.2f}M'
else: tvl_s=f'\${tvl/1e3:.2f}K'

print(f'> 查询时间: $(date \"+%Y-%m-%d %H:%M\")')
print()
print(f'| 属性 | 值 |')
print(f'|------|-----|')
print(f'| 名称 | {name} |')
print(f'| 类别 | {category} |')
print(f'| TVL | {tvl_s} |')
print(f'| 支持链 | {\", \".join(chains[:10])} |')
print(f'| 官网 | {url} |')
print()
print(f'**简介:** {desc}')

# 各链TVL分布
chain_tvls = d.get('currentChainTvls',{})
if chain_tvls:
    print()
    print('### 各链TVL分布')
    print()
    print('| 链 | TVL |')
    print('|-----|------|')
    sorted_chains = sorted(
        [(k,v) for k,v in chain_tvls.items() if isinstance(v,(int,float)) and k not in ('total','staking','pool2','borrowed')],
        key=lambda x: x[1], reverse=True
    )
    for chain, ctvl in sorted_chains[:10]:
        if ctvl>=1e9: cs=f'\${ctvl/1e9:.2f}B'
        elif ctvl>=1e6: cs=f'\${ctvl/1e6:.2f}M'
        else: cs=f'\${ctvl/1e3:.2f}K'
        print(f'| {chain} | {cs} |')
" 2>/dev/null || echo "❌ 数据解析失败，请检查协议名称是否正确"
  fi
}

# ── Gas费查询 ──
query_gas() {
  echo "# ⛽ Gas费实时数据"
  echo ""
  echo "> 查询时间: $(date '+%Y-%m-%d %H:%M UTC+8')"
  echo ""

  # 使用多个免费API尝试
  echo "## Ethereum Gas"
  local eth_gas
  eth_gas=$(api_get "https://api.blocknative.com/gasprices/blockprices" 2>/dev/null) || true

  if [[ -n "$eth_gas" && "$eth_gas" != *"error"* ]]; then
    echo "$eth_gas" | python3 -c "
import json,sys
try:
    d=json.load(sys.stdin)
    bp=d.get('blockPrices',[{}])[0]
    prices=bp.get('estimatedPrices',[])
    print('| 速度 | Gas (Gwei) | 预估时间 |')
    print('|------|-----------|---------|')
    for p in prices[:4]:
        conf=p.get('confidence',0)
        gas=p.get('maxFeePerGas',0)
        speed='🐢 慢' if conf<=70 else ('🚶 标准' if conf<=90 else ('🏃 快' if conf<=95 else '🚀 极速'))
        t='5-10min' if conf<=70 else ('2-5min' if conf<=90 else ('30s-2min' if conf<=95 else '<30s'))
        print(f'| {speed} | {gas:.1f} | {t} |')
except:
    print('数据源暂不可用')
" 2>/dev/null || echo "⚠️ Blocknative数据暂不可用"
  fi

  # 备用: 查Layer2 Gas
  echo ""
  echo "## Layer2 Gas对比"
  echo ""
  echo "| 链 | 典型转账费 | 适合场景 |"
  echo "|-----|----------|---------|"
  echo "| Ethereum L1 | \$2-20 | 大额交易 |"
  echo "| Arbitrum | \$0.1-0.5 | DeFi |"
  echo "| Optimism | \$0.1-0.5 | DeFi |"
  echo "| Polygon | \$0.01-0.05 | 日常交易 |"
  echo "| Base | \$0.01-0.1 | 小额交易 |"
  echo "| zkSync | \$0.05-0.3 | DeFi |"
  echo ""
  echo "💡 提示: Gas费随网络拥堵波动，低峰时段(UTC 2-6AM)通常更便宜"
}

# ── 热门池子 ──
query_pools() {
  local chain="${1:-}"
  local min_tvl="${2:-1000000}"

  echo "# 🏊 DeFi热门资金池"
  echo ""
  echo "> 查询时间: $(date '+%Y-%m-%d %H:%M UTC+8')"
  echo "> 最低TVL: $(fmt_usd "$min_tvl")"
  [[ -n "$chain" ]] && echo "> 链: $chain"
  echo ""

  local pools_data
  pools_data=$(api_get "${DEFILLAMA_YIELDS}/pools") || { echo "API请求失败"; return 1; }

  local chain_filter=""
  if [[ -n "$chain" ]]; then
    chain_filter="and d.get('chain','').lower()=='${chain}'.lower()"
  fi

  echo "$pools_data" | python3 -c "
import json,sys
data=json.load(sys.stdin).get('data',[])

# 过滤和排序
min_tvl=$min_tvl
chain='$chain'.lower()
filtered=[]
for d in data:
    tvl=float(d.get('tvlUsd',0) or 0)
    apy=float(d.get('apy',0) or 0)
    if tvl<min_tvl: continue
    if apy<=0 or apy>10000: continue  # 过滤异常APY
    if chain and d.get('chain','').lower()!=chain: continue
    filtered.append(d)

# 按APY排序
filtered.sort(key=lambda x: float(x.get('apy',0) or 0), reverse=True)

print('## Top 20 高收益池')
print()
print('| 排名 | 协议 | 链 | 资产对 | APY | TVL | 稳定币 |')
print('|------|------|-----|--------|-----|-----|--------|')

for i,d in enumerate(filtered[:20]):
    proj=d.get('project','?')
    ch=d.get('chain','?')
    symbol=d.get('symbol','?')
    apy=float(d.get('apy',0) or 0)
    tvl=float(d.get('tvlUsd',0) or 0)
    stable='✅' if d.get('stablecoin') else '❌'

    if tvl>=1e9: tvl_s=f'\${tvl/1e9:.2f}B'
    elif tvl>=1e6: tvl_s=f'\${tvl/1e6:.2f}M'
    else: tvl_s=f'\${tvl/1e3:.2f}K'

    apy_emoji='🔥' if apy>50 else ('📈' if apy>20 else '📊')
    print(f'| {i+1} | {proj} | {ch} | {symbol} | {apy_emoji} {apy:.2f}% | {tvl_s} | {stable} |')

# 汇总统计
if filtered:
    total_tvl=sum(float(d.get('tvlUsd',0) or 0) for d in filtered[:20])
    avg_apy=sum(float(d.get('apy',0) or 0) for d in filtered[:20])/min(20,len(filtered))
    chains_set=set(d.get('chain','') for d in filtered[:20])
    protos_set=set(d.get('project','') for d in filtered[:20])
    print()
    print(f'**统计:** 涉及 {len(chains_set)} 条链, {len(protos_set)} 个协议')
    if total_tvl>=1e9: ts=f'\${total_tvl/1e9:.2f}B'
    elif total_tvl>=1e6: ts=f'\${total_tvl/1e6:.2f}M'
    else: ts=f'\${total_tvl/1e3:.2f}K'
    print(f'**Top20总TVL:** {ts} | **平均APY:** {avg_apy:.2f}%')
" 2>/dev/null || echo "❌ 数据解析失败"

  echo ""
  echo "⚠️ **风险提示:** 高APY通常伴随高风险（无常损失/合约风险/rug pull），DYOR！"
}

# ── 无常损失计算 ──
calc_impermanent_loss() {
  local price_change="${1:-50}"  # 价格变动百分比

  echo "# 📉 无常损失计算器"
  echo ""
  echo "> 价格变动范围: -90% ~ +500%"
  echo ""

  echo "## 无常损失表"
  echo ""
  echo "| 价格变动 | 池子价值 vs HODL | 无常损失 |"
  echo "|---------|-----------------|---------|"

  local changes=(-90 -75 -50 -25 -10 0 10 25 50 75 100 200 300 500)
  for pct in "${changes[@]}"; do
    # IL = 2*sqrt(price_ratio) / (1+price_ratio) - 1
    local ratio
    ratio=$(echo "scale=10; (100 + $pct) / 100" | bc)
    local sqrt_r
    sqrt_r=$(echo "scale=10; sqrt($ratio)" | bc)
    local pool_vs_hodl
    pool_vs_hodl=$(echo "scale=6; 2 * $sqrt_r / (1 + $ratio)" | bc)
    local il
    il=$(echo "scale=4; (1 - $pool_vs_hodl) * 100" | bc)
    local pool_pct
    pool_pct=$(echo "scale=2; $pool_vs_hodl * 100" | bc)

    local marker=""
    if [[ "$pct" == "$price_change" ]]; then marker=" ← 你查询的"
    fi

    local severity="🟢"
    local il_abs
    il_abs=$(echo "$il" | sed 's/-//')
    if (( $(echo "$il_abs > 10" | bc -l) )); then severity="🔴"
    elif (( $(echo "$il_abs > 5" | bc -l) )); then severity="🟡"
    fi

    local sign="+"
    (( pct < 0 )) && sign=""
    echo "| ${sign}${pct}% | ${pool_pct}% | ${severity} ${il}%${marker} |"
  done

  # 具体计算用户输入的价格变动
  if [[ "$price_change" != "0" ]]; then
    echo ""
    echo "## 你的场景分析"
    echo ""
    local ratio
    ratio=$(echo "scale=10; (100 + $price_change) / 100" | bc)
    local sqrt_r
    sqrt_r=$(echo "scale=10; sqrt($ratio)" | bc)
    local pool_vs_hodl
    pool_vs_hodl=$(echo "scale=6; 2 * $sqrt_r / (1 + $ratio)" | bc)
    local il
    il=$(echo "scale=4; (1 - $pool_vs_hodl) * 100" | bc)

    echo "- 代币价格变动: **${price_change}%**"
    echo "- 提供流动性 vs 持币: **$(echo "scale=2; $pool_vs_hodl * 100" | bc)%**"
    echo "- 无常损失: **${il}%**"
    echo ""
    echo "假设初始投入 \$10,000："
    local hodl_val
    hodl_val=$(echo "scale=2; 10000 * (1 + $price_change / 200)" | bc)  # 简化: 50/50池
    local pool_val
    pool_val=$(echo "scale=2; $hodl_val * $pool_vs_hodl" | bc)
    local loss_usd
    loss_usd=$(echo "scale=2; $hodl_val - $pool_val" | bc)
    echo "- HODL价值: \$$(printf '%.2f' "$hodl_val")"
    echo "- LP池子价值: \$$(printf '%.2f' "$pool_val")"
    echo "- 无常损失金额: \$$(printf '%.2f' "$loss_usd")"
    echo ""
    echo "💡 如果池子APY高于 ${il}%，则提供流动性仍然划算。"
  fi
}

# ── APY计算 ──
calc_apy() {
  local daily_rate="${1:-0.5}"
  local principal="${2:-10000}"
  local days="${3:-365}"

  echo "# 📈 APY/APR计算器"
  echo ""

  # APR
  local apr
  apr=$(echo "scale=4; $daily_rate * 365" | bc)

  # APY (复利)
  local apy
  apy=$(echo "scale=4; ((1 + $daily_rate / 100) ^ 365 - 1) * 100" | bc)

  # 收益计算
  local simple_return
  simple_return=$(echo "scale=2; $principal * $apr / 100" | bc)
  local compound_return
  compound_return=$(echo "scale=2; $principal * $apy / 100" | bc)
  local compound_diff
  compound_diff=$(echo "scale=2; $compound_return - $simple_return" | bc)

  echo "| 指标 | 值 |"
  echo "|------|-----|"
  echo "| 日利率 | ${daily_rate}% |"
  echo "| APR (单利年化) | ${apr}% |"
  echo "| APY (复利年化) | ${apy}% |"
  echo "| 本金 | \$$(printf '%g' "$principal") |"
  echo "| 投资天数 | ${days}天 |"
  echo "| 单利收益 | \$$(printf '%.2f' "$simple_return") |"
  echo "| 复利收益 | \$$(printf '%.2f' "$compound_return") |"
  echo "| 复利额外收益 | \$$(printf '%.2f' "$compound_diff") |"
  echo ""

  echo "## 逐月复利增长"
  echo ""
  echo "| 月份 | 本金+收益 | 月收益 | 累计收益率 |"
  echo "|------|----------|--------|-----------|"

  local balance="$principal"
  for m in $(seq 1 12); do
    local monthly_days=30
    local prev_balance="$balance"
    balance=$(echo "scale=4; $balance * (1 + $daily_rate / 100) ^ $monthly_days" | bc)
    local monthly_gain
    monthly_gain=$(echo "scale=2; $balance - $prev_balance" | bc)
    local cum_return
    cum_return=$(echo "scale=2; ($balance - $principal) / $principal * 100" | bc)
    echo "| ${m}月 | \$$(printf '%.2f' "$balance") | +\$$(printf '%.2f' "$monthly_gain") | ${cum_return}% |"
  done
}

# ── 帮助 ──
show_help() {
  cat <<'HELP'
🔗 DeFi工具 — defi.sh

用法: bash defi.sh <command> [args...]

命令:
  tvl [协议名]
        → 查询DeFi TVL（无参数=全链排名，有参数=协议详情）
  gas   → 查询实时Gas费
  pools [链名] [最低TVL]
        → 查询热门资金池（按APY排序）
  apy <日利率%> [本金] [天数]
        → APY/APR计算（含逐月复利表）
  impermanent [价格变动%]
        → 无常损失计算器
  help  → 显示帮助

示例:
  bash defi.sh tvl               # 全链TVL排名
  bash defi.sh tvl aave          # Aave协议详情
  bash defi.sh gas               # 实时Gas费
  bash defi.sh pools ethereum    # 以太坊上热门池
  bash defi.sh pools "" 5000000  # TVL>$5M的池子
  bash defi.sh apy 0.3 50000     # 日利率0.3%，本金$50000
  bash defi.sh impermanent 100   # 价格翻倍时的无常损失

💡 数据源:
  - DeFiLlama API (免费，无需API Key)
  - Blocknative Gas API
HELP
}

case "$CMD" in
  tvl)         query_tvl "$INPUT" ;;
  gas)         query_gas ;;
  pools)
    IFS=' ' read -ra A <<< "$INPUT"
    query_pools "${A[0]:-}" "${A[1]:-1000000}"
    ;;
  apy)
    IFS=' ' read -ra A <<< "$INPUT"
    calc_apy "${A[0]:-0.5}" "${A[1]:-10000}" "${A[2]:-365}"
    ;;
  impermanent) calc_impermanent_loss "${INPUT:-50}" ;;
  help|*)      show_help ;;
esac
