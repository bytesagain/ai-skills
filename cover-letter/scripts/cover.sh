#!/usr/bin/env bash
# cover.sh — 求职信生成器（真实生成版）
# Usage: bash cover.sh <command> [args...]
# Commands: write, tech, finance, creative, score, batch
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

# ── 工具函数 ──
today() { date '+%Y年%m月%d日'; }

# ── 求职信模板引擎 ──
generate_letter() {
  local template="$1"  # tech|finance|creative|general
  local name="${2:-[您的姓名]}"
  local position="${3:-[目标职位]}"
  local company="${4:-[目标公司]}"
  local experience="${5:-3}"
  local highlight1="${6:-项目经验丰富}"
  local highlight2="${7:-技术能力突出}"
  local highlight3="${8:-团队协作优秀}"

  local greeting hook body_style sign_off

  # 根据模板设置风格
  case "$template" in
    tech)
      hook="作为一名拥有${experience}年经验的技术工程师，我一直关注${company}在技术领域的创新实践。贵司在[技术方向]上的突破令我深受启发，这也是我希望加入${company}团队的核心原因。"
      body_style="technical"
      ;;
    finance)
      hook="在金融行业深耕${experience}年，我对${company}在[业务领域]的战略布局一直保持高度关注。贵司近期[具体动态]的举措，与我的职业愿景高度契合。"
      body_style="formal"
      ;;
    creative)
      hook="每个人都有一个定义自己的时刻——我的，是在第一次体验${company}的[产品/服务]时。那一刻，我知道这就是我想要贡献创意和热情的地方。"
      body_style="creative"
      ;;
    *)
      hook="在浏览${company}的${position}招聘信息时，我发现这与我过去${experience}年积累的经验高度匹配。我相信我的能力和热情能为贵司带来价值。"
      body_style="general"
      ;;
  esac

  cat <<EOF
# 求职信

**${name}**
$(today)

尊敬的${company}招聘负责人：

您好！

${hook}

EOF

  # 核心段落 - 根据风格生成
  case "$body_style" in
    technical)
      cat <<EOF
## 技术能力与项目经验

在过去${experience}年的工作中，我积累了扎实的技术功底和丰富的项目经验：

**${highlight1}**
在[前公司]期间，我主导了[项目名]的架构设计和开发工作。该项目涉及[技术栈]，我通过[具体方案]将系统性能提升了[X]%，日均处理请求量从[A]提升至[B]。这段经历让我深刻理解了高并发系统设计的核心要素。

**${highlight2}**
作为技术负责人，我带领[X]人团队完成了[项目]的从0到1。项目上线后，[核心指标]实现了[X]%的增长。期间我推动了CI/CD流程优化，将部署频率从每周一次提升至每日多次，显著提高了团队交付效率。

**${highlight3}**
我积极参与开源社区，在[平台]上贡献了[具体贡献]。同时，我定期在团队内部进行技术分享，编写了[X]篇技术文档，帮助新成员快速上手。

## 为什么选择${company}

${company}在[技术方向]上的实践与我的技术追求高度一致。我特别欣赏贵司：
- [具体优势1]——这正是我希望深入的技术方向
- [具体优势2]——与我过往经验形成互补
- [文化/价值观]——与我的工作理念高度契合
EOF
      ;;
    formal)
      cat <<EOF
## 专业背景与核心能力

我在金融领域拥有${experience}年的从业经验，具备扎实的专业基础和出色的业务能力：

**${highlight1}**
在[前公司]的[部门]工作期间，我负责[业务范围]，管理资产规模达[X]亿元。通过[具体策略]，实现了年化收益率[X]%，超越基准[X]个百分点。

**${highlight2}**
我持有[CFA/CPA/FRM]等专业资质，熟悉[监管框架/合规要求]。在[具体项目]中，我主导设计了[风控模型/投资策略]，有效控制了[风险指标]在合理范围内。

**${highlight3}**
在跨部门协作方面，我与[相关部门]紧密合作，推动了[项目/流程]的落地，为公司创造了[X]万元的增量收益。

## 对贵司的认识

