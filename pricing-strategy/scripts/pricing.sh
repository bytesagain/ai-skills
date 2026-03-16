#!/usr/bin/env bash
set -euo pipefail

# Pricing Strategy — 定价策略工具
# Usage: bash scripts/pricing.sh <command> [args...]

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
  cat <<'EOF'
Pricing Strategy — 定价策略工具

Commands:
  analyze <cost> <price> <volume>              价格分析 (成本/售价/月销量)
  model <product> <cost> <market> <stage>      推荐定价模型
  compete <my_product:price> <competitors>     竞品定价对比
  bundle <tiers> <discount_levels>             捆绑定价方案
  discount <price> <rate> <volume>             折扣策略分析
  psychology <price> [audience]                价格心理学技巧
  help                                        显示帮助

Examples:
  pricing.sh analyze 50 99 1000
  pricing.sh model "SaaS工具" 30 "B2B" "growth"
  pricing.sh compete "我的产品:99" "竞品A:79,竞品B:129,竞品C:89"
  pricing.sh bundle "基础版:49,专业版:99,企业版:199" "3"
  pricing.sh discount 99 0.20 1000
  pricing.sh psychology 100 "consumer"

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

cmd_analyze() {
  local cost="${1:?请提供单位成本}"
  local price="${2:?请提供售价}"
  local volume="${3:?请提供月销量}"

  awk -v cost="$cost" -v price="$price" -v vol="$volume" '
  BEGIN {
    profit_unit = price - cost
    margin = profit_unit / price * 100
    revenue = price * vol
    total_cost = cost * vol
    total_profit = profit_unit * vol
    markup = profit_unit / cost * 100
    bep = total_cost / price  # break-even in units (fixed cost approx)

    printf "## 💰 价格分析报告\n\n"
    printf "```\n"
    printf "┌──────────────────────────────────────┐\n"
    printf "│          价格分析                     │\n"
    printf "├──────────────────────────────────────┤\n"
    printf "│  单位成本:     ¥%-10.2f             │\n", cost
    printf "│  售价:         ¥%-10.2f             │\n", price
    printf "│  月销量:       %-10d               │\n", vol
    printf "├──────────────────────────────────────┤\n"
    printf "│  单位利润:     ¥%-10.2f             │\n", profit_unit
    printf "│  利润率:       %-8.1f%%              │\n", margin
    printf "│  加价率:       %-8.1f%%              │\n", markup
    printf "├──────────────────────────────────────┤\n"
    printf "│  月营收:       ¥%-12.2f           │\n", revenue
    printf "│  月成本:       ¥%-12.2f           │\n", total_cost
    printf "│  月利润:       ¥%-12.2f           │\n", total_profit
    printf "│  年利润:       ¥%-12.2f           │\n", total_profit * 12
    printf "└──────────────────────────────────────┘\n"
    printf "```\n\n"

    printf "### 利润率评估\n\n"
    if (margin > 60) printf "🟢 **高利润率** (%.1f%%) — 定价空间充足，可考虑市场渗透或品牌溢价策略\n", margin
    else if (margin > 30) printf "🟡 **中等利润率** (%.1f%%) — 合理水平，注意控制成本\n", margin
    else if (margin > 15) printf "🟠 **低利润率** (%.1f%%) — 利润较薄，需要靠规模取胜或提升附加值\n", margin
    else printf "🔴 **微利** (%.1f%%) — 建议重新评估定价策略或降低成本\n", margin

    printf "\n### 敏感性分析\n\n"
    printf "| 售价调整 | 新售价 | 新利润率 | 月利润变化 |\n"
    printf "|---------|--------|---------|----------|\n"
    for (i = -20; i <= 20; i += 10) {
      if (i == 0) continue
      new_price = price * (1 + i/100)
      new_margin = (new_price - cost) / new_price * 100
      new_profit = (new_price - cost) * vol
      delta = new_profit - total_profit
      printf "| %+d%%    | ¥%.0f  | %.1f%%  | %+.0f     |\n", i, new_price, new_margin, delta
    }
  }'
}

cmd_model() {
  local product="${1:?请提供产品名称}"
  local cost="${2:?请提供成本}"
  local market="${3:-B2C}"
  local stage="${4:-growth}"

  cat <<EOF
## 🎯 定价模型推荐

**产品**: ${product}
**成本**: ¥${cost}
**市场**: ${market}
**阶段**: ${stage}

---

EOF

  case "$stage" in
    launch|新品)
      cat <<EOF
