#!/usr/bin/env bash
# tooltip — Tooltip UI Component Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Tooltip Overview ===

A tooltip is a small overlay that appears on hover or focus,
providing brief supplementary information about a UI element.

TYPES OF INFORMATIONAL OVERLAYS:

  Tooltip:
    Triggered by hover/focus, dismissed on leave/blur
    Text only (no interactive content)
    Describes or labels the trigger element
    Example: Icon button → "Delete item"

  Popover:
    Triggered by click, dismissed by click outside/close button
    Can contain interactive content (links, buttons, forms)
    Stays open until explicitly closed
    Example: "More info" button → settings panel

  Toggletip:
    Triggered by click (like popover), but text-only content
    Used when hover is unreliable (touch, keyboard-only)
    Example: Click "?" icon → explanation text

  Title attribute (native):
    HTML title="..." attribute
    Poor UX: slow delay, can't style, inconsistent, inaccessible
    ⚠️ Avoid for important information

WHEN TO USE TOOLTIPS:
  ✓ Label for icon-only buttons (accessibility essential)
  ✓ Clarify abbreviations or jargon
  ✓ Show full text for truncated content
  ✓ Keyboard shortcuts ("Ctrl+S")
  ✓ Additional context that's not essential

WHEN NOT TO USE:
  ✗ Essential information (user MUST see it)
  ✗ Interactive content (use popover instead)
  ✗ Long text (>1-2 sentences)
  ✗ Form validation messages (show inline)
  ✗ On touch-only devices without alternative
  ✗ Covering the trigger element itself
  ✗ On disabled elements without keyboard access

KEY PRINCIPLES:
  1. Supplementary, not essential (page works without them)
  2. Brief (1-2 short lines maximum)
  3. No interaction required to read
  4. Accessible to keyboard and screen readers
  5. Not the only way to convey information
EOF
}

cmd_anatomy() {
    cat << 'EOF'
=== Tooltip Anatomy ===

             ┌──────────────────────┐
             │   Tooltip content    │
             │   goes here          │
             └─────────┬────────────┘
                       ▼             ← Arrow (caret)
                 ┌──────────┐
                 │ Trigger  │        ← Trigger element
                 └──────────┘

COMPONENTS:

  Trigger Element:
    The UI element that activates the tooltip
    Examples: button, icon, link, abbreviation, truncated text
    Must be focusable (buttons, links) or made focusable (tabindex="0")

  Content:
    The text displayed in the tooltip overlay
    Text only — no links, buttons, or interactive elements
    1-2 lines maximum (≈80 characters)
    Plain language, sentence case

  Arrow (Caret / Beak):
    Visual connector pointing from tooltip to trigger
    Shows relationship between tooltip and its trigger
    Optional but recommended for clarity
    Rotates based on placement (▲ ▼ ◄ ►)

  Container:
    Overlay box with padding, background, border-radius
    Typically: dark background + light text (inverted from page)
    Or: light background + shadow (card-style)

TIMING:

  Show Delay:
    Time between hover start and tooltip appearing
    Recommended: 300-500ms (prevents accidental triggers)
    Too fast: tooltips flash during normal cursor movement
    Too slow: feels unresponsive

  Hide Delay:
    Time between hover end and tooltip disappearing
    Recommended: 100-200ms
    Allows cursor to move to tooltip without it closing
    Critical for users with motor impairments

  Group Delay (warm-up):
    After seeing one tooltip, next ones show immediately
    No delay when moving between elements quickly
    Resets after ~500ms of no tooltip activity

ANIMATION:
  Fade in:     opacity 0→1 (100-200ms)
  Scale:       scale 0.95→1 (subtle, fast)
  Slide:       translate 4px in from placement direction
  Keep it fast and subtle — tooltips should not distract
EOF
}

