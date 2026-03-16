#!/usr/bin/env bash
# blog.sh — 博客写作工具（真实SEO分析版）
# Usage: bash blog.sh <command> [args...]
# Commands: outline, meta, keywords, analyze, hooks, series, write
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

# ── SEO关键词分析 ──
analyze_keywords() {
  local topic="$1"
  local words
  words=$(echo "$topic" | tr ' ' '\n' | wc -l)

  echo "# 🔑 SEO关键词分析 — ${topic}"
  echo ""
  echo "> 分析时间: $(date '+%Y-%m-%d %H:%M')"
  echo ""

  echo "## 关键词拓展矩阵"
  echo ""
  echo "### 核心关键词"
  echo "| 关键词 | 类型 | 搜索意图 | 难度估算 |"
  echo "|--------|------|---------|---------|"
  echo "| ${topic} | 短尾词 | 信息型 | ⭐⭐⭐⭐ 高 |"

  # 长尾关键词生成
  local prefixes=("如何" "怎么" "什么是" "为什么" "最好的" "入门" "教程" "指南" "实战" "案例")
  local suffixes=("教程" "入门指南" "实战经验" "最佳实践" "常见问题" "注意事项" "工具推荐" "对比评测" "趋势分析" "学习路径")

  echo ""
  echo "### 长尾关键词"
  echo "| 关键词 | 类型 | 搜索意图 | 难度估算 |"
  echo "|--------|------|---------|---------|"

  local intents=("信息型" "导航型" "交易型" "商业型")
  local difficulties=("⭐ 低" "⭐⭐ 中低" "⭐⭐⭐ 中" "⭐⭐⭐⭐ 高")

  for i in $(seq 0 4); do
    local prefix="${prefixes[$i]}"
    local intent="${intents[$((i % 4))]}"
    local diff="${difficulties[$((RANDOM % 4))]}"
    echo "| ${prefix}${topic} | 长尾-问题型 | ${intent} | ${diff} |"
  done

  for i in $(seq 0 4); do
    local suffix="${suffixes[$i]}"
    local intent="${intents[$((i % 4))]}"
    local diff="${difficulties[$((RANDOM % 3))]}"
    echo "| ${topic}${suffix} | 长尾-主题型 | ${intent} | ${diff} |"
  done

  echo ""
  echo "### LSI语义关联词"
  echo ""
  echo "根据主题\`${topic}\`的语义场，推荐在文章中自然使用以下词汇："
  echo ""
  echo "- 同义/近义: [需根据具体主题填充]"
  echo "- 上位概念: [更大的分类]"
  echo "- 下位概念: [更具体的子话题]"
  echo "- 关联实体: [相关产品/工具/人物]"
  echo ""

  echo "## SEO优化建议"
  echo ""
  echo "| 项目 | 建议 | 说明 |"
  echo "|------|------|------|"
  echo "| 标题长度 | 20-30字 | 含核心关键词，前15字最关键 |"
  echo "| Meta描述 | 80-120字 | 含关键词+行动号召 |"
  echo "| H1标签 | 1个 | 与Title相似但不完全相同 |"
  echo "| H2标签 | 3-6个 | 含长尾关键词 |"
  echo "| 正文长度 | 1500-3000字 | 深度内容更受搜索引擎青睐 |"
  echo "| 关键词密度 | 1-3% | 自然分布，避免堆砌 |"
  echo "| 图片ALT | 每图必填 | 描述性+含关键词 |"
  echo "| 内链 | 3-5个 | 链接相关文章 |"
  echo "| 外链 | 2-3个 | 引用权威来源 |"
}

# ── 生成博客大纲 ──
generate_outline() {
  local topic="$1"
  local style="${2:-informational}"  # informational|tutorial|listicle|comparison|case-study

  echo "# 📝 博客大纲 — ${topic}"
  echo ""
  echo "> 风格: ${style}"
  echo "> 生成时间: $(date '+%Y-%m-%d %H:%M')"
  echo ""

  case "$style" in
    tutorial)
      cat <<EOF
