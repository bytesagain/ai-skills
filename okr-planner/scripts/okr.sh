#!/usr/bin/env bash
CMD="$1"; shift 2>/dev/null; INPUT="$*"
case "$CMD" in
  create) cat << 'PROMPT'
你是OKR教练。制定OKR：1.Objective(鼓舞人心) 2.3-5个Key Results(可衡量,有挑战) 3.每个KR的里程碑 4.所需资源 5.风险。用中文。
角色和目标：
PROMPT
    echo "$INPUT" ;;
  review) cat << 'PROMPT'
你是OKR评审专家。季度复盘：1.完成度评分(0-1.0) 2.每个KR分析 3.成功因素 4.改进空间 5.下季度建议。用中文。
OKR执行情况：
PROMPT
    echo "$INPUT" ;;
  align) cat << 'PROMPT'
你是战略对齐专家。检查OKR对齐：1.公司→部门→个人的关联 2.冲突识别 3.缺失环节 4.对齐建议。用中文。
各级OKR：
PROMPT
    echo "$INPUT" ;;
  score) cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📊 OKR 评分标准
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  0.0-0.3  ❌ 未达标(需要反思)
  0.4-0.6  ⚠️ 有进展(正常水平)
  0.7-1.0  ✅ 优秀(0.7是甜蜜点)
  1.0      🤔 可能目标设太低了

  评分原则：
  • 0.7 = 完美分数（说明目标有挑战性）
  • 每次都1.0 = 目标太保守
  • 每次都0.3 = 目标不现实或资源不够

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
  template) cat << 'PROMPT'
你是OKR模板专家。提供OKR模板：1.按角色(CEO/产品/技术/营销/HR) 2.Markdown格式 3.示例填充 4.常见KR指标。用中文。
角色/部门：
PROMPT
    echo "$INPUT" ;;
  cascade) cat << 'PROMPT'
你是战略分解专家。将公司目标级联分解：1.公司OKR 2.部门OKR 3.团队OKR 4.个人OKR。确保每级支撑上级目标。用中文。
公司目标：
PROMPT
    echo "$INPUT" ;;
  *) cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🎯 OKR Planner — 使用指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  create [目标]      制定OKR
  review [执行情况]   季度复盘
  align [各级OKR]    对齐检查
  score             评分标准速查
  template [角色]    OKR模板库
  cascade [公司目标]  级联分解

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
esac