cmd_positioning() {
    cat << 'EOF'
=== Tooltip Positioning ===

PLACEMENT OPTIONS:
  Primary:     top, right, bottom, left
  With align:  top-start, top-end, right-start, right-end,
               bottom-start, bottom-end, left-start, left-end

  Default: top (above the trigger, centered)

  Visual:
    top-start    top    top-end
         ┌────────────────┐
  left   │   Trigger      │  right
         └────────────────┘
    bottom-start bottom bottom-end

COLLISION DETECTION:
  Problem: Tooltip placed "top" but trigger is near top of viewport
           → tooltip is clipped or hidden

  Solution 1 — Flip:
    If tooltip would overflow on primary axis, flip to opposite side
    top → bottom, left → right
    Most common collision strategy

  Solution 2 — Shift:
    If tooltip would overflow on secondary axis, shift along it
    Tooltip stays on same side but slides to fit in viewport
    Arrow position updates to point at trigger

  Solution 3 — Auto:
    Calculate available space in all directions
    Choose placement with most room
    Less predictable but always visible

POSITIONING LIBRARIES:
  Floating UI (Popper.js successor):
    import { computePosition, flip, shift, arrow } from '@floating-ui/dom';
    computePosition(trigger, tooltip, {
      placement: 'top',
      middleware: [flip(), shift({ padding: 8 }), arrow({ element: arrowEl })]
    }).then(({ x, y, placement, middlewareData }) => {
      Object.assign(tooltip.style, { left: x+'px', top: y+'px' });
    });

  Key middleware:
    flip()        Flip to opposite side on overflow
    shift()       Shift along axis to stay in view
    offset()      Gap between trigger and tooltip (8px default)
    arrow()       Position the arrow element correctly
    autoPlacement()  Auto-choose best placement

CSS ANCHOR POSITIONING (emerging standard):
  .tooltip {
    position: absolute;
    position-anchor: --trigger;
    top: anchor(bottom);
    left: anchor(center);
    position-try: flip-block, flip-inline;
  }
  (Limited browser support as of 2024 — use as progressive enhancement)

VIRTUAL ELEMENTS:
  Position tooltip at cursor location (context menus):
    const virtualEl = {
      getBoundingClientRect() {
        return { x: mouseX, y: mouseY, width: 0, height: 0 ... }
      }
    };
    computePosition(virtualEl, tooltip, { placement: 'right-start' });

Z-INDEX MANAGEMENT:
  Tooltips should be above most UI but below modals
  Typical: z-index: 1000 (modal: 1100, toast: 1200)
  Use a stacking context layer system, not arbitrary numbers
EOF
}

cmd_accessibility() {
    cat << 'EOF'
=== Tooltip Accessibility ===

PATTERN 1 — DESCRIBING TOOLTIP (aria-describedby):
  Use when tooltip adds supplementary info to a labeled element.

  <button aria-describedby="tip-1">Save</button>
  <div role="tooltip" id="tip-1">Save changes to disk (Ctrl+S)</div>

  Screen reader: "Save, button. Save changes to disk, Ctrl+S."
  The element already has a name ("Save"), tooltip adds context.

PATTERN 2 — LABELING TOOLTIP (aria-labelledby):
  Use when tooltip IS the element's accessible name (icon buttons).

  <button aria-labelledby="tip-2">
    <svg>...</svg>  <!-- Icon only, no text -->
  </button>
  <div role="tooltip" id="tip-2">Delete item</div>

  Screen reader: "Delete item, button."

KEYBOARD SUPPORT:
  Show tooltip:   Focus trigger element (Tab into it)
  Hide tooltip:   Blur trigger (Tab away) OR press Escape
  Escape:         Must dismiss tooltip without other side effects
  Stay visible:   While trigger has focus, tooltip stays shown

  CRITICAL: Tooltips MUST be accessible via keyboard focus,
  not just mouse hover. If hover-only → inaccessible.

TOUCH DEVICE CONSIDERATIONS:
  No hover on touch → tooltips don't work!
  Solutions:
    1. Use aria-label instead (screen reader accessible)
    2. Use toggletip (tap to show, tap again to hide)
    3. Show tooltip on long-press (150ms+)
    4. Show info inline instead of in tooltip

SCREEN READER BEHAVIOR:
  role="tooltip":
    Semantically marks element as tooltip
    Some screen readers auto-announce tooltip content
    Content should be announced via aria-describedby relation

  Live updates:
    If tooltip content changes dynamically, use aria-live="polite"
    But static tooltips don't need aria-live

REQUIREMENTS CHECKLIST:
  [ ] Tooltip accessible via focus (not just hover)
  [ ] role="tooltip" on the overlay element
  [ ] aria-describedby OR aria-labelledby connects trigger → tooltip
  [ ] Escape key dismisses tooltip
  [ ] Tooltip doesn't obscure the trigger element
  [ ] Content doesn't require interaction (no links/buttons)
  [ ] Touch alternative exists (label, toggletip, or inline text)
  [ ] Sufficient color contrast (4.5:1 minimum for text)
  [ ] Tooltip text is concise and meaningful
EOF
}

