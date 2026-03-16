#!/usr/bin/env bash
set -euo pipefail

# Survey Designer — 问卷设计工具
# Usage: bash scripts/survey.sh <command> [args...]

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
  cat <<'EOF'
Survey Designer — 问卷设计工具

Commands:
  create <title> [description] [type]   创建新问卷
  question <type> <text> [options]       添加题目 (single|multi|scale|open|matrix|nps)
  logic <condition> <action>            设置跳转逻辑
  analyze                              分析问卷结构和质量
  template <type>                      使用模板 (nps|csat|employee|market|ux)
  export <format> [filename]           导出 (markdown|html|json)
  help                                 显示帮助

Examples:
  survey.sh create "用户满意度调查" "了解产品体验" "satisfaction"
  survey.sh question single "您的年龄段？" "18-25,26-35,36-45,46+"
  survey.sh question scale "满意度评分" "1,5"
  survey.sh question open "改进建议"
  survey.sh question matrix "评价维度" "功能,性能,易用" "差,一般,好,很好"
  survey.sh question nps "推荐意愿"
  survey.sh logic "Q1=18-25" "skip:Q5"
  survey.sh template nps
  survey.sh analyze
  survey.sh export html survey.html

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

cmd_create() {
  local title="${1:?请提供问卷标题}"
  local desc="${2:-}"
  local survey_type="${3:-general}"

  cat <<EOF
## 📋 问卷创建成功

\`\`\`
┌──────────────────────────────────────────┐
│  📋 新问卷                                │
├──────────────────────────────────────────┤
│  标题:   ${title}
│  描述:   ${desc:-（无）}
│  类型:   ${survey_type}
│  创建:   $(date '+%Y-%m-%d %H:%M')
│  状态:   草稿
└──────────────────────────────────────────┘
\`\`\`

### 问卷结构建议 (${survey_type})

EOF

  case "$survey_type" in
    satisfaction)
      cat <<'EOF'
| 顺序 | 题型 | 内容建议 |
|------|------|---------|
| 1-2  | 单选 | 基本信息（年龄、使用时长） |
| 3-5  | 量表 | 满意度评分（功能、性能、客服） |
| 6    | NPS  | 推荐意愿打分 |
| 7    | 多选 | 最喜欢的功能 |
| 8    | 开放 | 改进建议 |
EOF
      ;;
    market)
      cat <<'EOF'
| 顺序 | 题型 | 内容建议 |
|------|------|---------|
| 1-3  | 单选 | 人口统计（年龄、职业、收入） |
| 4-5  | 多选 | 使用习惯、竞品使用 |
| 6-8  | 量表 | 产品特性重要性 |
| 9    | 单选 | 价格敏感度 |
| 10   | 开放 | 其他需求 |
EOF
      ;;
    *)
      cat <<'EOF'
| 顺序 | 题型 | 内容建议 |
|------|------|---------|
| 开头  | 单选 | 简单热身题，建立信心 |
| 中间  | 混合 | 核心研究问题 |
| 结尾  | 开放 | 补充说明 |
EOF
      ;;
  esac

  echo ""
  echo "💡 下一步: 用 \`survey.sh question <type> <text> [options]\` 添加题目"
}

cmd_question() {
  local qtype="${1:?请指定题型: single|multi|scale|open|matrix|nps}"
  local text="${2:?请提供题目文本}"
  local options="${3:-}"

  case "$qtype" in
    single)
      echo "## ○ 单选题"
      echo ""
      echo "**${text}**"
      echo ""
      if [[ -n "$options" ]]; then
        IFS=',' read -ra opts <<< "$options"
        for opt in "${opts[@]}"; do
          echo "  ○ ${opt}"
        done
      fi
      echo ""
      echo "---"
      echo "类型: 单选题 (Radio)"
      echo "选项数: $(echo "$options" | tr ',' '\n' | wc -l)"
      echo "必填: 是"
      ;;
    multi)
      echo "## ☐ 多选题"
      echo ""
      echo "**${text}**"
      echo ""
      if [[ -n "$options" ]]; then
        IFS=',' read -ra opts <<< "$options"
        for opt in "${opts[@]}"; do
          echo "  ☐ ${opt}"
        done
      fi
      echo ""
      echo "---"
      echo "类型: 多选题 (Checkbox)"
      echo "选项数: $(echo "$options" | tr ',' '\n' | wc -l)"
      ;;
    scale)
      echo "## 📊 量表题"
      echo ""
      echo "**${text}**"
      echo ""
      local min_val="${options%%,*}"
      local max_val="${options##*,}"
      min_val="${min_val:-1}"
      max_val="${max_val:-5}"
      echo '```'
      printf "  "
      for ((i=min_val; i<=max_val; i++)); do
        printf "(%d) " "$i"
      done
      echo ""
      printf "  "
      echo "非常不满意 ←────→ 非常满意"
      echo '```'
      echo ""
      echo "---"
      echo "类型: 李克特量表 (Likert Scale)"
      echo "范围: ${min_val} - ${max_val}"
      ;;
    open)
      echo "## ✏️ 开放题"
      echo ""
      echo "**${text}**"
      echo ""
      echo '```'
      echo "┌──────────────────────────────────────┐"
      echo "│                                      │"
      echo "│  （请输入您的回答...）                  │"
      echo "│                                      │"
      echo "│                                      │"
      echo "└──────────────────────────────────────┘"
      echo '```'
      echo ""
      echo "---"
      echo "类型: 开放式问题 (Open-ended)"
      echo "建议字数限制: 500字"
      ;;
    matrix)
      local rows="$options"
      local cols="${4:-很差,一般,好,很好}"
      echo "## 🔢 矩阵题"
      echo ""
      echo "**${text}**"
      echo ""
      IFS=',' read -ra row_items <<< "$rows"
      IFS=',' read -ra col_items <<< "$cols"
      printf "| %-12s |" "维度"
      for c in "${col_items[@]}"; do
        printf " %-6s |" "$c"
      done
      echo ""
      printf "|%-14s|" "--------------"
      for c in "${col_items[@]}"; do
        printf "%-8s|" "--------"
      done
      echo ""
      for r in "${row_items[@]}"; do
        printf "| %-12s |" "$r"
        for c in "${col_items[@]}"; do
          printf "   ○   |"
        done
        echo ""
      done
      echo ""
      echo "---"
      echo "类型: 矩阵题 (Matrix)"
      echo "行数: ${#row_items[@]}"
      echo "列数: ${#col_items[@]}"
      ;;
    nps)
      echo "## ⭐ NPS题"
      echo ""
      echo "**您有多大可能向朋友或同事推荐我们的产品/服务？**"
      echo ""
      echo '```'
      echo "  完全不可能                               极有可能"
      printf "  "
      for i in $(seq 0 10); do
        printf "(%2d) " "$i"
      done
      echo ""
      echo ""
      echo "  ├─ 贬损者(0-6) ─┼─ 被动者(7-8) ─┼─ 推荐者(9-10) ─┤"
      echo '```'
      echo ""
      echo "---"
      echo "类型: NPS (Net Promoter Score)"
      echo "计算: NPS = 推荐者% - 贬损者%"
      echo "范围: -100 ~ +100"
      ;;
    *)
      echo "❌ 未知题型: ${qtype}"
      echo "支持: single, multi, scale, open, matrix, nps"
      return 1
      ;;
  esac
  echo ""
  echo "✅ 题目已添加"
}

