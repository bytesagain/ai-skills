#!/usr/bin/env bash
CMD="$1"; shift 2>/dev/null; INPUT="$*"
case "$CMD" in
  create) cat << 'PROMPT'
你是习惯养成教练。设计21天习惯计划：1.每日具体行动(从微小开始) 2.触发机制(if-then) 3.奖励设计 4.进度追踪表 5.常见陷阱及对策。基于《原子习惯》方法论。用中文。
想养成的习惯：
PROMPT
    echo "$INPUT" ;;
  streak) cat << 'PROMPT'
你是打卡追踪专家。生成打卡追踪模板：1.月度日历视图(Markdown) 2.连续天数统计 3.完成率计算 4.里程碑标记(7/21/30/66/100天) 5.中断恢复策略。用中文。
习惯和当前进度：
PROMPT
    echo "$INPUT" ;;
  review) cat << 'PROMPT'
你是习惯教练。进行习惯回顾分析：1.完成率评估 2.执行模式分析(哪天容易中断) 3.改进建议 4.下阶段目标调整 5.激励语。用中文。
习惯执行情况：
PROMPT
    echo "$INPUT" ;;
  challenge) cat << 'PROMPT'
你是挑战设计师。设计习惯挑战：1.30天挑战日历(每天递增) 2.规则说明 3.难度曲线 4.社交分享模板 5.完成奖励设计。类型：运动/阅读/冥想/早起/储蓄。用中文。
挑战类型：
PROMPT
    echo "$INPUT" ;;
  science) cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🧠 习惯养成科学
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📖 核心理论

  习惯回路（Habit Loop）:
  提示(Cue) → 渴望(Craving) → 反应(Response) → 奖励(Reward)

  ⏰ 关键时间节点
  • 21天 — 初步形成（神经通路开始建立）
  • 66天 — 自动化（伦敦大学研究平均值）
  • 90天 — 稳固期（不易中断）

  🔑 四大法则（原子习惯）
  1. 让它显而易见 — 环境设计
  2. 让它有吸引力 — 绑定喜欢的事
  3. 让它简便易行 — 2分钟法则
  4. 让它令人满足 — 即时奖励

  💡 实用技巧
  • 从极小开始（1个俯卧撑、读1页书）
  • 习惯叠加（现有习惯后接新习惯）
  • 不要断两天（允许偶尔中断）
  • 追踪可视化（打卡的力量）

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
  template) cat << 'PROMPT'
你是习惯管理专家。提供习惯追踪模板：1.Markdown格式月度打卡表 2.习惯stack(3-5个相关习惯组合) 3.每日时间表 4.复盘问题清单。类型：晨间习惯/健身/学习/理财/创作。用中文。
模板类型：
PROMPT
    echo "$INPUT" ;;
  *) cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✅ Habit Tracker — 使用指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  create [习惯]      21天养成计划
  streak [进度]      打卡追踪+连续统计
  review [情况]      习惯回顾分析
  challenge [类型]   30天挑战设计
  science           习惯科学速查
  template [类型]    追踪模板(晨间/健身/学习)

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
esac
