#!/usr/bin/env bash
set -euo pipefail

# A/B Test Calculator — A/B测试统计计算器
# Usage: bash scripts/abtest.sh <command> [args...]

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
  cat <<'EOF'
A/B Test Calculator — A/B测试统计计算器

Commands:
  calculate <visitorsA> <convA> <visitorsB> <convB>  计算统计显著性
  sample <baseline_rate> <mde> [confidence]          计算最小样本量
  significance <visitorsA> <convA> <visitorsB> <convB> 详细显著性检验
  duration <daily_traffic> <sample_needed>            预估实验天数
  report <visitorsA> <convA> <visitorsB> <convB> [name] 完整报告
  bayesian <visitorsA> <convA> <visitorsB> <convB>    贝叶斯分析
  help                                               显示帮助

Examples:
  abtest.sh calculate 1000 50 1000 65
  abtest.sh sample 0.05 0.02 0.95
  abtest.sh duration 5000 16000
  abtest.sh bayesian 1000 50 1000 65
  abtest.sh report 1000 50 1000 65 "按钮颜色测试"

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

# Helper: calculate z-score approximation (integer math with 4 decimal precision)
# We use awk for floating point since bash doesn't support it natively
calc_stats() {
  local nA="$1" cA="$2" nB="$3" cB="$4"
  awk -v nA="$nA" -v cA="$cA" -v nB="$nB" -v cB="$cB" '
  BEGIN {
    pA = cA / nA
    pB = cB / nB
    p_pool = (cA + cB) / (nA + nB)
    se = sqrt(p_pool * (1 - p_pool) * (1/nA + 1/nB))
    if (se > 0) {
      z = (pB - pA) / se
    } else {
      z = 0
    }
    # Approximate p-value using z-score (two-tailed)
    abs_z = (z < 0) ? -z : z
    # Approximation: p ≈ 2 * exp(-0.5 * z^2) / (abs_z * sqrt(2*3.14159265))
    if (abs_z > 0) {
      p_val = 2 * exp(-0.5 * abs_z * abs_z) / (abs_z * sqrt(2 * 3.14159265))
      if (p_val > 1) p_val = 1
    } else {
      p_val = 1
    }
    lift = (pA > 0) ? ((pB - pA) / pA * 100) : 0
    ci_low = (pB - pA) - 1.96 * se
    ci_high = (pB - pA) + 1.96 * se

    printf "pA=%.4f\n", pA
    printf "pB=%.4f\n", pB
    printf "z=%.4f\n", z
    printf "p_val=%.6f\n", p_val
    printf "lift=%.2f\n", lift
    printf "se=%.6f\n", se
    printf "ci_low=%.6f\n", ci_low
    printf "ci_high=%.6f\n", ci_high
    printf "significant=%s\n", (p_val < 0.05) ? "YES" : "NO"
  }'
}

