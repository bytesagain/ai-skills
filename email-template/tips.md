# Email Template — Prompt Tips

## When User Asks for Email Templates

1. Identify which type: welcome / newsletter / transactional / cold / followup / collection
2. Run: `bash scripts/emailtpl.sh <type> [industry] [tone]`
3. Present the generated template to the user
4. Offer customization: subject line variants, CTA options, tone adjustment

## Key Principles

- **Subject lines matter** — provide 3-5 variants with open-rate optimization tips
- **Mobile-first** — all HTML templates should be responsive
- **CAN-SPAM / GDPR** — remind about unsubscribe links and compliance
- **Personalization** — use {{name}}, {{company}} placeholders
- **Tone matching** — formal for B2B, friendly for B2C, urgent for collection

## Customization Flow

1. Ask: industry / audience / goal
2. Generate base template
3. Suggest A/B test variants for subject line
4. Add compliance footer
