#!/usr/bin/env bash
# awesome-submitter-pro — GitHub awesome-list submission generator
set -euo pipefail
VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
awesome-submitter-pro v1.0.0 — Awesome-List Submission Generator

Usage: awesome-submitter-pro <command>

Commands:
  generate       Generate Issue content for an awesome-list
  repo-list      Show supported awesome-list repositories
  find-lists     Find relevant awesome-lists
  submit-guide   Step-by-step submission guide
  format-rules   Formatting requirements per repo
  pr-vs-issue    Pull Request vs Issue decision guide
  success-tips   Tips for getting accepted
  track          Track submission status

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_generate() {
    cat << 'EOF'
# Generate Awesome-List Submission

## Issue Template
```markdown
## Add: [Your Product Name]

**Link:** https://yourproduct.com
**Description:** One-line description of what it does.
**Category:** [Most relevant section in the list]

**Why it fits this list:**
- [Reason 1: what problem it solves]
- [Reason 2: what makes it unique]
- [Reason 3: who benefits from it]

**Features:**
- Feature 1
- Feature 2
- Feature 3

---
I believe this project would be a valuable addition to this awesome list.
```

## Pull Request Template (if repo prefers PRs)
```markdown
## Add [Your Product Name]

Added [Your Product Name](https://yourproduct.com) to the [Section Name] section.

**Description:** Brief description.

**Checklist:**
- [x] Read the contribution guidelines
- [x] Link is not a duplicate
- [x] Description is concise and accurate
- [x] Added in alphabetical order (if required)
- [x] Verified the link works
```

## Auto-Generate Issue URL
```bash
REPO="owner/repo-name"
TITLE="Add Your Product"
BODY="## Add: Your Product..."

# URL-encode and open
URL="https://github.com/${REPO}/issues/new?title=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$TITLE'))")&body=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$BODY'''))")"

echo "Open this URL to create the issue:"
echo "$URL"
```
EOF
}

cmd_repo_list() {
    cat << 'EOF'
# Supported Awesome-List Repositories

## Tier 1: High Stars (Best Backlink Value)
| Repository | Stars | Category | Accepts |
|-----------|-------|----------|---------|
| sindresorhus/awesome | 350K+ | Meta list | PR only |
| awesome-selfhosted/awesome-selfhosted | 210K+ | Self-hosted apps | PR only |
| RunaCapital/awesome-oss-alternatives | 18K+ | OSS alternatives | Issue/PR |
| zhuima/awesome-cloudflare | 12K+ | Cloudflare tools | Issue/PR |
| mezod/awesome-indie | 10K+ | Indie projects | Issue/PR |

## Tier 2: Medium Stars (Good Value)
| Repository | Stars | Category | Accepts |
|-----------|-------|----------|---------|
| Lissy93/awesome-privacy | 8K+ | Privacy tools | PR only |
| Axorax/awesome-free-apps | 5K+ | Free apps | Issue/PR |
| one-aalam/awesome-astro | 3K+ | Astro ecosystem | Issue/PR |
| nichetools/awesome-pwa | 2K+ | PWA resources | Issue/PR |
| nichetools/awesome-no-login-web-apps | 2K+ | No-login apps | Issue/PR |

## Tier 3: Niche (Targeted Traffic)
| Repository | Stars | Category | Accepts |
|-----------|-------|----------|---------|
| chinese-independent-developer | 5K+ | Chinese indie dev | Issue/PR |
| awesome-ai-tools | 3K+ | AI tools | Issue/PR |
| awesome-llm-apps | 2K+ | LLM applications | Issue/PR |

## Finding More Lists
```bash
# Search GitHub for relevant awesome-lists
# https://github.com/search?q=awesome+ai+tools&type=repositories&sort=stars
```

## Selection Criteria
- Stars > 1,000 (for meaningful domain authority)
- Active maintenance (last commit < 6 months)
- Clear contribution guidelines
- Accepts external submissions
EOF
}

