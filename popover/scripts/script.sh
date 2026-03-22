#!/usr/bin/env bash
# popover — Popover & Tooltip Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Popovers ===

A popover is a transient floating element that appears relative to
a trigger element, showing additional content or actions.

Popover vs Tooltip vs Modal:
  ┌──────────┬────────────────┬──────────────┬──────────────┐
  │          │ Popover        │ Tooltip      │ Modal        │
  ├──────────┼────────────────┼──────────────┼──────────────┤
  │ Trigger  │ Click          │ Hover/Focus  │ Action       │
  │ Content  │ Rich (buttons) │ Text only    │ Complex      │
  │ Dismiss  │ Click outside  │ Mouse leave  │ Explicit     │
  │ Blocking │ No             │ No           │ Yes          │
  │ Focus    │ Optional       │ Never        │ Trapped      │
  │ Backdrop │ No             │ No           │ Yes          │
  │ Position │ Near trigger   │ Near trigger │ Center       │
  │ Example  │ Share menu     │ "Copy link"  │ "Delete?"    │
  └──────────┴────────────────┴──────────────┴──────────────┘

Common Popover Types:
  Tooltip:       Short hint text on hover/focus
  Menu:          List of actions/options
  Info popover:  Rich content (images, links, buttons)
  Combobox:      Search + dropdown list
  Date picker:   Calendar overlay
  Color picker:  Color selection UI
  Notification:  Alert/toast near trigger

Native Support (2024+):
  HTML Popover API:     popover attribute (Chrome 114+, FF 125+, Safari 17+)
  CSS Anchor Positioning: anchor-name + position-anchor (Chrome 125+)

  Before these APIs:
    Custom JS + absolute/fixed positioning + z-index hacks
    Libraries: Popper.js, Floating UI, Tippy.js

Key Challenges:
  1. Positioning: Stay near trigger, don't overflow viewport
  2. Z-index: Appear above all other content
  3. Dismissal: Click-outside, Escape, scroll-away
  4. Accessibility: Keyboard navigation, screen reader
  5. Nesting: Popover inside popover
EOF
}

cmd_api() {
    cat << 'EOF'
=== HTML Popover API ===

Supported: Chrome 114+, Firefox 125+, Safari 17+

--- Basic Usage ---
  <button popovertarget="mypopover">Toggle</button>
  <div id="mypopover" popover>
    <p>This is popover content!</p>
  </div>

  That's it! No JavaScript needed for basic popovers.

--- Popover Types ---
  popover="auto"     Default. Light dismiss (click-outside, Escape).
                     Only one auto popover visible at a time.
                     Closes other auto popovers when opened.

  popover="manual"   No light dismiss. Must close explicitly.
                     Multiple can be open simultaneously.
                     Use for: persistent toasts, custom dismiss logic.

--- Trigger Actions ---
  <button popovertarget="pop" popovertargetaction="toggle">Toggle</button>
  <button popovertarget="pop" popovertargetaction="show">Show</button>
  <button popovertarget="pop" popovertargetaction="hide">Hide</button>

  Default action is "toggle" if not specified.

--- JavaScript API ---
  const pop = document.getElementById('mypopover');

  pop.showPopover();     // Open
  pop.hidePopover();     // Close
  pop.togglePopover();   // Toggle

  // Check state:
  pop.matches(':popover-open')

--- Events ---
  pop.addEventListener('toggle', (e) => {
    console.log('Old state:', e.oldState);  // 'closed' or 'open'
    console.log('New state:', e.newState);  // 'open' or 'closed'
  });

  pop.addEventListener('beforetoggle', (e) => {
    if (e.newState === 'open') {
      // Can prevent opening:
      // e.preventDefault();
    }
  });

--- Top Layer ---
  Popover elements are promoted to the browser's "top layer":
  - Above all z-index stacking contexts
  - No z-index wars
  - Same mechanism as <dialog>.showModal()
  - ::backdrop pseudo-element available (but transparent by default)

--- Light Dismiss ---
  For popover="auto":
  - Click outside → closes
  - Press Escape → closes
  - Open another auto popover → closes this one
  - Tab out of popover → closes (if no focusable content)

--- Nested Popovers ---
  Auto popovers support nesting:
  <div popover id="parent">
    Parent content
    <button popovertarget="child">Open child</button>
  </div>
  <div popover id="child">
    Child popover
  </div>

  Opening child doesn't close parent (if child is ancestor).
  Opening an unrelated popover DOES close both.

--- Popover + Invoker (Future) ---
  <button commandfor="pop" command="toggle-popover">Toggle</button>
  (Invoker Commands API — extends popovertarget pattern)
EOF
}

