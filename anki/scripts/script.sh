#!/bin/bash
# Anki - Spaced Repetition Learning System Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              ANKI REFERENCE                                 ║
║          Spaced Repetition for Effective Learning           ║
╚══════════════════════════════════════════════════════════════╝

Anki is a free, open-source flashcard program using spaced repetition
(SRS) — showing cards at optimal intervals to maximize retention
with minimum study time.

THE SCIENCE:
  Ebbinghaus Forgetting Curve:
    Without review, you forget ~80% within a week.
    Spaced repetition fights this by reviewing at the moment
    you're about to forget.

    Day 1:  ████████████████████ 100% retention
    Day 2:  █████████████░░░░░░░ 65%  ← review here
    Day 4:  ████████████████░░░░ 80%  ← review again
    Day 10: ████████████████░░░░ 80%  ← review again
    Day 25: ████████████████░░░░ 80%  ← the interval grows

  SM-2 Algorithm (SuperMemo):
    Anki uses a modified SM-2 algorithm.
    Each card has an "ease factor" that adjusts based on performance.

    Response → Next Interval:
      Again  → 1 minute (relearn)
      Hard   → current × 1.2
      Good   → current × ease_factor (default 2.5)
      Easy   → current × ease_factor × 1.3

KEY CONCEPTS:
  Deck         Collection of cards (e.g., "Japanese N3")
  Card         A question-answer pair
  Note         Source data that generates card(s)
  Note Type    Template defining fields and card layout
  Field        A piece of data (Front, Back, Extra, Audio)
  Template     HTML/CSS defining how fields render on cards
  Interval     Days until next review
  Ease         Multiplier for interval growth (default 250%)
  Lapses       Times you forgot a mature card
  Due          Cards scheduled for today
  New          Cards not yet studied
  Learning     Cards in initial learning phase
  Young        Cards with interval < 21 days
  Mature       Cards with interval ≥ 21 days

PLATFORMS:
  Anki Desktop    Free (Windows, Mac, Linux)
  AnkiWeb         Free (browser-based sync)
  AnkiMobile      $25 (iOS) — supports the developer
  AnkiDroid       Free (Android)
EOF
}

cmd_cards() {
cat << 'EOF'
CARD DESIGN BEST PRACTICES
=============================

RULE 1: MINIMUM INFORMATION PRINCIPLE
  Bad:  "List all the planets in the solar system"
  Good: "What is the 3rd planet from the Sun?" → Earth
  Good: "Which planet is known as the Red Planet?" → Mars

  Break complex info into atomic facts.

RULE 2: ONE FACT PER CARD
  Bad:  "What are the capitals of France, Germany, and Italy?"
  Good: Three separate cards, one for each.

RULE 3: USE CLOZE DELETIONS
  "The {{c1::mitochondria}} is the powerhouse of the cell"
  Shows: "The [...] is the powerhouse of the cell"

  Multiple clozes (separate cards):
  "{{c1::Python}} was created by {{c2::Guido van Rossum}} in {{c3::1991}}"
  Creates 3 cards, each hiding one fact.

RULE 4: ADD CONTEXT
  Bad:  "What is 東京?" → "Tokyo"
  Good: "What is 東京 (Japanese city name)?" → "Tokyo (東京/とうきょう)"

RULE 5: USE IMAGES
  Visual memory is stronger than text memory.
  Add diagrams, screenshots, photos where relevant.
  <img src="anatomy_heart.png">

RULE 6: ADD PERSONAL CONNECTIONS
  "What is the capital of Peru?" → "Lima"
  Extra field: "Lima beans! I ate them at that restaurant in Lima."
  Personal associations dramatically improve retention.

EFFECTIVE NOTE TYPES:

  Basic:        Front → Back
  Basic + Reverse: Front ↔ Back (creates 2 cards)
  Cloze:        Fill in the blank(s)
  Image Occlusion: Hide parts of an image

  Custom for languages:
    Fields: Word, Reading, Meaning, Example, Audio
    Card 1: Meaning → Word (production)
    Card 2: Word → Meaning (recognition)
    Card 3: Audio → Meaning (listening)
EOF
}

