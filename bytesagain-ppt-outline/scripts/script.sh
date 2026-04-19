#!/usr/bin/env bash
# bytesagain-ppt-outline — Presentation outline generator
set -euo pipefail

CMD="${1:-help}"
shift || true

show_help() {
    echo "bytesagain-ppt-outline — Generate structured presentation outlines"
    echo ""
    echo "Usage:"
    echo "  bytesagain-ppt-outline business <topic> <slides>"
    echo "  bytesagain-ppt-outline ted <topic>"
    echo "  bytesagain-ppt-outline academic <topic> <slides>"
    echo "  bytesagain-ppt-outline pitch <product> <audience>"
    echo "  bytesagain-ppt-outline slides <topic> <count>"
    echo "  bytesagain-ppt-outline timer <slides> <minutes>"
    echo ""
}

cmd_business() {
    local topic="${1:-Topic}"; local slides="${2:-12}"
    PPT_TOPIC="$topic" PPT_SLIDES="${slides:-8}" PPT_COUNT="${count:-5}" PPT_PRODUCT="${product:-}" PPT_AUDIENCE="${audience:-}" python3 << 'PYEOF'
import os; topic = os.environ.get("PPT_TOPIC",""); n = int(os.environ.get("PPT_SLIDES","8"))
per = 60 * 20 // n  # assume 20 min presentation

print(f"""
=== Business Presentation: {topic} ===
Format: {n} slides | Audience: Business/Executive

SLIDE STRUCTURE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 1. TITLE SLIDE
    • {topic}
    • Your Name | Date | Company

 2. EXECUTIVE SUMMARY (1 slide)
    • 3 key takeaways upfront
    • What decision/action you need from them

 3. PROBLEM / OPPORTUNITY (1-2 slides)
    • Current situation (data-backed)
    • Pain points or market gap
    • Cost of inaction

 4. PROPOSED SOLUTION (2-3 slides)
    • Your recommendation
    • How it works (simple diagram)
    • Why now?

 5. EVIDENCE / PROOF (2 slides)
    • Case study or pilot results
    • Competitive analysis
    • ROI calculation

 6. IMPLEMENTATION PLAN (1-2 slides)
    • Timeline (quarters or milestones)
    • Resources required
    • Key dependencies

 7. RISKS & MITIGATION (1 slide)
    • Top 3 risks
    • Mitigation strategies

 8. FINANCIAL SUMMARY (1 slide)
    • Investment required
    • Expected return
    • Break-even point

 9. NEXT STEPS & CTA (1 slide)
    • 3 specific asks
    • Decision deadline
    • Contact info

TIMING GUIDE: ~{per} seconds per slide
DESIGN TIP: Max 6 words per bullet, 1 idea per slide
""")
PYEOF
}

cmd_ted() {
    local topic="${1:-Your Idea}"
    PPT_TOPIC="$topic" PPT_SLIDES="${slides:-8}" PPT_COUNT="${count:-5}" PPT_PRODUCT="${product:-}" PPT_AUDIENCE="${audience:-}" python3 << 'PYEOF'
import os; topic = os.environ.get("PPT_TOPIC","")
print(f"""
=== TED-Style Talk Outline: {topic} ===
Format: 18 minutes | Structure: Narrative arc

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[0:00-2:00] THE HOOK (2 min)
  • Open with a story, question, or shocking stat
  • "I want to tell you about the day I realized..."
  • Establish your personal connection to {topic}

[2:00-5:00] THE PROBLEM (3 min)
  • What's broken? What does the world get wrong?
  • Make the audience feel the tension
  • "Here's what most people don't understand about {topic}..."

[5:00-9:00] THE IDEA WORTH SPREADING (4 min)
  • Your core insight — say it in one sentence
  • Explain the mechanism / how it works
  • Use an analogy to make it tangible

[9:00-13:00] THE EVIDENCE (4 min)
  • 3 stories or data points that prove your idea
  • Personal experience + external research + example
  • Show transformation: before → after

[13:00-16:00] THE IMPLICATIONS (3 min)
  • What changes if we accept this idea?
  • Broader societal / personal impact
  • Address the obvious objection

[16:00-18:00] THE CALL TO ACTION (2 min)
  • One specific thing the audience can do today
  • Return to opening story — full circle
  • Memorable closing line they'll quote

SPEAKER NOTES:
  • Memorize opening 30 seconds and closing 30 seconds
  • No reading from slides — max 3 words per slide
  • Pause after key points (silence = emphasis)
  • Practice out loud 10+ times
""")
PYEOF
}

