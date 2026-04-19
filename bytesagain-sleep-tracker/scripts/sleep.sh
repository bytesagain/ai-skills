#!/usr/bin/env bash
# sleep-tracker — 睡眠改善工具
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

JOURNAL_FILE="/tmp/sleep_journal.txt"

show_help() {
  cat <<'EOF'
╔══════════════════════════════════════════════════════════╗
║              😴 Sleep Tracker 睡眠改善工具               ║
╚══════════════════════════════════════════════════════════╝

Usage: bash sleep.sh <command> [args...]

Commands:
  analyze   <bedtime> <waketime> [quality]    分析睡眠质量
      quality: 1-10 (1=极差, 10=极佳)
  improve   <issue>                            改善建议
      issue: insomnia | snoring | restless | early-wake | oversleep
  schedule  <wake_time> [cycles]               最佳入睡时间
      cycles: 4-6 (默认5-6)
  environment                                  睡眠环境优化
  nap       <duration_min> [time]              小睡建议
  journal   <date> <bed> <wake> <quality> [n]  记录睡眠
  help                                         显示此帮助

Examples:
  bash sleep.sh analyze 23:30 07:00 7
  bash sleep.sh improve insomnia
  bash sleep.sh schedule 07:00
  bash sleep.sh environment
  bash sleep.sh nap 20 13:00
  bash sleep.sh journal 2024-01-15 23:00 06:30 6 "多梦"

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

# Convert HH:MM to minutes since midnight
to_minutes() {
  local time="$1"
  local h="${time%%:*}"
  local m="${time##*:}"
  h=$((10#$h))
  m=$((10#$m))
  echo $((h * 60 + m))
}

cmd_analyze() {
  local bedtime="${1:?用法: analyze <bedtime> <waketime> [quality]}"
  local waketime="${2:?请提供起床时间}"
  local quality="${3:-0}"

  local bed_min wake_min sleep_min
  bed_min=$(to_minutes "$bedtime")
  wake_min=$(to_minutes "$waketime")

  if [ "$wake_min" -le "$bed_min" ]; then
    sleep_min=$((wake_min + 1440 - bed_min))
  else
    sleep_min=$((wake_min - bed_min))
  fi

  local sleep_hours sleep_rem
  sleep_hours=$((sleep_min / 60))
  sleep_rem=$((sleep_min % 60))
  local cycles=$((sleep_min / 90))
  local cycle_rem=$((sleep_min % 90))

  # Sleep quality assessment
  local rating rating_icon
  if [ "$sleep_min" -ge 420 ] && [ "$sleep_min" -le 540 ]; then
    rating="优秀" rating_icon="🟢"
  elif [ "$sleep_min" -ge 360 ] && [ "$sleep_min" -le 600 ]; then
    rating="良好" rating_icon="🟡"
  elif [ "$sleep_min" -ge 300 ]; then
    rating="不足" rating_icon="🟠"
  else
    rating="严重不足" rating_icon="🔴"
  fi

  # Cycle alignment
  local cycle_align
  if [ "$cycle_rem" -le 15 ] || [ "$cycle_rem" -ge 75 ]; then
    cycle_align="✅ 在周期结束时醒来，醒后应感觉清醒"
  else
    cycle_align="⚠️ 可能在周期中间醒来，会感觉困倦"
  fi

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           😴 睡眠质量分析
╚══════════════════════════════════════════════════════════╝

📋 睡眠数据
────────────────────────────────────────
  入睡时间:   ${bedtime}
  起床时间:   ${waketime}
  睡眠时长:   ${sleep_hours}小时${sleep_rem}分钟 (${sleep_min}分钟)
  睡眠周期:   约${cycles}个完整周期
  时长评级:   ${rating_icon} ${rating}
$([ "$quality" != "0" ] && echo "  主观质量:   ${quality}/10")

📊 睡眠周期分析
────────────────────────────────────────
  每个周期约90分钟:
  浅睡 → 深睡 → REM(做梦) → 浅睡...

  你的周期: ${cycles}个完整 + ${cycle_rem}分钟
  ${cycle_align}

📈 评估
────────────────────────────────────────
EOF

  if [ "$sleep_min" -lt 360 ]; then
    echo "  ⚠️  睡眠时间不足6小时！"
    echo "  建议: 尽量保证7-9小时睡眠"
    echo "  风险: 长期睡眠不足影响免疫力、记忆力、情绪"
  elif [ "$sleep_min" -gt 600 ]; then
    echo "  ⚠️  睡眠超过10小时"
    echo "  注意: 过度睡眠可能提示身体问题"
    echo "  建议: 如经常如此，建议咨询医生"
  else
    echo "  ✅ 睡眠时长在健康范围内"
    echo "  建议: 保持规律作息，周末也不要差太多"
  fi

  # Bedtime assessment
  echo ""
  if [ "$bed_min" -lt 1320 ] && [ "$bed_min" -gt 360 ]; then
    echo "  ⚠️  入睡时间较早 (${bedtime})"
  elif [ "$bed_min" -ge 1380 ] || [ "$bed_min" -le 60 ]; then
    echo "  ⚠️  入睡时间偏晚 (${bedtime})，建议提前到23:00前"
  else
    echo "  ✅ 入睡时间合理 (${bedtime})"
  fi
}

cmd_improve() {
  local issue="${1:?用法: improve <issue> (insomnia|snoring|restless|early-wake|oversleep)}"

  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║           💤 睡眠改善: ${issue}"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""

  case "$issue" in
    insomnia|失眠)
      cat <<'EOF'
😵 失眠改善方案
────────────────────────────────────────

  📋 睡眠卫生习惯
  ─────────────────
  ✅ 固定时间上床和起床（周末也是）
  ✅ 床只用于睡觉（不要在床上玩手机/工作）
  ✅ 20分钟睡不着就起来，有困意再回去
  ✅ 睡前1小时开始放松（调暗灯光，不看屏幕）

  📋 白天注意事项
  ─────────────────
  ✅ 白天多晒太阳（调节褪黑素）
  ✅ 下午2点后不喝咖啡/茶
  ✅ 规律运动（但睡前2小时不做剧烈运动）
  ✅ 午睡不超过20分钟

  📋 放松技巧
  ─────────────────
  🧘 4-7-8呼吸: 吸4秒→屏7秒→呼8秒
  🧘 渐进式肌肉放松: 从脚到头逐步放松
  🧘 身体扫描冥想
  📝 睡前写"担忧清单"，把烦心事放下

  ⚠️ 如失眠持续超过1个月，建议看睡眠科医生
EOF
      ;;
    snoring|打鼾)
      cat <<'EOF'
😤 打鼾改善方案
────────────────────────────────────────
  生活方式改善:
    ✅ 减重（肥胖是最大诱因）
    ✅ 侧卧睡姿（避免仰卧）
    ✅ 戒酒（尤其睡前）
    ✅ 戒烟
    ✅ 避免服用镇静药物

  辅助措施:
    🛏️ 抬高枕头15-20度
    💧 保持鼻腔湿润
    🏥 鼻塞治疗

  ⚠️ 注意睡眠呼吸暂停!
    如果伴有:
    • 打鼾声很大且不规律
    • 睡眠中呼吸暂停
    • 白天极度嗜睡
    → 请做睡眠监测检查
EOF
      ;;
    restless|翻来覆去)
      cat <<'EOF'
🔄 睡眠不安改善
────────────────────────────────────────
  可能原因:
    • 压力/焦虑
    • 咖啡因过量
    • 睡眠环境不佳
    • 不安腿综合征
    • 床垫/枕头不合适

  改善建议:
    ✅ 睡前泡热水澡/泡脚
    ✅ 确保卧室凉爽(18-22°C)
    ✅ 使用重力毯(可增加安全感)
    ✅ 白噪音/自然声音
    ✅ 减少晚餐量，不要太晚吃
    ✅ 补充镁元素(有助肌肉放松)
EOF
      ;;
    early-wake|早醒)
      cat <<'EOF'
🌅 早醒改善方案
────────────────────────────────────────
  可能原因:
    • 光线干扰（天亮太早）
    • 压力/焦虑
    • 抑郁情绪
    • 睡太早
    • 年龄增长

  改善建议:
    ✅ 使用遮光窗帘
    ✅ 适当推迟入睡时间
    ✅ 晚间限制液体摄入（减少夜尿）
    ✅ 保持卧室安静
    ✅ 醒后如无法再入睡，做放松练习

  ⚠️ 如伴有持续情绪低落，可能是抑郁信号
     建议寻求专业心理帮助
EOF
      ;;
    oversleep|嗜睡)
      cat <<'EOF'
😪 嗜睡/过度睡眠改善
────────────────────────────────────────
  可能原因:
    • 睡眠质量差（虽然时间长但不深）
    • 甲状腺功能低下
    • 抑郁
    • 药物副作用
    • 睡眠呼吸暂停

  改善建议:
    ✅ 设定固定起床时间（闹钟放远一点）
    ✅ 起床后立即接触阳光
    ✅ 规律运动
    ✅ 检查是否有潜在健康问题

  ⚠️ 每天睡眠超过9-10小时仍感困倦
     建议做相关检查
EOF
      ;;
    *)
      echo "❌ 未知问题: $issue"
      echo "支持: insomnia, snoring, restless, early-wake, oversleep"
      ;;
  esac
}

