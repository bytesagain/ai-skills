#!/usr/bin/env bash
# footer — Web Footer Design & Implementation Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Web Footer Design ===

The footer is the bottom section of every web page. Despite being "below
the fold," it's one of the most visited areas — users scroll down when
they can't find what they need in the main content.

Purpose of a Footer:
  1. Navigation safety net (links users couldn't find above)
  2. Trust signals (company info, certifications, social proof)
  3. Legal compliance (copyright, privacy policy, terms)
  4. Contact information (address, phone, email)
  5. Secondary actions (newsletter signup, app download)

Anatomy of a Great Footer:
  ┌────────────────────────────────────────────┐
  │  Brand / Logo                              │
  │                                            │
  │  Column 1     Column 2     Column 3        │
  │  - Link       - Link       - Link          │
  │  - Link       - Link       - Link          │
  │  - Link       - Link       - Link          │
  │                                            │
  │  Newsletter Signup          Social Icons    │
  │                                            │
  │  ─────────────────────────────────────────  │
  │  © 2024 Company  |  Privacy  |  Terms      │
  └────────────────────────────────────────────┘

Design Principles:
  - Consistent across all pages
  - Clear visual separation from main content
  - Readable text (adequate contrast, not too small)
  - Don't overload — prioritize what users actually need
  - Mobile-friendly (stacked columns, larger tap targets)

What NOT to Put in a Footer:
  - Primary CTAs (they belong above the fold)
  - Duplicate of the entire main navigation
  - Auto-playing media or animations
  - Excessive social media feeds
  - Walls of unformatted text
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Footer Layout Patterns ===

1. Minimal Footer:
   Just the essentials — copyright + key links
   Best for: landing pages, apps, simple sites
   Example:
     © 2024 Acme Inc. · Privacy · Terms · Contact

2. Fat Footer (Most Common):
   Multiple columns of organized links + contact info
   Best for: corporate sites, SaaS, e-commerce
   Structure:
     3-5 columns: Products | Resources | Company | Support | Legal
     Bottom bar: copyright + social icons

3. Mega Footer:
   Expanded sitemap-style with many link categories
   Best for: large sites (Amazon, Apple, Microsoft)
   Can include 50+ links organized in 5-8 columns
   Risk: overwhelming on mobile — use accordions

4. CTA Footer:
   Features a prominent call-to-action above the links
   Best for: lead generation, SaaS conversion
   Example:
     ┌─────────────────────────────┐
     │  Ready to get started?      │
     │  [Start Free Trial]         │
     ├─────────────────────────────┤
     │  Product  |  Company  |  …  │
     └─────────────────────────────┘

5. Social-Centric Footer:
   Social media icons are the primary feature
   Best for: media companies, influencers, brands
   Large social icons + minimal text links below

6. Contact Footer:
   Contact info is prominent (map, address, phone, hours)
   Best for: local businesses, restaurants, services
   Often includes an embedded Google Map

7. Newsletter Footer:
   Email signup form is the hero element
   Best for: blogs, content sites, publishers
   Simple: email input + subscribe button + privacy note

Column Count by Screen:
  Desktop:   3-5 columns side by side
  Tablet:    2-3 columns
  Mobile:    1 column (stacked) or accordion menus
EOF
}

