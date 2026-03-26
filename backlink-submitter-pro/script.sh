#!/usr/bin/env bash
# backlink-submitter-pro — Automated directory site submission toolkit
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
backlink-submitter-pro v1.0.0 — Directory Site Submission Toolkit

Usage: backlink-submitter-pro <command>

Commands:
  setup          Configure product info
  submit-all     Submit to all supported sites
  submit-site    Submit to a specific site
  scout          Discover submit pages on any URL
  check-status   Check submission status
  site-list      Show supported directory sites
  rate-guide     Submission pacing guidelines
  troubleshoot   Common issues and solutions

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_setup() {
    cat << 'EOF'
# Product Configuration Guide

## config.yaml Structure

```yaml
product:
  name: "Your Product Name"
  url: "https://yourproduct.com"
  description: "Short description (under 160 chars for SEO)"
  long_description: |
    Detailed description for directory sites that need more text.
    Include key features, what makes it unique, and who it's for.
  email: "hello@yourproduct.com"
  categories:
    - developer-tools
    - productivity
  pricing: free  # free | freemium | paid

  # Optional fields
  logo_url: ""
  github_url: ""
  twitter: ""
  features:
    - "Feature 1"
    - "Feature 2"
    - "Feature 3"

credentials:
  saashub:
    email: ""
    password: ""
  uneed:
    email: ""
    password: ""

utm:
  base_url: "https://yourproduct.com"
  medium: "directory"
  campaign: "backlink"

browser:
  headless: true
  slow_mo: 100
  timeout: 30000

pacing:
  min_interval_ms: 60000        # 1 min between sites
  same_site_interval_ms: 3600000  # 1 hour same site retry
```

## Setup Steps

1. Copy config.example.yaml to config.yaml
2. Fill in your product details
3. Add credentials for login-required sites (optional)
4. Run: `backlink-submitter-pro submit-all`

## Important

- config.yaml contains passwords → gitignore it
- UTM params auto-append to submitted URLs for tracking
- Test with a single site first: `submit-site toolverto`
EOF
}

cmd_submit_all() {
    cat << 'EOF'
# Batch Submission Workflow

## Recommended Order (easiest first)

### Phase 1: No Login Required
```bash
# These sites accept anonymous submissions
backlink-submitter-pro submit-site toolverto
sleep 120
backlink-submitter-pro submit-site submitaitools
sleep 120
backlink-submitter-pro submit-site dangai
sleep 120
backlink-submitter-pro submit-site startup88
```

### Phase 2: Login Required
```bash
# First login is manual (2FA approval needed)
backlink-submitter-pro submit-site saashub
sleep 120
backlink-submitter-pro submit-site uneed
```

### Phase 3: Google OAuth
```bash
# Do these in one browser session after first Google login
backlink-submitter-pro submit-site baitools
```

## Pacing Rules

- **Minimum 2 minutes** between different sites
- **Minimum 1 hour** before retrying same site
- **5-10 sites per day** is safe
- **Never submit same product twice** to same site

## After Submission

Most sites review within 1-7 days. Premium placement:
- IndieHub: $4.9 (skip)
- OpenHunts: 51 week free queue (skip)
- Toolify: $99 (skip unless high budget)
- Product Hunt: Manual only, no automation

## Tracking

All submissions logged to `logs/submissions.yaml`
Check status: `backlink-submitter-pro check-status`
EOF
}

cmd_submit_site() {
    cat << 'EOF'
# Submit to Specific Site

## Usage
```bash
# Via CLI
node src/cli.js submit <site-name>

# Available site names:
# toolverto, submitaitools, dangai, startup88
# saashub, uneed, baitools, 600tools
```

## Site-Specific Notes

### toolverto (Easiest)
- URL: https://toolverto.com/en/submit-tool
- 3 fields: name, website, description
- No login, no CAPTCHA
- Review: 1-3 days

### submitaitools (DA 73 — High Value)
- URL: https://submitaitools.org/submit/
- Color CAPTCHA auto-solved
- No login needed
- Review: 1-3 days

### saashub (Fast Approval)
- Requires email/password login
- Same-day approval typical
- Good for SaaS/tool products

### uneed (DR 72 — High Value)
- Requires email/password login
- Long queue but high domain authority
- Worth the wait

### startup88
- Uses Typeform embedded form
- May need manual completion
- Review: 1-2 weeks

### dangai
- React SPA — form may need page.evaluate()
- Review: 3-4 weeks
- Free submission

### 600tools
- Cloudflare Turnstile CAPTCHA
- Cannot automate — manual submission only
- 3 dofollow backlinks (high value)

### baitools
- Google OAuth required
- First login needs manual 2FA
- Subsequent logins auto-select cached account
EOF
}

