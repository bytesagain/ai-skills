#!/usr/bin/env bash
# bilibili-helper — B站内容创作与运营助手
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${BILI_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bilibili-helper}"
mkdir -p "$DATA_DIR/drafts"

show_help() {
    cat << HELP
bilibili-helper v$VERSION — B站内容创作助手

用法: bilibili-helper <命令> [参数]

内容创作:
  title <topic>                 爆款标题生成（5种风格）
  outline <topic> [duration]    视频脚本大纲
  tags <topic>                  标签推荐（20个）
  description <topic>           简介模板
  cover <topic>                 封面设计建议

运营:
  schedule [day]                发布排期建议
  timing                        最佳发布时间
  trending                      当前热门分区
  monetize                      变现方式清单
  growth                        涨粉策略

分析:
  audit <channel-desc>          频道诊断
  benchmark <niche>             同类UP主分析模板
  retention                     完播率优化建议
  thumbnail                     封面A/B测试建议

工具:
  danmaku <text>                弹幕互动模板
  reply <type>                  评论回复模板
  collab                        合作邀请模板
  draft save|list|show          草稿管理
  stats                         统计
  help                          帮助

HELP
}

cmd_title() {
    local topic="${1:?用法: bilibili-helper title <话题>}"
    echo "  ═══ B站爆款标题: $topic ═══"
    echo ""
    echo "  1. 数字型:"
    echo "     「$topic的10个神级技巧，第5个绝了！」"
    echo ""
    echo "  2. 反转型:"
    echo "     「$topic竟然可以这样？我后悔没早知道」"
    echo ""
    echo "  3. 挑战型:"
    echo "     「挑战用$topic做XX，结果翻车了...」"
    echo ""
    echo "  4. 教程型:"
    echo "     「【保姆级教程】$topic从入门到精通」"
    echo ""
    echo "  5. 情感型:"
    echo "     「做$topic三年了，说说我的心里话」"
    echo ""
    echo "  ⚠️ B站标题最佳: 15-25字, 带【】分区标签"
    _log "title" "$topic"
}

cmd_outline() {
    local topic="${1:?用法: bilibili-helper outline <话题> [时长分钟]}"
    local dur="${2:-8}"
    echo "  ═══ 视频脚本: $topic (${dur}分钟) ═══"
    echo ""
    echo "  [0:00-0:15] 开场钩子"
    echo "    → 「三秒定生死」: 冲击画面/问题/数据"
    echo ""
    echo "  [0:15-0:40] 自我介绍+预告"
    echo "    → 「大家好，今天聊$topic」"
    echo "    → 预告内容要点（制造期待）"
    echo ""
    local seg=$(( (dur * 60 - 60) / 3 ))
    for i in 1 2 3; do
        local s=$(( 40 + (i-1) * seg ))
        local e=$((s + seg))
        printf "  [%d:%02d-%d:%02d] 要点%d\n" $((s/60)) $((s%60)) $((e/60)) $((e%60)) "$i"
        echo "    → 核心观点 + 素材展示"
        echo "    → 「注意这里...」（提高完播率）"
        echo ""
    done
    echo "  [最后30秒] 结尾"
    echo "    → 总结 + 「一键三连」"
    echo "    → 「下期预告：...」"
    _log "outline" "$topic (${dur}min)"
}

cmd_tags() {
    local topic="${1:?用法: bilibili-helper tags <话题>}"
    echo "  ═══ 标签推荐: $topic ═══"
    echo "  核心标签（必加）:"
    echo "    #$topic #${topic}教程 #${topic}入门"
    echo ""
    echo "  分区标签:"
    echo "    #知识分享 #科技 #教程 #干货 #学习"
    echo ""
    echo "  流量标签:"
    echo "    #涨知识 #收藏 #必看 #推荐 #宝藏UP"
    echo ""
    echo "  长尾标签:"
    echo "    #${topic}技巧 #${topic}指南 #${topic}实战"
    echo ""
    echo "  ⚠️ B站最多10个标签, 优先放核心标签"
}

cmd_description() {
    local topic="${1:?用法: bilibili-helper description <话题>}"
    echo "  ═══ 简介模板 ═══"
    echo "  ─────────────────"
    echo "  关于${topic}的详细讲解。"
    echo ""
    echo "  📌 时间线:"
    echo "  00:00 开场"
    echo "  00:30 第一部分"
    echo "  03:00 第二部分"
    echo "  06:00 第三部分"
    echo "  08:00 总结"
    echo ""
    echo "  🔗 相关链接:"
    echo "  资料下载: (网盘链接)"
    echo "  上期视频: BVxxxxxxx"
    echo ""
    echo "  💬 互动话题:"
    echo "  你对${topic}有什么看法？评论区聊聊~"
    echo ""
    echo "  📧 合作联系: (邮箱)"
}

cmd_timing() {
    echo "  ═══ B站最佳发布时间 ═══"
    echo ""
    echo "  工作日:"
    echo "    7:00-8:00   通勤高峰"
    echo "    12:00-13:00 午休"
    echo "    18:00-20:00 下班黄金期 ★★★"
    echo "    21:00-23:00 晚间高峰 ★★★"
    echo ""
    echo "  周末:"
    echo "    10:00-12:00 上午活跃"
    echo "    14:00-16:00 下午活跃"
    echo "    20:00-22:00 晚间高峰 ★★★"
    echo ""
    echo "  分区差异:"
    echo "    游戏: 周五晚/周末"
    echo "    知识: 工作日晚"
    echo "    生活: 周末上午"
}

