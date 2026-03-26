#!/usr/bin/env bash
# seo-scout-pro — Website submit page discovery and form analysis
set -euo pipefail
VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
seo-scout-pro v1.0.0 — Submit Page Discovery & Form Analysis

Usage: seo-scout-pro <command>

Commands:
  scout-basic       Quick scan for submit pages
  scout-deep        Deep scan following links
  form-analysis     Detailed form field mapping
  auth-detect       Detect auth requirements
  cloudflare-check  Check Cloudflare protection
  adapter-template  Generate adapter boilerplate
  anti-detect       Browser stealth config guide
  manual-checklist  Manual submission checklist

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_scout_basic() {
    cat << 'EOF'
# Basic Scout — Quick Submit Page Discovery

## Usage
```bash
node src/cli.js scout https://target-directory.com
```

## What It Does
1. Loads target URL in stealth browser
2. Scans page for submit-related links:
   - /submit, /add, /new, /list-your, /get-listed
   - /suggest, /contribute, /register
3. Identifies visible form elements
4. Reports field names, types, and placeholders

## Manual Scout (No Browser)
```bash
# Quick curl-based check
URL="https://target-directory.com"

# Find submit links
curl -sL -A "Mozilla/5.0" "$URL" | \
  grep -oiP 'href="[^"]*(?:submit|add|new|list|suggest)[^"]*"' | \
  sort -u

# Find forms
curl -sL -A "Mozilla/5.0" "$URL" | \
  grep -oiP '<form[^>]*action="[^"]*"[^>]*>' | head -10

# Check for common submit paths
for path in /submit /add /new /list-your-tool /get-listed /suggest; do
  CODE=$(curl -sL -o /dev/null -w "%{http_code}" -A "Mozilla/5.0" "${URL}${path}")
  [ "$CODE" != "404" ] && echo "  Found: ${path} → HTTP ${CODE}"
done
```

## Output Example
```
🔍 Scouting https://example-directory.com

📋 Submit-related links found: 2
  /submit-tool (200)
  /add-your-app (200)

📝 Forms found: 1
  Form 1: action="/api/submit" method="POST"
    * [text] name (placeholder: "Tool name")
    * [url] website (placeholder: "https://...")
    * [textarea] description
    * [email] contact_email
    * [submit] Submit

🔐 Auth: No login required
🤖 CAPTCHA: None detected
```
EOF
}

cmd_scout_deep() {
    cat << 'EOF'
# Deep Scout — Follow Links to Find Hidden Submit Pages

## Usage
```bash
node src/cli.js scout https://target-directory.com --deep
```

## Deep Scout Strategy
1. Load homepage
2. Extract all internal links
3. Filter for submit-related paths
4. Visit each candidate page
5. Analyze forms on each page
6. Report all discovered submission points

## Manual Deep Scout
```bash
URL="https://target-directory.com"

# Get all internal links
curl -sL -A "Mozilla/5.0" "$URL" | \
  grep -oP 'href="/[^"]*"' | \
  sed 's/href="//;s/"//' | \
  sort -u > /tmp/links.txt

# Filter for submit-related
grep -iE 'submit|add|new|list|suggest|post|create|register' \
  /tmp/links.txt > /tmp/submit-links.txt

echo "Found $(wc -l < /tmp/submit-links.txt) potential submit pages"

# Check each
while read path; do
  FULL="${URL}${path}"
  CODE=$(curl -sL -o /dev/null -w "%{http_code}" -A "Mozilla/5.0" "$FULL")
  FORMS=$(curl -sL -A "Mozilla/5.0" "$FULL" | grep -c '<form')
  echo "  ${path} → HTTP ${CODE}, ${FORMS} forms"
done < /tmp/submit-links.txt
```

## Common Hidden Paths
- /submit-your-tool
- /add-new-listing
- /request-review
- /partner-with-us
- /list-your-product
- /get-featured
- /apply
- /nominate
EOF
}

cmd_form_analysis() {
    cat << 'EOF'
# Form Field Analysis

## Extract All Form Fields
```bash
URL="https://target-directory.com/submit"

curl -sL -A "Mozilla/5.0" "$URL" | python3 -c "
import sys, re

html = sys.stdin.read()

# Find all input/textarea/select elements
inputs = re.findall(r'<(?:input|textarea|select)[^>]*>', html, re.I)

for i, inp in enumerate(inputs):
    tag = 'input' if '<input' in inp.lower() else ('textarea' if '<textarea' in inp.lower() else 'select')
    name = re.search(r'name=[\"']([^\"']+)', inp)
    type_ = re.search(r'type=[\"']([^\"']+)', inp)
    placeholder = re.search(r'placeholder=[\"']([^\"']+)', inp)
    required = 'required' in inp.lower()

    print(f'  Field {i+1}:')
    print(f'    Tag: {tag}')
    print(f'    Name: {name.group(1) if name else \"(none)\"}')
    print(f'    Type: {type_.group(1) if type_ else \"text\"}')
    print(f'    Placeholder: {placeholder.group(1) if placeholder else \"(none)\"}')
    print(f'    Required: {required}')
    print()
"
```

## Field Type Mapping
| Field Type | What to Fill |
|-----------|-------------|
| text (name/title) | Product name |
| url/website | Product URL (clean, no UTM) |
| email | Contact email |
| textarea (desc) | Short or long description |
| select (category) | Best matching category |
| select (pricing) | free / freemium / paid |
| file (logo) | Logo image upload |
| hidden (csrf) | Don't touch — auto-handled |

## React/Vue Forms (No Static HTML)
If form fields aren't in HTML source:
```javascript
// Use browser console or Playwright
const inputs = document.querySelectorAll('input, textarea, select');
inputs.forEach(el => {
  console.log({
    name: el.name,
    type: el.type,
    placeholder: el.placeholder,
    id: el.id
  });
});
```
EOF
}

