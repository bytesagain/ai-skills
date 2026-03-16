#!/usr/bin/env bash
# retirement-planner — 退休规划工具
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
  cat <<'EOF'
╔══════════════════════════════════════════════════════════╗
║           🏖️ Retirement Planner 退休规划工具             ║
╚══════════════════════════════════════════════════════════╝

Usage: bash retire.sh <command> [args...]

Commands:
  calculate      <age> <retire_age> <monthly_expense>      计算退休所需资金
  strategy       <age> <monthly_savings> <risk_level>       投资策略建议
      risk_level: low | medium | high
  social-security <age> <salary> <years_paid>               估算社保养老金
  invest         <amount> <years> <risk_level>              退休投资组合
  withdraw       <savings> <monthly_need> [strategy]        提取策略
      strategy: fixed | percent | bucket
  gap            <age> <ret_age> <expense> <savings>        资金缺口分析
  help                                                      显示此帮助

Examples:
  bash retire.sh calculate 35 60 8000
  bash retire.sh strategy 30 5000 medium
  bash retire.sh social-security 35 15000 10
  bash retire.sh invest 500000 20 medium
  bash retire.sh withdraw 2000000 10000 bucket
  bash retire.sh gap 40 60 10000 300000

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

calc() { echo "scale=2; $1" | bc -l 2>/dev/null || echo "0"; }
calc0() { echo "scale=0; $1" | bc -l 2>/dev/null || echo "0"; }

cmd_calculate() {
  local age="${1:?用法: calculate <age> <retire_age> <monthly_expense>}"
  local retire_age="${2:?请提供退休年龄}"
  local monthly="${3:?请提供退休后月开销}"

  local years_to_retire life_expect retire_years
  years_to_retire=$(calc "$retire_age - $age")
  life_expect=85
  retire_years=$(calc "$life_expect - $retire_age")

  # Factor in inflation (3%)
  local inflation="1.03"
  local future_monthly
  future_monthly=$(calc "$monthly * $inflation ^ $years_to_retire")
  local total_needed
  total_needed=$(calc "$future_monthly * 12 * $retire_years")

  # Monthly savings needed (assuming 6% return)
  local return_rate="0.06"
  local months_to_save
  months_to_save=$(calc0 "$years_to_retire * 12")
  local monthly_r
  monthly_r=$(calc "$return_rate / 12")
  # FV of annuity formula simplified
  local monthly_save
  monthly_save=$(calc "$total_needed / ($months_to_save * 1.5)")

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           🏖️ 退休资金需求计算
╚══════════════════════════════════════════════════════════╝

📋 基本假设
────────────────────────────────────────
  当前年龄:     ${age}岁
  计划退休:     ${retire_age}岁
  距退休:       ${years_to_retire}年
  预期寿命:     ${life_expect}岁
  退休生活:     ${retire_years}年
  通胀率假设:   3%/年

💰 资金需求
────────────────────────────────────────
  当前月开销:   ¥$(printf "%'.0f" "$monthly")
  退休时月开销: ¥$(printf "%'.0f" "$future_monthly") (通胀调整后)
  退休期年开销: ¥$(printf "%'.0f" "$(calc "$future_monthly * 12")")

  📊 总需求:    ¥$(printf "%'.0f" "$total_needed")

💡 储蓄建议
────────────────────────────────────────
  假设年化收益6%，每月需储蓄:
  ¥$(printf "%'.0f" "$monthly_save")

📊 退休资金构成建议
────────────────────────────────────────
  社保养老金:  约占 30-40%
  个人储蓄:    约占 30-40%
  投资收益:    约占 20-30%

⚠️  以上为估算，建议定期重新评估
EOF
}

