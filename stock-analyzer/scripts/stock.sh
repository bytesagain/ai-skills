#!/usr/bin/env bash
# stock-analyzer — 股票分析工具
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

WATCHLIST_FILE="/tmp/stock_watchlist.txt"

show_help() {
  cat <<'EOF'
╔══════════════════════════════════════════════════════════╗
║              📈 Stock Analyzer 股票分析工具              ║
╚══════════════════════════════════════════════════════════╝

Usage: bash stock.sh <command> [args...]

Commands:
  analyze  <ticker>                    综合分析一只股票
  pe       <ticker> [industry]         PE估值分析
  technical <ticker>                   技术指标分析
  dividend <ticker>                    股息/分红分析
  compare  <t1> <t2> [t3...]          多股横向对比
  watchlist [add|remove|show] [ticker] 自选股管理
  help                                 显示此帮助

Examples:
  bash stock.sh analyze AAPL
  bash stock.sh pe 600519 白酒
  bash stock.sh technical TSLA
  bash stock.sh dividend 000651
  bash stock.sh compare AAPL MSFT GOOGL
  bash stock.sh watchlist add AAPL

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

detect_market() {
  local ticker="$1"
  if [[ "$ticker" =~ ^[0-9]{6}$ ]]; then
    if [[ "$ticker" =~ ^6 ]]; then echo "上交所(SH)"
    elif [[ "$ticker" =~ ^(0|3) ]]; then echo "深交所(SZ)"
    else echo "A股"; fi
  elif [[ "$ticker" =~ ^[A-Za-z]+$ ]]; then
    echo "美股(US)"
  else
    echo "未知市场"
  fi
}

cmd_analyze() {
  local ticker="${1:?用法: analyze <ticker>}"
  local market
  market=$(detect_market "$ticker")

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           📊 综合分析: ${ticker} (${market})
╚══════════════════════════════════════════════════════════╝

📋 基本信息
────────────────────────────────────────
  股票代码: ${ticker}
  所属市场: ${market}
  分析日期: $(date +%Y-%m-%d)

💰 估值指标（示例数据）
────────────────────────────────────────
  市盈率 (PE-TTM):  25.3x
  市净率 (PB):       4.8x
  市销率 (PS):       6.2x
  EV/EBITDA:        18.5x
  PEG:               1.2

📈 基本面（示例数据）
────────────────────────────────────────
  营业收入:  ¥3,850亿 (YoY +8.2%)
  净利润:    ¥960亿 (YoY +12.5%)
  毛利率:    42.3%
  净利率:    24.9%
  ROE:       28.7%
  资产负债率: 35.2%

📊 趋势判断
────────────────────────────────────────
  短期(1-4周):  ⬆️  偏多（站上5日/10日均线）
  中期(1-3月):  ➡️  震荡（均线缠绕）
  长期(6-12月): ⬆️  偏多（站上年线）

⚠️  以上为演示数据，实际投资请参考实时行情
EOF
}

cmd_pe() {
  local ticker="${1:?用法: pe <ticker> [industry]}"
  local industry="${2:-通用}"

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           💹 PE估值分析: ${ticker}
╚══════════════════════════════════════════════════════════╝

📊 PE估值详情
────────────────────────────────────────
  当前PE (TTM):     25.3x
  行业(${industry})平均PE: 20.1x
  历史PE中位数:      22.8x
  PE百分位:          68% (偏高区间)

📉 PE历史区间（近5年）
────────────────────────────────────────
  最低PE:  12.5x  (2022-10)
  最高PE:  45.2x  (2021-02)
  当前位置: ████████████░░░░ 68%

📋 估值判断
────────────────────────────────────────
  vs 行业:   ⚠️  高于行业平均 (+25.9%)
  vs 历史:   ⚠️  高于历史中位数 (+11.0%)
  PEG:       1.2x (合理偏高)

💡 建议
  当前估值处于历史偏高区间，建议等待回调
  或关注未来业绩增长能否支撑当前估值

⚠️  以上为演示数据，实际请参考实时行情
EOF
}

cmd_technical() {
  local ticker="${1:?用法: technical <ticker>}"

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           📉 技术指标分析: ${ticker}
╚══════════════════════════════════════════════════════════╝

📊 均线系统（示例数据）
────────────────────────────────────────
  MA5:   ¥152.30  (当前价在上方 ✅)
  MA10:  ¥150.85  (当前价在上方 ✅)
  MA20:  ¥148.60  (当前价在上方 ✅)
  MA60:  ¥142.15  (当前价在上方 ✅)
  MA120: ¥138.90  (当前价在上方 ✅)
  MA250: ¥135.20  (当前价在上方 ✅)
  → 多头排列 📈

📈 RSI (相对强弱指标)
────────────────────────────────────────
  RSI(6):   62.5  (中性偏强)
  RSI(12):  58.3  (中性)
  RSI(24):  55.1  (中性)
  [20====|====40====|====60==*=|====80]
                              ↑ 当前位置

📊 MACD
────────────────────────────────────────
  DIF:   1.25
  DEA:   0.98
  MACD:  0.54 (红柱)
  → 金叉后运行，多头信号 ✅

📊 布林带
────────────────────────────────────────
  上轨:  ¥158.50
  中轨:  ¥150.20
  下轨:  ¥141.90
  当前:  ¥154.80 (偏上轨运行)

📋 综合判断
────────────────────────────────────────
  短期信号: 偏多 ⬆️
  支撑位:   ¥148.60 (MA20)
  压力位:   ¥158.50 (布林上轨)

⚠️  技术分析仅供参考，不构成投资建议
EOF
}

cmd_dividend() {
  local ticker="${1:?用法: dividend <ticker>}"

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           💰 股息/分红分析: ${ticker}
╚══════════════════════════════════════════════════════════╝

📊 股息概览（示例数据）
────────────────────────────────────────
  当前股息率:    2.85%
  每股分红:      ¥3.50
  派息频率:      每年1次
  除权除息日:    2024-06-15 (预估)

📈 分红历史（近5年）
────────────────────────────────────────
  2023:  ¥3.50/股  (股息率 2.85%)  ██████████░
  2022:  ¥3.20/股  (股息率 2.60%)  █████████░░
  2021:  ¥2.80/股  (股息率 2.30%)  ████████░░░
  2020:  ¥2.50/股  (股息率 2.10%)  ███████░░░░
  2019:  ¥2.20/股  (股息率 1.85%)  ██████░░░░░
  → 连续5年分红增长 ✅

📋 可持续性分析
────────────────────────────────────────
  派息率:        45.2% (健康，<70%可持续)
  自由现金流:    充裕 ✅
  盈利稳定性:    高 ✅
  负债率:        35.2% (安全)

💡 股息投资建议
  ✅ 连续多年分红，分红增长趋势良好
  ✅ 派息率适中，有提升空间
  ⚠️  股息率低于3%，对比银行理财吸引力一般

⚠️  以上为演示数据，实际请参考实时行情
EOF
}

cmd_compare() {
  if [ $# -lt 2 ]; then
    echo "用法: compare <ticker1> <ticker2> [ticker3...]"
    echo "示例: compare AAPL MSFT GOOGL"
    return 1
  fi

  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║           🔄 股票对比分析"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""

  # Build header
  printf "%-16s" "  指标"
  for t in "$@"; do printf "%-14s" "$t"; done
  echo ""
  echo "────────────────────────────────────────────────────────"

  # Sample comparison data
  local pe_vals=(25.3 32.1 22.8 18.5 28.7)
  local pb_vals=(4.8 11.2 5.6 3.2 7.1)
  local roe_vals=(28.7 35.2 25.1 22.3 31.5)
  local margin_vals=(24.9 33.5 22.1 18.6 26.8)
  local growth_vals=(8.2 12.5 6.8 15.3 9.1)
  local div_vals=(2.85 0.85 1.20 3.50 1.65)

  printf "%-16s" "  PE(TTM)"
  local i=0
  for t in "$@"; do printf "%-14s" "${pe_vals[$i]:-N/A}x"; ((i++)); done
  echo ""

  printf "%-16s" "  PB"
  i=0
  for t in "$@"; do printf "%-14s" "${pb_vals[$i]:-N/A}x"; ((i++)); done
  echo ""

  printf "%-16s" "  ROE"
  i=0
  for t in "$@"; do printf "%-14s" "${roe_vals[$i]:-N/A}%"; ((i++)); done
  echo ""

  printf "%-16s" "  净利率"
  i=0
  for t in "$@"; do printf "%-14s" "${margin_vals[$i]:-N/A}%"; ((i++)); done
  echo ""

  printf "%-16s" "  营收增速"
  i=0
  for t in "$@"; do printf "%-14s" "${growth_vals[$i]:-N/A}%"; ((i++)); done
  echo ""

  printf "%-16s" "  股息率"
  i=0
  for t in "$@"; do printf "%-14s" "${div_vals[$i]:-N/A}%"; ((i++)); done
  echo ""

  cat <<'EOF'

📋 对比结论
────────────────────────────────────────
  估值最低:     按PE排序选择最低者
  盈利能力最强: 按ROE排序选择最高者
  成长性最好:   按营收增速选择最高者
  分红最优:     按股息率选择最高者

💡 综合建议: 结合估值、盈利、成长、分红多维度综合判断

⚠️  以上为演示数据，实际请参考实时行情
EOF
}

cmd_watchlist() {
  local action="${1:-show}"
  local ticker="${2:-}"

  case "$action" in
    add)
      if [ -z "$ticker" ]; then
        echo "❌ 用法: watchlist add <ticker>"
        return 1
      fi
      # Check if already exists
      if [ -f "$WATCHLIST_FILE" ] && grep -q "^${ticker}$" "$WATCHLIST_FILE" 2>/dev/null; then
        echo "⚠️  ${ticker} 已在自选股中"
      else
        echo "$ticker" >> "$WATCHLIST_FILE"
        echo "✅ 已添加 ${ticker} 到自选股"
      fi
      echo ""
      echo "当前自选股:"
      if [ -f "$WATCHLIST_FILE" ]; then
        local n=1
        while IFS= read -r line; do
          echo "  ${n}. ${line}"
          ((n++))
        done < "$WATCHLIST_FILE"
      fi
      ;;
    remove)
      if [ -z "$ticker" ]; then
        echo "❌ 用法: watchlist remove <ticker>"
        return 1
      fi
      if [ -f "$WATCHLIST_FILE" ]; then
        local tmp
        tmp=$(mktemp)
        grep -v "^${ticker}$" "$WATCHLIST_FILE" > "$tmp" || true
        mv "$tmp" "$WATCHLIST_FILE"
        echo "✅ 已从自选股移除 ${ticker}"
      else
        echo "⚠️  自选股列表为空"
      fi
      ;;
    show)
      echo "╔══════════════════════════════════════════════════════════╗"
      echo "║           ⭐ 自选股列表"
      echo "╚══════════════════════════════════════════════════════════╝"
      echo ""
      if [ -f "$WATCHLIST_FILE" ] && [ -s "$WATCHLIST_FILE" ]; then
        local n=1
        while IFS= read -r line; do
          local mkt
          mkt=$(detect_market "$line")
          printf "  %d. %-10s [%s]\n" "$n" "$line" "$mkt"
          ((n++))
        done < "$WATCHLIST_FILE"
        echo ""
        echo "共 $((n-1)) 只股票"
      else
        echo "  (空) 使用 'watchlist add <ticker>' 添加股票"
      fi
      ;;
    *)
      echo "❌ 未知操作: $action"
      echo "用法: watchlist [add|remove|show] [ticker]"
      ;;
  esac
}

case "$CMD" in
  analyze)   cmd_analyze "$@" ;;
  pe)        cmd_pe "$@" ;;
  technical) cmd_technical "$@" ;;
  dividend)  cmd_dividend "$@" ;;
  compare)   cmd_compare "$@" ;;
  watchlist) cmd_watchlist "$@" ;;
  help)      show_help ;;
  *)
    echo "❌ 未知命令: $CMD"
    echo "运行 'bash stock.sh help' 查看帮助"
    exit 1
    ;;
esac