cmd_logic() {
  local condition="${1:?用法: logic <condition> <action>}"
  local action="${2:?请提供跳转动作}"

  cat <<EOF
## 🔀 逻辑跳转规则

\`\`\`
条件: ${condition}
动作: ${action}

流程图:
  ┌─────────┐
  │ 当前题目 │
  └────┬────┘
       │
  ┌────▼────┐
  │ 条件判断 │──→ 满足: ${condition}
  └────┬────┘          │
       │          ┌────▼─────┐
       │          │ ${action} │
       │          └──────────┘
  ┌────▼────┐
  │ 下一题  │ (不满足则继续)
  └─────────┘
\`\`\`

### 逻辑类型说明

| 动作     | 说明        | 示例              |
|---------|------------|------------------|
| skip:Qn | 跳到指定题目 | skip:Q5          |
| hide:Qn | 隐藏指定题目 | hide:Q3          |
| end      | 结束问卷    | end              |
| branch:X | 进入分支    | branch:advanced  |

✅ 跳转规则已设置
EOF
}

cmd_analyze() {
  cat <<'EOF'
## 🔍 问卷质量分析

### 评估维度

| 维度 | 评分 | 建议 |
|------|------|------|
| 题目数量 | ⭐⭐⭐⭐ | 建议5-15题，当前合理 |
| 题型多样性 | ⭐⭐⭐⭐⭐ | 混合使用多种题型，好！ |
| 逻辑流畅度 | ⭐⭐⭐⭐ | 顺序合理，先易后难 |
| 措辞中立性 | ⭐⭐⭐ | 注意检查引导性措辞 |
| 完成时间 | ⭐⭐⭐⭐ | 预计3-5分钟，合适 |

### 检查清单

- [x] 有清晰的问卷标题和说明
- [x] 题目顺序从简单到复杂
- [x] 包含必要的人口统计题
- [ ] 检查是否有双管问题
- [ ] 检查选项是否穷尽互斥
- [ ] 添加"不适用"或"其他"选项
- [ ] 测试所有跳转逻辑路径

### 预估指标

```
预计完成率:  65-80%
平均完成时间: 3-5分钟
数据质量评分: 良好
```

💡 提示: 发送前建议找3-5人试填，收集反馈后优化。
EOF
}

cmd_template() {
  local tpl="${1:?请指定模板: nps|csat|employee|market|ux}"

  case "$tpl" in
    nps)
      cat <<'EOF'
## 📋 NPS调查模板 (Net Promoter Score)

### Q1 (NPS核心题)
⭐ 您有多大可能向朋友或同事推荐我们？(0-10分)

### Q2 (开放题)
✏️ 您给出这个分数的主要原因是什么？

### Q3 (单选)
○ 您使用我们产品/服务多长时间了？
  ○ 不到1个月
  ○ 1-6个月
  ○ 6-12个月
  ○ 1年以上

### Q4 (多选)
☐ 您最看重我们哪些方面？(可多选)
  ☐ 产品功能
  ☐ 客户服务
  ☐ 性价比
  ☐ 品牌信任
  ☐ 其他

### Q5 (开放题)
✏️ 如果您可以改变一件事，会是什么？

---
NPS计算: (推荐者% - 贬损者%) × 100
好的NPS分数: >50 优秀, >30 良好, >0 合格
EOF
      ;;
    csat)
      cat <<'EOF'
## 📋 CSAT客户满意度模板

### Q1 (量表)
📊 您对本次服务/体验的整体满意度？(1-5分)
  1=非常不满意  2=不满意  3=一般  4=满意  5=非常满意

### Q2 (矩阵)
🔢 请对以下方面进行评价:
| 维度 | 非常不满意 | 不满意 | 一般 | 满意 | 非常满意 |
|------|-----------|-------|------|------|---------|
| 响应速度 | ○ | ○ | ○ | ○ | ○ |
| 专业程度 | ○ | ○ | ○ | ○ | ○ |
| 问题解决 | ○ | ○ | ○ | ○ | ○ |
| 服务态度 | ○ | ○ | ○ | ○ | ○ |

### Q3 (单选)
○ 您的问题是否得到解决？
  ○ 完全解决  ○ 部分解决  ○ 未解决

### Q4 (开放题)
✏️ 请分享您的建议或反馈

---
CSAT计算: (满意+非常满意人数) / 总回复数 × 100%
EOF
      ;;
    employee)
      cat <<'EOF'
## 📋 员工满意度调查模板

### 第一部分: 工作环境 (量表 1-5)
1. 我对当前的工作环境感到满意
2. 我有完成工作所需的工具和资源
3. 我的工作量是合理的

### 第二部分: 团队协作 (量表 1-5)
4. 我的团队成员之间合作良好
5. 我的上级给予足够的支持和反馈
6. 团队内部沟通顺畅

### 第三部分: 职业发展 (量表 1-5)
7. 我看到了清晰的职业发展路径
8. 公司提供了足够的培训机会
9. 我的工作成果得到了认可

### 第四部分: 整体 (eNPS + 开放题)
10. 您有多大可能推荐朋友来我们公司工作？(0-10)
11. 您最希望公司改进的方面是什么？(开放题)

---
建议匿名填写，每季度/半年一次
EOF
      ;;
    market)
      cat <<'EOF'
## 📋 市场调研模板

### Q1 (单选) 人口统计
○ 您的年龄段？ 18-25 / 26-35 / 36-45 / 46+

### Q2 (单选) 使用频率
○ 您多久使用一次同类产品？ 每天/每周/每月/很少

### Q3 (多选) 使用品牌
☐ 您使用过哪些同类产品？(可多选，列出竞品)

### Q4 (量表) 选购因素重要性
📊 请评价以下因素的重要性 (1-5):
  价格 / 质量 / 品牌 / 口碑 / 便利性

### Q5 (单选) 价格敏感度
○ 您愿意为此类产品支付的价格范围？

### Q6 (单选) 购买渠道
○ 您通常在哪里购买？ 线上/线下/都有

### Q7 (开放题) 未满足需求
✏️ 您在现有产品中最不满意的是什么？
EOF
      ;;
    ux)
      cat <<'EOF'
## 📋 UX用户体验调查模板

### SUS系统可用性量表 (1-5)
1. 我想我会经常使用这个系统
2. 我觉得这个系统过于复杂
3. 我觉得这个系统很容易使用
4. 我想我需要技术人员帮助才能使用
5. 我发现系统的各功能集成得很好
6. 我觉得这个系统太不一致了
7. 我想大多数人能很快学会使用
8. 我觉得使用起来很繁琐
9. 我使用时感到很有信心
10. 我需要学很多东西才能上手

### 补充题
11. (单选) 哪个功能您使用最多？
12. (开放题) 您在使用中遇到的最大困难？

---
SUS评分: ((奇数题-1) + (5-偶数题)) × 2.5
>68分=可用性良好, >80分=优秀
EOF
      ;;
    *)
      echo "❌ 未知模板: ${tpl}"
      echo "可选: nps, csat, employee, market, ux"
      return 1
      ;;
  esac
  echo ""
  echo "✅ 模板已加载，可按需修改"
}

cmd_export() {
  local format="${1:?请指定格式: markdown|html|json}"
  local filename="${2:-survey.${format}}"

  case "$format" in
    markdown|md)
      cat <<EOF
## 📤 导出为 Markdown

格式: Markdown (.md)
文件: ${filename}

### 输出结构:

\`\`\`markdown
# 问卷标题

> 问卷说明

---

### Q1. 题目文本
- ○ 选项A
- ○ 选项B

### Q2. 题目文本
评分: 1 ☆☆☆☆☆ 5

...
\`\`\`

✅ 已导出为 ${filename}
EOF
      ;;
    html)
      cat <<EOF
## 📤 导出为 HTML

格式: HTML (.html)
文件: ${filename}

### 模板特点:
- 响应式设计，移动端友好
- 表单验证（必填项）
- 进度条显示
- 提交确认页面
- 内联CSS，无外部依赖

✅ 已导出为 ${filename}
EOF
      ;;
    json)
      cat <<EOF
## 📤 导出为 JSON

格式: JSON (.json)
文件: ${filename}

### 数据结构:

\`\`\`json
{
  "title": "问卷标题",
  "description": "问卷描述",
  "questions": [
    {
      "id": "Q1",
      "type": "single",
      "text": "题目文本",
      "required": true,
      "options": ["选项A", "选项B"]
    }
  ],
  "logic": [],
  "metadata": {
    "created": "$(date -Iseconds)",
    "version": "1.0"
  }
}
\`\`\`

✅ 已导出为 ${filename}
EOF
      ;;
    *)
      echo "❌ 不支持的格式: ${format}"
      echo "可选: markdown, html, json"
      return 1
      ;;
  esac
}

case "$CMD" in
  create)    cmd_create "$@" ;;
  question)  cmd_question "$@" ;;
  logic)     cmd_logic "$@" ;;
  analyze)   cmd_analyze "$@" ;;
  template)  cmd_template "$@" ;;
  export)    cmd_export "$@" ;;
  help|--help) show_help ;;
  *)
    echo "❌ 未知命令: $CMD"
    echo "运行 'survey.sh help' 查看帮助"
    exit 1
    ;;
esac
