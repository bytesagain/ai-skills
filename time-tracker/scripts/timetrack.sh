#!/usr/bin/env bash
set -euo pipefail

CMD="${1:-help}"
ARG2="${2:-}"
ARG3="${3:-}"
ARG4="${4:-}"

DATA_DIR="${TIMETRACK_DATA_DIR:-$HOME/.timetrack}"
mkdir -p "$DATA_DIR"

show_help() {
  cat <<'HELP'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⏱️ Time Tracker — 时间追踪工具
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Usage: bash timetrack.sh <command> [options]

Commands:
  log        记录时间条目（任务/时长/分类/备注）
  analyze    分析时间使用模式（按天/周/月）
  category   分类管理（查看默认分类体系）
  report     生成时间报表（日报/周报/月报）
  improve    效率改进建议
  pomodoro   番茄钟计划（任务拆分/番茄数估算/休息安排）

Log Usage:
  bash timetrack.sh log "task" "duration" "category"
  bash timetrack.sh log "Write report" "2h" "deep-work"

Examples:
  bash timetrack.sh log "Code review" "1.5h" "work"
  bash timetrack.sh analyze weekly
  bash timetrack.sh report daily
  bash timetrack.sh pomodoro "Build feature X" 6

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELP
}

# ── Parse duration string to minutes ──────────────────────────
parse_duration_minutes() {
  local dur="$1"
  local total=0
  # Match Xh, Xm, X.Yh patterns and combinations like 2h30m
  local hours=0 mins=0

  # Extract hours (integer or decimal)
  if [[ "$dur" =~ ([0-9]+\.?[0-9]*)h ]]; then
    hours="${BASH_REMATCH[1]}"
  fi
  # Extract minutes
  if [[ "$dur" =~ ([0-9]+)m ]]; then
    mins="${BASH_REMATCH[1]}"
  fi
  # If just a bare number, assume hours
  if [[ "$dur" =~ ^[0-9]+\.?[0-9]*$ ]]; then
    hours="$dur"
  fi

  # Calculate total minutes using awk (portable float math)
  total=$(awk "BEGIN { printf \"%d\", ($hours * 60) + $mins }")
  echo "$total"
}

# ── Format minutes to Xh Ym ──────────────────────────────────
format_minutes() {
  local mins="$1"
  local h=$((mins / 60))
  local m=$((mins % 60))
  if [[ $h -gt 0 && $m -gt 0 ]]; then
    echo "${h}h ${m}m"
  elif [[ $h -gt 0 ]]; then
    echo "${h}h"
  else
    echo "${m}m"
  fi
}

# ── Read log entries for a date (YYYY-MM-DD), output pipe-separated ──
read_log_entries() {
  local logfile="$DATA_DIR/${1}.log"
  if [[ -f "$logfile" ]]; then
    cat "$logfile"
  fi
}

cmd_log() {
  local task="${ARG2:-}"
  local duration="${ARG3:-}"
  local category="${ARG4:-general}"

  if [[ -z "$task" || -z "$duration" ]]; then
    cat <<EOF
⏱️ Time Log — 使用方法

  bash timetrack.sh log "任务名" "时长" "分类"

时长格式: 30m / 1h / 1.5h / 2h30m
默认分类: deep-work, communication, meeting, admin, learning, health, personal

示例:
  bash timetrack.sh log "Sprint planning" "50m" "meeting"
  bash timetrack.sh log "Feature development" "3h" "deep-work"
  bash timetrack.sh log "Email triage" "30m" "communication"
EOF
    return
  fi

  local today
  today=$(date +%Y-%m-%d)
  local now
  now=$(date +%H:%M)
  local logfile="$DATA_DIR/${today}.log"
  local mins
  mins=$(parse_duration_minutes "$duration")

  echo "${now}|${task}|${duration}|${mins}|${category}" >> "$logfile"

  cat <<EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✅ 时间条目已记录
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📅 日期: ${today}
  🕐 时间: ${now}
  📝 任务: ${task}
  ⏱️  时长: ${duration} (${mins} 分钟)
  🏷️  分类: ${category}
  💾 文件: ${logfile}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  # Show today's running total
  local total_mins=0
  local count=0
  while IFS='|' read -r _time _task _dur entry_mins _cat; do
    if [[ -n "$entry_mins" ]]; then
      total_mins=$((total_mins + entry_mins))
      count=$((count + 1))
    fi
  done < "$logfile"

  echo "  📊 今日累计: $(format_minutes $total_mins) ($count 条记录)"
  echo ""
}

