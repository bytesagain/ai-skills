#!/usr/bin/env bash
# slide-maker: Presentation/slide generator
# Usage: bash slides.sh <command> [topic]

set -euo pipefail

COMMAND="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

case "$COMMAND" in
  outline)
    python3 << 'PYEOF'
inp = """{}"""
if not inp.strip():
    inp = "AI in Education"
print("=" * 60)
print("  PRESENTATION OUTLINE")
print("=" * 60)
print()
topic = inp.strip()
sections = [
    ("Title Slide", "Main title, subtitle, presenter name, date"),
    ("Agenda", "Overview of topics to be covered"),
    ("Background / Problem", "Context and current challenges"),
    ("Key Insights / Data", "Core findings with supporting data"),
    ("Solution / Approach", "Proposed solution or methodology"),
    ("Case Study / Example", "Real-world application or demo"),
    ("Results / Impact", "Outcomes and measurable results"),
    ("Next Steps", "Action items and timeline"),
    ("Q&A", "Questions and discussion"),
    ("Thank You", "Contact info and resources")
]
print("Topic: {}".format(topic))
print()
for i, (title, desc) in enumerate(sections, 1):
    print("  Slide {}: {}".format(i, title))
    print("    {}".format(desc))
    print()
print("Total slides: {}".format(len(sections)))
print("Est. duration: {}-{} minutes".format(len(sections) * 2, len(sections) * 3))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  slides)
    python3 << 'PYEOF'
inp = """{}"""
if not inp.strip():
    inp = "AI in Education"
topic = inp.strip()
print("=" * 60)
print("  FULL SLIDE DECK (Markdown)")
print("=" * 60)
print()
slides = [
    "---\n# {topic}\n\n**Transforming the Future**\n\nPresenter: [Name]\nDate: [Date]\n",
    "---\n## Agenda\n\n1. Background & Challenge\n2. Key Insights\n3. Our Approach\n4. Results\n5. Next Steps\n",
    "---\n## The Challenge\n\n- Current state of {topic}\n- Pain points and gaps\n- Why now? Market timing\n\n> \"The best time to act was yesterday. The second best is now.\"\n",
    "---\n## Key Data & Insights\n\n| Metric | Before | After | Change |\n|--------|--------|-------|--------|\n| Efficiency | 45% | 82% | +37% |\n| Cost | $100K | $65K | -35% |\n| Satisfaction | 3.2 | 4.7 | +47% |\n",
    "---\n## Our Solution\n\n### Three Pillars\n\n1. **Innovation** - Cutting-edge approach\n2. **Execution** - Proven methodology\n3. **Scale** - Built for growth\n",
    "---\n## Case Study\n\n### Real-World Application\n\n- Client: [Company Name]\n- Challenge: [Specific problem]\n- Solution: Applied {topic} framework\n- Result: 3x improvement in 6 months\n",
    "---\n## Impact & Results\n\n- **82%** efficiency improvement\n- **$35K** annual cost savings\n- **4.7/5** user satisfaction\n- **3x** faster delivery\n",
    "---\n## Next Steps\n\n- [ ] Phase 1: Research & Planning (Week 1-2)\n- [ ] Phase 2: Implementation (Week 3-6)\n- [ ] Phase 3: Testing & Launch (Week 7-8)\n- [ ] Phase 4: Review & Optimize (Week 9+)\n",
    "---\n## Q&A\n\n### Questions?\n\nLet's discuss how {topic} can work for you.\n",
    "---\n## Thank You\n\n- Email: presenter@company.com\n- Website: company.com\n- LinkedIn: /in/presenter\n"
]
for slide in slides:
    print(slide.replace("{topic}", topic))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  speaker)
    python3 << 'PYEOF'
inp = """{}"""
if not inp.strip():
    inp = "AI in Education"