cmd_calculate() {
  local nA="${1:?用法: calculate <visitorsA> <convA> <visitorsB> <convB>}"
  local cA="${2:?请提供A组转化数}"
  local nB="${3:?请提供B组访客数}"
  local cB="${4:?请提供B组转化数}"

  local stats
  stats=$(calc_stats "$nA" "$cA" "$nB" "$cB")

  local pA pB z p_val lift significant
  pA=$(echo "$stats" | grep '^pA=' | cut -d= -f2)
  pB=$(echo "$stats" | grep '^pB=' | cut -d= -f2)
  z=$(echo "$stats" | grep '^z=' | cut -d= -f2)
  p_val=$(echo "$stats" | grep '^p_val=' | cut -d= -f2)
  lift=$(echo "$stats" | grep '^lift=' | cut -d= -f2)
  significant=$(echo "$stats" | grep '^significant=' | cut -d= -f2)

  local result_icon="❌ 不显著"
  if [[ "$significant" == "YES" ]]; then
    result_icon="✅ 显著"
  fi

  cat <<EOF
## 🧪 A/B测试结果

\`\`\`
┌────────────────────────────────────────┐
│          A/B 测试统计分析               │
├──────────┬──────────┬──────────────────┤
│          │  A组     │  B组              │
├──────────┼──────────┼──────────────────┤
│ 访客数   │  ${nA}   │  ${nB}           │
│ 转化数   │  ${cA}   │  ${cB}           │
│ 转化率   │  ${pA}   │  ${pB}           │
├──────────┴──────────┴──────────────────┤
│                                        │
│  Z值:      ${z}                        │
│  P值:      ${p_val}                    │
│  提升:     ${lift}%                    │
│  结论:     ${result_icon}              │
│  置信度:   95%                         │
│                                        │
└────────────────────────────────────────┘
\`\`\`

EOF

  if [[ "$significant" == "YES" ]]; then
    echo "📊 **结论**: B组转化率显著优于A组，提升 ${lift}%，建议采用B方案。"
  else
    echo "📊 **结论**: 两组差异不具有统计显著性(p > 0.05)，建议继续收集数据。"
  fi
}

cmd_sample() {
  local baseline="${1:?用法: sample <baseline_rate> <mde> [confidence]}"
  local mde="${2:?请提供最小可检测提升(MDE)}"
  local confidence="${3:-0.95}"

  awk -v baseline="$baseline" -v mde="$mde" -v conf="$confidence" '
  BEGIN {
    # Z values for common confidence levels
    if (conf >= 0.99) z_alpha = 2.576
    else if (conf >= 0.95) z_alpha = 1.96
    else if (conf >= 0.90) z_alpha = 1.645
    else z_alpha = 1.96

    z_beta = 0.842  # 80% power

    p1 = baseline
    p2 = baseline + mde
    p_avg = (p1 + p2) / 2

    n = ((z_alpha * sqrt(2 * p_avg * (1 - p_avg)) + z_beta * sqrt(p1 * (1-p1) + p2 * (1-p2)))^2) / (mde^2)
    n = int(n + 0.5)  # round up

    printf "## 📏 样本量计算\n\n"
    printf "```\n"
    printf "┌────────────────────────────────────┐\n"
    printf "│       最小样本量计算                 │\n"
    printf "├────────────────────────────────────┤\n"
    printf "│  基线转化率:    %.2f%%              │\n", p1 * 100
    printf "│  最小可检测提升: %.2f%%              │\n", mde * 100
    printf "│  目标转化率:    %.2f%%              │\n", p2 * 100
    printf "│  置信度:        %.0f%%              │\n", conf * 100
    printf "│  统计功效:      80%%                │\n"
    printf "│                                    │\n"
    printf "│  ✅ 每组最少需要: %d 个样本        │\n", n
    printf "│  ✅ 总计需要:     %d 个样本        │\n", n * 2
    printf "└────────────────────────────────────┘\n"
    printf "```\n\n"
    printf "💡 提示: 每组 %d 个样本，共 %d 个样本，才能以 %.0f%% 的置信度检测到 %.2f%% 的提升。\n", n, n*2, conf*100, mde*100
  }'
}

cmd_significance() {
  local nA="${1:?用法: significance <visitorsA> <convA> <visitorsB> <convB>}"
  local cA="${2:?}"
  local nB="${3:?}"
  local cB="${4:?}"

  local stats
  stats=$(calc_stats "$nA" "$cA" "$nB" "$cB")

  local pA pB z p_val lift se ci_low ci_high significant
  pA=$(echo "$stats" | grep '^pA=' | cut -d= -f2)
  pB=$(echo "$stats" | grep '^pB=' | cut -d= -f2)
  z=$(echo "$stats" | grep '^z=' | cut -d= -f2)
  p_val=$(echo "$stats" | grep '^p_val=' | cut -d= -f2)
  lift=$(echo "$stats" | grep '^lift=' | cut -d= -f2)
  se=$(echo "$stats" | grep '^se=' | cut -d= -f2)
  ci_low=$(echo "$stats" | grep '^ci_low=' | cut -d= -f2)
  ci_high=$(echo "$stats" | grep '^ci_high=' | cut -d= -f2)
  significant=$(echo "$stats" | grep '^significant=' | cut -d= -f2)

  cat <<EOF
## 🔬 详细显著性检验

### 假设检验
- **H₀ (零假设)**: pA = pB (两组无差异)
- **H₁ (备择假设)**: pA ≠ pB (两组有差异)

### 计算结果

| 指标              | 数值          |
|------------------|---------------|
| A组转化率         | ${pA}        |
| B组转化率         | ${pB}        |
| 差异              | $(awk "BEGIN{printf \"%.4f\", $pB - $pA}") |
| 标准误            | ${se}        |
| Z统计量           | ${z}         |
| P值 (双尾)        | ${p_val}     |
| 95%置信区间        | [${ci_low}, ${ci_high}] |
| 相对提升           | ${lift}%     |

### 结论

EOF

  if [[ "$significant" == "YES" ]]; then
    echo "✅ **统计显著** (p < 0.05)"
    echo ""
    echo "在95%置信水平下，B组转化率与A组存在显著差异。"
    echo "效应量约为 ${lift}% 的相对提升。"
  else
    echo "❌ **不显著** (p ≥ 0.05)"
    echo ""
    echo "在95%置信水平下，无法拒绝零假设。两组差异可能是随机波动。"
    echo "建议增加样本量或延长实验时间。"
  fi
}

