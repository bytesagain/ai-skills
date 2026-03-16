#!/usr/bin/env bash
# bp.sh — 商业计划书生成器（真实计算版）
# Usage: bash bp.sh <command> [args...]
# Commands: generate, canvas, swot, financial, market, pitch
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

# ── 工具函数 ──
currency_fmt() {
  local n="$1"
  if (( n >= 100000000 )); then
    printf "%.2f亿" "$(echo "scale=2; $n/100000000" | bc)"
  elif (( n >= 10000 )); then
    printf "%.1f万" "$(echo "scale=1; $n/10000" | bc)"
  else
    printf "%d" "$n"
  fi
}

pct() { echo "scale=2; $1 * 100 / $2" | bc 2>/dev/null || echo "0"; }

# ── 生成完整商业计划书 ──
generate_bp() {
  local name="${1:-我的项目}"
  local industry="${2:-科技}"
  local invest="${3:-1000000}"
  local monthly_rev="${4:-200000}"
  local monthly_cost="${5:-150000}"
  local growth="${6:-15}"

  # 财务预测计算
  local y1_rev y2_rev y3_rev
  y1_rev=$(echo "$monthly_rev * 12" | bc)
  y2_rev=$(echo "scale=0; $y1_rev * (100 + $growth) / 100" | bc)
  y3_rev=$(echo "scale=0; $y2_rev * (100 + $growth) / 100" | bc)

  local y1_cost y2_cost y3_cost
  y1_cost=$(echo "$monthly_cost * 12" | bc)
  y2_cost=$(echo "scale=0; $y1_cost * 110 / 100" | bc)
  y3_cost=$(echo "scale=0; $y2_cost * 108 / 100" | bc)

  local y1_profit y2_profit y3_profit
  y1_profit=$(echo "$y1_rev - $y1_cost" | bc)
  y2_profit=$(echo "$y2_rev - $y2_cost" | bc)
  y3_profit=$(echo "$y3_rev - $y3_cost" | bc)

  local bep_months
  if (( monthly_rev > monthly_cost )); then
    bep_months=$(echo "scale=1; $invest / ($monthly_rev - $monthly_cost)" | bc)
  else
    bep_months="N/A (亏损状态)"
  fi

  local y1_margin y2_margin y3_margin
  y1_margin=$(pct "$y1_profit" "$y1_rev")
  y2_margin=$(pct "$y2_profit" "$y2_rev")
  y3_margin=$(pct "$y3_profit" "$y3_rev")

  local roi_3y
  local total_profit
  total_profit=$(echo "$y1_profit + $y2_profit + $y3_profit" | bc)
  roi_3y=$(pct "$total_profit" "$invest")

  cat <<EOF
# 📋 商业计划书 — ${name}

> 生成时间: $(date '+%Y-%m-%d %H:%M')
> 行业: ${industry}

---

## 一、执行摘要

项目「${name}」定位于${industry}行业，初始投资$(currency_fmt "$invest")元。
预计月营收$(currency_fmt "$monthly_rev")元，月成本$(currency_fmt "$monthly_cost")元。
按年增长率${growth}%计算，**${bep_months}个月**可收回投资。

## 二、财务预测（3年）

| 指标 | 第1年 | 第2年 | 第3年 |
|------|-------|-------|-------|
| 营收 | $(currency_fmt "$y1_rev") | $(currency_fmt "$y2_rev") | $(currency_fmt "$y3_rev") |
| 成本 | $(currency_fmt "$y1_cost") | $(currency_fmt "$y2_cost") | $(currency_fmt "$y3_cost") |
| 净利润 | $(currency_fmt "$y1_profit") | $(currency_fmt "$y2_profit") | $(currency_fmt "$y3_profit") |
| 利润率 | ${y1_margin}% | ${y2_margin}% | ${y3_margin}% |

### 关键指标
- 💰 初始投资: $(currency_fmt "$invest")元
- 📈 年增长率: ${growth}%
- ⏰ 盈亏平衡: ${bep_months} 个月
- 📊 3年总利润: $(currency_fmt "$total_profit")元
- 🎯 3年ROI: ${roi_3y}%

## 三、月度现金流预测（第1年）

| 月份 | 累计营收 | 累计成本 | 累计利润 | 投资回收进度 |
|------|----------|----------|----------|------------|
EOF

  local cum_rev=0 cum_cost=0 cum_profit=0
  for m in $(seq 1 12); do
    cum_rev=$(echo "$cum_rev + $monthly_rev" | bc)
    cum_cost=$(echo "$cum_cost + $monthly_cost" | bc)
    cum_profit=$(echo "$cum_rev - $cum_cost" | bc)
    local recovery
    if (( invest > 0 )); then
      recovery=$(pct "$cum_profit" "$invest")
    else
      recovery="∞"
    fi
    echo "| ${m}月 | $(currency_fmt "$cum_rev") | $(currency_fmt "$cum_cost") | $(currency_fmt "$cum_profit") | ${recovery}% |"
  done

  cat <<EOF

## 四、市场分析框架

### TAM/SAM/SOM估算
- **TAM (总可达市场)**: 需根据${industry}行业规模填入
- **SAM (可服务市场)**: TAM × 地理/细分 比例
- **SOM (可获取市场)**: SAM × 市场份额目标

### 竞争格局矩阵
| 维度 | 我方 | 竞品A | 竞品B | 竞品C |
|------|------|-------|-------|-------|
| 价格 | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| 质量 | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |
| 渠道 | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| 品牌 | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |

## 五、团队与运营

### 人力规划
| 阶段 | 人数 | 月人力成本 | 占比 |
|------|------|-----------|------|
EOF
  local hr_cost=$(echo "scale=0; $monthly_cost * 40 / 100" | bc)
  local hr_y2=$(echo "scale=0; $hr_cost * 150 / 100" | bc)
  local hr_y3=$(echo "scale=0; $hr_cost * 200 / 100" | bc)
  echo "| 启动期(Y1) | 5-8人 | $(currency_fmt "$hr_cost") | 40% |"
  echo "| 增长期(Y2) | 10-15人 | $(currency_fmt "$hr_y2") | 45% |"
  echo "| 成熟期(Y3) | 15-25人 | $(currency_fmt "$hr_y3") | 42% |"

  cat <<EOF

## 六、融资需求

| 轮次 | 金额 | 用途 | 出让股份 |
|------|------|------|---------|
| 种子轮 | $(currency_fmt "$invest") | 产品开发+市场验证 | 10-15% |
| Pre-A轮 | $(currency_fmt "$(echo "$invest * 3" | bc)") | 团队扩张+市场推广 | 10-12% |
| A轮 | $(currency_fmt "$(echo "$invest * 10" | bc)") | 规模化增长 | 15-20% |

---

> ⚠️ 本计划书由脚本根据输入参数自动生成，财务数据基于线性模型估算。
> 实际运营需根据市场反馈动态调整。
EOF
}

