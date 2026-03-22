#!/usr/bin/env bash
# header — Web Header & Navigation Design Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Web Header Design ===

The header is the first thing users see. It establishes brand identity,
provides navigation, and sets the tone for the entire site experience.
Users spend 80% of their attention above the fold.

Purpose of a Header:
  1. Brand identity (logo, company name)
  2. Primary navigation (main site sections)
  3. Utility actions (search, login, cart, language)
  4. Trust establishment (first impression)
  5. Wayfinding (where am I? where can I go?)

Anatomy of a Header:
  ┌──────────────────────────────────────────┐
  │  [Logo]     Nav1  Nav2  Nav3    [🔍] [👤]│
  └──────────────────────────────────────────┘

  Extended:
  ┌──────────────────────────────────────────┐
  │  Top Bar: Phone | Email | Language | Login│
  ├──────────────────────────────────────────┤
  │  [Logo]     Nav1  Nav2  Nav3  Nav4  [CTA]│
  └──────────────────────────────────────────┘

Design Principles:
  - Keep it simple: 5-7 main nav items maximum
  - Logo top-left (or center for certain brands)
  - Clear visual hierarchy (primary nav > secondary > utility)
  - Consistent across all pages
  - Fast to load (no heavy images, lazy-load non-critical)
  - Height: 60-80px typical (larger for hero headers)

Common Mistakes:
  ✗ Too many nav items (cognitive overload)
  ✗ Tiny click/tap targets (minimum 44×44px)
  ✗ Logo not linking to homepage
  ✗ No visual indication of current page
  ✗ Header taking up too much vertical space on mobile
  ✗ Dropdown menus that disappear too quickly
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Navigation Patterns ===

1. Horizontal Navigation Bar:
   The standard. Links arranged left-to-right.
   Best for: 3-7 top-level items
   [Logo]  Home  Products  About  Blog  Contact  [CTA]

2. Mega Menu:
   Dropdown that spans the full width with organized content
   Best for: large sites with many sections (e-commerce, enterprise)
   Features:
     - Multi-column layout within dropdown
     - Can include images, icons, descriptions
     - Group links by category
     - Featured content or promotions
   Example: Amazon, Microsoft, Best Buy

3. Dropdown / Flyout Menu:
   Single-column dropdown appearing on hover or click
   Best for: moderate hierarchy (2-3 levels)
   Hover delay: 300-400ms prevents accidental triggers
   Click preferred on touch devices

4. Sidebar Navigation:
   Vertical nav on left (or right) side
   Best for: apps, dashboards, documentation
   Can be collapsible (hamburger toggle)
   Persistent = always visible, Overlay = slides over content

5. Breadcrumbs:
   Shows current location in site hierarchy
   Home > Category > Subcategory > Current Page
   Best for: deep hierarchies, e-commerce
   Always secondary to main nav (supplementary)

6. Tab Navigation:
   Tabs along the top (resembles browser tabs)
   Best for: related content sections on same page
   Active tab visually connected to content below

7. Priority+ Pattern:
   Shows as many items as fit, hides rest under "More" menu
   Best for: responsive nav without hamburger menu
   Adapts to screen width dynamically
   Requires JavaScript for calculation

8. Bottom Navigation (Mobile):
   Fixed bar at bottom with 3-5 icons
   Best for: mobile apps, PWAs
   Pattern from iOS/Android native apps
   Don't use for desktop websites
EOF
}