### 推荐: 🚀 渗透定价 (Penetration Pricing)

**策略**: 以低于市场均价进入，快速获取市场份额

\`\`\`
建议定价: ¥$(awk "BEGIN{printf \"%.0f\", $cost * 1.3}") - ¥$(awk "BEGIN{printf \"%.0f\", $cost * 1.5}")
加价率:   30% - 50%
目标:     快速获客，建立用户基础
\`\`\`

**适用条件**:
- 市场对价格敏感
- 产品差异化不大
- 规模效应明显
- 能承受短期低利润

**风险**: 低价形象难以提升，利润空间有限
EOF
      ;;
    growth|增长)
      cat <<EOF
### 推荐: 📈 价值定价 (Value-based Pricing)

**策略**: 基于客户感知价值定价，而非成本加成

\`\`\`
建议定价: ¥$(awk "BEGIN{printf \"%.0f\", $cost * 2.5}") - ¥$(awk "BEGIN{printf \"%.0f\", $cost * 4}")
加价率:   150% - 300%
目标:     最大化收入和利润
\`\`\`

**适用条件**:
- 产品有明确差异化
- 客户能感知独特价值
- 有竞争壁垒
- ${market}市场相对成熟

**关键**: 量化产品为客户节省的成本或创造的价值
EOF
      ;;
    mature|成熟)
      cat <<EOF
### 推荐: ⚖️ 竞争定价 (Competitive Pricing)

**策略**: 参考竞品价格，差异化定位

\`\`\`
建议定价: 参考市场均价 ±15%
加价率:   根据竞品调整
目标:     维持市场份额和利润
\`\`\`

**适用条件**:
- 市场竞争充分
- 产品差异化有限
- 客户比价行为明显

**策略变体**: 略高于竞品(品质定位) 或 略低于竞品(性价比定位)
EOF
      ;;
    premium|高端)
      cat <<EOF
### 推荐: 👑 撇脂定价 (Price Skimming)

**策略**: 高价入市，定位高端

\`\`\`
建议定价: ¥$(awk "BEGIN{printf \"%.0f\", $cost * 5}") - ¥$(awk "BEGIN{printf \"%.0f\", $cost * 10}")
加价率:   400% - 900%
目标:     品牌溢价，高利润
\`\`\`

**适用条件**:
- 产品有重大创新
- 品牌影响力强
- 目标客户对价格不敏感
- 竞品短期无法模仿
EOF
      ;;
    *)
      echo "**通用建议**: 成本加成法，加价率50-100%"
      echo ""
      echo "建议定价: ¥$(awk "BEGIN{printf \"%.0f\", $cost * 1.5}") - ¥$(awk "BEGIN{printf \"%.0f\", $cost * 2}")"
      ;;
  esac
}

cmd_compete() {
  local my_product="${1:?请提供你的产品和价格 (名称:价格)}"
  local competitors="${2:?请提供竞品数据 (竞品A:价格,竞品B:价格,...)}"

  local my_name="${my_product%%:*}"
  local my_price="${my_product##*:}"

  echo "## ⚔️ 竞品定价对比"
  echo ""
  echo "| 产品 | 价格 | 价差 | 定位 |"
  echo "|------|------|------|------|"

  printf "| **%s** | **¥%s** | 基准 | 📍 |\n" "$my_name" "$my_price"

  local total_price=$my_price
  local count=1
  local higher=0
  local lower=0

  IFS=',' read -ra comps <<< "$competitors"
  for comp in "${comps[@]}"; do
    local c_name="${comp%%:*}"
    local c_price="${comp##*:}"
    local diff=$((c_price - my_price))
    local position=""
    if (( diff > 0 )); then
      position="高于我 +¥${diff}"
      higher=$((higher + 1))
    elif (( diff < 0 )); then
      position="低于我 ¥${diff}"
      lower=$((lower + 1))
    else
      position="持平"
    fi
    printf "| %s | ¥%s | %+d | %s |\n" "$c_name" "$c_price" "$diff" "$position"
    total_price=$((total_price + c_price))
    count=$((count + 1))
  done

  local avg=$((total_price / count))

  echo ""
  echo "### 📊 市场定位分析"
  echo ""
  echo '```'
  echo "  市场均价: ¥${avg}"
  echo "  你的定价: ¥${my_price}"
  if (( my_price > avg )); then
    echo "  定位: 高于市场均价 (+¥$((my_price - avg)))"
  elif (( my_price < avg )); then
    echo "  定位: 低于市场均价 (-¥$((avg - my_price)))"
  else
    echo "  定位: 等于市场均价"
  fi
  echo "  高于你的竞品: ${higher} 个"
  echo "  低于你的竞品: ${lower} 个"
  echo '```'
}

