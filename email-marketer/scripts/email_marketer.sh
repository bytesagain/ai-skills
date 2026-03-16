#!/usr/bin/env bash
# Email Marketer — Complete email marketing toolkit
# Original implementation by BytesAgain (bytesagain.com)
# License: MIT
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

# Parse args
TYPE="" PRODUCT="" AUDIENCE="" TOPIC="" COUNT="5" STEPS="5" FORMAT="markdown" BRAND="" STYLE="professional" TOPICS=""
while [ $# -gt 0 ]; do
    case "$1" in
        --type) TYPE="$2"; shift 2 ;;
        --product) PRODUCT="$2"; shift 2 ;;
        --audience) AUDIENCE="$2"; shift 2 ;;
        --topic) TOPIC="$2"; shift 2 ;;
        --topics) TOPICS="$2"; shift 2 ;;
        --count) COUNT="$2"; shift 2 ;;
        --steps) STEPS="$2"; shift 2 ;;
        --format) FORMAT="$2"; shift 2 ;;
        --brand) BRAND="$2"; shift 2 ;;
        --style) STYLE="$2"; shift 2 ;;
        *) shift ;;
    esac
done

BRAND="${BRAND:-YourBrand}"
PRODUCT="${PRODUCT:-Your Product}"
AUDIENCE="${AUDIENCE:-subscribers}"

_campaign() {
    local ctype="${TYPE:-launch}"
    cat << CAMP
# Email Campaign: ${PRODUCT} (${ctype})

## Target Audience
${AUDIENCE}

## Campaign Overview
- **Type**: ${ctype}
- **Emails**: 3-part series
- **Timing**: Day 0 → Day 2 → Day 5

---

### Email 1: Announcement (Day 0)

**Subject Line Options:**
1. "Introducing ${PRODUCT} — Your ${AUDIENCE} Will Thank You"
2. "🚀 ${PRODUCT} is here. Here's why it matters."
3. "We built ${PRODUCT} because ${AUDIENCE} deserve better"

**Preview Text:** The tool you've been waiting for is finally here.

**Body:**

Hi {{first_name}},

We're excited to announce **${PRODUCT}** — built specifically for ${AUDIENCE}.

Here's what makes it different:

✅ **Problem-first design** — We started with your pain points
✅ **Instant value** — See results in the first 5 minutes
✅ **No learning curve** — If you can click a button, you can use it

**[Get Started Free →]({{cta_link}})**

Best,
The ${BRAND} Team

---

### Email 2: Social Proof (Day 2)

**Subject:** "${PRODUCT} in action — real results from real ${AUDIENCE}"

**Body:**

Hi {{first_name}},

Since we launched ${PRODUCT} two days ago, here's what's happened:

📊 **1,000+** ${AUDIENCE} signed up
⭐ **4.8/5** average rating
💬 "This changed how I work" — Beta User

Don't take our word for it. **Try it yourself.**

**[Start Your Free Trial →]({{cta_link}})**

---

### Email 3: Urgency (Day 5)

**Subject:** "Last chance: ${PRODUCT} early-bird pricing ends tomorrow"

**Body:**

Hi {{first_name}},

Quick reminder — our launch pricing for ${PRODUCT} ends **tomorrow at midnight**.

After that, prices go up. Here's what you'll miss:

❌ 50% off annual plan
❌ Priority support access
❌ Lifetime feature lock

**[Lock In Your Price →]({{cta_link}})**

---

## Campaign Metrics to Track
| Metric | Benchmark | Target |
|--------|-----------|--------|
| Open Rate | 20-25% | 30%+ |
| Click Rate | 2-5% | 5%+ |
| Conversion | 1-3% | 3%+ |
| Unsubscribe | <0.5% | <0.3% |

CAMP
}

