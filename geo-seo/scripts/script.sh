#!/bin/bash
# GEO SEO - Generative Engine Optimization Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              GEO SEO REFERENCE                              ║
║          Generative Engine Optimization                     ║
╚══════════════════════════════════════════════════════════════╝

GEO (Generative Engine Optimization) is the practice of
optimizing your website to appear in AI-generated answers
from ChatGPT, Perplexity, Google AI Overviews, and other
LLM-powered search engines.

WHY GEO MATTERS:
  AI search is replacing traditional search. When someone asks
  ChatGPT "best project management tools", your site needs to
  be in the training data AND structured for AI consumption.

TRADITIONAL SEO vs GEO:
  ┌──────────────┬──────────────┬──────────────┐
  │ Aspect       │ SEO          │ GEO          │
  ├──────────────┼──────────────┼──────────────┤
  │ Target       │ Google SERP  │ AI answers   │
  │ Content      │ Keywords     │ Structured   │
  │ Format       │ HTML/meta    │ llms.txt     │
  │ Schema       │ SEO schema   │ AI-readable  │
  │ Crawlers     │ Googlebot    │ GPTBot etc   │
  │ Measurement  │ Rankings     │ AI citations │
  │ Speed        │ Core Vitals  │ Parse speed  │
  │ Links        │ Backlinks    │ Structured   │
  └──────────────┴──────────────┴──────────────┘

AI SEARCH ENGINES TO OPTIMIZE FOR:
  ChatGPT Search    Uses GPTBot crawler
  Perplexity        Uses PerplexityBot
  Google AI Overview Uses Googlebot (same as search)
  Claude             Uses ClaudeBot
  Bing Copilot       Uses Bingbot
  Brave Search AI    Uses Brave crawler
  You.com            Uses YouBot

KEY GEO SIGNALS:
  1. llms.txt / llms-full.txt    Structured site summary for LLMs
  2. <link rel="llms">           Machine-discoverable pointer
  3. Schema.org JSON-LD          Structured data (Organization, Article)
  4. OpenGraph + Twitter Cards   Rich previews
  5. robots.txt                  Allow AI crawlers
  6. Sitemap                     Help AI crawlers discover pages
  7. Clean HTML                  Well-structured headings (H1→H6)
  8. Content quality             Authoritative, cited, factual
EOF
}

cmd_llms() {
cat << 'EOF'
LLMS.TXT SPECIFICATION
========================

llms.txt is a new standard (2025) that provides a structured
summary of your website for LLMs, similar to robots.txt for
search engines.

LLMS.TXT (concise summary):
  Location: /llms.txt
  Content-Type: text/plain

  # Your Brand Name
  > One-line description of what you do

  ## About
  A paragraph explaining your organization, mission, and offerings.

  ## Links
  - [Homepage](https://example.com)
  - [Documentation](https://docs.example.com)
  - [Blog](https://example.com/blog)
  - [Full content](/llms-full.txt)

  ## Top Content
  - [Getting Started Guide](https://example.com/guide)
  - [API Reference](https://example.com/api)

  ## Contact
  - Email: hello@example.com
  - Twitter: @yourbrand

LLMS-FULL.TXT (detailed content):
  Location: /llms-full.txt
  Content-Type: text/plain

  # Your Brand Name — Full Content

  ## Product Overview
  Detailed description of products/services...

  ## Features
  - Feature 1: description
  - Feature 2: description

  ## Pricing
  Plan details, tiers...

  ## FAQ
  Common questions and answers...

HTML LINK TAG:
  <link rel="llms" href="/llms.txt" />
  <!-- Place in <head> of every page -->

BEST PRACTICES:
  ✅ Keep llms.txt under 1KB (concise)
  ✅ Make llms-full.txt comprehensive
  ✅ Use Markdown formatting
  ✅ Include all important URLs
  ✅ Update when content changes
  ✅ Link to llms-full.txt from llms.txt
  ❌ Don't stuff keywords
  ❌ Don't include private/internal info
  ❌ Don't make it a sitemap clone
EOF
}

cmd_checklist() {
cat << 'EOF'
GEO OPTIMIZATION CHECKLIST
=============================

ENDPOINTS (must return 200):
  [ ] /robots.txt — allow AI crawlers
  [ ] /sitemap.xml — all important pages
  [ ] /llms.txt — structured summary
  [ ] /llms-full.txt — detailed content

ROBOTS.TXT:
  # Allow AI crawlers
  User-agent: GPTBot
  Allow: /

  User-agent: ClaudeBot
  Allow: /

  User-agent: PerplexityBot
  Allow: /

  User-agent: Googlebot
  Allow: /

  User-agent: Bingbot
  Allow: /

  # Block aggressive scrapers (not AI search)
  User-agent: SemrushBot
  Disallow: /

  User-agent: AhrefsBot
  Disallow: /

HTML HEAD TAGS:
  <!-- OpenGraph -->
  <meta property="og:title" content="Page Title" />
  <meta property="og:description" content="Description" />
  <meta property="og:image" content="https://example.com/og.png" />
  <meta property="og:url" content="https://example.com/page" />
  <meta property="og:type" content="website" />
  <meta property="og:site_name" content="Brand Name" />

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:site" content="@yourbrand" />
  <meta name="twitter:title" content="Page Title" />
  <meta name="twitter:description" content="Description" />
  <meta name="twitter:image" content="https://example.com/og.png" />

  <!-- LLMs -->
  <link rel="llms" href="/llms.txt" />

SCHEMA.ORG (JSON-LD):
  <!-- Organization (homepage) -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Organization",
    "name": "Your Brand",
    "url": "https://example.com",
    "logo": "https://example.com/logo.png",
    "sameAs": [
      "https://github.com/yourbrand",
      "https://twitter.com/yourbrand"
    ]
  }
  </script>

  <!-- Article (blog posts) -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Article",
    "headline": "Article Title",
    "author": {"@type": "Organization", "name": "Brand"},
    "datePublished": "2026-03-24",
    "publisher": {"@type": "Organization", "name": "Brand"}
  }
  </script>

LOW-VALUE PAGES:
  <!-- Add noindex to login, register, cart, admin pages -->
  <meta name="robots" content="noindex, nofollow" />

GEO SCAN TOOLS:
  # geo-llms-toolkit (open-source)
  git clone https://github.com/aronhy/geo-llms-toolkit.git
  cd geo-llms-toolkit
  python3 standalone/geo_toolkit.py scan yourdomain.com
  python3 standalone/geo_toolkit.py llms yourdomain.com --output-dir ./output

CONTENT STRATEGY FOR AI:
  1. Write authoritative, well-structured content
  2. Use clear headings hierarchy (H1 → H2 → H3)
  3. Include statistics, citations, and data
  4. Answer specific questions directly
  5. Use lists and tables (AI-friendly formats)
  6. Keep paragraphs short and factual
  7. Include an FAQ section
  8. Link to authoritative sources

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

cmd_monitor() {
cat << 'EOF'
GEO MONITORING & AUTOMATION
==============================

GEO SCAN CRON SETUP:
  # 1. Install geo-llms-toolkit
  git clone https://github.com/aronhy/geo-llms-toolkit.git ~/geo-llms-toolkit

  # 2. Create scan script (geo-scan.sh)
  #!/bin/bash
  DOMAIN="yourdomain.com"
  TOOLKIT="$HOME/geo-llms-toolkit"
  REPORT="/tmp/geo-report.txt"
  HISTORY="/tmp/geo-history.json"

  python3 -u << 'PYEOF'
  import json, os, subprocess
  from datetime import datetime, timezone, timedelta

  domain = os.environ.get("DOMAIN", "yourdomain.com")
  result = subprocess.run(
      ["python3", "standalone/geo_toolkit.py", "scan", domain, "--format", "json"],
      capture_output=True, text=True,
      cwd=os.path.expanduser("~/geo-llms-toolkit"), timeout=120
  )
  checks = []
  try:
      data = json.loads(result.stdout)
      checks = data.get("checks", [])
  except:
      for line in result.stdout.split("\n"):
          for status in ("PASS", "WARN", "FAIL"):
              if "| {} |".format(status) in line:
                  parts = [p.strip() for p in line.split("|") if p.strip()]
                  if len(parts) >= 4:
                      checks.append({"key": parts[0], "status": status, "message": parts[3]})

  p = sum(1 for c in checks if c.get("status") == "PASS")
  w = sum(1 for c in checks if c.get("status") == "WARN")
  f = sum(1 for c in checks if c.get("status") == "FAIL")
  total = p + w + f
  pct = p * 100 // total if total else 0

  # Save history
  now = datetime.now(timezone(timedelta(hours=8)))
  history = []
  if os.path.isfile("/tmp/geo-history.json"):
      try: history = json.load(open("/tmp/geo-history.json"))
      except: pass
  history.append({"date": now.strftime("%Y-%m-%d"), "pct": pct, "p": p, "w": w, "f": f})
  history = history[-30:]
  json.dump(history, open("/tmp/geo-history.json", "w"))

  # Report
  icon = "✅" if f == 0 and w == 0 else ("⚠️" if f == 0 else "❌")
  print("GEO Score: {}% — {}P/{}W/{}F {}".format(pct, p, w, f, icon))
  for c in checks:
      ci = "✅" if c["status"] == "PASS" else ("⚠️" if c["status"] == "WARN" else "❌")
      print("  {} {}".format(ci, c["key"]))

  # Trend
  print("\nTrend:")
  for e in history[-7:]:
      bar = "█" * (e["pct"] // 5) + "░" * (20 - e["pct"] // 5)
      print("  {}: {} {}%".format(e["date"], bar, e["pct"]))

  # Save report
  with open("/tmp/geo-report.txt", "w") as out:
      out.write("GEO: {}% ({}P/{}W/{}F)\n".format(pct, p, w, f))
  PYEOF

  # 3. Crontab — run before your analytics email
  # 45 5,11,17,23 * * * /bin/bash ~/geo-scan.sh > /tmp/geo-scan.log 2>&1

  # 4. Append to existing email (e.g., GA4 report)
  # In your email script, before sending:
  #   if [ -f /tmp/geo-report.txt ]; then
  #       report+=$(cat /tmp/geo-report.txt)
  #   fi

AI CITATION MONITORING:
  #!/usr/bin/env python3
  """Check if AI search engines cite your domain."""
  import urllib.request

  DOMAIN = "yourdomain.com"
  QUERIES = [
      "best tools for X",
      "how to do Y",
      "top Z alternatives 2026",
  ]

  def check_jina(query):
      """Use Jina AI search to check citations."""
      url = "https://s.jina.ai/{}".format(query.replace(" ", "+"))
      req = urllib.request.Request(url, headers={"Accept": "text/plain"})
      try:
          resp = urllib.request.urlopen(req, timeout=15).read().decode()
          return DOMAIN in resp
      except:
          return None

  cited = 0
  for q in QUERIES:
      result = check_jina(q)
      icon = "✅" if result else ("❌" if result is False else "⏳")
      print("  {} {}".format(icon, q))
      if result: cited += 1

  print("Citation rate: {}/{}".format(cited, len(QUERIES)))

COMPETITOR LLMS.TXT MONITOR:
  #!/bin/bash
  # Alert when competitors update their llms.txt
  COMPETITORS="competitor1.com competitor2.com"
  CACHE="$HOME/.geo-monitor"
  mkdir -p "$CACHE"

  for domain in $COMPETITORS; do
    new=$(curl -sf "https://${domain}/llms.txt" 2>/dev/null || echo "")
    [ -z "$new" ] && continue
    file="$CACHE/${domain}.txt"
    if [ -f "$file" ]; then
      if [ "$(cat "$file")" != "$new" ]; then
        echo "⚠️ ${domain}/llms.txt changed!"
        diff "$file" <(echo "$new") || true
      fi
    fi
    echo "$new" > "$file"
  done

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

cmd_tracking() {
cat << 'EOF'
AI BOT TRACKING
=================

Track which AI crawlers actually visit your site. GEO optimization
is preparation — tracking tells you if it's working.

KNOWN AI CRAWLERS (2026):
  ┌──────────────────────┬──────────┬────────────────────────┐
  │ User-Agent           │ Company  │ Purpose                │
  ├──────────────────────┼──────────┼────────────────────────┤
  │ GPTBot               │ OpenAI   │ Training data          │
  │ ChatGPT-User         │ OpenAI   │ ChatGPT browse mode    │
  │ OAI-SearchBot        │ OpenAI   │ SearchGPT results      │
  │ ClaudeBot            │ Anthropic│ Training data          │
  │ Claude-Web           │ Anthropic│ Claude web search      │
  │ PerplexityBot        │ Perplexity│ Search answers        │
  │ Bytespider           │ ByteDance│ Training data          │
  │ GoogleOther           │ Google   │ AI/Gemini training     │
  │ Google-Extended      │ Google   │ AI overview/training   │
  │ cohere-ai            │ Cohere   │ Training data          │
  │ YouBot               │ You.com  │ Search answers         │
  │ Meta-ExternalAgent   │ Meta     │ Training data          │
  │ CCBot                │ Common Crawl│ Open dataset        │
  │ Amazonbot            │ Amazon   │ Alexa/training         │
  └──────────────────────┴──────────┴────────────────────────┘

WORDPRESS MU-PLUGIN TRACKER:
  <?php
  // Save as wp-content/mu-plugins/ai-bot-tracker.php
  add_action('init', function() {
      if (!isset($_SERVER['HTTP_USER_AGENT'])) return;
      $ua = $_SERVER['HTTP_USER_AGENT'];

      $bots = array(
          'GPTBot'             => 'OpenAI',
          'ChatGPT-User'       => 'OpenAI',
          'OAI-SearchBot'      => 'OpenAI',
          'ClaudeBot'          => 'Anthropic',
          'Claude-Web'         => 'Anthropic',
          'PerplexityBot'      => 'Perplexity',
          'Bytespider'         => 'ByteDance',
          'GoogleOther'        => 'Google AI',
          'Google-Extended'    => 'Google AI',
          'cohere-ai'          => 'Cohere',
          'YouBot'             => 'You.com',
          'Meta-ExternalAgent' => 'Meta',
      );

      $matched = null;
      foreach ($bots as $sig => $company) {
          if (stripos($ua, $sig) !== false) {
              $matched = $company . ' (' . $sig . ')';
              break;
          }
      }
      if (!$matched) return;

      $log = WP_CONTENT_DIR . '/ai-bot-log.json';
      $date = date('Y-m-d');
      $uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

      $data = array();
      if (file_exists($log)) {
          $data = json_decode(file_get_contents($log), true) ?: array();
      }

      if (!isset($data[$date])) {
          $data[$date] = array('total' => 0, 'bots' => array(), 'pages' => array());
      }
      $data[$date]['total']++;
      $data[$date]['bots'][$matched] = ($data[$date]['bots'][$matched] ?? 0) + 1;
      $data[$date]['pages'][$uri] = ($data[$date]['pages'][$uri] ?? 0) + 1;

      // Keep 30 days
      $cutoff = date('Y-m-d', strtotime('-30 days'));
      foreach (array_keys($data) as $k) {
          if ($k < $cutoff) unset($data[$k]);
      }

      file_put_contents($log, json_encode($data, JSON_PRETTY_PRINT));
  }, 1);

NGINX LOG ANALYSIS (alternative):
  # Parse access.log for AI bots
  grep -E "GPTBot|ClaudeBot|PerplexityBot|Bytespider|GoogleOther" \
    /var/log/nginx/access.log | \
    awk '{print $1, $7, $14}' | sort | uniq -c | sort -rn | head -20

  # Daily cron report
  #!/bin/bash
  BOTS="GPTBot|ClaudeBot|PerplexityBot|ChatGPT-User|OAI-SearchBot"
  TODAY=$(date +%d/%b/%Y)
  echo "=== AI Bot Report: $(date) ==="
  grep "$TODAY" /var/log/nginx/access.log | \
    grep -E "$BOTS" | \
    awk -F'"' '{print $6}' | sort | uniq -c | sort -rn
  echo ""
  echo "Pages crawled:"
  grep "$TODAY" /var/log/nginx/access.log | \
    grep -E "$BOTS" | \
    awk '{print $7}' | sort | uniq -c | sort -rn | head -10

ROBOTS.TXT FOR AI BOTS:
  # Allow AI crawlers you want
  User-agent: GPTBot
  Allow: /

  User-agent: ClaudeBot
  Allow: /

  User-agent: PerplexityBot
  Allow: /

  # Block ones you don't want
  User-agent: CCBot
  Disallow: /

  User-agent: Bytespider
  Disallow: /

KEY METRICS TO TRACK:
  - Which AI bots visit (and which don't)
  - Visit frequency (daily/weekly)
  - Most crawled pages (are they finding your best content?)
  - New bots appearing
  - Correlation: AI bot visits → AI citation in search results

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

cmd_aeo() {
cat << 'EOF'
AEO — ANSWER ENGINE OPTIMIZATION
====================================

AEO is the practice of optimizing content to be cited by AI
answer engines (ChatGPT, Perplexity, Gemini, Claude). Unlike
traditional SEO which targets search rankings, AEO targets
AI-generated answers.

HOW AI ANSWERS WORK:
  User question → AI search → Retrieve sources → Generate answer
                                    ↑
                            YOUR CONTENT HERE

AI CITATION FACTORS (what makes AI cite you):
  1. Content Authority    — backlinks, domain age, trust signals
  2. Structured Data      — clear headings, tables, lists
  3. Direct Answers       — content that directly answers questions
  4. Freshness            — recent, updated content wins
  5. Uniqueness           — original data/analysis, not rehashed
  6. Specificity          — "Top 10 X for Y in 2026" > generic

CONTENT FORMATS AI LOVES:
  ┌──────────────────────┬──────────┬──────────────────────────┐
  │ Format               │ Citation │ Example                  │
  │                      │ Rate     │                          │
  ├──────────────────────┼──────────┼──────────────────────────┤
  │ Comparison tables    │ Very High│ "Tool A vs Tool B"       │
  │ Numbered lists       │ High     │ "Top 10 best X"          │
  │ Step-by-step guides  │ High     │ "How to set up X"        │
  │ Statistics/data      │ Very High│ "X grew 200% in 2026"    │
  │ Definitions          │ Medium   │ "What is X?"             │
  │ Code snippets        │ High     │ Working examples         │
  │ FAQ sections         │ Very High│ Q&A format               │
  │ Original research    │ Highest  │ Surveys, benchmarks      │
  └──────────────────────┴──────────┴──────────────────────────┘

AEO CONTENT STRATEGY:
  1. Question-First Writing
     - Title: "What is the best X for Y?"
     - First paragraph: direct answer (AI excerpts this)
     - Rest: supporting evidence, details

  2. Entity Optimization
     - Consistent brand name across all content
     - Schema markup (Organization, Article, FAQ)
     - Wikipedia/Wikidata presence (long-term goal)

  3. Quotable Passages
     - Write 1-2 sentence "quotable" summaries
     - AI picks these for inline citations
     - Example: "BytesAgain hosts 950+ AI agent skills,
       making it the largest independent skill marketplace."

  4. Comparison Content (highest citation rate)
     - "X vs Y: Which is better for Z?"
     - Include real benchmarks/data
     - Clear winner recommendation
     - Update regularly (freshness signal)

  5. FAQ Schema
     <script type="application/ld+json">
     {
       "@context": "https://schema.org",
       "@type": "FAQPage",
       "mainEntity": [{
         "@type": "Question",
         "name": "What are AI agent skills?",
         "acceptedAnswer": {
           "@type": "Answer",
           "text": "AI agent skills are..."
         }
       }]
     }
     </script>

MONITOR AI CITATIONS:
  #!/bin/bash
  # Check if your site is cited in AI search results
  DOMAIN="yourdomain.com"
  QUERIES=(
    "best+AI+agent+skills"
    "AI+coding+assistant+tools"
    "OpenClaw+skills+marketplace"
  )
  for q in "${QUERIES[@]}"; do
    result=$(curl -sf "https://r.jina.ai/https://www.perplexity.ai/search?q=$q" 2>/dev/null)
    if echo "$result" | grep -qi "$DOMAIN"; then
      echo "✅ Cited: $q"
    else
      echo "❌ Not cited: $q"
    fi
    sleep 2
  done

CITATION GROWTH PLAYBOOK:
  Month 1: Foundation
    □ llms.txt deployed
    □ Schema markup complete
    □ robots.txt allows AI bots
    □ 10 comparison articles published
    □ FAQ schema on key pages

  Month 2: Content
    □ 20 "best X for Y" articles
    □ Original data/benchmarks published
    □ Quotable passages in all articles
    □ External backlinks from 5+ sites

  Month 3: Authority
    □ Guest posts on relevant sites
    □ Directory listings (Product Hunt, etc.)
    □ Social proof (user counts, testimonials)
    □ Monitor citation rate weekly

PITFALLS:
  ✗ Don't stuff keywords — AI detects low quality
  ✗ Don't copy competitors — AI deduplicates
  ✗ Don't ignore freshness — outdated = ignored
  ✗ Don't forget attribution — AI prefers cited sources
  ✓ Do provide unique value — original data wins
  ✓ Do update regularly — monthly at minimum
  ✓ Do use structured data — helps AI parse content
  ✓ Do be the primary source — don't just aggregate

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
GEO SEO - Generative Engine Optimization Reference

Commands:
  intro       What is GEO, SEO vs GEO comparison
  llms        llms.txt specification and best practices
  checklist   Full GEO optimization checklist
  monitor     Automated scanning, citation tracking, daily reports
  tracking    AI bot detection, WordPress tracker, nginx analysis
  aeo         Answer Engine Optimization — get cited by AI

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)     cmd_intro ;;
  llms)      cmd_llms ;;
  checklist) cmd_checklist ;;
  monitor)   cmd_monitor ;;
  tracking)  cmd_tracking ;;
  aeo)       cmd_aeo ;;
  help|*)    show_help ;;
esac