cmd_find_lists() {
    cat << 'EOF'
# Find Relevant Awesome-Lists

## By Product Category

### AI / Machine Learning
- awesome-artificial-intelligence
- awesome-machine-learning
- awesome-deep-learning
- awesome-ai-tools
- awesome-llm-apps
- awesome-chatgpt-plugins

### Developer Tools
- awesome-selfhosted
- awesome-dev-tools
- awesome-cli-apps
- awesome-shell

### Productivity
- awesome-productivity
- awesome-no-login-web-apps
- awesome-free-apps

### Security
- awesome-security
- awesome-hacking
- awesome-privacy

### Blockchain / Crypto
- awesome-blockchain
- awesome-defi
- awesome-web3

## Search Strategy
```bash
# GitHub search for awesome-lists in your niche
# Replace KEYWORD with your domain
open "https://github.com/search?q=awesome+KEYWORD&type=repositories&sort=stars"

# Check if list is active
curl -s "https://api.github.com/repos/OWNER/REPO" | \
  python3 -c "import sys,json; d=json.load(sys.stdin); \
  print(f'Stars: {d[\"stargazers_count\"]}'); \
  print(f'Updated: {d[\"updated_at\"]}')"
```

## Qualification Checklist
Before submitting to any awesome-list:
- [ ] Your product genuinely fits the list's category
- [ ] Your product is functional and live
- [ ] The list is actively maintained (commits in last 6 months)
- [ ] The list accepts external submissions
- [ ] Your product isn't already listed
- [ ] You've read the CONTRIBUTING.md
EOF
}

cmd_submit_guide() {
    cat << 'EOF'
# Step-by-Step Submission Guide

## Step 1: Research the Repository
```bash
# Check repo info
curl -s "https://api.github.com/repos/OWNER/REPO" | \
  python3 -c "
import sys, json
d = json.load(sys.stdin)
print(f'Stars: {d[\"stargazers_count\"]}')
print(f'Open Issues: {d[\"open_issues_count\"]}')
print(f'Last Push: {d[\"pushed_at\"]}')
print(f'License: {d.get(\"license\", {}).get(\"spdx_id\", \"None\")}')
"
```

## Step 2: Read Contribution Guidelines
- Check CONTRIBUTING.md
- Check README for submission rules
- Some repos require specific formatting
- Some only accept Pull Requests (not Issues)

## Step 3: Prepare Your Entry
Standard format (most repos):
```markdown
- [Product Name](https://producturl.com) — Brief description.
```

Extended format (some repos):
```markdown
- [Product Name](https://producturl.com) — Brief description. `Tag1` `Tag2`
```

## Step 4: Submit

### Via Issue
1. Go to repo → Issues → New Issue
2. Title: "Add [Product Name]"
3. Body: Use the generate template
4. Submit

### Via Pull Request
1. Fork the repo
2. Edit README.md — add your entry in correct section
3. Maintain alphabetical order (if required)
4. Commit with message: "Add [Product Name]"
5. Create PR with description

## Step 5: Wait
- Most maintainers respond within 1-4 weeks
- Be patient, don't ping repeatedly
- If no response after 1 month, try a different list

## Step 6: After Acceptance
- Star the repo (good etiquette)
- Thank the maintainer
- Share the listing on social media
- Track referral traffic from GitHub
EOF
}

cmd_format_rules() {
    cat << 'EOF'
# Formatting Rules by Repository

## sindresorhus/awesome (The Meta List)
- PR only (no Issues for additions)
- Must follow awesome-lint rules
- Entry format: `- [Name](url) - Description.`
- Description starts lowercase, ends with period
- Alphabetical order within section
- No promotional language

## awesome-selfhosted
- PR only
- Format: `- [Name](url) - Description. ([Demo](url), [Source](url)) `License` `Language``
- Must be self-hostable
- Must include license and language tags
- Strict quality requirements

## awesome-indie (mezod)
- Issue or PR accepted
- More relaxed formatting
- Good for indie products and side projects

## awesome-oss-alternatives (RunaCapital)
- Issue or PR
- Format: `| Name | Description | Stars | License |`
- Table format within categories
- Must be open-source alternative to commercial product

## General Rules (Most Repos)
1. One entry per PR/Issue
2. No duplicate entries
3. Working link required
4. Concise description (one sentence)
5. Correct section/category
6. Follow existing format exactly
7. Don't add promotional superlatives
EOF
}