cmd_triggers() {
    cat << 'EOF'
=== Trigger Patterns ===

HOVER TRIGGER (most common):
  Show: mouseenter on trigger element
  Hide: mouseleave from trigger element
  Requirements:
    - Show delay: 300-500ms (prevent flash on cursor pass-through)
    - Hide delay: 100-200ms (grace period to reach tooltip)
    - Keep visible while cursor is over tooltip itself
    - Dismiss on scroll (tooltip position becomes stale)

  Mouse movement handling:
    pointerenter/pointerleave preferred over mouseenter/mouseleave
    pointerenter works for mouse AND stylus (not touch)

FOCUS TRIGGER (accessibility essential):
  Show: focus event on trigger element
  Hide: blur event on trigger element
  Requirements:
    - No delay needed (focus is intentional)
    - Must work alongside hover (both triggers)
    - Keep visible while trigger has focus
    - Dismiss with Escape key

CLICK TRIGGER (toggletip pattern):
  Show: click/tap on trigger element
  Hide: click trigger again, click outside, or Escape
  Requirements:
    - Toggle behavior (click on → click off)
    - Click outside to dismiss
    - Used for touch-friendly informational overlays
    - Technically a toggletip or popover, not a tooltip

LONG-PRESS TRIGGER (mobile):
  Show: press and hold 300-500ms on touch device
  Hide: release touch or Escape
  Requirements:
    - Visual feedback during press (scale/color change)
    - Haptic feedback when tooltip appears (if available)
    - Fallback for devices without long-press support

PROGRAMMATIC TRIGGER:
  Show/hide controlled by application logic
  Examples:
    - Form field tooltip when validation fails
    - Onboarding tooltip sequence (guided tour)
    - Feature discovery ("New!" tooltip on menu item)
  Requirements:
    - Manual control: show(), hide(), toggle() API
    - Auto-dismiss after timeout (optional)
    - Don't interrupt user's current task

COMBINED TRIGGERS (recommended pattern):
  Desktop: hover OR focus (whichever comes first)
  Mobile: long-press or tap (toggletip mode)
  Dismiss: mouseleave AND blur AND Escape AND scroll

  Implementation pseudocode:
    on pointerenter → start show timer
    on focus → show immediately
    on pointerleave → start hide timer
    on blur → start hide timer
    on Escape → hide immediately
    on scroll → hide immediately
    if (show timer running && hide timer starts) → cancel show timer
    if (hide timer running && show timer starts) → cancel hide timer
EOF
}