cmd_sticky() {
    cat << 'EOF'
=== Sticky & Fixed Headers ===

Fixed Header (Always Visible):
  header {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    z-index: 1000;
  }
  body {
    padding-top: 70px;  /* = header height */
  }
  Pros: navigation always accessible
  Cons: takes up permanent screen space

Sticky Header:
  header {
    position: sticky;
    top: 0;
    z-index: 1000;
  }
  Pros: simpler CSS, no padding needed, natural flow
  Cons: less browser support in older browsers (fine today)

Shrinking Header on Scroll:
  Initial: tall header (100px) with large logo
  After scroll: compact header (60px) with smaller logo
  Implementation: toggle CSS class on scroll via JS

  window.addEventListener('scroll', () => {
    const header = document.querySelector('header');
    if (window.scrollY > 50) {
      header.classList.add('header--compact');
    } else {
      header.classList.remove('header--compact');
    }
  });

  .header--compact {
    height: 60px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  }

Hide on Scroll Down, Show on Scroll Up:
  Popular pattern (Medium, many mobile sites)
  Saves screen space while scrolling content
  Shows header immediately when user scrolls up

  let lastScroll = 0;
  window.addEventListener('scroll', () => {
    const current = window.scrollY;
    if (current > lastScroll && current > 80) {
      header.classList.add('header--hidden');
    } else {
      header.classList.remove('header--hidden');
    }
    lastScroll = current;
  });

  .header--hidden {
    transform: translateY(-100%);
    transition: transform 0.3s ease;
  }

Transparent → Solid on Scroll:
  Hero section: transparent header with white text
  After scroll: solid background with dark text
  Common on landing pages with hero images
  Transition: background-color and color with smooth animation

Performance Tips:
  - Use will-change: transform on animated headers
  - Debounce scroll events or use IntersectionObserver
  - Avoid layout thrashing (read then write, not interleaved)
  - Use transform instead of top for animations (GPU accelerated)
EOF
}

cmd_responsive() {
    cat << 'EOF'
=== Responsive Navigation ===

Hamburger Menu:
  The ☰ icon that toggles a mobile menu
  Placement: top-right (most common) or top-left
  Animation: slide from right, slide from top, or fade in

  Hamburger Icon CSS (pure CSS):
    .hamburger {
      width: 30px; height: 20px;
      display: flex; flex-direction: column;
      justify-content: space-between;
      cursor: pointer;
    }
    .hamburger span {
      width: 100%; height: 3px;
      background: #333;
      transition: all 0.3s;
    }
    /* Animate to X when open */
    .hamburger.open span:nth-child(1) {
      transform: translateY(8.5px) rotate(45deg);
    }
    .hamburger.open span:nth-child(2) { opacity: 0; }
    .hamburger.open span:nth-child(3) {
      transform: translateY(-8.5px) rotate(-45deg);
    }

Off-Canvas Menu:
  Full-height panel slides in from left or right
  Overlay dims the main content
  Close: X button, tap overlay, or swipe
  Best for: deep navigation, many items

  .nav-overlay {
    position: fixed; inset: 0;
    background: rgba(0,0,0,0.5);
    z-index: 999;
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s;
  }
  .nav-panel {
    position: fixed; top: 0; left: -280px;
    width: 280px; height: 100%;
    background: white;
    z-index: 1000;
    transition: left 0.3s;
  }
  .nav-open .nav-panel { left: 0; }
  .nav-open .nav-overlay { opacity: 1; visibility: visible; }

Breakpoint Strategy:
  Mobile-first approach:
    Default: hamburger menu
    @media (min-width: 768px): show horizontal nav, hide hamburger
    @media (min-width: 1024px): full mega menu capability

  .nav-toggle { display: block; }
  .nav-links { display: none; }

  @media (min-width: 768px) {
    .nav-toggle { display: none; }
    .nav-links { display: flex; }
  }

Touch Considerations:
  - Hover doesn't work on touch — use click for dropdowns
  - Tap targets: minimum 44×44px
  - Swipe gestures for off-canvas menus
  - No double-tap needed (instant response)
EOF
}

