#!/usr/bin/env bash
# shopify-toolkit — Shopify Development Reference
set -euo pipefail
VERSION="7.0.0"

cmd_intro() { cat << 'EOF'
# Shopify Development — Overview

## Platform Architecture
  Shopify is a multi-tenant SaaS e-commerce platform:
    Storefront:  Customer-facing store (themes, checkout)
    Admin:       Merchant backend (products, orders, analytics)
    Apps:        Third-party extensions (embedded or standalone)
    Functions:   Server-side logic that extends Shopify (discounts, shipping)
    Hydrogen:    Custom storefronts with React + Remix

## Theme System
  Liquid Templates:
    Shopify's template language (Ruby-based, by Tobias Lütke)
    .liquid files contain HTML + Liquid tags + filters
    Objects: {{ product.title }}, {{ cart.total_price | money }}
    Tags: {% if %}, {% for %}, {% assign %}, {% render %}
    Filters: | money, | img_url: '300x', | date: '%B %d, %Y'

  Theme Architecture (OS 2.0):
    Sections: Reusable UI blocks (hero banner, product grid)
    Blocks: Nested components within sections
    Templates: JSON-based, sections everywhere (not just homepage)
    Presets: Default section configurations
    App blocks: Third-party sections via app extensions

## APIs
  Admin REST API:   CRUD for products, orders, customers, inventory
  Admin GraphQL API: Preferred for new apps (more efficient, flexible)
  Storefront API:   Customer-facing queries (products, cart, checkout)
  Checkout API:     Customize checkout experience (Shopify Plus)
  Functions API:    Run Wasm at Shopify's edge (discounts, shipping, payments)
  Webhooks:         Real-time event notifications (order created, etc.)

## Shopify CLI
  shopify app init     — Scaffold new app
  shopify app dev      — Start dev server with hot reload
  shopify theme dev    — Preview theme changes locally
  shopify theme push   — Deploy theme to store
  shopify app deploy   — Deploy app extensions
EOF
}

cmd_standards() { cat << 'EOF'
# Shopify Development Standards

## Theme Development
  Dawn: Official reference theme (OS 2.0, open source on GitHub)
  File structure:
    assets/          CSS, JS, images, fonts
    config/          settings_schema.json, settings_data.json
    layout/          theme.liquid (base layout), password.liquid
    locales/         Translation files (en.json, fr.json)
    sections/        Reusable section files
    snippets/        Partial templates ({% render 'snippet-name' %})
    templates/       Page templates (product.json, collection.json)

  Schema format in sections:
    {% schema %}
    {
      "name": "Hero Banner",
      "settings": [
        { "type": "image_picker", "id": "image", "label": "Background" },
        { "type": "text", "id": "heading", "label": "Heading" }
      ],
      "presets": [{ "name": "Hero Banner" }]
    }
    {% endschema %}

## App Development Standards
  OAuth flow for app installation:
    1. Merchant clicks "Install" on App Store listing
    2. Redirect to /admin/oauth/authorize with scopes
    3. Merchant grants permissions
    4. Shopify redirects with code
    5. Exchange code for permanent access token
    6. Store token securely (encrypted at rest)

  Scopes (request minimum needed):
    read_products, write_products
    read_orders, write_orders
    read_customers, write_customers
    read_inventory, write_inventory

## Metafields
  Custom data for any resource (products, customers, orders)
  Namespace: "custom" (standard) or your app namespace
  Types: single_line_text, number_integer, json, file_reference
  Definition via API: Create metafield definition first, then values
  Access: {{ product.metafields.custom.care_instructions }}
EOF
}