# ── 精益画布 ──
generate_canvas() {
  local name="${1:-项目}"
  cat <<EOF
# 🎯 精益画布 (Lean Canvas) — ${name}

> 生成时间: $(date '+%Y-%m-%d %H:%M')

┌─────────────────┬─────────────────┬─────────────────┐
│   ❓ 问题        │   💡 解决方案     │   🎯 独特价值     │
│                 │                 │                 │
│ 1. [核心痛点1]   │ 1. [方案1]       │ [一句话价值主张]   │
│ 2. [核心痛点2]   │ 2. [方案2]       │                 │
│ 3. [核心痛点3]   │ 3. [方案3]       │ 高层次概念:       │
│                 │                 │ [类比: X for Y]  │
├─────────────────┼─────────────────┼─────────────────┤
│   📊 关键指标     │   📢 渠道        │   👥 客户细分     │
│                 │                 │                 │
│ · DAU/MAU       │ · 线上: SEO/SEM  │ 早期用户:        │
│ · 转化率         │ · 社交: 微信/抖音 │ [画像描述]       │
│ · 客单价         │ · 线下: [渠道]   │                 │
│ · 留存率         │ · 合作: [伙伴]   │ 目标市场:        │
│ · NPS           │                 │ [画像描述]       │
├─────────────────┼─────────────────┼─────────────────┤
│   💰 成本结构                      │   💵 收入来源                     │
│                                   │                                 │
│ 固定成本:                          │ 主要收入:                        │
│ · 人力: ¥___/月                    │ · [收入模式1]: ¥___/月           │
│ · 房租: ¥___/月                    │ · [收入模式2]: ¥___/月           │
│ · 服务器: ¥___/月                  │                                 │
│ 可变成本:                          │ 辅助收入:                        │
│ · 获客成本(CAC): ¥___/人           │ · [收入模式3]                    │
│ · 运营: ¥___/月                    │ · [收入模式4]                    │
├─────────────────────────────────────────────────────┤
│   🛡️ 不公平优势                                      │
│   [技术壁垒 / 网络效应 / 数据优势 / 品牌 / 专利]       │
└─────────────────────────────────────────────────────┘

## 验证优先级
1. 🔴 最高 — 问题是否真实存在？(客户访谈 ≥ 20人)
2. 🟡 高 — 方案是否可行？(MVP测试)
3. 🟢 中 — 渠道是否有效？(小规模投放)
4. 🔵 低 — 能否规模化？(增长实验)
EOF
}

