#!/usr/bin/env bash
# loan-calculator — 贷款计算器
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
  cat <<'EOF'
╔══════════════════════════════════════════════════════════╗
║              🏦 Loan Calculator 贷款计算器               ║
╚══════════════════════════════════════════════════════════╝

Usage: bash loan.sh <command> [args...]

Commands:
  calculate <amount> <rate%> <years> [method]    计算月供
      method: equal-payment (等额本息,默认) | equal-principal (等额本金)
  compare   <amount> <rate1> <y1> <rate2> <y2>   对比两方案
  prepay    <amt> <rate> <yrs> <prepay> <after_m> 提前还款分析
  afford    <monthly_income> <rate> <years>       可贷额度评估
  schedule  <amount> <rate> <years> [method]      还款计划表(前12期)
  refinance <remaining> <old_r> <new_r> <rem_yrs> 再融资分析
  help                                            显示此帮助

Examples:
  bash loan.sh calculate 1000000 4.2 30
  bash loan.sh compare 1000000 4.9 30 4.2 25
  bash loan.sh prepay 1000000 4.2 30 200000 24
  bash loan.sh afford 15000 4.2 30
  bash loan.sh schedule 500000 3.8 10
  bash loan.sh refinance 800000 5.5 4.0 20

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

# bc helper: safe calculation
calc() {
  echo "scale=2; $1" | bc -l 2>/dev/null || echo "0"
}

calc6() {
  echo "scale=6; $1" | bc -l 2>/dev/null || echo "0"
}

cmd_calculate() {
  local amount="${1:?用法: calculate <amount> <rate%> <years> [method]}"
  local rate="${2:?请提供年利率(%)}"
  local years="${3:?请提供贷款年限}"
  local method="${4:-equal-payment}"

  local months
  months=$(calc "$years * 12")
  local monthly_rate
  monthly_rate=$(calc6 "$rate / 100 / 12")

  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║           🏦 贷款计算结果"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""
  echo "📋 贷款信息"
  echo "────────────────────────────────────────"
  printf "  贷款金额:   ¥%s\n" "$(printf "%'.0f" "$amount")"
  echo "  年利率:     ${rate}%"
  echo "  贷款期限:   ${years}年 (${months}期)"
  echo "  还款方式:   $([ "$method" = "equal-principal" ] && echo "等额本金" || echo "等额本息")"
  echo ""

  if [ "$method" = "equal-payment" ]; then
    # 等额本息: M = P * r * (1+r)^n / ((1+r)^n - 1)
    local pow
    pow=$(calc6 "(1 + $monthly_rate) ^ $months")
    local monthly_payment
    monthly_payment=$(calc "$amount * $monthly_rate * $pow / ($pow - 1)")
    local total_payment
    total_payment=$(calc "$monthly_payment * $months")
    local total_interest
    total_interest=$(calc "$total_payment - $amount")

    echo "💰 还款详情（等额本息）"
    echo "────────────────────────────────────────"
    printf "  月供:       ¥%s\n" "$(printf "%'.2f" "$monthly_payment")"
    printf "  总还款额:   ¥%s\n" "$(printf "%'.2f" "$total_payment")"
    printf "  总利息:     ¥%s\n" "$(printf "%'.2f" "$total_interest")"
    local interest_ratio
    interest_ratio=$(calc "$total_interest / $total_payment * 100")
    echo "  利息占比:   ${interest_ratio}%"
  else
    # 等额本金
    local monthly_principal
    monthly_principal=$(calc "$amount / $months")
    local first_payment
    first_payment=$(calc "$monthly_principal + $amount * $monthly_rate")
    local last_payment
    last_payment=$(calc "$monthly_principal + $monthly_principal * $monthly_rate")
    local total_interest
    total_interest=$(calc "$amount * $monthly_rate * ($months + 1) / 2")
    local total_payment
    total_payment=$(calc "$amount + $total_interest")

    echo "💰 还款详情（等额本金）"
    echo "────────────────────────────────────────"
    printf "  首月月供:   ¥%s\n" "$(printf "%'.2f" "$first_payment")"
    printf "  末月月供:   ¥%s\n" "$(printf "%'.2f" "$last_payment")"
    printf "  每月递减:   ¥%s\n" "$(printf "%'.2f" "$(calc "$amount * $monthly_rate / $months")")"
    printf "  总还款额:   ¥%s\n" "$(printf "%'.2f" "$total_payment")"
    printf "  总利息:     ¥%s\n" "$(printf "%'.2f" "$total_interest")"
  fi
}

