#!/usr/bin/env bash
CMD="$1"; shift 2>/dev/null; INPUT="$*"
case "$CMD" in
  feed) cat << 'PROMPT'
你是宠物营养师。制定喂养方案：1.每日喂食量(按体重/年龄) 2.推荐粮食品牌 3.禁忌食物清单 4.零食建议 5.饮水量。按猫/狗/年龄段分类。用中文。
宠物信息(类型/品种/年龄/体重)：
PROMPT
    echo "$INPUT" ;;
  health) cat << 'PROMPT'
你是宠物医生。健康检查指南：1.日常观察要点(眼/耳/口/毛/便) 2.疫苗时间表 3.驱虫计划 4.常见疾病症状 5.体检频率建议。用中文。
宠物信息：
PROMPT
    echo "$INPUT" ;;
  train) cat << 'PROMPT'
你是宠物训练师。训练指导：1.基础命令(坐/握手/等待) 2.分步训练法 3.奖励时机 4.常见错误 5.进阶技巧。正向强化为主。用中文。
训练需求：
PROMPT
    echo "$INPUT" ;;
  grooming) cat << 'PROMPT'
你是宠物美容师。护理指南：1.洗澡频率+方法 2.刷毛技巧 3.指甲修剪 4.耳朵清洁 5.牙齿护理 6.推荐工具。按品种定制。用中文。
宠物品种：
PROMPT
    echo "$INPUT" ;;
  emergency) cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🚨 宠物紧急处理速查
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🍫 误食巧克力/葡萄/洋葱
  → 立即就医，记录食用量和时间

  🤮 持续呕吐/腹泻
  → 禁食12h，少量饮水，持续则就医

  🩸 外伤出血
  → 干净布按压止血，不要用酒精

  🌡️ 高温中暑
  → 移到阴凉处，湿毛巾降温，就医

  😮‍💨 呼吸困难
  → 保持通风，立即就医

  🦴 骨折/无法行走
  → 不要强行移动，用硬板固定，就医

  ☎️ 紧急联系
  → 提前存好24h宠物医院电话
  → 保存宠物病历和疫苗记录

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
  checklist) cat << 'PROMPT'
你是宠物生活顾问。生成新手准备清单(Markdown)：1.必备用品(食盆/猫砂盆/窝/牵引绳) 2.预算估算 3.家居安全检查 4.第一周适应指南 5.附近宠物医院查找建议。用中文。
宠物类型(猫/狗/品种)：
PROMPT
    echo "$INPUT" ;;
  *) cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🐾 Pet Care Guide — 使用指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  feed [宠物信息]     喂养方案
  health [宠物信息]   健康检查指南
  train [需求]        训练技巧
  grooming [品种]     美容护理
  emergency          紧急处理速查
  checklist [类型]    新手准备清单

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
esac
