#!/bin/bash
# wechat-mp-writer — WeChat Public Account Content Generator
# Original implementation by BytesAgain

show_help() {
    cat << 'HELP'
微信公众号内容生成器 — WeChat MP Content Writer

Commands:
  article    Generate article outline & draft
  title      Generate attention-grabbing titles
  hook       Create engaging opening hooks
  cta        Generate call-to-action endings
  hashtag    Suggest relevant hashtags
  series     Plan article series
  format     Format article for WeChat style
  analyze    Analyze article structure
  help       Show this help

Usage:
  wechat-mp.sh article "AI如何改变教育"
  wechat-mp.sh title "人工智能" --style 悬念
  wechat-mp.sh hook "为什么90后都在学编程"
  wechat-mp.sh format < draft.txt
HELP
}

cmd_article() {
    local topic="$*"
    [ -z "$topic" ] && { echo "Usage: article <topic>"; return 1; }
    cat << EOF
📝 公众号文章大纲: $topic

━━ 标题选项 ━━
1. 震惊！$topic 的真相竟然是...
2. 深度解析：$topic，你不得不知的5件事
3. $topic 完全指南（建议收藏）

━━ 文章结构 ━━

【开头hook】(100字)
  以故事/数据/问题开场，3秒抓住读者

【第一部分】背景介绍 (200字)
  - 为什么要关注 $topic
  - 当前现状和趋势

【第二部分】核心内容 (500字)
  - 要点1: [具体观点+案例]
  - 要点2: [数据支撑+分析]
  - 要点3: [实操建议+步骤]

【第三部分】实际应用 (300字)
  - 案例分析
  - 可操作的建议

【结尾CTA】(100字)
  - 总结核心价值
  - 引导互动(留言/转发/关注)

━━ 配图建议 ━━
  封面: 清晰主题+大字标题
  正文: 每300字配1图
  数据: 用图表而非纯文字

━━ 排版提醒 ━━
  行间距: 1.75倍
  字号: 正文15px, 标题18px
  段间距: 10-15px
  字体色: #3f3f3f (非纯黑)
EOF
}

cmd_title() {
    local topic="$*"
    local style=""
    # Parse --style
    case "$*" in
        *--style*)
            topic=$(echo "$*" | sed 's/--style.*//' | sed 's/ *$//')
            style=$(echo "$*" | sed 's/.*--style *//')
            ;;
    esac
    [ -z "$topic" ] && { echo "Usage: title <topic> [--style 悬念|干货|情感|数字]"; return 1; }
    
    cat << EOF
🎯 标题生成: $topic

【悬念型】
  1. $topic 背后不为人知的秘密
  2. 99%的人都不知道的$topic 真相
  3. 看完这篇关于$topic 的文章，我沉默了

【干货型】
  4. $topic 实操指南：从入门到精通
  5. 一文讲透$topic（建议收藏）
  6. $topic 的10个实用技巧，第7个太绝了

【情感型】
  7. 致每一个关心$topic 的你
  8. $topic 这件事，越早知道越好
  9. 为什么我建议你现在就了解$topic

【数字型】
  10. 3分钟搞懂$topic
  11. 关于$topic 的5个误区，你中了几个？
  12. $topic 的2024终极总结

💡 爆款要素: 好奇心+利益点+紧迫感
EOF
}

cmd_hook() {
    local topic="$*"
    [ -z "$topic" ] && { echo "Usage: hook <topic>"; return 1; }
    cat << EOF
🎣 开头Hook: $topic

【故事型】
  "上周，一个朋友问我：$topic 到底怎么回事？
   我愣了一下，因为这个问题的答案，远比我想象的复杂..."

【数据型】
  "根据最新数据显示，$topic 相关的搜索量
   在过去一年增长了300%。这意味着什么？"

【痛点型】
  "如果你也被$topic 困扰过，
   那今天这篇文章，可能会改变你的认知。"

【反问型】
  "你有没有想过，为什么$topic 越来越受关注？
   答案可能和你想的完全不一样。"

【场景型】
  "想象一下：当你终于搞懂了$topic，
   你的生活/工作会发生怎样的变化？"
EOF
}