cmd_compare() {
  local amount="${1:?用法: compare <amount> <rate1> <years1> <rate2> <years2>}"
  local rate1="${2:?请提供方案1利率}"
  local years1="${3:?请提供方案1年限}"
  local rate2="${4:?请提供方案2利率}"
  local years2="${5:?请提供方案2年限}"

  local m1 m2 mr1 mr2 pow1 pow2 mp1 mp2 tp1 tp2 ti1 ti2
  m1=$(calc "$years1 * 12")
  m2=$(calc "$years2 * 12")
  mr1=$(calc6 "$rate1 / 100 / 12")
  mr2=$(calc6 "$rate2 / 100 / 12")
  pow1=$(calc6 "(1 + $mr1) ^ $m1")
  pow2=$(calc6 "(1 + $mr2) ^ $m2")
  mp1=$(calc "$amount * $mr1 * $pow1 / ($pow1 - 1)")
  mp2=$(calc "$amount * $mr2 * $pow2 / ($pow2 - 1)")
  tp1=$(calc "$mp1 * $m1")
  tp2=$(calc "$mp2 * $m2")
  ti1=$(calc "$tp1 - $amount")
  ti2=$(calc "$tp2 - $amount")

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           🔄 贷款方案对比
╚══════════════════════════════════════════════════════════╝

贷款金额: ¥$(printf "%'.0f" "$amount")

  指标           方案A          方案B
────────────────────────────────────────────────
  年利率         ${rate1}%          ${rate2}%
  贷款年限       ${years1}年          ${years2}年
  月供           ¥$(printf "%'.2f" "$mp1")   ¥$(printf "%'.2f" "$mp2")
  总还款         ¥$(printf "%'.2f" "$tp1")  ¥$(printf "%'.2f" "$tp2")
  总利息         ¥$(printf "%'.2f" "$ti1")  ¥$(printf "%'.2f" "$ti2")

📊 差异分析
────────────────────────────────────────
  月供差异:   ¥$(printf "%'.2f" "$(calc "$mp1 - $mp2")")
  利息差异:   ¥$(printf "%'.2f" "$(calc "$ti1 - $ti2")")

💡 $(if [ "$(calc "$ti1 < $ti2")" = "1" ]; then echo "方案A总利息更少，更省钱"; else echo "方案B总利息更少，更省钱"; fi)
EOF
}

cmd_prepay() {
  local amount="${1:?用法: prepay <amount> <rate> <years> <prepay_amount> <after_months>}"
  local rate="${2:?请提供年利率}"
  local years="${3:?请提供年限}"
  local prepay="${4:?请提供提前还款金额}"
  local after="${5:?请提供第几个月后提前还款}"

  local months mr pow mp tp ti
  months=$(calc "$years * 12")
  mr=$(calc6 "$rate / 100 / 12")
  pow=$(calc6 "(1 + $mr) ^ $months")
  mp=$(calc "$amount * $mr * $pow / ($pow - 1)")
  tp=$(calc "$mp * $months")
  ti=$(calc "$tp - $amount")

  # After prepayment: remaining principal (simplified)
  local remaining_months
  remaining_months=$(calc "$months - $after")
  local paid_principal
  paid_principal=$(calc "$amount * $after / $months")
  local remaining
  remaining=$(calc "$amount - $paid_principal - $prepay")
  if [ "$(calc "$remaining < 0")" = "1" ]; then remaining=0; fi

  local new_pow new_mp new_tp
  new_pow=$(calc6 "(1 + $mr) ^ $remaining_months")
  new_mp=$(calc "$remaining * $mr * $new_pow / ($new_pow - 1)")
  new_tp=$(calc "$mp * $after + $prepay + $new_mp * $remaining_months")
  local saved
  saved=$(calc "$tp - $new_tp")

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           💵 提前还款分析
╚══════════════════════════════════════════════════════════╝

📋 原贷款信息
────────────────────────────────────────
  贷款金额: ¥$(printf "%'.0f" "$amount")  利率: ${rate}%  期限: ${years}年
  原月供:   ¥$(printf "%'.2f" "$mp")
  原总利息: ¥$(printf "%'.2f" "$ti")

📋 提前还款方案
────────────────────────────────────────
  第${after}期后提前还款: ¥$(printf "%'.0f" "$prepay")
  剩余本金:  ¥$(printf "%'.2f" "$remaining")
  剩余期数:  ${remaining_months}期
  新月供:    ¥$(printf "%'.2f" "$new_mp")

💰 节省分析
────────────────────────────────────────
  预计节省利息: ¥$(printf "%'.2f" "$saved")
  月供减少:     ¥$(printf "%'.2f" "$(calc "$mp - $new_mp")")

💡 提前还款建议
  贷款前1/3时间段提前还款效果最佳
  当前在第${after}期还款，$(if [ "$(calc "$after < $months / 3")" = "1" ]; then echo "✅ 时机较好"; else echo "⚠️ 效果相对有限"; fi)
EOF
}

