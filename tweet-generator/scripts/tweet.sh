#!/usr/bin/env bash
# tweet.sh — Twitter/X content generation assistant
# Usage: bash scripts/tweet.sh <command> [args...]
# Commands: write, thread, viral, reply, bio, schedule

set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
    cat << 'HELP'
Tweet Generator — Create engaging Twitter/X content

Usage: bash scripts/tweet.sh <command> [args...]

Commands:
  write    <topic> [style]       Generate a tweet (280 chars)
  thread   <topic> [tweets]      Plan a Twitter thread
  viral    <tweet_text>          Analyze viral potential
  reply    <context>             Generate a quality reply
  bio      <role> [personality]  Optimize Twitter bio
  schedule <timezone> [audience] Get optimal posting times

Styles (for write): witty, informative, hot-take, storytelling, promotional

Examples:
  bash scripts/tweet.sh write "AI replacing jobs" hot-take
  bash scripts/tweet.sh thread "startup lessons" 10
  bash scripts/tweet.sh viral "Just quit my job to build AI"
  bash scripts/tweet.sh reply "Post about tech interviews"
  bash scripts/tweet.sh bio "indie hacker" "nerdy"
  bash scripts/tweet.sh schedule "EST" "tech-founders"

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELP
}

gen_write() {
    local topic="${1:-}"
    local style="${2:-witty}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/tweet.sh write <topic> [style]"
        return 1
    fi

    local style_guide=""
    case "$style" in
        witty)
            style_guide="Sharp, clever, and memorable. Use wordplay, irony, or unexpected twists. Think 'shower thought' energy."
            ;;
        informative)
            style_guide="Data-driven and educational. Lead with a surprising stat or insight. Be concise but substantive."
            ;;
        hot-take)
            style_guide="Bold and opinion-driven. Start with 'Unpopular opinion:' or a provocative statement. Be confident, not arrogant."
            ;;
        storytelling)
            style_guide="Mini-narrative in 280 chars. Set scene, create tension, deliver punchline/lesson. Every word counts."
            ;;
        promotional)
            style_guide="Product or project promotion. Lead with value/benefit, not features. Include a clear CTA. Avoid sounding salesy."
            ;;
        *)
            style_guide="Sharp, clever, and memorable."
            ;;
    esac

    python3 -c "
topic = '${topic}'
style = '${style}'
style_guide = '''${style_guide}'''

prompt = '''Generate 5 tweet variations about: {topic}

Style: {style}
Guide: {style_guide}

Requirements for each tweet:
- MUST be under 280 characters (this is critical)
- Show character count after each tweet: [X/280]
- Each tweet should take a different angle on the topic
- Use line breaks where they add impact
- No excessive hashtags (0-2 max)
- No excessive emojis (0-2 max)

Format:
1. [tweet text]
   [char count/280] | Angle: [brief description]

2. [tweet text]
   [char count/280] | Angle: [brief description]

... and so on for all 5.

Also suggest:
- Best time to post this type of content
- Whether to add an image/gif (and what kind)
- Whether to quote-tweet or standalone'''.format(topic=topic, style=style, style_guide=style_guide)

print(prompt)
"
}

gen_thread() {
    local topic="${1:-}"
    local tweets="${2:-7}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/tweet.sh thread <topic> [tweets]"
        return 1
    fi

    python3 -c "
topic = '${topic}'
tweets = '${tweets}'

prompt = '''Plan a {tweets}-tweet Twitter thread about: {topic}

Structure:
- Tweet 1 (HOOK): Must be compelling enough to stand alone and make people click the thread. End with '(thread)' or use the thread emoji.
- Tweets 2-{last}: One clear point per tweet. Each should be independently valuable.
- Last tweet (CTA): Summarize key takeaway + ask for follow/retweet/bookmark.

For each tweet provide:
- Tweet number: X/{tweets}
- The full tweet text (under 280 chars each)
- [char count/280]
- Media suggestion (image/gif/none)

Thread best practices applied:
- Number tweets for easy reference
- Use line breaks for readability
- Make each tweet quotable on its own
- Build momentum — each tweet should make people want the next
- End strong with a summary + CTA

Also provide:
- Suggested posting time
- Whether to post all at once or space them out
- A 'teaser tweet' to post 1 hour before the thread'''.format(tweets=tweets, topic=topic, last=str(int(tweets)-1))

print(prompt)
"
}

