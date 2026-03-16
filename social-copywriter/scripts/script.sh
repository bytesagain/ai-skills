#!/usr/bin/env bash
# social-copywriter — Social media copywriting toolkit
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${COPY_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/social-copywriter}"
mkdir -p "$DATA_DIR/templates"

show_help() {
    cat << HELP
social-copywriter v$VERSION

Usage: social-copywriter <command> [args]

Writing:
  hook <topic>                  5 attention hooks
  caption <topic> [platform]    Platform-optimized caption
  thread <topic> [tweets]       Twitter/X thread builder
  carousel <topic> [slides]     Carousel post planner
  headline <topic>              10 headline variations
  cta <goal>                    Call-to-action copy

Frameworks:
  aida <product>                AIDA framework (Attention-Interest-Desire-Action)
  pas <problem>                 PAS framework (Problem-Agitate-Solve)
  fab <product>                 FAB framework (Features-Advantages-Benefits)
  storytelling <topic>          Story arc for posts
  before-after <topic>          Before/After transformation copy

Platform:
  twitter <topic>               Twitter-optimized (280 chars)
  instagram <topic>             Instagram caption + hashtags
  linkedin <topic>              LinkedIn professional post
  tiktok <topic>                TikTok caption + sounds
  email <topic> [type]          Email copy (welcome|promo|newsletter)

Tools:
  hashtags <topic> [n]          Generate n hashtags
  emoji <topic>                 Relevant emoji suggestions
  schedule                      Best posting times by platform
  swipe                         Swipe file templates
  history                       Recent copywriting
  help                          Show this help

HELP
}

cmd_hook() {
    local topic="${1:?Usage: social-copywriter hook <topic>}"
    echo "  ═══ 5 HOOKS: $topic ═══"
    echo ""
    echo "  1. Question:"
    echo "     \"What if everything you knew about $topic was wrong?\""
    echo ""
    echo "  2. Statistic:"
    echo "     \"[X]% of people fail at $topic. Here's why.\""
    echo ""
    echo "  3. Story:"
    echo "     \"I spent [X] months mastering $topic. This changed everything.\""
    echo ""
    echo "  4. Contrarian:"
    echo "     \"Stop trying to $topic. Do this instead.\""
    echo ""
    echo "  5. List:"
    echo "     \"7 $topic secrets nobody talks about (thread 🧵)\""
    _log "hook" "$topic"
}

cmd_caption() {
    local topic="${1:?Usage: social-copywriter caption <topic> [platform]}"
    local platform="${2:-instagram}"
    echo "  Caption ($platform) for: $topic"
    echo "  ──────────────────────────────"
    case "$platform" in
        instagram|ig)
            echo "  Hook line about $topic."
            echo "  "
            echo "  The story/insight paragraph goes here."
            echo "  Make it personal and relatable."
            echo "  "
            echo "  Key takeaway in one sentence."
            echo "  "
            echo "  💡 Save this for later"
            echo "  ❤️ Like if you agree"
            echo "  💬 Comment your experience"
            echo "  "
            echo "  #${topic// /} #tips #growth #mindset #motivation"
            echo ""
            echo "  [Max: 2200 chars, optimal: 138-150]"
            ;;
        twitter|x)
            echo "  $topic — here's what most people get wrong:"
            echo "  "
            echo "  ➜ Point 1"
            echo "  ➜ Point 2"
            echo "  ➜ Point 3"
            echo "  "
            echo "  Bookmark this. 🔖"
            echo ""
            echo "  [Max: 280 chars]"
            ;;
        linkedin)
            echo "  I've been thinking about $topic."
            echo "  "
            echo "  Here's what I've learned after [X] years:"
            echo "  "
            echo "  1. Insight one"
            echo "  2. Insight two"
            echo "  3. Insight three"
            echo "  "
            echo "  What's your take? 👇"
            echo ""
            echo "  [Optimal: 1200-1500 chars]"
            ;;
        tiktok)
            echo "  POV: You just discovered the truth about $topic 😱"
            echo "  "
            echo "  #${topic// /} #fyp #viral #learnontiktok"
            echo ""
            echo "  [Max: 300 chars, keep short]"
            ;;
    esac
    _log "caption" "$topic ($platform)"
}