cmd_schedule() {
  local wake_time="${1:?用法: schedule <wake_time> [cycles]}"
  local min_cycles="${2:-5}"

  local wake_min
  wake_min=$(to_minutes "$wake_time")

  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║           ⏰ 最佳入睡时间计算"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""
  echo "  目标起床时间: ${wake_time}"
  echo "  (入睡约需15分钟，已计入)"
  echo ""
  echo "📊 建议入睡时间:"
  echo "────────────────────────────────────────"

  for cycles in 6 5 4 3; do
    local sleep_needed=$((cycles * 90 + 15))  # +15 min to fall asleep
    local bed_min=$((wake_min - sleep_needed))
    if [ "$bed_min" -lt 0 ]; then
      bed_min=$((bed_min + 1440))
    fi
    local bed_h=$((bed_min / 60))
    local bed_m=$((bed_min % 60))
    local bed_time
    bed_time=$(printf "%02d:%02d" "$bed_h" "$bed_m")
    local sleep_h=$((cycles * 90 / 60))
    local sleep_m=$((cycles * 90 % 60))

    local recommend=""
    if [ "$cycles" -eq 6 ]; then recommend=" ⭐ 最佳"
    elif [ "$cycles" -eq 5 ]; then recommend=" ✅ 推荐"
    elif [ "$cycles" -eq 4 ]; then recommend=" 🟡 可接受"
    else recommend=" 🔴 偏少"; fi

    echo "  ${bed_time}  →  ${cycles}个周期 = ${sleep_h}h${sleep_m}m${recommend}"
  done

  cat <<'EOF'

💡 睡眠周期小知识
────────────────────────────────────────
  • 一个完整周期 ≈ 90分钟
  • 成人建议 5-6 个周期（7.5-9小时）
  • 在周期结束时自然醒来最清醒
  • 固定作息比睡多久更重要
EOF
}