cmd_content() {
    cat << 'EOF'
=== Tooltip Content Guidelines ===

WHAT BELONGS IN TOOLTIPS:
  ✓ Labels for icon-only buttons ("Bold", "Undo", "Search")
  ✓ Keyboard shortcuts ("Ctrl+B", "⌘+Z")
  ✓ Abbreviation expansion ("API: Application Programming Interface")
  ✓ Full text for truncated content ("Q4 2024 Sales Report Final...")
  ✓ Brief clarification ("Based on last 30 days of data")
  ✓ Units or format hints ("Enter date as YYYY-MM-DD")

WHAT DOESN'T BELONG:
  ✗ Essential instructions (put these in the UI itself)
  ✗ Error messages (show inline, red text)
  ✗ Long explanations (use a help panel or documentation link)
  ✗ Interactive content (use a popover or dialog)
  ✗ Images or media (use a preview card)
  ✗ Redundant labels ("Save" tooltip on a "Save" button)

WRITING GUIDELINES:
  Length:        1-2 lines, ≈80 characters maximum
  Case:          Sentence case ("Save changes" not "Save Changes")
  Punctuation:   No period for labels, period for sentences
  Voice:         Direct, concise, plain language
  Tone:          Helpful, not condescending

EXAMPLES:

  Good tooltip content:
    Icon button:         "Delete conversation"
    With shortcut:       "Bold (Ctrl+B)"
    Clarification:       "Includes tax and shipping"
    Truncated text:      "Very Long Report Title That Was Truncated..."
    Status:              "Last synced 5 minutes ago"

  Bad tooltip content:
    Too long:            "This button will delete the selected
                          conversation and all messages within it.
                          This action cannot be undone. Please make
                          sure you have backed up any important..."
    Redundant:           Button text "Save" + tooltip "Save" (useless)
    Too vague:           "Click here"
    Technical jargon:    "Executes the PATCH /api/v2/resource endpoint"

RICH TOOLTIPS (use sparingly):
  Some design systems support "rich" tooltips with:
    - Title + description
    - Small images/illustrations
    - "Learn more" link (opens new page)
  These blur the line with popovers
  If content needs interaction → use popover instead

LOCALIZATION:
  Tooltip text may expand 30-50% in translation
  German, French often longer than English
  Right-to-left languages (Arabic, Hebrew) → flip placement
  Test with longest language strings
EOF
}

