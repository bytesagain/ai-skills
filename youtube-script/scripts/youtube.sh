#!/usr/bin/env bash
# youtube.sh — YouTube content generation assistant
# Usage: bash scripts/youtube.sh <command> [args...]
# Commands: script, title, thumbnail, seo, hook, chapter

set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
    cat << 'HELP'
YouTube Script Writer — Generate YouTube video content

Usage: bash scripts/youtube.sh <command> [args...]

Commands:
  script    <topic> [minutes]    Generate a full video script
  title     <topic>              Generate title A/B test options
  thumbnail <title>              Design thumbnail text/concept
  seo       <topic>              Optimize video SEO metadata
  hook      <topic>              Generate opening hooks (first 30s)
  chapter   <topic> [chapters]   Generate chapter markers/timestamps

Examples:
  bash scripts/youtube.sh script "investing basics" 10
  bash scripts/youtube.sh title "productivity for devs"
  bash scripts/youtube.sh thumbnail "I Quit My Job"
  bash scripts/youtube.sh seo "React vs Vue 2025"
  bash scripts/youtube.sh hook "why startups fail"
  bash scripts/youtube.sh chapter "Python tutorial" 12

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELP
}

gen_script() {
    local topic="${1:-}"
    local minutes="${2:-8}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/youtube.sh script <topic> [minutes]"
        return 1
    fi

    # Estimate word count: ~150 words per minute of speaking
    local word_count
    word_count=$(python3 -c "print(int(${minutes}) * 150)")

    python3 -c "
topic = '${topic}'
minutes = '${minutes}'
word_count = '${word_count}'

prompt = '''Write a complete {minutes}-minute YouTube video script about: {topic}

Target length: ~{word_count} words (at ~150 words/min speaking pace)

## Script Structure

### COLD OPEN / HOOK (0:00-0:30)
- Pattern interrupt or bold statement to stop the scroll
- Preview the value: what viewers will learn/gain
- Create an open loop (tease something for later)
- Write the exact words to say

### INTRO (0:30-1:00)
- Brief channel intro (keep it under 10 seconds)
- Context: why this topic matters RIGHT NOW
- Credibility: why YOU are the person to teach this
- Subscribe CTA (quick, not pushy)

### MAIN CONTENT (1:00-{end_time})
Break into 3-5 clear sections. For each section:
- **Section title** (for chapter markers)
- **Key point** (one main idea)
- **Script** (exact words to say)
- **B-roll/visual notes** [in brackets]
- **Re-hook** at the end of each section to prevent drop-off

Include:
- Specific examples and stories
- Data points where relevant
- Analogies to explain complex ideas
- Pattern interrupts every 2-3 minutes

### CLIMAX / KEY TAKEAWAY ({end_time2})
- The biggest insight or most valuable piece
- Why this matters more than everything else
- Emotional or surprising angle

### OUTRO (last 30 seconds)
- Recap the 3 most important points
- Clear CTA: subscribe, comment with [specific question], watch next video
- End screen recommendation: link to related video
- Sign-off catchphrase (suggest one)

## Production Notes
- Suggested B-roll shots
- Music mood recommendations
- Graphics/text overlay cues
- Thumbnail moment (which part of the video)'''.format(minutes=minutes, topic=topic, word_count=word_count,
    end_time='{}:30'.format(str(int(minutes)-1)),
    end_time2='last 1 minute')

print(prompt)
"
}

gen_title() {
    local topic="${1:-}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/youtube.sh title <topic>"
        return 1
    fi

    python3 -c "
topic = '${topic}'

prompt = '''Generate 10 YouTube title options for a video about: {topic}

## Title A/B Test Options

For each title:
- The full title (under 60 characters — show char count)
- CTR prediction: [Low/Medium/High/Very High]
- Formula used (e.g., 'How I...', 'X Things...', etc.)
- Why it works

Categories (at least 2 titles each):

### Curiosity-Gap Titles
Titles that create an information gap the viewer MUST close.

### Benefit-Driven Titles
Titles that promise a clear outcome or transformation.

### Emotional/Provocative Titles
Titles that trigger strong feelings (surprise, FOMO, controversy).

### Search-Optimized Titles
Titles that include the primary keyword for SEO.

## Recommended A/B Test
Pick the top 2 titles to A/B test and explain why:
- Title A: [title] — Optimized for CTR
- Title B: [title] — Optimized for Search
- When to switch: After [X] impressions, switch to the winner

## Title SEO Analysis
- Primary keyword: [keyword]
- Search volume estimate: [high/medium/low]
- Competition level: [high/medium/low]'''.format(topic=topic)

print(prompt)
"
}

gen_thumbnail() {
    local title="${1:-}"
    if [ -z "$title" ]; then
        echo "Error: title is required"
        echo "Usage: bash scripts/youtube.sh thumbnail <title>"
        return 1
    fi

    python3 -c "
title = '''${title}'''

prompt = '''Design 3 YouTube thumbnail concepts for the video: \"{title}\"

For each thumbnail concept:

### Concept [number]: [name]
- **Text on thumbnail**: [3 words MAX, large and bold]
- **Font style**: [e.g., Impact, bold sans-serif, handwritten]
- **Text color**: [specific color + outline/shadow]
- **Background**: [color, gradient, or image description]
- **Face/Person**: [expression, position, yes/no]
- **Props/Graphics**: [arrows, circles, emojis, icons]
- **Layout**: [where each element goes — left/right/center]
- **Mood/Energy**: [exciting, shocking, calm, mysterious]
- **Color palette**: [2-3 dominant colors]

## Thumbnail Principles Applied
- Readable at mobile size (small)?
- High contrast?
- Creates curiosity gap with the title?
- Consistent with channel branding?

## A/B Test Recommendation
Which 2 thumbnails to test first and why.

## Technical Specs
- Resolution: 1280x720 pixels (minimum)
- Aspect ratio: 16:9
- File size: Under 2MB
- Format: JPG or PNG
- Safe zone: Keep key elements away from timestamp overlay (bottom right)'''.format(title=title)

print(prompt)
"
}