cmd_afford() {
  local income="${1:?用法: afford <monthly_income> <rate%> <years>}"
  local rate="${2:?请提供年利率}"
  local years="${3:?请提供年限}"

  local max_payment months mr pow max_loan
  max_payment=$(calc "$income * 0.4")
  months=$(calc "$years * 12")
  mr=$(calc6 "$rate / 100 / 12")
  pow=$(calc6 "(1 + $mr) ^ $months")
  max_loan=$(calc "$max_payment * ($pow - 1) / ($mr * $pow)")

  local conservative_payment conservative_loan
  conservative_payment=$(calc "$income * 0.3")
  conservative_loan=$(calc "$conservative_payment * ($pow - 1) / ($mr * $pow)")

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           🏠 贷款能力评估
╚══════════════════════════════════════════════════════════╝

📋 基本信息
────────────────────────────────────────
  月收入:     ¥$(printf "%'.0f" "$income")
  年利率:     ${rate}%
  贷款年限:   ${years}年

💰 可贷额度评估
────────────────────────────────────────
  📊 标准方案 (月供≤收入40%)
     最大月供:   ¥$(printf "%'.2f" "$max_payment")
     可贷额度:   ¥$(printf "%'.0f" "$max_loan")

  📊 保守方案 (月供≤收入30%)
     最大月供:   ¥$(printf "%'.2f" "$conservative_payment")
     可贷额度:   ¥$(printf "%'.0f" "$conservative_loan")

💡 建议
  ✅ 推荐保守方案，留足生活空间
  ⚠️  月供占比超过50%会严重影响生活质量
  💡 考虑公积金贷款可降低利率
EOF
}

cmd_schedule() {
  local amount="${1:?用法: schedule <amount> <rate%> <years> [method]}"
  local rate="${2:?请提供年利率}"
  local years="${3:?请提供年限}"
  local method="${4:-equal-payment}"

  local months mr
  months=$(calc "$years * 12")
  mr=$(calc6 "$rate / 100 / 12")

  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║           📋 还款计划表（前12期）"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""
  printf "  贷款: ¥%s | 利率: %s%% | 期限: %s年 | %s\n\n" \
    "$(printf "%'.0f" "$amount")" "$rate" "$years" \
    "$([ "$method" = "equal-principal" ] && echo "等额本金" || echo "等额本息")"

  printf "  %-6s %-14s %-14s %-14s %-14s\n" "期数" "月供" "本金" "利息" "剩余本金"
  echo "  ─────────────────────────────────────────────────────────────"

  local remaining="$amount"
  if [ "$method" = "equal-payment" ]; then
    local pow mp
    pow=$(calc6 "(1 + $mr) ^ $months")
    mp=$(calc "$amount * $mr * $pow / ($pow - 1)")
    for i in $(seq 1 12); do
      local interest principal
      interest=$(calc "$remaining * $mr")
      principal=$(calc "$mp - $interest")
      remaining=$(calc "$remaining - $principal")
      printf "  %-6s ¥%-12s ¥%-12s ¥%-12s ¥%-12s\n" \
        "$i" "$(printf "%'.2f" "$mp")" "$(printf "%'.2f" "$principal")" \
        "$(printf "%'.2f" "$interest")" "$(printf "%'.2f" "$remaining")"
    done
  else
    local mp_base
    mp_base=$(calc "$amount / $months")
    for i in $(seq 1 12); do
      local interest payment
      interest=$(calc "$remaining * $mr")
      payment=$(calc "$mp_base + $interest")
      remaining=$(calc "$remaining - $mp_base")
      printf "  %-6s ¥%-12s ¥%-12s ¥%-12s ¥%-12s\n" \
        "$i" "$(printf "%'.2f" "$payment")" "$(printf "%'.2f" "$mp_base")" \
        "$(printf "%'.2f" "$interest")" "$(printf "%'.2f" "$remaining")"
    done
  fi
  echo ""
  echo "  ... 共${months}期，以上显示前12期"
}

