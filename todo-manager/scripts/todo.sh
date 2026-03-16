#!/usr/bin/env bash
# Todo Manager — add, prioritize, eisenhower, pomodoro, weekly, gtd
# Usage: bash todo.sh <command> [args]

CMD="$1"; shift 2>/dev/null; INPUT="$*"

# Split comma-separated items into array
split_items() {
  local IFS=','
  local items=()
  for item in $1; do
    item=$(echo "$item" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    [[ -n "$item" ]] && items+=("$item")
  done
  echo "${items[@]}"
}

case "$CMD" in
  add)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
📝 添加待办事项 (Add Todos)

用法: add <任务1>, <任务2>, <任务3>...

示例:
  add 完成季度报告, 回复客户邮件, 买菜做饭
  add 修复bug#123, 代码review, 更新文档

功能:
  - 自动编号和格式化
  - 生成Markdown清单
  - 添加创建时间

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    IFS=',' read -ra TASKS <<< "$INPUT"
    echo "📝 待办事项清单"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    COUNT=0
    for task in "${TASKS[@]}"; do
      task=$(echo "$task" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      [[ -z "$task" ]] && continue
      COUNT=$((COUNT + 1))
      echo "  $COUNT. [ ] $task"
    done
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "共 $COUNT 项待办 | 创建于 $(date '+%Y-%m-%d %H:%M')"
    echo ""
    echo "Markdown格式:"
    echo '```'
    COUNT=0
    for task in "${TASKS[@]}"; do
      task=$(echo "$task" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      [[ -z "$task" ]] && continue
      COUNT=$((COUNT + 1))
      echo "- [ ] $task"
    done
    echo '```'
    echo ""
    echo "💡 提示: 用 prioritize 命令可以按优先级排序"
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;

  prioritize)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
🎯 优先级排序 (Prioritize Tasks)

用法: prioritize <任务:优先级>, <任务:优先级>...

优先级: 高/h/high, 中/m/medium, 低/l/low
不标注优先级默认为"中"

示例:
  prioritize 写报告:高, 整理文件:低, 回复邮件:中
  prioritize 修bug:h, 开会:m, 学习:l

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    IFS=',' read -ra ITEMS <<< "$INPUT"
    HIGH=()
    MED=()
    LOW=()

    for item in "${ITEMS[@]}"; do
      item=$(echo "$item" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      [[ -z "$item" ]] && continue

      # Extract priority
      if echo "$item" | grep -qiE ':(高|h|high)$'; then
        task=$(echo "$item" | sed -E 's/:(高|h|high)$//i')
        HIGH+=("$task")
      elif echo "$item" | grep -qiE ':(低|l|low)$'; then
        task=$(echo "$item" | sed -E 's/:(低|l|low)$//i')
        LOW+=("$task")
      else
        task=$(echo "$item" | sed -E 's/:(中|m|medium)$//i')
        MED+=("$task")
      fi
    done

    echo "🎯 任务优先级排序"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    if [[ ${#HIGH[@]} -gt 0 ]]; then
      echo "🔴 高优先级 (立即处理)"
      for t in "${HIGH[@]}"; do
        echo "  ‣ $t"
      done
      echo ""
    fi
    if [[ ${#MED[@]} -gt 0 ]]; then
      echo "🟡 中优先级 (今日完成)"
      for t in "${MED[@]}"; do
        echo "  ‣ $t"
      done
      echo ""
    fi
    if [[ ${#LOW[@]} -gt 0 ]]; then
      echo "🟢 低优先级 (有空再做)"
      for t in "${LOW[@]}"; do
        echo "  ‣ $t"
      done
      echo ""
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "建议: 先完成🔴高优先级，再依次处理🟡🟢"
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;

  eisenhower)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
📊 艾森豪威尔矩阵 (Eisenhower Matrix)

用法: eisenhower <任务1>, <任务2>, <任务3>...

每个任务可以用标签标注象限:
  :ui 或 :紧急重要   → 第一象限 (立即做)
  :ni 或 :重要       → 第二象限 (计划做)
  :un 或 :紧急       → 第三象限 (委托做)
  :nn 或 :不重要     → 第四象限 (删除它)
  不标注 → 进入收集箱，需要你手动分类

示例:
  eisenhower 客户投诉:ui, 学英语:ni, 回复通知:un, 刷社交:nn
  eisenhower 做PPT, 修bug, 整理桌面, 看新闻

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    IFS=',' read -ra ITEMS <<< "$INPUT"
    Q1=() # Urgent & Important
    Q2=() # Not Urgent & Important
    Q3=() # Urgent & Not Important
    Q4=() # Not Urgent & Not Important
    INBOX=()

    for item in "${ITEMS[@]}"; do
      item=$(echo "$item" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      [[ -z "$item" ]] && continue

      if echo "$item" | grep -qiE ':(ui|紧急重要)$'; then
        task=$(echo "$item" | sed -E 's/:(ui|紧急重要)$//i')
        Q1+=("$task")
      elif echo "$item" | grep -qiE ':(ni|重要)$'; then
        task=$(echo "$item" | sed -E 's/:(ni|重要)$//i')
        Q2+=("$task")
      elif echo "$item" | grep -qiE ':(un|紧急)$'; then
        task=$(echo "$item" | sed -E 's/:(un|紧急)$//i')
        Q3+=("$task")
      elif echo "$item" | grep -qiE ':(nn|不重要)$'; then
        task=$(echo "$item" | sed -E 's/:(nn|不重要)$//i')
        Q4+=("$task")
      else
        INBOX+=("$item")
      fi
    done

    cat <<'HEADER'
📊 艾森豪威尔决策矩阵
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              紧急              不紧急
        ┌─────────────────┬─────────────────┐
HEADER

    echo "  重要  │ 🔴 Q1: 立即做     │ 🔵 Q2: 计划做     │"
    echo "        │                   │                   │"
    for t in "${Q1[@]}"; do printf "        │  ‣ %-15s │" "$t"; echo "                   │"; done
    [[ ${#Q1[@]} -eq 0 ]] && echo "        │  (空)             │                   │"
    for t in "${Q2[@]}"; do printf "        │                   │  ‣ %-15s │\n" "$t"; done
    [[ ${#Q2[@]} -eq 0 ]] && echo "        │                   │  (空)             │"
    echo "        ├─────────────────┼─────────────────┤"
    echo "  不重要│ 🟡 Q3: 委托做     │ ⚫ Q4: 删除它     │"
    echo "        │                   │                   │"
    for t in "${Q3[@]}"; do printf "        │  ‣ %-15s │" "$t"; echo "                   │"; done
    [[ ${#Q3[@]} -eq 0 ]] && echo "        │  (空)             │                   │"
    for t in "${Q4[@]}"; do printf "        │                   │  ‣ %-15s │\n" "$t"; done
    [[ ${#Q4[@]} -eq 0 ]] && echo "        │                   │  (空)             │"
    echo "        └─────────────────┴─────────────────┘"

    if [[ ${#INBOX[@]} -gt 0 ]]; then
      echo ""
      echo "📥 待分类 (请标注象限):"
      for t in "${INBOX[@]}"; do
        echo "  ? $t → 属于哪个象限？"
      done
    fi

    echo ""
    echo "行动指南:"
    echo "  Q1 🔴 → 现在立刻去做"
    echo "  Q2 🔵 → 安排时间，这是最重要的象限"
    echo "  Q3 🟡 → 能否委托他人？"
    echo "  Q4 ⚫ → 勇敢删除，别浪费时间"
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;

  pomodoro)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
🍅 番茄钟计划 (Pomodoro Planner)

用法: pomodoro <任务 时间估算>, <任务 时间估算>...

时间格式: 30min, 1h, 1.5h, 2h 等

示例:
  pomodoro 写报告 2h, 代码审查 1h, 回邮件 30min
  pomodoro 学英语 1.5h, 整理笔记 45min

番茄钟规则:
  🍅 1个番茄 = 25分钟专注
  ☕ 短休息 = 5分钟
  🌴 长休息 = 15-30分钟 (每4个番茄后)

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    IFS=',' read -ra ITEMS <<< "$INPUT"
    echo "🍅 番茄钟工作计划"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    TOTAL_POMOS=0
    TASK_NUM=0

    for item in "${ITEMS[@]}"; do
      item=$(echo "$item" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      [[ -z "$item" ]] && continue
      TASK_NUM=$((TASK_NUM + 1))

      # Extract time estimate
      TIME_STR=$(echo "$item" | grep -oE '[0-9]+\.?[0-9]*(h|min|m)' | tail -1)
      TASK_NAME=$(echo "$item" | sed -E "s/[[:space:]]*[0-9]+\.?[0-9]*(h|min|m)[[:space:]]*//")

      MINUTES=0
      if [[ -n "$TIME_STR" ]]; then
        if echo "$TIME_STR" | grep -qE 'h$'; then
          HOURS=$(echo "$TIME_STR" | sed 's/h//')
          MINUTES=$(echo "$HOURS * 60" | bc 2>/dev/null | cut -d. -f1)
        elif echo "$TIME_STR" | grep -qE '(min|m)$'; then
          MINUTES=$(echo "$TIME_STR" | sed -E 's/(min|m)//')
        fi
      fi
      [[ "$MINUTES" -eq 0 ]] && MINUTES=25

      POMOS=$(( (MINUTES + 24) / 25 ))
      TOTAL_POMOS=$((TOTAL_POMOS + POMOS))

      echo "  任务 $TASK_NUM: $TASK_NAME"
      echo "  ⏱️  预估: ${MINUTES}分钟 → 需要 $POMOS 个番茄"
      POMO_STR=""
      for ((i=1; i<=POMOS; i++)); do
        POMO_STR="${POMO_STR}🍅"
        if (( i % 4 == 0 && i < POMOS )); then
          POMO_STR="${POMO_STR} 🌴 "
        fi
      done
      echo "  $POMO_STR"
      echo ""
    done

    TOTAL_MIN=$((TOTAL_POMOS * 25))
    SHORT_BREAKS=$((TOTAL_POMOS - 1))
    LONG_BREAKS=$((TOTAL_POMOS / 4))
    SHORT_BREAKS=$((SHORT_BREAKS - LONG_BREAKS))
    [[ $SHORT_BREAKS -lt 0 ]] && SHORT_BREAKS=0
    BREAK_MIN=$((SHORT_BREAKS * 5 + LONG_BREAKS * 20))
    TOTAL_WITH_BREAKS=$((TOTAL_MIN + BREAK_MIN))

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📊 汇总"
    echo "  任务数:     $TASK_NUM"
    echo "  总番茄数:   $TOTAL_POMOS 🍅"
    echo "  专注时间:   ${TOTAL_MIN}分钟 ($(echo "scale=1; $TOTAL_MIN/60" | bc)小时)"
    echo "  休息时间:   ${BREAK_MIN}分钟 (短休${SHORT_BREAKS}次 + 长休${LONG_BREAKS}次)"
    echo "  预计总耗时: ${TOTAL_WITH_BREAKS}分钟 ($(echo "scale=1; $TOTAL_WITH_BREAKS/60" | bc)小时)"
    echo ""
    echo "💡 小贴士: 番茄钟期间遇到干扰，记在纸上稍后处理"
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;

  weekly)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
📅 周计划模板 (Weekly Planner)

用法: weekly <项目/任务1>, <项目/任务2>...

示例:
  weekly 项目A开发, 英语学习, 健身运动
  weekly 客户项目, 内部优化, 团队管理, 个人成长

生成包含:
  - 周一到周日的时间块规划
  - 重要任务分配建议
  - 回顾检查模板

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    IFS=',' read -ra ITEMS <<< "$INPUT"
    TASKS=()
    for item in "${ITEMS[@]}"; do
      item=$(echo "$item" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      [[ -n "$item" ]] && TASKS+=("$item")
    done

    # Get next Monday's date
    echo "📅 周计划模板"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📌 核心项目/任务: ${TASKS[*]}"
    echo ""

    DAYS=("周一 Monday" "周二 Tuesday" "周三 Wednesday" "周四 Thursday" "周五 Friday" "周六 Saturday" "周日 Sunday")
    THEMES=("🚀 冲刺日" "📋 推进日" "🤝 协作日" "📋 推进日" "📦 收尾日" "🌿 充电日" "📝 规划日")

    for i in "${!DAYS[@]}"; do
      echo "┌─────────────────────────────────────┐"
      echo "│ ${DAYS[$i]} — ${THEMES[$i]}"
      echo "├─────────────────────────────────────┤"
      if [[ $i -lt 5 ]]; then
        echo "│ 09:00-12:00  🔴 深度工作"
        # Rotate tasks across days
        TASK_IDX=$((i % ${#TASKS[@]}))
        echo "│   → ${TASKS[$TASK_IDX]}"
        echo "│ 14:00-17:00  🟡 常规工作"
        TASK_IDX2=$(( (i + 1) % ${#TASKS[@]} ))
        echo "│   → ${TASKS[$TASK_IDX2]}"
        echo "│ 17:00-18:00  🟢 收尾整理"
      elif [[ $i -eq 5 ]]; then
        echo "│ 上午  📚 学习/个人项目"
        echo "│ 下午  🏃 运动/休息"
      else
        echo "│ 上午  📝 本周回顾 + 下周规划"
        echo "│ 下午  🌴 休息充电"
      fi
      echo "└─────────────────────────────────────┘"
      echo ""
    done

    echo "✅ 周末回顾清单:"
    echo "  [ ] 本周目标完成了几个？"
    echo "  [ ] 什么做得好？什么需要改进？"
    echo "  [ ] 下周最重要的3件事是什么？"
    echo "  [ ] 有什么需要提前准备的？"
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;

  gtd)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
🧠 GTD 收集箱处理 (Getting Things Done)

用法: gtd <想法/任务1>, <想法/任务2>...

GTD五步法:
  1. 收集 — 倒出脑中所有事情
  2. 处理 — 逐一判断：需要行动吗？
  3. 组织 — 分类到合适的清单
  4. 回顾 — 定期检查
  5. 执行 — 选择并行动

示例:
  gtd 学Python, 约牙医, 买生日礼物, 读完那本书, 修电脑
  gtd 写周报, 回复老板, 整理房间, 计划旅行

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    IFS=',' read -ra ITEMS <<< "$INPUT"

    echo "🧠 GTD 收集箱处理"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📥 Step 1: 收集 (Capture)"
    echo "  已收集 ${#ITEMS[@]} 个条目"
    echo ""
    echo "🔍 Step 2 & 3: 处理 & 组织 (Process & Organize)"
    echo ""
    echo "  对每个条目问自己：这需要行动吗？"
    echo ""

    # Process items with GTD categories
    NEXT_ACTIONS=()
    COUNT=0
    for item in "${ITEMS[@]}"; do
      item=$(echo "$item" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      [[ -z "$item" ]] && continue
      COUNT=$((COUNT + 1))
      NEXT_ACTIONS+=("$item")
    done

    echo "┌─────────────────────────────────────────┐"
    echo "│ 📋 下一步行动 (Next Actions)             │"
    echo "├─────────────────────────────────────────┤"
    for t in "${NEXT_ACTIONS[@]}"; do
      echo "│  → $t"
      echo "│    ❓ 2分钟能做完吗？→ 立刻做！"
      echo "│    ❓ 需要多步？→ 变成项目"
      echo "│    ❓ 特定日期？→ 放进日历"
      echo "│    ❓ 等别人？→ 等待清单"
      echo "│    ❓ 以后再说？→ 将来/也许"
      echo "│"
    done
    echo "└─────────────────────────────────────────┘"
    echo ""

    echo "📂 GTD 清单模板:"
    echo ""
    echo "  📌 下一步行动 (Next Actions):"
    for t in "${NEXT_ACTIONS[@]}"; do
      echo "    - [ ] $t"
    done
    echo ""
    echo "  📁 项目 (Projects):"
    echo "    - [ ] (多步骤任务放这里)"
    echo ""
    echo "  📅 日历 (Calendar):"
    echo "    - [ ] (有具体时间的放这里)"
    echo ""
    echo "  ⏳ 等待 (Waiting For):"
    echo "    - [ ] (等别人完成的放这里)"
    echo ""
    echo "  💭 将来/也许 (Someday/Maybe):"
    echo "    - [ ] (不急的想法放这里)"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "💡 每周回顾一次所有清单，保持系统可靠"
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;

  *)
    cat <<'EOF'
✅ 待办管理工具 (Todo Manager)

用法: bash todo.sh <command> [args]

命令:
  add          添加/整理待办事项
  prioritize   按优先级排序 (高/中/低)
  eisenhower   艾森豪威尔四象限分析
  pomodoro     番茄钟时间规划
  weekly       生成周计划模板
  gtd          GTD收集箱处理

示例:
  bash todo.sh add 任务1, 任务2, 任务3
  bash todo.sh prioritize 任务A:高, 任务B:低
  bash todo.sh eisenhower 客户投诉:ui, 学英语:ni
  bash todo.sh pomodoro 写报告 2h, 审查 1h
  bash todo.sh weekly 项目A, 学习, 健身
  bash todo.sh gtd 想法1, 想法2, 任务3

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
esac
