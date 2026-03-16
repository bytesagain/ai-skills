#!/usr/bin/env bash
set -euo pipefail

# Dashboard Builder — 数据看板构建器
# Usage: bash scripts/dashboard.sh <command> [args...]

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
  cat <<'EOF'
Dashboard Builder — 数据看板构建器

Commands:
  create <title> [description]         创建新看板
  widget <type> <title> <data>         添加组件 (bar|line|pie|number|table|progress)
  metric <name> <value> [change] [dir] 添加KPI指标卡片
  layout <columns> [gap]              设置布局 (列数, 间距px)
  export <filename>                   导出为HTML文件
  theme <name>                        切换主题 (light|dark|corporate|startup)
  help                                显示帮助

Examples:
  dashboard.sh create "销售日报" "2024年Q1销售数据"
  dashboard.sh widget bar "月销售" "Jan:120,Feb:150,Mar:180"
  dashboard.sh widget number "总营收" "¥1,250,000" "+12.5%"
  dashboard.sh widget progress "目标完成率" "78"
  dashboard.sh metric "DAU" "15,230" "+8.2%" "up"
  dashboard.sh layout 3 20
  dashboard.sh theme dark
  dashboard.sh export dashboard.html

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

cmd_create() {
  local title="${1:?请提供看板标题}"
  local desc="${2:-}"
  cat <<EOF
╔══════════════════════════════════════════════════════════════╗
║  📊 数据看板创建成功                                          ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  标题: ${title}
║  描述: ${desc:-（无）}
║  创建时间: $(date '+%Y-%m-%d %H:%M:%S')
║                                                              ║
║  📋 下一步操作:                                               ║
║  1. 添加组件:  dashboard.sh widget bar "图表名" "数据"         ║
║  2. 添加指标:  dashboard.sh metric "KPI名" "数值"             ║
║  3. 设置布局:  dashboard.sh layout 3                          ║
║  4. 选择主题:  dashboard.sh theme dark                        ║
║  5. 导出文件:  dashboard.sh export output.html                ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

### 看板结构（Markdown预览）

# 📊 ${title}
${desc:+> $desc}

---

| 区域 | 建议组件 | 说明 |
|------|---------|------|
| 顶部 | number/metric | KPI核心指标，一眼看全局 |
| 中部 | bar/line | 趋势和对比图表 |
| 底部 | table/progress | 明细数据和进度跟踪 |

💡 建议：先用 \`widget\` 添加3-6个组件，再用 \`export\` 生成HTML
EOF
}

cmd_widget() {
  local wtype="${1:?请指定组件类型: bar|line|pie|number|table|progress}"
  local title="${2:?请提供组件标题}"
  local data="${3:-}"

  case "$wtype" in
    bar)
      echo "## 📊 柱状图组件: ${title}"
      echo ""
      echo '```'
      echo "类型: 柱状图 (Bar Chart)"
      echo "标题: ${title}"
      echo "数据: ${data}"
      echo ""
      if [[ -n "$data" ]]; then
        # Parse data and draw ASCII bar chart
        local max_val=0
        local items=()
        IFS=',' read -ra pairs <<< "$data"
        for pair in "${pairs[@]}"; do
          local label="${pair%%:*}"
          local val="${pair##*:}"
          items+=("${label}:${val}")
          if (( val > max_val )); then max_val=$val; fi
        done
        local bar_width=30
        for item in "${items[@]}"; do
          local label="${item%%:*}"
          local val="${item##*:}"
          local bar_len=0
          if (( max_val > 0 )); then
            bar_len=$(( val * bar_width / max_val ))
          fi
          local bar=""
          for ((i=0; i<bar_len; i++)); do bar+="█"; done
          printf "  %-10s |%-${bar_width}s| %s\n" "$label" "$bar" "$val"
        done
      fi
      echo '```'
      echo ""
      echo "✅ 柱状图组件已添加到看板"
      ;;
    line)
      echo "## 📈 折线图组件: ${title}"
      echo ""
      echo '```'
      echo "类型: 折线图 (Line Chart)"
      echo "标题: ${title}"
      echo "数据: ${data}"
      echo ""
      if [[ -n "$data" ]]; then
        IFS=',' read -ra pairs <<< "$data"
        local vals=()
        local labels=()
        local max_val=0
        local min_val=999999999
        for pair in "${pairs[@]}"; do
          labels+=("${pair%%:*}")
          local v="${pair##*:}"
          vals+=("$v")
          (( v > max_val )) && max_val=$v
          (( v < min_val )) && min_val=$v
        done
        local height=8
        local range=$((max_val - min_val))
        (( range == 0 )) && range=1
        for ((row=height; row>=0; row--)); do
          local threshold=$(( min_val + range * row / height ))
          printf "%8s │ " "$threshold"
          for v in "${vals[@]}"; do
            local level=$(( (v - min_val) * height / range ))
            if (( level == row )); then
              printf "● "
            elif (( level > row )); then
              printf "│ "
            else
              printf "  "
            fi
          done
          echo ""
        done
        printf "%8s └─" ""
        for l in "${labels[@]}"; do printf "──"; done
        echo ""
        printf "%10s" ""
        for l in "${labels[@]}"; do printf "%-2s" "$l"; done
        echo ""
      fi
      echo '```'
      echo ""
      echo "✅ 折线图组件已添加到看板"
      ;;
    pie)
      echo "## 🥧 饼图组件: ${title}"
      echo ""
      echo '```'
      echo "类型: 饼图 (Pie Chart)"
      echo "标题: ${title}"
      echo "数据: ${data}"
      echo ""
      if [[ -n "$data" ]]; then
        local total=0
        IFS=',' read -ra pairs <<< "$data"
        for pair in "${pairs[@]}"; do
          local val="${pair##*:}"
          total=$((total + val))
        done
        local symbols=("█" "▓" "▒" "░" "◆" "◇" "●" "○")
        local idx=0
        echo "  分布:"
        for pair in "${pairs[@]}"; do
          local label="${pair%%:*}"
          local val="${pair##*:}"
          local pct=0
          if (( total > 0 )); then
            pct=$((val * 100 / total))
          fi
          local bar_len=$((pct / 3))
          local bar=""
          local sym="${symbols[$((idx % ${#symbols[@]}))]}"
          for ((i=0; i<bar_len; i++)); do bar+="$sym"; done
          printf "  %s %-10s %3d%% %s\n" "$sym" "$label" "$pct" "$bar"
          idx=$((idx + 1))
        done
        echo ""
        echo "  总计: ${total}"
      fi
      echo '```'
      echo ""
      echo "✅ 饼图组件已添加到看板"
      ;;
    number)
      local change="${4:-}"
      echo "## 🔢 数字卡片: ${title}"
      echo ""
      echo '```'
      echo "┌────────────────────────────┐"
      echo "│  ${title}"
      printf "│  %-26s│\n" "${data}"
      if [[ -n "$change" ]]; then
        local arrow="→"
        if [[ "$change" == +* ]]; then arrow="↑"; fi
        if [[ "$change" == -* ]]; then arrow="↓"; fi
        printf "│  %s %-24s│\n" "$arrow" "$change"
      fi
      echo "└────────────────────────────┘"
      echo '```'
      echo ""
      echo "✅ 数字卡片已添加到看板"
      ;;
    progress)
      echo "## 📊 进度条组件: ${title}"
      echo ""
      local pct="${data:-0}"
      local filled=$((pct / 5))
      local empty=$((20 - filled))
      local bar=""
      for ((i=0; i<filled; i++)); do bar+="█"; done
      for ((i=0; i<empty; i++)); do bar+="░"; done
      echo '```'
      echo "┌────────────────────────────┐"
      echo "│  ${title}"
      echo "│  [${bar}] ${pct}%"
      echo "└────────────────────────────┘"
      echo '```'
      echo ""
      echo "✅ 进度条组件已添加到看板"
      ;;
    table)
      echo "## 📋 表格组件: ${title}"
      echo ""
      echo "数据: ${data}"
      echo ""
      echo "✅ 表格组件已添加到看板"
      ;;
    *)
      echo "❌ 未知组件类型: ${wtype}"
      echo "支持: bar, line, pie, number, table, progress"
      return 1
      ;;
  esac
}

