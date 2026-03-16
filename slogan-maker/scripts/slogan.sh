#!/usr/bin/env bash
set -euo pipefail

# Slogan Maker — 广告语生成器
# Usage: bash scripts/slogan.sh <command> [args...]

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
  cat <<'EOF'
Slogan Maker — 广告语生成器

Commands:
  create <brand> <keywords> [style]     生成广告语 (品牌名 关键词 风格)
  industry <type>                      行业广告语 (tech|food|education|fashion|health|finance)
  rhyme <word1> <word2>                生成押韵口号
  translate <slogan> <direction>       中英互译 (en2cn|cn2en)
  test <slogan>                        广告语效果评测
  collection <category>                经典广告语库 (tech|luxury|food|sports|auto)
  help                                 显示帮助

Examples:
  slogan.sh create "鲜果时光" "新鲜,健康,活力" "活泼"
  slogan.sh industry tech
  slogan.sh rhyme "品质" "生活"
  slogan.sh translate "Just Do It" "en2cn"
  slogan.sh test "鲜果时光，新鲜每一天"
  slogan.sh collection tech

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

cmd_create() {
  local brand="${1:?请提供品牌名}"
  local keywords="${2:?请提供关键词 (逗号分隔)}"
  local style="${3:-通用}"

  IFS=',' read -ra kws <<< "$keywords"
  local kw1="${kws[0]:-}"
  local kw2="${kws[1]:-}"
  local kw3="${kws[2]:-}"

  cat <<EOF
## ✨ 品牌广告语生成

**品牌**: ${brand}
**关键词**: ${keywords}
**风格**: ${style}

---

### 🏆 推荐广告语

| # | 广告语 | 风格 | 字数 |
|---|--------|------|------|
| 1 | ${brand}，${kw1}由心 | 情感型 | $((${#brand} + ${#kw1} + 3)) |
| 2 | ${kw1}${kw2}，从${brand}开始 | 行动型 | $((${#kw1} + ${#kw2} + ${#brand} + 4)) |
| 3 | 每一天的${kw1}，${brand}为你守护 | 承诺型 | $((${#kw1} + ${#brand} + 8)) |
| 4 | ${brand}，让${kw1}触手可及 | 利益型 | $((${#brand} + ${#kw1} + 7)) |
| 5 | ${kw1}生活，${brand}相伴 | 场景型 | $((${#kw1} + ${#brand} + 4)) |
EOF

  if [[ -n "$kw2" ]]; then
    cat <<EOF
| 6 | ${kw1}与${kw2}，${brand}都给你 | 全面型 | $((${#kw1} + ${#kw2} + ${#brand} + 5)) |
| 7 | ${brand}，${kw1}看得见的${kw2} | 品质型 | $((${#brand} + ${#kw1} + ${#kw2} + 5)) |
EOF
  fi

  if [[ -n "$kw3" ]]; then
    cat <<EOF
| 8 | ${kw1}·${kw2}·${kw3}，就是${brand} | 并列型 | $((${#kw1} + ${#kw2} + ${#kw3} + ${#brand} + 5)) |
EOF
  fi

  cat <<'EOF'

### 💡 创作技巧

- **短**: 理想长度6-10个字
- **顺**: 读起来朗朗上口
- **记**: 有节奏感或画面感
- **准**: 突出核心卖点

### 📝 下一步

1. 选择2-3个候选，用 `slogan.sh test <广告语>` 评测
2. 内部投票选出最佳
3. 小范围用户测试验证
EOF
}

cmd_industry() {
  local industry="${1:?请指定行业: tech|food|education|fashion|health|finance}"

  echo "## 🏭 ${industry} 行业广告语模板"
  echo ""

  case "$industry" in
    tech)
      cat <<'EOF'
| # | 模板 | 示例 | 适用 |
|---|------|------|------|
| 1 | 让[名词]更[形容词] | 让工作更简单 | 工具类 |
| 2 | [动词]未来的[名词] | 连接未来的可能 | 平台类 |
| 3 | 智能[名词]，[形容词]生活 | 智能办公，高效生活 | 智能产品 |
| 4 | 一键[动词]，[名词]无限 | 一键启动，创意无限 | App类 |
| 5 | [名词]，重新定义 | 效率，重新定义 | 创新类 |
| 6 | 你的[名词]，由你[动词] | 你的数据，由你掌控 | 安全类 |
| 7 | 从[A]到[B]，只需一步 | 从想法到产品，只需一步 | 开发工具 |
| 8 | [数字]+[名词]的选择 | 百万开发者的选择 | 社会证明 |
EOF
      ;;
    food)
      cat <<'EOF'
| # | 模板 | 示例 | 适用 |
|---|------|------|------|
| 1 | [形容词]每一口 | 新鲜每一口 | 食品饮料 |
| 2 | 妈妈的味道，[品牌]的品质 | - | 家庭食品 |
| 3 | 一口[品牌]，[感受] | 一口鲜，一口甜 | 零食 |
| 4 | 自然的[名词]，舌尖的[名词] | 自然的馈赠，舌尖的享受 | 有机食品 |
| 5 | [动词]生活，从[品牌]开始 | 品味生活，从XX开始 | 高端食品 |
| 6 | 好[名词]，看得见 | 好食材，看得见 | 透明供应链 |
| 7 | [时间]的[名词] | 24小时的新鲜 | 新鲜食品 |
| 8 | [名词]会说话 | 味道会说话 | 品质自信 |
EOF
      ;;
    education)
      cat <<'EOF'
| # | 模板 | 示例 | 适用 |
|---|------|------|------|
| 1 | 让学习[动词] | 让学习发生 | 通用 |
| 2 | [名词]改变[名词] | 知识改变命运 | 励志型 |
| 3 | 每个[名词]都能[动词] | 每个孩子都能发光 | 素质教育 |
| 4 | [动词]更好的自己 | 遇见更好的自己 | 成人教育 |
| 5 | 学无[名词]，[品牌]相伴 | 学无止境，XX相伴 | 终身学习 |
| 6 | [数字]分钟，学会[技能] | 15分钟，学会Python | 技能培训 |
| 7 | 名师[动词]，[名词]无忧 | 名师指导，升学无忧 | K12 |
EOF
      ;;
    fashion)
      cat <<'EOF'
| # | 模板 | 示例 | 适用 |
|---|------|------|------|
| 1 | 穿出[名词] | 穿出自信 | 通用服装 |
| 2 | [名词]不止于[名词] | 时尚不止于外表 | 品牌理念 |
| 3 | 你的风格，你[动词] | 你的风格，你定义 | 个性化 |
| 4 | [形容词]由内而外 | 美丽由内而外 | 女装 |
| 5 | 为[场景]而生 | 为都市而生 | 功能服装 |
| 6 | [品质]+[舒适]=[品牌] | - | 品质型 |
EOF
      ;;
    health)
      cat <<'EOF'
| # | 模板 | 示例 | 适用 |
|---|------|------|------|
| 1 | 守护[名词]的[名词] | 守护家人的健康 | 保健品 |
| 2 | 自然的力量，[名词]的选择 | 自然的力量，健康的选择 | 天然产品 |
| 3 | [数字]年专注[名词] | 20年专注健康 | 品牌历史 |
| 4 | 每天一点，[名词]多一点 | 每天一点，活力多一点 | 日常保健 |
| 5 | [名词]，从[动词]开始 | 健康，从呼吸开始 | 空气/水 |
EOF
      ;;
    finance)
      cat <<'EOF'
| # | 模板 | 示例 | 适用 |
|---|------|------|------|
| 1 | 让[名词]更[形容词] | 让理财更简单 | 理财App |
| 2 | 稳健[动词]，[名词]未来 | 稳健投资，赢得未来 | 基金 |
| 3 | 你的[名词]，我们[动词] | 你的财富，我们守护 | 银行 |
| 4 | [形容词]每一分 | 珍惜每一分 | 储蓄 |
| 5 | 从[A]到[B]的[名词] | 从今天到未来的保障 | 保险 |
EOF
      ;;
    *)
      echo "❌ 未知行业: ${industry}"
      echo "可选: tech, food, education, fashion, health, finance"
      return 1
      ;;
  esac
}

cmd_rhyme() {
  local word1="${1:?请提供第一个关键词}"
  local word2="${2:?请提供第二个关键词}"

  cat <<EOF
## 🎵 押韵口号生成

**关键词**: ${word1} + ${word2}

### 生成结果

| # | 口号 | 韵脚类型 |
|---|------|---------|
| 1 | 好${word1}好${word2}，天天好心情 | 叠字韵 |
| 2 | ${word1}在手，${word2}我有 | 尾韵 |
| 3 | 选${word1}，享${word2}，就是这么简单 | 三段式 |
| 4 | 有${word1}有${word2}，生活更加有滋有味 | 排比 |
| 5 | ${word1}${word2}两相宜，幸福生活从此起 | 七言韵 |
| 6 | 一份${word1}，十分${word2} | 数字对比 |

### 押韵技巧

- **尾韵**: 句末字韵母相同 (最常用)
- **头韵**: 句首字声母相同 (英语常用)
- **内韵**: 句中间的字押韵 (更复杂)
- **叠字**: 重复关键字创造节奏感

💡 朗读3遍，选最上口的那个
EOF
}

cmd_translate() {
  local slogan="${1:?请提供广告语}"
  local direction="${2:-en2cn}"

  echo "## 🌐 广告语翻译"
  echo ""
  echo "**原文**: ${slogan}"
  echo "**方向**: ${direction}"
  echo ""

  case "$direction" in
    en2cn)
      cat <<EOF
### 翻译建议

| # | 翻译版本 | 策略 |
|---|---------|------|
| 1 | (直译版) | 忠实原意，保持逻辑 |
| 2 | (意译版) | 符合中文表达习惯 |
| 3 | (创意版) | 重新创作，保留精神 |

### 经典案例参考

| 英文原文 | 中文翻译 | 策略 |
|---------|---------|------|
| Just Do It | 放手去做 / 想做就做 | 意译 |
| Think Different | 非同凡想 | 创意翻译 |
| Impossible is Nothing | 没有不可能 | 直译 |
| I'm Lovin' It | 我就喜欢 | 意译 |
| The Best a Man Can Get | 男人的选择 | 缩写意译 |

### 翻译原则

1. **音美** — 读起来顺口
2. **意美** — 意思准确传达
3. **形美** — 字数精炼对称
4. **文化适配** — 避免文化误解
EOF
      ;;
    cn2en)
      cat <<EOF
### 翻译建议

| # | Translation | Strategy |
|---|------------|----------|
| 1 | (Literal) | Direct translation |
| 2 | (Adaptive) | English expression habits |
| 3 | (Creative) | Reimagined for global audience |

### Tips

- Keep it under 6 words
- Use active voice
- Consider alliteration
- Test with native speakers
EOF
      ;;
    *)
      echo "❌ 不支持的方向: ${direction}"
      echo "可选: en2cn, cn2en"
      return 1
      ;;
  esac
}

cmd_test() {
  local slogan="${1:?请提供广告语}"

  local char_count=${#slogan}
  local word_score=0
  local memory_score=0
  local emotion_score=0
  local clarity_score=0
  local unique_score=0

  # Simple heuristic scoring
  # Length: 6-10 chars = 100, 4-5 or 11-15 = 80, else 60
  if (( char_count >= 6 && char_count <= 10 )); then
    word_score=95
  elif (( char_count >= 4 && char_count <= 15 )); then
    word_score=80
  elif (( char_count <= 20 )); then
    word_score=65
  else
    word_score=50
  fi

  # Other scores (heuristic based on length and structure)
  if (( char_count <= 12 )); then
    memory_score=90
  else
    memory_score=$((100 - char_count * 2))
    (( memory_score < 40 )) && memory_score=40
  fi

  # Check for comma/symmetry (suggests rhythm)
  if [[ "$slogan" == *"，"* ]]; then
    emotion_score=85
    clarity_score=85
  else
    emotion_score=70
    clarity_score=75
  fi

  unique_score=75  # Default

  local total=$(( (word_score + memory_score + emotion_score + clarity_score + unique_score) / 5 ))

  cat <<EOF
## 📝 广告语评测

**测试对象**: "${slogan}"

### 评分结果

\`\`\`
┌──────────────────────────────────────┐
│         广告语评测报告                 │
├──────────────────────────────────────┤
│                                      │
│  简洁度:   $(printf "%-3d" "$word_score")/100  $(printf '█%.0s' $(seq 1 $((word_score/10))))
│  记忆度:   $(printf "%-3d" "$memory_score")/100  $(printf '█%.0s' $(seq 1 $((memory_score/10))))
│  情感度:   $(printf "%-3d" "$emotion_score")/100  $(printf '█%.0s' $(seq 1 $((emotion_score/10))))
│  清晰度:   $(printf "%-3d" "$clarity_score")/100  $(printf '█%.0s' $(seq 1 $((clarity_score/10))))
│  独特度:   $(printf "%-3d" "$unique_score")/100  $(printf '█%.0s' $(seq 1 $((unique_score/10))))
│                                      │
│  ✨ 综合评分:  ${total}/100
│                                      │
└──────────────────────────────────────┘
\`\`\`

### 分析

- **字数**: ${char_count}字 $(if (( char_count <= 10 )); then echo "(✅ 理想长度)"; elif (( char_count <= 15 )); then echo "(🟡 稍长)"; else echo "(🔴 过长)"; fi)
$(if [[ "$slogan" == *"，"* ]]; then echo "- **结构**: 有停顿节奏 (✅)"; else echo "- **结构**: 一气呵成 (✅)"; fi)
- **综合**: $(if (( total >= 85 )); then echo "🏆 优秀！可以直接使用"; elif (( total >= 70 )); then echo "👍 良好，可进一步打磨"; elif (( total >= 55 )); then echo "🟡 一般，建议优化"; else echo "🔴 需要重新创作"; fi)

### 优化建议

1. $(if (( char_count > 12 )); then echo "尝试缩短到10字以内"; else echo "长度合适，保持精炼"; fi)
2. 朗读3遍，检查是否上口
3. 去掉非核心信息
4. 找5个人测试，看能否复述
EOF
}

cmd_collection() {
  local category="${1:?请指定类别: tech|luxury|food|sports|auto}"

  echo "## 📚 经典广告语库: ${category}"
  echo ""

  case "$category" in
    tech)
      cat <<'EOF'
| 品牌 | 广告语 | 分析 |
|------|--------|------|
| Apple | Think Different | 2词定义品牌精神 |
| Google | Don't be evil | 简单直接的价值观 |
| Microsoft | Empowering us all | 赋能感 |
| IBM | Think | 极简主义巅峰 |
| Intel | Intel Inside | 位置感+信任 |
| Nokia | Connecting People | 功能+情感 |
| 华为 | 构建万物互联的智能世界 | 宏大愿景 |
| 小米 | 让每个人都能享受科技的乐趣 | 普惠理念 |
| 字节跳动 | Inspire Creativity | 国际化表达 |
| 钉钉 | 让工作更简单 | 功能承诺 |
EOF
      ;;
    luxury)
      cat <<'EOF'
| 品牌 | 广告语 | 分析 |
|------|--------|------|
| De Beers | 钻石恒久远，一颗永流传 | 经典中的经典 |
| L'Oréal | 你值得拥有 | 自我价值认同 |
| Chanel | 时尚易逝，风格永存 | 超越时尚 |
| Rolex | 每一秒都值得 | 时间+价值 |
| LV | 旅行的真谛 | 精神层面 |
| Cartier | 皇帝的珠宝商 | 身份象征 |
| Hermès | 匠心传承 | 工艺精神 |
| Tiffany | 真爱无价 | 情感连接 |
EOF
      ;;
    food)
      cat <<'EOF'
| 品牌 | 广告语 | 分析 |
|------|--------|------|
| McDonald's | I'm Lovin' It | 情感直接 |
| KFC | 指点好滋味 | 动作+感受 |
| Coca-Cola | Open Happiness | 场景化 |
| 农夫山泉 | 我们不生产水，我们只是大自然的搬运工 | 画面感 |
| 脑白金 | 今年过节不收礼，收礼只收脑白金 | 洗脑重复 |
| 王老吉 | 怕上火喝王老吉 | 场景+方案 |
| 六个核桃 | 经常用脑，多喝六个核桃 | 人群+方案 |
| 蒙牛 | 每天一杯奶，强壮中国人 | 日常+宏大 |
EOF
      ;;
    sports)
      cat <<'EOF'
| 品牌 | 广告语 | 分析 |
|------|--------|------|
| Nike | Just Do It | 行动号召 |
| Adidas | Impossible is Nothing | 挑战精神 |
| Under Armour | I Will | 意志力 |
| Puma | Forever Faster | 速度基因 |
| 李宁 | 一切皆有可能 | 本土化Nike |
| 安踏 | 永不止步 | 坚持精神 |
| Keep | 自律给我自由 | 矛盾统一 |
| Red Bull | 给你翅膀 | 产品拟人 |
EOF
      ;;
    auto)
      cat <<'EOF'
| 品牌 | 广告语 | 分析 |
|------|--------|------|
| BMW | 驾驶的乐趣 | 核心体验 |
| Mercedes | The Best or Nothing | 极致追求 |
| Audi | 突破科技，启迪未来 | 创新定位 |
| Toyota | 车到山前必有路，有路必有丰田车 | 中国神翻译 |
| Volvo | 为了生命 | 安全基因 |
| Porsche | There is no substitute | 不可替代 |
| Tesla | 加速世界向可持续能源转变 | 使命驱动 |
| 比亚迪 | 成就梦想 | 本土励志 |
EOF
      ;;
    *)
      echo "❌ 未知类别: ${category}"
      echo "可选: tech, luxury, food, sports, auto"
      return 1
      ;;
  esac
}

case "$CMD" in
  create)     cmd_create "$@" ;;
  industry)   cmd_industry "$@" ;;
  rhyme)      cmd_rhyme "$@" ;;
  translate)  cmd_translate "$@" ;;
  test)       cmd_test "$@" ;;
  collection) cmd_collection "$@" ;;
  help|--help) show_help ;;
  *)
    echo "❌ 未知命令: $CMD"
    echo "运行 'slogan.sh help' 查看帮助"
    exit 1
    ;;
esac