_newsletter() {
    local items="${TOPICS:-Product Update, Industry News, Tips and Tricks}"
    IFS=',' read -ra SECTIONS <<< "$items"
    
    if [ "$FORMAT" = "html" ]; then
        cat << NHTML
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
<body style="margin:0;padding:0;background:#f4f4f4;font-family:Arial,sans-serif;">
<div style="max-width:600px;margin:0 auto;background:#fff;">

<!-- Header -->
<div style="background:linear-gradient(135deg,#667eea,#764ba2);padding:30px;text-align:center;">
<h1 style="color:#fff;margin:0;font-size:24px;">${BRAND} Newsletter</h1>
<p style="color:rgba(255,255,255,0.8);margin:5px 0 0;">$(date '+%B %Y')</p>
</div>

<!-- Intro -->
<div style="padding:20px 30px;">
<p>Hi {{first_name}},</p>
<p>Here's what's new this month:</p>
</div>
NHTML
        local i=1
        for section in "${SECTIONS[@]}"; do
            section=$(echo "$section" | xargs)
            cat << NSEC

<!-- Section $i -->
<div style="padding:15px 30px;border-bottom:1px solid #eee;">
<h2 style="color:#333;font-size:18px;">📌 ${section}</h2>
<p style="color:#666;line-height:1.6;">
[Write 2-3 sentences about ${section}. Include specific details, numbers, or quotes to make it engaging.]
</p>
<a href="{{link_$i}}" style="color:#667eea;text-decoration:none;font-weight:bold;">Read more →</a>
</div>
NSEC
            i=$((i+1))
        done
        
        cat << NFOOT

<!-- CTA -->
<div style="padding:25px 30px;text-align:center;">
<a href="{{main_cta}}" style="display:inline-block;padding:12px 30px;background:#667eea;color:#fff;text-decoration:none;border-radius:6px;font-weight:bold;">Check It Out</a>
</div>

<!-- Footer -->
<div style="padding:20px 30px;background:#f8f8f8;text-align:center;font-size:12px;color:#999;">
<p>${BRAND} · {{address}}</p>
<p><a href="{{unsubscribe}}" style="color:#999;">Unsubscribe</a> | <a href="{{preferences}}" style="color:#999;">Preferences</a></p>
</div>

</div>
</body>
</html>
NFOOT
    else
        cat << NMD
# ${BRAND} Newsletter — $(date '+%B %Y')

Hi {{first_name}},

Here's what's new this month:

NMD
        local i=1
        for section in "${SECTIONS[@]}"; do
            section=$(echo "$section" | xargs)
            echo "## 📌 ${section}"
            echo ""
            echo "[Write 2-3 sentences about ${section}. Include specific details.]"
            echo ""
            echo "[Read more →]({{link_$i}})"
            echo ""
            i=$((i+1))
        done
        echo "---"
        echo "**[Main CTA Button →]({{main_cta}})**"
        echo ""
        echo "*${BRAND} · [Unsubscribe]({{unsubscribe}}) · [Preferences]({{preferences}})*"
    fi
}

_sequence() {
    local stype="${TYPE:-onboarding}"
    local nsteps="${STEPS:-5}"
    
    cat << SEQ
# Drip Sequence: ${stype} (${nsteps} emails)
**Product**: ${PRODUCT}
**Audience**: ${AUDIENCE}

---
SEQ
    
    local i=1
    local delays=("Immediate" "Day 1" "Day 3" "Day 5" "Day 7" "Day 10" "Day 14" "Day 21" "Day 30")
    local onboard_subjects=("Welcome to ${PRODUCT}!" "Quick win: Your first 5 minutes" "3 features you haven't tried yet" "How others use ${PRODUCT}" "You're a pro now — what's next?" "Unlock advanced features" "Your ${PRODUCT} journey so far")
    local nurture_subjects=("Thought you'd find this useful" "A quick question for you" "This strategy increased results by 47%" "Free resource: ${PRODUCT} playbook" "What top ${AUDIENCE} do differently" "Exclusive: early access to new features" "Your personalized recommendation")
    local winback_subjects=("We miss you!" "Things have changed since you left" "Here's what you're missing" "Special offer — just for you" "Last chance: Your account data")
    
    while [ $i -le "$nsteps" ] && [ $i -le 7 ]; do
        local delay="${delays[$((i-1))]}"
        local subject
        case "$stype" in
            onboarding) subject="${onboard_subjects[$((i-1))]}" ;;
            nurture) subject="${nurture_subjects[$((i-1))]}" ;;
            winback) subject="${winback_subjects[$((i-1))]}" ;;
            *) subject="Email $i: ${stype} step $i" ;;
        esac
        
        cat << STEP

### Email $i — ${delay}
**Subject:** "${subject}"
**Goal:** $([ $i -eq 1 ] && echo "First impression & quick win" || ([ $i -eq "$nsteps" ] && echo "Convert or re-engage" || echo "Build value & trust"))

