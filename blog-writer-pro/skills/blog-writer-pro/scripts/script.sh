#!/usr/bin/env bash
# blog-writer-pro — Draft blog articles with outlines, SEO, and CTA copy
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="2.1.0"
DATA_DIR="$HOME/.blog-writer-pro"
DRAFTS="$DATA_DIR/drafts"
HISTORY="$DATA_DIR/history.log"

ensure_dirs() { mkdir -p "$DATA_DIR" "$DRAFTS"; }
ts() { date '+%Y-%m-%d %H:%M:%S'; }
log_action() { echo "$(ts)|$1|$2" >> "$HISTORY"; }

show_help() {
    cat << EOF
blog-writer-pro v$VERSION — Blog writing toolkit

Usage: blog-writer-pro <command> [args]

Commands:
  outline <topic>           Generate article outline (H1/H2/H3)
  draft <topic>             Generate article draft framework
  title <topic>             Generate 5 title candidates
  intro <topic>             Generate opening paragraph
  conclusion <topic>        Generate closing paragraph
  cta <type>                Call-to-action copy (subscribe/buy/share/download)
  seo <keyword>             SEO keyword analysis and placement tips
  rewrite <file> <tone>     Rewrite article tone (formal/casual/persuasive)
  wordcount <file>          Word count + readability analysis
  export <file> <fmt>       Export draft (markdown/html/txt)
  list                      List saved drafts
  history                   Show action history
  help                      Show this help
  version                   Show version

Data: $DATA_DIR
EOF
}

