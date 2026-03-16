#!/usr/bin/env bash
# Decision Maker — analyze, pros-cons, matrix, blind, framework, risk
# Usage: bash decide.sh <command> [args]

CMD="$1"; shift 2>/dev/null; INPUT="$*"

case "$CMD" in
  analyze)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
🔍 决策全面分析 (Decision Analysis)

用法: analyze <决策问题描述>

示例:
  analyze 是否跳槽到新公司
  analyze 选择考研还是工作
  analyze 是否搬到另一个城市

输出包含:
  - 关键问题梳理
  - 影响因素分析
  - 决策框架推荐
  - 思考清单

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    cat <<EOF
🔍 决策分析: $INPUT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Step 1: 明确问题
┌─────────────────────────────────────────┐
│ 核心问题: $INPUT
│
│ 问自己:
│  ❓ 这个决定的本质是什么？
│  ❓ 为什么现在需要做这个决定？
│  ❓ 不做决定的后果是什么？
│  ❓ 最迟什么时候必须决定？
└─────────────────────────────────────────┘

🎯 Step 2: 影响因素分析
┌─────────────────────────────────────────┐
│ 短期影响 (1-3个月):
│  • 经济/金钱: ______
│  • 时间/精力: ______
│  • 情绪/压力: ______
│
│ 长期影响 (1-5年):
│  • 职业发展: ______
│  • 人际关系: ______
│  • 个人成长: ______
│  • 生活质量: ______
└─────────────────────────────────────────┘

⚖️ Step 3: 10/10/10 法则
┌─────────────────────────────────────────┐
│  10分钟后: 我会怎么想/感受？
│  10个月后: 这个决定还重要吗？
│  10年后:   我会庆幸还是后悔？
└─────────────────────────────────────────┘

🔄 Step 4: 反转测试
┌─────────────────────────────────────────┐
│ 如果已经做了这个决定，我会想撤回吗？
│   → 想撤回 = 可能不该做
│   → 不想撤回 = 倾向于做
└─────────────────────────────────────────┘

💡 推荐下一步:
  1. 用 pros-cons 做利弊对比
  2. 用 matrix 做加权评估
  3. 用 risk 做风险分析
  4. 用 blind 消除偏见后再选

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;

  pros-cons)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
⚖️ 利弊对比 (Pros & Cons)

用法: pros-cons <方案A> vs <方案B>
  或: pros-cons <单个选项>

