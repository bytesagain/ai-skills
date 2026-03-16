#!/usr/bin/env bash
# Comparison Table — create, product, tech, pricing, feature, export
# Usage: bash compare.sh <command> [args]

CMD="$1"; shift 2>/dev/null; INPUT="$*"

# Parse comma-separated items
parse_items() {
  local input="$1"
  IFS=',' read -ra ITEMS <<< "$input"
  CLEAN_ITEMS=()
  for item in "${ITEMS[@]}"; do
    item=$(echo "$item" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    [[ -n "$item" ]] && CLEAN_ITEMS+=("$item")
  done
}

# Print table separator
print_sep() {
  local cols=$1
  printf '%s' "├──────────────────┤"
  for ((i=0; i<cols; i++)); do
    printf '%s' "──────────────┤"
  done
  echo ""
}

# Print header separator
print_header_sep() {
  local cols=$1
  printf '%s' "┌──────────────────┬"
  for ((i=0; i<cols; i++)); do
    if ((i < cols-1)); then
      printf '%s' "──────────────┬"
    else
      printf '%s' "──────────────┐"
    fi
  done
  echo ""
}

# Print footer
print_footer() {
  local cols=$1
  printf '%s' "└──────────────────┴"
  for ((i=0; i<cols; i++)); do
    if ((i < cols-1)); then
      printf '%s' "──────────────┴"
    else
      printf '%s' "──────────────┘"
    fi
  done
  echo ""
}

case "$CMD" in
  create)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
📊 自定义对比表 (Create Comparison)

用法: create <项目1>, <项目2>, <项目3>...

示例:
  create React, Vue, Angular
  create Python, JavaScript, Go
  create AWS, Azure, GCP

输出通用对比表模板

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    parse_items "$INPUT"
    NUM=${#CLEAN_ITEMS[@]}

    echo "📊 通用对比表"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Markdown table
    echo "### Markdown 格式"
    echo ""
    printf "| 对比维度 |"
    for item in "${CLEAN_ITEMS[@]}"; do printf " %s |" "$item"; done
    echo ""
    printf "|----------|"
    for item in "${CLEAN_ITEMS[@]}"; do printf '%s' '------|'; done
    echo ""

    DIMS=("简介" "核心优势" "适用场景" "学习曲线" "社区生态" "性能表现" "文档质量" "总评")
    for dim in "${DIMS[@]}"; do
      printf "| %-8s |" "$dim"
      for item in "${CLEAN_ITEMS[@]}"; do printf " ___  |"; done
      echo ""
    done

    echo ""
    echo "### 可视化对比"
    echo ""
    print_header_sep "$NUM"
    printf "│ %-16s │" "对比维度"
    for item in "${CLEAN_ITEMS[@]}"; do printf " %-12s │" "${item::12}"; done
    echo ""
    print_sep "$NUM"

    for dim in "${DIMS[@]}"; do
      printf "│ %-16s │" "$dim"
      for item in "${CLEAN_ITEMS[@]}"; do printf " %-12s │" "______"; done
      echo ""
    done

    print_footer "$NUM"
    echo ""
    echo "💡 填写后即可得到完整对比分析"
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;

  product)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
🛍️ 产品对比 (Product Comparison)

用法: product <产品1>, <产品2>, <产品3>...

示例:
  product iPhone 15, Galaxy S24, Pixel 8
  product MacBook Pro, ThinkPad X1, XPS 15

输出含: 价格、性能、设计、续航、生态、售后

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    parse_items "$INPUT"
    NUM=${#CLEAN_ITEMS[@]}

    echo "🛍️ 产品对比表"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    printf "| 产品维度 |"
    for item in "${CLEAN_ITEMS[@]}"; do printf " %s |" "$item"; done
    echo ""
    printf "|----------|"
    for item in "${CLEAN_ITEMS[@]}"; do printf '%s' '------|'; done
    echo ""

    DIMS=("💰 价格" "⚡ 性能" "🎨 设计" "🔋 续航" "📱 生态" "🛠️ 售后" "⭐ 评分" "🎯 适合人群")
    for dim in "${DIMS[@]}"; do
      printf "| %-10s |" "$dim"
      for item in "${CLEAN_ITEMS[@]}"; do printf " ___  |"; done
      echo ""
    done

    echo ""
    echo "### 评分雷达图 (1-5星)"
    echo ""
    RADAR_DIMS=("价格" "性能" "设计" "续航" "生态")
    for item in "${CLEAN_ITEMS[@]}"; do
      echo "  📌 $item"
      for dim in "${RADAR_DIMS[@]}"; do
        echo "    $dim: ☆☆☆☆☆"
      done
      echo ""
    done
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;

  tech)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
