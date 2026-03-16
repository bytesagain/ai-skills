#!/usr/bin/env bash
# podcast.sh — Podcast content generation assistant
# Usage: bash scripts/podcast.sh <command> [args...]
# Commands: outline, shownotes, intro, questions, monetize, distribute

set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
    cat << 'HELP'
Podcast Notes Assistant — Generate podcast content and strategies

Usage: bash scripts/podcast.sh <command> [args...]

Commands:
  outline    <topic> [minutes]          Generate an episode outline
  shownotes  <topic> [format]           Generate show notes
  intro      <topic> [style]            Write an episode intro/opening
  questions  <guest_role> [topic]       Generate guest interview questions
  monetize   <audience_size> [niche]    Monetization strategy
  distribute <podcast_name> [niche]     Distribution channel plan

Formats (for shownotes): brief, detailed, blog-style
Styles (for intro): conversational, professional, storytelling, energetic

Examples:
  bash scripts/podcast.sh outline "remote work" 45
  bash scripts/podcast.sh shownotes "AI healthcare" detailed
  bash scripts/podcast.sh intro "startup failures" conversational
  bash scripts/podcast.sh questions "CTO" "eng culture"
  bash scripts/podcast.sh monetize "5000" "tech"
  bash scripts/podcast.sh distribute "The Daily Build" "software"

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELP
}

gen_outline() {
    local topic="${1:-}"
    local minutes="${2:-30}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/podcast.sh outline <topic> [minutes]"
        return 1
    fi

    python3 -c "
topic = '${topic}'
minutes = '${minutes}'

prompt = '''Create a detailed {minutes}-minute podcast episode outline about: {topic}

## Episode Overview
- **Title options** (3 compelling episode titles)
- **One-line description** (for podcast apps)
- **Target listener** (who is this episode for)

## Detailed Outline

### Cold Open (0:00-0:30)
- Start with the most interesting/provocative point from the episode
- Exact words to say (script the cold open)

### Intro (0:30-1:30)
- Welcome + show intro
- What this episode covers and why it matters
- What the listener will walk away with

### Segment 1: [Title] (1:30-{seg1_end})
- Main topic introduction
- Key points to cover (3-4 bullets)
- Talking points with specific examples
- Transition to next segment

### Segment 2: [Title] ({seg1_end}-{seg2_end})
- Deep dive into core content
- Stories, case studies, or data to reference
- Talking points
- Transition

### Segment 3: [Title] ({seg2_end}-{seg3_end})
- Practical application / actionable advice
- Talking points
- Transition

### Segment 4: [Title] ({seg3_end}-{seg4_end})
- Contrarian view or future predictions
- Discussion questions (for co-host or reflection)
- Talking points

### Key Takeaways ({seg4_end}-{close_start})
- 3 bullet points to summarize
- The ONE thing listeners should remember

### Outro ({close_start}-{minutes}:00)
- CTA: subscribe, review, share
- Preview next episode
- Sign-off

## Preparation Checklist
- Research to do before recording
- Stats/data to look up
- Stories to prepare
- Quotes to include'''.format(
    minutes=minutes, topic=topic,
    seg1_end='{}:00'.format(str(max(int(int(minutes)*0.25), 5))),
    seg2_end='{}:00'.format(str(max(int(int(minutes)*0.5), 10))),
    seg3_end='{}:00'.format(str(max(int(int(minutes)*0.7), 15))),
    seg4_end='{}:00'.format(str(max(int(int(minutes)*0.85), 20))),
    close_start='{}:00'.format(str(max(int(int(minutes)*0.9), 22)))
)

print(prompt)
"
}

gen_shownotes() {
    local topic="${1:-}"
    local fmt="${2:-detailed}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/podcast.sh shownotes <topic> [format]"
        return 1
    fi

    local format_guide=""
    case "$fmt" in
        brief)
            format_guide="Keep it concise. 3-5 sentence summary, key timestamps, and essential links only. Under 200 words."
            ;;
        detailed)
            format_guide="Comprehensive notes. Full summary, all timestamps, detailed descriptions of each segment, all links and resources. 400-600 words."
            ;;
        blog-style)
            format_guide="Write as a blog post that stands alone. Full paragraphs, SEO-optimized, can be published as a companion article. 600-1000 words."
            ;;
        *)
            format_guide="Comprehensive notes with timestamps and links."
            ;;
    esac

    python3 -c "
topic = '${topic}'
fmt = '${fmt}'
format_guide = '''${format_guide}'''