topic = inp.strip()
print("=" * 60)
print("  SPEAKER NOTES")
print("=" * 60)
print()
notes = [
    ("Opening (2 min)", "Good morning everyone. Today I am excited to talk about {}. This topic is critical because it impacts all of us.".format(topic)),
    ("Problem Statement (3 min)", "Let me start with the challenge we face. The current approach to {} has several limitations that we need to address.".format(topic)),
    ("Key Insights (4 min)", "Our research shows three important findings. First... Second... Third... These data points paint a clear picture."),
    ("Solution (4 min)", "Based on these insights, we propose a three-pillar approach. Let me walk you through each one in detail."),
    ("Case Study (3 min)", "To see this in action, let me share a real example. This company implemented our approach and saw remarkable results."),
    ("Results (2 min)", "The numbers speak for themselves. We achieved significant improvements across all key metrics."),
    ("Next Steps (2 min)", "So what do we do next? I have a clear four-phase plan that we can start implementing immediately."),
    ("Closing (1 min)", "Thank you for your time. I look forward to your questions and to working together on this exciting journey.")
]
total_min = 0
for title, script in notes:
    mins = int(title.split("(")[1].split(" ")[0])
    total_min += mins
    print("[{}]".format(title))
    print(script)
    print()
    print("  TIP: Pause here for eye contact. Breathe.")
    print()
print("Total estimated time: {} minutes".format(total_min))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  pitch)
    python3 << 'PYEOF'
inp = """{}"""
if not inp.strip():
    inp = "EdTech Startup"
topic = inp.strip()
print("=" * 60)
print("  PITCH DECK")
print("=" * 60)
print()
pages = [
    ("Cover", "# {}\n\nSeed Round | $2M\n[Logo]"),
    ("Problem", "## The Problem\n\n- 70% of users face this issue\n- Current solutions are expensive\n- Market gap of $X billion"),
    ("Solution", "## Our Solution\n\n- One-line description\n- Key differentiator\n- Screenshot / demo"),
    ("Market", "## Market Opportunity\n\n- TAM: $50B\n- SAM: $5B\n- SOM: $500M (Year 3)"),
    ("Product", "## Product\n\n- Core features\n- User experience\n- Technology stack"),
    ("Traction", "## Traction\n\n- 10K users (growing 20% MoM)\n- $50K MRR\n- 95% retention rate"),
    ("Business Model", "## Business Model\n\n- SaaS subscription\n- Freemium + Premium\n- Enterprise tier"),
    ("Competition", "## Competitive Landscape\n\n| Feature | Us | Comp A | Comp B |\n|---------|-----|--------|--------|\n| Price | Low | High | Med |"),
    ("Team", "## Team\n\n- CEO: 10yr industry exp\n- CTO: Ex-FAANG\n- COO: MBA, operations"),
    ("Financials", "## Financial Projections\n\n| Year | Revenue | Users |\n|------|---------|-------|\n| Y1 | $600K | 50K |\n| Y2 | $3M | 200K |\n| Y3 | $10M | 500K |"),
    ("Ask", "## The Ask\n\n- Raising: $2M Seed\n- Use: 50% Product, 30% Growth, 20% Ops\n- Timeline: 18 months to Series A"),
    ("Contact", "## Let's Talk\n\n- Email: founder@startup.com\n- Deck: startup.com/deck")
]
for title, content in pages:
    print("---")
    print(content.replace("{}", topic))
    print()
print("Total: {} slides (standard pitch format)".format(len(pages)))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  training)
    python3 << 'PYEOF'
inp = """{}"""
if not inp.strip():
    inp = "Python Programming Basics"
topic = inp.strip()
print("=" * 60)
print("  TRAINING SLIDES")
print("=" * 60)
print()
modules = [
    ("Welcome", "# Training: {}\n\nObjective: By the end, you will understand the fundamentals.\nDuration: 2 hours\nFormat: Lecture + Hands-on".format(topic)),
    ("Learning Goals", "## What You Will Learn\n\n1. Core concepts\n2. Practical applications\n3. Best practices\n4. Common pitfalls"),
    ("Module 1", "## Module 1: Introduction\n\n- What is {}?\n- Why does it matter?\n- Real-world examples".format(topic)),
    ("Exercise 1", "## Hands-On Exercise 1\n\nTask: Try the basic example\nTime: 10 minutes\nExpected outcome: Working demo"),
    ("Module 2", "## Module 2: Deep Dive\n\n- Advanced concepts\n- Technical details\n- Performance tips"),
    ("Exercise 2", "## Hands-On Exercise 2\n\nTask: Build a mini-project\nTime: 15 minutes\nBonus: Add extra features"),
    ("Best Practices", "## Best Practices & Tips\n\n- Do: Follow conventions\n- Do: Write tests\n- Don't: Skip documentation\n- Don't: Premature optimization"),
    ("Summary", "## Key Takeaways\n\n1. Start with fundamentals\n2. Practice regularly\n3. Learn from mistakes\n4. Keep building"),
    ("Resources", "## Further Resources\n\n- Documentation: [link]\n- Tutorials: [link]\n- Community: [link]")
]
for title, content in modules:
    print("---")
    print(content)
    print()
