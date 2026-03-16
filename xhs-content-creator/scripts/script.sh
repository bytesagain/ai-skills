#!/usr/bin/env bash
# xhs-viral-note-writer — 小红书爆款笔记创作助手
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${XHS_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/xhs-viral-note-writer}"
mkdir -p "$DATA_DIR/notes" "$DATA_DIR/templates"

show_help() {
    cat << EOF
xhs-viral-note-writer v$VERSION

小红书爆款笔记创作全流程工具

Usage: xhs-viral-note-writer <command> [args]

创作:
  note <topic>               生成完整笔记(标题+正文+标签)
  title <topic> [n]          生成N个爆款标题
  hook <topic>               开头金句模板
  body <topic> <style>       正文生成(干货/种草/测评/教程)
  ending <type>              结尾互动引导
  emoji <topic>              小红书风格emoji搭配

运营:
  hashtag <topic> [n]        话题标签推荐
  timing                     最佳发布时间
  cover <type>               封面设计建议
  hotspot                    当前热门选题方向
  checklist                  发布前检查清单

管理:
  save <name>                保存笔记草稿
  list                       查看草稿列表
  stats                      创作统计
  templates                  查看模板库
  help                       显示帮助

EOF
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

cmd_note() {
    local topic="${1:?用法: xhs-viral-note-writer note <话题>}"
    echo "  ════════════════════════════════════════"
    echo "  📝 小红书笔记: $topic"
    echo "  ════════════════════════════════════════"
    echo ""
    cmd_title "$topic" 3
    echo ""
    echo "  ── 正文 ──"
    echo "  开头(共情): 姐妹们！关于${topic}我真的有话说！"
    echo "  踩过的坑全在这了，看完少走弯路 👇"
    echo ""
    echo "  ✅ 要点1: [核心干货]"
    echo "  详细说明第一个关键点..."
    echo ""
    echo "  ✅ 要点2: [实操方法]"
    echo "  步骤拆解，降低理解门槛..."
    echo ""
    echo "  ✅ 要点3: [避坑指南]"
    echo "  真实经验分享..."
    echo ""
    echo "  ✅ 要点4: [效果对比]"
    echo "  前后对比/数据佐证..."
    echo ""
    echo "  📌 总结: 一句话概括核心价值"
    echo ""
    echo "  ── 互动引导 ──"
    echo "  觉得有用的姐妹点个赞❤️收藏📁"
    echo "  有问题评论区见～我会一一回复的！"
    echo ""
    cmd_hashtag "$topic" 5
    echo ""
    cmd_emoji "$topic"
    _log "note" "$topic"
}

cmd_title() {
    local topic="${1:?}"
    local n="${2:-5}"
    echo "  🔥 爆款标题 ($topic):"
    local templates=(
        "关于${topic}，我后悔没早点知道的%d件事"
        "${topic}天花板❗️这篇笔记建议收藏"
        "姐妹们！${topic}真的绝了！！！"
        "被问了800遍的${topic}攻略，一次说清✨"
        "${topic}避坑指南｜血泪经验总结"
        "30天${topic}实测｜效果惊人🤯"
        "新手必看！${topic}入门不踩雷"
        "${topic}合集｜全网最全整理📋"
        "打工人的${topic}神器，效率翻倍💪"
        "❌别再这样${topic}了！正确方式是..."
    )
    for i in $(seq 0 $((n-1))); do
        idx=$((i % ${#templates[@]}))
        local t="${templates[$idx]}"
        t=$(echo "$t" | sed "s/%d/$((RANDOM % 5 + 3))/g")
        echo "  $((i+1)). $t"
    done
}

cmd_hook() {
    local topic="${1:?}"
    echo "  ═══ 开头金句: $topic ═══"
    echo "  1. 共情型: 「姐妹们有没有跟我一样，被${topic}困扰很久？」"
    echo "  2. 反转型: 「以前我也觉得${topic}没用，直到...」"
    echo "  3. 数据型: 「花了XX元踩坑${topic}，总结出这几条」"
    echo "  4. 紧迫型: 「关于${topic}，这个方法快要被限流了赶紧看」"
    echo "  5. 权威型: 「做${topic}5年，这些经验分享给你」"
}

cmd_body() {
    local topic="${1:?}"
    local style="${2:-干货}"
    echo "  ═══ 正文模板 ($style): $topic ═══"
    case "$style" in
        干货)
            echo "  结构: 问题→方法→案例→总结"
            echo "  1. 先说痛点(2-3句)"
            echo "  2. 给出3-5个解决方案(每个配emoji)"
            echo "  3. 附上真实案例或数据"
            echo "  4. 一句话总结+互动" ;;
        种草)
            echo "  结构: 场景→产品→体验→对比"
            echo "  1. 场景代入(什么情况下需要)"
            echo "  2. 产品介绍(外观/功能/价格)"
            echo "  3. 真实使用体验(优缺点)"
            echo "  4. 同类对比+购买建议" ;;
        测评)
            echo "  结构: 开箱→使用→优缺点→评分"
            echo "  1. 开箱第一印象"
            echo "  2. 7天使用体验"
            echo "  3. 优点(至少3个) + 缺点(至少1个)"
            echo "  4. 综合评分 + 适合人群" ;;
        教程)
            echo "  结构: 效果展示→工具准备→步骤→注意事项"
            echo "  1. 先晒成品(吸引继续看)"
            echo "  2. 需要的工具/材料清单"
            echo "  3. 分步骤图文教程(每步一张图)"
            echo "  4. 常见问题解答" ;;
        *) echo "  风格: 干货/种草/测评/教程" ;;
    esac
}