cmd_positioning() {
    cat << 'EOF'
=== Popover Positioning ===

--- CSS Anchor Positioning (New) ---
  Chrome 125+. Native CSS-based positioning relative to an anchor.

  .trigger {
    anchor-name: --my-trigger;
  }

  .popover {
    position: fixed;
    position-anchor: --my-trigger;

    /* Position below the trigger: */
    top: anchor(bottom);
    left: anchor(left);

    /* Or use inset-area (logical positioning): */
    inset-area: bottom span-right;
  }

  /* Auto-flip when near viewport edge: */
  @position-try --flip-top {
    inset-area: top span-right;
  }

  .popover {
    position-try-options: --flip-top;
  }

--- Floating UI (JavaScript) ---
  import { computePosition, flip, shift, offset } from '@floating-ui/dom';

  const trigger = document.querySelector('.trigger');
  const popover = document.querySelector('.popover');

  computePosition(trigger, popover, {
    placement: 'bottom-start',
    middleware: [
      offset(8),           // 8px gap from trigger
      flip(),              // flip to top if no room below
      shift({ padding: 8 }), // shift to stay in viewport
    ],
  }).then(({ x, y }) => {
    Object.assign(popover.style, {
      left: `${x}px`,
      top: `${y}px`,
    });
  });

--- Placement Options ---
  12 placements:
    top           top-start       top-end
    bottom        bottom-start    bottom-end
    left          left-start      left-end
    right         right-start     right-end

--- Middleware Explained ---
  offset:    Gap between trigger and popover
  flip:      Switch to opposite side if clipped
  shift:     Slide along axis to stay in viewport
  arrow:     Position arrow element
  size:      Resize popover to fit available space
  hide:      Hide when trigger is scrolled out of view
  autoPlacement: Auto-choose best placement

--- The Arrow Problem ---
  CSS triangle (classic):
    .arrow {
      position: absolute;
      width: 12px; height: 12px;
      background: white;
      transform: rotate(45deg);
      /* positioned by JS based on placement */
    }

  Floating UI arrow middleware calculates position:
    arrow({ element: arrowElement, padding: 8 })

--- Virtual Elements ---
  Position relative to cursor (context menu):
    computePosition(
      { getBoundingClientRect: () => ({
          x: event.clientX, y: event.clientY,
          width: 0, height: 0, top: event.clientY,
          left: event.clientX, right: event.clientX,
          bottom: event.clientY
        })
      },
      popover,
      { placement: 'bottom-start' }
    );

--- Position Strategies ---
  position: absolute  — relative to nearest positioned ancestor
                        Problem: clipping by overflow:hidden containers
  position: fixed     — relative to viewport
                        Problem: doesn't scroll with trigger
  Floating UI:        — handles both cases automatically
  Top layer (popover):— above all stacking contexts (best)
EOF
}

