#!/usr/bin/env bash
# ribbon — Ribbon UI Component Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Ribbon UI Overview ===

A ribbon is a tabbed toolbar that organizes commands into logical groups,
making large feature sets discoverable without deep menu hierarchies.

HISTORY:
  2007  Microsoft Office 2007 introduces the Ribbon (Fluent UI)
        Replaced menus and toolbars after research showed users
        couldn't find commands — 90% of feature requests were
        for features that already existed.
  2010  Office 2010 adds backstage view (File tab)
  2013  Office 2013 simplifies, flatter design
  2016+ Ribbon becomes standard in complex productivity apps
  Web   Fluent UI React, Kendo UI, DevExtreme implement web ribbons

WHEN TO USE A RIBBON:
  ✓ Application has 50+ commands
  ✓ Commands group naturally into categories
  ✓ Users perform diverse tasks (not one linear workflow)
  ✓ Discoverability is more important than screen space
  ✓ Desktop-class productivity application

WHEN NOT TO USE:
  ✗ Simple app with <20 commands (use a toolbar)
  ✗ Mobile-first interface (too complex for touch)
  ✗ Document consumption (reading, not editing)
  ✗ Single-purpose tool (use contextual toolbar)
  ✗ Terminal/CLI application

ALTERNATIVES:
  Traditional toolbar     Simple, fewer commands, icon-heavy
  Command palette         Keyboard-first (VS Code Ctrl+Shift+P)
  Sidebar navigation      For page-based apps
  Contextual toolbars     Appear near selection/content
  Hamburger menu          Mobile-first, hidden navigation
  Action bar              Android-style, limited primary actions

KEY BENEFITS:
  - All commands visible (no hunting through menus)
  - Logical grouping aids learning
  - Visual size indicates importance
  - Contextual tabs show relevant commands per task
  - Consistent structure reduces cognitive load
EOF
}

cmd_anatomy() {
    cat << 'EOF'
=== Ribbon Anatomy ===

┌─────────────────────────────────────────────────────────────┐
│ [App Icon] │ File │ Home │ Insert │ Layout │ Review │       │
├─────────────────────────────────────────────────────────────┤
│ ┌─Clipboard──┐ ┌──Font──────────┐ ┌──Paragraph────────┐   │
│ │ 📋 Paste   │ │ B I U abc  A▼  │ │ ≡ ≡ ≡ ¶  ↕  │ ≡  │   │
│ │ ✂ Cut      │ │ Arial  ▼ 12 ▼  │ │ 📝 Bullets Indent │   │
│ │ 📄 Copy    │ │                │ │                   │   │
│ └────────────┘ └────────────────┘ └───────────────────┘   │
│  Clipboard ▼     Font ▼              Paragraph ▼           │
└─────────────────────────────────────────────────────────────┘

COMPONENTS:

  Application Button / File Tab:
    Top-left, opens backstage view
    Contains: New, Open, Save, Print, Export, Options
    Always visible, always first position

  Tabs:
    Home, Insert, Layout, Review, etc.
    Each tab shows a different set of command groups
    Home tab = most frequently used commands

  Contextual Tabs:
    Appear only when specific content is selected
    Example: "Picture Format" tab when image is selected
    Usually colored differently (orange, green, purple)
    Disappear when selection changes

  Groups:
    Logical clusters of related commands within a tab
    Each group has a label at the bottom
    Optional dialog launcher (▼) opens detailed settings

  Controls:
    Individual command elements within groups
    Large buttons for frequent commands
    Small buttons for secondary commands
    See 'controls' command for full taxonomy

  Quick Access Toolbar (QAT):
    Tiny toolbar above/below ribbon
    User-customizable with favorite commands
    Always visible regardless of active tab

  Backstage View:
    Full-page view for file/app-level operations
    Opened by File tab
    New, Open, Save, Print, Share, Export, Account, Options

  Minimize/Collapse:
    Double-click tab or Ctrl+F1 to collapse ribbon
    Shows only tab names, expands on click
    Important for maximizing content area
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Ribbon Design Patterns ===

COMMAND ORGANIZATION:
  Rule of 7±2: Keep 5-9 groups per tab
  Most important commands → largest buttons, leftmost position
  Reading order: Left-to-right, top-to-bottom within groups
  Related commands grouped together (spatial proximity)

  Tab ordering principle:
    Tab 1 (Home):    Most frequently used commands (80/20 rule)
    Tab 2+:          Task-oriented grouping
    Last tabs:       Specialized/advanced features

PROGRESSIVE DISCLOSURE:
  Level 1: Large iconic buttons (primary actions)
  Level 2: Small buttons in group (secondary actions)
  Level 3: Drop-down menus on buttons (options)
  Level 4: Dialog launcher (full settings panel)
  Level 5: Backstage view (app-level operations)

  Users should accomplish 80% of tasks at Level 1-2.

COMMAND SIZING RULES:
  Large button (32x32 icon + label):
    - Used for most important/frequent commands
    - Maximum 3-4 large buttons per group
    - Always include text label

  Small button (16x16 icon + optional label):
    - Secondary commands
    - Can stack 2-3 rows
    - Labels optional but recommended

  Size consistency within a group:
    Don't mix large and small randomly
    Large on left, small stacked on right (typical pattern)

SPLIT BUTTON PATTERN:
  Top half: executes default action (click)
  Bottom half (▼): opens menu of variations
  Example: Paste (top) → Paste Special, Paste Values (dropdown)
  Use when: one primary action with multiple options

GALLERY PATTERN:
  Visual grid of options shown directly in ribbon
  Example: Style gallery, color palette, chart types
  Shows preview of result before applying
  "More" button at bottom for full gallery view
  Power: visual recognition faster than text scanning

CONTEXTUAL TAB PATTERN:
  Trigger: specific content type selected
  Display: colored tab appears at end of tab bar
  Dismiss: tab disappears when selection changes
  Example: Select a table → "Table Design" and "Layout" tabs appear
  Rule: Never put essential commands only in contextual tabs
EOF
}