# ── SWOT分析 ──
generate_swot() {
  local name="${1:-项目}"
  cat <<EOF
# 📊 SWOT分析 — ${name}

> 生成时间: $(date '+%Y-%m-%d %H:%M')

## 分析矩阵

|          | 💪 有利因素 | ⚠️ 不利因素 |
|----------|-----------|-----------|
| 🏠 内部  | **S 优势** | **W 劣势** |
|          | 1. [核心竞争力] | 1. [资源短板] |
|          | 2. [技术优势] | 2. [经验不足] |
|          | 3. [团队优势] | 3. [品牌弱] |
| 🌍 外部  | **O 机会** | **T 威胁** |
|          | 1. [市场增长] | 1. [竞争加剧] |
|          | 2. [政策利好] | 2. [替代品] |
|          | 3. [技术趋势] | 3. [经济下行] |

## 交叉策略矩阵

### SO策略（增长型）— 用优势抓机会
- S1 + O1: [具体策略]
- S2 + O2: [具体策略]

### WO策略（扭转型）— 克服劣势抓机会
- W1 + O1: [具体策略]
- W2 + O3: [具体策略]

### ST策略（防御型）— 用优势应对威胁
- S1 + T1: [具体策略]
- S3 + T2: [具体策略]

### WT策略（收缩型）— 减小劣势避免威胁
- W1 + T1: [具体策略]
- W2 + T3: [具体策略]

## 评分卡（1-5分）

| 因素 | 重要性 | 当前评分 | 加权分 |
|------|--------|---------|--------|
| S1 | 5 | 4 | 20 |
| S2 | 4 | 3 | 12 |
| W1 | 5 | 2 | 10 |
| W2 | 3 | 2 | 6 |
| O1 | 5 | - | - |
| T1 | 4 | - | - |
| **总计** | | | **48** |
EOF
}

# ── 主入口 ──
show_help() {
  cat <<'HELP'
📋 商业计划书生成器 — bp.sh

用法: bash bp.sh <command> [参数]

命令:
  generate <名称> <行业> <投资额> <月营收> <月成本> <年增长率%>
           → 生成完整商业计划书（含3年财务预测+月度现金流）
  canvas [项目名]
           → 生成精益画布(Lean Canvas)模板
  swot [项目名]
           → 生成SWOT分析框架
  help     → 显示帮助

示例:
  bash bp.sh generate "AI写作" "科技" 2000000 500000 300000 20
  bash bp.sh canvas "社区团购"
  bash bp.sh swot "电商平台"

💡 generate命令会自动计算:
  - 3年营收/成本/利润预测
  - 盈亏平衡点
  - 月度现金流
  - ROI回报率
  - 人力成本规划
  - 融资规划
HELP
}

case "$CMD" in
  generate)
    # 解析参数: name industry invest monthly_rev monthly_cost growth
    IFS='|' read -ra ARGS <<< "$(echo "$INPUT" | sed 's/  */|/g')"
    name="${ARGS[0]:-我的项目}"
    industry="${ARGS[1]:-科技}"
    invest="${ARGS[2]:-1000000}"
    monthly_rev="${ARGS[3]:-200000}"
    monthly_cost="${ARGS[4]:-150000}"
    growth="${ARGS[5]:-15}"
    generate_bp "$name" "$industry" "$invest" "$monthly_rev" "$monthly_cost" "$growth"
    ;;
  canvas) generate_canvas "$INPUT" ;;
  swot)   generate_swot "$INPUT" ;;
  help|*) show_help ;;
esac