cmd_tooltip() {
    cat << 'EOF'
=== Tooltip Patterns ===

--- Semantic Requirements ---
  Tooltips are supplementary text hints. They should:
  ✓ Contain only text (no interactive elements)
  ✓ Be accessible via hover AND focus
  ✓ Not be the only way to access information
  ✓ Not contain critical content

  If you need interactive content → use a popover, not tooltip.

--- CSS-Only Tooltip ---
  <button data-tooltip="Copy to clipboard" class="tooltip-trigger">
    📋 Copy
  </button>

  .tooltip-trigger {
    position: relative;
  }

  .tooltip-trigger::after {
    content: attr(data-tooltip);
    position: absolute;
    bottom: 100%;
    left: 50%;
    transform: translateX(-50%);
    padding: 4px 8px;
    background: #333;
    color: white;
    border-radius: 4px;
    font-size: 12px;
    white-space: nowrap;
    opacity: 0;
    pointer-events: none;
    transition: opacity 150ms;
  }

  .tooltip-trigger:hover::after,
  .tooltip-trigger:focus-visible::after {
    opacity: 1;
  }

--- Accessible Tooltip (ARIA) ---
  <button aria-describedby="tip1">
    Delete
  </button>
  <div id="tip1" role="tooltip" hidden>
    Permanently remove this item
  </div>

  role="tooltip" — tells screen reader this is supplementary text
  aria-describedby — connects trigger to tooltip content

--- Delay and Debounce ---
  Show delay: 300-500ms (prevent accidental trigger)
  Hide delay: 100-200ms (allow moving to tooltip)
  Instant show: If another tooltip was recently shown (warm-up)

  let showTimeout, hideTimeout;

  trigger.addEventListener('mouseenter', () => {
    clearTimeout(hideTimeout);
    showTimeout = setTimeout(() => showTooltip(), 400);
  });

  trigger.addEventListener('mouseleave', () => {
    clearTimeout(showTimeout);
    hideTimeout = setTimeout(() => hideTooltip(), 150);
  });

--- Touch Devices ---
  No hover on touch! Options:
  1. Long press to show tooltip
  2. Don't show tooltips (use labels instead)
  3. First tap shows tooltip, second tap activates
  4. Show on focus (tappable elements get focus)

  @media (hover: none) {
    .tooltip::after { display: none; }
  }

--- Common Tooltip Content ---
  ✓ Keyboard shortcut:  "Undo (Ctrl+Z)"
  ✓ Full label:         Truncated text → full text
  ✓ Status info:        "Last saved 5 minutes ago"
  ✓ Disambiguation:     Icon-only buttons → "Settings"

  ✗ Essential info:     Don't hide critical content in tooltips
  ✗ Forms/links:        Use popover for interactive content
  ✗ Long text:          Keep under ~80 characters
EOF
}

cmd_dropdown() {
    cat << 'EOF'
=== Dropdown Menus ===

--- Basic Pattern ---
  <div class="dropdown">
    <button aria-expanded="false" aria-haspopup="true"
            aria-controls="menu1">
      Options ▾
    </button>
    <ul id="menu1" role="menu" hidden>
      <li role="menuitem"><button>Edit</button></li>
      <li role="menuitem"><button>Duplicate</button></li>
      <li role="separator"></li>
      <li role="menuitem"><button>Delete</button></li>
    </ul>
  </div>

--- ARIA Roles ---
  role="menu"        Container for menu items
  role="menuitem"    Clickable menu option
  role="menubar"     Horizontal menu bar (like app menus)
  role="separator"   Visual divider between groups
  aria-expanded      "true" when open, "false" when closed
  aria-haspopup      "true" indicates element opens a popup
  aria-controls      Points to the menu element ID

--- Keyboard Navigation ---
  Enter/Space    Open menu + focus first item
  Escape         Close menu, return focus to trigger
  ↓ Arrow Down   Move to next item
  ↑ Arrow Up     Move to previous item
  Home           Move to first item
  End            Move to last item
  A-Z            Jump to item starting with letter
  Tab            Close menu and move to next element

--- Implementation ---
  const trigger = document.querySelector('.trigger');
  const menu = document.querySelector('[role="menu"]');
  const items = menu.querySelectorAll('[role="menuitem"]');
  let activeIndex = -1;

  trigger.addEventListener('click', () => {
    const isOpen = trigger.getAttribute('aria-expanded') === 'true';
    trigger.setAttribute('aria-expanded', !isOpen);
    menu.hidden = isOpen;
    if (!isOpen) {
      activeIndex = 0;
      items[0].focus();
    }
  });

  menu.addEventListener('keydown', (e) => {
    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault();
        activeIndex = (activeIndex + 1) % items.length;
        items[activeIndex].focus();
        break;
      case 'ArrowUp':
        e.preventDefault();
        activeIndex = (activeIndex - 1 + items.length) % items.length;
        items[activeIndex].focus();
        break;
      case 'Escape':
        menu.hidden = true;
        trigger.setAttribute('aria-expanded', 'false');
        trigger.focus();
        break;
    }
  });

--- Nested Menus ---
  <li role="menuitem" aria-haspopup="true" aria-expanded="false">
    Share →
    <ul role="menu" hidden>
      <li role="menuitem">Email</li>
      <li role="menuitem">Slack</li>
    </ul>
  </li>

  Open submenu on: ArrowRight or hover (with delay)
  Close submenu on: ArrowLeft or Escape
  Challenge: diagonal mouse movement (use "safe triangle" pattern)