cmd_strategy() {
  local age="${1:?用法: strategy <age> <monthly_savings> <risk_level>}"
  local savings="${2:?请提供每月可储蓄金额}"
  local risk="${3:-medium}"

  local risk_cn stock_pct bond_pct cash_pct expected_return
  case "$risk" in
    low)
      risk_cn="保守型" stock_pct=20 bond_pct=60 cash_pct=20 expected_return="4-5%"
      ;;
    medium)
      risk_cn="平衡型" stock_pct=50 bond_pct=35 cash_pct=15 expected_return="6-8%"
      ;;
    high)
      risk_cn="进取型" stock_pct=80 bond_pct=15 cash_pct=5 expected_return="8-12%"
      ;;
    *) risk_cn="$risk" stock_pct=50 bond_pct=35 cash_pct=15 expected_return="6-8%" ;;
  esac

  # Age-based adjustment
  local age_adjust=""
  if [ "$age" -lt 30 ]; then
    age_adjust="年轻可以适当提高风险偏好"
  elif [ "$age" -lt 45 ]; then
    age_adjust="黄金积累期，平衡配置为宜"
  elif [ "$age" -lt 55 ]; then
    age_adjust="接近退休，应逐步降低风险"
  else
    age_adjust="临近/已退休，以保本为主"
  fi

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           📊 退休投资策略建议
╚══════════════════════════════════════════════════════════╝

📋 个人信息
────────────────────────────────────────
  年龄:         ${age}岁
  每月储蓄:     ¥$(printf "%'.0f" "$savings")
  风险偏好:     ${risk_cn}
  年龄建议:     ${age_adjust}

📊 资产配置建议
────────────────────────────────────────
  权益类(股票/基金):  ${stock_pct}%  $(printf '%*s' "$((stock_pct/5))" '' | tr ' ' '█')
  固收类(债券/存款):  ${bond_pct}%  $(printf '%*s' "$((bond_pct/5))" '' | tr ' ' '█')
  现金/货币基金:      ${cash_pct}%  $(printf '%*s' "$((cash_pct/5))" '' | tr ' ' '█')
  预期年化收益:       ${expected_return}

💰 每月定投建议
────────────────────────────────────────
  权益类:  ¥$(printf "%'.0f" "$(calc "$savings * $stock_pct / 100")")  → 指数基金/混合基金
  固收类:  ¥$(printf "%'.0f" "$(calc "$savings * $bond_pct / 100")")  → 债券基金/国债
  现金类:  ¥$(printf "%'.0f" "$(calc "$savings * $cash_pct / 100")")  → 货币基金/银行存款

📈 10/20/30年预估 (按中等收益)
────────────────────────────────────────
  10年后:  ¥$(printf "%'.0f" "$(calc "$savings * 12 * 10 * 1.4")")
  20年后:  ¥$(printf "%'.0f" "$(calc "$savings * 12 * 20 * 2.0")")
  30年后:  ¥$(printf "%'.0f" "$(calc "$savings * 12 * 30 * 3.0")")

💡 策略调整建议
  • 每年检视一次资产配置
  • 年龄增长逐步降低权益占比（100-年龄 = 权益比例参考）
  • 不要频繁交易，长期持有
EOF
}