cmd_sticky() {
    cat << 'EOF'
=== Sticky Footer Techniques ===

Problem: When page content is shorter than the viewport, the footer
floats in the middle of the screen instead of staying at the bottom.

Method 1: Flexbox (Recommended)
  html, body {
    height: 100%;
    margin: 0;
  }
  body {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
  }
  main {
    flex: 1;            /* main content grows to fill space */
  }
  footer {
    flex-shrink: 0;     /* footer doesn't shrink */
  }

Method 2: CSS Grid
  body {
    display: grid;
    grid-template-rows: auto 1fr auto;
    min-height: 100vh;
    margin: 0;
  }
  /* header = row 1, main = row 2 (1fr), footer = row 3 */

Method 3: calc() with Fixed Footer Height
  footer {
    height: 80px;       /* known height */
  }
  main {
    min-height: calc(100vh - 80px - [header-height]);
  }
  Downside: footer height must be known and fixed

Method 4: Fixed Footer (Always Visible)
  footer {
    position: fixed;
    bottom: 0;
    left: 0;
    width: 100%;
    z-index: 100;
  }
  body {
    padding-bottom: 80px;  /* prevent content hiding behind footer */
  }
  Use case: persistent nav bars, cookie banners, chat widgets
  Caution: takes up screen space — avoid for content-heavy footers

Method 5: Sticky Position
  footer {
    position: sticky;
    bottom: 0;
  }
  Note: sticky + bottom doesn't work like sticky + top
  Requires the footer to be inside a tall container

Best Practice:
  Use Flexbox (Method 1) for most cases
  Use Grid (Method 2) when using CSS Grid layout already
  Avoid fixed footers unless truly necessary (e.g., cookie bar)
EOF
}