EOF
}

cmd_css() {
    cat << 'EOF'
=== Popover CSS ===

--- Basic Popover Styling ---
  [popover] {
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    padding: 12px 16px;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
    max-width: 320px;
  }

  /* Remove default border/padding */
  [popover] {
    border: none;
    padding: 0;
    background: transparent;
  }

--- Animations ---
  /* Entry animation */
  [popover]:popover-open {
    opacity: 1;
    transform: scale(1);
  }

  /* Starting style for animation (Chrome 117+) */
  @starting-style {
    [popover]:popover-open {
      opacity: 0;
      transform: scale(0.95);
    }
  }

  /* Exit animation */
  [popover] {
    transition: opacity 150ms, transform 150ms,
                display 150ms allow-discrete,
                overlay 150ms allow-discrete;
    opacity: 0;
    transform: scale(0.95);
  }

  /* allow-discrete enables transition of display: none → block */

--- :popover-open Pseudo-Class ---
  [popover]:popover-open {
    /* styles when popover is visible */
  }

  [popover]:not(:popover-open) {
    /* styles when popover is hidden */
  }

--- Backdrop ---
  [popover]::backdrop {
    /* Transparent by default (unlike dialog) */
    background: rgba(0, 0, 0, 0.1);
  }

  /* Usually don't want backdrop for popovers */
  /* But useful for mobile full-screen menus */

--- CSS Anchor Positioning ---
  .trigger { anchor-name: --btn; }

  [popover] {
    position: fixed;
    position-anchor: --btn;
    inset-area: bottom;
    margin-top: 8px;

    /* Auto-flip */
    position-try-options: flip-block;
  }

  /* Available inset-area values: */
  /* top, bottom, left, right */
  /* top span-left, bottom span-right, etc. */
  /* center (centered on anchor) */

--- Arrow with CSS ---
  .popover-arrow {
    position: absolute;
    width: 12px;
    height: 12px;
    background: inherit;
    border: inherit;
    border-right: none;
    border-bottom: none;
    transform: rotate(45deg);
    /* Bottom placement: arrow at top */
    top: -7px;
    left: calc(50% - 6px);
  }
EOF
}

cmd_accessibility() {
    cat << 'EOF'
=== Accessible Popovers ===

--- Tooltip Accessibility ---
  <button aria-describedby="tooltip-1">ℹ️</button>
  <span role="tooltip" id="tooltip-1" popover>
    Additional information about this feature
  </span>

  role="tooltip" — semantic meaning
  aria-describedby — links trigger to tooltip
  Must appear on hover AND focus

--- Menu Accessibility ---
  See dropdown command for full ARIA menu pattern.
  Key requirements:
    role="menu" + role="menuitem"
    aria-expanded on trigger
    Arrow key navigation
    Type-ahead (first letter)

--- Disclosure Pattern (Simple Popover) ---
  <button aria-expanded="false" aria-controls="details-1">
    More info
  </button>
  <div id="details-1" popover>
    <p>Detailed information here.</p>
    <a href="/learn-more">Learn more</a>
  </div>

  // Update aria-expanded on toggle:
  button.addEventListener('click', () => {
    const expanded = button.getAttribute('aria-expanded') === 'true';
    button.setAttribute('aria-expanded', !expanded);
  });

--- Dialog-like Popover ---
  For popovers with complex interactive content:
  <div popover role="dialog" aria-label="Share options">
    <h3>Share</h3>
    <button>Copy link</button>
    <button>Email</button>
    <button>Twitter</button>
  </div>

  Use role="dialog" when popover has:
    - Multiple interactive elements
    - Complex content structure
    - Need for focus management

--- Focus Management ---
  Auto popovers: focus does NOT automatically move into popover
  (Unlike modal dialogs)

  For interactive popovers, manually manage focus:
    popover.addEventListener('toggle', (e) => {
      if (e.newState === 'open') {
        const firstFocusable = popover.querySelector('button, [href], input');
        firstFocusable?.focus();
      }
    });

--- Screen Reader Testing ---
  ✓ Tooltip content announced when trigger focused
  ✓ Menu items navigable with arrow keys
  ✓ Expanded/collapsed state announced
  ✓ Popover content reachable in browse mode
  ✓ Dismissal announced (or popover simply disappears)

--- WAI-ARIA Patterns ---
  Tooltip:     role="tooltip" + aria-describedby
  Menu:        role="menu" + role="menuitem"
  Listbox:     role="listbox" + role="option" (autocomplete)
  Tree:        role="tree" + role="treeitem" (nested menus)
  Dialog:      role="dialog" (complex interactive popovers)
  Combobox:    role="combobox" + listbox (search + dropdown)
EOF
}