cmd_duration() {
  local daily_traffic="${1:?用法: duration <daily_traffic> <sample_needed>}"
  local sample_needed="${2:?请提供所需总样本量}"

  awk -v traffic="$daily_traffic" -v needed="$sample_needed" '
  BEGIN {
    per_group = traffic / 2
    days = needed / per_group
    days_ceil = int(days) + (days > int(days) ? 1 : 0)
    weeks = days_ceil / 7.0

    printf "## ⏱️ 实验时长预估\n\n"
    printf "```\n"
    printf "┌──────────────────────────────────┐\n"
    printf "│       实验时长估算                 │\n"
    printf "├──────────────────────────────────┤\n"
    printf "│  日均总流量:     %d              │\n", traffic
    printf "│  每组日均流量:   %d              │\n", per_group
    printf "│  每组所需样本:   %d              │\n", needed
    printf "│                                  │\n"
    printf "│  ✅ 预计需要:    %d 天            │\n", days_ceil
    printf "│  ✅ 约:          %.1f 周          │\n", weeks
    printf "└──────────────────────────────────┘\n"
    printf "```\n\n"

    if (days_ceil > 30) {
      printf "⚠️ 实验时间超过30天，建议:\n"
      printf "- 增大最小可检测效应(MDE)来减少样本量\n"
      printf "- 增加实验流量占比\n"
      printf "- 优先在高流量页面实验\n"
    } else if (days_ceil < 7) {
      printf "⚠️ 实验时间不足7天，建议至少跑满一个完整周以覆盖周末效应。\n"
    } else {
      printf "✅ 实验时长合理，建议跑满 %d 天后分析结果。\n", days_ceil
    }
  }'
}

cmd_report() {
  local nA="${1:?用法: report <visitorsA> <convA> <visitorsB> <convB> [name]}"
  local cA="${2:?}"
  local nB="${3:?}"
  local cB="${4:?}"
  local test_name="${5:-A/B测试}"

  echo "# 📋 A/B测试报告: ${test_name}"
  echo ""
  echo "**报告生成时间**: $(date '+%Y-%m-%d %H:%M:%S')"
  echo ""
  echo "---"
  echo ""

  echo "## 1. 实验概况"
  echo ""
  echo "| 项目 | 详情 |"
  echo "|------|------|"
  echo "| 实验名称 | ${test_name} |"
  echo "| 总样本量 | $((nA + nB)) |"
  echo "| A组样本 | ${nA} |"
  echo "| B组样本 | ${nB} |"
  echo ""

  echo "## 2. 统计分析"
  echo ""
  cmd_calculate "$nA" "$cA" "$nB" "$cB"

  echo ""
  echo "## 3. 详细检验"
  echo ""
  cmd_significance "$nA" "$cA" "$nB" "$cB"

  echo ""
  echo "## 4. 贝叶斯分析"
  echo ""
  cmd_bayesian "$nA" "$cA" "$nB" "$cB"

  echo ""
  echo "## 5. 建议"
  echo ""
  local stats
  stats=$(calc_stats "$nA" "$cA" "$nB" "$cB")
  local significant
  significant=$(echo "$stats" | grep '^significant=' | cut -d= -f2)
  local lift
  lift=$(echo "$stats" | grep '^lift=' | cut -d= -f2)

  if [[ "$significant" == "YES" ]]; then
    cat <<EOF
- ✅ 实验结论: **B方案胜出**
- 📈 转化率提升: ${lift}%
- 🎯 建议: 全量上线B方案
- 📋 后续: 监控1-2周，确认效果稳定
EOF
  else
    cat <<EOF
- ❌ 实验结论: **差异不显著**
- 🎯 建议:
  1. 继续收集数据直到达到所需样本量
  2. 考虑更大胆的变体设计
  3. 检查是否存在分群差异
  4. 确认实验是否覆盖完整业务周期
EOF
  fi
}

