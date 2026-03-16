#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Slides — terminal presentation tool (inspired by maaslalani/slides 11K+ stars)
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Slides — Markdown presentation generator
Commands:
  create <title>       Create presentation skeleton
  outline <topic>      Generate slide outline
  template <type>      Get template (pitch/tech/report/education)
  export <file>        Export slides to clean markdown
  count <file>         Count slides
  timing <file> <min>  Calculate time per slide
  info                 Version info
Powered by BytesAgain | bytesagain.com";;
create)
    title="${1:-My Presentation}"
    cat << EOF
---
title: $title
author: $(whoami)
date: $(date +%Y-%m-%d)
---

# $title

---

## Agenda

1. Introduction
2. Problem Statement
3. Solution
4. Demo
5. Q&A

---

## Introduction

Your opening content here.

---

## Problem

What problem are we solving?

---

## Solution

How we solve it.

---

## Demo

Live demonstration.

---

## Q&A

Thank you!

---
*Powered by BytesAgain*
EOF
;;
outline)
    topic="${1:-AI Tools}"
    cat << EOF
# $topic — Slide Outline

## Slide 1: Title
- $topic
- Presenter: $(whoami)
- Date: $(date +%Y-%m-%d)

## Slide 2: Why This Matters
- Key problem statement
- Market context
- Audience pain point

## Slide 3: Current State
- What exists today
- Limitations
- Gaps

## Slide 4: Our Approach
- Core idea
- Differentiation
- Key insight

## Slide 5: How It Works
- Architecture / Process
- Key components
- Flow diagram

## Slide 6: Results
- Metrics
- Before/After
- Impact

## Slide 7: Demo
- Live walkthrough

## Slide 8: Next Steps
- Roadmap
- Call to action

## Slide 9: Q&A
- Contact info
EOF
;;
template)
    type="${1:-pitch}"
    case "$type" in
        pitch) echo "# [Company Name]
---
## The Problem
- Pain point 1
- Pain point 2
---
## Market Size
- TAM: \$X billion
- Growth: X%/year
---
## Our Solution
- Feature 1
- Feature 2
---
## Traction
- Users: X
- Revenue: \$X
---
## Team
- CEO: Name
- CTO: Name
---
## Ask
- Raising: \$X
- Use of funds";;
        tech) echo "# Technical Deep Dive
---
## Architecture
- Component diagram
---
## Stack
- Frontend / Backend / DB
---
## Performance
- Benchmarks
---
## Security
- Measures taken
---
## Deployment
- CI/CD pipeline";;
        *) echo "Templates: pitch, tech, report, education";;
    esac;;
export)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: export <file>"; exit 1; }
    grep -v "^---$" "$f" 2>/dev/null;;
count)
    f="${1:-}"; [ -z "$f" ] && { echo "Usage: count <file>"; exit 1; }
    n=$(grep -c "^---$" "$f" 2>/dev/null || echo 0)
    echo "Slides: $((n/2 + 1))";;
timing)
    f="${1:-}"; min="${2:-15}"
    [ -z "$f" ] && { echo "Usage: timing <file> <minutes>"; exit 1; }
    n=$(grep -c "^---$" "$f" 2>/dev/null || echo 0)
    slides=$((n/2 + 1))
    per=$(echo "$min $slides" | awk '{printf "%.1f", $1/$2}')
    echo "Slides: $slides | Time: ${min}min | Per slide: ${per}min";;
info) echo "Slides v1.0.0"; echo "Inspired by: maaslalani/slides (11,000+ stars)"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