🔧 技术选型对比 (Tech Comparison)

用法: tech <技术1>, <技术2>, <技术3>...

示例:
  tech PostgreSQL, MySQL, MongoDB
  tech Docker, Kubernetes, Nomad
  tech React, Vue, Svelte

输出含: 性能、学习曲线、生态、社区、文档、适用场景

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    parse_items "$INPUT"
    NUM=${#CLEAN_ITEMS[@]}

    echo "🔧 技术选型对比"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    printf "| 技术维度 |"
    for item in "${CLEAN_ITEMS[@]}"; do printf " %s |" "$item"; done
    echo ""
    printf "|----------|"
    for item in "${CLEAN_ITEMS[@]}"; do printf '%s' '------|'; done
    echo ""

    DIMS=("类型/定位" "⚡ 性能" "📚 学习曲线" "🌍 生态/插件" "👥 社区活跃" "📖 文档质量" "🏢 企业采用" "🔄 更新频率" "📦 包大小" "🛡️ 安全性" "🎯 最适场景" "⚠️ 不适场景")
    for dim in "${DIMS[@]}"; do
      printf "| %-12s |" "$dim"
      for item in "${CLEAN_ITEMS[@]}"; do printf " ___  |"; done
      echo ""
    done

    echo ""
    echo "### 决策建议"
    echo ""
    echo "  选 ${CLEAN_ITEMS[0]} 如果: ______"
    for ((i=1; i<NUM; i++)); do
      echo "  选 ${CLEAN_ITEMS[$i]} 如果: ______"
    done
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;

  pricing)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
💰 定价方案对比 (Pricing Comparison)

用法: pricing <方案1>, <方案2>, <方案3>...

示例:
  pricing 基础版, 专业版, 企业版
  pricing Free, Pro, Enterprise
  pricing 月付, 年付

输出含: 价格、功能、限制、适合用户

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    parse_items "$INPUT"
    NUM=${#CLEAN_ITEMS[@]}

    echo "💰 定价方案对比"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Visual pricing cards
    for item in "${CLEAN_ITEMS[@]}"; do
      echo "┌─────────────────────────────┐"
      printf "│  %-27s│\n" "$item"
      echo "├─────────────────────────────┤"
      echo "│  💲 价格: ___/月             │"
      echo "│  💲 年付: ___/年 (省__%)     │"
      echo "│                             │"
      echo "│  ✅ 功能1                    │"
      echo "│  ✅ 功能2                    │"
      echo "│  ✅ 功能3                    │"
      echo "│  ❌ 高级功能                 │"
      echo "│                             │"
      echo "│  👤 适合: ______             │"
      echo "│  📊 用量限制: ______         │"
      echo "└─────────────────────────────┘"
      echo ""
    done

    echo "### Markdown对比表"
    echo ""
    printf "| 对比项 |"
    for item in "${CLEAN_ITEMS[@]}"; do printf " %s |" "$item"; done
    echo ""
    printf "|--------|"
    for item in "${CLEAN_ITEMS[@]}"; do printf '%s' '------|'; done
    echo ""

    DIMS=("月价格" "年价格" "用户数" "存储空间" "API调用" "客服支持" "SLA" "自定义" "推荐指数")
    for dim in "${DIMS[@]}"; do
      printf "| %-8s |" "$dim"
      for item in "${CLEAN_ITEMS[@]}"; do printf " ___  |"; done
      echo ""
    done

    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;

  feature)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
✅ 功能矩阵 (Feature Matrix)

用法: feature <产品1>, <产品2>, <产品3>...

示例:
  feature Slack, Teams, Discord
  feature Notion, Obsidian, Logseq
  feature Figma, Sketch, Adobe XD

