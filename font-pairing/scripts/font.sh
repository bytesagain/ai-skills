#!/usr/bin/env bash
# Font Pairing — font-pairing skill
CMD="$1"; shift 2>/dev/null; INPUT="$*"
case "$CMD" in
  pair) cat << 'PROMPT'
你是字体设计专家。推荐字体搭配方案：1.标题字体+正文字体(3组搭配) 2.适用场景 3.Google Fonts/Adobe Fonts链接 4.CSS代码 5.完整HTML预览文件。用中文。
项目风格/需求：
PROMPT
    echo "$INPUT" ;;
  chinese) cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🇨🇳 中文字体指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📝 正文推荐
  • 思源黑体 (Noto Sans SC) — 免费，最通用
  • 思源宋体 (Noto Serif SC) — 免费，阅读体验好
  • 苹方 (PingFang SC) — macOS/iOS系统字体
  • 微软雅黑 (Microsoft YaHei) — Windows系统字体

  🎯 标题推荐
  • 阿里巴巴普惠体 — 免费商用
  • 站酷系列 — 免费，风格多样
  • 优设标题黑 — 免费，适合大标题
  • 汉仪系列 — 部分免费

  📱 系统字体栈
  font-family: -apple-system, BlinkMacSystemFont,
    "PingFang SC", "Microsoft YaHei",
    "Noto Sans SC", "Helvetica Neue",
    sans-serif;

  ⚡ 性能建议
  • 中文字体文件大(5-15MB)
  • 优先用系统字体栈
  • 必须用Web字体时用font-display: swap
  • 子集化(subset)减小体积

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
  web) cat << 'PROMPT'
你是Web性能专家。生成字体加载最佳方案：1.font-face声明 2.preload标签 3.font-display策略 4.子集化建议 5.回退方案。包含完整HTML代码。用中文。
字体需求：
PROMPT
    echo "$INPUT" ;;
  heading) cat << 'PROMPT'
你是品牌设计师。推荐5种适合标题的字体：1.字体名+风格描述 2.适用场景 3.免费/付费标注 4.CSS代码 5.HTML预览。中英文都推荐。用中文。
风格偏好：
PROMPT
    echo "$INPUT" ;;
  system) cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  💻 系统字体栈
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  通用（零加载时间）:
  font-family: system-ui, -apple-system,
    BlinkMacSystemFont, "Segoe UI", Roboto,
    "Helvetica Neue", Arial, sans-serif;

  中文优化:
  font-family: "PingFang SC", "Microsoft YaHei",
    "Noto Sans SC", "WenQuanYi Micro Hei",
    system-ui, sans-serif;

  等宽（代码）:
  font-family: "SF Mono", "Fira Code",
    "Cascadia Code", Consolas, monospace;

  衬线（阅读）:
  font-family: "Noto Serif SC", "Source Han Serif SC",
    "STSong", Georgia, serif;

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
  preview) cat << 'PROMPT'
你是字体展示专家。生成一个HTML字体预览页面：1.显示指定字体在不同大小(12-48px)的效果 2.中英文示例文本 3.粗体/斜体/不同字重 4.暗色主题 5.可直接浏览器打开。
字体名称：
PROMPT
    echo "$INPUT" ;;
  *) cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🔤 Font Pairing — 使用指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  pair [风格]       字体搭配推荐(3组)
  chinese          中文字体指南
  web [字体]        Web字体加载优化
  heading [风格]    标题字体推荐(5种)
  system           系统字体栈速查
  preview [字体]    字体预览HTML页面

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
esac
