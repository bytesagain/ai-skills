#!/usr/bin/env bash
# debt-payoff — 还债策略工具
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
  cat <<'EOF'
╔══════════════════════════════════════════════════════════╗
║              💳 Debt Payoff 还债策略工具                 ║
╚══════════════════════════════════════════════════════════╝

Usage: bash debt.sh <command> [args...]

Commands:
  plan        <total_debt> <monthly_pay> <avg_rate%>    基础还款计划
  snowball    <bal,rate> <bal,rate> [...]                雪球法(先还最小)
  avalanche   <bal,rate> <bal,rate> [...]                雪崩法(先还高利率)
  consolidate <bal,rate> <bal,rate> <new_rate%>          债务合并分析
  negotiate   <debt_type> <amount>                      协商还款技巧
      debt_type: credit-card | loan | mortgage | medical
  timeline    <total_debt> <monthly_pay> <rate%>        还清时间线
  help                                                   显示此帮助

Examples:
  bash debt.sh plan 100000 5000 12
  bash debt.sh snowball 5000,18 20000,12 50000,6
  bash debt.sh avalanche 5000,18 20000,12 50000,6
  bash debt.sh consolidate 30000,18 20000,15 8
  bash debt.sh negotiate credit-card 50000
  bash debt.sh timeline 100000 3000 15

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

calc() { echo "scale=2; $1" | bc -l 2>/dev/null || echo "0"; }
calc0() { echo "scale=0; $1" | bc -l 2>/dev/null || echo "0"; }

cmd_plan() {
  local total="${1:?用法: plan <total_debt> <monthly_payment> <avg_rate%>}"
  local monthly="${2:?请提供每月还款额}"
  local rate="${3:?请提供平均年利率(%)}"

  local monthly_rate monthly_interest
  monthly_rate=$(echo "scale=6; $rate / 100 / 12" | bc -l)
  monthly_interest=$(calc "$total * $monthly_rate")

  if [ "$(calc "$monthly <= $monthly_interest")" = "1" ]; then
    cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           ⚠️ 还款警告
╚══════════════════════════════════════════════════════════╝

❌ 月还款额 ¥$(printf "%'.0f" "$monthly") 不足以覆盖月利息 ¥$(printf "%'.0f" "$monthly_interest")
   债务会越还越多！

💡 建议:
   最低月还款应 > ¥$(printf "%'.0f" "$(calc "$monthly_interest * 1.2")")
   才能开始减少本金
EOF
    return 1
  fi

  # Estimate payoff months
  local months
  months=$(calc0 "-1 * l(1 - $total * $monthly_rate / $monthly) / l(1 + $monthly_rate)" 2>/dev/null || echo "999")
  if [ "$months" = "999" ] || [ -z "$months" ]; then
    months=$(calc0 "$total / ($monthly - $monthly_interest)")
  fi

  local total_paid
  total_paid=$(calc "$monthly * $months")
  local total_interest
  total_interest=$(calc "$total_paid - $total")
  local years
  years=$(calc "$months / 12")

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           📋 基础还款计划
╚══════════════════════════════════════════════════════════╝

📋 债务信息
────────────────────────────────────────
  总债务:     ¥$(printf "%'.0f" "$total")
  年利率:     ${rate}%
  每月还款:   ¥$(printf "%'.0f" "$monthly")
  月利息:     ¥$(printf "%'.0f" "$monthly_interest")

📊 还款预测
────────────────────────────────────────
  预计还清:   ${months}个月 (约${years}年)
  总还款额:   ¥$(printf "%'.0f" "$total_paid")
  总利息:     ¥$(printf "%'.0f" "$total_interest")

📈 如果增加还款额
────────────────────────────────────────
  +¥500/月:  提前约$(calc0 "$months * 0.15")个月还清
  +¥1000/月: 提前约$(calc0 "$months * 0.25")个月还清
  +¥2000/月: 提前约$(calc0 "$months * 0.38")个月还清

💡 加速还债建议
  1. 先建立1个月应急基金
  2. 停止新增债务
  3. 增加收入 (兼职/副业)
  4. 减少非必要开支
  5. 考虑债务合并降低利率
EOF
}