cmd_troubleshooting() { cat << 'EOF'
# Shopify Troubleshooting Guide

## Liquid Rendering Errors
  "Liquid error: Memory limits exceeded"
    Cause: Too many nested loops or large data sets
    Fix: Use paginate tag ({% paginate collection.products by 12 %})
    Fix: Reduce forloop depth, avoid nested for-in-for

  "undefined method 'size' for nil:NilClass"
    Cause: Accessing property of nil object
    Fix: Add nil check: {% if product.images != blank %}

  Filter errors:
    {{ price | money }} → requires numeric input, not string
    {{ 'image.jpg' | img_url: '300x' }} → deprecated, use image_url
    New: {{ image | image_url: width: 300 }}

## API Rate Limits
  REST API: Leaky bucket, 40 requests/second, 80 request bucket
    Header: X-Shopify-Shop-Api-Call-Limit: 32/80
    Strategy: Check remaining capacity, pause when >75%

  GraphQL API: 1,000 cost points per second
    Each query has a calculated cost
    Response: throttleStatus { currentlyAvailable, restoreRate }
    Optimize: Request only needed fields, reduce query depth

  Webhook: Respond within 5 seconds or Shopify marks as failed
    Queue webhooks for async processing (Redis/SQS)
    After 19 consecutive failures → webhook deleted automatically

## Checkout Issues
  "Cart line items changed"
    Cause: Product went out of stock between cart and checkout
    Fix: Handle inventory_policy (continue/deny) in product settings

  "Payment declined"
    Cause: Shopify Payments processor declined
    Check: Shopify admin → Settings → Payments → View payouts

  Shipping rates not showing:
    Check: Carrier service app responding within 10 seconds?
    Check: Weight/dimensions set on products?
    Check: Shipping zones cover delivery address?
EOF
}

cmd_performance() { cat << 'EOF'
# Shopify Performance Optimization

## Liquid Performance
  Avoid:
    - forloop.index in large collections (use paginate instead)
    - Multiple | where filters chained (filter once, assign result)
    - Rendering sections inside loops (each render = full compile)
    - Excessive | json filter usage (large JSON = slow parse)

  Optimize:
    - {% assign %} results outside loops, not inside
    - {% render %} over {% include %} (isolated scope, parallel rendering)
    - Use section.settings.xxx instead of global settings when possible
    - Lazy load images with loading="lazy" attribute

  Liquid Profiler:
    Enable: ?_fd=0&pb=1 query parameters on storefront
    Shows: Render time per section, template, snippet
    Available on Shopify Partner stores

## Image Optimization
  Old: {{ image | img_url: '300x300' }}    — deprecated
  New: {{ image | image_url: width: 300 }} — responsive, WebP auto
  Srcset: Generate multiple sizes for responsive images
    <img srcset="{{ image | image_url: width: 200 }} 200w,
                  {{ image | image_url: width: 400 }} 400w,
                  {{ image | image_url: width: 800 }} 800w"
         sizes="(max-width: 600px) 200px, 400px">
  CDN: Shopify serves all assets from their CDN (cdn.shopify.com)
  Format: WebP served automatically to supporting browsers

## JavaScript & CSS
  Load scripts async: {% javascript %} block or <script defer>
  Critical CSS: Inline above-the-fold styles in <head>
  Remove unused: Audit third-party apps' injected JS/CSS
  Bundling: Shopify's asset pipeline handles minification
  Third-party apps: Each app can inject scripts — audit regularly
    Common problem: 15 apps = 15 extra JS files = 3+ second load time

## Core Web Vitals Targets
  LCP (Largest Contentful Paint): < 2.5 seconds
  FID (First Input Delay) / INP: < 200 milliseconds
  CLS (Cumulative Layout Shift): < 0.1
  Check: Google PageSpeed Insights with store URL
EOF
}

cmd_security() { cat << 'EOF'
# Shopify App Security

## OAuth Flow Security
  Always verify: Validate HMAC signature on callback
  Python: hmac.compare_digest(calculated_hmac, received_hmac)
  Node: crypto.timingSafeEqual(calculated, received)
  Never skip HMAC verification — attacker can fake installation
  State parameter: Include random nonce to prevent CSRF
  Token storage: Encrypt access tokens at rest (AES-256-GCM)

## Session Token Authentication
  For embedded apps (running inside Shopify Admin iframe):
  JWT-based, issued by Shopify App Bridge
  Verify: shopify.auth.verify(sessionToken)
  Contains: iss (shop domain), dest (app URL), exp (expiration)
  Rotate: Tokens expire in 1 minute, auto-refresh by App Bridge

## HMAC Webhook Validation
  Every webhook includes X-Shopify-Hmac-Sha256 header
  Verify: HMAC-SHA256(body, client_secret)
  MUST verify before processing — prevents spoofed webhooks
  Use timing-safe comparison (prevent timing attacks)
  Node example:
    const hash = crypto.createHmac('sha256', secret)
      .update(body, 'utf8').digest('base64');
    crypto.timingSafeEqual(Buffer.from(hash), Buffer.from(hmac));

## Content Security Policy
  Embedded apps: Must handle Shopify's iframe restrictions
  frame-ancestors: Allow only *.myshopify.com and admin.shopify.com
  App Bridge handles CSP headers for embedded apps
  Custom storefronts (Hydrogen): You manage CSP yourself

## Common Vulnerabilities
  XSS in Liquid: {{ user_input | escape }} — ALWAYS escape user input
  SQL Injection: N/A (no direct DB access), but sanitize GraphQL variables
  SSRF: If app makes requests based on user input, validate URLs
  Access control: Verify shop domain in every request (multi-tenant)
  Rate limit abuse: Implement per-shop rate limiting in your app
EOF
}

