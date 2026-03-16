#!/usr/bin/env bash
# linkedin.sh — LinkedIn content generation assistant
# Usage: bash scripts/linkedin.sh <command> [args...]
# Commands: write, hook, hashtag, carousel, comment, profile

set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

show_help() {
    cat << 'HELP'
LinkedIn Post Writer — Generate professional LinkedIn content

Usage: bash scripts/linkedin.sh <command> [args...]

Commands:
  write   <topic> [tone]        Generate a LinkedIn post
  hook    <topic>               Generate attention-grabbing opening lines
  hashtag <topic> [count]       Suggest relevant hashtags
  carousel <topic> [slides]     Plan a carousel/slide post
  comment <context>             Generate a thoughtful comment
  profile <role> [industry]     Optimize LinkedIn headline/about

Tones (for write): professional, storytelling, contrarian, educational, inspirational

Examples:
  bash scripts/linkedin.sh write "AI in hiring" storytelling
  bash scripts/linkedin.sh hook "remote work"
  bash scripts/linkedin.sh hashtag "data science" 10
  bash scripts/linkedin.sh carousel "leadership" 8
  bash scripts/linkedin.sh comment "Post about burnout culture"
  bash scripts/linkedin.sh profile "Product Manager" "SaaS"

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELP
}

gen_write() {
    local topic="${1:-}"
    local tone="${2:-professional}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/linkedin.sh write <topic> [tone]"
        return 1
    fi

    local tone_guide=""
    case "$tone" in
        professional)
            tone_guide="Write in a clean, authoritative, professional tone. Use data points and clear structure. Avoid fluff."
            ;;
        storytelling)
            tone_guide="Write as a personal narrative. Start with a specific moment or experience. Use short paragraphs and line breaks for readability. Build tension, then deliver the lesson."
            ;;
        contrarian)
            tone_guide="Challenge conventional wisdom. Start with a bold, unexpected statement. Back it up with reasoning. Be provocative but respectful."
            ;;
        educational)
            tone_guide="Teach something valuable. Use numbered lists or step-by-step structure. Make it actionable. Include specific examples."
            ;;
        inspirational)
            tone_guide="Motivate and uplift. Share a transformation story or insight. Be genuine, not cheesy. End with an empowering message."
            ;;
        *)
            tone_guide="Write in a clean, professional tone."
            ;;
    esac

    python3 -c "
topic = '${topic}'
tone = '${tone}'
tone_guide = '''${tone_guide}'''

prompt = '''Generate a LinkedIn post about: {topic}

Tone: {tone}
Style guide: {tone_guide}

Requirements:
1. Start with a powerful hook (first 1-3 lines before 'see more')
2. Use short paragraphs (1-2 sentences each) with line breaks between them
3. Include a personal angle or specific example
4. End with a clear call-to-action (question or invitation to engage)
5. Add 3-5 relevant hashtags at the end
6. Total length: 150-300 words (optimal for LinkedIn algorithm)
7. Use line breaks generously — LinkedIn is mobile-first

Format the output as a ready-to-post LinkedIn post.
Do NOT use markdown formatting — output plain text only.'''.format(topic=topic, tone=tone, tone_guide=tone_guide)

print(prompt)
" 
}

gen_hook() {
    local topic="${1:-}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/linkedin.sh hook <topic>"
        return 1
    fi

    python3 -c "
topic = '${topic}'

prompt = '''Generate 7 attention-grabbing LinkedIn post opening hooks about: {topic}

Requirements for each hook:
- Must work in the first 1-3 lines (before the 'see more' button)
- Create curiosity, tension, or an unexpected angle
- Make the reader NEED to click 'see more'

Use these proven formulas (one per hook):
1. Personal failure/lesson: 'I [did X]. Here is what happened...'
2. Bold contrarian take: 'Stop [doing common thing].'
3. Surprising statistic: '[Shocking number] of [people] [do X]...'
4. Question that challenges: 'Why do we still [outdated practice]?'
5. Vulnerability opening: 'I was not going to share this, but...'
6. List tease: '[Number] things I learned from [experience]:'
7. Prediction/trend: 'In 2 years, [dramatic change] will happen.'

Format: Number each hook. Add a brief note on why it works.'''.format(topic=topic)

print(prompt)
"
}

