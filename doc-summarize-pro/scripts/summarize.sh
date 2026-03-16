#!/usr/bin/env bash
# summarize-pro: Enhanced document summarizer
# Usage: bash summarize.sh <command> [args...]

set -euo pipefail

COMMAND="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

case "$COMMAND" in
  summarize)
    python3 << 'PYEOF'
import sys, textwrap
inp = """{}"""
if not inp.strip():
    inp = "No input provided. Please provide text to summarize."
print("=" * 60)
print("  DOCUMENT SUMMARY")
print("=" * 60)
print()
print("Input length: {} characters".format(len(inp)))
print("-" * 40)
print(textwrap.fill(inp[:500], width=70))
if len(inp) > 500:
    print("... [truncated]")
print()
print("SUMMARY:")
print("-" * 40)
sentences = [s.strip() for s in inp.replace("!", ".").replace("?", ".").split(".") if s.strip()]
total = len(sentences)
keep = max(1, total // 3)
for s in sentences[:keep]:
    print(textwrap.fill(s + ".", width=70))
print()
print("Word count: {} -> ~{}".format(len(inp.split()), len(" ".join(sentences[:keep]).split())))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  bullet)
    python3 << 'PYEOF'
import sys
inp = """{}"""
if not inp.strip():
    inp = "No input provided."
print("=" * 60)
print("  KEY POINTS EXTRACTION")
print("=" * 60)
print()
sentences = [s.strip() for s in inp.replace("!", ".").replace("?", ".").split(".") if len(s.strip()) > 5]
for i, s in enumerate(sentences[:10], 1):
    print("  {}. {}".format(i, s.strip()))
print()
print("Total points extracted: {}".format(min(len(sentences), 10)))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  executive)
    python3 << 'PYEOF'
import textwrap
inp = """{}"""
if not inp.strip():
    inp = "No input provided."
print("=" * 60)
print("  EXECUTIVE SUMMARY")
print("=" * 60)
print()
sentences = [s.strip() for s in inp.replace("!", ".").replace("?", ".").split(".") if s.strip()]
total = len(sentences)
print("[CONCLUSION]")
if sentences:
    print(textwrap.fill(sentences[-1] + ".", width=70))
print()
print("[KEY FINDINGS]")
for s in sentences[:3]:
    print("  - {}".format(s))
print()
print("[RECOMMENDATION]")
print("  Based on the above findings, further review is recommended.")
print()
print("Document stats: {} words | {} sentences".format(len(inp.split()), total))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  chapter)
    python3 << 'PYEOF'
import textwrap
inp = """{}"""
if not inp.strip():
    inp = "No input provided."
print("=" * 60)
print("  CHAPTER BREAKDOWN")
print("=" * 60)
print()
paragraphs = [p.strip() for p in inp.split("\n\n") if p.strip()]
if len(paragraphs) <= 1:
    paragraphs = [p.strip() for p in inp.split("\n") if p.strip()]
for i, p in enumerate(paragraphs[:8], 1):
    print("Chapter {}: ".format(i))
    summary = p[:120] + ("..." if len(p) > 120 else "")
    print("  {}".format(summary))
    print()
print("Total chapters identified: {}".format(min(len(paragraphs), 8)))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  compare)
    python3 << 'PYEOF'
inp = """{}"""
if not inp.strip():
    inp = "Document A: sample\n---\nDocument B: sample"
print("=" * 60)
print("  MULTI-DOCUMENT COMPARISON")
print("=" * 60)
print()
docs = inp.split("---")
if len(docs) < 2:
    docs = inp.split("\n\n")
for i, doc in enumerate(docs[:5], 1):
    doc = doc.strip()
    print("Document {}:".format(i))
    print("  Length: {} words".format(len(doc.split())))
    sentences = [s.strip() for s in doc.split(".") if s.strip()]
    print("  Core point: {}".format(sentences[0] if sentences else "N/A"))
    print()
print("[COMPARISON ANALYSIS]")
print("  Documents analyzed: {}".format(min(len(docs), 5)))
print("  Common themes: Review content for shared topics")
print("  Key differences: Compare specific claims and data points")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  translate-summary)
    python3 << 'PYEOF'
inp = """{}"""
if not inp.strip():
    inp = "No input provided."
print("=" * 60)
print("  TRANSLATE + SUMMARIZE")
print("=" * 60)
print()
print("[ORIGINAL] ({} characters)".format(len(inp)))
print(inp[:200])
if len(inp) > 200:
    print("...")
print()
print("[SUMMARY]")
sentences = [s.strip() for s in inp.replace("!", ".").replace("?", ".").split(".") if s.strip()]
for s in sentences[:3]:
    print("  - {}".format(s))
print()
print("Note: For full translation, pair with a translation tool.")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  action)
    python3 << 'PYEOF'
import re
inp = """{}"""
if not inp.strip():
    inp = "No input provided."
print("=" * 60)
print("  ACTION ITEMS EXTRACTION")
print("=" * 60)
print()
keywords = ["need", "should", "must", "will", "todo", "action", "follow up",
            "deadline", "assign", "complete", "deliver", "review", "approve",
            "schedule", "prepare", "submit", "finalize", "implement"]
sentences = [s.strip() for s in inp.replace("!", ".").replace("?", ".").split(".") if s.strip()]
actions = []
for s in sentences:
    lower = s.lower()
    if any(k in lower for k in keywords):
        actions.append(s)
if not actions:
    actions = sentences[:3]
print("Action Items Found: {}".format(len(actions)))
print("-" * 40)
for i, a in enumerate(actions[:10], 1):
    print("  [ ] {}. {}".format(i, a))
print()
print("Priority: Review and assign owners to each item.")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  timeline)
    python3 << 'PYEOF'
import re
inp = """{}"""
if not inp.strip():
    inp = "No input provided."
print("=" * 60)
print("  TIMELINE EXTRACTION")
print("=" * 60)
print()
date_pattern = re.compile(r'\d{4}[-/]\d{1,2}[-/]\d{1,2}|\b(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\w*\s+\d{1,2}')
sentences = inp.split(".")
events = []
for s in sentences:
    dates = date_pattern.findall(s)
    if dates:
        events.append((dates[0], s.strip()))
if events:
    for date, event in events[:15]:
        print("  [{}] {}".format(date, event[:80]))
else:
    print("  No dates detected. Showing sequential events:")
    lines = [l.strip() for l in inp.split("\n") if l.strip()]
    for i, l in enumerate(lines[:10], 1):
        print("  [Event {}] {}".format(i, l[:80]))
print()
print("Total events: {}".format(len(events) if events else min(len(inp.split("\n")), 10)))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  help|*)
    cat << 'HELPEOF'
========================================
  Summarize Pro - Enhanced Summarizer
========================================

Commands:
  summarize           Default summary
  bullet              Key points extraction
  executive           Executive summary
  chapter             Chapter breakdown
  compare             Multi-document comparison
  translate-summary   Translate + summarize
  action              Action items extraction
  timeline            Timeline extraction

Usage:
  bash summarize.sh <command> <text>

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
    ;;
esac