cmd_environment() {
  cat <<'EOF'
╔══════════════════════════════════════════════════════════╗
║           🛏️ 睡眠环境优化清单
╚══════════════════════════════════════════════════════════╝

🌡️ 温度
────────────────────────────────────────
  ✅ 卧室温度: 18-22°C（凉爽最佳）
  ✅ 被子适当，不要太厚
  ✅ 可以穿袜子（温暖四肢有助入睡）
  ❌ 电热毯整夜开着

🌙 光线
────────────────────────────────────────
  ✅ 遮光窗帘（遮光率>90%）
  ✅ 睡前1小时调暗灯光
  ✅ 电子设备充电指示灯遮住
  ❌ 开灯睡觉
  ❌ 睡前看明亮屏幕

🔇 声音
────────────────────────────────────────
  ✅ 安静环境 (噪音<30分贝)
  ✅ 白噪音机/APP (如无法安静)
  ✅ 耳塞 (如有噪音干扰)
  ❌ 开着电视睡觉

🛏️ 寝具
────────────────────────────────────────
  ✅ 床垫软硬适中（5-8年更换）
  ✅ 枕头高度合适（侧卧时脊柱平直）
  ✅ 床品定期清洗（每1-2周）
  ✅ 考虑防螨床品

🌿 空气
────────────────────────────────────────
  ✅ 睡前通风30分钟
  ✅ 湿度40-60%
  ✅ 可放薰衣草助眠
  ❌ 空间太干燥或太潮湿

📱 电子设备
────────────────────────────────────────
  ✅ 手机放远离床头
  ✅ 开启夜间模式/勿扰
  ❌ 手机放枕边
  ❌ 卧室放电视/电脑

✅ 检查清单
────────────────────────────────────────
  □ 遮光窗帘已装好
  □ 室温调至18-22°C
  □ 安静/白噪音准备好
  □ 手机放远处
  □ 床品干净舒适
  □ 通风良好
EOF
}