gen_hashtag() {
    local topic="${1:-}"
    local count="${2:-10}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/linkedin.sh hashtag <topic> [count]"
        return 1
    fi

    python3 -c "
topic = '${topic}'
count = '${count}'

prompt = '''Suggest {count} LinkedIn hashtags for the topic: {topic}

Organize into categories:
1. BROAD (high volume, 1M+ followers): 2-3 hashtags
   e.g. #Leadership, #Innovation, #Technology
2. NICHE (medium volume, 10K-1M followers): 3-5 hashtags
   e.g. #ProductManagement, #StartupLife, #DataDriven
3. SPECIFIC (low volume, <10K followers): 2-3 hashtags
   e.g. #AIinHR, #RemoteTeamCulture

For each hashtag, estimate follower count if known.

LinkedIn Best Practice:
- Use 3-5 hashtags per post (optimal)
- Place at the END of the post
- Recommended combo for this topic: [pick best 5]'''.format(count=count, topic=topic)

print(prompt)
"
}

gen_carousel() {
    local topic="${1:-}"
    local slides="${2:-8}"
    if [ -z "$topic" ]; then
        echo "Error: topic is required"
        echo "Usage: bash scripts/linkedin.sh carousel <topic> [slides]"
        return 1
    fi

    python3 -c "
topic = '${topic}'
slides = '${slides}'

prompt = '''Plan a {slides}-slide LinkedIn carousel post about: {topic}

For each slide, provide:
- **Slide number** and **type** (cover/content/CTA)
- **Headline** (big text, 5-8 words max)
- **Body text** (supporting detail, 1-2 short sentences)
- **Visual suggestion** (color, icon, or image idea)

Structure:
- Slide 1: COVER — Eye-catching title + hook subtitle
- Slides 2-{last_content}: CONTENT — One key point per slide
- Last slide: CTA — Follow, save, share prompt

Design tips:
- Consistent color scheme throughout
- One idea per slide (do not overcrowd)
- Use large, readable fonts
- Brand logo/name on every slide (small, corner)
- Aspect ratio: 1:1 or 4:5

Also provide:
- Suggested caption text (for the post accompanying the carousel)
- 3-5 hashtags'''.format(slides=slides, topic=topic, last_content=str(int(slides)-1))

print(prompt)
"
}

gen_comment() {
    local context="${1:-}"
    if [ -z "$context" ]; then
        echo "Error: context is required"
        echo "Usage: bash scripts/linkedin.sh comment <context>"
        return 1
    fi

    python3 -c "
context = '''${context}'''

prompt = '''Generate 3 thoughtful LinkedIn comments for this post context: {context}

For each comment, use a different approach:

1. **Add Value** — Share a related insight, data point, or personal experience
   that extends the conversation

2. **Respectful Challenge** — Offer a different perspective or nuance
   without being confrontational

3. **Story Response** — Share a brief personal anecdote that relates to the topic

Requirements for all comments:
- 2-4 sentences (not too long, not too short)
- Sound genuine, not generic ('Great post!' is lazy)
- Ask a follow-up question to keep the conversation going
- Do NOT use emojis excessively (0-1 max)
- Do NOT start with 'Great post!' or 'Love this!'
- Show you actually read and thought about the post'''.format(context=context)

print(prompt)
"
}

gen_profile() {
    local role="${1:-}"
    local industry="${2:-}"
    if [ -z "$role" ]; then
        echo "Error: role is required"
        echo "Usage: bash scripts/linkedin.sh profile <role> [industry]"
        return 1
    fi

    local industry_ctx=""
    if [ -n "$industry" ]; then
        industry_ctx="Industry/Domain: ${industry}"
    fi

    python3 -c "
role = '${role}'
industry_ctx = '${industry_ctx}'

prompt = '''Optimize a LinkedIn profile for: {role}
{industry_ctx}

Generate the following:

## 1. HEADLINE OPTIONS (3 versions)
LinkedIn headline (220 chars max). Formula: [Role] | [Value Prop] | [Keyword]
- Version A: Authority-focused
- Version B: Results-focused  
- Version C: Mission-focused

## 2. ABOUT SECTION (2 versions)
~300 words each. Structure:
- Opening hook (who you are and why it matters)
- Your unique value / approach
- Key achievements (2-3 specific results)
- What you are looking for / how to connect
- Include relevant keywords naturally for LinkedIn SEO

Version A: Professional/Third-person feel
Version B: Personal/First-person storytelling

## 3. FEATURED SECTION SUGGESTIONS
- 3-5 content ideas to pin in your Featured section
- Types: articles, posts, external links, media

## 4. KEYWORD LIST
- 15-20 keywords to naturally include across your profile
- Organized by: job title variants, skills, industry terms'''.format(role=role, industry_ctx=industry_ctx)

print(prompt)
"
}

case "$CMD" in
    write)
        gen_write "$@"
        ;;
    hook)
        gen_hook "$@"
        ;;
    hashtag)
        gen_hashtag "$@"
        ;;
    carousel)
        gen_carousel "$@"
        ;;
    comment)
        gen_comment "$@"
        ;;
    profile)
        gen_profile "$@"
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
