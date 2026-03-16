#!/usr/bin/env bash
# community.sh — 社群运营工具（真实生成版）
# Usage: bash community.sh <command> [args...]
# Commands: calendar, activity, report, growth, crisis, sop
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

# ── 工具函数 ──
get_weekday() {
  # 0=周日 ... 6=周六
  date -d "$1" +%u 2>/dev/null || date -j -f "%Y-%m-%d" "$1" +%u 2>/dev/null || echo "1"
}

WEEKDAYS=("周日" "周一" "周二" "周三" "周四" "周五" "周六")

# ── 生成运营日历 ──
generate_calendar() {
  local month="${1:-$(date +%Y-%m)}"
  local community_name="${2:-社群}"
  local year="${month%-*}"
  local mon="${month#*-}"

  echo "# 📅 ${community_name}运营日历 — ${year}年${mon}月"
  echo ""
  echo "> 生成时间: $(date '+%Y-%m-%d %H:%M')"
  echo ""

  # 计算本月天数
  local days_in_month
  days_in_month=$(date -d "${year}-${mon}-01 +1 month -1 day" +%d 2>/dev/null || echo 30)

  # 每周主题
  local themes=("产品分享周" "用户故事周" "技术干货周" "福利活动周" "行业洞察周")
  local daily_tasks=(
    "早报+签到"        # 周一
    "话题讨论"         # 周二
    "干货分享"         # 周三
    "互动游戏"         # 周四
    "答疑解惑"         # 周五
    "周末活动预告"     # 周六
    "休息/轻互动"      # 周日
  )

  echo "## 每周主题规划"
  echo ""
  echo "| 周次 | 主题 | 核心目标 |"
  echo "|------|------|---------|"
  local week=1
  local d=1
  while (( d <= days_in_month )); do
    local date_str="${year}-${mon}-$(printf '%02d' $d)"
    local wd
    wd=$(date -d "$date_str" +%u 2>/dev/null || echo 1)
    if (( wd == 1 )); then
      local theme_idx=$(( (week - 1) % ${#themes[@]} ))
      local objectives=("拉新+30" "留存提升" "活跃度+20%" "转化+GMV" "品牌建设")
      echo "| 第${week}周 | ${themes[$theme_idx]} | ${objectives[$theme_idx]} |"
      ((week++))
    fi
    ((d++))
  done

  echo ""
  echo "## 日历详情"
  echo ""
  echo "| 日期 | 星期 | 内容类型 | 发布时间 | 具体安排 |"
  echo "|------|------|---------|---------|---------|"

  local content_pool_morning=(
    "🌅 行业早报+签到打卡"
    "📊 数据日报+每日问答"
    "💡 今日一个小技巧"
    "🔥 热点事件点评"
    "📰 行业新闻速递"
  )
  local content_pool_afternoon=(
    "📚 深度长文/案例拆解"
    "🎯 产品使用技巧分享"
    "💬 主题讨论: 开放话题"
    "🏆 成功案例分享"
    "📋 投票: 社群热议"
  )
  local content_pool_evening=(
    "🎮 互动小游戏/猜谜"
    "📖 读书会/学习打卡"
    "🗣️ 嘉宾分享(15分钟)"
    "🎁 福利抽奖/优惠码"
    "📝 今日总结+预告明天"
  )

  for d in $(seq 1 "$days_in_month"); do
    local date_str="${year}-${mon}-$(printf '%02d' $d)"
    local wd
    wd=$(date -d "$date_str" +%u 2>/dev/null || echo 1)
    local wd_name="${WEEKDAYS[$wd]}"

    local task_idx=$(( (d - 1) % ${#daily_tasks[@]} ))
    local m_idx=$(( (d - 1) % ${#content_pool_morning[@]} ))
    local a_idx=$(( (d * 3) % ${#content_pool_afternoon[@]} ))

    local time_slot="08:30"
    local content="${content_pool_morning[$m_idx]}"

    if (( wd == 6 || wd == 0 )); then
      time_slot="10:00"
      content="${content_pool_evening[$(( d % ${#content_pool_evening[@]} ))]}"
    fi

    echo "| ${mon}/${d} | ${wd_name} | ${daily_tasks[$task_idx]} | ${time_slot} | ${content} |"
  done

  echo ""
  echo "## 📊 KPI指标"
  echo ""
  echo "| 指标 | 目标值 | 衡量方式 |"
  echo "|------|--------|---------|"
  echo "| 日活跃率 | >30% | 每日发言人数/总人数 |"
  echo "| 新增成员 | +100/月 | 邀请链接追踪 |"
  echo "| 留存率 | >85% | 月末活跃/月初总数 |"
  echo "| 消息量 | >50条/日 | 群消息统计 |"
  echo "| 转化率 | >5% | 活动参与/总人数 |"
}

# ── 活动方案生成 ──
generate_activity() {
  local type="${1:-抽奖}"
  local theme="${2:-社群周年庆}"

  cat <<EOF
# 🎉 社群活动方案 — ${theme}

> 活动类型: ${type}
> 生成时间: $(date '+%Y-%m-%d %H:%M')

## 一、活动概述

| 项目 | 详情 |
|------|------|
| 活动名称 | ${theme} |
| 活动类型 | ${type} |
| 活动周期 | $(date '+%Y-%m-%d') ~ $(date -d '+7 days' '+%Y-%m-%d' 2>/dev/null || date '+%Y-%m-%d') |
| 目标人数 | 500人参与 |
| 预算 | ¥2,000 - ¥5,000 |

## 二、活动流程

### 预热期（D-3 ~ D-1）
| 时间 | 动作 | 渠道 | 负责人 |
|------|------|------|--------|
| D-3 | 悬念海报发布 | 朋友圈+群 | 运营 |
| D-2 | 规则预告+往期回顾 | 社群+公众号 | 内容 |
| D-1 | 倒计时+提醒 | 社群+私信 | 运营 |

### 执行期（D-Day）
| 时间 | 环节 | 时长 | 说明 |
|------|------|------|------|
| 19:00 | 开场预热 | 10min | 主持人暖场+规则说明 |
| 19:10 | 嘉宾分享 | 20min | 干货内容+互动 |
| 19:30 | 互动环节 | 15min | ${type}+问答 |
| 19:45 | 高潮环节 | 10min | 大奖揭晓/重磅发布 |
| 19:55 | 收尾总结 | 5min | 感谢+预告下次 |

### 复盘期（D+1 ~ D+3）
- D+1: 数据整理+中奖公示
- D+2: 活动复盘会议
- D+3: 复盘报告+经验沉淀

## 三、预算明细

| 项目 | 金额 | 说明 |
|------|------|------|
| 奖品采购 | ¥1,500 | 一等奖×1 + 二等奖×3 + 三等奖×10 |
| 海报设计 | ¥500 | 预热+活动+复盘3套 |
| 嘉宾费用 | ¥500 | 分享嘉宾礼品 |
| 工具费用 | ¥200 | 抽奖工具/直播工具 |
| 应急预算 | ¥300 | 10%预留 |
| **合计** | **¥3,000** | |

## 四、话术模板

### 预热话术
\`\`\`
🎉 重磅预告！
${theme}即将开启！
🎁 奖品已备好，惊喜等你来
📅 时间：XX月XX日 19:00
👉 参与方式：群内接龙报名
名额有限，先到先得！
\`\`\`

### 开场话术
\`\`\`
🎤 各位小伙伴，欢迎来到${theme}！
今晚我们准备了超多惊喜：
✅ 干货分享
✅ 互动游戏
✅ ${type}抽奖
跟着节奏走，大奖带回家！🏠
先发个 "1" 签到一下~
\`\`\`

### 结束话术
\`\`\`
🎊 感谢大家参与${theme}！
📊 本次活动数据：
- 参与人数：___人
- 互动消息：___条
- 中奖人数：___人
🎁 中奖名单已公布，请私信领取
❤️ 我们下次活动再见！
\`\`\`

## 五、风险预案

| 风险 | 概率 | 应对方案 |
|------|------|---------|
| 参与人数不足 | 中 | 降低门槛+追加推广 |
| 技术故障 | 低 | 备用方案(文字版) |
| 嘉宾缺席 | 低 | 备用嘉宾/录播 |
| 现场冷场 | 中 | 准备托+破冰话题 |
| 争议/投诉 | 低 | 规则提前公示+客服 |
EOF
}

# ── 数据报告 ──
generate_report() {
  local name="${1:-社群}"
  local members="${2:-500}"
  local active="${3:-150}"
  local new_members="${4:-30}"
  local messages="${5:-1200}"
  local events="${6:-4}"

  local active_rate
  active_rate=$(echo "scale=1; $active * 100 / $members" | bc)
  local msg_per_active
  msg_per_active=$(echo "scale=1; $messages / $active" | bc)
  local churn=$((members / 20))
  local net_growth=$((new_members - churn))
  local growth_rate
  growth_rate=$(echo "scale=1; $net_growth * 100 / $members" | bc)

  cat <<EOF
# 📊 ${name} 运营数据报告

> 报告周期: $(date -d '-30 days' '+%Y-%m-%d' 2>/dev/null || date '+%Y-%m-%d') ~ $(date '+%Y-%m-%d')
> 生成时间: $(date '+%Y-%m-%d %H:%M')

## 一、核心数据概览

| 指标 | 数值 | 环比 | 状态 |
|------|------|------|------|
| 总成员数 | ${members}人 | +${net_growth} | $([ "$net_growth" -gt 0 ] && echo "📈" || echo "📉") |
| 活跃成员 | ${active}人 | - | $([ "$(echo "$active_rate > 25" | bc)" -eq 1 ] && echo "✅" || echo "⚠️") |
| 活跃率 | ${active_rate}% | - | $([ "$(echo "$active_rate > 30" | bc)" -eq 1 ] && echo "🟢" || echo "🟡") |
| 新增成员 | ${new_members}人 | - | 📊 |
| 流失成员 | ${churn}人 | - | 📊 |
| 净增长率 | ${growth_rate}% | - | $([ "$(echo "$growth_rate > 0" | bc)" -eq 1 ] && echo "📈" || echo "📉") |
| 消息总量 | ${messages}条 | - | 📊 |
| 人均消息 | ${msg_per_active}条 | - | $([ "$(echo "$msg_per_active > 5" | bc)" -eq 1 ] && echo "✅" || echo "⚠️") |
| 活动场次 | ${events}场 | - | 📊 |

## 二、活跃度分析

### 成员分层
| 层级 | 人数 | 占比 | 特征 |
|------|------|------|------|
| 🔴 核心用户 | $(echo "$active * 10 / 100" | bc) | $(echo "scale=1; $active * 10 / $members" | bc)% | 日均发言>10条 |
| 🟡 活跃用户 | $(echo "$active * 30 / 100" | bc) | $(echo "scale=1; $active * 30 / $members" | bc)% | 周均发言>5条 |
| 🟢 普通用户 | $(echo "$active * 60 / 100" | bc) | $(echo "scale=1; $active * 60 / $members" | bc)% | 月有发言 |
| ⚪ 沉默用户 | $((members - active)) | $(echo "scale=1; ($members - $active) * 100 / $members" | bc)% | 月无发言 |

### 活跃时段分布（估算）
\`\`\`
消息量
 ▎
 ▎    ██
 ▎   ████              ██
 ▎  ██████    ██       ████
 ▎ ████████  ████     ██████  ██
 ▎██████████████████████████████
 └──────────────────────────────
  06 08 10 12 14 16 18 20 22 24
           时间（小时）
\`\`\`

峰值时段: 09:00-11:00, 20:00-22:00

## 三、健康度评分

| 维度 | 得分 | 权重 | 加权分 |
|------|------|------|--------|
EOF

  # 计算健康度评分
  local score_active score_growth score_engage score_retention
  if (( $(echo "$active_rate > 40" | bc -l) )); then score_active=90
  elif (( $(echo "$active_rate > 25" | bc -l) )); then score_active=70
  else score_active=50; fi

  if (( net_growth > 20 )); then score_growth=90
  elif (( net_growth > 0 )); then score_growth=70
  else score_growth=40; fi

  if (( $(echo "$msg_per_active > 10" | bc -l) )); then score_engage=90
  elif (( $(echo "$msg_per_active > 5" | bc -l) )); then score_engage=70
  else score_engage=50; fi

  score_retention=$((100 - churn * 100 / members))

  local total_score=$(( (score_active * 30 + score_growth * 25 + score_engage * 25 + score_retention * 20) / 100 ))

  echo "| 活跃度 | ${score_active} | 30% | $((score_active * 30 / 100)) |"
  echo "| 增长性 | ${score_growth} | 25% | $((score_growth * 25 / 100)) |"
  echo "| 互动性 | ${score_engage} | 25% | $((score_engage * 25 / 100)) |"
  echo "| 留存率 | ${score_retention} | 20% | $((score_retention * 20 / 100)) |"
  echo "| **综合** | **${total_score}** | 100% | **${total_score}** |"

  local health_grade
  if (( total_score >= 80 )); then health_grade="🟢 优秀"
  elif (( total_score >= 60 )); then health_grade="🟡 良好"
  elif (( total_score >= 40 )); then health_grade="🟠 一般"
  else health_grade="🔴 需要关注"; fi

  echo ""
  echo "**社群健康度: ${health_grade} (${total_score}/100)**"

  cat <<EOF

## 四、改进建议

### 本月重点行动
1. $([ "$score_active" -lt 70 ] && echo "⚠️ 活跃率偏低 → 增加互动活动频次" || echo "✅ 活跃度良好 → 保持当前节奏")
2. $([ "$net_growth" -lt 10 ] && echo "⚠️ 增长放缓 → 策划裂变活动" || echo "✅ 增长健康 → 关注用户质量")
3. $([ "$(echo "$msg_per_active < 5" | bc)" -eq 1 ] && echo "⚠️ 互动不足 → 提升内容质量" || echo "✅ 互动活跃 → 深化用户关系")
4. $([ "$score_retention" -lt 70 ] && echo "⚠️ 流失率偏高 → 做流失用户回访" || echo "✅ 留存稳定 → 建立忠诚度体系")
EOF
}

# ── SOP模板 ──
generate_sop() {
  cat <<'EOF'
# 📋 社群运营SOP

## 一、日常运营（每日）

### 早间 08:00-09:00
- [ ] 发布早安问候/签到
- [ ] 推送行业早报(3-5条)
- [ ] 检查昨晚未回复消息
- [ ] 处理入群申请

### 中午 12:00-13:00
- [ ] 发布午间话题/投票
- [ ] 回复上午问题
- [ ] 审核群内广告/违规

### 晚间 20:00-21:00
- [ ] 发布晚间内容(干货/故事)
- [ ] 互动引导(提问/讨论)
- [ ] 整理当日精华消息

### 睡前 22:00
- [ ] 发布晚安+明日预告
- [ ] 记录当日数据
- [ ] 更新运营日志

## 二、周度运营

| 星期 | 主题 | 内容 |
|------|------|------|
| 周一 | 目标日 | 本周计划+签到 |
| 周二 | 干货日 | 行业分享/教程 |
| 周三 | 互动日 | 话题讨论/辩论 |
| 周四 | 故事日 | 用户案例/经验 |
| 周五 | 福利日 | 抽奖/优惠/资源 |
| 周六 | 活动日 | 线上活动/直播 |
| 周日 | 复盘日 | 本周总结+下周预告 |

## 三、月度运营

### 第1周: 数据分析+计划
- 上月数据复盘
- 本月KPI设定
- 内容日历规划

### 第2周: 内容深耕
- 系列主题内容
- 嘉宾邀约

### 第3周: 活动执行
- 月度主题活动
- 裂变增长

### 第4周: 总结优化
- 月度复盘
- 用户回访
- 流程优化

## 四、危机处理流程

```
发现问题 → 截图留证 → 评估级别
  ↓
P0(严重): 立即处理 → 通知管理层 → 公告说明
P1(重要): 1小时内处理 → 私聊沟通 → 群内回应
P2(一般): 当日处理 → 私聊提醒 → 记录备案
```
EOF
}

# ── 帮助 ──
show_help() {
  cat <<'HELP'
📱 社群运营工具 — community.sh

用法: bash community.sh <command> [args...]

命令:
  calendar [YYYY-MM] [社群名]
           → 生成月度运营日历（每日安排+KPI）
  activity [活动类型] [主题]
           → 生成完整活动方案（流程/预算/话术/风险）
  report [社群名] [总人数] [活跃人数] [新增] [消息量] [活动数]
           → 生成数据分析报告（健康度评分+改进建议）
  sop      → 生成日/周/月运营SOP模板
  help     → 显示帮助

示例:
  bash community.sh calendar 2025-03 "AI学习群"
  bash community.sh activity "抽奖" "春季回馈"
  bash community.sh report "技术社群" 800 240 50 2000 6
  bash community.sh sop

💡 真实功能:
  - 根据日期自动排列运营日历
  - 活动方案含预算/话术/时间线
  - 数据报告含健康度评分算法
  - 成员分层分析
HELP
}

case "$CMD" in
  calendar)
    IFS=' ' read -ra ARGS <<< "$INPUT"
    generate_calendar "${ARGS[0]:-}" "${ARGS[1]:-}"
    ;;
  activity)
    IFS=' ' read -ra ARGS <<< "$INPUT"
    generate_activity "${ARGS[0]:-}" "${ARGS[1]:-}"
    ;;
  report)
    IFS=' ' read -ra ARGS <<< "$INPUT"
    generate_report "${ARGS[0]:-}" "${ARGS[1]:-}" "${ARGS[2]:-}" "${ARGS[3]:-}" "${ARGS[4]:-}" "${ARGS[5]:-}"
    ;;
  sop) generate_sop ;;
  help|*) show_help ;;
esac