cmd_snowball() {
  if [ $# -lt 2 ]; then
    echo "用法: snowball <balance,rate%> <balance,rate%> [...]"
    echo "示例: snowball 5000,18 20000,12 50000,6"
    return 1
  fi

  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║           ☃️  雪球法还债计划 (Debt Snowball)"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""
  echo "  策略: 先还余额最小的债务 → 快速获得成就感"
  echo ""

  # Parse and sort by balance (ascending)
  local debts=()
  local total_debt=0
  local total_min=0

  for arg in "$@"; do
    debts+=("$arg")
    local bal="${arg%%,*}"
    total_debt=$(calc "$total_debt + $bal")
  done

  # Sort by balance (ascending) - simple bubble sort
  local n=${#debts[@]}
  for ((i=0; i<n; i++)); do
    for ((j=0; j<n-i-1; j++)); do
      local bal1="${debts[$j]%%,*}"
      local bal2="${debts[$((j+1))]%%,*}"
      if [ "$(calc "$bal1 > $bal2")" = "1" ]; then
        local tmp="${debts[$j]}"
        debts[$j]="${debts[$((j+1))]}"
        debts[$((j+1))]="$tmp"
      fi
    done
  done

  echo "📊 还款顺序（按余额从小到大）"
  echo "────────────────────────────────────────"
  local step=1
  for debt in "${debts[@]}"; do
    local bal="${debt%%,*}"
    local rate="${debt##*,}"
    local monthly_int
    monthly_int=$(calc "$bal * $rate / 100 / 12")
    printf "  Step %d: ¥%s (利率%s%%) — 月利息¥%s\n" \
      "$step" "$(printf "%'.0f" "$bal")" "$rate" "$(printf "%'.0f" "$monthly_int")"
    ((step++))
  done

  cat <<EOF

💰 总债务: ¥$(printf "%'.0f" "$total_debt")

📋 执行方法
────────────────────────────────────────
  1. 对所有债务支付最低还款额
  2. 剩余资金全部投入最小余额的债务
  3. 还清一笔后，将该笔月供加到下一笔
  4. 像滚雪球一样，还款速度越来越快

💡 雪球法优势
  ✅ 快速获得"还清"成就感
  ✅ 心理激励效果强
  ✅ 简单易执行
  ⚠️ 总利息可能比雪崩法多一些
EOF
}

cmd_avalanche() {
  if [ $# -lt 2 ]; then
    echo "用法: avalanche <balance,rate%> <balance,rate%> [...]"
    echo "示例: avalanche 5000,18 20000,12 50000,6"
    return 1
  fi

  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║           🏔️  雪崩法还债计划 (Debt Avalanche)"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""
  echo "  策略: 先还利率最高的债务 → 数学上最优，省最多钱"
  echo ""

  local debts=()
  local total_debt=0

  for arg in "$@"; do
    debts+=("$arg")
    local bal="${arg%%,*}"
    total_debt=$(calc "$total_debt + $bal")
  done

  # Sort by rate (descending)
  local n=${#debts[@]}
  for ((i=0; i<n; i++)); do
    for ((j=0; j<n-i-1; j++)); do
      local rate1="${debts[$j]##*,}"
      local rate2="${debts[$((j+1))]##*,}"
      if [ "$(calc "$rate1 < $rate2")" = "1" ]; then
        local tmp="${debts[$j]}"
        debts[$j]="${debts[$((j+1))]}"
        debts[$((j+1))]="$tmp"
      fi
    done
  done

  echo "📊 还款顺序（按利率从高到低）"
  echo "────────────────────────────────────────"
  local step=1
  local total_monthly_int=0
  for debt in "${debts[@]}"; do
    local bal="${debt%%,*}"
    local rate="${debt##*,}"
    local monthly_int
    monthly_int=$(calc "$bal * $rate / 100 / 12")
    total_monthly_int=$(calc "$total_monthly_int + $monthly_int")
    printf "  Step %d: ¥%s @ %s%% — 月利息¥%s\n" \
      "$step" "$(printf "%'.0f" "$bal")" "$rate" "$(printf "%'.0f" "$monthly_int")"
    ((step++))
  done

  cat <<EOF

💰 总债务: ¥$(printf "%'.0f" "$total_debt")
💸 当前月利息合计: ¥$(printf "%'.0f" "$total_monthly_int")

📋 执行方法
────────────────────────────────────────
  1. 对所有债务支付最低还款额
  2. 剩余资金全部投入利率最高的债务
  3. 还清后转移到下一个高利率债务
  4. 数学上最优，节省最多利息

💡 雪崩法优势
  ✅ 总利息最少，最省钱
  ✅ 理性最优解
  ⚠️ 如果高利率债务也是最大的，前期成就感可能不足
  💡 如果感到挫败，可以切换到雪球法
EOF
}

cmd_consolidate() {
  if [ $# -lt 3 ]; then
    echo "用法: consolidate <bal1,rate1> <bal2,rate2> <new_rate%>"
    echo "示例: consolidate 30000,18 20000,15 8"
    return 1
  fi

  local new_rate="${!#}"  # last argument
  local total_debt=0
  local total_monthly_int=0
  local count=0

  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║           🔄 债务合并分析"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""
  echo "📊 当前债务"
  echo "────────────────────────────────────────"

  # Process all args except last (new_rate)
  local args=("$@")
  local num_args=${#args[@]}
  for ((i=0; i<num_args-1; i++)); do
    local debt="${args[$i]}"
    local bal="${debt%%,*}"
    local rate="${debt##*,}"
    local mi
    mi=$(calc "$bal * $rate / 100 / 12")
    total_debt=$(calc "$total_debt + $bal")
    total_monthly_int=$(calc "$total_monthly_int + $mi")
    ((count++))
    echo "  债务${count}: ¥$(printf "%'.0f" "$bal") @ ${rate}% (月利息: ¥$(printf "%'.0f" "$mi"))"
  done

  local new_monthly_int
  new_monthly_int=$(calc "$total_debt * $new_rate / 100 / 12")
  local saved_monthly
  saved_monthly=$(calc "$total_monthly_int - $new_monthly_int")
  local saved_yearly
  saved_yearly=$(calc "$saved_monthly * 12")

  cat <<EOF

📊 合并后
────────────────────────────────────────
  合并总额:   ¥$(printf "%'.0f" "$total_debt")
  新利率:     ${new_rate}%
  新月利息:   ¥$(printf "%'.0f" "$new_monthly_int")

💰 节省分析
────────────────────────────────────────
  原月利息:   ¥$(printf "%'.0f" "$total_monthly_int")
  新月利息:   ¥$(printf "%'.0f" "$new_monthly_int")
  月节省:     ¥$(printf "%'.0f" "$saved_monthly")
  年节省:     ¥$(printf "%'.0f" "$saved_yearly")

$(if [ "$(calc "$saved_monthly > 0")" = "1" ]; then
  echo "  ✅ 合并划算！每月少付¥$(printf "%'.0f" "$saved_monthly")"
else
  echo "  ❌ 合并不划算！新利率反而更高"
fi)

⚠️ 注意事项
────────────────────────────────────────
  • 确认没有提前还款违约金
  • 合并贷款可能有手续费
  • 合并后不要再刷信用卡/借新债
  • 确保新贷款条款透明
EOF
}

cmd_negotiate() {
  local type="${1:?用法: negotiate <debt_type> <amount>}"
  local amount="${2:?请提供债务金额}"

  local type_cn
  case "$type" in
    credit-card) type_cn="信用卡" ;;
    loan)        type_cn="贷款" ;;
    mortgage)    type_cn="房贷" ;;
    medical)     type_cn="医疗费" ;;
    *)           type_cn="$type" ;;
  esac

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           🤝 债务协商技巧: ${type_cn}
╚══════════════════════════════════════════════════════════╝

📋 债务信息
────────────────────────────────────────
  债务类型: ${type_cn}
  债务金额: ¥$(printf "%'.0f" "$amount")

📞 协商步骤
────────────────────────────────────────

  Step 1: 准备工作
  ─────────────────
  • 整理所有债务清单和合同
  • 计算自己的实际还款能力
  • 准备收入证明/困难证明

  Step 2: 主动联系
  ─────────────────
  • 不要等到催收才联系
  • 拨打客服热线，说明困难
  • 态度诚恳，表达还款意愿

  Step 3: 提出方案
  ─────────────────
  • 请求减免利息/滞纳金
  • 提出分期还款计划
  • 给出具体还款时间表
EOF

  case "$type" in
    credit-card)
      cat <<'EOF'

  💳 信用卡专项建议
  ─────────────────
  • 申请"个性化分期"(最长60期)
  • 要求停止计息(停息挂账)
  • 话术: "我有还款意愿，但目前确实困难，
    希望能协商一个双方都能接受的方案"
  • 如拒绝，可投诉到银保监会 12378
EOF
      ;;
    loan)
      cat <<'EOF'

  🏦 贷款专项建议
  ─────────────────
  • 申请延期还款或展期
  • 协商降低月还款额
  • 了解是否有困难减免政策