cmd_analyze() {
  local period="${ARG2:-daily}"
  local today
  today=$(date +%Y-%m-%d)

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  📊 时间分析 — ${period}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  # Collect data based on period
  local -a dates=()
  case "$period" in
    daily|today)
      dates=("$today")
      ;;
    weekly|week)
      # Last 7 days
      for i in $(seq 0 6); do
        dates+=("$(date -d "$today - $i days" +%Y-%m-%d 2>/dev/null || date -v-${i}d +%Y-%m-%d 2>/dev/null || echo "$today")")
      done
      ;;
    monthly|month)
      # Last 30 days
      for i in $(seq 0 29); do
        dates+=("$(date -d "$today - $i days" +%Y-%m-%d 2>/dev/null || date -v-${i}d +%Y-%m-%d 2>/dev/null || echo "$today")")
      done
      ;;
    *)
      dates=("$today")
      ;;
  esac

  # Aggregate by category
  declare -A cat_mins
  local grand_total=0
  local entry_count=0
  local day_count=0

  for dt in "${dates[@]}"; do
    local logfile="$DATA_DIR/${dt}.log"
    if [[ -f "$logfile" ]]; then
      day_count=$((day_count + 1))
      while IFS='|' read -r _time _task _dur mins cat; do
        if [[ -n "$mins" && -n "$cat" ]]; then
          cat_mins["$cat"]=$(( ${cat_mins["$cat"]:-0} + mins ))
          grand_total=$((grand_total + mins))
          entry_count=$((entry_count + 1))
        fi
      done < "$logfile"
    fi
  done

  if [[ $entry_count -eq 0 ]]; then
    echo "  ⚠️  暂无 ${period} 数据。用 'log' 命令开始记录！"
    echo ""
    echo "  bash timetrack.sh log \"任务名\" \"时长\" \"分类\""
    echo ""
    return
  fi

  # Category emoji mapping
  declare -A cat_emoji
  cat_emoji=( ["deep-work"]="💻" ["communication"]="📧" ["meeting"]="🤝" ["admin"]="📋" ["learning"]="📚" ["health"]="🏃" ["personal"]="🎮" ["general"]="📌" ["work"]="💼" )

  echo "  📅 分析范围: ${#dates[@]} 天 (有数据: ${day_count} 天)"
  echo "  📝 总条目: ${entry_count}"
  echo "  ⏱️  总时间: $(format_minutes $grand_total)"
  echo ""
  echo "  ┌─────────────────┬────────┬──────┬────────────────────────┐"
  echo "  │ 分类            │ 时长   │  %   │ 分布                   │"
  echo "  ├─────────────────┼────────┼──────┼────────────────────────┤"

  # Sort categories by time (descending)
  local sorted_cats
  sorted_cats=$(for cat in "${!cat_mins[@]}"; do
    echo "${cat_mins[$cat]}|$cat"
  done | sort -t'|' -k1 -nr)

  while IFS='|' read -r mins cat; do
    [[ -z "$mins" ]] && continue
    local emoji="${cat_emoji[$cat]:-📌}"
    local pct=0
    if [[ $grand_total -gt 0 ]]; then
      pct=$((mins * 100 / grand_total))
    fi
    # Visual bar (each block = 5%)
    local bar_len=$((pct / 5))
    local bar=""
    for ((j=0; j<bar_len; j++)); do bar+="█"; done
    for ((j=bar_len; j<20; j++)); do bar+="░"; done

    printf "  │ %s %-14s │ %6s │ %3d%% │ %-22s │\n" \
      "$emoji" "$cat" "$(format_minutes $mins)" "$pct" "$bar"
  done <<< "$sorted_cats"

  echo "  └─────────────────┴────────┴──────┴────────────────────────┘"
  echo ""

  # Productivity metrics
  local deep_mins=${cat_mins["deep-work"]:-0}
  local meet_mins=${cat_mins["meeting"]:-0}
  local deep_pct=0 meet_pct=0
  if [[ $grand_total -gt 0 ]]; then
    deep_pct=$((deep_mins * 100 / grand_total))
    meet_pct=$((meet_mins * 100 / grand_total))
  fi

  echo "  📈 效率指标:"
  local deep_status="🔴"
  [[ $deep_pct -ge 40 ]] && deep_status="🟢"
  [[ $deep_pct -ge 25 && $deep_pct -lt 40 ]] && deep_status="🟡"
  echo "    深度工作占比: ${deep_pct}% (目标≥40%) ${deep_status}"

  local meet_status="🟢"
  [[ $meet_pct -gt 30 ]] && meet_status="🔴"
  [[ $meet_pct -gt 20 && $meet_pct -le 30 ]] && meet_status="🟡"
  echo "    会议负载:     ${meet_pct}% (目标≤20%) ${meet_status}"

  if [[ $day_count -gt 0 ]]; then
    local avg_daily=$((grand_total / day_count))
    echo "    日均工时:     $(format_minutes $avg_daily)"
  fi
  echo ""
}

cmd_category() {
  cat <<EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🏷️ 分类体系
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  💻 deep-work     深度工作 (编码/写作/设计)
  📧 communication 沟通 (邮件/聊天/电话)
  🤝 meeting       会议 (站会/评审/1对1)
  📋 admin         行政 (规划/组织/报告)
  📚 learning      学习 (阅读/课程/研究)
  🏃 health        健康 (运动/休息/用餐)
  🎮 personal      个人 (娱乐/爱好/休闲)
  📌 general       通用 (未分类)

  使用方法:
  bash timetrack.sh log "任务" "时长" "分类名"
EOF
}