**Key Points:**
- [Point 1: specific value or tip]
- [Point 2: social proof or data]
- [Point 3: clear next action]

**CTA:** [Action Button Text]

**Trigger for next:** $([ $i -lt "$nsteps" ] && echo "Opens email OR waits ${delays[$i]}" || echo "End of sequence → move to regular newsletter")

---
STEP
        i=$((i+1))
    done
    
    cat << METRICS

## Sequence Benchmarks
| Email # | Expected Open Rate | Expected Click Rate |
|---------|-------------------|-------------------|
| 1 | 50-60% | 10-15% |
| 2 | 35-45% | 5-8% |
| 3 | 25-35% | 3-5% |
| 4+ | 20-30% | 2-4% |

## Optimization Tips
1. **Test send times**: Tuesday/Thursday 10am tend to perform best
2. **Segment non-openers**: Re-send with different subject after 48h
3. **Track drop-off**: If open rate drops >50% between emails, revise content
4. **Personalize**: Use {{first_name}} and behavior-based content
METRICS
}

_subject() {
    local t="${TOPIC:-Product Launch}"
    local n="${COUNT:-10}"
    
    echo "# Subject Line Generator"
    echo "**Topic:** ${t}"
    echo "**Count:** ${n}"
    echo ""
    
    local styles=("curiosity" "urgency" "benefit" "question" "number" "personal" "emoji" "controversy" "fomo" "story")
    local i=0
    while [ $i -lt "$n" ] && [ $i -lt 10 ]; do
        local s="${styles[$i]}"
        case "$s" in
            curiosity)   echo "$((i+1)). [CURIOSITY] \"The secret behind ${t} that nobody talks about\"" ;;
            urgency)     echo "$((i+1)). [URGENCY] \"⏰ ${t} — only 24 hours left\"" ;;
            benefit)     echo "$((i+1)). [BENEFIT] \"How ${t} saves you 10 hours/week\"" ;;
            question)    echo "$((i+1)). [QUESTION] \"Are you making this ${t} mistake?\"" ;;
            number)      echo "$((i+1)). [NUMBER] \"7 ${t} strategies that actually work in $(date '+%Y')\"" ;;
            personal)    echo "$((i+1)). [PERSONAL] \"{{first_name}}, your ${t} update is ready\"" ;;
            emoji)       echo "$((i+1)). [EMOJI] \"🚀 ${t} just got a major upgrade\"" ;;
            controversy) echo "$((i+1)). [BOLD] \"Stop doing ${t} the old way\"" ;;
            fomo)        echo "$((i+1)). [FOMO] \"Everyone's talking about ${t} — here's why\"" ;;
            story)       echo "$((i+1)). [STORY] \"How we went from 0 to 10K with ${t}\"" ;;
        esac
        i=$((i+1))
    done
    
    echo ""
    echo "## Subject Line Best Practices"
    echo "- Keep under 50 characters (mobile-friendly)"
    echo "- Front-load the important words"
    echo "- Avoid ALL CAPS and excessive !!! (spam triggers)"
    echo "- Test emoji vs no-emoji (varies by audience)"
    echo "- Personalization ({{first_name}}) increases opens 10-15%"
}

_segment() {
    cat << SEGM
# Subscriber Segmentation Strategy
**Product:** ${PRODUCT}
**Total Audience:** ${AUDIENCE}

## Recommended Segments

### 1. Engagement-Based
| Segment | Criteria | Size Est. | Strategy |
|---------|----------|-----------|----------|
| 🔥 Power Users | Opens >80%, clicks >20% | ~10% | Upsell, referral program |
| 👍 Active | Opens 40-80% | ~30% | Value content, feature education |
| 😐 Passive | Opens 10-40% | ~35% | Re-engagement, subject line test |
| 💤 Inactive | Opens <10% (90 days) | ~25% | Win-back sequence → sunset |

### 2. Behavior-Based
| Segment | Trigger | Email Type |
|---------|---------|------------|
| New Signup | Registration | Welcome series |
| Free Trial | Started trial | Onboarding drip |
| Abandoned | Started but didn't finish | Reminder + help |
| Purchased | Completed purchase | Thank you + cross-sell |
| Churned | Cancelled/expired | Win-back campaign |

### 3. Demographic
| Segment | Data Source | Use Case |
|---------|------------|----------|
| By Role | Signup form | Tailored content |
| By Company Size | Enrichment | Pricing tier |
| By Location | IP/form | Timezone sends |
| By Industry | Form/behavior | Case studies |

## Implementation Checklist
- [ ] Set up engagement scoring (opens × 1 + clicks × 3)
- [ ] Create automated segment rules
- [ ] Design segment-specific content paths
- [ ] Set up A/B tests per segment
- [ ] Review segments monthly
- [ ] Sunset truly inactive (no opens in 6 months)
SEGM
}