## 推荐标题（5选1）
1. 「${topic}」完全指南：从入门到精通（2025最新版）
2. 手把手教你${topic}：新手必看教程
3. ${topic}实战教程：10分钟快速上手
4. 零基础学${topic}：一篇文章就够了
5. ${topic}保姆级教程：附代码/模板/工具

## 大纲结构

### 引言（100-150字）
- Hook: 痛点/场景引入
- 价值承诺: 读完能获得什么
- 预计阅读时间: X分钟

### H2: 什么是${topic}？（200字）
- 定义和核心概念
- 为什么重要
- 适用场景

### H2: 准备工作（200字）
- 环境/工具准备
- 前置知识要求
- 资源清单

### H2: 第一步 — [基础操作]（300字）
- 详细步骤说明
- 截图/代码示例
- 常见问题

### H2: 第二步 — [进阶操作]（300字）
- 详细步骤说明
- 最佳实践
- 注意事项

### H2: 第三步 — [高级技巧]（300字）
- 进阶用法
- 优化建议
- 专家提示

### H2: 常见问题FAQ（200字）
- Q1: [最常见问题]
- Q2: [第二常见问题]
- Q3: [第三常见问题]

### H2: 总结与下一步（100字）
- 核心要点回顾（3-5条）
- 推荐进阶资源
- CTA: 行动号召

---
预计总字数: 1500-2000字
预计阅读时间: 8-10分钟
EOF
      ;;
    listicle)
      cat <<EOF
## 推荐标题（5选1）
1. ${topic}：10个你必须知道的要点（2025版）
2. 关于${topic}，这7条建议价值百万
3. ${topic}指南：5个步骤让你少走弯路
4. 盘点${topic}的8大趋势，第3个最意外
5. ${topic}清单：12个实用技巧立即可用

## 大纲结构

### 引言（100字）
- 数据/事实引入
- 预告清单价值

### H2: 1. [第一个要点]
- 核心论述（150字）
- 案例/数据支撑
- 实操建议

### H2: 2. [第二个要点]
- 核心论述（150字）
- 对比分析
- 工具推荐

### H2: 3. [第三个要点]
- 核心论述（150字）
- 真实案例
- 避坑指南

### H2: 4. [第四个要点]
- 核心论述（150字）
- 专家观点
- 行动清单

### H2: 5. [第五个要点]
- 核心论述（150字）
- 趋势预判
- 资源推荐

### H2: 总结
- 核心回顾
- 读者互动（投票/评论引导）
- CTA

---
预计总字数: 1200-1800字
EOF
      ;;
    comparison)
      cat <<EOF
## 推荐标题（5选1）
1. ${topic}全面对比：哪个更适合你？（2025评测）
2. ${topic}横评：优劣势深度分析
3. ${topic}选择指南：一张表帮你做决定
4. A vs B vs C：${topic}终极对比
5. ${topic}深度评测：从性能到价格全覆盖

## 大纲结构

### 引言（100字）
- 对比背景和选择困难
- 评测标准说明

### H2: 评测标准
- 维度1: 功能
- 维度2: 价格
- 维度3: 易用性
- 维度4: 生态/社区
- 维度5: 适用场景

### H2: 选手一览
| 维度 | A | B | C |
|------|---|---|---|
| 功能 | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 价格 | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ |
| 易用性 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |

### H2: A — 详细评测（300字）
### H2: B — 详细评测（300字）
### H2: C — 详细评测（300字）

### H2: 最终推荐
- 预算有限选: B
- 功能至上选: C
- 均衡之选: A

### H2: FAQ

---
预计总字数: 2000-2500字
EOF
      ;;
    *)
      cat <<EOF
## 推荐标题（5选1）
1. ${topic}：你需要知道的一切（2025深度解读）
2. 深度解析${topic}：趋势、挑战与机遇
3. ${topic}全景分析：从基础到前沿
4. 为什么${topic}正在改变行业格局
5. ${topic}终极指南：方法论+实战+工具

## 大纲结构

### 引言（100-150字）
- 行业背景/数据引入
- 文章的独特视角
- 读者能获得的价值

### H2: ${topic}的现状与背景（300字）
- 发展历程
- 当前格局
- 关键数据

### H2: ${topic}的核心概念（300字）
- 基本原理
- 关键要素
- 常见误区