cmd_refinance() {
  local remaining="${1:?用法: refinance <remaining> <old_rate> <new_rate> <remaining_years>}"
  local old_rate="${2:?请提供原利率}"
  local new_rate="${3:?请提供新利率}"
  local rem_years="${4:?请提供剩余年限}"

  local months mr_old mr_new pow_old pow_new mp_old mp_new
  months=$(calc "$rem_years * 12")
  mr_old=$(calc6 "$old_rate / 100 / 12")
  mr_new=$(calc6 "$new_rate / 100 / 12")
  pow_old=$(calc6 "(1 + $mr_old) ^ $months")
  pow_new=$(calc6 "(1 + $mr_new) ^ $months")
  mp_old=$(calc "$remaining * $mr_old * $pow_old / ($pow_old - 1)")
  mp_new=$(calc "$remaining * $mr_new * $pow_new / ($pow_new - 1)")

  local tp_old tp_new saved
  tp_old=$(calc "$mp_old * $months")
  tp_new=$(calc "$mp_new * $months")
  saved=$(calc "$tp_old - $tp_new")

  local cost="15000"  # estimated refinance cost
  local net_saved
  net_saved=$(calc "$saved - $cost")

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           🔄 再融资/转贷分析
╚══════════════════════════════════════════════════════════╝

📋 当前贷款
────────────────────────────────────────
  剩余本金:   ¥$(printf "%'.0f" "$remaining")
  当前利率:   ${old_rate}%
  剩余年限:   ${rem_years}年
  当前月供:   ¥$(printf "%'.2f" "$mp_old")

📋 转贷后
────────────────────────────────────────
  新利率:     ${new_rate}%
  新月供:     ¥$(printf "%'.2f" "$mp_new")

💰 节省分析
────────────────────────────────────────
  月供减少:     ¥$(printf "%'.2f" "$(calc "$mp_old - $mp_new")")
  总利息节省:   ¥$(printf "%'.2f" "$saved")
  预估转贷成本: ¥$(printf "%'.0f" "$cost") (评估费+手续费等)
  净节省:       ¥$(printf "%'.2f" "$net_saved")

💡 建议
  $(if [ "$(calc "$net_saved > 0")" = "1" ]; then echo "✅ 转贷划算，净节省¥$(printf "%'.0f" "$net_saved")"; else echo "❌ 转贷不划算，节省金额不足以覆盖成本"; fi)
  利差: $(calc "$old_rate - $new_rate")% $(if [ "$(calc "$old_rate - $new_rate > 0.5")" = "1" ]; then echo "(>0.5%，值得考虑)"; else echo "(<0.5%，意义不大)"; fi)
EOF
}

case "$CMD" in
  calculate) cmd_calculate "$@" ;;
  compare)   cmd_compare "$@" ;;
  prepay)    cmd_prepay "$@" ;;
  afford)    cmd_afford "$@" ;;
  schedule)  cmd_schedule "$@" ;;
  refinance) cmd_refinance "$@" ;;
  help)      show_help ;;
  *)
    echo "❌ 未知命令: $CMD"
    echo "运行 'bash loan.sh help' 查看帮助"
    exit 1
    ;;
esac