cmd_css() {
    cat << 'EOF'
=== CSS Implementation ===

BASIC TOOLTIP:

  .tooltip-trigger {
    position: relative;
  }

  .tooltip {
    position: absolute;
    bottom: calc(100% + 8px);  /* 8px gap above trigger */
    left: 50%;
    transform: translateX(-50%);
    padding: 6px 12px;
    background: #1a1a1a;
    color: #ffffff;
    font-size: 13px;
    line-height: 1.4;
    border-radius: 6px;
    white-space: nowrap;
    pointer-events: none;
    z-index: 1000;
    opacity: 0;
    visibility: hidden;
    transition: opacity 0.15s ease, visibility 0.15s ease;
  }

  .tooltip-trigger:hover .tooltip,
  .tooltip-trigger:focus-within .tooltip {
    opacity: 1;
    visibility: visible;
  }

ARROW (CSS triangle):

  .tooltip::after {
    content: '';
    position: absolute;
    top: 100%;
    left: 50%;
    transform: translateX(-50%);
    border: 6px solid transparent;
    border-top-color: #1a1a1a;
  }

  /* Arrow for bottom placement */
  .tooltip--bottom::after {
    top: auto;
    bottom: 100%;
    border-top-color: transparent;
    border-bottom-color: #1a1a1a;
  }

ANIMATIONS:

  /* Fade + slide */
  .tooltip--animated {
    opacity: 0;
    transform: translateX(-50%) translateY(4px);
    transition: opacity 0.15s ease,
                transform 0.15s ease,
                visibility 0.15s ease;
  }

  .tooltip-trigger:hover .tooltip--animated {
    opacity: 1;
    transform: translateX(-50%) translateY(0);
  }

  /* Fade + scale */
  .tooltip--scale {
    opacity: 0;
    transform: translateX(-50%) scale(0.95);
    transform-origin: bottom center;
  }

SHOW DELAY WITH CSS:

  .tooltip {
    transition-delay: 0.3s;  /* 300ms show delay */
  }

  .tooltip-trigger:hover .tooltip {
    transition-delay: 0s;  /* No delay on hide */
  }

  /* Note: CSS-only delay is limited — JS gives more control
     for grace periods and group warming behavior */

LIGHT THEME VARIANT:

  .tooltip--light {
    background: #ffffff;
    color: #1a1a1a;
    box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    border: 1px solid #e5e7eb;
  }

  .tooltip--light::after {
    border-top-color: #ffffff;
    /* Shadow on arrow requires clip-path or SVG arrow */
  }

MAX WIDTH FOR WRAPPING:

  .tooltip--multiline {
    white-space: normal;
    max-width: 250px;
    text-align: left;
  }

PORTAL/TELEPORT APPROACH:
  For complex apps, render tooltip in <body> (not near trigger):
  - Avoids overflow: hidden clipping
  - Avoids stacking context issues
  - Use position: fixed + JavaScript positioning
  - Libraries: Floating UI, Tippy.js, Radix Tooltip
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Tooltip Design & Implementation Checklist ===

CONTENT:
  [ ] Text is brief (≤80 characters, 1-2 lines)
  [ ] Content is supplementary, not essential
  [ ] Not redundant with visible label
  [ ] Keyboard shortcuts included where applicable
  [ ] No interactive elements in tooltip (use popover instead)
  [ ] Localization-safe (tested with longer translations)

BEHAVIOR:
  [ ] Show delay of 300-500ms on hover
  [ ] Hide delay of 100-200ms (grace period)
  [ ] Appears immediately on focus (no delay)
  [ ] Dismissed by Escape key
  [ ] Dismissed on scroll (position becomes stale)
  [ ] Persists while cursor is over tooltip itself
  [ ] Group warming: instant show after recent tooltip

POSITIONING:
  [ ] Default placement defined (top recommended)
  [ ] Collision detection (flip when near viewport edge)
  [ ] Shift when near viewport edge on cross-axis
  [ ] Gap between tooltip and trigger (6-8px)
  [ ] Arrow points accurately at trigger
  [ ] Doesn't obscure the trigger element itself
  [ ] Works in scrollable containers

ACCESSIBILITY:
  [ ] Trigger is focusable (button, link, or tabindex="0")
  [ ] role="tooltip" on overlay element
  [ ] aria-describedby OR aria-labelledby on trigger
  [ ] Visible on keyboard focus (not just mouse hover)
  [ ] Escape key dismisses without other side effects
  [ ] Touch alternative exists (tap, label, or inline)
  [ ] Color contrast ≥ 4.5:1 for tooltip text
  [ ] Not the only source of important information

VISUAL:
  [ ] Consistent style across application
  [ ] Arrow present and rotates with placement
  [ ] Animation is subtle and fast (150-200ms)
  [ ] Z-index appropriate (above content, below modals)
  [ ] Dark and light theme support
  [ ] Maximum width set for long content (250-300px)

TECHNICAL:
  [ ] Works in portaled/teleported rendering
  [ ] No overflow clipping from parent containers
  [ ] Cleaned up on trigger unmount (no orphan tooltips)
  [ ] Performance: no layout thrashing during positioning
  [ ] Mobile: graceful degradation (no hover on touch)
EOF
}

show_help() {
    cat << EOF
tooltip v$VERSION — Tooltip UI Component Reference

Usage: script.sh <command>

Commands:
  intro         Tooltip overview, types, when to use vs alternatives
  anatomy       Trigger, content, arrow, timing, animation
  positioning   Placement, collision detection, flip/shift, libraries
  accessibility ARIA patterns, keyboard, screen readers, touch
  triggers      Hover, focus, click, long-press, combined patterns
  content       What belongs in tooltips, writing guidelines
  css           CSS positioning, arrow, animations, theming
  checklist     Tooltip design and implementation checklist
  help          Show this help
  version       Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)         cmd_intro ;;
    anatomy)       cmd_anatomy ;;
    positioning)   cmd_positioning ;;
    accessibility) cmd_accessibility ;;
    triggers)      cmd_triggers ;;
    content)       cmd_content ;;
    css)           cmd_css ;;
    checklist)     cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "tooltip v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