cmd_libraries() {
    cat << 'EOF'
=== Popover Libraries ===

--- Floating UI (Successor to Popper.js) ---
  The gold standard for floating element positioning.

  npm install @floating-ui/dom

  import { computePosition, flip, shift, offset, arrow } from '@floating-ui/dom';

  Features:
    ✓ 12 placement options with auto-flip
    ✓ Viewport-aware shifting
    ✓ Arrow positioning
    ✓ Virtual element support (cursor, selection)
    ✓ Scroll and resize handling
    ✓ Tree-shakeable (only import what you need)
    ✓ Framework packages: @floating-ui/react, @floating-ui/vue

  Size: ~2KB gzipped (core)

--- Tippy.js ---
  Batteries-included tooltip/popover library.
  Built on Floating UI.

  npm install tippy.js

  import tippy from 'tippy.js';
  tippy('#myButton', {
    content: 'Tooltip text',
    placement: 'top',
    animation: 'fade',
    delay: [300, 100],
    interactive: true,
    trigger: 'click',
  });

  Features:
    ✓ Declarative API
    ✓ Themes and animations
    ✓ Singleton (only one visible at a time)
    ✓ Follow cursor mode
    ✓ Headless mode (bring your own styles)

  Size: ~10KB gzipped

--- Radix UI (React) ---
  @radix-ui/react-popover
  @radix-ui/react-tooltip
  @radix-ui/react-dropdown-menu

  Unstyled, accessible primitives:
  <Popover.Root>
    <Popover.Trigger>Click me</Popover.Trigger>
    <Popover.Portal>
      <Popover.Content>
        Content here
        <Popover.Arrow />
      </Popover.Content>
    </Popover.Portal>
  </Popover.Root>

--- Headless UI ---
  @headlessui/react, @headlessui/vue

  Designed for Tailwind CSS:
  <Popover>
    <Popover.Button>Solutions</Popover.Button>
    <Popover.Panel className="absolute z-10">
      Panel content
    </Popover.Panel>
  </Popover>

--- Native (No Library) ---
  Modern browsers support:
  1. HTML popover attribute — top layer, light dismiss
  2. CSS anchor positioning — relative positioning
  3. Combine both for full-featured popovers

  When you can use native:
    ✓ Modern browser targets (Chrome 114+, FF 125+, Safari 17+)
    ✓ Simple tooltip/popover needs
    ✓ Want zero JS bundle impact

  When you need a library:
    ✓ Supporting older browsers
    ✓ Complex positioning (virtual elements, nested scrolls)
    ✓ Advanced features (animations, follow cursor)
    ✓ Framework integration (React/Vue state management)
EOF
}

show_help() {
    cat << EOF
popover v$VERSION — Popover & Tooltip Reference

Usage: script.sh <command>

Commands:
  intro          Popover vs tooltip vs modal, key challenges
  api            HTML Popover API: popover attr, events, top layer
  positioning    CSS anchor positioning, Floating UI, flip/shift
  tooltip        Tooltip patterns: delay, touch, accessible tooltips
  dropdown       Dropdown menus: ARIA, keyboard nav, nested menus
  css            Popover CSS: animations, @starting-style, anchor
  accessibility  ARIA patterns, screen readers, focus management
  libraries      Floating UI, Tippy.js, Radix, Headless UI
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)         cmd_intro ;;
    api)           cmd_api ;;
    positioning)   cmd_positioning ;;
    tooltip)       cmd_tooltip ;;
    dropdown)      cmd_dropdown ;;
    css)           cmd_css ;;
    accessibility) cmd_accessibility ;;
    libraries)     cmd_libraries ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "popover v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
