#!/usr/bin/env bash
# tab — Tab UI Component Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Tab Component Overview ===

Tabs organize content into separate views where only one view is
visible at a time. Users click tab buttons to switch between views
without navigating to a different page.

WHEN TO USE TABS:
  ✓ Content can be divided into 2-7 discrete sections
  ✓ Sections are parallel (same level of hierarchy)
  ✓ Users don't need to compare content across sections
  ✓ Each section can stand alone
  ✓ Labels are short enough to scan (1-3 words)

WHEN NOT TO USE:
  ✗ Content needs to be compared side-by-side (use columns)
  ✗ Sequential steps (use stepper/wizard)
  ✗ More than 7 sections (use navigation menu)
  ✗ Users need to see all content at once (use accordion)
  ✗ Single content section (use headings)
  ✗ Primary navigation between pages (use nav bar)

TAB TYPES:
  Content tabs       Switch content panels in-place
  Navigation tabs    Link to different pages/routes
  Filter tabs        Filter a single data set (All | Active | Archived)
  Settings tabs      Organize settings into categories

TABS vs ALTERNATIVES:
  Tabs:              2-7 sections, parallel content, no cross-reference needed
  Accordion:         Many sections, some open simultaneously, long labels OK
  Segmented control: 2-5 options, acts as a filter, all data same type
  Navigation:        Primary site structure, persistent across views
  Stepper/Wizard:    Sequential process, must complete in order
  Dropdown:          Many options (8+), compact space, less discovery

KEY PRINCIPLES:
  1. Only one tab active at a time
  2. Tab labels describe content (nouns, not verbs)
  3. Default tab should be most commonly needed
  4. Tab order should follow user's mental model
  5. Content in tabs should be independent of other tabs
  6. Don't nest tabs within tabs (use a different pattern)
EOF
}

