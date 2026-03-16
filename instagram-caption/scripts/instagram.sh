#!/usr/bin/env bash
# instagram.sh — Instagram content generation assistant
# Usage: bash scripts/instagram.sh <command> [args...]
# Commands: caption, hashtag, story, reel, bio, calendar

set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
    cat << 'HELP'
Instagram Caption Writer — Generate engaging Instagram content

Usage: bash scripts/instagram.sh <command> [args...]

Commands:
  caption  <topic> [vibe]       Generate an Instagram caption
  hashtag  <niche> [size]       Generate 30 targeted hashtags
  story    <topic> [slides]     Plan an Instagram Story sequence
  reel     <topic> [duration]   Script a Reels video
  bio      <brand> [type]       Optimize Instagram bio
  calendar <niche> [weeks]      Generate a content calendar

Vibes (for caption): casual, aesthetic, funny, educational, sales

Account sizes (for hashtag): small, medium, large

Examples:
  bash scripts/instagram.sh caption "coffee shop" aesthetic
  bash scripts/instagram.sh hashtag "fitness" medium
  bash scripts/instagram.sh story "product launch" 8
  bash scripts/instagram.sh reel "morning routine" 30
  bash scripts/instagram.sh bio "handmade jewelry" "creator"
  bash scripts/instagram.sh calendar "travel" 4

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELP
}

gen_caption() {
    local topic="${1:-}"
    local vibe="${2:-casual}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/instagram.sh caption <topic> [vibe]"
        return 1
    fi

    local vibe_guide=""
    case "$vibe" in
        casual)
            vibe_guide="Friendly, relatable, conversational. Like talking to a friend. Use some emojis naturally."
            ;;
        aesthetic)
            vibe_guide="Poetic, moody, artsy. Short sentences. Evocative language. Minimal emojis. Think art gallery caption."
            ;;
        funny)
            vibe_guide="Humorous, witty, meme-worthy. Self-deprecating humor works well. Make people tag their friends."
            ;;
        educational)
            vibe_guide="Informative, value-packed. Lead with a surprising fact or tip. Use numbered lists. Make people save the post."
            ;;
        sales)
            vibe_guide="Product promotion with personality. Lead with benefit, not feature. Include social proof. Clear CTA. Not pushy."
            ;;
        *)
            vibe_guide="Friendly and conversational."
            ;;
    esac

    python3 -c "
topic = '${topic}'
vibe = '${vibe}'
vibe_guide = '''${vibe_guide}'''

prompt = '''Generate 3 Instagram caption options for: {topic}

Vibe: {vibe}
Style guide: {vibe_guide}

For each caption:
1. **Hook line** (what shows before 'more' — make it irresistible)
2. **Body** (story, value, or context — 2-4 short paragraphs)
3. **CTA** (engagement driver — question, save prompt, or share prompt)
4. **Emoji usage** (natural, not excessive)

Caption lengths:
- Option A: SHORT (1-2 sentences — for aesthetic/photo-focused posts)
- Option B: MEDIUM (3-5 sentences — balanced)
- Option C: LONG (micro-blog style — for educational/storytelling)

Also provide:
- Suggested post type (single image / carousel / reel)
- Best posting time
- 5 relevant hashtags to use (put full set in a separate hashtag command)'''.format(topic=topic, vibe=vibe, vibe_guide=vibe_guide)

print(prompt)
"
}

gen_hashtag() {
    local niche="${1:-}"
    local size="${2:-medium}"
    if [ -z "$niche" ]; then
        echo "Error: niche is required"
        echo "Usage: bash scripts/instagram.sh hashtag <niche> [size]"
        return 1
    fi

    local size_strategy=""
    case "$size" in
        small)
            size_strategy="Account under 1K followers. Focus heavily on small hashtags (<10K posts) for better ranking chances. Avoid huge hashtags where you will get buried."
            ;;
        medium)
            size_strategy="Account 1K-50K followers. Balanced mix. Can compete in medium hashtags (10K-500K posts). Mix in some larger ones."
            ;;
        large)
            size_strategy="Account 50K+ followers. Can use larger hashtags (500K+ posts) and still rank. Mix in niche ones for targeted reach."
            ;;
        *)
            size_strategy="Balanced mix of small, medium, and large hashtags."
            ;;
    esac

    python3 -c "