cmd_settings() {
cat << 'EOF'
OPTIMAL DECK SETTINGS
=======================

NEW CARDS:
  Learning steps:      1m 10m         (2-step default)
  Recommended:         1m 10m 1d      (add a 1-day step)
  Aggressive:          1m 5m 15m 1d   (more reps on day 1)
  Graduating interval: 1 day          (after all steps)
  Easy interval:       4 days
  New cards/day:       20             (adjust to your capacity)

  Starting ease: 250% (default, don't change unless advanced)
  Insertion order: Sequential (for ordered content like textbooks)

REVIEWS:
  Maximum reviews/day: 9999           (don't limit artificially)
  Easy bonus:          130%
  Interval modifier:   100%           (adjust based on retention)
  Maximum interval:    36500 (100 years, effectively unlimited)

  Hard interval:       120%
  New interval:        0% (when you forget, start fresh)
  Or:                  20% (keep some progress)

LAPSES:
  Relearning steps:    10m
  Minimum interval:    1 day
  Leech threshold:     8 lapses
  Leech action:        Tag Only (don't suspend!)

  When a card becomes a leech:
  1. Review and rewrite the card
  2. Add more context or mnemonics
  3. Break into simpler sub-cards
  4. Add images or audio

RETENTION TARGETING:
  Use the stats to find your retention rate.
  Target: 85-90% for mature cards.

  If retention < 85%: decrease interval modifier
    Formula: log(desired) / log(current)
    Example: current 80%, target 85%
    Modifier: log(0.85) / log(0.80) = 0.73 → set to 73%

  If retention > 95%: increase interval modifier
    You're reviewing too often, wasting time.

FSRS (Free Spaced Repetition Scheduler):
  Anki 23.10+ includes FSRS as an alternative to SM-2.
  - Machine learning based
  - Better calibrated intervals
  - Adapts to your personal forgetting curve
  Enable: Deck Options → Advanced → FSRS
  Requires ~1000 reviews for good calibration.
EOF
}

cmd_workflow() {
cat << 'EOF'
STUDY WORKFLOW
================

DAILY ROUTINE:
  1. Review due cards first (most important!)
  2. Study new cards after reviews
  3. Never skip a day if possible (snowball effect)

  Time estimation:
    ~30 seconds per review card
    ~60 seconds per new card
    20 new cards/day = ~15 min new + ~20 min reviews
    Total: ~35-45 min/day (grows over first 3 months, then stabilizes)

KEYBOARD SHORTCUTS:
  Space    Show answer / mark Good
  1        Again
  2        Hard
  3        Good
  4        Easy
  E        Edit current card
  @        Suspend card
  !        Mark card (flag for later)
  Ctrl+Z   Undo
  B        Bury card (skip today)
  F        Add flag (6 colors)

DEALING WITH BACKLOGS:
  If you skipped days and have 500+ reviews:

  Strategy 1: Power through (if < 300)
    Just do them all. Will take 2-3 hours but fixes the problem.

  Strategy 2: Custom study (if 300-1000)
    Custom Study → Increase today's review limit
    Do 100-150/day over several days

  Strategy 3: Reset (if > 1000 or abandoned for months)
    Options:
    a) Reschedule cards: Browse → select all → Reschedule
    b) Export deck → delete → reimport (resets scheduling)
    c) Accept some loss and reduce scope

WORKFLOW FOR LANGUAGE LEARNING:
  1. Immerse first (watch/read/listen)
  2. Mine sentences from immersion material
  3. Create cards from mined sentences
  4. Review daily
  5. Repeat

  Sentence mining tools:
    - subs2srs (subtitle to Anki)
    - Yomichan/Yomitan (browser popup dictionary → Anki)
    - Migaku (video player + Anki integration)
    - mpvacious (mpv + Anki mining)

WORKFLOW FOR MEDICAL/EXAM PREP:
  1. Use pre-made decks as base (AnKing for medical)
  2. Unsuspend cards as you cover topics in class
  3. Add personal notes to "Extra" field
  4. Tag cards by lecture/chapter
  5. Use filtered decks for exam cramming
EOF
}