cmd_academic() {
    local topic="${1:-Topic}"; local slides="${2:-20}"
    PPT_TOPIC="$topic" PPT_SLIDES="${slides:-8}" PPT_COUNT="${count:-5}" PPT_PRODUCT="${product:-}" PPT_AUDIENCE="${audience:-}" python3 << 'PYEOF'
import os; topic = os.environ.get("PPT_TOPIC",""); n = int(os.environ.get("PPT_SLIDES","8"))
print(f"""
=== Academic Presentation: {topic} ===
Format: {n} slides | Style: Research/Conference

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 1. Title + Authors + Institution + Date

 2. Outline / Agenda
    • What you'll cover today

 3-4. Introduction & Background
    • Research context
    • Why this matters
    • Research gap

 5-6. Literature Review
    • Key prior work (3-5 papers)
    • What's been done, what's missing

 7-8. Research Questions / Hypotheses
    • RQ1, RQ2, RQ3 clearly stated
    • Theoretical framework

 9-11. Methodology
    • Study design / experimental setup
    • Data collection
    • Analysis approach

 12-15. Results
    • Key findings (one finding per slide)
    • Figures/tables with clear labels
    • Statistical significance

 16-17. Discussion
    • Interpretation of results
    • Connection to prior literature
    • Unexpected findings

 18. Limitations
    • Study constraints
    • Threats to validity

 19. Conclusions & Contributions
    • Direct answers to RQs
    • Theoretical/practical implications

 20. Future Work & References
    • Next steps
    • Key citations (APA/IEEE format)

SLIDE DESIGN: Use sans-serif font (14pt+), high contrast, no clip art
CITATION NOTE: Every factual claim needs a citation
""")
PYEOF
}

cmd_pitch() {
    local product="${1:-Product}"; local audience="${2:-investors}"
    PPT_TOPIC="$topic" PPT_SLIDES="${slides:-8}" PPT_COUNT="${count:-5}" PPT_PRODUCT="${product:-}" PPT_AUDIENCE="${audience:-}" python3 << 'PYEOF'
import os; product = os.environ.get("PPT_PRODUCT",""); audience = os.environ.get("PPT_AUDIENCE","")
print(f"""
=== Pitch Deck: {product} ===
Audience: {audience.title()} | Format: 10-12 slides (Guy Kawasaki method)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 1. TITLE
    {product} — [One-line value proposition]

 2. PROBLEM
    • Who suffers and how badly?
    • Market pain — use a story or stat

 3. SOLUTION
    • What is {product}?
    • How does it solve the problem?
    • Demo screenshot or mockup

 4. BUSINESS MODEL
    • How do you make money?
    • Pricing tiers / revenue streams
    • Unit economics (CAC, LTV)

 5. MARKET SIZE
    • TAM → SAM → SOM
    • Bottom-up calculation preferred
    • Growth rate of the market

 6. TRACTION
    • Users, revenue, growth rate
    • Key partnerships or LOIs
    • Testimonials from real customers

 7. COMPETITION
    • 2x2 matrix (your axes, your corner)
    • Why can't they copy you?
    • Your sustainable moat

 8. TEAM
    • Why YOU are uniquely qualified
    • Relevant experience + domain expertise
    • Key advisors

 9. FINANCIALS
    • 3-year projections (conservative)
    • Key assumptions
    • Path to profitability

10. THE ASK
    • Raise amount and valuation
    • Use of funds (3 buckets max)
    • Milestones this gets you to

TIPS for {audience}:
{'  • Lead with traction if you have it' if audience == 'investors' else '  • Focus on their specific use case'}
  • Send deck as PDF, present live version with more slides
  • Prepare for: "Who else is doing this?" and "Why now?"
""")
PYEOF
}