cmd_scout() {
    cat << 'EOF'
# Site Scout — Discover Submit Pages

## Usage
```bash
# Basic scout
node src/cli.js scout https://new-directory.com

# Deep scout (follows links)
node src/cli.js scout https://new-directory.com --deep

# With screenshot
node src/cli.js scout https://new-directory.com --screenshot ./scout.png
```

## What Scout Does

1. Loads the target URL in stealth browser
2. Scans for submit-related links (/submit, /add, /new)
3. Detects form fields (input names, placeholders, types)
4. Checks authentication requirements
5. Detects CAPTCHA presence
6. Reports findings

## Scout Output Example
```
📋 Submit-related links found: 3
  /submit-tool
  /add-your-product
  /new-listing

📝 Form 1 (4 fields):
  * [text] tool_name (required)
  * [url] tool_url (required)
  * [textarea] tool_desc
  * [email] contact

🔐 Auth signals:
  Login required: No
  OAuth available: —
  CAPTCHA detected: Color CAPTCHA
```

## Writing New Adapters

After scouting, create `src/sites/newsite.js`:

```javascript
import { withBrowser, delay } from '../browser.js';

export default {
  name: 'new-site.com',
  url: 'https://new-site.com/submit',
  auth: 'none',
  captcha: 'none',

  async submit(product, config) {
    return withBrowser(config, async ({ page }) => {
      await page.goto('https://new-site.com/submit');
      await delay(1500);
      // Fill fields from scout output
      await page.fill('input[name="tool_name"]', product.name);
      await page.fill('input[name="tool_url"]', product.url);
      await page.click('button[type="submit"]');
      await delay(3000);
      return { url: page.url() };
    });
  },
};
```
EOF
}

cmd_check_status() {
    cat << 'EOF'
# Submission Status Tracking

## Check Status
```bash
node src/cli.js status
```

## Status Output
```
📊 Submission History
─────────────────────────────────────
Site              Status    Date        Product
toolverto         ✅ Done   2026-03-24  BytesAgain
submitaitools     ⏳ Review 2026-03-24  BytesAgain
startup88         ✅ Done   2026-03-24  BytesAgain
saashub           📝 Draft  —           —
uneed             📝 Draft  —           —
─────────────────────────────────────
Total: 3/8 submitted | 2 approved | 1 pending
```

## Log File Location
- Submissions: `logs/submissions.yaml`
- Screenshots: `screenshots/`

## Verification

After approval, verify your listing:
1. Google: `site:directory.com "your product name"`
2. Check backlink: Ahrefs/Semrush → referring domains
3. Monitor referral traffic in Google Analytics
EOF
}

cmd_site_list() {
    cat << 'EOF'
# Supported Directory Sites

## Tier 1: Free, No Login
| Site | Domain Auth | Review | Backlink Type |
|------|------------|--------|---------------|
| toolverto.com | Medium | 1-3 days | dofollow |
| submitaitools.org | DA 73 | 1-3 days | mixed |
| dang.ai | DA 35 | 3-4 weeks | dofollow |
| startup88.com | DA 34 | 1-2 weeks | dofollow |
| 600.tools | Medium | 1-3 days | 3x dofollow |

## Tier 2: Login Required
| Site | Domain Auth | Review | Backlink Type |
|------|------------|--------|---------------|
| saashub.com | High | Same day | dofollow |
| uneed.best | DR 72 | Queued | dofollow |
| bai.tools | Medium | ~30 days | dofollow |

## Tier 3: Paid / Manual Only
| Site | Cost | Notes |
|------|------|-------|
| Product Hunt | Free | Manual only, no automation |
| Toolify.ai | $99 | High traffic if approved |
| IndieHub | $4.9 | Low value |
| OpenHunts | Free | 51 week queue |

## Tier 4: Community (Manual)
- Hacker News (Show HN)
- Reddit (r/SideProject)
- V2EX, 即刻
- Dev.to, Medium, CSDN
EOF
}