cmd_social_security() {
  local age="${1:?用法: social-security <age> <salary> <years_paid>}"
  local salary="${2:?请提供当前月薪}"
  local years="${3:?请提供已缴社保年数}"

  local retire_age=60
  local total_years
  total_years=$(calc "$years + ($retire_age - $age)")
  if [ "$(calc "$total_years < 15")" = "1" ]; then
    total_years=15
  fi

  # Simplified Chinese pension formula
  # 基础养老金 ≈ 当地平均工资 × (1 + 缴费指数) / 2 × 缴费年限 × 1%
  # 个人账户养老金 ≈ 个人账户累计 / 计发月数(60岁=139)
  local avg_salary=8000  # simplified average
  local pay_index
  pay_index=$(calc "$salary / $avg_salary")
  if [ "$(calc "$pay_index > 3")" = "1" ]; then pay_index="3.00"; fi

  local base_pension
  base_pension=$(calc "$avg_salary * (1 + $pay_index) / 2 * $total_years * 0.01")
  local personal_account
  personal_account=$(calc "$salary * 0.08 * 12 * $total_years")
  local account_pension
  account_pension=$(calc "$personal_account / 139")
  local total_pension
  total_pension=$(calc "$base_pension + $account_pension")

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           🏛️ 社保养老金估算
╚══════════════════════════════════════════════════════════╝

📋 缴费信息
────────────────────────────────────────
  当前年龄:     ${age}岁
  当前月薪:     ¥$(printf "%'.0f" "$salary")
  已缴年数:     ${years}年
  预计退休:     ${retire_age}岁
  预计总缴费:   ${total_years}年

💰 养老金估算
────────────────────────────────────────
  基础养老金:   ¥$(printf "%'.0f" "$base_pension")/月
  (当地平均工资 × (1+缴费指数)/2 × 缴费年限 × 1%)

  个人账户养老金: ¥$(printf "%'.0f" "$account_pension")/月
  (个人账户累计 ÷ 139个月)

  ═══════════════════════════
  合计预估:     ¥$(printf "%'.0f" "$total_pension")/月
  年养老金:     ¥$(printf "%'.0f" "$(calc "$total_pension * 12")")/年
  ═══════════════════════════

📊 替代率分析
────────────────────────────────────────
  工资替代率:   $(calc0 "$total_pension * 100 / $salary")%
  (养老金 / 退休前工资)
  建议替代率:   70-80% (含个人储蓄)

💡 提升养老金建议
  ✅ 延长缴费年限（每多缴1年，基础养老金多1%）
  ✅ 提高缴费基数（影响个人账户积累）
  ✅ 补充商业养老保险
  ✅ 个人养老金账户（每年1.2万额度）

⚠️  以上为简化估算，实际以社保局核算为准
EOF
}

cmd_invest() {
  local amount="${1:?用法: invest <amount> <years> <risk_level>}"
  local years="${2:?请提供投资年限}"
  local risk="${3:-medium}"

  local risk_cn
  case "$risk" in
    low)    risk_cn="保守型" ;;
    medium) risk_cn="平衡型" ;;
    high)   risk_cn="进取型" ;;
    *)      risk_cn="$risk" ;;
  esac

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           💼 退休投资组合建议
╚══════════════════════════════════════════════════════════╝

📋 投资信息
────────────────────────────────────────
  投资金额:   ¥$(printf "%'.0f" "$amount")
  投资期限:   ${years}年
  风险偏好:   ${risk_cn}

📊 推荐组合
────────────────────────────────────────
EOF

  case "$risk" in
    low)
      cat <<EOF
  💵 货币基金/银行存款    30%   ¥$(printf "%'.0f" "$(calc "$amount * 0.30")")
  📄 国债/政策性金融债    40%   ¥$(printf "%'.0f" "$(calc "$amount * 0.40")")
  📊 债券基金             20%   ¥$(printf "%'.0f" "$(calc "$amount * 0.20")")
  📈 宽基指数基金         10%   ¥$(printf "%'.0f" "$(calc "$amount * 0.10")")

  预期年化: 3-5%
  ${years}年后预估: ¥$(printf "%'.0f" "$(calc "$amount * 1.04 ^ $years")")
EOF
      ;;
    medium)
      cat <<EOF
  💵 货币基金/存款        15%   ¥$(printf "%'.0f" "$(calc "$amount * 0.15")")
  📄 债券基金             25%   ¥$(printf "%'.0f" "$(calc "$amount * 0.25")")
  📊 混合基金             30%   ¥$(printf "%'.0f" "$(calc "$amount * 0.30")")
  📈 指数基金(沪深300等)  20%   ¥$(printf "%'.0f" "$(calc "$amount * 0.20")")
  🌍 海外指数(标普500等)  10%   ¥$(printf "%'.0f" "$(calc "$amount * 0.10")")

  预期年化: 6-8%
  ${years}年后预估: ¥$(printf "%'.0f" "$(calc "$amount * 1.07 ^ $years")")