cmd_ending() {
    local type="${1:-互动}"
    echo "  ═══ 结尾模板 ($type) ═══"
    case "$type" in
        互动) echo "  「觉得有用就点个赞吧～有问题评论区见！」"
              echo "  「你们还想看什么？评论区告诉我📝」"
              echo "  「收藏=学会✅ 转发=分享❤️」" ;;
        引流) echo "  「更多干货在主页，记得关注不迷路～」"
              echo "  「私信【关键词】获取完整资料📋」" ;;
        促单) echo "  「链接放评论区了，需要的自取～」"
              echo "  「限时优惠ing，犹豫就没了⏰」" ;;
        *) echo "  类型: 互动/引流/促单" ;;
    esac
}

cmd_emoji() {
    local topic="${1:-}"
    echo "  ═══ Emoji搭配建议 ═══"
    echo "  通用: ✨ 💕 📌 🔥 ❤️ 👏 🙌 💯"
    echo "  强调: ❗️ ⚠️ 🚨 ‼️ ⭐️"
    echo "  列表: ✅ 1️⃣ 2️⃣ 3️⃣ ▪️ ▫️"
    echo "  美妆: 💄 💋 🪞 ✨ 🌸"
    echo "  美食: 🍜 🥘 🍰 😋 👨‍🍳"
    echo "  穿搭: 👗 👠 🧥 💅 🎀"
    echo "  学习: 📚 📝 💡 🎯 🧠"
    echo ""
    echo "  规则: 标题1-3个emoji，正文每段1-2个"
}

cmd_hashtag() {
    local topic="${1:?}"
    local n="${2:-8}"
    echo "  ═══ 话题标签: $topic ═══"
    echo "  核心: #${topic} #${topic}分享 #${topic}推荐"
    echo "  流量: #好物分享 #干货分享 #实用技巧"
    echo "  场景: #日常生活 #打工人 #学生党"
    echo "  涨粉: #小红书 #每日分享 #记录生活"
    echo ""
    echo "  规则: 5-10个标签，核心标签放前面"
}

cmd_timing() {
    echo "  ═══ 小红书最佳发布时间 ═══"
    echo "  工作日:"
    echo "    7:00-9:00   通勤 ★★★"
    echo "    12:00-14:00 午休 ★★★★"
    echo "    18:00-20:00 下班 ★★★★"
    echo "    21:00-23:00 睡前 ★★★★★ (黄金时段)"
    echo "  周末:"
    echo "    10:00-12:00 上午 ★★★★"
    echo "    14:00-16:00 下午 ★★★"
    echo "    20:00-22:00 晚上 ★★★★★"
    echo ""
    echo "  类目差异:"
    echo "  美妆穿搭: 晚8-10点 | 美食: 午11-1点 | 学习: 早7-9点"
}