gen_viral() {
    local tweet_text="${1:-}"
    if [ -z "$tweet_text" ]; then
        echo "Error: tweet text is required"
        echo "Usage: bash scripts/tweet.sh viral <tweet_text>"
        return 1
    fi

    python3 -c "
tweet = '''${tweet_text}'''

prompt = '''Analyze the viral potential of this tweet: \"{tweet}\"

Rate each factor (1-10) and explain:

## Viral Scorecard

| Factor | Score | Notes |
|--------|-------|-------|
| Hook Strength | X/10 | Does it stop the scroll? |
| Emotional Trigger | X/10 | Does it evoke a strong emotion? |
| Relatability | X/10 | Will people see themselves in it? |
| Shareability | X/10 | Would people RT/quote this? |
| Controversy Level | X/10 | Does it invite debate? |
| Clarity | X/10 | Is the message instantly clear? |
| Uniqueness | X/10 | Has this been said before? |

**Overall Viral Score: X/70**

## Verdict
- Viral likelihood: [Low/Medium/High/Very High]
- Expected engagement: [range]
- Best audience: [who will engage most]

## Improvement Suggestions
Provide 3 rewritten versions with higher viral potential, explaining what changed and why.'''.format(tweet=tweet)

print(prompt)
"
}

gen_reply() {
    local context="${1:-}"
    if [ -z "$context" ]; then
        echo "Error: context is required"
        echo "Usage: bash scripts/tweet.sh reply <context>"
        return 1
    fi

    python3 -c "
context = '''${context}'''

prompt = '''Generate 4 quality reply tweets for this context: {context}

Each reply should use a different strategy:

1. **Agree and Amplify** — Build on their point with a new angle or example
2. **Witty Response** — Clever, funny, but not mean-spirited
3. **Add Value** — Share a relevant data point, resource, or insight
4. **Thoughtful Challenge** — Respectfully offer a different perspective

Requirements for all replies:
- Under 280 characters each
- Show [char count/280]
- Sound natural, not robotic
- Do NOT start with generic 'This!' or 'So true!'
- Would genuinely add to the conversation
- Could attract followers from the original poster audience'''.format(context=context)

print(prompt)
"
}

gen_bio() {
    local role="${1:-}"
    local personality="${2:-professional}"
    if [ -z "$role" ]; then
        echo "Error: role is required"
        echo "Usage: bash scripts/tweet.sh bio <role> [personality]"
        return 1
    fi

    python3 -c "
role = '${role}'
personality = '${personality}'

prompt = '''Create 5 Twitter/X bio options for: {role}
Personality vibe: {personality}

Requirements:
- 160 characters max each
- Show [char count/160]
- Include what you do + who you help + personality flair
- Use line breaks where effective (they work in Twitter bios)

Formats to try:
1. **One-liner**: Punchy, single sentence
2. **Stacked**: Multiple short lines with line breaks
3. **Emoji-accented**: Strategic emoji as bullet points
4. **Minimalist**: Ultra-short, mysterious
5. **Builder-style**: 'Building [X] | Previously [Y] | [Interest]'

Also suggest:
- Pinned tweet idea that complements the bio
- Profile pic style recommendation
- Banner image concept'''.format(role=role, personality=personality)

print(prompt)
"
}

gen_schedule() {
    local timezone="${1:-}"
    local audience="${2:-general}"
    if [ -z "$timezone" ]; then
        echo "Error: timezone is required"
        echo "Usage: bash scripts/tweet.sh schedule <timezone> [audience]"
        return 1
    fi

    python3 -c "
timezone = '${timezone}'
audience = '${audience}'

prompt = '''Create an optimal Twitter/X posting schedule.

Timezone: {timezone}
Target audience: {audience}

## Weekly Posting Schedule

For each day (Mon-Sun), provide:
- Number of tweets recommended
- Best posting times (in {timezone})
- Content type for each slot (original/reply/retweet/thread)

## Content Mix (Weekly)
- Original tweets: X per week
- Threads: X per week
- Replies/engagement: X per day
- Retweets with commentary: X per week

## Time Slot Analysis
| Time Slot | Engagement Level | Best Content Type | Why |
|-----------|-----------------|-------------------|-----|
| Early AM  | ...             | ...               | ... |
| Mid-morning | ...           | ...               | ... |
| Lunch     | ...             | ...               | ... |
| Afternoon | ...             | ...               | ... |
| Evening   | ...             | ...               | ... |

## Audience-Specific Tips for {audience}
- When this audience is most active
- What content they engage with most
- Peak engagement patterns

## Tools Recommendation
- Scheduling tools to use
- Analytics to track
- Engagement routines (daily habits)'''.format(timezone=timezone, audience=audience)

print(prompt)
"
}

case "$CMD" in
    write)
        gen_write "$@"
        ;;
    thread)
        gen_thread "$@"
        ;;
    viral)
        gen_viral "$@"
        ;;
    reply)
        gen_reply "$@"
        ;;
    bio)
        gen_bio "$@"
        ;;
    schedule)
        gen_schedule "$@"
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