cmd_addons() {
cat << 'EOF'
ESSENTIAL ADD-ONS
===================

Install: Tools → Add-ons → Get Add-ons → paste code

TOP ADD-ONS:

  Review Heatmap (1771074083)
    GitHub-style contribution heatmap of your reviews.
    Great for motivation and streak tracking.

  Image Occlusion Enhanced (1374772155)
    Hide parts of an image to create cards.
    Essential for anatomy, geography, diagrams.

  AnkiConnect (2055492159)
    HTTP API for external tools to interact with Anki.
    Required for: Yomitan, mpvacious, other mining tools.

  FSRS4Anki Helper (759844606)
    Tools for the FSRS scheduler.
    Optimize parameters, compute stats.

  Advanced Browser (874215009)
    More columns and filters in the card browser.

  Batch Editing (291119185)
    Edit multiple cards at once.
    Add tags, change fields in bulk.

  Speed Focus Mode (1046608507)
    Auto-show answer after N seconds.
    Forces faster reviews.

  True Retention (613684242)
    More accurate retention statistics.

  Edit Field During Review (1020366288)
    Fix typos without leaving review mode.

POPULAR SHARED DECKS:
  Languages:
    Core 2K/6K/10K (Japanese vocabulary)
    HSK 1-6 (Chinese)
    Frequency lists (any language)

  Medical:
    AnKing Step 1/Step 2 (~40,000 cards)
    Physeo
    Pathoma

  Programming:
    LeetCode patterns
    System design concepts
    Language syntax cards

  Find decks: AnkiWeb → Shared Decks
  URL: https://ankiweb.net/shared/decks/
EOF
}

cmd_advanced() {
cat << 'EOF'
ADVANCED FEATURES
===================

CUSTOM NOTE TYPES (HTML/CSS):

  Front Template:
    <div class="front">
      {{Front}}
      {{#Hint}}<div class="hint">Hint: {{Hint}}</div>{{/Hint}}
    </div>

  Back Template:
    {{FrontSide}}
    <hr>
    <div class="back">
      {{Back}}
      {{#Extra}}<div class="extra">{{Extra}}</div>{{/Extra}}
    </div>

  Styling (CSS):
    .card {
      font-family: "Noto Sans", sans-serif;
      font-size: 20px;
      text-align: center;
      background: #1a1a2e;
      color: #e0e0e0;
    }
    .hint { color: #888; font-size: 14px; margin-top: 10px; }
    .extra { color: #aaa; font-size: 14px; border-top: 1px solid #333; }

FILTERED DECKS:
  Create temporary study sessions:

  "is:due prop:ivl>21"          → Review only mature cards
  "tag:chapter-5 is:new"        → New cards from chapter 5
  "rated:1:1"                   → Cards failed today
  "prop:lapses>3"               → Leech candidates
  "added:7"                     → Cards added in last 7 days
  "deck:Japanese -is:suspended" → Active cards in Japanese deck

ANKICONNECT API (for automation):
  # Add a card via API
  curl -X POST http://localhost:8765 -d '{
    "action": "addNote",
    "version": 6,
    "params": {
      "note": {
        "deckName": "Default",
        "modelName": "Basic",
        "fields": {"Front": "Question", "Back": "Answer"},
        "tags": ["auto-generated"]
      }
    }
  }'

  # Get due count
  curl -X POST http://localhost:8765 -d '{
    "action": "getDeckStats",
    "version": 6,
    "params": {"decks": ["Default"]}
  }'

BACKUP & SYNC:
  Anki auto-saves to: ~/Documents/Anki2/<profile>/
  AnkiWeb sync: free, encrypted, cross-device
  Manual backup: File → Export → Anki Collection Package (.colpkg)

  Conflict resolution:
  - If both desktop and mobile changed → manual resolve
  - Use "Upload" or "Download" to force one direction
  - Always sync before AND after studying

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Anki - Spaced Repetition Learning System Reference

Commands:
  intro       SRS science, SM-2 algorithm, key concepts
  cards       Card design principles and note types
  settings    Optimal deck settings and FSRS
  workflow    Daily routine, shortcuts, backlog recovery
  addons      Essential add-ons and shared decks
  advanced    Custom templates, filtered decks, API

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  cards)    cmd_cards ;;
  settings) cmd_settings ;;
  workflow) cmd_workflow ;;
  addons)   cmd_addons ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac
