#!/usr/bin/env bash
# crawler — Web Crawling & Scraping Reference
set -euo pipefail
VERSION="3.0.0"

cmd_intro() { cat << 'EOF'
# Web Crawling & Scraping — Overview

## Crawling vs Scraping
  Crawling: Systematically browsing the web, following links, discovering URLs
    Purpose: Build index (like Google), map site structure, find content
    Output: List of URLs, link graph, sitemap
  Scraping: Extracting specific data from web pages
    Purpose: Get prices, reviews, contact info, structured data
    Output: Structured data (JSON, CSV, database records)
  In practice: Crawl first (find pages), then scrape (extract data)

## robots.txt Protocol (RFC 9309)
  Location: https://example.com/robots.txt
  Purpose: Tell crawlers which pages they can/cannot access
  Directives:
    User-agent: *           (applies to all crawlers)
    Disallow: /admin/       (don't crawl admin pages)
    Allow: /admin/public/   (exception within disallowed path)
    Crawl-delay: 10         (wait 10 seconds between requests)
    Sitemap: /sitemap.xml   (location of sitemap)
  Important: robots.txt is advisory, not enforced (polite crawlers follow it)
  Legal: Ignoring robots.txt may increase legal liability

## Sitemap.xml
  Purpose: Tell crawlers about all important pages
  Format: XML with <urlset> containing <url> entries
  Tags: <loc>, <lastmod>, <changefreq>, <priority>
  Sitemap index: For large sites, index file pointing to multiple sitemaps
  Size limits: 50,000 URLs or 50MB per sitemap file
  Auto-discovery: Referenced in robots.txt or via HTTP header

## Crawl Politeness
  Rate limiting: 1-2 requests per second per domain (minimum)
  Respect robots.txt and Crawl-delay directive
  Identify yourself: Use descriptive User-Agent string
  Handle errors gracefully: Back off on 429 (Too Many Requests)
  Respect nofollow/noindex meta tags
EOF
}

cmd_standards() { cat << 'EOF'
# Web Standards for Crawling

## HTTP Caching Headers
  Cache-Control: max-age=3600 (cache for 1 hour)
  ETag: "abc123" → If-None-Match: "abc123" (conditional request)
  Last-Modified: date → If-Modified-Since: date (conditional request)
  304 Not Modified: Content unchanged, use cached version
  Why care: Saves bandwidth, reduces server load, faster crawls
  Implementation: Store ETag/Last-Modified per URL, send in next request

## Structured Data Standards
  JSON-LD (preferred by Google):
    <script type="application/ld+json">
    {"@context":"https://schema.org","@type":"Product","name":"Widget"}
    </script>
  Microdata: HTML attributes (itemscope, itemprop)
  RDFa: HTML attributes (typeof, property)
  Schema.org types: Product, Article, Event, Organization, Person, Review
  Benefit for scrapers: Machine-readable data already extracted by site

## Meta Tags for Crawlers
  <meta name="robots" content="noindex, nofollow"> (page-level control)
  <meta name="googlebot" content="nosnippet"> (Google-specific)
  <link rel="canonical" href="https://example.com/page"> (preferred URL)
  X-Robots-Tag HTTP header: Same directives, works for non-HTML files
  Directives: index, noindex, follow, nofollow, noarchive, nosnippet

## HTTP Status Codes for Crawlers
  200: OK (process page)
  301: Permanent redirect (update URL in database, follow redirect)
  302: Temporary redirect (follow but keep original URL)
  304: Not Modified (use cached version)
  403: Forbidden (stop, likely blocked)
  404: Not Found (remove from index)
  429: Too Many Requests (back off, check Retry-After header)
  500: Server Error (retry later, maybe 3 times with exponential backoff)
  503: Service Unavailable (temporary, check Retry-After)
EOF
}

cmd_troubleshooting() { cat << 'EOF'
# Crawling Troubleshooting

## Anti-Bot Detection
  CAPTCHAs:
    - reCAPTCHA v3: Score-based, no user interaction (hard to bypass)
    - hCaptcha: Image classification tasks
    - Solutions: Captcha-solving services (2Captcha, Anti-Captcha) — costly
    - Better: Use API if available, contact site for data access

  Browser Fingerprinting:
    - Canvas fingerprint: Render invisible image, hash pixel data
    - WebGL fingerprint: GPU rendering characteristics
    - Navigator properties: plugins, languages, platform
    - TLS fingerprint (JA3/JA4): Unique per browser/library
    - requests library JA3 ≠ Chrome JA3 → detected as bot
    - Solution: Use real browser (Playwright/Puppeteer) or curl_cffi

  Rate Limiting:
    - 429 responses with Retry-After header
    - IP-based throttling (affects all concurrent requests from same IP)
    - Progressive blocking: Warns → slows → blocks → bans
    - Solution: Respect rate limits, use rotating proxies, add random delays

## JavaScript Rendering
  Problem: Page content loaded via JavaScript (SPA/React/Vue/Angular)
  Simple requests/BeautifulSoup: Only see initial HTML (no JS-rendered content)
  Solutions:
    1. Playwright/Puppeteer: Full browser, executes JS
    2. Splash: Lightweight rendering service (Scrapy integration)
    3. API endpoints: Check Network tab for XHR/fetch calls to data APIs
    4. Pre-rendered/SSR pages: Some sites serve static HTML to crawlers
  Playwright usage:
    await page.goto(url)
    await page.wait_for_selector('.product-list')
    content = await page.content()

## Encoding Issues
  Mojibake: garbled text from wrong encoding
  Detection: chardet library (Python), charset in Content-Type header
  Common: UTF-8 (default), Shift_JIS (Japanese), GB2312/GBK (Chinese)
  Fix: response.encoding = response.apparent_encoding
  HTML entities: &amp; &lt; &gt; → use html.unescape() or BeautifulSoup
EOF
}

cmd_performance() { cat << 'EOF'
# Crawling Performance

## Concurrent Requests
  Sequential: 1 request/second = 86,400 pages/day
  Concurrent (10 threads): 10 req/s = 864,000 pages/day
  Async (100 connections): 100 req/s = 8.6M pages/day (if server allows)
  Bottleneck: Usually politeness (rate limiting), not your bandwidth
  Python: asyncio + aiohttp, or Scrapy (built-in async)
  Node.js: Got/Axios with concurrency limiter (p-limit)
  Rule: Balance speed vs politeness — don't overwhelm target servers

## URL Deduplication
  Problem: Same page reachable via multiple URLs
  Solutions:
    - Normalize URLs: lowercase, sort params, remove fragments, trailing slash
    - Bloom filter: Probabilistic set membership (very memory efficient)
      1M URLs in ~1.2MB RAM, 1% false positive rate
    - Hash set: Exact dedup, more memory but no false positives
    - Database: URL table with unique constraint (persistent across runs)
  Python bloom filter: from pybloom_live import BloomFilter

## Incremental Crawling
  Problem: Re-crawling entire site is wasteful
  Strategy:
    1. Store Last-Modified and ETag for each URL
    2. Send conditional requests (If-Modified-Since / If-None-Match)
    3. Only process pages that return 200 (skip 304 Not Modified)
    4. Prioritize recently changed pages (from sitemap lastmod)
    5. Schedule: High-priority pages daily, low-priority weekly
  Savings: Typically 70-90% bandwidth reduction vs full crawl

## Distributed Crawling
  Scrapy + Scrapy-Redis: Distribute URLs across multiple workers
  Architecture: Redis queue → Multiple Scrapy spiders → Shared pipeline
  URL frontier: Redis set for dedup, sorted set for priority queue
  Scaling: Add more workers as needed (horizontal scaling)
  Alternatives:
    - Apache Nutch: Java-based, Hadoop integration, web-scale
    - StormCrawler: Storm-based, real-time crawling
    - Colly: Go library, fast concurrent crawling
EOF
}

cmd_security() { cat << 'EOF'
# Legal & Ethical Considerations

## Legal Landscape
  United States:
    CFAA (Computer Fraud and Abuse Act): Unauthorized access = criminal
    hiQ v LinkedIn (2022): Scraping public data is not CFAA violation
    But: Terms of Service violation may still create civil liability
    Van Buren v US (2021): Narrowed CFAA — exceeding authorized access ≠ misuse

  European Union:
    GDPR: Scraping personal data requires legal basis (consent, legitimate interest)
    Database Directive: Protects database investments (EU-specific right)
    Ryanair v PR Aviation: Screen scraping can violate terms of service

  Key principles:
    - Public data ≠ free data (legal ≠ ethical ≠ terms-compliant)
    - Personal data scraping has stricter requirements (GDPR)
    - Commercial use of scraped data faces more scrutiny
    - Always check ToS before scraping

## Ethical Scraping Guidelines
  1. Check for API first (always prefer official API over scraping)
  2. Read and follow robots.txt
  3. Rate limit your requests (minimum 1s between requests per domain)
  4. Identify your crawler (descriptive User-Agent with contact info)
  5. Don't scrape behind authentication without permission
  6. Respect CAPTCHA (it means they don't want you crawling)
  7. Cache responses to avoid re-fetching
  8. Don't redistribute copyrighted content
  9. Handle personal data per GDPR/CCPA requirements
  10. Stop if you receive a cease and desist

## Proxy Rotation
  Types:
    Datacenter proxies: Fast, cheap ($1-2/GB), easily detected
    Residential proxies: Real IPs, harder to detect, expensive ($5-15/GB)
    Mobile proxies: Hardest to detect, most expensive ($20+/GB)
    ISP proxies: Static residential IPs, good balance
  Providers: Bright Data, Oxylabs, Smartproxy, ScraperAPI
  Rotation strategy: New IP per request or per domain
  Anti-detect: Rotate User-Agent, accept headers, TLS fingerprint per IP
EOF
}

cmd_migration() { cat << 'EOF'
# Scraping Framework Migration

## BeautifulSoup → Scrapy
  When to migrate:
    - Need concurrent requests (BS4 is single-threaded)
    - Crawling multiple pages with link following
    - Need robust retry/error handling
    - Want pipeline processing (database, file storage)

  BeautifulSoup strengths: Simple, quick scripts, good for one-off scraping
  Scrapy strengths: Production-grade, built-in concurrency, middleware, pipelines

  Migration mapping:
    requests.get(url)           → scrapy.Request(url, callback)
    BeautifulSoup(html)         → response.css() or response.xpath()
    soup.find('div', class_='x') → response.css('div.x')
    soup.find_all('a')          → response.css('a::attr(href)').getall()
    Manual loop                 → Spider with parse method + yield

## requests → Playwright (for JS Sites)
  When: Page content loaded via JavaScript (React, Vue, Angular SPAs)
  Playwright advantages: Full browser engine, handles JS, AJAX, websockets
  Setup:
    pip install playwright
    playwright install chromium
  Migration:
    response = requests.get(url)   →   page = browser.new_page()
    html = response.text           →   page.goto(url)
                                       page.wait_for_selector('.data')
                                       html = page.content()
  Headless mode: browser = playwright.chromium.launch(headless=True)
  Resource: Block images/CSS for faster scraping:
    page.route("**/*.{png,jpg,css}", lambda route: route.abort())

## Self-Hosted → Cloud Scraping
  Cloud options:
    ScraperAPI: API proxy with JS rendering ($29/mo)
    Apify: Actor-based scraping platform (free tier)
    Crawlee: Open source (Apify's framework, self-host or cloud)
    Zyte (formerly Scrapy Cloud): Scrapy hosting + smart proxy
  Benefits: No proxy management, built-in browser rendering, auto-scaling
  Self-hosted benefits: Full control, no per-request costs, data stays local
  Hybrid: Run spiders locally, use cloud proxy/rendering services
EOF
}

cmd_cheatsheet() { cat << 'EOF'
# Web Scraping Quick Reference

## Scrapy Commands
  scrapy startproject myproject     # Create project
  scrapy genspider myspider domain  # Generate spider
  scrapy crawl myspider             # Run spider
  scrapy shell "http://example.com" # Interactive shell
  scrapy bench                      # Benchmark concurrency
  scrapy view http://example.com    # Open page in browser
  scrapy fetch --nolog http://url   # Fetch single page

## CSS Selectors vs XPath
  CSS: response.css('div.product h2::text').get()
  XPath: response.xpath('//div[@class="product"]/h2/text()').get()

  CSS examples:
    div.class          Element with class
    #id                Element with id
    a::attr(href)      Attribute value
    h1::text           Text content
    div > p            Direct child
    div p              Any descendant
    li:nth-child(2)    Second list item

  XPath examples:
    //div[@class="x"]         Element with class
    //a/@href                 Attribute value
    //h1/text()               Text content
    //div[contains(@class,"x")] Class contains
    //table/tr[position()>1]  Skip header row

## curl with Cookie Jar
  curl -c cookies.txt -b cookies.txt -L "https://example.com/login"   -d "user=x&pass=y"
  curl -b cookies.txt "https://example.com/data"

## Common User-Agent Strings
  Chrome:  Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
  Firefox: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0
  Googlebot: Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)

## Headless Chrome Flags
  --headless=new        New headless mode (Chrome 112+)
  --disable-gpu         Disable GPU (server environments)
  --no-sandbox          Required in Docker
  --disable-dev-shm     Use /tmp instead of /dev/shm
  --window-size=1920,1080  Set viewport
  --user-agent="..."    Custom user agent
EOF
}

cmd_faq() { cat << 'EOF'
# Web Scraping — FAQ

Q: Is web scraping legal?
A: It depends on jurisdiction, what you scrape, and how you use it.
   US: Scraping public data generally OK (hiQ v LinkedIn ruling).
   EU: GDPR restricts scraping personal data. Database Directive applies.
   Factors: robots.txt compliance, ToS agreement, personal data, purpose.
   Safe: Public data, no ToS violation, no personal data, non-commercial.
   Risky: Behind login, against ToS, personal data, commercial purpose.
   Always consult a lawyer for commercial scraping operations.

Q: How do I scrape JavaScript-rendered pages?
A: Use a browser automation tool:
   - Playwright (recommended): Python/JS/Java/.NET, fast, modern API.
   - Puppeteer: JS/Node.js, Chrome DevTools Protocol.
   - Selenium: Oldest, widest language support, slower.
   Alternative: Check for API endpoints (Network tab in DevTools).
   Many SPAs load data via JSON API — scraping the API is more efficient.

Q: How do I avoid getting blocked?
A: 1. Slow down (1-3 second delays between requests).
   2. Rotate User-Agent strings (pool of 10-20 real browser UAs).
   3. Use residential proxies for sensitive targets.
   4. Match browser fingerprint (TLS, headers, cookies).
   5. Handle CAPTCHAs or use browser automation.
   6. Don't crawl aggressively during business hours.
   7. Rotate session/cookies periodically.

Q: BeautifulSoup vs Scrapy — which should I use?
A: BeautifulSoup + requests: Best for quick scripts, few pages.
   Scrapy: Best for production crawlers, many pages, pipeline processing.
   If you're scraping <100 pages: BeautifulSoup is fine.
   If you're building a recurring scraping system: Use Scrapy.
   Learning curve: BS4 = 30 minutes, Scrapy = a few hours.

Q: How do I store scraped data?
A: Small (< 10K records): CSV or JSON files.
   Medium (10K-1M): SQLite database (single file, no server).
   Large (> 1M): PostgreSQL or MongoDB.
   Pipeline: Scrapy pipelines can write to any of these automatically.
   Best practice: Store raw HTML too (allows re-parsing later).
EOF
}

cmd_help() {
    echo "crawler v$VERSION — Web Crawling & Scraping Reference"
    echo ""
    echo "Usage: crawler <command>"
    echo ""
    echo "Commands:"
    echo "  intro           Crawling vs scraping, robots.txt, sitemap"
    echo "  standards       HTTP caching, structured data, meta tags"
    echo "  troubleshooting Anti-bot detection, JS rendering, encoding"
    echo "  performance     Concurrency, dedup, incremental, distributed"
    echo "  security        Legal landscape, ethical guidelines, proxies"
    echo "  migration       BS4→Scrapy, requests→Playwright, cloud"
    echo "  cheatsheet      Scrapy commands, CSS/XPath, curl, user-agents"
    echo "  faq             Legality, JS pages, blocking, storage"
    echo "  help            Show this help"
}

case "${1:-help}" in
    intro) cmd_intro ;; standards) cmd_standards ;;
    troubleshooting) cmd_troubleshooting ;; performance) cmd_performance ;;
    security) cmd_security ;; migration) cmd_migration ;;
    cheatsheet) cmd_cheatsheet ;; faq) cmd_faq ;;
    help|--help|-h) cmd_help ;;
    *) echo "Unknown: $1"; echo "Run: crawler help" ;;
esac