cmd_cta() {
    cat << 'EOF'
📢 结尾CTA模板:

【互动型】
  "你对这个话题怎么看？欢迎在评论区留下你的看法。
   觉得有用的话，别忘了【点赞】和【在看】👇"

【关注型】
  "关注我，每天分享一个实用干货。
   点击下方名片，第一时间获取最新内容。"

【转发型】
  "如果这篇文章对你有帮助，
   请【转发】给你身边需要的朋友，感谢支持！"

【引流型】
  "想获取更多资料？
   后台回复关键词「XXX」即可免费领取。"

【系列型】
  "这是「系列名」的第X篇，
   点击上方 #话题标签# 查看全部文章。"
EOF
}

cmd_hashtag() {
    local topic="$*"
    [ -z "$topic" ] && { echo "Usage: hashtag <topic>"; return 1; }
    cat << EOF
# 话题标签建议: $topic

核心标签:
  #$topic#  #${topic}干货#  #${topic}分享#

扩展标签:
  #每日分享#  #知识科普#  #实用技巧#
  #成长笔记#  #自我提升#  #职场干货#

💡 标签策略:
  • 3-5个标签最佳
  • 核心标签+热门标签组合
  • 第一个标签要精准匹配主题
EOF
}

cmd_series() {
    local topic="$*"
    [ -z "$topic" ] && { echo "Usage: series <topic>"; return 1; }
    cat << EOF
📚 公众号系列规划: $topic

【推荐5篇系列结构】

第1篇: 入门概述
  "$topic 是什么？一篇文章带你全面了解"
  目标: 建立认知，吸引关注

第2篇: 深度分析
  "深入解读$topic 的核心原理"
  目标: 展示专业度

第3篇: 实操指南
  "$topic 实战手册：手把手教程"
  目标: 提供价值，促进收藏/转发

第4篇: 案例分享
  "盘点$topic 的成功案例"
  目标: 增加可信度

第5篇: 趋势展望
  "$topic 的未来：机遇与挑战"
  目标: 引发讨论，促进互动

━━ 发布节奏 ━━
  建议: 每周2-3篇，固定时间发布
  最佳时间: 早7-9点 / 午12-1点 / 晚8-10点
EOF
}

cmd_format() {
    cat << 'EOF'
📐 微信公众号排版规范:

字体设置:
  标题: 18-20px, 加粗, #000000
  正文: 15-16px, #3f3f3f
  注释: 13-14px, #888888, 斜体

间距设置:
  行间距: 1.75-2倍
  段间距: 10-15px
  首行缩进: 不建议（移动端显示差）

配色方案:
  主色调: 选1个品牌色
  强调色: 用于重点文字/标题
  背景色: #ffffff 或 #fafafa

排版工具推荐:
  • 135编辑器 (135editor.com)
  • 秀米 (xiumi.us)
  • i排版 (ipaiban.com)
  • 壹伴 (yiban.io)

Tips:
  ✓ 每段不超过4行
  ✓ 关键句加粗或变色
  ✓ 善用分割线和小标题
  ✓ 图片居中，宽度100%
  ✗ 不要用太多颜色(≤3种)
  ✗ 不要字号混乱
EOF
}

cmd_analyze() {
    echo "📊 文章分析检查清单:"
    echo ""
    echo "  标题:"
    echo "    □ 是否有好奇心驱动？"
    echo "    □ 是否包含利益点？"
    echo "    □ 字数是否在15-25字？"
    echo ""
    echo "  开头:"
    echo "    □ 前3行是否有吸引力？"
    echo "    □ 是否用了hook技巧？"
    echo ""
    echo "  正文:"
    echo "    □ 结构是否清晰（小标题分段）？"
    echo "    □ 每段是否≤4行？"
    echo "    □ 是否有案例/数据支撑？"
    echo "    □ 配图是否≥3张？"
    echo ""
    echo "  结尾:"
    echo "    □ 是否有明确CTA？"
    echo "    □ 是否引导互动？"
    echo ""
    echo "  SEO:"
    echo "    □ 是否添加话题标签？"
    echo "    □ 摘要是否包含关键词？"
}

case "${1:-help}" in
    article)  shift; cmd_article "$@" ;;
    title)    shift; cmd_title "$@" ;;
    hook)     shift; cmd_hook "$@" ;;
    cta)      cmd_cta ;;
    hashtag)  shift; cmd_hashtag "$@" ;;
    series)   shift; cmd_series "$@" ;;
    format)   cmd_format ;;
    analyze)  cmd_analyze ;;
    help)     show_help ;;
    *)        echo "Unknown: $1"; show_help ;;
esac