cmd_outline() {
    ensure_dirs
    local topic="${1:?Usage: blog-writer-pro outline <topic>}"
    local slug=$(echo "$topic" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-')
    local file="$DRAFTS/${slug}-outline.md"
    cat > "$file" << EOF
# $topic

## Introduction
- Hook: Why $topic matters
- Context: Current landscape
- Thesis: What the reader will learn

## Background
- History and evolution of $topic
- Key concepts and terminology
- Common misconceptions

## Core Analysis
### Point 1: Foundation
- Supporting evidence
- Real-world example
- Data or statistics

### Point 2: Deep Dive
- Technical breakdown
- Case study
- Expert perspective

### Point 3: Practical Application
- Step-by-step guide
- Tools and resources
- Tips and best practices

## Comparison
- Pros and cons
- Alternative approaches
- Decision framework

## Conclusion
- Summary of key points
- Actionable takeaways
- Future outlook

## Call to Action
- Next steps for the reader
- Related resources
- Engagement prompt

---
Generated: $(ts)
EOF
    log_action "outline" "$topic"
    echo "[blog-writer-pro] Outline saved: $file"
    echo "  Sections: 6 main + 3 sub"
    cat "$file"
}

cmd_draft() {
    ensure_dirs
    local topic="${1:?Usage: blog-writer-pro draft <topic>}"
    local slug=$(echo "$topic" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-')
    local file="$DRAFTS/${slug}-draft.md"
    cat > "$file" << EOF
# $topic: A Complete Guide

*Published: $(date '+%B %d, %Y') | Reading time: ~8 min | Author: BytesAgain*

---

## Introduction

[HOOK] Have you ever wondered about $topic? Whether you are a beginner or experienced practitioner, understanding the fundamentals can transform your approach.

In this guide, we will break down everything you need to know about $topic, from basic concepts to advanced strategies.

**What you will learn:**
- The core principles behind $topic
- Practical steps to get started
- Common pitfalls and how to avoid them
- Expert tips for long-term success

---

## Why $topic Matters

[CONTEXT] In today's landscape, $topic has become increasingly relevant. Here is why you should pay attention:

1. **Growing demand** — More professionals are adopting this approach
2. **Proven results** — Case studies show measurable improvements
3. **Low barrier to entry** — You can start with minimal investment

---

## Getting Started

### Step 1: Foundation

[DETAIL] Before diving deep, establish your baseline. Here is what you need:

- Requirement A
- Requirement B
- Requirement C

### Step 2: Implementation

[DETAIL] With the foundation in place, follow this process:

\`\`\`
1. Plan your approach
2. Execute in small iterations
3. Measure and adjust
4. Scale what works
\`\`\`

### Step 3: Optimization

[DETAIL] Once you have a working system, focus on:

- Performance tuning
- Automation opportunities
- Quality improvements

---

## Common Mistakes to Avoid

| Mistake | Why It Happens | How to Fix |
|---------|---------------|------------|
| Rushing the basics | Impatience | Follow the steps in order |
| Ignoring feedback | Ego | Set up regular review cycles |
| Over-complicating | Feature creep | Start simple, add complexity later |

---

## Conclusion

$topic is not just a trend — it is a fundamental skill that pays dividends over time. Start with the basics outlined above, stay consistent, and iterate based on results.

**Your next step:** [CTA — customize based on your audience]

---

*Have questions about $topic? Drop a comment below or reach out at hello@bytesagain.com*
EOF
    log_action "draft" "$topic"
    local wc=$(wc -w < "$file")
    echo "[blog-writer-pro] Draft saved: $file"
    echo "  Words: $wc | Sections: 5 | Tables: 1"
}

cmd_title() {
    local topic="${1:?Usage: blog-writer-pro title <topic>}"
    log_action "title" "$topic"
    echo "[blog-writer-pro] Title candidates for: $topic"
    echo ""
    echo "  1. $topic: The Complete Guide for $(date '+%Y')"
    echo "  2. How to Master $topic (Step-by-Step)"
    echo "  3. $topic Explained: What Every Beginner Should Know"
    echo "  4. The Ultimate $topic Playbook: From Zero to Pro"
    echo "  5. Why $topic Matters More Than Ever (And How to Start)"
}

cmd_intro() {
    local topic="${1:?Usage: blog-writer-pro intro <topic>}"
    log_action "intro" "$topic"
    echo "[blog-writer-pro] Opening paragraph for: $topic"
    echo ""
    echo "---"
    echo "If you have been paying attention to $topic lately, you have probably noticed"
    echo "a shift in how people approach it. Gone are the days of guesswork and trial-and-error."
    echo "Today, there is a clear framework that separates those who succeed from those who struggle."
    echo "In this article, we will walk through the exact steps you need to take, backed by real"
    echo "examples and proven strategies. Whether you are just getting started or looking to level"
    echo "up, this guide has something for you."
    echo "---"
}

cmd_conclusion() {
    local topic="${1:?Usage: blog-writer-pro conclusion <topic>}"
    log_action "conclusion" "$topic"
    echo "[blog-writer-pro] Closing paragraph for: $topic"
    echo ""
    echo "---"
    echo "$topic is one of those areas where consistent effort beats sporadic bursts of activity."
    echo "The strategies we covered today are not theoretical — they are battle-tested approaches"
    echo "used by professionals across the industry. Start with one technique, measure your results,"
    echo "and build from there. The best time to begin was yesterday. The second best time is now."
    echo ""
    echo "What aspect of $topic are you most interested in? Let us know in the comments."
    echo "---"
}

cmd_cta() {
    local ctype="${1:-subscribe}"
    log_action "cta" "$ctype"
    echo "[blog-writer-pro] CTA copy — type: $ctype"
    echo ""
    case "$ctype" in
        subscribe)
            echo "  \"Never miss an update — subscribe to our newsletter and get weekly insights"
            echo "   delivered straight to your inbox. Join 10,000+ readers who stay ahead.\""
            ;;
        buy)
            echo "  \"Ready to take the next step? Our premium guide includes templates, checklists,"
            echo "   and exclusive case studies. Get instant access for \$29.\""
            ;;
        share)
            echo "  \"Found this helpful? Share it with someone who needs to see it."
            echo "   Every share helps us create more free content like this.\""
            ;;
        download)
            echo "  \"Grab the free checklist that goes with this article."
            echo "   Download the PDF and keep it handy for reference.\""
            ;;
        *)
            echo "  Types: subscribe, buy, share, download"
            ;;
    esac
}

cmd_seo() {
    local kw="${1:?Usage: blog-writer-pro seo <keyword>}"
    local kwlen=${#kw}
    log_action "seo" "$kw"
    echo "[blog-writer-pro] SEO analysis for: $kw"
    echo ""
    echo "  Keyword length:      $kwlen characters"
    echo "  Word count:          $(echo "$kw" | wc -w | tr -d ' ') words"
    if [ "$kwlen" -le 30 ]; then
        echo "  Title fit:           Good (under 60 char limit)"
    else
        echo "  Title fit:           Tight (aim for <30 chars in keyword)"
    fi
    echo ""
    echo "  Placement recommendations:"
    echo "    - Title (H1):       Include exact keyword"
    echo "    - First paragraph:  Use within first 100 words"
    echo "    - H2 subheadings:   Use 2-3 variations"
    echo "    - Meta description: Include near the start"
    echo "    - URL slug:         $(echo "$kw" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"
    echo "    - Image alt text:   Use keyword + context"
    echo ""
    echo "  Suggested variations:"
    echo "    - \"best $kw\""
    echo "    - \"how to $kw\""
    echo "    - \"$kw guide\""
    echo "    - \"$kw for beginners\""
    echo "    - \"$kw tips\""
}

cmd_rewrite() {
    local file="${1:?Usage: blog-writer-pro rewrite <file> <tone>}"
    local tone="${2:-casual}"
    if [ ! -f "$file" ]; then
        echo "File not found: $file"; return 1
    fi
    log_action "rewrite" "$file ($tone)"
    local wc=$(wc -w < "$file")
    echo "[blog-writer-pro] Rewrite analysis for: $file (tone: $tone)"
    echo "  Original words: $wc"
    echo ""
    case "$tone" in
        formal)
            echo "  Suggestions for formal tone:"
            echo "    - Replace contractions (don't → do not, can't → cannot)"
            echo "    - Remove colloquialisms and slang"
            echo "    - Use third person instead of first/second"
            echo "    - Add transitional phrases between paragraphs"
            echo "    - Replace short sentences with compound ones"
            ;;
        casual)
            echo "  Suggestions for casual tone:"
            echo "    - Use contractions freely"
            echo "    - Add personal anecdotes or questions"
            echo "    - Shorten paragraphs (3-4 sentences max)"
            echo "    - Use conversational transitions (So, Now, Here is the thing)"
            echo "    - Address the reader directly (you, your)"
            ;;
        persuasive)
            echo "  Suggestions for persuasive tone:"
            echo "    - Lead with benefits, not features"
            echo "    - Add social proof (numbers, testimonials)"
            echo "    - Create urgency (limited time, growing trend)"
            echo "    - Use power words (proven, exclusive, instant)"
            echo "    - End sections with micro-CTAs"
            ;;
        *) echo "  Tones: formal, casual, persuasive" ;;
    esac
}

cmd_wordcount() {
    local file="${1:?Usage: blog-writer-pro wordcount <file>}"
    if [ ! -f "$file" ]; then
        echo "File not found: $file"; return 1
    fi
    local words=$(wc -w < "$file")
    local chars=$(wc -c < "$file")
    local lines=$(wc -l < "$file")
    local paragraphs=$(grep -c '^$' "$file" 2>/dev/null || echo 0)
    local sentences=$(grep -oE '[.!?]' "$file" | wc -l)
    local avg_sentence=0
    [ "$sentences" -gt 0 ] && avg_sentence=$((words / sentences))
    local reading_min=$((words / 250))
    [ "$reading_min" -eq 0 ] && reading_min=1
    log_action "wordcount" "$file"
    echo "[blog-writer-pro] Analysis: $file"
    echo ""
    echo "  Words:          $words"
    echo "  Characters:     $chars"
    echo "  Lines:          $lines"
    echo "  Paragraphs:     ~$paragraphs"
    echo "  Sentences:      ~$sentences"
    echo "  Avg words/sent: ~$avg_sentence"
    echo "  Reading time:   ~${reading_min} min"
    echo ""
    if [ "$avg_sentence" -gt 25 ]; then
        echo "  Readability: Complex — consider shorter sentences"
    elif [ "$avg_sentence" -gt 15 ]; then
        echo "  Readability: Good — balanced sentence length"
    else
        echo "  Readability: Easy — clear and accessible"
    fi
}

cmd_export() {
    ensure_dirs
    local file="${1:?Usage: blog-writer-pro export <file> <format>}"
    local fmt="${2:-markdown}"
    if [ ! -f "$file" ]; then
        echo "File not found: $file"; return 1
    fi
    local base=$(basename "$file" .md)
    local outfile=""
    case "$fmt" in
        markdown|md)
            outfile="$DRAFTS/${base}.md"
            cp "$file" "$outfile"
            ;;
        html)
            outfile="$DRAFTS/${base}.html"
            echo "<!DOCTYPE html><html><head><title>$base</title></head><body>" > "$outfile"
            while IFS= read -r line; do
                case "$line" in
                    "# "*)   echo "<h1>${line#\# }</h1>" >> "$outfile" ;;
                    "## "*)  echo "<h2>${line#\#\# }</h2>" >> "$outfile" ;;
                    "### "*) echo "<h3>${line#\#\#\# }</h3>" >> "$outfile" ;;
                    "")      echo "<br>" >> "$outfile" ;;
                    *)       echo "<p>$line</p>" >> "$outfile" ;;
                esac
            done < "$file"
            echo "</body></html>" >> "$outfile"
            ;;
        txt)
            outfile="$DRAFTS/${base}.txt"
            sed 's/^#\+ //' "$file" | sed 's/\*\*//g' | sed 's/\*//g' > "$outfile"
            ;;
        *) echo "Formats: markdown, html, txt"; return 1 ;;
    esac
    log_action "export" "$file ($fmt)"
    echo "[blog-writer-pro] Exported: $outfile ($(wc -c < "$outfile") bytes)"
}

cmd_list() {
    ensure_dirs
    echo "[blog-writer-pro] Saved drafts:"
    local count=0
    for f in "$DRAFTS"/*; do
        [ -f "$f" ] || continue
        count=$((count + 1))
        local name=$(basename "$f")
        local size=$(wc -c < "$f")
        local words=$(wc -w < "$f")
        printf "  %3d. %-40s %6d bytes  %5d words\n" "$count" "$name" "$size" "$words"
    done
    [ "$count" -eq 0 ] && echo "  (none — try: blog-writer-pro outline <topic>)"
    echo "  Total: $count drafts"
}

cmd_history() {
    ensure_dirs
    if [ ! -f "$HISTORY" ]; then
        echo "[blog-writer-pro] No history yet."
        return
    fi
    echo "[blog-writer-pro] Recent actions:"
    tail -20 "$HISTORY" | while IFS='|' read -r ts action detail; do
        printf "  %-20s %-12s %s\n" "$ts" "$action" "$detail"
    done
    echo "  Total: $(wc -l < "$HISTORY") actions"
}

# Main
CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
    outline)    cmd_outline "$@" ;;
    draft)      cmd_draft "$@" ;;
    title)      cmd_title "$@" ;;
    intro)      cmd_intro "$@" ;;
    conclusion) cmd_conclusion "$@" ;;
    cta)        cmd_cta "$@" ;;
    seo)        cmd_seo "$@" ;;
    rewrite)    cmd_rewrite "$@" ;;
    wordcount)  cmd_wordcount "$@" ;;
    export)     cmd_export "$@" ;;
    list)       cmd_list ;;
    history)    cmd_history ;;
    help|-h)    show_help ;;
    version|-v) echo "blog-writer-pro v$VERSION — Powered by BytesAgain" ;;
    *)          echo "Unknown: $CMD"; show_help; exit 1 ;;
esac