cmd_report() {
  local period="${ARG2:-daily}"
  local today
  today=$(date +%Y-%m-%d)
  local day_name
  day_name=$(date +%A)

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  📊 时间报表 — ${period}"
  echo "  📅 ${today} (${day_name})"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  local -a dates=()
  case "$period" in
    daily|today)
      dates=("$today")
      ;;
    weekly|week)
      for i in $(seq 0 6); do
        dates+=("$(date -d "$today - $i days" +%Y-%m-%d 2>/dev/null || date -v-${i}d +%Y-%m-%d 2>/dev/null || echo "$today")")
      done
      ;;
    monthly|month)
      for i in $(seq 0 29); do
        dates+=("$(date -d "$today - $i days" +%Y-%m-%d 2>/dev/null || date -v-${i}d +%Y-%m-%d 2>/dev/null || echo "$today")")
      done
      ;;
  esac

  local grand_total=0
  local entry_count=0
  local has_data=false

  for dt in "${dates[@]}"; do
    local logfile="$DATA_DIR/${dt}.log"
    if [[ -f "$logfile" ]]; then
      has_data=true
      local day_total=0
      local day_entries=0

      echo "  📅 ${dt}:"
      echo "  ┌───────┬─────────────────────────────┬─────────┬──────────────┐"
      echo "  │ 时间  │ 任务                        │ 时长    │ 分类         │"
      echo "  ├───────┼─────────────────────────────┼─────────┼──────────────┤"

      while IFS='|' read -r etime task dur mins cat; do
        if [[ -n "$etime" && -n "$task" ]]; then
          printf "  │ %-5s │ %-27.27s │ %-7s │ %-12s │\n" \
            "$etime" "$task" "$dur" "$cat"
          if [[ -n "$mins" ]]; then
            day_total=$((day_total + mins))
            day_entries=$((day_entries + 1))
          fi
        fi
      done < "$logfile"

      echo "  └───────┴─────────────────────────────┴─────────┴──────────────┘"
      echo "    小计: $(format_minutes $day_total) ($day_entries 条)"
      echo ""

      grand_total=$((grand_total + day_total))
      entry_count=$((entry_count + day_entries))
    fi
  done

  if [[ "$has_data" == "false" ]]; then
    echo "  ⚠️  该时段暂无数据。用 'log' 命令记录时间！"
    echo ""
    return
  fi

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  📈 汇总"
  echo "  总时间: $(format_minutes $grand_total)"
  echo "  总条目: ${entry_count}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

cmd_improve() {
  cat <<EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🚀 效率改进建议
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  1. [关闭通知]     省 30-60m/天  ⭐
  2. [批量处理邮件]  省 30-45m/天  ⭐
  3. [25分钟短会]    省 10-20m/会  ⭐
  4. [文本快捷键]    省 15-30m/天  ⭐⭐
  5. [早晨例程]      省 30m/天     ⭐⭐
  6. [键盘快捷键]    省 15-20m/天  ⭐⭐
  7. [自动化重复]    因人而异      ⭐⭐⭐

  PLAN 框架:
  P — 优先级 (艾森豪威尔矩阵)
  L — 杠杆化 (自动化/模板/AI)
  A — 时间分配 (时间块)
  N — 协商 (减少低价值会议)

EOF
}

cmd_pomodoro() {
  local task="${ARG2:-General Task}"
  local pomodoros="${ARG3:-8}"

  # Calculate time
  local total_mins=$((pomodoros * 25))
  local total_hrs
  total_hrs=$(awk "BEGIN { printf \"%.1f\", $total_mins / 60 }")

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  🍅 番茄钟计划"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "  任务: ${task}"
  echo "  番茄数: ${pomodoros} (${total_mins}分钟 ≈ ${total_hrs}h)"
  echo ""
  echo "  规则: 🍅25分钟工作 → ☕5分钟休息 → 每4个🌴长休15-30分钟"
  echo ""

  local set_num=1
  for i in $(seq 1 "$pomodoros"); do
    if (( (i - 1) % 4 == 0 )); then
      echo "  --- 第 $set_num 组 ---"
      set_num=$((set_num + 1))
    fi
    echo "  🍅 #${i}  ${task} — Part ${i}"
    if (( i % 4 == 0 && i < pomodoros )); then
      echo "  🌴 长休息 (15-30分钟)"
    elif (( i < pomodoros )); then
      echo "  ☕ 短休息 (5分钟)"
    fi
  done

  echo ""
  echo "  完成后记得用 log 命令记录时间："
  echo "  bash timetrack.sh log \"${task}\" \"${total_hrs}h\" \"deep-work\""
  echo ""
}

case "$CMD" in
  log)      cmd_log ;;
  analyze)  cmd_analyze ;;
  category) cmd_category ;;
  report)   cmd_report ;;
  improve)  cmd_improve ;;
  pomodoro) cmd_pomodoro ;;
  help|--help|-h) show_help ;;
  *)
    echo "❌ Unknown command: $CMD"
    echo "Run 'bash timetrack.sh help' for usage."
    exit 1
    ;;
esac