cmd_controls() {
    cat << 'EOF'
=== Ribbon Control Types ===

BUTTONS:
  Standard Button      Click to execute command
  Toggle Button        On/off state (bold, italic, grid lines)
  Split Button         Click = default action, ▼ = menu
  Menu Button          Always opens a menu (no direct action)

DROP-DOWNS:
  Simple Drop-down     Select one option from list
  Combo Box            Drop-down + text input (font name)
  In-Ribbon Gallery    Visual grid shown inline
  Drop-down Gallery    Visual grid in opened panel

INPUT CONTROLS:
  Spinner              Numeric up/down (font size, margins)
  Text Input           Free text field (search, go-to page)
  Color Picker         Color selection with palette + custom

GROUPING CONTROLS:
  Group                Container for related controls
  Separator            Visual divider within a group
  Dialog Launcher      Small icon opening detailed settings dialog

SPECIAL CONTROLS:
  CheckBox             Toggle option (show rulers, snap to grid)
  Radio Group          Mutually exclusive options
  Label                Read-only text (status, info)
  MRU (Most Recently Used)  Shows recent selections at top of list

CONTROL STATE MANAGEMENT:
  Enabled:      Normal, interactive
  Disabled:     Grayed out, non-interactive (context doesn't apply)
  Pressed:      Toggle is active (bold button when text is bold)
  Hover:        Mouse over, show tooltip
  Focused:      Keyboard focus indicator

  State rules:
    - Disable rather than hide (users learn positions)
    - Show tooltip on disabled controls explaining WHY
    - Toggle states must be visually distinct
    - Keyboard focus must be visible (2px+ outline)

TOOLTIP DESIGN FOR RIBBON:
  Standard tooltip: Icon + Name + Description
  Enhanced tooltip: Icon + Name + Description + Shortcut + Preview image
  Show after 400ms hover delay
  Position: below the control, don't obscure ribbon content
EOF
}

cmd_responsive() {
    cat << 'EOF'
=== Responsive Ribbon Design ===

CHALLENGE:
  Ribbons contain many controls that won't fit at narrow widths.
  Must degrade gracefully without losing functionality.

ADAPTIVE LAYOUT STRATEGY (priority-based):

  Priority 1 — Full display:
    All controls shown at maximum size with labels
    Width: > 1200px

  Priority 2 — Reduce large buttons:
    Large buttons → small buttons (keep icon + label)
    Width: 900-1200px

  Priority 3 — Remove labels:
    Small buttons → icon only (tooltip shows label)
    Width: 700-900px

  Priority 4 — Collapse groups:
    Entire group → single drop-down button
    Click opens group's controls in a popup
    Width: 500-700px

  Priority 5 — Overflow menu:
    Multiple groups → "..." overflow button
    Width: < 500px

COLLAPSE PRIORITY RULES:
  Each group gets a collapse priority (1 = collapse last):
    Priority 1: Clipboard, Font (most used → collapse last)
    Priority 2: Paragraph, Styles
    Priority 3: Editing, Proofing (less frequent → collapse first)

  Within a group, controls collapse in order:
    1. Labels removed (icon only)
    2. Large → small buttons
    3. Galleries → dropdown button
    4. Entire group → single button

MOBILE CONSIDERATIONS:
  Full ribbon not suitable for mobile → use:
    - Bottom toolbar with most frequent actions
    - Overflow menu ("...") for remaining commands
    - Full ribbon accessible via toolbar toggle
    - Touch targets minimum 44x44px
    - No hover-dependent features (no tooltips on touch)

IMPLEMENTATION CSS PATTERN:
  Use CSS container queries (preferred) or media queries:

  @container ribbon (max-width: 900px) {
    .ribbon-btn-large { /* convert to small */ }
  }
  @container ribbon (max-width: 700px) {
    .ribbon-btn-label { display: none; }
  }
  @container ribbon (max-width: 500px) {
    .ribbon-group { /* collapse to dropdown */ }
  }
EOF
}

cmd_accessibility() {
    cat << 'EOF'
=== Ribbon Accessibility ===

KEYBOARD NAVIGATION:

  KeyTips (Office-style):
    Press Alt → letters appear on each tab/control
    Press letter → navigate to that item
    Example: Alt → H (Home tab) → B (Bold)
    All commands reachable in 2-4 keystrokes

  Tab/Arrow Navigation:
    Tab:           Move between major regions (QAT → tabs → groups)
    Left/Right:    Move between tabs or controls within group
    Up/Down:       Move within stacked controls or open menus
    Enter/Space:   Activate focused control
    Escape:        Close menu, return to previous level
    F6:            Cycle between ribbon, content, status bar

  Focus Management:
    Roving tabindex within groups (one tab stop per group)
    Arrow keys move within group
    Focus returns to last position when re-entering ribbon
    Visual focus indicator: 2px+ outline, high contrast

ARIA ROLES:
  Ribbon container:    role="toolbar" or role="tablist" for tabs
  Tab:                 role="tab", aria-selected="true/false"
  Tab panel:           role="tabpanel", aria-labelledby="tab-id"
  Group:               role="group", aria-label="Group Name"
  Button:              role="button", aria-pressed for toggles
  Menu button:         aria-haspopup="true", aria-expanded
  Split button:        Two buttons in a group (action + menu)
  Gallery:             role="listbox" with role="option" items
  Spinner:             role="spinbutton", aria-valuenow/min/max
  Disabled control:    aria-disabled="true" (NOT just visual gray)

SCREEN READER ANNOUNCEMENTS:
  Tab switch:      "Home tab, selected, 1 of 5 tabs"
  Group entry:     "Clipboard group"
  Button focus:    "Bold, toggle button, pressed"
  Menu open:       "Paste options menu, 3 items"
  Disabled:        "Strikethrough, button, disabled, requires text selection"

HIGH CONTRAST MODE:
  All icons must be visible in Windows High Contrast
  Use currentColor for SVG icons
  Don't rely on color alone for toggle state (add underline or border)
  Test with forced-colors: active media query

MINIMUM REQUIREMENTS:
  [ ] All commands reachable by keyboard
  [ ] Focus visible on every interactive element
  [ ] Screen reader announces control name, role, state
  [ ] Disabled controls explain why via aria-description
  [ ] Color not sole means of conveying state
  [ ] Touch targets ≥ 44x44px for mobile
  [ ] Tooltips accessible to keyboard users
EOF
}

cmd_css() {
    cat << 'EOF'
=== CSS Implementation Patterns ===

RIBBON LAYOUT (Flexbox):

  .ribbon {
    display: flex;
    flex-direction: column;
    border-bottom: 1px solid var(--ribbon-border);
    background: var(--ribbon-bg);
    user-select: none;
  }

  .ribbon-tabs {
    display: flex;
    gap: 0;
    border-bottom: 1px solid var(--ribbon-border);
  }

  .ribbon-tab {
    padding: 6px 16px;
    cursor: pointer;
    border: 1px solid transparent;
    border-bottom: none;
    font-size: 13px;
  }

  .ribbon-tab[aria-selected="true"] {
    background: var(--ribbon-panel-bg);
    border-color: var(--ribbon-border);
    border-bottom-color: var(--ribbon-panel-bg);
    margin-bottom: -1px;
  }

  .ribbon-panel {
    display: flex;
    padding: 4px 8px;
    gap: 2px;
    min-height: 86px;
  }

GROUP LAYOUT:

  .ribbon-group {
    display: flex;
    align-items: flex-start;
    padding: 0 6px;
    border-right: 1px solid var(--ribbon-separator);
    position: relative;
  }

  .ribbon-group-label {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    text-align: center;
    font-size: 11px;
    color: var(--ribbon-label-color);
  }

BUTTON STYLES:

  .ribbon-btn {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 4px 8px;
    border: 1px solid transparent;
    border-radius: 3px;
    background: none;
    cursor: pointer;
    gap: 2px;
  }

  .ribbon-btn:hover {
    background: var(--ribbon-hover-bg);
    border-color: var(--ribbon-hover-border);
  }

  .ribbon-btn[aria-pressed="true"] {
    background: var(--ribbon-active-bg);
    border-color: var(--ribbon-active-border);
  }

  .ribbon-btn-large .ribbon-btn-icon {
    width: 32px; height: 32px;
  }

  .ribbon-btn-small .ribbon-btn-icon {
    width: 16px; height: 16px;
  }

THEMING VARIABLES:

  :root {
    --ribbon-bg: #f3f3f3;
    --ribbon-panel-bg: #ffffff;
    --ribbon-border: #d1d1d1;
    --ribbon-separator: #e0e0e0;
    --ribbon-hover-bg: #e5e5e5;
    --ribbon-hover-border: #c8c8c8;
    --ribbon-active-bg: #cde4f7;
    --ribbon-active-border: #98c6ea;
    --ribbon-label-color: #666666;
  }

  /* Dark theme */
  [data-theme="dark"] {
    --ribbon-bg: #2d2d2d;
    --ribbon-panel-bg: #1e1e1e;
    --ribbon-border: #3e3e3e;
    /* ... */
  }
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Ribbon UI Design Checklist ===

STRUCTURE:
  [ ] Home tab contains 80% of frequently used commands
  [ ] 5-9 groups per tab (not overwhelming)
  [ ] Groups ordered by frequency (left = most used)
  [ ] Commands sized by importance (large = primary)
  [ ] Contextual tabs defined for special content types
  [ ] Quick Access Toolbar includes top 3-5 commands
  [ ] File/backstage view handles app-level operations

CONTROLS:
  [ ] Split buttons used where default action + variations exist
  [ ] Toggle buttons show clear pressed/unpressed state
  [ ] Disabled controls show reason via tooltip
  [ ] Drop-downs have sensible default selections
  [ ] Galleries show visual previews of options
  [ ] Dialog launchers open detailed settings for each group

RESPONSIVE:
  [ ] Collapse priorities assigned to every group
  [ ] Controls degrade: large → small → icon only → collapsed
  [ ] Overflow menu catches all collapsed controls
  [ ] Minimum 320px width still functional
  [ ] Tested at 320, 768, 1024, 1440+ pixel widths
  [ ] Touch targets ≥ 44x44px on touch devices

ACCESSIBILITY:
  [ ] All commands reachable by keyboard only
  [ ] KeyTips or equivalent keyboard shortcut system
  [ ] ARIA roles on all interactive elements
  [ ] Screen reader announces name, role, state
  [ ] Focus indicator visible (2px+ contrast)
  [ ] High contrast mode tested and working
  [ ] No information conveyed by color alone

VISUAL:
  [ ] Consistent icon style (size, weight, detail level)
  [ ] Labels readable (13-14px, sufficient contrast)
  [ ] Group separators visible but subtle
  [ ] Active tab clearly distinguished
  [ ] Hover and pressed states for all controls
  [ ] Dark theme / light theme support
  [ ] Animation duration ≤ 200ms for transitions

USABILITY:
  [ ] New users can find common commands within 10 seconds
  [ ] Ribbon collapsible to maximize content area
  [ ] Customization option (right-click → customize)
  [ ] Tooltips include keyboard shortcuts
  [ ] Search/command palette as alternative to browsing
EOF
}

show_help() {
    cat << EOF
ribbon v$VERSION — Ribbon UI Component Reference

Usage: script.sh <command>

Commands:
  intro         Ribbon UI overview, history, when to use
  anatomy       Tabs, groups, controls, contextual tabs, backstage
  patterns      Command organization, progressive disclosure, sizing
  controls      Control types — buttons, galleries, drop-downs, spinners
  responsive    Collapse priorities, overflow menus, mobile adaptation
  accessibility KeyTips, keyboard nav, ARIA roles, screen readers
  css           CSS flexbox layout, theming variables, button styles
  checklist     Ribbon design review checklist
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
    controls)      cmd_controls ;;
    responsive)    cmd_responsive ;;
    accessibility) cmd_accessibility ;;
    css)           cmd_css ;;
    checklist)     cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "ribbon v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