cmd_html() {
    cat << 'EOF'
=== Semantic HTML for Footers ===

Basic Structure:
  <footer role="contentinfo">
    <div class="footer-content">
      <nav aria-label="Footer navigation">
        <h2 class="sr-only">Footer Menu</h2>
        <!-- link columns -->
      </nav>
      <div class="footer-bottom">
        <p>&copy; 2024 Company Name. All rights reserved.</p>
      </div>
    </div>
  </footer>

Key HTML Elements:
  <footer>      Semantic landmark — screen readers announce it
  <nav>         For navigation link groups within footer
  <address>     For contact information (auto-styled italic)
  <small>       For copyright and fine print
  <ul> / <li>   For link lists (accessible, semantic)

ARIA Roles & Labels:
  role="contentinfo"     Implicit on <footer> (don't duplicate)
  aria-label="Footer"    Only if multiple <footer> elements exist
  aria-label="Footer navigation"  On <nav> elements in footer
  Multiple <nav>?        Each needs a unique aria-label

Example with Multiple Sections:
  <footer>
    <nav aria-label="Products">
      <h3>Products</h3>
      <ul>
        <li><a href="/features">Features</a></li>
        <li><a href="/pricing">Pricing</a></li>
      </ul>
    </nav>

    <nav aria-label="Company">
      <h3>Company</h3>
      <ul>
        <li><a href="/about">About</a></li>
        <li><a href="/careers">Careers</a></li>
      </ul>
    </nav>

    <address>
      <p>123 Main St, City, State 12345</p>
      <p><a href="mailto:hello@example.com">hello@example.com</a></p>
    </address>

    <small>&copy; 2024 Company. All rights reserved.</small>
  </footer>

Common Mistakes:
  ✗ Using <div> instead of <footer>
  ✗ Putting navigation links without <nav>
  ✗ Missing heading hierarchy (use sr-only headings if visual clutter)
  ✗ Links without descriptive text ("click here")
  ✗ Missing lang attribute on multi-language content
EOF
}

cmd_css() {
    cat << 'EOF'
=== CSS Patterns for Responsive Footers ===

Base Footer Styles:
  .footer {
    background-color: #1a1a2e;
    color: #e0e0e0;
    padding: 3rem 1.5rem 1.5rem;
    font-size: 0.875rem;
    line-height: 1.6;
  }

Multi-Column with Flexbox:
  .footer-columns {
    display: flex;
    flex-wrap: wrap;
    gap: 2rem;
    max-width: 1200px;
    margin: 0 auto;
  }
  .footer-column {
    flex: 1;
    min-width: 200px;   /* triggers wrapping on small screens */
  }
  .footer-column h3 {
    font-size: 1rem;
    margin-bottom: 1rem;
    color: #ffffff;
  }
  .footer-column ul {
    list-style: none;
    padding: 0;
  }
  .footer-column a {
    color: #b0b0b0;
    text-decoration: none;
    display: block;
    padding: 0.25rem 0;
    transition: color 0.2s;
  }
  .footer-column a:hover {
    color: #ffffff;
  }

Multi-Column with Grid:
  .footer-columns {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 2rem;
    max-width: 1200px;
    margin: 0 auto;
  }

Bottom Bar:
  .footer-bottom {
    border-top: 1px solid #333;
    margin-top: 2rem;
    padding-top: 1.5rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 1rem;
  }

Social Icons:
  .social-links {
    display: flex;
    gap: 1rem;
  }
  .social-links a {
    display: inline-flex;
    width: 40px;
    height: 40px;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background: #333;
    transition: background 0.2s;
  }
  .social-links a:hover {
    background: #555;
  }

Mobile Responsive:
  @media (max-width: 768px) {
    .footer-columns {
      flex-direction: column;
      gap: 1.5rem;
    }
    .footer-bottom {
      flex-direction: column;
      text-align: center;
    }
  }
EOF
}

cmd_legal() {
    cat << 'EOF'
=== Legal & Compliance Content in Footers ===

Copyright Notice:
  Format: © [Year] [Company Name]. All rights reserved.
  Year: use creation year or range (e.g., © 2020-2024)
  "All rights reserved" is optional but conventional
  Auto-update year: use server-side or JS for current year
  HTML entity: &copy; or ©

Required Legal Links (varies by jurisdiction):

  Universal:
    - Privacy Policy (required if collecting ANY data)
    - Terms of Service / Terms of Use
    - Cookie Policy (if using cookies)

  EU/GDPR:
    - Privacy Policy (detailed, GDPR-compliant)
    - Cookie consent banner (not just a link)
    - Data Processing Agreement (B2B)
    - Right to erasure / data portability info
    - DPO contact information

  US/California (CCPA/CPRA):
    - "Do Not Sell My Personal Information" link
    - Privacy Policy with CCPA disclosures
    - Categories of data collected and shared

  E-commerce:
    - Return/Refund Policy
    - Shipping Policy
    - Terms of Sale
    - Company registration number (EU)
    - VAT number (if applicable)

  Accessibility:
    - Accessibility Statement (ADA / EAA compliance)
    - Link to VPAT if available
    - Contact for accessibility issues

Cookie Consent (GDPR):
  Must appear BEFORE setting non-essential cookies
  Required elements:
    - Clear explanation of cookie types
    - Accept / Reject buttons (equal prominence)
    - Link to full cookie policy
    - Granular consent options (analytics, marketing, etc.)
  Common placement: footer link + popup banner

Trust Signals in Footer:
  - Security badges (SSL, PCI-DSS, SOC 2)
  - Payment method icons (Visa, Mastercard, PayPal)
  - Industry certifications (ISO, BBB, Trustpilot)
  - Partner logos
  - "Secured by" or "Protected by" badges
EOF
}

cmd_accessibility() {
    cat << 'EOF'
=== Footer Accessibility (WCAG 2.1) ===

Landmark Navigation:
  <footer> is automatically a "contentinfo" landmark
  Screen readers list it in landmark navigation
  Only ONE <footer> per page should be the main footer
  Multiple <footer> elements (in <article>, <section>) are fine
    but each needs aria-label for distinction

Keyboard Navigation:
  All links must be reachable via Tab key
  Focus order should follow visual order (left→right, top→bottom)
  Focus indicators must be visible (don't disable :focus outlines)
  Skip-to-footer link optional but helpful for keyboard users

Color Contrast (WCAG AA):
  Normal text: 4.5:1 contrast ratio minimum
  Large text (18px+ bold or 24px+): 3:1 minimum
  Links: must be distinguishable from surrounding text
    - Color alone is not enough (add underline or other indicator)
    - Link vs visited states should differ

  Common footer mistake: gray text on dark gray background
  Test: use Chrome DevTools → Rendering → CSS contrast checker

Screen Reader Best Practices:
  - Heading hierarchy: h2 or h3 for footer column titles
  - Use sr-only class for visually hidden headings:
      .sr-only {
        position: absolute;
        width: 1px; height: 1px;
        padding: 0; margin: -1px;
        overflow: hidden;
        clip: rect(0,0,0,0);
        border: 0;
      }
  - Social icons need aria-label: <a aria-label="Twitter" href="...">
  - External links: indicate with aria-label or sr-only text

Link Best Practices:
  ✓ "Privacy Policy" (descriptive)
  ✗ "Click here" (meaningless out of context)
  ✗ "Read more" (ambiguous)
  ✓ Open-in-new-window: add aria-label="opens in new tab"
  ✓ Email links: <a href="mailto:...">hello@example.com</a>

Mobile Accessibility:
  Minimum tap target: 44×44px (WCAG 2.5.5)
  Spacing between targets: 8px minimum
  Font size: 14px minimum for footer text
  Accordion menus on mobile: use <details>/<summary> or
    proper ARIA (aria-expanded, aria-controls)
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Footer Code Examples ===

--- Minimal Footer ---
<footer>
  <p>&copy; 2024 Company Name &middot;
    <a href="/privacy">Privacy</a> &middot;
    <a href="/terms">Terms</a>
  </p>
</footer>

--- SaaS Fat Footer ---
<footer class="site-footer">
  <div class="footer-grid">
    <div class="footer-brand">
      <img src="/logo.svg" alt="Company" width="120">
      <p>Building the future of collaboration.</p>
    </div>
    <nav aria-label="Product links">
      <h3>Product</h3>
      <ul>
        <li><a href="/features">Features</a></li>
        <li><a href="/pricing">Pricing</a></li>
        <li><a href="/integrations">Integrations</a></li>
        <li><a href="/changelog">Changelog</a></li>
      </ul>
    </nav>
    <nav aria-label="Company links">
      <h3>Company</h3>
      <ul>
        <li><a href="/about">About</a></li>
        <li><a href="/blog">Blog</a></li>
        <li><a href="/careers">Careers</a></li>
        <li><a href="/press">Press</a></li>
      </ul>
    </nav>
    <nav aria-label="Support links">
      <h3>Support</h3>
      <ul>
        <li><a href="/docs">Documentation</a></li>
        <li><a href="/help">Help Center</a></li>
        <li><a href="/status">System Status</a></li>
        <li><a href="/contact">Contact Us</a></li>
      </ul>
    </nav>
  </div>
  <div class="footer-bottom">
    <small>&copy; 2024 Company. All rights reserved.</small>
    <div class="social-links">
      <a href="..." aria-label="Twitter"><svg>...</svg></a>
      <a href="..." aria-label="GitHub"><svg>...</svg></a>
      <a href="..." aria-label="LinkedIn"><svg>...</svg></a>
    </div>
  </div>
</footer>

--- Mobile Accordion Footer ---
Use <details>/<summary> for collapsible sections:
<footer>
  <details>
    <summary>Products</summary>
    <ul>
      <li><a href="/features">Features</a></li>
      <li><a href="/pricing">Pricing</a></li>
    </ul>
  </details>
  <details>
    <summary>Company</summary>
    <ul>
      <li><a href="/about">About</a></li>
      <li><a href="/careers">Careers</a></li>
    </ul>
  </details>
</footer>

Benefits of <details>/<summary>:
  - No JavaScript required
  - Accessible by default
  - Works on all modern browsers
  - Keyboard navigable (Enter/Space to toggle)
EOF
}

show_help() {
    cat << EOF
footer v$VERSION — Web Footer Design & Implementation Reference

Usage: script.sh <command>

Commands:
  intro         Footer purpose, anatomy, and design principles
  patterns      Layout patterns — minimal, fat, mega, CTA footers
  sticky        Sticky footer techniques — flexbox, grid, fixed
  html          Semantic HTML structure — tags, ARIA, landmarks
  css           CSS patterns — responsive layouts, grid, flexbox
  legal         Legal content — copyright, GDPR, CCPA, cookies
  accessibility WCAG compliance — contrast, keyboard, screen readers
  examples      Code snippets for common footer types
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
    html)          cmd_html ;;
    css)           cmd_css ;;
    legal)         cmd_legal ;;
    accessibility) cmd_accessibility ;;
    examples)      cmd_examples ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "footer v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