cmd_thread() {
    local topic="${1:?Usage: social-copywriter thread <topic> [tweets]}"
    local n="${2:-7}"
    echo "  ═══ THREAD: $topic ($n tweets) ═══"
    echo ""
    echo "  1/ Hook:"
    echo "  \"$topic — a thread 🧵\""
    echo "  \"Most people don't know this, but...\""
    echo ""
    for i in $(seq 2 $((n - 1))); do
        echo "  $i/ Point $((i-1)):"
        echo "  \"[Key insight #$((i-1)) about $topic]\""
        echo "  \"[Supporting detail or example]\""
        echo ""
    done
    echo "  $n/ Wrap up:"
    echo "  \"TL;DR:\""
    echo "  \"→ Point 1\""
    echo "  \"→ Point 2\""
    echo "  \"→ Point 3\""
    echo "  \"Retweet the first tweet to help others.\""
    _log "thread" "$topic ($n tweets)"
}

cmd_aida() {
    local product="${1:?Usage: social-copywriter aida <product>}"
    echo "  ═══ AIDA Framework: $product ═══"
    echo ""
    echo "  [A] ATTENTION:"
    echo "  \"Tired of struggling with [problem]?\""
    echo ""
    echo "  [I] INTEREST:"
    echo "  \"$product helps you [benefit] in [timeframe].\""
    echo "  \"Unlike [alternatives], it [unique value].\""
    echo ""
    echo "  [D] DESIRE:"
    echo "  \"Imagine [positive outcome]. That's what"
    echo "  [X]+ customers experience with $product.\""
    echo ""
    echo "  [A] ACTION:"
    echo "  \"Start your free trial → [link]\""
    echo "  \"Limited time: [offer]\""
    _log "aida" "$product"
}

cmd_pas() {
    local problem="${1:?Usage: social-copywriter pas <problem>}"
    echo "  ═══ PAS Framework: $problem ═══"
    echo ""
    echo "  [P] PROBLEM:"
    echo "  \"$problem is costing you [time/money/peace].\""
    echo ""
    echo "  [A] AGITATE:"
    echo "  \"Every day you wait, it gets worse."
    echo "  You've tried [solutions] but nothing works.\""
    echo ""
    echo "  [S] SOLVE:"
    echo "  \"Here's the fix: [your solution]."
    echo "  It works because [reason].\""
    _log "pas" "$problem"
}

cmd_fab() {
    local product="${1:?Usage: social-copywriter fab <product>}"
    echo "  ═══ FAB Framework: $product ═══"
    echo ""
    echo "  [F] FEATURES:"
    echo "  → Feature 1: ..."
    echo "  → Feature 2: ..."
    echo ""
    echo "  [A] ADVANTAGES:"
    echo "  → Faster than [competitor]"
    echo "  → Easier to use"
    echo ""
    echo "  [B] BENEFITS:"
    echo "  → Save [X] hours/week"
    echo "  → Make [X]% more revenue"
}

cmd_headline() {
    local topic="${1:?Usage: social-copywriter headline <topic>}"
    echo "  ═══ 10 Headlines: $topic ═══"
    echo "  1. How to $topic (Step-by-Step Guide)"
    echo "  2. The Ultimate Guide to $topic in $(date +%Y)"
    echo "  3. $topic: What Nobody Tells You"
    echo "  4. Why $topic Matters More Than Ever"
    echo "  5. I Tried $topic for 30 Days. Here's What Happened."
    echo "  6. The $topic Mistake 90% of People Make"
    echo "  7. $topic vs [Alternative]: Which Is Better?"
    echo "  8. Everything I Wish I Knew About $topic"
    echo "  9. $topic Simplified: A Beginner's Roadmap"
    echo "  10. The Future of $topic (And Why You Should Care)"
}