cmd_cover() {
    local type="${1:-图文}"
    echo "  ═══ 封面建议 ($type) ═══"
    case "$type" in
        图文) echo "  • 3:4竖版比例(1080x1440)"
              echo "  • 大标题文字居中(20字以内)"
              echo "  • 高对比色背景(白底红字/黄底黑字)"
              echo "  • 真人出镜 +30% 点击率" ;;
        视频) echo "  • 第一帧要有冲击力"
              echo "  • 加文字标题覆盖"
              echo "  • 展示成品/效果" ;;
        *) echo "  类型: 图文/视频" ;;
    esac
}

cmd_hotspot() {
    echo "  ═══ 热门选题方向 ═══"
    echo "  常青树: 护肤/穿搭/美食/旅行/家居/学习"
    echo "  高增长: AI工具/数码/理财/健身/心理"
    echo "  季节性: 根据当前季节调整"
    echo ""
    echo "  爆款公式:"
    echo "  1. 热门话题 + 个人经验"
    echo "  2. 反常识观点 + 数据支撑"
    echo "  3. 省钱攻略 + 真实对比"
    echo "  4. 高颜值展示 + 教程步骤"
}

cmd_checklist() {
    echo "  ═══ 发布前检查清单 ═══"
    echo "  内容:"
    echo "  [ ] 标题有emoji且<20字？"
    echo "  [ ] 开头3行有钩子？"
    echo "  [ ] 正文分段清晰？"
    echo "  [ ] 有互动引导？"
    echo "  图片:"
    echo "  [ ] 封面够吸引？"
    echo "  [ ] 图片清晰不模糊？"
    echo "  [ ] 图片数量4-9张？"
    echo "  标签:"
    echo "  [ ] 5-10个相关标签？"
    echo "  [ ] 核心标签在前？"
    echo "  合规:"
    echo "  [ ] 没有敏感词？"
    echo "  [ ] 没有硬广？"
    echo "  [ ] 没有引流到站外？"
}

cmd_save() {
    local name="${1:?用法: xhs-viral-note-writer save <名称>}"
    cat > "$DATA_DIR/notes/$name.md"
    echo "  已保存: $name"
    _log "save" "$name"
}

cmd_list() {
    echo "  草稿列表:"
    ls -1 "$DATA_DIR/notes/"*.md 2>/dev/null | while read -r f; do
        printf "  %-25s %s字\n" "$(basename "$f" .md)" "$(wc -c < "$f")"
    done || echo "  (空)"
}

cmd_stats() {
    local total=$(ls "$DATA_DIR/notes/"*.md 2>/dev/null | wc -l || echo 0)
    local logs=$(wc -l < "$DATA_DIR/history.log" 2>/dev/null || echo 0)
    echo "  创作统计:"
    echo "  草稿数: $total"
    echo "  操作数: $logs"
}

cmd_templates() {
    echo "  ═══ 笔记模板库 ═══"
    echo "  1. 干货分享型 — 「关于XX的N个建议」"
    echo "  2. 种草推荐型 — 「用了XX之后再也离不开」"
    echo "  3. 测评对比型 — 「XX vs YY 到底选哪个」"
    echo "  4. 教程攻略型 — 「手把手教你XX」"
    echo "  5. 经验避坑型 — 「XX踩坑实录」"
    echo "  6. 合集清单型 — 「XX合集 一篇搞定」"
}

case "${1:-help}" in
    note)       shift; cmd_note "$@" ;;
    title)      shift; cmd_title "$@" ;;
    hook)       shift; cmd_hook "$@" ;;
    body)       shift; cmd_body "$@" ;;
    ending)     shift; cmd_ending "$@" ;;
    emoji)      shift; cmd_emoji "$@" ;;
    hashtag)    shift; cmd_hashtag "$@" ;;
    timing)     cmd_timing ;;
    cover)      shift; cmd_cover "${1:-图文}" ;;
    hotspot)    cmd_hotspot ;;
    checklist)  cmd_checklist ;;
    save)       shift; cmd_save "$@" ;;
    list)       cmd_list ;;
    stats)      cmd_stats ;;
    templates)  cmd_templates ;;
    help|-h)    show_help ;;
    version|-v) echo "xhs-viral-note-writer v$VERSION" ;;
    *)          echo "Unknown: $1"; show_help; exit 1 ;;
esac
