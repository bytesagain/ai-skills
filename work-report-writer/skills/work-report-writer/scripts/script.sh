#!/usr/bin/env bash
# work-report-writer — 工作日报/周报/月报自动生成工具
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${WORK_REPORT_WRITER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/work-report-writer}"
DB="$DATA_DIR/entries.jsonl"
mkdir -p "$DATA_DIR"

show_help() {
    cat << EOF
work-report-writer v$VERSION — 工作报告生成器

Usage: work-report-writer <command> [args]

生成:
  daily [date]                 日报模板
  weekly [week]                周报模板
  monthly [month]              月报模板
  standup                      站会汇报模板
  okr <objective>              OKR进度报告

记录:
  log <task> [status]          记录工作项(done/wip/blocked)
  list [date]                  查看今日记录
  clear                        清空今日记录

格式:
  format <style>               报告风格(简约/详细/数据)
  bullet <text>                格式化为要点
  metrics <kpi> <value>        关键指标记录
  template <type>              获取空白模板(日报/周报/述职)
  help                         显示帮助
EOF
}

cmd_daily() {
    local date="${1:-$(date +%Y-%m-%d)}"
    echo "  ═══ 工作日报 $date ═══"
    echo ""
    echo "  【今日完成】"
    if [ -f "$DB" ]; then
        grep "done" "$DB" 2>/dev/null | while IFS='|' read -r ts task status; do
            echo "  ✅ $task"
        done
    fi
    echo "  ✅ [补充完成的工作]"
    echo ""
    echo "  【进行中】"
    if [ -f "$DB" ]; then
        grep "wip" "$DB" 2>/dev/null | while IFS='|' read -r ts task status; do
            echo "  🔄 $task"
        done
    fi
    echo "  🔄 [进行中的工作]"
    echo ""
    echo "  【明日计划】"
    echo "  📋 [明天要做的事]"
    echo ""
    echo "  【问题/风险】"
    echo "  ⚠️ [需要协助或有风险的事项]"
    _log "daily" "$date"
}

cmd_weekly() {
    local week="${1:-$(date +%V)}"
    echo "  ═══ 周报 第${week}周 ═══"
    echo ""
    echo "  【本周成果】"
    echo "  1. [重点成果1 + 量化数据]"
    echo "  2. [重点成果2 + 量化数据]"
    echo "  3. [重点成果3]"
    echo ""
    echo "  【关键指标】"
    echo "  • KPI 1: [数值] (目标: [数值])"
    echo "  • KPI 2: [数值] (目标: [数值])"
    echo ""
    echo "  【下周计划】"
    echo "  1. [优先级P0]"
    echo "  2. [优先级P1]"
    echo "  3. [优先级P2]"
    echo ""
    echo "  【风险&依赖】"
    echo "  ⚠️ [风险描述 + 应对方案]"
}

cmd_monthly() {
    local month="${1:-$(date +%m)}"
    echo "  ═══ 月报 ${month}月 ═══"
    echo ""
    echo "  【月度总结】"
    echo "  本月核心目标: [目标描述]"
    echo "  完成度: [X]%"
    echo ""
    echo "  【重点成果】"
    echo "  1. [成果 + 影响]"
    echo "  2. [成果 + 数据]"
    echo ""
    echo "  【数据回顾】"
    echo "  │ 指标     │ 目标  │ 实际  │ 达成率 │"
    echo "  │──────────│───────│───────│────────│"
    echo "  │ [KPI 1]  │ [XX]  │ [XX]  │ [XX]%  │"
    echo ""
    echo "  【经验教训】"
    echo "  ✅ 做得好: [继续保持的]"
    echo "  ❌ 待改进: [下月优化的]"
    echo ""
    echo "  【下月计划】"
    echo "  核心目标: [下月目标]"
}

cmd_standup() {
    echo "  ═══ 站会汇报 $(date +%Y-%m-%d) ═══"
    echo ""
    echo "  昨天做了:"
    echo "  • [完成的任务]"
    echo ""
    echo "  今天要做:"
    echo "  • [计划的任务]"
    echo ""
    echo "  阻塞/需要帮助:"
    echo "  • [有则说，无则跳过]"
}

cmd_log() {
    local task="${1:?用法: work-report-writer log <任务> [done/wip/blocked]}"
    local status="${2:-done}"
    echo "$(date +%H:%M)|$task|$status" >> "$DB"
    echo "  记录: [$status] $task"
    _log "log" "$task ($status)"
}

cmd_list() {
    echo "  ═══ 今日记录 ═══"
    [ -f "$DB" ] || { echo "  (空)"; return; }
    while IFS='|' read -r ts task status; do
        case "$status" in
            done) echo "  ✅ $ts $task" ;;
            wip)  echo "  🔄 $ts $task" ;;
            blocked) echo "  ❌ $ts $task" ;;
            *) echo "  ● $ts $task" ;;
        esac
    done < "$DB"
}

cmd_template() {
    local type="${1:-日报}"
    case "$type" in
        述职) echo "  述职报告模板:"
              echo "  1. 岗位职责概述"
              echo "  2. 工作业绩(量化)"
              echo "  3. 能力提升"
              echo "  4. 不足与改进"
              echo "  5. 未来计划" ;;
        *) echo "  模板: 日报/周报/月报/述职" ;;
    esac
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

case "${{1:-help}}" in
    daily) shift; cmd_daily "$@" ;;
    weekly) shift; cmd_weekly "$@" ;;
    monthly) shift; cmd_monthly "$@" ;;
    standup) shift; cmd_standup "$@" ;;
    log) shift; cmd_log "$@" ;;
    list) shift; cmd_list "$@" ;;
    template) shift; cmd_template "$@" ;;
    help|-h) show_help ;;
    version|-v) echo "work-report-writer v$VERSION" ;;
    *) echo "Unknown: $1"; show_help; exit 1 ;;
esac