cmd_slides() {
    local topic="${1:-Topic}"; local count="${2:-10}"
    PPT_TOPIC="$topic" PPT_SLIDES="${slides:-8}" PPT_COUNT="${count:-5}" PPT_PRODUCT="${product:-}" PPT_AUDIENCE="${audience:-}" python3 << 'PYEOF'
import os; topic = os.environ.get("PPT_TOPIC",""); n = int(os.environ.get("PPT_COUNT","5"))
print(f"\n=== Slide-by-Slide Outline: {topic} ({n} slides) ===\n")
templates = [
    "Title + hook statement",
    "Problem / current situation",
    "Why this matters (stakes)",
    "Proposed solution / main idea",
    "How it works (diagram/visual)",
    "Evidence / proof / data",
    "Case study or example",
    "Comparison / before & after",
    "Implementation / next steps",
    "Call to action + contact",
    "FAQ / anticipated questions",
    "Appendix / backup data",
]
for i in range(1, n+1):
    tpl = templates[i-1] if i <= len(templates) else f"Supporting point {i-len(templates)}"
    print(f"  Slide {i:2}: {tpl}")
print(f"\n💡 Rule of thumb: 1 idea per slide, max 30 seconds per slide in fast pitches")
PYEOF
}

cmd_timer() {
    local slides="${1:-10}"; local minutes="${2:-20}"
    PPT_TOPIC="$topic" PPT_SLIDES="${slides:-8}" PPT_COUNT="${count:-5}" PPT_PRODUCT="${product:-}" PPT_AUDIENCE="${audience:-}" python3 << 'PYEOF'
slides = int("$slides"); minutes = int("$minutes")
secs_total = minutes * 60
secs_per = secs_total // slides
print(f"\n=== Time Allocation: {slides} slides in {minutes} minutes ===\n")
print(f"  Total time:    {minutes} min ({secs_total} sec)")
print(f"  Per slide avg: {secs_per} sec ({secs_per//60}m {secs_per%60}s)")
print(f"\n  Recommended distribution:")
print(f"  {'Section':<25} {'Slides':>6}  {'Time':>8}")
print(f"  {'─'*25} {'─'*6}  {'─'*8}")
intro = max(1, slides//10)
main = slides - intro*3
outro = max(1, slides//10)
print(f"  {'Opening/Hook':<25} {intro:>6}  {intro*secs_per//60:>5}m {intro*secs_per%60:>2}s")
print(f"  {'Main content':<25} {main:>6}  {main*secs_per//60:>5}m {main*secs_per%60:>2}s")
print(f"  {'Evidence/Examples':<25} {intro:>6}  {intro*secs_per//60:>5}m {intro*secs_per%60:>2}s")
print(f"  {'Close/CTA':<25} {outro:>6}  {outro*secs_per//60:>5}m {outro*secs_per%60:>2}s")
print(f"\n  ⏱ Buffer tip: build in 2-3 min for Q&A start delay")
PYEOF
}

case "$CMD" in
    business)  cmd_business "$@" ;;
    ted)       cmd_ted "$@" ;;
    academic)  cmd_academic "$@" ;;
    pitch)     cmd_pitch "$@" ;;
    slides)    cmd_slides "$@" ;;
    timer)     cmd_timer "$@" ;;
    help|--help|-h) show_help ;;
    *) echo "Unknown: $CMD"; show_help; exit 1 ;;
esac