_template() {
    cat << TMPL
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${BRAND} Email</title>
</head>
<body style="margin:0;padding:0;background:#f4f4f4;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Arial,sans-serif;">

<!-- Preheader (hidden preview text) -->
<div style="display:none;max-height:0;overflow:hidden;">
[Preview text goes here — first 90 chars show in inbox]
</div>

<table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background:#f4f4f4;">
<tr><td align="center" style="padding:20px 0;">

<table role="presentation" width="600" cellspacing="0" cellpadding="0" style="background:#ffffff;border-radius:8px;overflow:hidden;">

<!-- HEADER -->
<tr><td style="background:linear-gradient(135deg,#667eea,#764ba2);padding:30px;text-align:center;">
<img src="{{logo_url}}" alt="${BRAND}" width="150" style="display:block;margin:0 auto 10px;">
<h1 style="color:#fff;margin:0;font-size:22px;">{{headline}}</h1>
</td></tr>

<!-- BODY -->
<tr><td style="padding:30px;">
<p style="color:#333;font-size:16px;line-height:1.6;">Hi {{first_name}},</p>
<p style="color:#555;font-size:15px;line-height:1.6;">{{body_text}}</p>

<!-- CTA BUTTON -->
<table role="presentation" width="100%" cellspacing="0" cellpadding="0">
<tr><td align="center" style="padding:25px 0;">
<a href="{{cta_url}}" style="display:inline-block;padding:14px 35px;background:#667eea;color:#fff;text-decoration:none;border-radius:6px;font-weight:bold;font-size:16px;">{{cta_text}}</a>
</td></tr>
</table>

</td></tr>

<!-- FOOTER -->
<tr><td style="padding:20px 30px;background:#f8f9fa;text-align:center;border-top:1px solid #eee;">
<p style="margin:0 0 8px;font-size:12px;color:#999;">${BRAND} · {{company_address}}</p>
<p style="margin:0;font-size:12px;">
<a href="{{unsubscribe}}" style="color:#667eea;text-decoration:none;">Unsubscribe</a> · 
<a href="{{preferences}}" style="color:#667eea;text-decoration:none;">Preferences</a> · 
<a href="{{browser_view}}" style="color:#667eea;text-decoration:none;">View in browser</a>
</p>
</td></tr>

</table>
</td></tr>
</table>
</body>
</html>
TMPL
}

_welcome() {
    local nsteps="${STEPS:-3}"
    TYPE="onboarding"
    STEPS="$nsteps"
    _sequence
}

_winback() {
    local nsteps="${STEPS:-3}"
    TYPE="winback"
    STEPS="$nsteps"
    _sequence
}