示例:
  pros-cons 留在现公司 vs 跳槽新公司
  pros-cons 买房
  pros-cons 自研 vs 外包 vs 开源方案

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    # Split by "vs"
    IFS_OLD="$IFS"
    OPTIONS=()
    if echo "$INPUT" | grep -qi ' vs '; then
      while IFS= read -r opt; do
        opt=$(echo "$opt" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        [[ -n "$opt" ]] && OPTIONS+=("$opt")
      done <<< "$(echo "$INPUT" | sed 's/ vs /\n/gi')"
    else
      OPTIONS+=("$INPUT")
    fi

    echo "⚖️ 利弊对比分析"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    for opt in "${OPTIONS[@]}"; do
      cat <<EOF
┌─────────────────────────────────────────┐
│ 📌 方案: $opt
├──────────────────┬──────────────────────┤
│ ✅ 优点 (Pros)   │ ❌ 缺点 (Cons)       │
├──────────────────┼──────────────────────┤
│ 1.               │ 1.                   │
│ 2.               │ 2.                   │
│ 3.               │ 3.                   │
│ 4.               │ 4.                   │
│ 5.               │ 5.                   │
├──────────────────┼──────────────────────┤
│ 权重合计: __/10  │ 权重合计: __/10      │
└──────────────────┴──────────────────────┘

EOF
    done

    if [[ ${#OPTIONS[@]} -gt 1 ]]; then
      echo "📊 对比总结模板:"
      echo "┌─────────────────┬──────────┬──────────┐"
      echo "│ 维度            │ ${OPTIONS[0]::8}    │ ${OPTIONS[1]::8}    │"
      echo "├─────────────────┼──────────┼──────────┤"
      echo "│ 经济收益         │  ?/10    │  ?/10    │"
      echo "│ 个人成长         │  ?/10    │  ?/10    │"
      echo "│ 风险程度         │  ?/10    │  ?/10    │"
      echo "│ 机会成本         │  ?/10    │  ?/10    │"
      echo "│ 可逆性           │  ?/10    │  ?/10    │"
      echo "├─────────────────┼──────────┼──────────┤"
      echo "│ 总分             │  ?/50    │  ?/50    │"
      echo "└─────────────────┴──────────┴──────────┘"
    fi
    echo ""
    echo "💡 填写提示: 给每个优缺点打权重(1-10)，更客观"
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;

  matrix)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
📊 加权决策矩阵 (Weighted Decision Matrix)

用法: matrix <方案1>, <方案2>, <方案3>...

示例:
  matrix React, Vue, Angular
  matrix 北京, 上海, 深圳
  matrix 方案A, 方案B, 方案C

输出: 可填写的加权评分矩阵模板

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    IFS=',' read -ra OPTIONS <<< "$INPUT"
    CLEAN_OPTS=()
    for opt in "${OPTIONS[@]}"; do
      opt=$(echo "$opt" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      [[ -n "$opt" ]] && CLEAN_OPTS+=("$opt")
    done

    echo "📊 加权决策矩阵"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "方案: ${CLEAN_OPTS[*]}"
    echo ""

    # Header
    printf "┌──────────────┬────────┐"
    for opt in "${CLEAN_OPTS[@]}"; do
      printf "──────────┬"
    done
    echo ""

    printf "│ 评估维度     │ 权重   │"
    for opt in "${CLEAN_OPTS[@]}"; do
      printf " %-8s │" "${opt::8}"
    done
    echo ""

    printf "├──────────────┼────────┤"
    for opt in "${CLEAN_OPTS[@]}"; do
      printf "──────────┤"
    done
    echo ""

    # Criteria rows
    CRITERIA=("成本/价格" "质量/性能" "易用性" "可扩展性" "风险程度" "时间成本" "团队适配" "长期价值")
    for c in "${CRITERIA[@]}"; do
      printf "│ %-12s │   /10  │" "$c"
      for opt in "${CLEAN_OPTS[@]}"; do
        printf "   /10    │"
      done
      echo ""
    done

    printf "├──────────────┼────────┤"
    for opt in "${CLEAN_OPTS[@]}"; do
      printf "──────────┤"
    done
    echo ""

    printf "│ 加权总分     │        │"
    for opt in "${CLEAN_OPTS[@]}"; do
      printf "   /100   │"
    done
    echo ""

    printf "└──────────────┴────────┘"
    for opt in "${CLEAN_OPTS[@]}"; do
      printf "──────────┘"
    done
    echo ""

    echo ""
    echo "📝 使用方法:"
    echo "  1. 给每个维度设权重 (1-10，10=最重要)"
    echo "  2. 给每个方案在各维度打分 (1-10)"
    echo "  3. 加权分 = Σ(权重 × 得分)"
    echo "  4. 最高分 = 最优方案"
    echo ""
    echo "💡 可以根据实际情况增删评估维度"
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;

  blind)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
🎲 盲选 - 消除偏见 (Blind Choice)

用法: blind <选项1>, <选项2>, <选项3>...

功能:
  - 随机打乱顺序，消除锚定效应
  - 匿名化选项，减少情感偏见
  - 提供硬币测试法
  - 帮助识别内心真实偏好

示例:
  blind 留在北京, 去上海, 去深圳
  blind 方案A, 方案B, 方案C

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    IFS=',' read -ra OPTIONS <<< "$INPUT"
    CLEAN_OPTS=()
    for opt in "${OPTIONS[@]}"; do
      opt=$(echo "$opt" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      [[ -n "$opt" ]] && CLEAN_OPTS+=("$opt")
    done

    NUM=${#CLEAN_OPTS[@]}

    # Shuffle using random
    SHUFFLED=()
    INDICES=()
    for ((i=0; i<NUM; i++)); do INDICES+=($i); done

    for ((i=NUM-1; i>0; i--)); do
      j=$((RANDOM % (i + 1)))
      tmp=${INDICES[$i]}
      INDICES[$i]=${INDICES[$j]}
      INDICES[$j]=$tmp
    done

    for idx in "${INDICES[@]}"; do
      SHUFFLED+=("${CLEAN_OPTS[$idx]}")
    done

    echo "🎲 盲选 - 消除决策偏见"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🔀 Step 1: 随机排序 (消除锚定效应)"
    echo ""
    for ((i=0; i<NUM; i++)); do
      LETTER=$(printf "\\$(printf '%03o' $((65+i)))")
      echo "  选项 $LETTER: ${SHUFFLED[$i]}"
    done
    echo ""

    echo "🎭 Step 2: 匿名评分"
    echo "  不看选项名称，只看描述来评分"
    echo ""
    for ((i=0; i<NUM; i++)); do
      LETTER=$(printf "\\$(printf '%03o' $((65+i)))")
      echo "  选项 $LETTER 满意度: ___/10"
    done
    echo ""

    # Random pick
    LUCKY=$((RANDOM % NUM))
    echo "🎯 Step 3: 硬币测试法"
    echo "┌─────────────────────────────────────────┐"
    echo "│ 随机结果指向: ${SHUFFLED[$LUCKY]}"
    echo "│"
    echo "│ 看到这个结果，你的第一反应是什么？"
    echo "│"
    echo "│   😊 松了口气 → 这可能就是你的答案"
    echo "│   😟 有点失望 → 你其实想选别的"
    echo "│   😐 无所谓   → 选哪个差别不大"
    echo "│"
    echo "│ 这个方法的关键不在于结果，"
    echo "│ 而在于你对结果的情绪反应。"
    echo "└─────────────────────────────────────────┘"
    echo ""
    echo "💡 如果硬币测试后你想\"再来一次\"，"
    echo "   说明你心里已经有了答案。"
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;

  framework)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
🧭 决策框架推荐 (Decision Framework)

用法: framework <决策场景>

示例:
  framework 职业选择
  framework 投资决策
  framework 技术选型
  framework 人生大事

输出: 最适合该场景的决策框架和步骤

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    cat <<EOF
🧭 决策框架推荐
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
场景: $INPUT

📚 推荐框架:

1️⃣ WRAP 框架 (适合重要决策)
┌─────────────────────────────────────────┐
│ W - Widen Options (拓宽选择)            │
│   → 除了A和B，还有C吗？                 │
│   → 有没有"既要...又要..."的方案？        │
│                                         │
│ R - Reality-test (验证假设)             │
│   → 我的假设有数据支持吗？               │
│   → 去问问有经验的人                     │
│                                         │
│ A - Attain Distance (保持距离)          │
│   → 如果是朋友遇到这个问题，我会建议什么？│
│   → 用10/10/10法则检验                  │
│                                         │
│ P - Prepare to be wrong (准备应变)      │
│   → 最坏情况是什么？能承受吗？            │
│   → 设置止损线/触发条件                  │
└─────────────────────────────────────────┘

2️⃣ 二阶思维 (Second-Order Thinking)
┌─────────────────────────────────────────┐
│ 第一层: 这个决定的直接结果是什么？        │
│ 第二层: 这些结果又会导致什么？             │
│ 第三层: 连锁反应的终点在哪里？            │
│                                         │
│ 大多数人只想到第一层，                    │
│ 优秀的决策者会想到第二、三层。            │
└─────────────────────────────────────────┘

3️⃣ 可逆性检验
┌─────────────────────────────────────────┐
│ 这个决定可以撤回吗？                     │
│                                         │
│ ✅ 可逆决策 → 快速决定，边做边调整       │
│   (例: 试用新工具，尝试新方法)           │
│                                         │
│ ❌ 不可逆决策 → 慎重分析，多方验证       │
│   (例: 签长期合同，重大投资)             │
│                                         │
│ 80%的决策是可逆的，不要过度分析。        │
└─────────────────────────────────────────┘

4️⃣ 预验尸法 (Pre-mortem)
┌─────────────────────────────────────────┐
│ 假设已经做了这个决定，而且失败了...       │
│                                         │
│ → 最可能因为什么失败？                   │
│ → 有哪些我忽视的风险？                   │
│ → 现在能做什么预防？                     │
│                                         │
│ 这比事后复盘有效100倍。                  │
└─────────────────────────────────────────┘

💡 建议: 重要决策至少用2个框架交叉验证

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;

  risk)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
⚠️ 风险评估 (Risk Assessment)

用法: risk <决策/项目描述>

示例:
  risk 投资创业项目
  risk 转行做自由职业
  risk 引入新技术栈

输出:
  - 风险识别矩阵
  - 概率×影响评估
  - 风险应对策略
  - 止损计划

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    cat <<EOF
⚠️ 风险评估报告
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
决策: $INPUT

📊 风险矩阵 (概率 × 影响)
┌──────────┬──────────┬──────────┬──────────┐
│          │ 低影响   │ 中影响   │ 高影响   │
├──────────┼──────────┼──────────┼──────────┤
│ 高概率   │ 🟡 关注  │ 🟠 警惕  │ 🔴 危险  │
│ 中概率   │ 🟢 接受  │ 🟡 关注  │ 🟠 警惕  │
│ 低概率   │ 🟢 忽略  │ 🟢 接受  │ 🟡 关注  │
└──────────┴──────────┴──────────┴──────────┘

📋 风险识别清单

  请逐一评估以下风险:

  1. 💰 财务风险
     概率: [ ]/5  影响: [ ]/5  等级: ____
     描述: ______________________________

  2. ⏰ 时间风险
     概率: [ ]/5  影响: [ ]/5  等级: ____
     描述: ______________________________

  3. 👥 人力风险
     概率: [ ]/5  影响: [ ]/5  等级: ____
     描述: ______________________________

  4. 🔧 技术风险
     概率: [ ]/5  影响: [ ]/5  等级: ____
     描述: ______________________________

  5. 📈 市场风险
     概率: [ ]/5  影响: [ ]/5  等级: ____
     描述: ______________________________

  6. ⚖️ 法律/合规风险
     概率: [ ]/5  影响: [ ]/5  等级: ____
     描述: ______________________________

🛡️ 风险应对策略
┌──────────┬──────────────────────────────┐
│ 策略     │ 适用场景                      │
├──────────┼──────────────────────────────┤
│ 🔴 规避  │ 不做这件事，完全避开风险      │
│ 🟠 转移  │ 保险、外包、合同分摊         │
│ 🟡 缓解  │ 降低概率或减轻影响           │
│ 🟢 接受  │ 风险可控，准备应急方案        │
└──────────┴──────────────────────────────┘

🚫 止损计划
┌─────────────────────────────────────────┐
│ 止损线: 当 ______ 发生时，立即停止       │
│ 触发条件:                                │
│   • 亏损超过 _____ 时                    │
│   • 连续 _____ 天没有进展时              │
│   • 关键假设 _____ 被证伪时              │
│                                         │
│ 退出方案:                                │
│   • 如何最小化损失？                     │
│   • 谁需要被通知？                       │
│   • 如何总结教训？                       │
└─────────────────────────────────────────┘

💡 记住: 所有投资都有风险，关键是风险是否在承受范围内

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;

  *)
    cat <<'EOF'
🤔 决策分析工具 (Decision Maker)

用法: bash decide.sh <command> [args]

命令:
  analyze    全面分析一个决策问题
  pros-cons  利弊对比分析
  matrix     加权决策矩阵
  blind      盲选(消除偏见)
  framework  推荐决策框架
  risk       风险评估分析

示例:
  bash decide.sh analyze 是否跳槽
  bash decide.sh pros-cons 留下 vs 离开
  bash decide.sh matrix 方案A, 方案B, 方案C
  bash decide.sh blind 选项1, 选项2, 选项3
  bash decide.sh framework 职业选择
  bash decide.sh risk 投资创业

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
esac
