#!/usr/bin/env bash
CMD="$1"; shift 2>/dev/null; INPUT="$*"
case "$CMD" in
  create) cat << 'PROMPT'
你是会议管理专家。创建会议议程(Markdown)：1.会议目标 2.参与人 3.时间分配 4.每项议题(讨论要点+时长+负责人) 5.下一步行动。用中文。
会议主题和时长：
PROMPT
    echo "$INPUT" ;;
  standup) cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🕐 每日站会模板 (15分钟)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  每人回答3个问题(每人2分钟):

  1️⃣ 昨天完成了什么?
  2️⃣ 今天计划做什么?
  3️⃣ 有什么阻碍?

  规则:
  • 站着开(保持简短)
  • 不讨论细节(会后单独聊)
  • 准时开始准时结束
  • 记录阻碍项,指定跟进人

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
  retro) cat << 'PROMPT'
你是敏捷教练。设计复盘会(Markdown)：1.回顾目标 2.好的(继续) 3.不好的(停止) 4.可以尝试(开始) 5.行动项(SMART)。用中文。
复盘周期/项目：
PROMPT
    echo "$INPUT" ;;
  oneonone) cat << 'PROMPT'
你是管理教练。设计一对一会议议程(Markdown)：1.开场(近况) 2.工作进展 3.挑战支持 4.职业发展 5.反馈(双向) 6.行动项。30分钟分配。用中文。
会议对象和情况：
PROMPT
    echo "$INPUT" ;;
  decision) cat << 'PROMPT'
你是决策会议引导师。设计决策会议议程：1.背景介绍(5min) 2.方案展示(10min) 3.利弊分析(10min) 4.提问讨论(10min) 5.投票决策(5min) 6.行动项。用中文。
决策主题：
PROMPT
    echo "$INPUT" ;;
  minutes) cat << 'PROMPT'
你是会议记录专家。将会议内容整理为正式纪要(Markdown)：1.会议信息(日期/参与人/时长) 2.讨论要点 3.决议事项 4.行动项(负责人+截止日期) 5.下次会议安排。用中文。
会议内容：
PROMPT
    echo "$INPUT" ;;
  *) cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 Meeting Agenda — 使用指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  create [主题]      创建会议议程
  standup           每日站会模板
  retro [周期]       复盘会设计
  oneonone [对象]    一对一会议
  decision [主题]    决策会议
  minutes [内容]     会议纪要整理

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
esac