_analyze() {
    cat << ANAL
# Campaign Analysis Framework

## Input Your Metrics
Fill in your actual numbers:

| Metric | Your Value | Industry Avg | Status |
|--------|-----------|--------------|--------|
| List Size | _____ | - | - |
| Open Rate | ___% | 21.5% | $(echo "⚠️ Compare") |
| Click Rate | ___% | 2.3% | $(echo "⚠️ Compare") |
| Click-to-Open | ___% | 10.5% | $(echo "⚠️ Compare") |
| Bounce Rate | ___% | 0.7% | $(echo "⚠️ Compare") |
| Unsubscribe | ___% | 0.1% | $(echo "⚠️ Compare") |
| Revenue/Email | \$___ | \$0.08 | $(echo "⚠️ Compare") |

## Diagnosis Guide

### Low Open Rate (<15%)
- ❌ Subject lines too generic
- ❌ Sending at wrong time
- ❌ List is stale (clean inactive)
- ✅ Fix: A/B test subjects, segment by timezone, prune list

### Low Click Rate (<1%)
- ❌ CTA not compelling
- ❌ Content doesn't match subject promise
- ❌ Too many links (paradox of choice)
- ✅ Fix: Single clear CTA, match subject to content, mobile-optimize buttons

### High Unsubscribe (>0.5%)
- ❌ Sending too frequently
- ❌ Content not relevant to segment
- ❌ Hard to find preference center
- ✅ Fix: Reduce frequency, better segmentation, add preference options

### High Bounce (>2%)
- ❌ List hygiene issues
- ❌ Purchased/scraped emails
- ✅ Fix: Double opt-in, regular list cleaning, verify before import

## Quick Wins
1. **Send Time Optimization**: Test Tu/Th 10am vs your current
2. **Subject Line Formula**: [Number] + [Benefit] + [Timeframe]
3. **Preview Text**: Write custom (don't let it default to "View in browser")
4. **Mobile**: 60%+ opens are mobile — test on phone first
5. **Segmentation**: Even 2 segments outperform 1 blast
ANAL
}

_calendar() {
    local month=$(date '+%B %Y')
    cat << CAL
# Email Marketing Calendar — ${month}
**Brand:** ${BRAND}

| Week | Day | Type | Topic | Segment | Status |
|------|-----|------|-------|---------|--------|
| 1 | Mon | Newsletter | Monthly roundup | All | ⬜ |
| 1 | Thu | Promo | Feature spotlight | Active | ⬜ |
| 2 | Tue | Educational | How-to guide | New users | ⬜ |
| 2 | Fri | Social proof | Case study | Prospects | ⬜ |
| 3 | Mon | Newsletter | Industry news | All | ⬜ |
| 3 | Wed | Re-engage | Win-back offer | Inactive | ⬜ |
| 4 | Tue | Promo | End-of-month deal | All | ⬜ |
| 4 | Thu | Educational | Tips & tricks | Active | ⬜ |

## Sending Rules
- **Max frequency**: 2-3 emails/week per subscriber
- **Best days**: Tuesday, Thursday (test Wednesday)
- **Best times**: 10am, 2pm local time
- **Avoid**: Monday morning, Friday evening, weekends
- **Always**: Preview text, mobile test, link check

## Content Mix (monthly)
- 40% Educational (how-to, tips, guides)
- 25% Promotional (features, offers, launches)
- 20% Social proof (case studies, testimonials)
- 15% Engagement (surveys, polls, UGC)
CAL
}

case "$CMD" in
    campaign)   _campaign ;;
    newsletter) _newsletter ;;
    sequence)   _sequence ;;
    subject)    _subject ;;
    segment)    _segment ;;
    template)   _template ;;
    welcome)    _welcome ;;
    winback)    _winback ;;
    analyze)    _analyze ;;
    calendar)   _calendar ;;
    help|*)
        echo "Email Marketer — Complete email marketing toolkit"
        echo ""
        echo "Commands:"
        echo "  campaign    Create full email campaign (announcement/launch/promo)"
        echo "  newsletter  Generate formatted newsletter (html/markdown)"
        echo "  sequence    Build multi-step drip sequence (onboarding/nurture/winback)"
        echo "  subject     Generate A/B test subject lines"
        echo "  segment     Create subscriber segmentation strategy"
        echo "  template    Generate responsive HTML email template"
        echo "  welcome     Welcome email series for new subscribers"
        echo "  winback     Win-back campaign for inactive users"
        echo "  analyze     Campaign performance analysis framework"
        echo "  calendar    Monthly email marketing calendar"
        echo ""
        echo "Options:"
        echo "  --type TYPE        Campaign/sequence type"
        echo "  --product NAME     Product name"
        echo "  --audience DESC    Target audience"
        echo "  --topic TOPIC      Subject line topic"
        echo "  --topics LIST      Comma-separated newsletter sections"
        echo "  --count N          Number of subject lines (default: 5)"
        echo "  --steps N          Number of sequence emails (default: 5)"
        echo "  --format FMT       Output format: html|markdown (default: markdown)"
        echo "  --brand NAME       Brand name (default: YourBrand)"
        echo "  --style STYLE      Writing style: professional|casual|urgent"
        echo ""
        echo "Examples:"
        echo "  email_marketer.sh campaign --type launch --product 'AI Tool'"
        echo "  email_marketer.sh subject --topic 'Black Friday' --count 10"
        echo "  email_marketer.sh newsletter --topics 'News,Tips,Updates' --format html"
        echo "  email_marketer.sh sequence --type onboarding --steps 7"
        ;;
esac