cmd_auth_detect() {
    cat << 'EOF'
# Authentication Detection

## Quick Auth Check
```bash
URL="https://target-directory.com/submit"

# Check for login redirects
FINAL=$(curl -sL -o /dev/null -w "%{url_effective}" -A "Mozilla/5.0" "$URL")
echo "Final URL: $FINAL"
# If redirected to /login or /auth → login required

# Check for OAuth buttons
curl -sL -A "Mozilla/5.0" "$URL" | \
  grep -ioP '(google|github|twitter|facebook|oauth|sign.?in|log.?in)' | \
  sort -u
```

## Auth Types & How to Handle

### No Auth (Best)
- Form is directly accessible
- Fill and submit immediately
- Examples: toolverto, submitaitools

### Email/Password Login
- Register account first
- Store credentials in config.yaml
- Login flow: fill email → fill password → click submit
- Handle: 2FA, email verification, CAPTCHA on login
- Examples: saashub, uneed

### Google OAuth
- "Sign in with Google" button
- First login: manual (2FA approval on phone)
- Subsequent: auto-select cached Google account
- Tip: do all OAuth sites in one browser session
- Examples: bai.tools

### GitHub OAuth
- Similar to Google OAuth
- Usually simpler (no 2FA after first approval)

### Magic Link (Email)
- Enter email → receive login link
- Cannot fully automate
- Semi-manual: enter email, click link in inbox

## CAPTCHA Detection
```bash
curl -sL -A "Mozilla/5.0" "$URL" | \
  grep -ioP '(captcha|recaptcha|hcaptcha|turnstile|challenge)' | \
  sort -u
```

| CAPTCHA Type | Automatable? |
|-------------|-------------|
| Color CAPTCHA | ✅ Text parsing |
| Simple math | ✅ Eval expression |
| reCAPTCHA v2 | ❌ Manual click |
| reCAPTCHA v3 | ⚠️ Sometimes passes |
| hCaptcha | ❌ Manual |
| Cloudflare Turnstile | ❌ Impossible |
EOF
}

cmd_cloudflare_check() {
    cat << 'EOF'
# Cloudflare Protection Level Check

## Quick Check
```bash
URL="https://target-directory.com"

# Check response headers
curl -sI -A "Mozilla/5.0" "$URL" | grep -i "cf-\|cloudflare\|server:"

# Check with bare request (no User-Agent)
BARE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
UA=$(curl -s -o /dev/null -w "%{http_code}" -A "Mozilla/5.0" "$URL")

echo "Bare request: HTTP $BARE"
echo "With User-Agent: HTTP $UA"
```

## Protection Levels

### Level 0: No Cloudflare
- server: nginx/apache
- Direct access, easy to automate

### Level 1: Basic WAF (403 → 200 with UA)
- Bare request: 403
- With User-Agent: 200
- rebrowser-playwright: ✅ Works

### Level 2: Challenge Page
- Returns challenge HTML ("Checking your browser")
- Requires JavaScript execution
- rebrowser-playwright: ❌ Cannot solve
- Action: Mark as manual-only

### Level 3: Turnstile CAPTCHA
- Interactive challenge widget
- No known automation solution
- Action: Submit manually

## Decision Tree
```
Is site on Cloudflare?
├── No → Automate freely
└── Yes → What level?
    ├── Basic WAF → Use rebrowser ✅
    ├── Challenge → Manual only ❌
    └── Turnstile → Manual only ❌
```
EOF
}