EOF
      ;;
    mortgage)
      cat <<'EOF'

  🏠 房贷专项建议
  ─────────────────
  • 申请延长贷款期限
  • 协商暂时只还利息
  • 利用LPR重定价降低利率
  • 房贷逾期影响最大，优先处理
EOF
      ;;
    medical)
      cat <<'EOF'

  🏥 医疗费专项建议
  ─────────────────
  • 申请医院减免或分期
  • 了解医疗救助政策
  • 申请慈善基金援助
  • 医疗费通常可协商空间较大
EOF
      ;;
  esac

  cat <<'EOF'

💡 通用话术模板
────────────────────────────────────────
  "您好，我是[姓名]，卡号/合同号是[xxx]。
  由于[失业/疾病/收入下降]，我目前暂时无法按原计划还款。
  但我非常希望能还清这笔债务。
  我目前每月能承受¥[金额]的还款。
  能否帮我申请一个分期方案？"

⚠️ 重要提醒
  • 所有协商结果要求书面/录音确认
  • 不要轻信第三方"代协商"机构
  • 协商期间继续还最低还款额
  • 如遇暴力催收，保留证据投诉
EOF
}

cmd_timeline() {
  local total="${1:?用法: timeline <total_debt> <monthly_payment> <rate%>}"
  local monthly="${2:?请提供每月还款额}"
  local rate="${3:?请提供年利率(%)}"

  local monthly_rate
  monthly_rate=$(echo "scale=6; $rate / 100 / 12" | bc -l)
  local monthly_interest
  monthly_interest=$(calc "$total * $monthly_rate")

  if [ "$(calc "$monthly <= $monthly_interest")" = "1" ]; then
    echo "❌ 月还款额不足以覆盖利息！至少需要 ¥$(printf "%'.0f" "$(calc "$monthly_interest + 1")")"
    return 1
  fi

  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║           📅 还清时间线"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""

  local remaining="$total"
  local total_interest=0
  local month=0

  printf "  %-8s %-16s %-14s %-14s\n" "月份" "剩余本金" "还本金" "付利息"
  echo "  ──────────────────────────────────────────────────────"

  while [ "$(calc "$remaining > 0")" = "1" ] && [ "$month" -lt 600 ]; do
    ((month++))
    local interest principal
    interest=$(calc "$remaining * $monthly_rate")
    principal=$(calc "$monthly - $interest")
    if [ "$(calc "$principal > $remaining")" = "1" ]; then
      principal="$remaining"
    fi
    remaining=$(calc "$remaining - $principal")
    if [ "$(calc "$remaining < 0")" = "1" ]; then remaining="0"; fi
    total_interest=$(calc "$total_interest + $interest")

    # Print milestone months
    if [ "$month" -le 6 ] || [ $((month % 12)) -eq 0 ] || [ "$remaining" = "0" ] || [ "$(calc "$remaining < 1")" = "1" ]; then
      printf "  %-8s ¥%-14s ¥%-12s ¥%-12s\n" \
        "${month}月" "$(printf "%'.0f" "$remaining")" "$(printf "%'.0f" "$principal")" "$(printf "%'.0f" "$interest")"
    fi

    if [ "$(calc "$remaining < 1")" = "1" ]; then break; fi
  done

  local years
  years=$(calc "$month / 12")
  local total_paid
  total_paid=$(calc "$total + $total_interest")

  cat <<EOF

📊 还款总结
────────────────────────────────────────
  总债务:     ¥$(printf "%'.0f" "$total")
  月还款:     ¥$(printf "%'.0f" "$monthly")
  利率:       ${rate}%
  还清时间:   ${month}个月 (约$(printf "%.1f" "$years")年)
  总还款额:   ¥$(printf "%'.0f" "$total_paid")
  总利息:     ¥$(printf "%'.0f" "$total_interest")

📅 预计还清日期: $(date -d "+${month} months" +%Y年%m月 2>/dev/null || echo "约${years}年后")

💡 加速技巧: 每月多还10%可提前约$(calc0 "$month * 0.12")个月还清
EOF
}

case "$CMD" in
  plan)        cmd_plan "$@" ;;
  snowball)    cmd_snowball "$@" ;;
  avalanche)   cmd_avalanche "$@" ;;
  consolidate) cmd_consolidate "$@" ;;
  negotiate)   cmd_negotiate "$@" ;;
  timeline)    cmd_timeline "$@" ;;
  help)        show_help ;;
  *)
    echo "❌ 未知命令: $CMD"
    echo "运行 'bash debt.sh help' 查看帮助"
    exit 1
    ;;
esac