cmd_html() {
    cat << 'EOF'
=== Semantic HTML for Headers ===

Basic Structure:
  <header role="banner">
    <a href="/" class="logo" aria-label="Company Name - Home">
      <img src="/logo.svg" alt="Company Name" width="120" height="40">
    </a>
    <nav aria-label="Main navigation">
      <ul>
        <li><a href="/" aria-current="page">Home</a></li>
        <li><a href="/products">Products</a></li>
        <li><a href="/about">About</a></li>
        <li><a href="/contact">Contact</a></li>
      </ul>
    </nav>
    <button
      class="nav-toggle"
      aria-expanded="false"
      aria-controls="mobile-nav"
      aria-label="Toggle navigation menu"
    >
      <span></span><span></span><span></span>
    </button>
  </header>

Skip Navigation Link:
  First element in <body>, before <header>:
  <a href="#main-content" class="skip-link">
    Skip to main content
  </a>

  CSS (visible only on focus):
  .skip-link {
    position: absolute;
    top: -40px; left: 0;
    background: #000; color: #fff;
    padding: 8px 16px;
    z-index: 10000;
  }
  .skip-link:focus {
    top: 0;
  }

Key ARIA Attributes:
  aria-current="page"     Mark the current page link
  aria-expanded="false"   Hamburger button state (false/true)
  aria-controls="id"      Connect button to controlled element
  aria-haspopup="true"    Button opens a dropdown/menu
  aria-label="..."        Descriptive label when text is insufficient

Dropdown Menu HTML:
  <li class="has-dropdown">
    <button aria-expanded="false" aria-haspopup="true">
      Products <span aria-hidden="true">▾</span>
    </button>
    <ul role="menu" hidden>
      <li role="menuitem"><a href="/product-a">Product A</a></li>
      <li role="menuitem"><a href="/product-b">Product B</a></li>
    </ul>
  </li>

  Toggle aria-expanded and hidden attribute with JavaScript
  Use <button> not <a> for toggle controls (semantic intent)

Logo Best Practices:
  - Always link to homepage
  - Include alt text with company name
  - Set width and height to prevent CLS (Cumulative Layout Shift)
  - Use SVG for crisp rendering at all sizes
  - Provide aria-label on the link if logo is decorative
EOF
}