cmd_migration() { cat << 'EOF'
# Shopify Migration Guide

## Theme 1.0 → 2.0 (OS 2.0) Migration
  What changed:
    - Templates: .liquid files → .json files with section references
    - Sections: Available everywhere, not just homepage
    - App blocks: Apps add sections via theme app extensions
    - Settings: More granular, per-template customization

  Migration steps:
    1. Backup current theme (Download theme file)
    2. Create new OS 2.0 theme based on Dawn
    3. Port custom sections: Add {% schema %} with presets
    4. Convert templates: Create .json templates referencing sections
    5. Move static content to sections (editable in customizer)
    6. Test all pages in theme preview
    7. Publish new theme during low-traffic hours

  What breaks:
    - {% include %} works but {% render %} preferred (no variable leaking)
    - section.id changes (don't hardcode section IDs)
    - Alternate templates: Create via JSON, not Liquid

## Custom Checkout → Checkout Extensibility
  Old: checkout.liquid (Shopify Plus only, deprecated 2025)
  New: Checkout UI Extensions (React-based components)
  Migration:
    1. Audit checkout.liquid customizations
    2. Map to Checkout Extension points:
       - purchase.checkout.header → Branding extension
       - purchase.checkout.shipping-option → Shipping customization
       - purchase.checkout.payment-method → Payment customization
    3. Build extensions with Shopify CLI
    4. Test in development store
    5. Deploy to production store

## Platform Migration to Shopify
  From WooCommerce/Magento/BigCommerce:
    1. Export: Products (CSV), customers (CSV), orders (CSV)
    2. Import: Shopify Admin → Settings → Import data
    3. URL redirects: Map old URLs → new Shopify URLs (301 redirects)
    4. Apps: Find Shopify equivalents for critical plugins
    5. Theme: Customize Dawn or hire theme developer
    6. Payment: Set up Shopify Payments or third-party gateway
    7. DNS: Update A record and CNAME to Shopify servers
    8. Test: Place test orders, verify checkout flow
  Tools: Matrixify (complex imports), LitExtension (automated migration)
EOF
}

cmd_cheatsheet() { cat << 'EOF'
# Shopify Quick Reference

## Shopify CLI Commands
  shopify app init                    Create new app
  shopify app dev                     Start dev server
  shopify app deploy                  Deploy extensions
  shopify theme init                  Create new theme
  shopify theme dev                   Preview theme locally
  shopify theme push                  Upload theme
  shopify theme pull                  Download theme
  shopify theme list                  List store themes
  shopify auth logout                 Clear authentication
  shopify version                     Check CLI version

## GraphQL Common Queries
  # Get products
  { products(first: 10) { edges { node { id title handle variants(first:5) { edges { node { price } } } } } } }

  # Get orders
  { orders(first: 10, query: "financial_status:paid") { edges { node { id name totalPriceSet { shopMoney { amount } } } } } }

  # Get customers
  { customers(first: 10) { edges { node { id email firstName lastName ordersCount } } } }

## Liquid Filters Reference
  String:   | capitalize, | downcase, | upcase, | truncate: 50
  Number:   | money, | money_with_currency, | plus: 1, | minus: 1
  Array:    | first, | last, | size, | sort, | where: "available", true
  URL:      | asset_url, | shopify_asset_url, | img_url (deprecated)
  Image:    | image_url: width: 300, | image_url: height: 200
  Date:     | date: "%B %d, %Y" → "March 23, 2026"
  HTML:     | escape, | strip_html, | newline_to_br

## Liquid Tags Reference
  {% if condition %} ... {% elsif %} ... {% else %} ... {% endif %}
  {% for item in collection %} ... {% endfor %}
  {% assign variable = value %}
  {% capture variable %} ... {% endcapture %}
  {% render 'snippet-name', product: product %}
  {% paginate collection.products by 12 %} ... {% endpaginate %}
  {% form 'product', product %} ... {% endform %}
  {% schema %} ... {% endschema %}

## Webhook Event Types
  orders/create       orders/updated     orders/cancelled
  products/create     products/update    products/delete
  customers/create    customers/update   customers/delete
  checkouts/create    checkouts/update
  inventory_levels/update
  app/uninstalled  (MUST handle — clean up data)
EOF
}

cmd_faq() { cat << 'EOF'
# Shopify Development — FAQ

Q: Shopify Payments vs third-party payment gateways?
A: Shopify Payments (powered by Stripe): No transaction fees.
   Third-party gateways: 0.5-2% additional transaction fee on top of gateway fees.
   Shopify Payments available in 23 countries.
   For others: Use local gateways but pay the extra fee.
   Recommendation: Always use Shopify Payments if available.

Q: How do I handle international/multi-currency stores?
A: Shopify Markets: Built-in multi-currency and multi-language.
   Set up: Admin → Settings → Markets → Add market → Set currency and language.
   Automatic currency conversion based on exchange rates.
   Price rounding rules: Configure per market.
   Duties and taxes: Shopify Markets Pro for DDP (Delivered Duty Paid).
   Alternatively: Separate stores per region (Shopify Plus expansion stores).

Q: What's the difference between Online Store and Hydrogen?
A: Online Store: Liquid templates, hosted by Shopify, no-code customizable.
   Hydrogen: Custom React/Remix storefront, developer-built, fully custom.
   Online Store: 95% of merchants, faster to set up, app ecosystem works.
   Hydrogen: Complex custom UX, headless commerce, needs developer team.
   Start with Online Store unless you have specific UX requirements.

Q: How many apps should I install?
A: General rule: As few as possible. Each app adds JS/CSS overhead.
   Audit regularly: Admin → Settings → Apps → Review unused apps.
   Impact: 10+ apps commonly adds 2-5 seconds to page load.
   Alternatives: Many app features can be done with Liquid (tabs, accordions).
   Critical apps only: Reviews, email, analytics, upsell.
   Check: Remove app, test speed before/after.

Q: Shopify Plus — is it worth the $2,000+/month?
A: Worth it if: >$500K/month revenue, need checkout customization,
   multi-store (expansion stores), B2B wholesale, advanced automation.
   Features: checkout.liquid (deprecated), Flow, Launchpad, custom scripts.
   Alternative: Advanced plan ($399/mo) covers most needs.
   ROI: Calculate based on checkout conversion improvement potential.
EOF
}

cmd_help() {
    echo "shopify-toolkit v$VERSION — Shopify Development Reference"
    echo ""
    echo "Usage: shopify-toolkit <command>"
    echo ""
    echo "Commands:"
    echo "  intro           Platform architecture, APIs, CLI"
    echo "  standards       Theme development, OAuth, metafields"
    echo "  troubleshooting Liquid errors, rate limits, checkout issues"
    echo "  performance     Liquid optimization, images, Core Web Vitals"
    echo "  security        OAuth, HMAC, session tokens, CSP"
    echo "  migration       Theme 1.0→2.0, checkout extensibility"
    echo "  cheatsheet      CLI, GraphQL, Liquid filters/tags, webhooks"
    echo "  faq             Payments, multi-currency, Hydrogen, Plus"
    echo "  help            Show this help"
}

case "${1:-help}" in
    intro) cmd_intro ;; standards) cmd_standards ;;
    troubleshooting) cmd_troubleshooting ;; performance) cmd_performance ;;
    security) cmd_security ;; migration) cmd_migration ;;
    cheatsheet) cmd_cheatsheet ;; faq) cmd_faq ;;
    help|--help|-h) cmd_help ;;
    *) echo "Unknown: $1"; echo "Run: shopify-toolkit help" ;;
esac