niche = '${niche}'
size = '${size}'
size_strategy = '''${size_strategy}'''

prompt = '''Generate 30 Instagram hashtags for the niche: {niche}

Account size: {size}
Strategy: {size_strategy}

Organize into 3 tiers (10 each):

## Tier 1: SMALL (under 10K posts) — 10 hashtags
Highly specific, niche hashtags where you can rank easily.
Format: #hashtag (~estimated post count)

## Tier 2: MEDIUM (10K-500K posts) — 10 hashtags
Category-specific hashtags with moderate competition.
Format: #hashtag (~estimated post count)

## Tier 3: LARGE (500K+ posts) — 10 hashtags
Broad hashtags for maximum exposure (higher competition).
Format: #hashtag (~estimated post count)

## Ready-to-Copy Block
All 30 hashtags in a single copy-paste block (no line breaks).

## Rotation Sets
Create 3 different hashtag sets (10 each) from the 30, for rotation across posts to avoid shadowban.

## Banned/Risky Hashtags Warning
List any hashtags to AVOID in this niche (commonly shadowbanned).'''.format(niche=niche, size=size, size_strategy=size_strategy)

print(prompt)
"
}

gen_story() {
    local topic="${1:-}"
    local slides="${2:-6}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/instagram.sh story <topic> [slides]"
        return 1
    fi

    python3 -c "
topic = '${topic}'
slides = '${slides}'

prompt = '''Plan a {slides}-slide Instagram Story sequence about: {topic}

For each slide, provide:
- **Slide #** and **Type** (photo/video/text/poll/quiz/countdown/question)
- **Visual description** (what the viewer sees)
- **Text overlay** (exact words on screen)
- **Sticker/interactive element** (poll, quiz, emoji slider, question box, etc.)
- **Duration** (how long to show — 5-15 seconds)

Story arc:
- Slides 1-2: HOOK — Grab attention, create curiosity
- Slides 3-{mid}: CONTENT — Deliver value, build engagement
- Last slide: CTA — Drive action (swipe up, DM, visit link, answer question)

Interactive elements to include (at least 2):
- Poll ('This or That', 'Yes/No')
- Quiz (multiple choice)
- Question box ('Ask me anything')
- Emoji slider (rate something)
- Countdown (for launches/events)

Design tips:
- Consistent color/font theme
- Use Instagram native fonts and stickers
- Mix photo, video, and text-only slides
- Add captions for accessibility'''.format(slides=slides, topic=topic, mid=str(int(slides)-1))

print(prompt)
"
}

gen_reel() {
    local topic="${1:-}"
    local duration="${2:-30}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/instagram.sh reel <topic> [duration]"
        return 1
    fi

    python3 -c "
topic = '${topic}'
duration = '${duration}'

prompt = '''Script a {duration}-second Instagram Reel about: {topic}

## Reel Script

### Hook (0-3 seconds)
- What appears on screen (text overlay)
- What is said/narrated
- Visual action to stop the scroll
- Why this hook works

### Body ({body_time})
Break into 2-4 segments. For each:
- Timestamp range
- On-screen text
- Narration/voiceover (or lip-sync text)
- Visual action/transition
- B-roll suggestion

### Ending (last 3 seconds)
- CTA text overlay
- Verbal CTA
- Loop trick (does it loop seamlessly?)

## Technical Details
- **Aspect ratio**: 9:16 (vertical)
- **Audio suggestion**: [trending sound or original audio]
- **Text style**: [font, size, position recommendations]
- **Transitions**: [cut, zoom, swipe — specify for each segment]
- **Captions**: Full text for accessibility

## Caption for the Reel
- Hook line + body + CTA + 5 hashtags

## Trending Audio Ideas
- 3 trending sounds that would work with this content
- Whether to use original audio or trending sound'''.format(duration=duration, topic=topic, body_time='3-{} seconds'.format(str(int(duration)-3)))

print(prompt)
"
}