prompt = '''Generate podcast show notes for an episode about: {topic}

Format: {fmt}
Guide: {format_guide}

## Show Notes

### Episode Title
3 options (pick the most compelling)

### Episode Summary
{fmt}-style description for podcast apps and website.

### Timestamps
00:00 - [Section title]
XX:XX - [Section title]
(Include 6-10 timestamps)

### Key Takeaways
- Bullet point 1
- Bullet point 2
- Bullet point 3
(3-5 takeaways)

### Resources Mentioned
- [Resource name] - [brief description] - [placeholder URL]
(List everything referenced in the episode)

### Notable Quotes
> 'Quote 1' - [Speaker]
> 'Quote 2' - [Speaker]
(2-3 memorable quotes)

### Guest Info (if applicable)
- Name and title
- Website
- Social media links
- How to connect

### Call to Action
- Subscribe prompt
- Review request
- Social sharing prompt
- Newsletter/community link

### SEO Keywords
- 5-10 keywords for the show notes page
- Meta description (155 characters)

### Social Media Clips
Suggest 3 moments from the episode that would make great social media clips:
- Clip 1: [timestamp] - [why it is shareable]
- Clip 2: [timestamp] - [why it is shareable]
- Clip 3: [timestamp] - [why it is shareable]'''.format(topic=topic, fmt=fmt, format_guide=format_guide)

print(prompt)
"
}

gen_intro() {
    local topic="${1:-}"
    local style="${2:-conversational}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/podcast.sh intro <topic> [style]"
        return 1
    fi

    local style_guide=""
    case "$style" in
        conversational)
            style_guide="Warm, casual, like talking to a friend. Use natural language and personal anecdotes."
            ;;
        professional)
            style_guide="Polished and authoritative. Clear, structured, confidence-inspiring."
            ;;
        storytelling)
            style_guide="Start with a story or vivid scene. Build curiosity. Make the listener feel like they are there."
            ;;
        energetic)
            style_guide="High energy, enthusiastic, excited. Fast-paced. Make the listener feel pumped."
            ;;
        *)
            style_guide="Warm and engaging."
            ;;
    esac

    python3 -c "
topic = '${topic}'
style = '${style}'
style_guide = '''${style_guide}'''

prompt = '''Write 3 podcast episode intro scripts about: {topic}

Style: {style}
Guide: {style_guide}

Each intro should be ~60-90 seconds when spoken (~150-225 words).

### Intro Version 1: COLD OPEN STYLE
- Start with the most interesting/provocative moment
- Then transition to 'Welcome to [show name]...'
- Set up what the episode covers
- [Speaking pace notes in brackets]

### Intro Version 2: QUESTION HOOK
- Open with a thought-provoking question
- Bridge to why this topic matters NOW
- Preview what the listener will learn
- [Speaking pace notes]

### Intro Version 3: STORY OPENING
- Start with a brief, relevant story or scenario
- Connect it to the episode topic
- Build anticipation for what is coming
- [Speaking pace notes]

## For Each Version Include:
- Word count and estimated speaking time
- Where to place the theme music jingle
- Tone notes (speed, emphasis, pauses)
- Suggested background music mood

## Recording Tips for This Intro
- Pace recommendation
- Where to pause for effect
- Which words to emphasize
- Energy level (1-10)'''.format(topic=topic, style=style, style_guide=style_guide)

print(prompt)
"
}

gen_questions() {
    local guest_role="${1:-}"
    local topic="${2:-}"
    if [ -z "$guest_role" ]; then
        echo "Error: guest role is required"
        echo "Usage: bash scripts/podcast.sh questions <guest_role> [topic]"
        return 1
    fi

    local topic_ctx=""
    if [ -n "$topic" ]; then
        topic_ctx="Focused on the topic: ${topic}"
    fi

    python3 -c "
guest_role = '${guest_role}'
topic_ctx = '${topic_ctx}'

prompt = '''Generate podcast interview questions for a guest who is a: {guest_role}
{topic_ctx}

## Interview Question Set (20 questions)

### Warmup Questions (3)
Easy, personal questions to build rapport and help the guest relax.
- Question + [why this works as a warmup]
- Follow-up prompt if the answer is short

### Background/Journey Questions (4)
Understand their path and what shaped them.
- Question + [what insight this reveals]
- Follow-up prompt

### Core Topic Deep-Dive (6)
The meat of the interview — their expertise and unique perspective.
- Question + [what value this gives the listener]
- Follow-up prompt
- Potential controversial/interesting tangent to explore

### Practical/Actionable Questions (4)
Give listeners something they can USE.
- Question + [actionable takeaway expected]
- Follow-up prompt

### Unexpected/Fun Questions (3)
Surprise the guest, get memorable answers.
- Question + [why this is unexpected]
- Follow-up prompt

## Interview Flow Tips
- Suggested order (may differ from above)
- When to deviate from the script
- Signs the guest wants to go deeper on a topic
- How to redirect if they go off-topic

## The Golden Questions
3 questions that almost always produce great answers:
1. 'What is something you believe that most people in your field disagree with?'
2. 'What is the biggest mistake you have made, and what did you learn?'
3. 'If you could go back and give yourself one piece of advice when you started, what would it be?'

## Pre-Interview Checklist
- Research to do about this guest
- Recent news/projects to reference
- Their social media hot takes to bring up
- Previous podcast appearances to watch (do not repeat questions)'''.format(guest_role=guest_role, topic_ctx=topic_ctx)

print(prompt)
"
}