cmd_nap() {
  local duration="${1:?用法: nap <duration_min> [time]}"
  local nap_time="${2:-13:00}"

  cat <<EOF
╔══════════════════════════════════════════════════════════╗
║           😴 小睡建议
╚══════════════════════════════════════════════════════════╝

📋 你的计划
────────────────────────────────────────
  小睡时长:  ${duration}分钟
  计划时间:  ${nap_time}
EOF

  if [ "$duration" -le 10 ]; then
    echo ""
    echo "  类型: ⚡ 微睡 (Nano Nap)"
    echo "  效果: 略有提神，但效果有限"
    echo "  建议: 10-20分钟效果更佳"
  elif [ "$duration" -le 20 ]; then
    echo ""
    echo "  类型: ⭐ 能量小睡 (Power Nap)"
    echo "  效果: 提升警觉性、注意力和情绪"
    echo "  评价: ✅ 最佳小睡时长！"
  elif [ "$duration" -le 30 ]; then
    echo ""
    echo "  类型: 🟡 标准小睡"
    echo "  效果: 可能进入深度睡眠"
    echo "  风险: ⚠️ 醒后可能有短暂迷糊感(睡眠惰性)"
  elif [ "$duration" -le 60 ]; then
    echo ""
    echo "  类型: 🟠 深度小睡"
    echo "  效果: 有助记忆巩固"
    echo "  风险: ⚠️ 可能影响夜间睡眠"
  else
    echo ""
    echo "  类型: 🔴 长时间小睡"
    echo "  效果: 完整睡眠周期"
    echo "  风险: ❌ 很可能影响夜间睡眠！建议缩短"
  fi

  cat <<'EOF'

💡 小睡黄金法则
────────────────────────────────────────
  ⏰ 最佳时间: 13:00-15:00
  ⏱️ 最佳时长: 10-20分钟
  ☕ 咖啡小睡: 喝杯咖啡后立即小睡20分钟
     （咖啡因约20分钟后生效，醒来双重提神）
  🚫 下午3点后不要小睡
  ⏰ 设闹钟！防止睡过头
EOF
}

cmd_journal() {
  local date="${1:?用法: journal <date> <bedtime> <waketime> <quality> [notes]}"
  local bedtime="${2:?请提供入睡时间}"
  local waketime="${3:?请提供起床时间}"
  local quality="${4:?请提供质量评分(1-10)}"
  local notes="${5:-}"

  # Calculate duration
  local bed_min wake_min sleep_min
  bed_min=$(to_minutes "$bedtime")
  wake_min=$(to_minutes "$waketime")
  if [ "$wake_min" -le "$bed_min" ]; then
    sleep_min=$((wake_min + 1440 - bed_min))
  else
    sleep_min=$((wake_min - bed_min))
  fi
  local sleep_h=$((sleep_min / 60))
  local sleep_m=$((sleep_min % 60))

  echo "${date} | ${bedtime}-${waketime} | ${sleep_h}h${sleep_m}m | Q:${quality}/10 | ${notes}" >> "$JOURNAL_FILE"

  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║           📓 睡眠日记"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""
  echo "  ✅ 已记录 ${date} 的睡眠数据"
  echo ""
  echo "📋 最近7天记录:"
  echo "────────────────────────────────────────"
  printf "  %-12s %-14s %-10s %-8s %s\n" "日期" "时间" "时长" "质量" "备注"
  echo "  ─────────────────────────────────────────────────"

  if [ -f "$JOURNAL_FILE" ]; then
    tail -7 "$JOURNAL_FILE" | while IFS='|' read -r d t dur q n; do
      printf "  %-12s %-14s %-10s %-8s %s\n" "$d" "$t" "$dur" "$q" "$n"
    done
  fi

  echo ""
  echo "💡 坚持记录，可以发现睡眠规律和改善方向"
  echo "   文件位置: ${JOURNAL_FILE}"
}

case "$CMD" in
  analyze)     cmd_analyze "$@" ;;
  improve)     cmd_improve "$@" ;;
  schedule)    cmd_schedule "$@" ;;
  environment) cmd_environment ;;
  nap)         cmd_nap "$@" ;;
  journal)     cmd_journal "$@" ;;
  help)        show_help ;;
  *)
    echo "❌ 未知命令: $CMD"
    echo "运行 'bash sleep.sh help' 查看帮助"
    exit 1
    ;;
esac