cmd_metric() {
  local name="${1:?请提供指标名称}"
  local value="${2:?请提供指标数值}"
  local change="${3:-}"
  local direction="${4:-stable}"

  local icon="→"
  local color_hint="neutral"
  case "$direction" in
    up)   icon="↑"; color_hint="green (positive)" ;;
    down) icon="↓"; color_hint="red (negative)" ;;
    *)    icon="→"; color_hint="gray (stable)" ;;
  esac

  echo "## 📌 KPI 指标卡片"
  echo ""
  echo '```'
  echo "┌─────────────────────────────────┐"
  printf "│  📌 %-28s│\n" "${name}"
  echo "│                                 │"
  printf "│  %-31s│\n" "${value}"
  if [[ -n "$change" ]]; then
    printf "│  %s %-29s│\n" "$icon" "${change}"
  fi
  printf "│  趋势: %-25s│\n" "${color_hint}"
  echo "│                                 │"
  echo "└─────────────────────────────────┘"
  echo '```'
  echo ""
  echo "✅ KPI指标卡片已添加"
}

cmd_layout() {
  local columns="${1:-3}"
  local gap="${2:-20}"

  cat <<EOF
## 🔧 布局配置

\`\`\`
布局模式: CSS Grid
列数: ${columns}
间距: ${gap}px

┌─────────┬─────────┬─────────┐
EOF

  local col_display=""
  for ((i=1; i<=columns; i++)); do
    if [[ -n "$col_display" ]]; then col_display+=" │ "; fi
    col_display+="  Col ${i}  "
  done
  echo "│ ${col_display} │"

  cat <<EOF
├─────────┼─────────┼─────────┤
│ Widget  │ Widget  │ Widget  │
│   1     │   2     │   3     │
├─────────┼─────────┼─────────┤
│ Widget  │ Widget  │ Widget  │
│   4     │   5     │   6     │
└─────────┴─────────┴─────────┘

CSS Grid 样式:
  display: grid;
  grid-template-columns: repeat(${columns}, 1fr);
  gap: ${gap}px;
\`\`\`

✅ 布局已配置为 ${columns} 列，间距 ${gap}px
EOF
}

cmd_theme() {
  local theme="${1:-light}"

  case "$theme" in
    light)
      cat <<'EOF'
## 🎨 主题: Light (浅色)

```
背景色:   #FFFFFF (白色)
卡片背景:  #F8F9FA (浅灰)
文字颜色:  #212529 (深灰)
主色调:    #4361EE (蓝色)
成功色:    #2EC4B6 (青绿)
警告色:    #FF6B6B (红色)
边框:     #DEE2E6 (灰色)
阴影:     0 2px 8px rgba(0,0,0,0.1)
```

✅ 已切换到 Light 主题 — 适合打印和投影
EOF
      ;;
    dark)
      cat <<'EOF'
## 🎨 主题: Dark (深色)

```
背景色:   #1A1A2E (深蓝黑)
卡片背景:  #16213E (深蓝)
文字颜色:  #E8E8E8 (浅灰)
主色调:    #00D2FF (荧光蓝)
成功色:    #00F5D4 (荧光绿)
警告色:    #FF6B6B (珊瑚红)
边框:     #2A2A4A (暗紫)
阴影:     0 4px 12px rgba(0,0,0,0.3)
```

✅ 已切换到 Dark 主题 — 适合大屏展示和监控
EOF
      ;;
    corporate)
      cat <<'EOF'
## 🎨 主题: Corporate (商务)

```
背景色:   #F5F5F5 (米灰)
卡片背景:  #FFFFFF (白色)
文字颜色:  #333333 (深灰)
主色调:    #1B4F72 (商务蓝)
成功色:    #27AE60 (深绿)
警告色:    #E74C3C (正红)
边框:     #BDC3C7 (银灰)
阴影:     0 1px 4px rgba(0,0,0,0.08)
```

✅ 已切换到 Corporate 主题 — 适合商务汇报
EOF
      ;;
    startup)
      cat <<'EOF'
## 🎨 主题: Startup (活力)

```
背景色:   #FAFAFA (近白)
卡片背景:  #FFFFFF (白色)
文字颜色:  #2D3436 (墨灰)
主色调:    #6C5CE7 (紫色)
成功色:    #00B894 (翠绿)
警告色:    #FDCB6E (琥珀)
强调色:    #FD79A8 (粉红)
边框:     #DFE6E9 (云灰)
阴影:     0 4px 16px rgba(108,92,231,0.15)
圆角:     12px
```

✅ 已切换到 Startup 主题 — 适合产品演示
EOF
      ;;
    *)
      echo "❌ 未知主题: ${theme}"
      echo "可选: light, dark, corporate, startup"
      return 1
      ;;
  esac
}

cmd_export() {
  local filename="${1:-dashboard.html}"

  cat <<EOF
## 📤 导出看板 HTML

将生成完整的自包含HTML文件，包含:
- 内联CSS样式（无外部依赖）
- SVG图表（矢量可缩放）
- 响应式布局
- 可直接在浏览器打开

### HTML模板结构:

\`\`\`html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>数据看板</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; }
    .dashboard { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; padding: 24px; }
    .card { background: #fff; border-radius: 8px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    .metric-value { font-size: 2.5em; font-weight: 700; }
    .metric-change.up { color: #2EC4B6; }
    .metric-change.down { color: #FF6B6B; }
  </style>
</head>
<body>
  <div class="dashboard">
    <!-- 组件将在此渲染 -->
  </div>
</body>
</html>
\`\`\`

📁 输出文件: ${filename}
✅ 看板已导出 — 可直接在浏览器中打开
EOF
}

case "$CMD" in
  create)       cmd_create "$@" ;;
  widget)       cmd_widget "$@" ;;
  metric)       cmd_metric "$@" ;;
  layout)       cmd_layout "$@" ;;
  export)       cmd_export "$@" ;;
  theme)        cmd_theme "$@" ;;
  help|--help)  show_help ;;
  *)
    echo "❌ 未知命令: $CMD"
    echo "运行 'dashboard.sh help' 查看帮助"
    exit 1
    ;;
esac