### H2: ${topic}实战方法论（400字）
- 方法一: [具体方法]
- 方法二: [具体方法]
- 方法三: [具体方法]
- 工具推荐表格

### H2: 案例分析（300字）
- 成功案例
- 失败案例
- 经验总结

### H2: 未来趋势与展望（200字）
- 短期趋势 (6-12月)
- 中期趋势 (1-3年)
- 长期展望

### H2: 总结（100字）
- 3-5条核心要点
- 行动建议
- CTA

---
预计总字数: 1800-2200字
预计阅读时间: 10-12分钟
EOF
      ;;
  esac
}

# ── Meta描述生成 ──
generate_meta() {
  local title="$1"
  local keywords="${2:-}"

  echo "# 🏷️ Meta标签生成 — ${title}"
  echo ""

  local title_len=${#title}
  echo "## Title标签"
  echo ""
  echo '```html'
  echo "<title>${title}</title>"
  echo '```'
  echo ""
  echo "- 长度: ${title_len}字符"
  if (( title_len < 10 )); then
    echo "- ⚠️ 标题过短，建议15-30字符"
  elif (( title_len > 35 )); then
    echo "- ⚠️ 标题过长，搜索结果可能截断"
  else
    echo "- ✅ 长度合适"
  fi

  echo ""
  echo "## Meta Description（5个版本）"
  echo ""

  # 生成5种不同风格的描述
  echo "### 版本1 — 信息型"
  echo '```html'
  echo "<meta name=\"description\" content=\"深入了解${title}。本文涵盖核心概念、实战方法、工具推荐和最佳实践，帮助你快速掌握关键要点。\" />"
  echo '```'
  echo ""

  echo "### 版本2 — 问题导向"
  echo '```html'
  echo "<meta name=\"description\" content=\"还在为${title}发愁？本指南从零开始，手把手教你掌握核心技能，附实用模板和案例分析。\" />"
  echo '```'
  echo ""

  echo "### 版本3 — 数据驱动"
  echo '```html'
  echo "<meta name=\"description\" content=\"2025年${title}最新指南。覆盖5大核心方法、10+实用工具和3个真实案例，已帮助10000+读者。\" />"
  echo '```'
  echo ""

  echo "### 版本4 — 行动号召"
  echo '```html'
  echo "<meta name=\"description\" content=\"想要精通${title}？立即阅读本文，获取专业分析和可执行的行动清单。5分钟阅读，受益终身。\" />"
  echo '```'
  echo ""

  echo "### 版本5 — 权威型"
  echo '```html'
  echo "<meta name=\"description\" content=\"${title}权威指南。基于行业最新数据和专家洞察，提供深度分析和前沿趋势解读。\" />"
  echo '```'

  echo ""
  echo "## OG标签（社交分享）"
  echo '```html'
  echo "<meta property=\"og:title\" content=\"${title}\" />"
  echo "<meta property=\"og:description\" content=\"深入了解${title}的核心概念与实战方法\" />"
  echo "<meta property=\"og:type\" content=\"article\" />"
  echo "<meta property=\"og:image\" content=\"/images/${title// /-}-cover.jpg\" />"
  echo '```'

  if [[ -n "$keywords" ]]; then
    echo ""
    echo "## Keywords标签"
    echo '```html'
    echo "<meta name=\"keywords\" content=\"${keywords}\" />"
    echo '```'
  fi
}

# ── 文章SEO分析 ──
analyze_article() {
  local file="$1"
  [[ -f "$file" ]] || { echo "❌ 文件不存在: $file"; exit 1; }

  local content
  content=$(cat "$file")
  local char_count=${#content}
  local line_count
  line_count=$(wc -l < "$file")
  local word_count
  word_count=$(wc -w < "$file")

  echo "# 🔍 文章SEO分析报告"
  echo ""
  echo "> 文件: $(basename "$file")"
  echo "> 分析时间: $(date '+%Y-%m-%d %H:%M')"
  echo ""

  local score=0

  echo "## 基础指标"
  echo ""
  echo "| 指标 | 值 | 评价 |"
  echo "|------|-----|------|"

  # 字数
  if (( char_count >= 1500 && char_count <= 3000 )); then
    echo "| 字符数 | $char_count | ✅ 适中 |"
    score=$((score + 15))
  elif (( char_count < 800 )); then
    echo "| 字符数 | $char_count | ❌ 过短 (<800) |"
    score=$((score + 5))
  elif (( char_count > 5000 )); then
    echo "| 字符数 | $char_count | ⚠️ 偏长 (>5000) |"
    score=$((score + 10))
  else
    echo "| 字符数 | $char_count | ✅ 可以 |"
    score=$((score + 12))
  fi

  # 标题结构
  local h1_count h2_count h3_count
  h1_count=$(grep -c '^# ' "$file" 2>/dev/null || echo 0)
  h2_count=$(grep -c '^## ' "$file" 2>/dev/null || echo 0)
  h3_count=$(grep -c '^### ' "$file" 2>/dev/null || echo 0)

  echo "| H1标签 | $h1_count | $([ "$h1_count" -eq 1 ] && echo "✅ 正确" || echo "⚠️ 应该有且仅有1个") |"
  echo "| H2标签 | $h2_count | $([ "$h2_count" -ge 3 ] && echo "✅ 良好" || echo "⚠️ 建议≥3") |"
  echo "| H3标签 | $h3_count | 📊 |"

  (( h1_count == 1 )) && score=$((score + 10))
  (( h2_count >= 3 )) && score=$((score + 10))

  # 段落分析
  local para_count
  para_count=$(grep -c '^[^#\|`-].\{10,\}' "$file" 2>/dev/null || echo 0)
  echo "| 段落数 | $para_count | 📊 |"
  echo "| 行数 | $line_count | 📊 |"

  # 链接
  local link_count
  link_count=$(grep -coE '\[.*\]\(.*\)' "$file" 2>/dev/null || echo 0)
  echo "| 链接数 | $link_count | $([ "$link_count" -ge 2 ] && echo "✅ 有引用" || echo "⚠️ 建议添加") |"
  (( link_count >= 2 )) && score=$((score + 10))

  # 图片
  local img_count
  img_count=$(grep -coE '!\[.*\]\(.*\)' "$file" 2>/dev/null || echo 0)
  echo "| 图片数 | $img_count | $([ "$img_count" -ge 1 ] && echo "✅ 有配图" || echo "⚠️ 建议添加") |"
  (( img_count >= 1 )) && score=$((score + 10))

  # 列表使用
  local list_count
  list_count=$(grep -c '^\s*[-*]\s\|^\s*[0-9]\.' "$file" 2>/dev/null || echo 0)
  echo "| 列表项 | $list_count | $([ "$list_count" -ge 3 ] && echo "✅ 格式丰富" || echo "⚠️ 建议使用") |"
  (( list_count >= 3 )) && score=$((score + 10))

  # 代码块
  local code_count
  code_count=$(grep -c '```' "$file" 2>/dev/null || echo 0)
  code_count=$((code_count / 2))
  echo "| 代码块 | $code_count | 📊 |"

  # 加粗/强调
  local bold_count
  bold_count=$(grep -coE '\*\*[^*]+\*\*' "$file" 2>/dev/null || echo 0)
  echo "| 加粗文本 | $bold_count处 | $([ "$bold_count" -ge 3 ] && echo "✅ 有重点" || echo "⚠️ 建议标注") |"
  (( bold_count >= 3 )) && score=$((score + 5))

  # 可读性评分
  local avg_para_len=0
  if (( para_count > 0 )); then
    avg_para_len=$((char_count / para_count))
  fi

  echo ""
  echo "## 可读性"
  echo ""
  echo "| 指标 | 值 | 建议 |"
  echo "|------|-----|------|"
  echo "| 平均段落长度 | ${avg_para_len}字 | $([ "$avg_para_len" -le 200 ] && echo "✅ 易读" || echo "⚠️ 建议<200字/段") |"
  (( avg_para_len <= 200 )) && score=$((score + 10))

  # 总分
  (( score > 100 )) && score=100

  local grade
  if (( score >= 85 )); then grade="🟢 优秀"
  elif (( score >= 70 )); then grade="🟡 良好"
  elif (( score >= 55 )); then grade="🟠 一般"
  else grade="🔴 需改善"; fi

  echo ""
  echo "## 📊 SEO评分: ${score}/100 ${grade}"
}

# ── Hook开头生成 ──
generate_hooks() {
  local topic="$1"

  echo "# 🎣 开头Hook生成 — ${topic}"
  echo ""
  echo "## 8种Hook风格"
  echo ""

  echo "### 1. 数据冲击型"
  echo "> 你知道吗？超过73%的人在面对${topic}时，都犯了同一个致命错误。更令人震惊的是，这个错误每年造成数十亿的损失——而解决它只需要5分钟。"
  echo ""

  echo "### 2. 故事引入型"
  echo "> 三年前的一个深夜，我在${topic}上踩了一个大坑。那次经历让我损失了[X]，但也让我学到了最宝贵的一课。今天，我把这个教训分享给你。"
  echo ""

  echo "### 3. 反直觉型"
  echo "> 关于${topic}，互联网上99%的建议都是错的。今天这篇文章可能会颠覆你的认知——但请先读完再下结论。"
  echo ""

  echo "### 4. 痛点共鸣型"
  echo "> 如果你正在为${topic}头疼，恭喜你，你不是一个人。我调研了100+从业者后发现，每个人都在同一个地方卡住了。好消息是，解决方案比你想象的简单。"
  echo ""

  echo "### 5. 权威背书型"
  echo "> 在过去[X]年里，我在${topic}领域帮助了[Y]个客户/项目，总结出了一套经过验证的方法论。本文是这套方法论的完整公开版。"
  echo ""

  echo "### 6. 时效性型"
  echo "> 2025年，${topic}正在经历一场前所未有的变革。如果你还在用去年的方法，你可能已经落后了。本文将带你了解最新的趋势和应对策略。"
  echo ""

  echo "### 7. 问题序列型"
  echo "> ${topic}为什么这么难？怎样才能快速上手？有没有一个简单的框架可以照搬？如果这些问题也困扰着你，那这篇文章就是为你写的。"
  echo ""

  echo "### 8. 承诺型"
  echo "> 读完这篇文章，你将掌握${topic}的3个核心技能、5个实用工具和1个可复用的框架。我保证，这是你读过的关于这个话题最实用的一篇。"
}

# ── 帮助 ──
show_help() {
  cat <<'HELP'
✍️ 博客写作工具 — blog.sh

用法: bash blog.sh <command> [args...]

命令:
  outline <主题> [风格]
        → 生成SEO优化的博客大纲
        风格: informational|tutorial|listicle|comparison
  meta <标题> [关键词]
        → 生成Meta标签（title/description/OG）
  keywords <主题>
        → 关键词分析（核心词+长尾词+LSI词）
  analyze <文件>
        → 分析已有文章的SEO评分
  hooks <主题>
        → 生成8种开头Hook
  help  → 显示帮助

示例:
  bash blog.sh outline "Python异步编程" tutorial
  bash blog.sh outline "2025年AI趋势" listicle
  bash blog.sh meta "Python异步编程入门指南" "Python,async,异步"
  bash blog.sh keywords "微服务架构"
  bash blog.sh analyze article.md
  bash blog.sh hooks "创业融资"

💡 功能:
  - 4种大纲风格（教程/列表/对比/信息型）
  - 关键词矩阵（长尾词+搜索意图分析）
  - Meta标签（5种description风格+OG标签）
  - 文章SEO评分（100分制，10+维度）
  - 8种开头Hook风格
HELP
}

case "$CMD" in
  outline)
    IFS='|' read -ra A <<< "$(echo "$INPUT" | sed 's/  */|/g')"
    generate_outline "${A[0]:-}" "${A[1]:-informational}"
    ;;
  meta)
    IFS='|' read -ra A <<< "$(echo "$INPUT" | sed 's/  */|/g')"
    generate_meta "${A[0]:-}" "${A[1]:-}"
    ;;
  keywords)  analyze_keywords "$INPUT" ;;
  analyze)   analyze_article "${INPUT%% *}" ;;
  hooks)     generate_hooks "$INPUT" ;;
  help|*)    show_help ;;
esac