${company}在[业务领域]的市场地位和战略眼光令人敬佩。我期望能将自己的专业能力融入贵司的发展战略中：
- [业务方向]方面，我有[X]年直接相关经验
- [合规/风控]方面，我的专业背景可以即刻产生价值
- [创新业务]方面，我愿意积极探索和贡献
EOF
      ;;
    creative)
      cat <<EOF
## 创意履历

${experience}年的创意旅程，让我学会了一件事：**好的创意不是灵感的闪现，而是理解用户后的精准表达。**

**${highlight1}**
在[前公司/项目]中，我操刀了[X]个品牌的视觉/内容重塑。其中[案例名]项目在上线后获得了[X]万次曝光，社交媒体互动率提升了[X]%。这个项目教会我，数据和创意不是对立的——它们是最好的搭档。

**${highlight2}**
我相信"限制催生创意"。在预算仅有[X]元的[项目]中，我通过[具体方式]实现了ROI [X]倍的回报。这段经历让我明白，创意的价值不在于花了多少钱，而在于触动了多少人。

**${highlight3}**
从[平面/视频/文案/UI]到[新领域]，我始终保持对新事物的好奇心。最近我正在探索[AI/新媒体/新技术]在创意中的应用，已产出[具体成果]。

## 为什么是${company}

坦白说，在了解${company}的[产品/品牌/文化]之前，我投了很多份简历。但了解之后，我撤回了其他所有申请。因为——
- 贵司的[品牌理念]与我的创作哲学完美契合
- [具体项目/作品]让我看到了创意的更多可能性
- 我想和[这样的团队]一起创造下一个[代表作]
EOF
      ;;
    *)
      cat <<EOF
## 工作经验与核心优势

在过去${experience}年的职业生涯中，我积累了丰富的工作经验和专业技能：

**${highlight1}**
在[前公司]担任[职位]期间，我负责[具体职责]，取得了[量化成果]。通过[具体举措]，我为团队/公司带来了[具体价值]。

**${highlight2}**
我在[专业领域]具备深厚的知识储备。在[项目/任务]中，我运用[技能/方法]，成功[完成了什么]，获得了[认可/奖项]。

**${highlight3}**
我注重团队合作和持续学习。在日常工作中，我积极与同事沟通协作，同时不断提升自己的专业能力，[具体学习/成长经历]。

## 加入${company}的期望

${company}的[企业文化/业务方向/行业地位]令我心向往之。我期望能够：
- 将${experience}年的[行业]经验带入贵司${position}岗位
- 在[具体方向]上为团队创造可衡量的价值
- 与优秀的团队一起成长和突破
EOF
      ;;
  esac

  cat <<EOF

## 结语

期待有机会与您进一步交流，详细展示我的经验和能力如何为${company}的${position}岗位创造价值。我可以随时安排面试时间。

感谢您在百忙之中阅读我的求职信。

此致
敬礼

**${name}**
📧 [email@example.com]
📱 [138-XXXX-XXXX]
🔗 [LinkedIn/GitHub/Portfolio链接]
EOF
}