gen_seo() {
    local topic="${1:-}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/youtube.sh seo <topic>"
        return 1
    fi

    python3 -c "
topic = '${topic}'

prompt = '''Generate complete YouTube SEO metadata for a video about: {topic}

## Title (optimized)
- Primary title (under 60 chars): [title]
- Backup title: [alternative]

## Description (2000+ characters)
Write a full YouTube description:
- First 2 sentences: keyword-rich summary (shows in search results)
- Paragraph 2-3: detailed overview of video content
- Timestamps/chapters section
- Related resources and links section
- Social media links section
- About the channel section
- Hashtags (3-5, placed at the end)

## Tags (15-20)
Organize by type:
- Exact match keywords: [5-7 tags]
- Broad keywords: [3-5 tags]
- Long-tail keywords: [5-8 tags]
- Channel/brand tags: [2-3 tags]

## Hashtags (for description)
3-5 hashtags that will appear above the title.

## Cards & End Screen Strategy
- Card 1: [timestamp] — Link to [related video topic]
- Card 2: [timestamp] — Link to [playlist]
- End screen: [video suggestion] + [subscribe button]

## Keyword Research Summary
| Keyword | Search Volume | Competition | Recommendation |
|---------|--------------|-------------|----------------|
| [kw1]   | High         | Medium      | Use in title   |
| [kw2]   | Medium       | Low         | Use in desc     |
| ...     | ...          | ...         | ...            |

## Filename
Rename video file to: [suggested-filename.mp4]'''.format(topic=topic)

print(prompt)
"
}

gen_hook() {
    local topic="${1:-}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/youtube.sh hook <topic>"
        return 1
    fi

    python3 -c "
topic = '${topic}'

prompt = '''Generate 5 powerful YouTube video opening hooks (first 30 seconds) for: {topic}

Each hook should be different style:

### Hook 1: BOLD CLAIM
- Start with a surprising or controversial statement
- Immediately challenge what the viewer thinks they know
- Full script (word for word, 30 seconds of speaking)
- [Visual direction in brackets]

### Hook 2: STORY OPENING
- Start in the middle of a dramatic moment
- Create tension and curiosity
- Full script (30 seconds)
- [Visual direction]

### Hook 3: QUESTION + STAT
- Open with a thought-provoking question
- Follow with a shocking statistic
- Full script (30 seconds)
- [Visual direction]

### Hook 4: PROBLEM AGITATION
- Name a pain point the viewer has
- Make it worse (agitate)
- Promise the solution is in this video
- Full script (30 seconds)
- [Visual direction]

### Hook 5: RESULT TEASE
- Show or describe the end result first
- Make them want to know HOW
- Full script (30 seconds)
- [Visual direction]

## Hook Best Practices Applied
- No long intros or channel plugs
- Value or curiosity in first 5 seconds
- Open loop created (viewer NEEDS to keep watching)
- Pattern interrupt (something unexpected)
- Each hook includes retention prediction [High/Medium]'''.format(topic=topic)

print(prompt)
"
}

gen_chapter() {
    local topic="${1:-}"
    local chapters="${2:-8}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/youtube.sh chapter <topic> [chapters]"
        return 1
    fi

    python3 -c "
topic = '${topic}'
chapters = '${chapters}'

prompt = '''Generate {chapters} chapter markers (timestamps) for a YouTube video about: {topic}

## Chapters / Timestamps

Format (ready to paste into YouTube description):
0:00 - [Chapter title]
X:XX - [Chapter title]
...

Requirements:
- First chapter MUST start at 0:00 (YouTube requirement)
- Each chapter title: concise but descriptive (3-8 words)
- Chapters should have logical flow and progression
- Include estimated duration for each section in parentheses

## Detailed Chapter Breakdown

For each chapter, also provide:
- **Chapter {n}**: [Title]
  - Timestamp: X:XX
  - Duration: ~X minutes
  - Key points covered in this section (2-3 bullets)
  - Re-hook suggestion (how to keep viewers watching into the next chapter)

## Why This Structure Works
- Explanation of the logical flow
- How chapters improve viewer experience
- SEO benefit of chapters (Google can show chapter results in search)

## Bonus: Key Moments
Suggest 2-3 timestamps to mark as 'Key Moments' for Google Search featured snippets.'''.format(chapters=chapters, topic=topic)

print(prompt)
"
}

case "$CMD" in
    script)
        gen_script "$@"
        ;;
    title)
        gen_title "$@"
        ;;
    thumbnail)
        gen_thumbnail "$@"
        ;;
    seo)
        gen_seo "$@"
        ;;
    hook)
        gen_hook "$@"
        ;;
    chapter)
        gen_chapter "$@"
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