cmd_css() {
    cat << 'EOF'
=== CSS Patterns for Headers ===

Flexbox Header Layout:
  .header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 1.5rem;
    height: 70px;
    background: #fff;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  }
  .logo { flex-shrink: 0; }
  .nav-links {
    display: flex;
    gap: 2rem;
    list-style: none;
    margin: 0; padding: 0;
  }
  .nav-actions {
    display: flex;
    gap: 1rem;
    align-items: center;
  }

Navigation Link Styles:
  .nav-links a {
    text-decoration: none;
    color: #333;
    font-weight: 500;
    padding: 0.5rem 0;
    position: relative;
    transition: color 0.2s;
  }
  .nav-links a:hover,
  .nav-links a[aria-current="page"] {
    color: #0066cc;
  }
  /* Underline indicator */
  .nav-links a::after {
    content: '';
    position: absolute;
    bottom: 0; left: 0;
    width: 0; height: 2px;
    background: #0066cc;
    transition: width 0.3s;
  }
  .nav-links a:hover::after,
  .nav-links a[aria-current="page"]::after {
    width: 100%;
  }

Dropdown Menu CSS:
  .has-dropdown { position: relative; }
  .has-dropdown ul {
    position: absolute;
    top: 100%;
    left: 0;
    min-width: 200px;
    background: white;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    border-radius: 8px;
    padding: 0.5rem 0;
    opacity: 0;
    transform: translateY(-10px);
    transition: all 0.2s;
    pointer-events: none;
  }
  .has-dropdown ul[aria-hidden="false"],
  .has-dropdown:hover ul {
    opacity: 1;
    transform: translateY(0);
    pointer-events: auto;
  }
  .has-dropdown li a {
    display: block;
    padding: 0.5rem 1rem;
    white-space: nowrap;
  }
  .has-dropdown li a:hover {
    background: #f5f5f5;
  }

CTA Button in Header:
  .header-cta {
    background: #0066cc;
    color: white;
    padding: 0.5rem 1.25rem;
    border-radius: 6px;
    border: none;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.2s;
  }
  .header-cta:hover { background: #0052a3; }
EOF
}

cmd_accessibility() {
    cat << 'EOF'
=== Header Accessibility ===

Keyboard Navigation:
  Tab through all interactive elements in order
  Enter/Space activates buttons and links
  Escape closes dropdowns and mobile menus
  Arrow keys navigate within dropdown menus (optional but nice)

  Dropdown keyboard pattern:
    Enter/Space on trigger → open dropdown, focus first item
    Down arrow → next item
    Up arrow → previous item
    Escape → close dropdown, return focus to trigger
    Tab → close dropdown, move to next element

Focus Management:
  When hamburger menu opens:
    1. Move focus to the first link in the menu
    2. Trap focus within the menu (can't tab out)
    3. On close: return focus to the hamburger button

  Focus trap implementation:
    - Track all focusable elements in the menu
    - On Tab at last element → loop to first
    - On Shift+Tab at first → loop to last

  Code concept:
    const focusable = menu.querySelectorAll(
      'a, button, input, [tabindex]'
    );
    const first = focusable[0];
    const last = focusable[focusable.length - 1];

Screen Reader Considerations:
  - <header> + <nav> provide automatic landmarks
  - Announce current page: aria-current="page"
  - Announce menu state: aria-expanded="true/false"
  - Hide decorative icons: aria-hidden="true"
  - Announce dropdown: aria-haspopup="true"
  - Don't hide skip-link permanently (only visually until focus)

WCAG Checklist for Headers:
  [ ] Skip navigation link present and functional
  [ ] Logo has alt text and links to home
  [ ] Current page is indicated (aria-current)
  [ ] All links have descriptive text
  [ ] Color contrast: 4.5:1 for normal text
  [ ] Focus indicators visible on all interactive elements
  [ ] Dropdown menus keyboard accessible
  [ ] Mobile menu has focus trap and Escape to close
  [ ] Touch targets >= 44×44px
  [ ] No content visible only on hover (must be accessible)

Reduced Motion:
  @media (prefers-reduced-motion: reduce) {
    .header, .nav-links a::after, .dropdown {
      transition: none;
    }
  }
  Respects users who are sensitive to motion/animation
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Header Implementation Examples ===

--- Simple Corporate Header ---
<header class="header">
  <a href="/" aria-label="Acme Corp Home">
    <img src="/logo.svg" alt="Acme Corp" width="120" height="36">
  </a>
  <nav aria-label="Main">
    <ul class="nav-links">
      <li><a href="/solutions">Solutions</a></li>
      <li><a href="/pricing">Pricing</a></li>
      <li><a href="/resources">Resources</a></li>
      <li><a href="/company" aria-current="page">Company</a></li>
    </ul>
  </nav>
  <div class="nav-actions">
    <a href="/login">Log in</a>
    <a href="/signup" class="header-cta">Get Started</a>
  </div>
</header>

--- E-commerce Header with Search ---
<header class="header">
  <button class="nav-toggle" aria-label="Menu" aria-expanded="false">
    ☰
  </button>
  <a href="/" class="logo">
    <img src="/logo.svg" alt="ShopName" width="100" height="32">
  </a>
  <form class="search-bar" role="search" aria-label="Site search">
    <input type="search" placeholder="Search products..."
      aria-label="Search products">
    <button type="submit" aria-label="Search">🔍</button>
  </form>
  <nav class="nav-actions" aria-label="Account">
    <a href="/account" aria-label="My Account">👤</a>
    <a href="/wishlist" aria-label="Wishlist (3 items)">♡ 3</a>
    <a href="/cart" aria-label="Shopping Cart (2 items)">🛒 2</a>
  </nav>
</header>

--- Header with Mega Menu ---
Key structure:
  <nav aria-label="Main navigation">
    <ul>
      <li class="mega-dropdown">
        <button aria-expanded="false" aria-haspopup="true">
          Products ▾
        </button>
        <div class="mega-panel" hidden>
          <div class="mega-column">
            <h3>Software</h3>
            <ul> ... </ul>
          </div>
          <div class="mega-column">
            <h3>Hardware</h3>
            <ul> ... </ul>
          </div>
          <div class="mega-feature">
            <img src="/promo.jpg" alt="New Product Launch">
            <a href="/new">See what's new →</a>
          </div>
        </div>
      </li>
    </ul>
  </nav>
EOF
}

show_help() {
    cat << EOF
header v$VERSION — Web Header & Navigation Design Reference

Usage: script.sh <command>

Commands:
  intro         Header purpose, anatomy, and design principles
  patterns      Nav patterns — horizontal, mega menu, sidebar, tabs
  sticky        Sticky/fixed headers — scroll effects, show/hide
  responsive    Responsive nav — hamburger, off-canvas, breakpoints
  html          Semantic HTML — landmarks, ARIA, skip nav
  css           CSS patterns — flexbox layouts, dropdowns, CTAs
  accessibility Keyboard nav, focus management, screen readers
  examples      Code snippets for common header types
  help          Show this help
  version       Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)         cmd_intro ;;
    patterns)      cmd_patterns ;;
    sticky)        cmd_sticky ;;
    responsive)    cmd_responsive ;;
    html)          cmd_html ;;
    css)           cmd_css ;;
    accessibility) cmd_accessibility ;;
    examples)      cmd_examples ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "header v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
