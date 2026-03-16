---
version: "2.0.0"
name: email-marketer
description: "Email marketing campaign builder with newsletter templates, drip sequences, A/B subject lines, subscriber segmentation, and analytics tracking. Use when you need to create email campaigns, write marketing newsletters, design drip sequences, generate subject lines, segment subscriber lists, plan email automation, or analyze campaign performance. Triggers on: email marketing, newsletter, drip campaign, email sequence, subject line, subscriber, mailchimp, sendinblue, email automation, campaign, open rate, click rate, unsubscribe."
---

# Email Marketer

Complete email marketing toolkit — from campaign planning to performance analysis.

## Commands

| Command | Description |
|---------|-------------|
| `campaign` | Create a full email campaign (subject + body + CTA) |
| `newsletter` | Generate formatted newsletter from topics/updates |
| `sequence` | Build multi-step drip/nurture email sequence |
| `subject` | Generate A/B test subject lines |
| `segment` | Create subscriber segmentation strategy |
| `template` | Generate HTML email template |
| `welcome` | Create welcome email series for new subscribers |
| `winback` | Win-back campaign for inactive subscribers |
| `analyze` | Analyze campaign metrics and suggest improvements |
| `calendar` | Plan monthly email marketing calendar |
| `help` | Show this help |

## Examples

```bash
# Create a product launch campaign
bash scripts/email_marketer.sh campaign --type launch --product "AI Writing Tool" --audience developers

# Generate 10 A/B subject lines
bash scripts/email_marketer.sh subject --topic "Black Friday Sale" --count 10 --style urgency

# Build a 7-day onboarding drip sequence
bash scripts/email_marketer.sh sequence --type onboarding --steps 7 --product SaaS

# Create HTML newsletter
bash scripts/email_marketer.sh newsletter --topics "New features, Case study, Tips" --format html

# Welcome email series
bash scripts/email_marketer.sh welcome --brand "BytesAgain" --steps 3
```

## Output Formats

- **HTML** — Ready-to-send email templates with responsive design
- **Markdown** — For preview and editing
- **Plain text** — For text-only email clients
- **CSV** — Segmentation and calendar exports

---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