EOF
      ;;
    high)
      cat <<EOF
  💵 货币基金             5%    ¥$(printf "%'.0f" "$(calc "$amount * 0.05")")
  📄 债券基金             10%   ¥$(printf "%'.0f" "$(calc "$amount * 0.10")")
  📈 主动管理基金         30%   ¥$(printf "%'.0f" "$(calc "$amount * 0.30")")
  📈 指数基金             30%   ¥$(printf "%'.0f" "$(calc "$amount * 0.30")")
  🌍 海外/新兴市场        15%   ¥$(printf "%'.0f" "$(calc "$amount * 0.15")")
  ₿  另类投资(REITs等)    10%   ¥$(printf "%'.0f" "$(calc "$amount * 0.10")")

  预期年化: 8-12%
  ${years}年后预估: ¥$(printf "%'.0f" "$(calc "$amount * 1.10 ^ $years")")
EOF
      ;;
  esac

  cat <<'EOF'

💡 投资原则
────────────────────────────────────────
  ✅ 分散投资，不把鸡蛋放一个篮子
  ✅ 定期再平衡（每年1-2次）
  ✅ 长期持有，不频繁交易
  ✅ 随年龄增长逐步降低风险

⚠️  以上不构成投资建议，投资有风险
EOF
}

cmd_withdraw() {
  local savings="${1:?用法: withdraw <savings> <monthly_need> [strategy]}"
  local monthly="${2:?请提供每月需要金额}"
  local strategy="${3:-fixed}"

  local annual
  annual=$(calc "$monthly * 12")

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           💸 退休提取策略
╚══════════════════════════════════════════════════════════╝

📋 基本信息
────────────────────────────────────────
  总储蓄:     ¥$(printf "%'.0f" "$savings")
  每月需求:   ¥$(printf "%'.0f" "$monthly")
  年需求:     ¥$(printf "%'.0f" "$annual")
EOF

  case "$strategy" in
    fixed)
      local years_last
      years_last=$(calc0 "$savings / $annual")
      cat <<EOF

📊 固定金额提取法
────────────────────────────────────────
  每月提取:  ¥$(printf "%'.0f" "$monthly") (固定)
  可维持:    约${years_last}年 (不考虑投资收益)
  考虑3%收益: 约$(calc0 "$years_last * 1.3")年

  优点: 简单，收入稳定可预期
  缺点: 不抗通胀，可能提前耗尽
  适合: 有其他固定收入来源者
EOF
      ;;
    percent)
      local withdraw_pct="4"
      local first_year
      first_year=$(calc "$savings * $withdraw_pct / 100")
      cat <<EOF

📊 固定比例提取法 (${withdraw_pct}%法则)
────────────────────────────────────────
  提取比例:   每年提取总资产的${withdraw_pct}%
  第1年提取:  ¥$(printf "%'.0f" "$first_year")
  月均:       ¥$(printf "%'.0f" "$(calc "$first_year / 12")")

  📈 各年提取预估 (假设年化收益5%)
  第1年:  ¥$(printf "%'.0f" "$(calc "$savings * 0.04")")
  第5年:  ¥$(printf "%'.0f" "$(calc "$savings * 1.05 ^ 4 * 0.96 ^ 4 * 0.04")")
  第10年: ¥$(printf "%'.0f" "$(calc "$savings * 1.05 ^ 9 * 0.96 ^ 9 * 0.04")")

  优点: 自动调节，本金长期保值
  缺点: 收入随市场波动
  适合: 有一定风险承受能力者
EOF
      ;;
    bucket)
      local bucket1 bucket2 bucket3
      bucket1=$(calc "$savings * 0.20")
      bucket2=$(calc "$savings * 0.40")
      bucket3=$(calc "$savings * 0.40")
      cat <<EOF