cmd_bundle() {
  local tiers="${1:?请提供档位数据 (名称:价格,...)}"
  local levels="${2:-3}"

  echo "## 📦 捆绑定价方案"
  echo ""

  IFS=',' read -ra tier_list <<< "$tiers"

  echo "### 当前档位"
  echo ""
  echo "| 档位 | 月付 | 年付(85折) | 节省 |"
  echo "|------|------|-----------|------|"

  local idx=0
  local highlight=$((${#tier_list[@]} / 2))
  for tier in "${tier_list[@]}"; do
    local name="${tier%%:*}"
    local price="${tier##*:}"
    local annual
    annual=$(awk "BEGIN{printf \"%.0f\", $price * 12 * 0.85}")
    local monthly_equiv
    monthly_equiv=$(awk "BEGIN{printf \"%.0f\", $annual / 12}")
    local save=$((price * 12 - annual))
    local star=""
    if (( idx == highlight )); then
      star=" ⭐ 推荐"
    fi
    printf "| %s%s | ¥%s/月 | ¥%s/年 (¥%s/月) | ¥%s |\n" "$name" "$star" "$price" "$annual" "$monthly_equiv" "$save"
    idx=$((idx + 1))
  done

  cat <<'EOF'

### 💡 捆绑定价建议

1. **三档定价法** — 利用锚定效应，中间档最受欢迎
2. **推荐标签** — 给目标档位加"最受欢迎"标签
3. **年付优惠** — 通常月付的80-85%，提升LTV
4. **功能递进** — 每档增加关键功能差异

### 定价心理结构

```
┌──────────┐  ┌──────────────┐  ┌──────────┐
│  基础版   │  │ ⭐ 专业版     │  │  企业版   │
│          │  │ (最受欢迎)    │  │          │
│  ¥49/月  │  │  ¥99/月      │  │  ¥199/月 │
│          │  │              │  │          │
│ 核心功能  │  │ 全部功能      │  │ 定制化    │
│ 个人使用  │  │ 团队协作      │  │ 专属服务   │
└──────────┘  └──────────────┘  └──────────┘
  锚定参照          目标选项          价值感衬托
```
EOF
}

cmd_discount() {
  local price="${1:?请提供原价}"
  local rate="${2:?请提供折扣率 (0-1之间)}"
  local volume="${3:?请提供预期销量}"

  awk -v price="$price" -v rate="$rate" -v vol="$volume" '
  BEGIN {
    discount_price = price * (1 - rate)
    discount_amount = price - discount_price
    revenue_full = price * vol
    # Assume 30% more volume with discount
    vol_boost = vol * 1.3
    revenue_discount = discount_price * vol_boost
    delta = revenue_discount - revenue_full

    printf "## 🏷️ 折扣策略分析\n\n"
    printf "```\n"
    printf "┌───────────────────────────────────────┐\n"
    printf "│           折扣影响分析                  │\n"
    printf "├───────────────────────────────────────┤\n"
    printf "│  原价:       ¥%-10.0f               │\n", price
    printf "│  折扣:       %-.0f%% off              │\n", rate * 100
    printf "│  折后价:     ¥%-10.0f               │\n", discount_price
    printf "│  单件优惠:   ¥%-10.0f               │\n", discount_amount
    printf "├───────────────────────────────────────┤\n"
    printf "│  不打折营收:  ¥%-12.0f (%d件)       │\n", revenue_full, vol
    printf "│  打折后营收:  ¥%-12.0f (%d件,+30%%) │\n", revenue_discount, vol_boost
    printf "│  营收变化:   ¥%-+12.0f              │\n", delta
    printf "└───────────────────────────────────────┘\n"
    printf "```\n\n"

    printf "### 盈亏平衡分析\n\n"
    bep_vol = revenue_full / discount_price
    printf "打折后需要卖出 **%.0f 件** 才能达到原来的营收水平\n", bep_vol
    printf "即销量需要增加 **%.0f%%**\n\n", (bep_vol / vol - 1) * 100

    printf "### 折扣策略建议\n\n"
    if (rate > 0.30) {
      printf "⚠️ 折扣力度较大(>30%%)，注意:\n"
      printf "- 品牌价值可能受损\n"
      printf "- 客户可能等折扣才买\n"
      printf "- 建议限时限量\n"
    } else if (rate > 0.15) {
      printf "🟡 中等折扣(15-30%%):\n"
      printf "- 适合促销活动\n"
      printf "- 注意控制频率\n"
      printf "- 建议搭配会员专享\n"
    } else {
      printf "🟢 温和折扣(<15%%):\n"
      printf "- 对品牌影响小\n"
      printf "- 适合日常优惠\n"
      printf "- 可作为注册/复购激励\n"
    }
  }'
}

cmd_psychology() {
  local price="${1:?请提供价格}"
  local audience="${2:-consumer}"

  cat <<EOF
## 🧠 价格心理学技巧 (¥${price})

### 1. 尾数定价 (Charm Pricing)

\`\`\`
原价: ¥${price}
心理价: ¥$((price - 1))    ← 左位效应，感知便宜很多
高端价: ¥${price}.00      ← 整数=品质感
EOF

  local daily
  daily=$(awk "BEGIN{printf \"%.1f\", $price / 365}")
  local monthly
  monthly=$(awk "BEGIN{printf \"%.1f\", $price / 12}")

  cat <<EOF
\`\`\`

### 2. 框架效应 (Framing)

| 表述方式 | 效果 |
|---------|------|
| "¥${price}" | 中性 |
| "每天只需¥${daily}" | ✅ 金额拆解，感知更低 |
| "每月¥${monthly}" | ✅ 分期概念 |
| "节省¥$(awk "BEGIN{printf \"%.0f\", $price * 0.3}")" | ✅ 得到感 |
| "比竞品便宜30%" | ✅ 对比锚定 |

### 3. 锚定效应 (Anchoring)

\`\`\`
  划掉价: ¥$(awk "BEGIN{printf \"%.0f\", $price * 1.5}")  ← 锚点
  现价:   ¥${price}              ← 目标价
  特价:   ¥$((price - 1))        ← 感知超值
\`\`\`

### 4. 诱饵效应 (Decoy Effect)

\`\`\`
  A 基础版: ¥$(awk "BEGIN{printf \"%.0f\", $price * 0.6}")  (5个功能)
  B 高级版: ¥${price}              (15个功能) ← 目标
  C 诱饵版: ¥$(awk "BEGIN{printf \"%.0f\", $price * 0.9}")  (8个功能)  ← 让B更有吸引力
\`\`\`

### 5. 免费的魔力 (Zero Price Effect)

- "免费试用14天" > "¥1试用14天"
- "买一送一" > "全场五折"
- "免费升级" > "半价升级"

### 6. 稀缺性 (Scarcity)

EOF

  case "$audience" in
    consumer|b2c)
      cat <<'EOF'
**适合消费者的策略:**
- ⏰ "限时特价，还剩2小时"
- 📦 "限量100份"
- 🔥 "已有326人抢购"
- 🎁 "前50名赠送..."
EOF
      ;;
    b2b|business)
      cat <<'EOF'
**适合企业客户的策略:**
- 📊 "帮您节省20%运营成本"
- 🏆 "500+企业的选择"
- 📈 "平均提升转化率35%"
- 🛡️ "30天无条件退款"
EOF
      ;;
    *)
      echo "**通用策略:** 限时优惠 + 社会证明 + 风险逆转"
      ;;
  esac
}

case "$CMD" in
  analyze)     cmd_analyze "$@" ;;
  model)       cmd_model "$@" ;;
  compete)     cmd_compete "$@" ;;
  bundle)      cmd_bundle "$@" ;;
  discount)    cmd_discount "$@" ;;
  psychology)  cmd_psychology "$@" ;;
  help|--help) show_help ;;
  *)
    echo "❌ 未知命令: $CMD"
    echo "运行 'pricing.sh help' 查看帮助"
    exit 1
    ;;
esac