cmd_trending() {
    echo "  ═══ B站热门分区 ═══"
    echo "  1. 知识区 — 科普/教程/职场"
    echo "  2. 科技区 — 数码/软件/AI"
    echo "  3. 生活区 — vlog/美食/旅行"
    echo "  4. 游戏区 — 实况/攻略/电竞"
    echo "  5. 影视区 — 解说/混剪/吐槽"
    echo "  6. 音乐区 — 翻唱/原创/教学"
}

cmd_monetize() {
    echo "  ═══ B站变现方式 ═══"
    echo "  1. 创作激励 — 播放量收益（需1000粉）"
    echo "  2. 充电计划 — 粉丝打赏"
    echo "  3. 花火商单 — 品牌合作"
    echo "  4. 直播 — 礼物+带货"
    echo "  5. 课程 — B站课堂"
    echo "  6. 带货 — 视频橱窗"
    echo "  7. 私域 — 引流微信/淘宝"
}

cmd_growth() {
    echo "  ═══ B站涨粉策略 ═══"
    echo "  1. 封面标题 — 决定点击率"
    echo "  2. 前5秒 — 决定完播率"
    echo "  3. 互动引导 — 「一键三连」"
    echo "  4. 评论区运营 — 回复+置顶"
    echo "  5. 系列化 — 合集功能"
    echo "  6. 热点蹭流 — 但要自然"
    echo "  7. 投稿频率 — 每周2-3更"
    echo "  8. 跨区投稿 — 增加曝光"
}

cmd_retention() {
    echo "  ═══ 完播率优化 ═══"
    echo "  开头: 前3秒抓注意力（不要长片头）"
    echo "  节奏: 每30秒一个小高潮"
    echo "  互动: 「你觉得呢？」「弹幕打1」"
    echo "  视觉: 画面切换不超过8秒"
    echo "  BGM: 跟节奏走，低潮期换音乐"
    echo "  片尾: 不要太长，15秒内结束"
}

cmd_danmaku() {
    local text="${1:-互动}"
    echo "  ═══ 弹幕互动模板 ═══"
    echo "  「弹幕打1支持UP主！」"
    echo "  「同意的打666！」"
    echo "  「你们觉得选A还是B？」"
    echo "  「前方高能！」"
    echo "  「这里是重点，记笔记！」"
}

cmd_reply() {
    local type="${1:-thanks}"
    echo "  评论回复模板 ($type):"
    case "$type" in
        thanks) echo "  「谢谢支持！你的三连是我更新的动力💪」" ;;
        question) echo "  「好问题！简单说就是...下期详细讲~」" ;;
        negative) echo "  「感谢反馈，我会改进的，欢迎继续关注~」" ;;
        *) echo "  Types: thanks, question, negative, pin" ;;
    esac
}

cmd_cover() {
    local topic="${1:?}"
    echo "  ═══ 封面建议: $topic ═══"
    echo "  1. 大字标题 — 3-6个字，高对比"
    echo "  2. 人物出镜 — 夸张表情"
    echo "  3. 对比图 — Before/After"
    echo "  4. 信息图 — 数字+箭头"
    echo "  5. 分辨率: 1920x1200 (16:10)"
}

cmd_draft() {
    local action="${1:-list}"
    case "$action" in
        save) cat > "$DATA_DIR/drafts/${2:?}.md"; echo "已保存: $2" ;;
        list) ls -1 "$DATA_DIR/drafts/"*.md 2>/dev/null | xargs -I{} basename {} .md || echo "(空)" ;;
        show) [ -f "$DATA_DIR/drafts/${2:?}.md" ] && cat "$DATA_DIR/drafts/$2.md" || echo "找不到" ;;
    esac
}

cmd_stats() {
    echo "[bilibili-helper] 统计"
    echo "  草稿: $(ls -1 "$DATA_DIR/drafts/"*.md 2>/dev/null | wc -l) 篇"
    echo "  操作: $(wc -l < "$DATA_DIR/history.log" 2>/dev/null || echo 0) 次"
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

case "${1:-help}" in
    title)       shift; cmd_title "$@" ;;
    outline)     shift; cmd_outline "$@" ;;
    tags)        shift; cmd_tags "$@" ;;
    description|desc) shift; cmd_description "$@" ;;
    cover)       shift; cmd_cover "$@" ;;
    schedule)    echo "建议: 周三/周五/周日 晚8点" ;;
    timing)      cmd_timing ;;
    trending)    cmd_trending ;;
    monetize)    cmd_monetize ;;
    growth)      cmd_growth ;;
    audit)       shift; echo "TODO: 频道诊断" ;;
    benchmark)   shift; echo "TODO: 竞品分析" ;;
    retention)   cmd_retention ;;
    thumbnail)   shift; cmd_cover "$@" ;;
    danmaku)     shift; cmd_danmaku "$@" ;;
    reply)       shift; cmd_reply "$@" ;;
    collab)      echo "  合作邮件模板: 「您好，我是B站UP主...」" ;;
    draft)       shift; cmd_draft "$@" ;;
    stats)       cmd_stats ;;
    help|-h)     show_help ;;
    version|-v)  echo "bilibili-helper v$VERSION" ;;
    *)           echo "未知: $1"; show_help; exit 1 ;;
esac