cmd_bayesian() {
  local nA="${1:?用法: bayesian <visitorsA> <convA> <visitorsB> <convB>}"
  local cA="${2:?}"
  local nB="${3:?}"
  local cB="${4:?}"

  awk -v nA="$nA" -v cA="$cA" -v nB="$nB" -v cB="$cB" '
  BEGIN {
    pA = cA / nA
    pB = cB / nB

    # Beta distribution parameters (using uniform prior: alpha=1, beta=1)
    alphaA = cA + 1
    betaA = nA - cA + 1
    alphaB = cB + 1
    betaB = nB - cB + 1

    # Mean of Beta distribution = alpha / (alpha + beta)
    meanA = alphaA / (alphaA + betaA)
    meanB = alphaB / (alphaB + betaB)

    # Variance of Beta
    varA = (alphaA * betaA) / ((alphaA + betaA)^2 * (alphaA + betaA + 1))
    varB = (alphaB * betaB) / ((alphaB + betaB)^2 * (alphaB + betaB + 1))

    # Approximate P(B > A) using normal approximation
    diff_mean = meanB - meanA
    diff_std = sqrt(varA + varB)
    if (diff_std > 0) {
      z = diff_mean / diff_std
      # Approximate CDF using logistic approximation
      prob_b_wins = 1 / (1 + exp(-1.7 * z))
    } else {
      prob_b_wins = 0.5
    }

    printf "## 🎲 贝叶斯分析\n\n"
    printf "```\n"
    printf "┌──────────────────────────────────────┐\n"
    printf "│        贝叶斯 A/B 测试分析            │\n"
    printf "├──────────┬──────────┬────────────────┤\n"
    printf "│          │  A组     │  B组            │\n"
    printf "├──────────┼──────────┼────────────────┤\n"
    printf "│ 后验均值  │  %.4f   │  %.4f          │\n", meanA, meanB
    printf "│ 后验方差  │  %.6f │  %.6f        │\n", varA, varB
    printf "│ Beta参数  │  α=%-4d  │  α=%-4d        │\n", alphaA, alphaB
    printf "│          │  β=%-4d  │  β=%-4d        │\n", betaA, betaB
    printf "├──────────┴──────────┴────────────────┤\n"
    printf "│                                      │\n"
    printf "│  🎯 B优于A的概率: %.1f%%              │\n", prob_b_wins * 100
    printf "│  📊 期望提升: %.2f%%                  │\n", (meanB - meanA) / meanA * 100
    printf "│                                      │\n"
    printf "└──────────────────────────────────────┘\n"
    printf "```\n\n"

    if (prob_b_wins > 0.95) {
      printf "✅ 贝叶斯结论: B方案有 %.1f%% 的概率优于A方案，可以放心采用。\n", prob_b_wins * 100
    } else if (prob_b_wins > 0.80) {
      printf "🟡 贝叶斯结论: B方案有 %.1f%% 的概率优于A方案，有一定优势但建议继续观察。\n", prob_b_wins * 100
    } else if (prob_b_wins > 0.50) {
      printf "⚠️ 贝叶斯结论: B方案仅有 %.1f%% 的概率优于A方案，差异不明显。\n", prob_b_wins * 100
    } else {
      printf "❌ 贝叶斯结论: A方案有 %.1f%% 的概率优于B方案。\n", (1 - prob_b_wins) * 100
    }
  }'
}

case "$CMD" in
  calculate)     cmd_calculate "$@" ;;
  sample)        cmd_sample "$@" ;;
  significance)  cmd_significance "$@" ;;
  duration)      cmd_duration "$@" ;;
  report)        cmd_report "$@" ;;
  bayesian)      cmd_bayesian "$@" ;;
  help|--help)   show_help ;;
  *)
    echo "❌ 未知命令: $CMD"
    echo "运行 'abtest.sh help' 查看帮助"
    exit 1
    ;;
esac