cmd_hashtags() {
    local topic="${1:?Usage: social-copywriter hashtags <topic> [count]}"
    local n="${2:-20}"
    echo "  Hashtags for: $topic (top $n)"
    local base=$(echo "$topic" | tr ' ' '' | tr '[:upper:]' '[:lower:]')
    echo "  Core: #${base} #${base}tips #${base}life #learn${base}"
    echo "  Growth: #fyp #viral #trending #explore #foryou"
    echo "  Niche: #${base}community #${base}lover #daily${base}"
    echo "  CTA: #follow #like #share #save #comment"
    echo "  Trending: #${base}$(date +%Y) #new${base} #best${base}"
}

cmd_emoji() {
    local topic="${1:?}"
    echo "  Emoji suggestions for: $topic"
    echo "  CTAs: 👇 💬 ❤️ 🔖 🔗 ➡️"
    echo "  Energy: 🔥 ⚡ 💥 🚀 ✨ 💡"
    echo "  Emotions: 😱 🤔 😍 🎉 💪 👏"
    echo "  Lists: 1️⃣ 2️⃣ 3️⃣ ✅ ❌ ⭐"
}

cmd_schedule() {
    echo "  ═══ Best Posting Times ═══"
    echo "  Twitter/X:   9-11am, 1-3pm (weekdays)"
    echo "  Instagram:   11am-1pm, 7-9pm"
    echo "  LinkedIn:    7-8am, 12pm, 5-6pm (Tue-Thu)"
    echo "  TikTok:      7-9am, 12-3pm, 7-11pm"
    echo "  Facebook:    1-4pm (Wed best)"
    echo "  YouTube:     2-4pm (Thu-Fri for weekend views)"
}

cmd_email() {
    local topic="${1:?Usage: social-copywriter email <topic> [type]}"
    local type="${2:-promo}"
    echo "  Email Copy ($type): $topic"
    case "$type" in
        welcome) echo "  Subject: Welcome aboard! Here's what's next 🎉" ;;
        promo) echo "  Subject: [X]% off $topic — this week only ⚡" ;;
        newsletter) echo "  Subject: This week in $topic — [highlight]" ;;
    esac
}

cmd_carousel() {
    local topic="${1:?Usage: social-copywriter carousel <topic> [slides]}"
    local n="${2:-7}"
    echo "  ═══ Carousel: $topic ($n slides) ═══"
    echo "  Slide 1: HOOK — \"$topic: What You Need to Know\""
    for i in $(seq 2 $((n-1))); do
        echo "  Slide $i: POINT $((i-1)) — \"[Insight #$((i-1))]\""
    done
    echo "  Slide $n: CTA — \"Save & Share 🔖 Follow for more\""
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

case "${1:-help}" in
    hook)        shift; cmd_hook "$@" ;;
    caption)     shift; cmd_caption "$@" ;;
    thread)      shift; cmd_thread "$@" ;;
    carousel)    shift; cmd_carousel "$@" ;;
    headline)    shift; cmd_headline "$@" ;;
    cta)         shift; echo "CTA: Subscribe | Buy Now | Learn More | Start Free Trial" ;;
    aida)        shift; cmd_aida "$@" ;;
    pas)         shift; cmd_pas "$@" ;;
    fab)         shift; cmd_fab "$@" ;;
    storytelling) shift; echo "Story arc: Setup → Conflict → Resolution → Lesson" ;;
    before-after) shift; echo "Before: [pain]. After: [transformation]. How: [your solution]" ;;
    twitter)     shift; cmd_caption "$@" twitter ;;
    instagram)   shift; cmd_caption "$@" instagram ;;
    linkedin)    shift; cmd_caption "$@" linkedin ;;
    tiktok)      shift; cmd_caption "$@" tiktok ;;
    email)       shift; cmd_email "$@" ;;
    hashtags)    shift; cmd_hashtags "$@" ;;
    emoji)       shift; cmd_emoji "$@" ;;
    schedule)    cmd_schedule ;;
    swipe)       echo "TODO: swipe file" ;;
    history)     [ -f "$DATA_DIR/history.log" ] && tail -20 "$DATA_DIR/history.log" || echo "No history" ;;
    help|-h)     show_help ;;
    version|-v)  echo "social-copywriter v$VERSION" ;;
    *)           echo "Unknown: $1"; show_help; exit 1 ;;
esac
