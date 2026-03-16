#!/usr/bin/env bash
# CET-4/6 四六级备考工具
# 功能: vocab / score / plan / tips / help

set -euo pipefail

# ========== 高频四级词汇库 (50个) ==========
VOCAB_WORDS=(
  "abandon|v. 放弃，抛弃"
  "absolute|adj. 绝对的，完全的"
  "absorb|v. 吸收；使全神贯注"
  "abstract|adj. 抽象的 n. 摘要"
  "abundant|adj. 丰富的，充裕的"
  "access|n. 通道，入口；v. 访问"
  "accommodate|v. 容纳；提供住宿"
  "accomplish|v. 完成，实现"
  "accumulate|v. 积累，积聚"
  "accurate|adj. 精确的，准确的"
  "achieve|v. 实现，达到"
  "acknowledge|v. 承认；致谢"
  "acquire|v. 获得，取得"
  "adapt|v. 适应；改编"
  "adequate|adj. 足够的，适当的"
  "adjust|v. 调整，调节"
  "administration|n. 管理，行政"
  "advance|v. 前进；n. 进步"
  "advocate|v. 提倡；n. 倡导者"
  "affect|v. 影响；感动"
  "afford|v. 负担得起；提供"
  "aggressive|adj. 侵略的；有进取心的"
  "allocate|v. 分配，拨给"
  "alternative|adj. 可替代的 n. 选择"
  "ambitious|adj. 有雄心的"
  "approach|v. 接近 n. 方法"
  "appropriate|adj. 适当的"
  "approve|v. 批准，赞成"
  "arise|v. 出现，产生"
  "assumption|n. 假设，假定"
  "available|adj. 可用的，可获得的"
  "barrier|n. 障碍，屏障"
  "benefit|n. 利益 v. 受益"
  "budget|n. 预算 v. 编预算"
  "capacity|n. 容量；能力"
  "challenge|n. 挑战 v. 质疑"
  "character|n. 性格；角色；字符"
  "circumstance|n. 环境，情况"
  "collapse|v./n. 倒塌，崩溃"
  "commit|v. 犯（罪）；承诺"
  "communicate|v. 交流，沟通"
  "community|n. 社区，团体"
  "comparison|n. 比较，对比"
  "compete|v. 竞争，比赛"
  "component|n. 成分，零件"
  "concentrate|v. 集中，专注"
  "concept|n. 概念，观念"
  "conclusion|n. 结论"
  "considerable|adj. 相当大的"
  "contribute|v. 贡献；投稿"
)