gen_monetize() {
    local audience_size="${1:-}"
    local niche="${2:-general}"
    if [ -z "$audience_size" ]; then
        echo "Error: audience size is required"
        echo "Usage: bash scripts/podcast.sh monetize <audience_size> [niche]"
        return 1
    fi

    python3 -c "
audience_size = '${audience_size}'
niche = '${niche}'

prompt = '''Create a podcast monetization strategy.

Current audience: {audience_size} downloads per episode
Niche: {niche}

## Current Tier Assessment
Based on {audience_size} downloads/episode, you are in the [X] tier.
Realistic monthly revenue estimate: \$[range]

## Monetization Strategies (Ranked by Feasibility)

### Tier 1: Start Now (Any Audience Size)
1. **Affiliate Marketing**
   - Best affiliate programs for {niche} niche
   - Expected earnings per episode
   - How to integrate naturally (not salesy)
   - Tracking and optimization tips

2. **Listener Support (Patreon/Buy Me a Coffee)**
   - Pricing tiers (suggest 3)
   - Exclusive perks for each tier
   - Expected conversion rate
   - How to pitch it without begging

3. **Your Own Products/Services**
   - Digital products that fit your niche
   - Consulting/coaching opportunities
   - Course or community ideas
   - Revenue projections

### Tier 2: At 1K-5K Downloads/Episode
4. **Sponsorships**
   - How to find sponsors
   - Rate card (CPM for your niche)
   - Pre-roll vs mid-roll vs post-roll
   - Pitch template for sponsors
   - Networks to join (Podcorn, AdvertiseCast, etc.)

5. **Premium Content**
   - Bonus episodes
   - Early access
   - Ad-free feed
   - Behind-the-scenes

### Tier 3: At 5K+ Downloads/Episode
6. **Live Events/Workshops**
7. **Licensing and Syndication**
8. **Merchandise**

## Revenue Projection
| Month | Downloads | Revenue Stream | Est. Revenue |
|-------|-----------|---------------|-------------|
| Now   | {audience_size} | [strategy] | \$[amount] |
| +3mo  | [projected] | [strategy] | \$[amount] |
| +6mo  | [projected] | [strategy] | \$[amount] |
| +12mo | [projected] | [strategy] | \$[amount] |

## Action Plan (Next 30 Days)
- Week 1: [specific action]
- Week 2: [specific action]
- Week 3: [specific action]
- Week 4: [specific action]'''.format(audience_size=audience_size, niche=niche)

print(prompt)
"
}

gen_distribute() {
    local podcast_name="${1:-}"
    local niche="${2:-general}"
    if [ -z "$podcast_name" ]; then
        echo "Error: podcast name is required"
        echo "Usage: bash scripts/podcast.sh distribute <podcast_name> [niche]"
        return 1
    fi

    python3 -c "
podcast_name = '${podcast_name}'
niche = '${niche}'

prompt = '''Create a comprehensive distribution plan for the podcast: \"{podcast_name}\"
Niche: {niche}

## Hosting Platform Recommendation
Compare top 3 hosting platforms for this podcast:
| Platform | Price | Analytics | Distribution | Best For |
|----------|-------|-----------|-------------|----------|
| [name]   | [price] | [rating] | [coverage] | [type] |

## Primary Distribution (Must-Have)
For each platform:
- How to submit
- Optimization tips specific to that platform
- Expected timeline for approval

1. **Apple Podcasts** — [tips]
2. **Spotify** — [tips]
3. **Google/YouTube Podcasts** — [tips]
4. **Amazon Music/Audible** — [tips]

## Secondary Distribution
5. Overcast, Pocket Casts, Castro
6. Stitcher, TuneIn
7. iHeartRadio
8. Podcast Index / Podchaser

## Social Media Distribution Strategy
For each platform, how to repurpose podcast content:

### YouTube
- Full video podcast upload
- Short clips (60-90s) as YouTube Shorts
- Audiogram style (waveform + captions)

### Instagram
- Reels: 30-60s best moments
- Carousel: Key takeaways
- Stories: Behind-the-scenes recording

### Twitter/X
- Thread: Episode key points
- Clips: 30s audio/video
- Quote graphics from the episode

### TikTok
- 15-60s clips from episodes
- Behind-the-scenes recording content
- Trending audio mashups

### LinkedIn
- Long-form post summarizing episode
- Professional insights from the episode
- Tag guests for reach

## Email/Newsletter Strategy
- Episode announcement template
- Weekly digest format
- Subscriber growth tactics

## Cross-Promotion Plan
- How to find podcasts to cross-promote with
- Guest swap strategy
- Promo swap template/script

## SEO Strategy
- Show notes blog optimization
- Transcript publication
- Episode page structure

## Launch Checklist (for new episodes)
Day-of and post-launch tasks in order:
- [ ] Task 1 (pre-publish)
- [ ] Task 2 (publish)
- [ ] Task 3 (post-publish, same day)
- [ ] Task 4 (next day)
- [ ] Task 5 (same week)'''.format(podcast_name=podcast_name, niche=niche)

print(prompt)
"
}

case "$CMD" in
    outline)
        gen_outline "$@"
        ;;
    shownotes)
        gen_shownotes "$@"
        ;;
    intro)
        gen_intro "$@"
        ;;
    questions)
        gen_questions "$@"
        ;;
    monetize)
        gen_monetize "$@"
        ;;
    distribute)
        gen_distribute "$@"
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