cmd_anatomy() {
    cat << 'EOF'
=== Tab Anatomy ===

  ┌─────────┬─────────┬─────────┬────────────────────────┐
  │ Tab 1 ● │  Tab 2  │  Tab 3  │                        │
  ├─────────┴─────────┴─────────┴────────────────────────┤
  │ ════════                                              │  ← Active indicator
  │                                                       │
  │             Tab Panel Content                          │
  │                                                       │
  │  Content for the currently active tab appears here.   │
  │                                                       │
  └───────────────────────────────────────────────────────┘

COMPONENTS:

  Tab List (container):
    Horizontal row (or vertical column) of tab buttons
    Single row — don't wrap to multiple lines (scroll instead)
    Usually at top of panel (bottom tabs for mobile apps)

  Tab Button:
    Clickable element that activates its panel
    Contains: label (required), icon (optional), badge (optional), close button (optional)
    States: default, hover, active/selected, focused, disabled

  Active Indicator:
    Visual mark showing which tab is selected
    Common styles:
      Bottom border (underline) — most common web pattern
      Background color change — filled tab
      Top border — less common, indicates panel above
      Pill/rounded background — modern/playful

  Tab Panel:
    Content area associated with each tab
    Only one visible at a time (display: none vs visibility)
    Should maintain scroll position when switching back

  Badge:
    Notification count on tab (unread messages, pending items)
    Position: top-right of tab label
    Use sparingly — not every tab needs a badge

  Close Button:
    "×" on tab for closeable tabs (like browser tabs)
    Position: right side of tab label
    Keyboard: Delete or Ctrl+W to close focused tab

  Overflow Indicator:
    Arrow buttons or scroll indicator when tabs don't fit
    Shows that more tabs exist beyond visible area
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Tab Design Patterns ===

HORIZONTAL TABS (most common):
  Default for content organization
  Position: top of panel
  Indicator: bottom border on active tab
  Best for: 2-7 tabs, short labels

VERTICAL TABS:
  Tab list on left side, content on right
  Better for: many tabs (8+), long labels, settings panels
  Responsive: collapse to horizontal or dropdown on mobile
  Example: VS Code sidebar, settings pages

SCROLLABLE TABS:
  When tabs overflow the container width
  Arrow buttons on edges for scrolling
  Swipe on touch devices
  Active tab should always be visible (scroll into view)
  Show fade/shadow at overflow edges

CLOSEABLE TABS:
  Browser-style tabs (documents, editor tabs)
  Close button on each tab ("×")
  Middle-click to close (web convention)
  "New tab" button at the end (+)
  Reorder by drag-and-drop

ICON TABS:
  Icons only (no labels) — compact, use for well-known concepts
  Always include tooltip and aria-label
  Good for: toolbar-style tabs, mobile, universal concepts
  Examples: 🏠 Home, 🔔 Notifications, 👤 Profile

PILL/CHIP TABS:
  Rounded background instead of underline indicator
  More playful, modern feel
  Works well for filter-style tabs
  Example: All | Photos | Videos | Documents

BOTTOM TABS (mobile):
  Tab bar at bottom of screen (iOS/Android pattern)
  Maximum 5 tabs
  Icon + label combination
  Active: filled icon + tinted label
  Inactive: outline icon + muted label
  Fixed position (doesn't scroll with content)

SEGMENTED TABS (filter pattern):
  Look like a segmented control
  Toggle between views of the SAME data
  Example: Day | Week | Month (calendar views)
  All options visible, one selected
  Usually 2-4 segments

LAZY LOADING PATTERN:
  Don't render panel content until tab is first activated
  Render once, then keep in DOM (hidden)
  Reduces initial load for complex panels
  Show loading skeleton on first activation
EOF
}

cmd_accessibility() {
    cat << 'EOF'
=== Tab Accessibility ===

ARIA ROLES (WAI-ARIA Authoring Practices):

  Tab list container:
    role="tablist"
    aria-label="Section tabs" (or aria-labelledby)
    aria-orientation="horizontal" (or "vertical")

  Tab button:
    role="tab"
    aria-selected="true" (active tab) / "false"
    aria-controls="panel-id" (points to its panel)
    id="tab-1" (referenced by panel's aria-labelledby)
    tabindex="0" (active tab) / "-1" (inactive tabs)

  Tab panel:
    role="tabpanel"
    aria-labelledby="tab-1" (points to its tab)
    id="panel-1" (referenced by tab's aria-controls)
    tabindex="0" (panel itself is focusable)

HTML EXAMPLE:
  <div role="tablist" aria-label="User settings">
    <button role="tab" id="tab-1" aria-selected="true"
            aria-controls="panel-1" tabindex="0">Profile</button>
    <button role="tab" id="tab-2" aria-selected="false"
            aria-controls="panel-2" tabindex="-1">Security</button>
  </div>
  <div role="tabpanel" id="panel-1" aria-labelledby="tab-1"
       tabindex="0">
    Profile content here...
  </div>
  <div role="tabpanel" id="panel-2" aria-labelledby="tab-2"
       tabindex="0" hidden>
    Security content here...
  </div>

KEYBOARD NAVIGATION:
  Horizontal tabs:
    Left Arrow     Focus previous tab
    Right Arrow    Focus next tab
    Home           Focus first tab
    End            Focus last tab

  Vertical tabs:
    Up Arrow       Focus previous tab
    Down Arrow     Focus next tab
    Home           Focus first tab
    End            Focus last tab

  Both:
    Enter/Space    Activate focused tab (if not auto-activate)
    Tab            Move focus into the active panel
    Shift+Tab      Move focus back to active tab from panel
    Delete         Close tab (if closeable)

  AUTO-ACTIVATE vs MANUAL:
    Auto-activate: focusing a tab immediately shows its panel
    Manual: user must press Enter/Space to activate
    Recommendation: auto-activate for few tabs, manual for many
                    or when panel loading is expensive

SCREEN READER ANNOUNCEMENTS:
  Tab focus:     "Profile, tab, 1 of 4, selected"
  Tab switch:    "Security, tab, 2 of 4"
  Panel entry:   "Security tab panel"

COMMON MISTAKES:
  ✗ Using <a> links for tabs (should be <button>)
  ✗ Missing aria-selected on tabs
  ✗ All tabs having tabindex="0" (only active tab should)
  ✗ Panel not labeled (missing aria-labelledby)
  ✗ No keyboard arrow key navigation
  ✗ Focus lost when switching tabs
EOF
}

cmd_state() {
    cat << 'EOF'
=== Tab State Management ===

CONTROLLED vs UNCONTROLLED:

  Uncontrolled (internal state):
    Component manages its own active tab index
    const [activeTab, setActiveTab] = useState(0)
    Simpler, good for isolated tab components

  Controlled (external state):
    Parent component controls active tab
    <Tabs activeKey={activeKey} onChange={setActiveKey}>
    Required when: URL sync, form validation, external triggers

URL SYNCHRONIZATION:
  Sync active tab with URL for deep linking and browser history.

  Hash-based:     /settings#security
  Query-based:    /settings?tab=security
  Path-based:     /settings/security (feels like navigation)

  Implementation:
    On tab change → update URL (pushState or replaceState)
    On page load → read URL → set initial active tab
    On browser back → listen to popstate → update active tab

  Benefits:
    - Users can bookmark specific tabs
    - Sharing URLs opens the right tab
    - Browser back/forward works naturally

LAZY LOADING:
  Strategy 1 — Render on first activation, keep mounted:
    if (hasBeenActive) render panel; (hidden when inactive)
    Pro: Fast re-switch, state preserved

  Strategy 2 — Render only when active:
    if (isActive) render panel;
    Pro: Minimal DOM, lower memory
    Con: State lost on switch, loading on every switch

  Strategy 3 — Prefetch on hover:
    Start loading data when user hovers over tab
    Panel ready by the time they click

PERSISTENCE:
  Where to persist active tab:
    URL:              Best for shareable state
    sessionStorage:   Survives refresh, not new tabs
    localStorage:     Survives sessions (user preference)
    State management: Redux/Zustand for complex app state
    Server:           User preferences synced across devices

FORM HANDLING IN TABS:
  Challenge: User fills Tab 1 form, switches to Tab 2, switches back
  Solution 1: Keep all panels mounted (hidden), preserve form state
  Solution 2: Lift form state to parent component
  Solution 3: Warn on tab switch with unsaved changes
  Never: Destroy form data on tab switch without warning!
EOF
}

cmd_responsive() {
    cat << 'EOF'
=== Responsive Tab Strategies ===

PROBLEM:
  Desktop: 7 tabs fit comfortably in a row
  Mobile: only 2-3 tabs visible, rest are hidden

STRATEGY 1 — SCROLLABLE TABS:
  Tab list scrolls horizontally
  Active tab scrolled into view
  Scroll indicators on edges (arrows or shadows)
  Swipe gesture on touch devices
  Pros: All tabs remain tabs, consistent behavior
  Cons: Hidden tabs are less discoverable
  Best for: 4-8 tabs, short labels
  Used by: Material Design (Google)

STRATEGY 2 — DROPDOWN CONVERSION:
  Tabs → select dropdown on small screens
  <select> element styled as tab navigation
  Pros: Very compact, all options visible in dropdown
  Cons: Extra click needed, less visual
  Best for: Many tabs (7+), functional/data apps

STRATEGY 3 — ACCORDION CONVERSION:
  Tabs → accordion on small screens
  Each tab becomes an accordion header
  Multiple sections can be open (unlike tabs)
  Pros: All content accessible without scrolling through tabs
  Cons: Different interaction pattern, more vertical space
  Best for: Content-heavy sections, documentation

STRATEGY 4 — PRIORITY / "MORE" TABS:
  Show N tabs that fit + "More ▼" dropdown for overflow
  Most important tabs always visible
  "More" shows remaining tabs in dropdown
  Pros: Key tabs always visible, others accessible
  Cons: Requires priority assignment, "More" is vague
  Best for: Variable-width containers, dashboards

STRATEGY 5 — ICON-ONLY ON MOBILE:
  Full labels on desktop → icons only on mobile
  Requires universally understood icons
  Add tooltip/aria-label
  Pros: Compact, recognizable
  Cons: Icons can be ambiguous

BREAKPOINT RECOMMENDATIONS:
  > 768px:    Full horizontal tabs with labels
  480-768px:  Scrollable tabs or icon + label
  < 480px:    Scrollable icons, dropdown, or accordion

IMPLEMENTATION TIPS:
  Use ResizeObserver to detect container width (not window)
  Calculate: total tab widths > container width → activate scroll
  CSS: overflow-x: auto; scroll-snap-type: x mandatory;
  Animate scroll indicator (fade in/out based on scroll position)
  Test with longest possible tab labels × maximum tab count
EOF
}

cmd_css() {
    cat << 'EOF'
=== CSS Implementation ===

BASIC TAB STRUCTURE:

  .tabs {
    display: flex;
    flex-direction: column;
  }

  .tab-list {
    display: flex;
    gap: 0;
    border-bottom: 2px solid var(--tab-border);
    position: relative;
  }

  .tab-button {
    padding: 12px 20px;
    background: none;
    border: none;
    cursor: pointer;
    font-size: 14px;
    font-weight: 500;
    color: var(--tab-text);
    position: relative;
    white-space: nowrap;
  }

  .tab-button[aria-selected="true"] {
    color: var(--tab-active-text);
  }

ANIMATED INDICATOR (sliding underline):

  /* Pseudo-element indicator on active tab */
  .tab-button[aria-selected="true"]::after {
    content: '';
    position: absolute;
    bottom: -2px;
    left: 0;
    right: 0;
    height: 2px;
    background: var(--tab-indicator);
  }

  /* JS-driven sliding indicator (smoother) */
  .tab-indicator {
    position: absolute;
    bottom: 0;
    height: 2px;
    background: var(--tab-indicator);
    transition: left 0.3s ease, width 0.3s ease;
  }

  /* JavaScript updates left/width based on active tab position:
     indicator.style.left = activeTab.offsetLeft + 'px';
     indicator.style.width = activeTab.offsetWidth + 'px'; */

TAB VARIANTS:

  /* Underline variant (default) */
  .tabs--underline .tab-button[aria-selected="true"]::after {
    background: var(--primary);
  }

  /* Pill variant */
  .tabs--pill .tab-button[aria-selected="true"] {
    background: var(--primary);
    color: white;
    border-radius: 999px;
  }

  /* Boxed variant */
  .tabs--boxed .tab-button[aria-selected="true"] {
    background: var(--surface);
    border: 1px solid var(--border);
    border-bottom-color: var(--surface);
    border-radius: 6px 6px 0 0;
    margin-bottom: -1px;
  }

SCROLLABLE TABS:

  .tab-list--scrollable {
    overflow-x: auto;
    scrollbar-width: none;
    -ms-overflow-style: none;
    scroll-behavior: smooth;
    scroll-snap-type: x proximity;
  }
  .tab-list--scrollable::-webkit-scrollbar {
    display: none;
  }
  .tab-list--scrollable .tab-button {
    scroll-snap-align: start;
    flex-shrink: 0;
  }

THEMING:

  :root {
    --tab-text: #666;
    --tab-active-text: #1a1a1a;
    --tab-indicator: #2563eb;
    --tab-border: #e5e7eb;
    --tab-hover-bg: #f3f4f6;
  }

  .tab-panel {
    padding: 16px 0;
    animation: fadeIn 0.2s ease;
  }

  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(4px); }
    to   { opacity: 1; transform: translateY(0); }
  }
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Tab Design & Implementation Checklist ===

DESIGN:
  [ ] 2-7 tabs maximum (consider alternatives for more)
  [ ] Labels are short, descriptive nouns (1-3 words)
  [ ] Default tab is the most commonly needed section
  [ ] Tab order follows user's mental model
  [ ] Active tab is clearly distinguishable
  [ ] No nested tabs (tab within a tab)
  [ ] Content in each tab is independent

VISUAL:
  [ ] Active indicator is visible and clear
  [ ] Hover state on interactive tabs
  [ ] Disabled tab state (if applicable) with tooltip
  [ ] Consistent label alignment and spacing
  [ ] Icons (if used) are meaningful and have text alternatives
  [ ] Badge/count display is readable and positioned consistently
  [ ] Transition animation is smooth (200-300ms)

ACCESSIBILITY:
  [ ] role="tablist" on container
  [ ] role="tab" on each tab button
  [ ] role="tabpanel" on each panel
  [ ] aria-selected="true/false" on tabs
  [ ] aria-controls links tab to panel
  [ ] aria-labelledby links panel to tab
  [ ] Only active tab has tabindex="0"
  [ ] Arrow keys navigate between tabs
  [ ] Home/End keys jump to first/last tab
  [ ] Tab key moves focus from tab to panel content
  [ ] Focus indicator visible (2px+ outline)
  [ ] Screen reader announces tab position (X of Y)

RESPONSIVE:
  [ ] Tested at 320px, 768px, 1024px+ widths
  [ ] Overflow strategy chosen (scroll/dropdown/accordion/more)
  [ ] Active tab visible after responsive transformation
  [ ] Touch targets ≥ 44px height on mobile
  [ ] Swipe gestures supported on touch devices (if scrollable)

STATE:
  [ ] URL sync for deep linking (if appropriate)
  [ ] Panel content preserved when switching tabs
  [ ] Form state not lost on tab switch
  [ ] Loading state handled for lazy-loaded panels
  [ ] Browser back/forward works with tab state
EOF
}

show_help() {
    cat << EOF
tab v$VERSION — Tab UI Component Reference

Usage: script.sh <command>

Commands:
  intro         Tab overview, when to use, types, alternatives
  anatomy       Tab list, buttons, panels, indicators, badges
  patterns      Horizontal, vertical, scrollable, closeable, icon tabs
  accessibility ARIA roles, keyboard navigation, screen readers
  state         Controlled/uncontrolled, URL sync, lazy loading
  responsive    Scrollable, dropdown, accordion, priority strategies
  css           CSS layout, animated indicator, variants, theming
  checklist     Tab design and implementation checklist
  help          Show this help
  version       Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)         cmd_intro ;;
    anatomy)       cmd_anatomy ;;
    patterns)      cmd_patterns ;;
    accessibility) cmd_accessibility ;;
    state)         cmd_state ;;
    responsive)    cmd_responsive ;;
    css)           cmd_css ;;
    checklist)     cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "tab v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