# ========== vocab: 词汇测试 ==========
cmd_vocab() {
  local count=${1:-10}
  if (( count > 50 )); then count=50; fi
  if (( count < 1 )); then count=5; fi

  echo "╔══════════════════════════════════════════╗"
  echo "║     📝 CET-4 高频词汇随机测试            ║"
  echo "║     共抽取 ${count} 个词汇                      ║"
  echo "╚══════════════════════════════════════════╝"
  echo ""

  # 生成随机索引
  local indices=()
  local total=${#VOCAB_WORDS[@]}
  while (( ${#indices[@]} < count )); do
    local r=$(( RANDOM % total ))
    local dup=0
    for idx in "${indices[@]}"; do
      if (( idx == r )); then dup=1; break; fi
    done
    if (( dup == 0 )); then
      indices+=("$r")
    fi
  done

  # 显示词汇
  local i=1
  for idx in "${indices[@]}"; do
    local entry="${VOCAB_WORDS[$idx]}"
    local word="${entry%%|*}"
    local meaning="${entry#*|}"
    printf "  %2d. %-20s %s\n" "$i" "$word" "$meaning"
    (( i++ ))
  done

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "💡 学习建议："
  echo "  1. 先遮住右边释义，看英文回忆中文"
  echo "  2. 再遮住左边单词，看中文拼写英文"
  echo "  3. 每个词造一个句子加深记忆"
  echo "  4. 重点标记不熟悉的词，第二天复习"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# ========== score: 分数计算器 ==========
cmd_score() {
  local level="${1:-4}"
  local listening="${2:-0}"
  local reading="${3:-0}"
  local translation="${4:-0}"
  local writing="${5:-0}"

  echo "╔══════════════════════════════════════════╗"
  echo "║     📊 CET-${level} 成绩换算器                 ║"
  echo "╚══════════════════════════════════════════╝"
  echo ""

  # CET评分说明
  # 听力 248.5分(满分) 阅读 248.5分 翻译106.5分 写作106.5分
  # 总分710分
  # 原始分满分: 听力35题 阅读30题(含选词填空/长篇阅读/仔细阅读)
  # 翻译和写作按15分制

  # 简化换算：按比例映射到710分制
  # 听力: 原始满分35 → 标准分248.5
  # 阅读: 原始满分35 → 标准分248.5  (含选词填空5+长篇阅读10+仔细阅读10+信息匹配10)
  # 翻译: 原始满分15 → 标准分106.5
  # 写作: 原始满分15 → 标准分106.5

  local listen_max=35
  local read_max=35
  local trans_max=15
  local write_max=15

  # 检查输入范围
  if (( listening > listen_max )); then listening=$listen_max; fi
  if (( reading > read_max )); then reading=$read_max; fi
  if (( translation > trans_max )); then translation=$trans_max; fi
  if (( writing > write_max )); then writing=$write_max; fi

  # 换算（用整数运算近似）
  local listen_score=$(( listening * 2485 / listen_max / 10 ))
  local read_score=$(( reading * 2485 / read_max / 10 ))
  local trans_score=$(( translation * 1065 / trans_max / 10 ))
  local write_score=$(( writing * 1065 / write_max / 10 ))
  local total=$(( listen_score + read_score + trans_score + write_score ))

  echo "  📌 输入原始分："
  echo "  ┌─────────────┬──────────┬──────────┐"
  echo "  │ 题型        │ 原始分   │ 满分     │"
  echo "  ├─────────────┼──────────┼──────────┤"
  printf "  │ 听力        │ %-8s │ %-8s │\n" "$listening" "$listen_max"
  printf "  │ 阅读        │ %-8s │ %-8s │\n" "$reading" "$read_max"
  printf "  │ 翻译        │ %-8s │ %-8s │\n" "$translation" "$trans_max"
  printf "  │ 写作        │ %-8s │ %-8s │\n" "$writing" "$write_max"
  echo "  └─────────────┴──────────┴──────────┘"
  echo ""
  echo "  📌 换算标准分（710分制）："
  echo "  ┌─────────────┬──────────┬──────────┐"
  echo "  │ 题型        │ 标准分   │ 满分     │"
  echo "  ├─────────────┼──────────┼──────────┤"
  printf "  │ 听力        │ %-8s │ 248      │\n" "$listen_score"
  printf "  │ 阅读        │ %-8s │ 248      │\n" "$read_score"
  printf "  │ 翻译        │ %-8s │ 106      │\n" "$trans_score"
  printf "  │ 写作        │ %-8s │ 106      │\n" "$write_score"
  echo "  ├─────────────┼──────────┼──────────┤"
  printf "  │ 总分        │ %-8s │ 710      │\n" "$total"
  echo "  └─────────────┴──────────┴──────────┘"
  echo ""

  # 等级判定
  if (( total >= 550 )); then
    echo "  🏆 优秀！可以报考口语考试"
  elif (( total >= 425 )); then
    echo "  ✅ 通过！达到合格线（425分）"
  elif (( total >= 380 )); then
    echo "  ⚠️  接近合格线，再努力一把！"
  else
    echo "  📚 需要加强复习，距合格线还有 $(( 425 - total )) 分"
  fi
}

# ========== plan: 备考计划生成 ==========
cmd_plan() {
  local exam_date="${1:-}"
  local today_ts
  today_ts=$(date +%s)

  if [[ -z "$exam_date" ]]; then
    # 默认下一次考试时间（6月/12月的第三个周六）
    local year month
    year=$(date +%Y)
    month=$(date +%-m)
    if (( month <= 6 )); then
      exam_date="${year}-06-14"
    else
      exam_date="${year}-12-14"
    fi
    echo "  ℹ️  未指定考试日期，默认使用: $exam_date"
  fi

  local exam_ts
  exam_ts=$(date -d "$exam_date" +%s 2>/dev/null || echo "0")
  if (( exam_ts == 0 )); then
    echo "  ❌ 日期格式错误，请使用 YYYY-MM-DD"
    return 1
  fi

  local days_left=$(( (exam_ts - today_ts) / 86400 ))
  if (( days_left < 0 )); then
    echo "  ❌ 考试日期已过！"
    return 1
  fi

  echo "╔══════════════════════════════════════════╗"
  echo "║     📅 CET 备考计划生成器                ║"
  echo "╚══════════════════════════════════════════╝"
  echo ""
  echo "  考试日期: $exam_date"
  echo "  剩余天数: ${days_left} 天"
  echo ""

  if (( days_left > 90 )); then
    echo "  ═══ 第一阶段：基础夯实（前30天）═══"
    echo "  📖 每日任务："
    echo "    • 背诵30个核心词汇 + 复习前一天词汇"
    echo "    • 精读1篇阅读理解（逐句翻译）"
    echo "    • 听力精听15分钟（听写法）"
    echo "    • 语法专项：每天一个语法点"
    echo ""
    echo "  ═══ 第二阶段：强化提升（31-60天）═══"
    echo "  📖 每日任务："
    echo "    • 背诵20个词汇 + 复习本周词汇"
    echo "    • 限时做2篇阅读理解（18分钟内）"
    echo "    • 听力套题练习（1套/天）"
    echo "    • 翻译练习：每天1段中译英"
    echo "    • 背诵3个写作高分句型"
    echo ""
    echo "  ═══ 第三阶段：真题冲刺（61-90天）═══"
    echo "  📖 每日任务："
    echo "    • 整套真题模拟（每2天1套）"
    echo "    • 错题分析和知识点整理"
    echo "    • 作文模板背诵（5篇范文）"
    echo "    • 翻译热点话题练习"
    echo ""
    echo "  ═══ 第四阶段：考前冲刺（最后阶段）═══"
    echo "    • 回顾所有错题"
    echo "    • 模拟考试环境做3套题"
    echo "    • 作文万能模板最终定稿"
    echo "    • 调整作息，保持状态"

  elif (( days_left > 30 )); then
    echo "  ═══ 紧凑型备考计划（${days_left}天）═══"
    echo ""
    echo "  📖 每日必做："
    echo "    • 词汇：背50个 + APP刷词"
    echo "    • 听力：精听30分钟"
    echo "    • 阅读：限时做3篇"
    echo "    • 翻译/写作：交替练习"
    echo ""
    echo "  📖 每周安排："
    echo "    周一至周五：专项突破"
    echo "    周六：整套真题模拟"
    echo "    周日：错题回顾 + 薄弱项加强"
    echo ""
    echo "  📖 最后一周："
    echo "    • 停止背新词，只复习"
    echo "    • 每天1套真题保持手感"
    echo "    • 背熟作文模板"

  else
    echo "  ═══ 冲刺型计划（仅剩${days_left}天！）═══"
    echo ""
    echo "  🔥 核心策略：抓大放小，拿分优先"
    echo ""
    echo "  📖 每日必做："
    echo "    • 真题！真题！真题！每天1套"
    echo "    • 听力：只听真题录音"
    echo "    • 阅读：重点练仔细阅读（分值最高）"
    echo "    • 写作：背3个万能模板"
    echo "    • 翻译：练习热点话题（传统文化/经济/教育）"
    echo ""
    echo "  ⚡ 提分捷径："
    echo "    • 仔细阅读 > 长篇阅读 > 选词填空（按性价比分配时间）"
    echo "    • 听力短对话注意转折词（but/however）"
    echo "    • 作文首尾段背模板，中间段写简单句"
  fi
}

# ========== tips: 答题技巧 ==========
cmd_tips() {
  local section="${1:-all}"

  echo "╔══════════════════════════════════════════╗"
  echo "║     💡 CET 答题技巧大全                  ║"
  echo "╚══════════════════════════════════════════╝"
  echo ""

  if [[ "$section" == "all" || "$section" == "listening" ]]; then
    echo "  ━━━ 🎧 听力技巧 ━━━"
    echo ""
    echo "  1. 预读选项：利用Direction播放时间快速浏览选项"
    echo "  2. 关注转折词：but, however, actually, in fact"
    echo "     转折后面往往是答案"
    echo "  3. 短对话：注意第二个人说的话（常含答案）"
    echo "  4. 长对话/短文：开头和结尾是重点"
    echo "  5. 数字题：听到的第一个数字往往不是答案"
    echo "  6. 态度题：注意语气词和形容词"
    echo "  7. 因果关系：because, since, due to 后是重点"
    echo "  8. 听不懂就选最不像的那个选项"
    echo "  9. 边听边做标记，不要等全部听完再选"
    echo "  10. 不确定的题立刻选，不要纠结影响下一题"
    echo ""
  fi

  if [[ "$section" == "all" || "$section" == "reading" ]]; then
    echo "  ━━━ 📖 阅读技巧 ━━━"
    echo ""
    echo "  【选词填空】（5分，性价比最低，放最后做）"
    echo "  1. 先判断每个空的词性（名词/动词/形容词/副词）"
    echo "  2. 按词性分组候选词"
    echo "  3. 根据上下文语义选择"
    echo "  4. 注意动词时态和名词单复数"
    echo ""
    echo "  【信息匹配】（10分）"
    echo "  1. 先读题目，画出关键词"
    echo "  2. 带着关键词扫读各段"
    echo "  3. 注意同义替换（题目和原文用不同词表达相同意思）"
    echo "  4. 一段可能对应多题，一题只对应一段"
    echo ""
    echo "  【仔细阅读】（20分，最重要！）"
    echo "  1. 先读题目再读文章（带着问题找答案）"
    echo "  2. 定位关键词在文中的位置"
    echo "  3. 主旨题看首尾段"
    echo "  4. 细节题回原文找对应句"
    echo "  5. 推断题注意 imply/suggest/infer"
    echo "  6. 态度题找形容词/副词"
    echo ""
  fi

  if [[ "$section" == "all" || "$section" == "translation" ]]; then
    echo "  ━━━ 🔄 翻译技巧 ━━━"
    echo ""
    echo "  1. 先通读全段，理解大意"
    echo "  2. 逐句翻译，不要跳跃"
    echo "  3. 遇到不会的词用简单词替代（不要空着）"
    echo "  4. 注意中英文语序差异："
    echo "     中文：时间+地点+方式+动作"
    echo "     英文：主语+动作+方式+地点+时间"
    echo "  5. 常考话题准备："
    echo "     • 中国传统文化（春节/中秋/功夫/茶文化）"
    echo "     • 经济发展（改革开放/一带一路/电子商务）"
    echo "     • 教育（高考/留学/素质教育）"
    echo "     • 社会生活（移动支付/共享经济/环保）"
    echo "  6. 高分句型储备："
    echo "     • With the development of..."
    echo "     • It is widely acknowledged that..."
    echo "     • ...plays an important role in..."
    echo ""
  fi

  if [[ "$section" == "all" || "$section" == "writing" ]]; then
    echo "  ━━━ ✍️ 写作技巧 ━━━"
    echo ""
    echo "  【三段式结构】"
    echo "  第一段：引出话题（2-3句）"
    echo "    → 模板: Nowadays, ... has become a hot topic."
    echo "    → 或引用名言/数据开头"
    echo ""
    echo "  第二段：论述分析（5-8句，最重要）"
    echo "    → First and foremost, ..."
    echo "    → In addition, ..."
    echo "    → Last but not least, ..."
    echo ""
    echo "  第三段：总结观点（2-3句）"
    echo "    → In conclusion, ..."
    echo "    → Taking all factors into consideration, ..."
    echo ""
    echo "  【提分要点】"
    echo "  1. 字数：120-180词（四级）/ 150-200词（六级）"
    echo "  2. 书写工整，段落分明"
    echo "  3. 用高级词替换简单词："
    echo "     think → maintain/argue/contend"
    echo "     important → crucial/vital/essential"
    echo "     many → numerous/a multitude of"
    echo "     good → beneficial/favorable"
    echo "  4. 用复杂句式加分："
    echo "     • 定语从句: which/who/that"
    echo "     • 强调句: It is...that..."
    echo "     • 倒装句: Not only...but also..."
    echo "     • 虚拟语气: If I were..."
    echo "  5. 不要用中式英语，不确定的表达用简单句"
    echo ""
  fi

  if [[ "$section" == "all" || "$section" == "time" ]]; then
    echo "  ━━━ ⏰ 时间分配建议 ━━━"
    echo ""
    echo "  总时长：130分钟"
    echo "  ┌──────────────┬──────────┬──────────┐"
    echo "  │ 题型         │ 时间     │ 建议     │"
    echo "  ├──────────────┼──────────┼──────────┤"
    echo "  │ 写作         │ 30分钟   │ 先审题构思5分钟 │"
    echo "  │ 听力         │ 25分钟   │ 跟着录音走 │"
    echo "  │ 阅读-选词    │ 5-8分钟  │ 放最后做  │"
    echo "  │ 阅读-匹配    │ 15分钟   │ 关键词定位 │"
    echo "  │ 阅读-仔细    │ 25-30分钟│ 重点保证  │"
    echo "  │ 翻译         │ 25-30分钟│ 不留空白  │"
    echo "  └──────────────┴──────────┴──────────┘"
    echo ""
    echo "  💡 做题顺序：写作→听力→仔细阅读→信息匹配→翻译→选词填空"
    echo ""
  fi
}

# ========== help: 帮助 ==========
cmd_help() {
  echo "╔══════════════════════════════════════════╗"
  echo "║     📚 CET 四六级备考工具                ║"
  echo "╚══════════════════════════════════════════╝"
  echo ""
  echo "  用法: cet.sh <命令> [参数]"
  echo ""
  echo "  命令:"
  echo "    vocab [数量]          随机词汇测试（默认10个）"
  echo "    score <级别> <听力> <阅读> <翻译> <写作>"
  echo "                          分数换算器"
  echo "                          级别: 4 或 6"
  echo "                          各项填原始分"
  echo "    plan [考试日期]       生成备考计划（YYYY-MM-DD）"
  echo "    tips [题型]           答题技巧"
  echo "                          题型: listening/reading/"
  echo "                          translation/writing/time/all"
  echo "    help                  显示此帮助"
  echo ""
  echo "  示例:"
  echo "    cet.sh vocab 15"
  echo "    cet.sh score 4 25 28 10 11"
  echo "    cet.sh plan 2025-06-14"
  echo "    cet.sh tips reading"
  echo ""
}

# ========== 主入口 ==========
main() {
  local cmd="${1:-help}"
  shift 2>/dev/null || true

  case "$cmd" in
    vocab)    cmd_vocab "$@" ;;
    score)    cmd_score "$@" ;;
    plan)     cmd_plan "$@" ;;
    tips)     cmd_tips "$@" ;;
    help|*)   cmd_help ;;
  esac
}

main "$@"
