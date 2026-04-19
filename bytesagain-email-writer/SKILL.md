---
description: "Generate professional email templates for outreach, follow-ups, and apologies. Use when writing cold emails, drafting follow-up messages, creating apology emails, or generating subject line variants."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---
# bytesagain-email-writer

Professional email templates for cold outreach, follow-ups, apologies, introductions, and polite declines. Includes subject line generators with estimated open rates and platform-specific timing tips.

## Usage

```
bytesagain-email-writer cold <name> <company> <goal>
bytesagain-email-writer followup <context> <days_since>
bytesagain-email-writer apology <issue> <audience>
bytesagain-email-writer intro <your_name> <their_name>
bytesagain-email-writer decline <request>
bytesagain-email-writer subject <topic> <goal>
```

## Commands

- `cold` — Cold outreach email with personalization tips and send-time guidance
- `followup` — Follow-up email with multiple variants and cadence recommendations
- `apology` — Apology email with accountability structure and remedy framework
- `intro` — Self-introduction or mutual introduction email templates
- `decline` — Polite decline with optional alternative and delay variants
- `subject` — Generate 5 subject line variants by goal (open/convert/engage)

## Examples

```bash
bytesagain-email-writer cold "Sarah Chen" "Acme Corp" "partnership"
bytesagain-email-writer followup "our product demo" 3
bytesagain-email-writer apology "service outage" "customers"
bytesagain-email-writer intro "Alice" "Bob"
bytesagain-email-writer decline "speaking at conference"
bytesagain-email-writer subject "AI tools" convert
```

## Requirements

- bash
- python3

## When to Use

Use when writing professional emails, need templates for common scenarios, want subject line inspiration, or need structured guidance on email etiquette and timing.