# ── 求职信评分 ──
score_letter() {
  local file="$1"
  [[ -f "$file" ]] || { echo "❌ 文件不存在: $file"; exit 1; }

  local content
  content=$(cat "$file")
  local total_chars=${#content}
  local total_lines
  total_lines=$(wc -l < "$file")

  echo "# 📝 求职信评分报告"
  echo ""
  echo "> 文件: $(basename "$file")"
  echo "> 字数: $total_chars"
  echo "> 行数: $total_lines"
  echo ""

  local score=0

  # 1. 长度评分 (15分)
  echo "## 评分明细"
  echo ""
  local len_score=0
  if (( total_chars >= 400 && total_chars <= 1000 )); then
    len_score=15
    echo "✅ 长度适中 ($total_chars字) — 15/15"
  elif (( total_chars >= 200 && total_chars < 400 )); then
    len_score=10
    echo "⚠️ 偏短 ($total_chars字, 建议400-1000) — 10/15"
  elif (( total_chars > 1000 && total_chars <= 1500 )); then
    len_score=10
    echo "⚠️ 偏长 ($total_chars字, 建议400-1000) — 10/15"
  else
    len_score=5
    echo "❌ 长度不当 ($total_chars字) — 5/15"
  fi
  score=$((score + len_score))

  # 2. 结构评分 (20分)
  local struct_score=0
  local has_greeting=$(grep -c '尊敬的\|Dear\|您好' "$file" 2>/dev/null || echo 0)
  local has_closing=$(grep -c '此致\|敬礼\|Sincerely\|Best\|期待' "$file" 2>/dev/null || echo 0)
  local has_name=$(grep -c '姓名\|联系\|电话\|邮箱\|email\|📧\|📱' "$file" 2>/dev/null || echo 0)
  [[ "$has_greeting" -gt 0 ]] && struct_score=$((struct_score + 7))
  [[ "$has_closing" -gt 0 ]] && struct_score=$((struct_score + 7))
  [[ "$has_name" -gt 0 ]] && struct_score=$((struct_score + 6))
  echo "$([ $struct_score -ge 15 ] && echo "✅" || echo "⚠️") 结构完整度 — $struct_score/20"
  score=$((score + struct_score))

  # 3. 量化数据 (20分)
  local quant_score=0
  local numbers
  numbers=$(grep -coE '[0-9]+%|[0-9]+万|[0-9]+亿|[0-9]+倍' "$file" 2>/dev/null || echo 0)
  if (( numbers >= 3 )); then quant_score=20
  elif (( numbers >= 1 )); then quant_score=12
  else quant_score=5; fi
  echo "$([ $quant_score -ge 15 ] && echo "✅" || echo "⚠️") 量化数据 ($numbers处) — $quant_score/20"
  score=$((score + quant_score))

  # 4. 个性化 (20分)
  local personal_score=0
  local company_mention
  company_mention=$(grep -coE '贵司|贵公司|公司' "$file" 2>/dev/null || echo 0)
  local position_mention
  position_mention=$(grep -coE '职位|岗位|角色' "$file" 2>/dev/null || echo 0)
  if (( company_mention >= 2 && position_mention >= 1 )); then personal_score=20
  elif (( company_mention >= 1 )); then personal_score=12
  else personal_score=5; fi
  echo "$([ $personal_score -ge 15 ] && echo "✅" || echo "⚠️") 个性化程度 — $personal_score/20"
  score=$((score + personal_score))

  # 5. 行动导向 (15分)
  local action_score=0
  local action_words
  action_words=$(grep -coEi '主导|负责|推动|设计|开发|优化|领导|创建|实现|完成|提升' "$file" 2>/dev/null || echo 0)
  if (( action_words >= 5 )); then action_score=15
  elif (( action_words >= 2 )); then action_score=10
  else action_score=5; fi
  echo "$([ $action_score -ge 10 ] && echo "✅" || echo "⚠️") 行动导向词汇 ($action_words个) — $action_score/15"
  score=$((score + action_score))

  # 6. 无负面词 (10分)
  local neg_score=10
  local neg_words
  neg_words=$(grep -coEi '虽然我不|我没有经验|我知道我缺|抱歉|不好意思|可能不太' "$file" 2>/dev/null || echo 0)
  if (( neg_words > 0 )); then
    neg_score=$((10 - neg_words * 3))
    (( neg_score < 0 )) && neg_score=0
  fi
  echo "$([ $neg_score -ge 8 ] && echo "✅" || echo "⚠️") 自信度 (负面词$neg_words个) — $neg_score/10"
  score=$((score + neg_score))

  echo ""
  echo "---"
  echo ""

  local grade
  if (( score >= 85 )); then grade="🟢 优秀 — 可以直接投递"
  elif (( score >= 70 )); then grade="🟡 良好 — 建议小幅优化"
  elif (( score >= 55 )); then grade="🟠 一般 — 需要修改"
  else grade="🔴 需重写 — 问题较多"; fi

  echo "## 📊 总分: ${score}/100"
  echo "## 📋 评级: ${grade}"
}

# ── 批量生成 ──
batch_generate() {
  local name="$1"
  local positions="$2"  # 逗号分隔的职位列表
  local template="${3:-general}"

  IFS=',' read -ra pos_list <<< "$positions"

  echo "# 📦 批量求职信生成"
  echo ""
  echo "生成数量: ${#pos_list[@]}"
  echo "模板: $template"
  echo ""

  local i=1
  for pos in "${pos_list[@]}"; do
    local trimmed
    trimmed=$(echo "$pos" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    echo "---"
    echo ""
    echo "## 第 ${i} 封 — ${trimmed}"
    echo ""
    generate_letter "$template" "$name" "$trimmed" "[公司]" "3" "经验丰富" "能力突出" "团队优秀"
    echo ""
    ((i++))
  done
}

# ── 帮助 ──
show_help() {
  cat <<'HELP'
✉️ 求职信生成器 — cover.sh

用法: bash cover.sh <command> [args...]

命令:
  write <名字> <职位> <公司> [年限] [亮点1] [亮点2] [亮点3]
        → 生成通用求职信
  tech <名字> <职位> <公司> [年限] [亮点1] [亮点2] [亮点3]
        → 生成技术岗求职信（强调技术栈/项目/开源）
  finance <名字> <职位> <公司> [年限] [亮点1] [亮点2] [亮点3]
        → 生成金融岗求职信（强调资质/业绩/合规）
  creative <名字> <职位> <公司> [年限] [亮点1] [亮点2] [亮点3]
        → 生成创意岗求职信（强调作品/灵感/品牌）
  score <文件>
        → 评分已有求职信（100分制，6个维度）
  batch <名字> <职位1,职位2,...> [模板]
        → 批量生成多封求职信
  help  → 显示帮助

示例:
  bash cover.sh tech "张三" "高级Go开发" "字节跳动" 5 "分布式系统" "性能优化" "开源贡献"
  bash cover.sh finance "李四" "风控分析师" "蚂蚁集团" 4 "风控模型" "CFA持证" "跨部门协作"
  bash cover.sh score my_letter.md
  bash cover.sh batch "王五" "前端开发,全栈工程师,技术经理" tech

💡 评分维度:
  - 长度适中(15分)  - 结构完整(20分)
  - 量化数据(20分)  - 个性化(20分)
  - 行动导向(15分)  - 自信度(10分)
HELP
}

case "$CMD" in
  write)
    IFS='|' read -ra A <<< "$(echo "$INPUT" | sed 's/  */|/g')"
    generate_letter "general" "${A[0]:-}" "${A[1]:-}" "${A[2]:-}" "${A[3]:-}" "${A[4]:-}" "${A[5]:-}" "${A[6]:-}"
    ;;
  tech)
    IFS='|' read -ra A <<< "$(echo "$INPUT" | sed 's/  */|/g')"
    generate_letter "tech" "${A[0]:-}" "${A[1]:-}" "${A[2]:-}" "${A[3]:-}" "${A[4]:-}" "${A[5]:-}" "${A[6]:-}"
    ;;
  finance)
    IFS='|' read -ra A <<< "$(echo "$INPUT" | sed 's/  */|/g')"
    generate_letter "finance" "${A[0]:-}" "${A[1]:-}" "${A[2]:-}" "${A[3]:-}" "${A[4]:-}" "${A[5]:-}" "${A[6]:-}"
    ;;
  creative)
    IFS='|' read -ra A <<< "$(echo "$INPUT" | sed 's/  */|/g')"
    generate_letter "creative" "${A[0]:-}" "${A[1]:-}" "${A[2]:-}" "${A[3]:-}" "${A[4]:-}" "${A[5]:-}" "${A[6]:-}"
    ;;
  score)
    score_letter "${INPUT%% *}"
    ;;
  batch)
    IFS='|' read -ra A <<< "$(echo "$INPUT" | sed 's/  */|/g')"
    batch_generate "${A[0]:-}" "${A[1]:-}" "${A[2]:-general}"
    ;;
  help|*) show_help ;;
esac