cmd_pr_vs_issue() {
    cat << 'EOF'
# Pull Request vs Issue — When to Use Each

## Use Issue When:
- Repo explicitly says "create an Issue to suggest"
- You're not sure which section to add to
- You want maintainer to decide placement
- You don't want to fork the repo
- Quick and easy

## Use Pull Request When:
- Repo says "PRs only" or "no Issues for additions"
- Repo has CONTRIBUTING.md with PR instructions
- You want faster processing (PRs often get merged faster)
- You know exactly where your entry belongs

## Most Repos Accept Both
When in doubt, check:
1. CONTRIBUTING.md
2. Recent closed Issues (do they accept additions via Issues?)
3. Recent merged PRs (do they merge external additions?)

## PR Best Practices
- Fork → Edit in browser (no need to clone)
- One addition per PR
- Match existing format exactly
- Write clear PR description
- Don't modify other entries
- If CI checks fail, fix them before asking for review
EOF
}

cmd_success_tips() {
    cat << 'EOF'
# Tips for Getting Accepted

## DO
- Read the entire README first
- Match the exact formatting of existing entries
- Be concise — one sentence descriptions
- Explain why your product fits the list
- Star the repo before submitting
- Be patient — maintainers are volunteers

## DON'T
- Don't use marketing language ("revolutionary", "best", "#1")
- Don't submit to irrelevant lists
- Don't submit broken links
- Don't submit multiple times if ignored
- Don't argue if rejected
- Don't submit very new products (< 1 month old)

## Increase Acceptance Rate
1. **Have a good README** — maintainers will click your link
2. **Be established** — GitHub stars, users, or downloads help
3. **Be relevant** — only submit to lists where you truly fit
4. **Be helpful** — fix typos or dead links in the same PR
5. **Engage** — star the repo, comment on other Issues

## Rejection Reasons (and how to avoid)
| Reason | Prevention |
|--------|-----------|
| "Not a good fit" | Research the list's scope first |
| "Low quality" | Improve your product page/README |
| "Duplicate" | Search the list before submitting |
| "Wrong format" | Copy exact format from existing entries |
| "No response" | Try again after 2 months, or try different list |
EOF
}

cmd_track() {
    cat << 'EOF'
# Track Submission Status

## Manual Tracking Spreadsheet
```
| Repo | Status | Date | PR/Issue # | Notes |
|------|--------|------|-----------|-------|
| awesome-indie | ⏳ Open | 2026-03-24 | #142 | Awaiting review |
| awesome-free-apps | ✅ Merged | 2026-03-20 | #89 | Accepted! |
| awesome-selfhosted | ❌ Closed | 2026-03-18 | #201 | "Not self-hosted" |
```

## Check Status via API
```bash
# Check if your Issue/PR is still open
curl -s "https://api.github.com/repos/OWNER/REPO/issues/NUMBER" | \
  python3 -c "
import sys, json
d = json.load(sys.stdin)
print(f'Status: {d[\"state\"]}')
print(f'Created: {d[\"created_at\"]}')
print(f'Comments: {d[\"comments\"]}')
if d.get('pull_request'):
    print(f'Merged: {d[\"pull_request\"].get(\"merged_at\", \"Not merged\")}')
"
```

## Backlink Verification
After acceptance, verify the backlink exists:
```bash
# Check if your URL appears in the repo's README
curl -s "https://raw.githubusercontent.com/OWNER/REPO/main/README.md" | \
  grep -i "yourproduct.com" && echo "✅ Backlink found!" || echo "❌ Not found"
```

## Track Referral Traffic
In Google Analytics:
- Acquisition → Referral → github.com
- Filter by specific repo paths
EOF
}

case "${1:-help}" in
    generate)       cmd_generate ;;
    repo-list)      cmd_repo_list ;;
    find-lists)     cmd_find_lists ;;
    submit-guide)   cmd_submit_guide ;;
    format-rules)   cmd_format_rules ;;
    pr-vs-issue)    cmd_pr_vs_issue ;;
    success-tips)   cmd_success_tips ;;
    track)          cmd_track ;;
    help|-h)        show_help ;;
    version|-v)     echo "awesome-submitter-pro v$VERSION" ;;
    *)              echo "Unknown: $1"; show_help ;;
esac