gen_bio() {
    local brand="${1:-}"
    local acct_type="${2:-creator}"
    if [ -z "$brand" ]; then
        echo "Error: brand/name is required"
        echo "Usage: bash scripts/instagram.sh bio <brand> [type]"
        return 1
    fi

    python3 -c "
brand = '${brand}'
acct_type = '${acct_type}'

prompt = '''Optimize an Instagram bio for: {brand}
Account type: {acct_type}

## Bio Options (5 versions, 150 chars max each)

1. **Emoji Bullet Style**
   Uses emojis as line-break bullet points
   [char count/150]

2. **Minimalist**
   Clean, few words, maximum impact
   [char count/150]

3. **Value Proposition**
   What you do + who it is for + proof
   [char count/150]

4. **Personality-Forward**
   Shows character and vibe
   [char count/150]

5. **CTA-Focused**
   Drives a specific action
   [char count/150]

## Name Field Optimization
The Name field is searchable! Suggest 3 options that include keywords.
Format: {brand} | [searchable keyword]
(30 char max for Name field)

## Additional Elements
- **Category**: Best Instagram category to select
- **CTA Button**: Which action button (Email/Call/Book/Reserve/Order)
- **Highlights covers**: 5-6 highlight categories with emoji icons
- **Link-in-bio**: What to link to and tool recommendation'''.format(brand=brand, acct_type=acct_type)

print(prompt)
"
}

gen_calendar() {
    local niche="${1:-}"
    local weeks="${2:-2}"
    if [ -z "$niche" ]; then
        echo "Error: niche is required"
        echo "Usage: bash scripts/instagram.sh calendar <niche> [weeks]"
        return 1
    fi

    python3 -c "
niche = '${niche}'
weeks = '${weeks}'

prompt = '''Generate a {weeks}-week Instagram content calendar for: {niche}

## Content Strategy
- Posting frequency: 4-5 feed posts + daily stories per week
- Content mix: 40%% educational, 25%% entertaining, 20%% personal, 15%% promotional

## Calendar

For each day with a post, provide:
- **Day & Date** (Week X, Day)
- **Post Type**: Single image / Carousel / Reel
- **Content Pillar**: Educational / Entertaining / Personal / Promotional
- **Topic/Concept**: Specific post idea
- **Caption hook**: First line of the caption
- **Hashtag set**: Which rotation set (A/B/C)
- **Story plan**: Quick note on daily story content
- **Best time to post**: Specific time recommendation

## Weekly Themes
- Week 1 theme: [theme]
- Week 2 theme: [theme]
(etc. for {weeks} weeks)

## Recurring Content Ideas
- **Monday**: [recurring series idea]
- **Wednesday**: [recurring series idea]
- **Friday**: [recurring series idea]

## Content Batching Plan
Group similar content for efficient creation:
- Photo shoot day: [what to shoot]
- Reel filming day: [what to film]
- Writing day: [captions to write]'''.format(weeks=weeks, niche=niche)

print(prompt)
"
}

case "$CMD" in
    caption)
        gen_caption "$@"
        ;;
    hashtag)
        gen_hashtag "$@"
        ;;
    story)
        gen_story "$@"
        ;;
    reel)
        gen_reel "$@"
        ;;
    bio)
        gen_bio "$@"
        ;;
    calendar)
        gen_calendar "$@"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Error: Unknown command '$CMD'"
        echo ""
        show_help
        exit 1
        ;;
esac