cmd_rate_guide() {
    cat << 'EOF'
# Submission Rate Limiting Guide

## Safe Pacing
- 2+ minutes between different sites
- 1+ hour before retrying same site
- 5-10 submissions per day maximum
- Never submit same product to same site twice

## What Gets You Blocked
- Rapid-fire submissions (< 1 min apart)
- Same product submitted multiple times
- Bot-like behavior (no delays, no mouse movement)
- Datacenter IP addresses (some sites block AWS/GCP ranges)

## Anti-Detection Measures
- rebrowser-playwright patches navigator.webdriver
- Chrome-like User-Agent and viewport
- Human-like typing delays (30-100ms per character)
- Random jitter on all wait times

## Cloudflare Levels
1. Basic WAF (403) — rebrowser bypasses ✅
2. Challenge page — cannot bypass ❌
3. Turnstile CAPTCHA — cannot bypass ❌

## Rate Limit Recovery
- Most sites: wait 24 hours, try again
- Cloudflare block: may need different IP
- Account ban: contact site support

## IndexNow (No Rate Limit)
```bash
node src/cli.js indexnow https://yoursite.com
```
Notifies Bing, Yandex, and IndexNow API instantly.
No rate limits, no authentication needed.
EOF
}

cmd_troubleshoot() {
    cat << 'EOF'
# Troubleshooting Guide

## Browser Issues

### "Executable doesn't exist"
```bash
npx rebrowser-playwright install chromium
```

### "libatk-1.0.so.0 not found"
```bash
# CentOS/RHEL
sudo yum install -y atk cups-libs pango nss libdrm mesa-libgbm alsa-lib

# Ubuntu/Debian
sudo apt install -y libatk1.0-0 libcups2 libpango-1.0-0 libnss3
```

### Version mismatch (chromium-1169 vs 1208)
```bash
cd ~/.cache/ms-playwright
ln -s chromium-1208 chromium-1169
ln -s chromium_headless_shell-1208 chromium_headless_shell-1169
# Fix path structure
cd chromium_headless_shell-1169
mkdir -p chrome-linux
ln -sf ../chrome-headless-shell-linux64/chrome-headless-shell chrome-linux/headless_shell
```

## Site-Specific Issues

### toolverto: 404 on /submit
URL changed to /en/submit-tool (2026-03-24)

### submitaitools: Server 500
Site is down. Wait and retry later.

### 600tools: Cloudflare Turnstile
Cannot automate. Submit manually at https://600.tools/submit

### dangai: Form fields not found
React SPA with client-side rendering. Headless shell can't access
hydrated DOM. Use full Chromium (not headless-shell) or submit manually.

### saashub: 403 Forbidden
Cloudflare protection. Use rebrowser with Chrome User-Agent.
If still blocked, submit manually.

## Google OAuth Sites
- First login requires manual 2FA approval
- Do all OAuth sites in one browser session
- Sessions don't persist across chromium.launch()
- Use storageState to save/restore cookies
EOF
}

# Main
case "${1:-help}" in
    setup)          cmd_setup ;;
    submit-all)     cmd_submit_all ;;
    submit-site)    cmd_submit_site ;;
    scout)          cmd_scout ;;
    check-status)   cmd_check_status ;;
    site-list)      cmd_site_list ;;
    rate-guide)     cmd_rate_guide ;;
    troubleshoot)   cmd_troubleshoot ;;
    help|-h)        show_help ;;
    version|-v)     echo "backlink-submitter-pro v$VERSION" ;;
    *)              echo "Unknown: $1"; show_help ;;
esac