cmd_adapter_template() {
    cat << 'EOF'
# Site Adapter Template

## After scouting a new site, create an adapter:

```javascript
// src/sites/newsite.js
import { withBrowser, delay, humanType } from '../browser.js';

export default {
  // Metadata
  name: 'newsite.com',
  url: 'https://newsite.com/submit',
  auth: 'none',       // none | email | oauth
  captcha: 'none',    // none | color | recaptcha
  reviewTime: '1-3 days',
  backlinkType: 'dofollow',

  async submit(product, config) {
    return withBrowser(config, async ({ page }) => {
      // 1. Navigate
      console.log('  Loading submit page...');
      await page.goto('https://newsite.com/submit', {
        waitUntil: 'networkidle',
        timeout: 30000,
      });
      await delay(2000);

      // 2. Fill form (use field names from scout)
      await page.fill('input[name="tool_name"]', product.name);
      await delay(300);

      await page.fill('input[name="tool_url"]', product.url);
      await delay(300);

      await page.fill('textarea[name="description"]',
        product.long_description || product.description);
      await delay(300);

      await page.fill('input[name="email"]', product.email);
      await delay(300);

      // 3. Handle category dropdown (if exists)
      try {
        await page.selectOption('select[name="category"]',
          { label: 'Developer Tools' });
      } catch (e) {}

      // 4. Submit
      await page.click('button[type="submit"]');
      await delay(3000);

      // 5. Check result
      const body = await page.textContent('body');
      const success = /thank|success|submitted|review/i.test(body);

      return {
        url: page.url(),
        confirmation: success ? 'Submitted' : 'Check manually',
      };
    });
  },
};
```

## Testing
```bash
# Dry run (just loads the page, no submit)
node src/cli.js scout https://newsite.com/submit

# Real submission
node src/cli.js submit newsite
```
EOF
}

cmd_anti_detect() {
    cat << 'EOF'
# Browser Anti-Detection Configuration

## Stealth Browser Setup (rebrowser-playwright)
```javascript
import { chromium } from 'rebrowser-playwright';

const browser = await chromium.launch({
  headless: true,
  args: [
    '--disable-blink-features=AutomationControlled',
    '--no-sandbox',
    '--disable-dev-shm-usage',
  ],
});

const context = await browser.newContext({
  userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ' +
    'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',
  viewport: { width: 1440, height: 900 },
  locale: 'en-US',
  timezoneId: 'America/New_York',
});
```

## What rebrowser Patches
- navigator.webdriver → undefined ✅
- window.chrome → exists ✅
- Plugins array → populated ✅
- Languages → populated ✅
- WebDriver (legacy) → not detected ✅

## What Still Fails
- WebDriver (New) flag on sannysoft — 1 red item
- Cloudflare Challenge pages
- Reddit network-level blocking
- Sites checking datacenter IP ranges

## Human-Like Behavior
```javascript
// Random delays between actions
function delay(ms) {
  const jitter = Math.random() * ms * 0.3;
  return new Promise(r => setTimeout(r, ms + jitter));
}

// Character-by-character typing
async function humanType(page, selector, text) {
  await page.click(selector);
  await delay(200);
  await page.fill(selector, '');
  for (const char of text) {
    await page.type(selector, char, {
      delay: 30 + Math.random() * 70
    });
  }
}
```

## Why Not Regular Playwright?
Regular Playwright sets `navigator.webdriver = true`.
This is detected by ~70% of directory sites.
rebrowser patches this at the Chromium compilation level.
EOF
}

cmd_manual_checklist() {
    cat << 'EOF'
# Manual Submission Checklist

Use this for sites that can't be automated (Cloudflare, complex forms).

## Before You Start
- [ ] Product name finalized
- [ ] One-line description ready (< 160 chars)
- [ ] Long description ready (2-3 paragraphs)
- [ ] Website URL live and working
- [ ] Contact email ready
- [ ] Logo image (if required, usually 200x200 PNG)
- [ ] Category determined (AI Tools / Developer Tools / etc.)

## Submission Steps
1. [ ] Visit the submit page
2. [ ] Create account if required
3. [ ] Fill product name
4. [ ] Paste website URL (clean, no UTM params)
5. [ ] Select best category
6. [ ] Paste short description
7. [ ] Paste long description (if field exists)
8. [ ] Upload logo (if field exists)
9. [ ] Enter contact email
10. [ ] Select pricing model (Free/Freemium/Paid)
11. [ ] Complete CAPTCHA (if any)
12. [ ] Click Submit
13. [ ] Screenshot confirmation page
14. [ ] Log submission date and expected review time

## After Submission
- [ ] Check email for confirmation/verification
- [ ] Set calendar reminder for expected review date
- [ ] After approval: verify listing is live
- [ ] After approval: check backlink with Ahrefs/Semrush
- [ ] Track referral traffic in Google Analytics

## UTM Tracking
When sites allow custom URLs, append tracking:
```
https://yoursite.com?utm_source=directoryname&utm_medium=directory&utm_campaign=backlink
```
EOF
}

case "${1:-help}" in
    scout-basic)      cmd_scout_basic ;;
    scout-deep)       cmd_scout_deep ;;
    form-analysis)    cmd_form_analysis ;;
    auth-detect)      cmd_auth_detect ;;
    cloudflare-check) cmd_cloudflare_check ;;
    adapter-template) cmd_adapter_template ;;
    anti-detect)      cmd_anti_detect ;;
    manual-checklist) cmd_manual_checklist ;;
    help|-h)          show_help ;;
    version|-v)       echo "seo-scout-pro v$VERSION" ;;
    *)                echo "Unknown: $1"; show_help ;;
esac