print("Total: {} slides | Est. duration: 2 hours".format(len(modules)))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  report)
    python3 << 'PYEOF'
inp = """{}"""
if not inp.strip():
    inp = "Q3 Business Review"
topic = inp.strip()
print("=" * 60)
print("  REPORT SLIDES")
print("=" * 60)
print()
pages = [
    "---\n# {}\n\nPeriod: [Date Range]\nPresenter: [Name]\nDepartment: [Team]".format(topic),
    "---\n## Executive Summary\n\n- Overall status: On Track\n- Key achievement: [Highlight]\n- Challenge: [Issue]\n- Next priority: [Focus]",
    "---\n## KPI Dashboard\n\n| KPI | Target | Actual | Status |\n|-----|--------|--------|--------|\n| Revenue | $1M | $1.1M | Above |\n| Users | 10K | 9.5K | Near |\n| NPS | 50 | 55 | Above |",
    "---\n## Achievements\n\n1. Launched feature X (+25% engagement)\n2. Reduced costs by 15%\n3. Hired 3 key roles\n4. Reached milestone ahead of schedule",
    "---\n## Challenges & Risks\n\n- Risk 1: [Description] - Mitigation: [Plan]\n- Risk 2: [Description] - Mitigation: [Plan]\n- Blocker: [What needs escalation]",
    "---\n## Next Period Plan\n\n- [ ] Priority 1: [Task]\n- [ ] Priority 2: [Task]\n- [ ] Priority 3: [Task]\n\nDeadline: [Date]"
]
for page in pages:
    print(page)
    print()
print("Total: {} slides".format(len(pages)))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  design)
    python3 << 'PYEOF'
print("=" * 60)
print("  SLIDE DESIGN GUIDE")
print("=" * 60)
print()
print("[COLOR SCHEMES]")
schemes = [
    ("Professional Blue", "#1a365d, #2b6cb0, #bee3f8, #ffffff"),
    ("Modern Dark", "#1a1a2e, #16213e, #0f3460, #e94560"),
    ("Nature Green", "#1b4332, #2d6a4f, #95d5b2, #f0fdf4"),
    ("Warm Sunset", "#7f1d1d, #dc2626, #fbbf24, #fffbeb"),
    ("Clean Minimal", "#111827, #6b7280, #e5e7eb, #ffffff"),
]
for name, colors in schemes:
    print("  {} : {}".format(name, colors))
print()
print("[TYPOGRAPHY]")
print("  Title: Bold, 36-44pt")
print("  Subtitle: Regular, 24-28pt")
print("  Body: Regular, 18-22pt")
print("  Caption: Light, 14-16pt")
print()
print("  Recommended fonts:")
print("    - Inter / Source Sans Pro (body)")
print("    - Montserrat / Poppins (headings)")
print("    - Noto Sans SC (Chinese)")
print()
print("[LAYOUT RULES]")
print("  - Max 6 bullet points per slide")
print("  - One idea per slide")
print("  - 60/40 or 50/50 split for text+image")
print("  - Consistent margins (min 5% padding)")
print("  - Left-align text (avoid center for body)")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  help|*)
    cat << 'HELPEOF'
========================================
  Slide Maker - Presentation Generator
========================================

Commands:
  outline    Presentation outline
  slides     Full slide deck (Markdown)
  speaker    Speaker notes with timing
  pitch      Pitch deck (fundraising)
  training   Training slides
  report     Report/review slides
  design     Design recommendations

Usage:
  bash slides.sh <command> <topic>

Output: Markdown with --- page separators
Compatible with: Marp, Slidev, Reveal.js

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
    ;;
esac