输出: ✅/❌ 功能对比矩阵

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    parse_items "$INPUT"
    NUM=${#CLEAN_ITEMS[@]}

    echo "✅ 功能矩阵"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    printf "| 功能特性 |"
    for item in "${CLEAN_ITEMS[@]}"; do printf " %s |" "$item"; done
    echo ""
    printf "|----------|"
    for item in "${CLEAN_ITEMS[@]}"; do printf '%s' '------|'; done
    echo ""

    FEATURES=(
      "核心功能1"
      "核心功能2"
      "核心功能3"
      "高级功能1"
      "高级功能2"
      "移动端支持"
      "API接口"
      "第三方集成"
      "团队协作"
      "离线使用"
      "数据导出"
      "中文支持"
    )

    for feat in "${FEATURES[@]}"; do
      printf "| %-10s |" "$feat"
      for item in "${CLEAN_ITEMS[@]}"; do printf " ✅/❌ |"; done
      echo ""
    done

    echo ""
    echo "图例: ✅ 支持  ❌ 不支持  🔶 部分支持  💰 付费功能"
    echo ""
    echo "### 功能覆盖率统计"
    for item in "${CLEAN_ITEMS[@]}"; do
      echo "  $item: __/${#FEATURES[@]} 项 (__%%)"
    done
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;

  export)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
📤 导出HTML对比表 (Export HTML)

用法: export <项目1>, <项目2>, <项目3>...

示例:
  export React, Vue, Angular

输出: 可直接使用的HTML对比表代码

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    parse_items "$INPUT"

    echo "📤 HTML 对比表"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "将以下HTML代码保存为 .html 文件即可使用:"
    echo ""
    echo '```html'
    cat <<'HTMLHEAD'
<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>对比表</title>
<style>
  body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; max-width: 900px; margin: 40px auto; padding: 0 20px; }
  h1 { text-align: center; color: #333; }
  table { width: 100%; border-collapse: collapse; margin: 20px 0; }
  th { background: #4A90D9; color: white; padding: 12px 15px; text-align: left; }
  td { padding: 10px 15px; border-bottom: 1px solid #eee; }
  tr:hover { background: #f5f5f5; }
  tr:nth-child(even) { background: #fafafa; }
  .yes { color: #27ae60; font-weight: bold; }
  .no { color: #e74c3c; }
  .footer { text-align: center; color: #999; margin-top: 30px; font-size: 0.85em; }
</style>
</head>
<body>
<h1>📊 对比分析</h1>
<table>
<thead>
<tr>
  <th>对比维度</th>
HTMLHEAD

    for item in "${CLEAN_ITEMS[@]}"; do
      echo "  <th>$item</th>"
    done

    cat <<'HTMLMID'
</tr>
</thead>
<tbody>
HTMLMID

    DIMS=("简介" "核心优势" "适用场景" "性能" "学习曲线" "生态" "社区" "总评")
    for dim in "${DIMS[@]}"; do
      echo "<tr>"
      echo "  <td><strong>$dim</strong></td>"
      for item in "${CLEAN_ITEMS[@]}"; do
        echo "  <td>—</td>"
      done
      echo "</tr>"
    done

    cat <<'HTMLFOOT'
</tbody>
</table>
<p class="footer">Powered by BytesAgain | bytesagain.com | hello@bytesagain.com</p>
</body>
</html>
HTMLFOOT
    echo '```'
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;

  *)
    cat <<'EOF'
📊 产品对比表生成工具 (Comparison Table)

用法: bash compare.sh <command> [args]

命令:
  create     自定义对比表
  product    产品对比
  tech       技术选型对比
  pricing    定价方案对比
  feature    功能矩阵 (✅/❌)
  export     导出HTML格式

示例:
  bash compare.sh create React, Vue, Angular
  bash compare.sh product iPhone, Galaxy, Pixel
  bash compare.sh tech PostgreSQL, MySQL, MongoDB
  bash compare.sh pricing 基础版, 专业版, 企业版
  bash compare.sh feature Slack, Teams, Discord
  bash compare.sh export React, Vue, Angular

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
esac