📊 桶策略 (三桶配置)
────────────────────────────────────────

  🪣 短期桶 (1-3年开销) — 20%
     金额: ¥$(printf "%'.0f" "$bucket1")
     投向: 活期/货币基金/短期存款
     作用: 日常开销，随用随取

  🪣 中期桶 (3-7年) — 40%
     金额: ¥$(printf "%'.0f" "$bucket2")
     投向: 债券基金/固定收益产品
     作用: 稳定增值，定期补充短期桶

  🪣 长期桶 (7年+) — 40%
     金额: ¥$(printf "%'.0f" "$bucket3")
     投向: 指数基金/权益类资产
     作用: 对抗通胀，长期增长

  操作规则:
  • 日常从短期桶取钱
  • 每年从中期桶补充短期桶
  • 每2-3年从长期桶补充中期桶

  优点: 兼顾安全和增长
  缺点: 管理稍复杂
  适合: 大多数退休人士（推荐）
EOF
      ;;
  esac
}

cmd_gap() {
  local age="${1:?用法: gap <age> <retire_age> <monthly_expense> <current_savings>}"
  local retire_age="${2:?请提供退休年龄}"
  local monthly="${3:?请提供退休后月开销}"
  local current="${4:?请提供当前储蓄}"

  local years_to
  years_to=$(calc "$retire_age - $age")
  local retire_years=25  # assume 25 years in retirement
  local total_needed
  total_needed=$(calc "$monthly * 1.03 ^ $years_to * 12 * $retire_years")

  # Assume current savings grow at 5%
  local future_savings
  future_savings=$(calc "$current * 1.05 ^ $years_to")

  local gap
  gap=$(calc "$total_needed - $future_savings")
  if [ "$(calc "$gap < 0")" = "1" ]; then gap="0"; fi

  local monthly_save
  if [ "$gap" != "0" ]; then
    monthly_save=$(calc "$gap / ($years_to * 12 * 1.3)")
  else
    monthly_save="0"
  fi

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           📊 退休资金缺口分析
╚══════════════════════════════════════════════════════════╝

📋 基本信息
────────────────────────────────────────
  当前年龄:     ${age}岁
  退休年龄:     ${retire_age}岁
  距退休:       ${years_to}年
  当前储蓄:     ¥$(printf "%'.0f" "$current")
  退休后月开销: ¥$(printf "%'.0f" "$monthly")

📊 资金需求 vs 资源
────────────────────────────────────────
  退休所需总资金:    ¥$(printf "%'.0f" "$total_needed")
  现有储蓄未来价值:  ¥$(printf "%'.0f" "$future_savings")
  ─────────────────────────
  资金缺口:          ¥$(printf "%'.0f" "$gap")

$(if [ "$gap" = "0" ]; then
  echo "  ✅ 恭喜！按当前节奏，退休资金充足！"
else
  echo "  ⚠️  存在资金缺口，需要额外储蓄"
fi)

💡 填补方案
────────────────────────────────────────
$(if [ "$gap" != "0" ]; then
  echo "  每月额外储蓄: ¥$(printf "%'.0f" "$monthly_save")"
  echo ""
  echo "  缩小缺口的方法:"
  echo "  1. 💰 增加每月储蓄"
  echo "  2. 📈 提高投资收益率"
  echo "  3. ⏰ 延迟退休1-3年"
  echo "  4. 📉 适当降低退休开销预期"
  echo "  5. 🏛️ 确保社保缴满15年以上"
else
  echo "  继续保持当前储蓄习惯"
  echo "  定期复查，应对通胀变化"
fi)

⚠️  以上为简化估算，建议每年重新评估
EOF
}

case "$CMD" in
  calculate)       cmd_calculate "$@" ;;
  strategy)        cmd_strategy "$@" ;;
  social-security) cmd_social_security "$@" ;;
  invest)          cmd_invest "$@" ;;
  withdraw)        cmd_withdraw "$@" ;;
  gap)             cmd_gap "$@" ;;
  help)            show_help ;;
  *)
    echo "❌ 未知命令: $CMD"
    echo "运行 'bash retire.sh help' 查看帮助"
    exit 1
    ;;
esac
