#!/usr/bin/env bash
# stripe-manager — Stripe Payment Platform Reference
set -euo pipefail
VERSION="5.0.0"

cmd_intro() { cat << 'EOF'
# Stripe Payment Platform — Overview

## Architecture
Stripe processes payments through a series of API objects:
  PaymentIntent  — Represents a payment lifecycle (create → confirm → capture)
  SetupIntent    — Saves payment method for future use without charging
  Customer       — Stores customer data, payment methods, subscriptions
  Product/Price  — Catalog items with recurring or one-time pricing
  Subscription   — Recurring billing with trials, proration, metered usage
  Invoice        — Billing document, auto-generated for subscriptions

## Payment Flow
  1. Create PaymentIntent with amount + currency
  2. Client confirms with payment method (card, bank, wallet)
  3. 3D Secure challenge if required (SCA)
  4. Payment succeeds → funds in Stripe balance
  5. Payout to bank account (T+2 standard, T+1 with Instant)

## Supported Payment Methods
  Cards:    Visa, Mastercard, Amex, Discover, JCB, UnionPay, Diners
  Wallets:  Apple Pay, Google Pay, Link, Cash App Pay
  Bank:     ACH Direct Debit, SEPA, iDEAL, Bancontact, BECS
  BNPL:     Afterpay/Clearpay, Klarna, Affirm
  Crypto:   Not natively supported (use third-party)
  Local:    Alipay, WeChat Pay, Boleto, OXXO, Konbini

## Key Concepts
  Idempotency Keys: Prevent duplicate charges on retries
  Stripe.js/Elements: PCI-compliant client-side card collection
  Connect: Multi-party payments (marketplace, platform)
  Radar: Machine learning fraud detection
  Billing Portal: Customer self-service for subscriptions
EOF
}

cmd_standards() { cat << 'EOF'
# Stripe Compliance & Standards

## PCI DSS Compliance Levels
  Level 1: >6M transactions/year — annual audit by QSA
  Level 2: 1-6M transactions — annual SAQ
  Level 3: 20K-1M e-commerce — annual SAQ
  Level 4: <20K e-commerce — annual SAQ
  Stripe.js/Elements: Keeps you at SAQ-A (simplest level)
  Never log or store raw card numbers on your server

## Strong Customer Authentication (SCA)
  Required by PSD2 in European Economic Area since Sep 2019
  3D Secure 2 (3DS2): Improved UX vs 3DS1 (fewer pop-ups)
  Two of three factors: knowledge (password), possession (phone), inherence (biometric)
  Exemptions: <€30 transactions, recurring payments, trusted beneficiaries
  Stripe handles 3DS2 automatically via PaymentIntents API

## Idempotency
  Add Idempotency-Key header to POST requests
  Stripe caches response for 24 hours
  Same key + same parameters = same response (no duplicate charge)
  Generate UUID v4 for each unique business operation
  Critical for retry logic in unreliable networks

## Webhook Best Practices
  Verify signature using stripe-signature header
  Tolerance window: 300 seconds (5 minutes)
  Respond with 2xx within 10 seconds
  Process asynchronously (queue the event, respond immediately)
  Handle out-of-order events (check object state, not event order)
  Stripe retries: 3 days, exponential backoff, up to 5 attempts
EOF
}

cmd_troubleshooting() { cat << 'EOF'
# Stripe Troubleshooting Guide

## Card Declined Codes
  card_declined              Generic decline (ask customer to contact bank)
  insufficient_funds         Not enough balance
  expired_card               Card past expiration date
  incorrect_cvc              Wrong CVC/CVV code
  processing_error           Temporary bank processing issue (retry)
  do_not_honor               Bank refuses without specific reason
  fraudulent                 Bank suspects fraud
  lost_card / stolen_card    Card reported lost/stolen
  Fix: Show specific user-friendly messages per decline code

## Webhook Signature Verification Failure
  Error: "No signatures found matching the expected signature"
  Causes:
    - Using wrong webhook signing secret (each endpoint has its own)
    - Clock skew >5 minutes between your server and Stripe
    - Request body modified by middleware (parsing before verification)
  Fix: Use raw body for verification, not parsed JSON
    app.post('/webhook', express.raw({type:'application/json'}), handler)

## Payout Delays
  New accounts: 7-14 day initial payout delay
  Standard: T+2 business days (US), T+3 (EU)
  "Payout failed": Invalid bank account, closed account
  "Funds on hold": Stripe risk review triggered
  Check: Dashboard → Balances → Payout schedule

## Subscription Issues
  past_due:   Payment failed, retry schedule active (4 attempts over 1 month)
  incomplete: First payment never succeeded
  canceled:   All retries exhausted or manually canceled
  Fix past_due: Update payment method, then retry invoice
    stripe invoices pay inv_xxx

## Connect Account Issues
  "Account not fully onboarded": Missing identity verification
  "Payout not allowed": Missing bank account or TOS acceptance
  Fix: Generate new Account Link for onboarding completion
EOF
}

cmd_performance() { cat << 'EOF'
# Stripe Performance Optimization

## Rate Limits
  Read operations:  100 requests/second per secret key
  Write operations: 100 requests/second per secret key
  Error response: HTTP 429 with Retry-After header
  Best practice: Implement exponential backoff with jitter

## Batch Operations
  Don't: Loop through 1000 customers making individual API calls
  Do: Use auto-pagination (stripe.customers.list auto_paging=True)
  Do: Use Search API for complex queries (created>X AND email:"@gmail")
  Do: Use bulk operations where available (bulk meter event creation)

## Webhook Optimization
  Use webhook event types selectively (don't listen to all events)
  Critical events: payment_intent.succeeded, invoice.paid, charge.disputed
  Process async: Receive → queue (Redis/SQS) → process → acknowledge
  Idempotent processing: Store processed event IDs, skip duplicates

## Client-Side Performance
  Load Stripe.js async: <script src="https://js.stripe.com/v3/" async>
  Lazy-load Elements: Only initialize when payment form is visible
  Use Payment Element (single component) instead of individual Card Element
  Preload: stripe.elements() during page load, mount on form display

## Reducing API Calls
  Expand related objects: stripe.charges.retrieve(id, expand=['customer'])
  Cache customer/product data locally (refresh daily)
  Use Events instead of polling for status changes
  Metadata: Store your IDs in Stripe metadata to avoid lookups
EOF
}

cmd_security() { cat << 'EOF'
# Stripe Security Guide

## API Key Management
  Secret keys: sk_test_xxx / sk_live_xxx (server-side only, never expose)
  Publishable keys: pk_test_xxx / pk_live_xxx (client-side, safe to expose)
  Restricted keys: Create keys with specific permissions per service
  Rotation: Generate new key → update all services → revoke old key
  Never commit keys to git (use environment variables)

## Webhook Endpoint Security
  Always verify webhook signatures:
    stripe.webhooks.constructEvent(body, sig, endpointSecret)
  Use HTTPS endpoints only (Stripe rejects HTTP in live mode)
  IP allowlist: Stripe webhook IPs at stripe.com/docs/ips
  Reject events older than tolerance window (300 seconds default)

## Radar Fraud Prevention
  Built-in rules: Block if CVC fails, block if postal code fails
  Custom rules: Block if :risk_score: > 75
  Review rules: Review if amount > 500 AND country != US
  Allow/Block lists: Whitelist known customers, block known fraudsters
  3DS: Request 3D Secure for high-risk transactions
  Machine learning: Trained on billions of Stripe transactions

## PCI Compliance
  Use Stripe.js/Elements to tokenize cards client-side
  Never log request bodies containing card data
  Use PaymentIntents API (not legacy Tokens + Charges)
  Regular security audits of server infrastructure
  Enable two-factor authentication on Stripe Dashboard

## Connect Security
  Verify webhook signature per connected account
  Use account-scoped API keys for connected account operations
  OAuth: Validate redirect URIs, use state parameter for CSRF
  Don't store connected account secret keys
EOF
}

cmd_migration() { cat << 'EOF'
# Stripe Migration Guide

## Legacy Charges API → PaymentIntents
  Old flow: Create Token → Create Charge
  New flow: Create PaymentIntent → Confirm with payment method
  Why migrate: SCA compliance, better error handling, more payment methods
  Steps:
    1. Replace stripe.charges.create with stripe.paymentIntents.create
    2. Handle requires_action status (3DS challenges)
    3. Update webhook handlers: charge.succeeded → payment_intent.succeeded
    4. Update client: Use confirmPayment instead of createToken
    5. Test in test mode with 3DS test cards (4000002760003184)

## Test → Live Mode Checklist
  [ ] Replace all test API keys with live keys
  [ ] Update webhook endpoints to live signing secrets
  [ ] Verify webhook URL is HTTPS
  [ ] Test with real card (small amount, then refund)
  [ ] Enable Radar rules for fraud prevention
  [ ] Configure payout schedule and bank account
  [ ] Set up email receipts and invoice templates
  [ ] Review Dashboard users and permissions
  [ ] Enable two-factor auth for all team members
  [ ] Set up PagerDuty/Slack alerts for failed payments

## Single Integration → Connect Platform
  Choose model: Standard (Stripe hosts onboarding) vs Custom (you build UI)
  Create connected accounts: stripe.accounts.create
  Implement onboarding: Account Links for identity verification
  Update charges: Add transfer_data or on_behalf_of
  Handle payouts: Per-account payout schedules
  Split payments: application_fee_amount for platform revenue
EOF
}

cmd_cheatsheet() { cat << 'EOF'
# Stripe Quick Reference

## Stripe CLI Commands
  stripe login                              # Authenticate
  stripe listen --forward-to localhost:4242 # Forward webhooks locally
  stripe trigger payment_intent.succeeded   # Test webhook events
  stripe logs tail                          # Stream API logs
  stripe customers list --limit 5           # List resources
  stripe payment_intents create --amount 2000 --currency usd  # Create PI

## Common API Endpoints
  POST /v1/payment_intents          Create payment
  POST /v1/setup_intents            Save card for later
  POST /v1/customers                Create customer
  GET  /v1/charges/{id}             Retrieve charge
  POST /v1/refunds                  Refund payment
  POST /v1/subscriptions            Create subscription
  GET  /v1/balance                  Check balance
  POST /v1/webhook_endpoints        Register webhook

## Key Webhook Events
  payment_intent.succeeded          Payment completed
  payment_intent.payment_failed     Payment failed
  invoice.paid                      Subscription invoice paid
  invoice.payment_failed            Subscription payment failed
  customer.subscription.deleted     Subscription canceled
  charge.dispute.created            Chargeback filed
  account.updated                   Connect account changed

## Test Card Numbers
  4242424242424242    Visa (success)
  4000000000009995    Insufficient funds (decline)
  4000002760003184    Requires 3D Secure
  4000000000000341    Attaching succeeds, charge fails
  4000003720000278    Always requires auth (India)

## Error Code Categories
  card_error:          Customer card issue
  api_error:           Stripe server issue (retry)
  authentication_error: Invalid API key
  rate_limit_error:    Too many requests (back off)
  invalid_request:     Missing/invalid parameters
EOF
}

cmd_faq() { cat << 'EOF'
# Stripe — Frequently Asked Questions

Q: What are Stripe's fees?
A: Standard: 2.9% + $0.30 per successful card charge (US).
   International cards: +1.5%. Currency conversion: +1%.
   ACH Direct Debit: 0.8% (capped at $5).
   Instant payouts: 1% of payout amount (min $0.50).
   Stripe Tax, Billing, Connect, Radar have additional fees.
   Volume discounts available for >$80k/month.

Q: How long do payouts take?
A: Standard US: 2 business days (T+2).
   Standard EU: 3 business days.
   Instant payouts: Minutes (for additional 1% fee).
   New accounts: 7-14 day initial delay while risk is assessed.
   Weekends/holidays: Payouts process next business day.

Q: How do I handle disputes/chargebacks?
A: Notification via charge.dispute.created webhook.
   Respond within 7-21 days with evidence (receipt, tracking, logs).
   Upload via Dashboard or API: stripe.disputes.update(id, evidence).
   Dispute fee: $15 (refunded if you win).
   Prevention: Use Radar, collect billing address, send receipts.

Q: Can I use Stripe internationally?
A: Stripe is available in 47+ countries.
   Each country requires a separate Stripe account with local entity.
   Cross-border charges: Standard fee + 1.5% international card fee.
   Multi-currency: Create charges in 135+ currencies.
   Payouts: Received in your local currency.

Q: How do I test my integration?
A: Use test mode API keys (sk_test_xxx).
   Test card numbers: 4242... (success), 4000... (various scenarios).
   Stripe CLI: stripe listen + stripe trigger for webhook testing.
   Clock simulations: Test subscriptions with test clocks.
   Go live: Switch to live keys, test with real card ($0.50 charge).
EOF
}

cmd_help() {
    echo "stripe-manager v$VERSION — Stripe Payment Platform Reference"
    echo ""
    echo "Usage: stripe-manager <command>"
    echo ""
    echo "Commands:"
    echo "  intro           Stripe architecture and payment flow"
    echo "  standards       PCI DSS, SCA/3DS2, compliance"
    echo "  troubleshooting Card declines, webhooks, payout issues"
    echo "  performance     Rate limits, batching, optimization"
    echo "  security        API keys, Radar, PCI compliance"
    echo "  migration       Charges→PaymentIntents, test→live"
    echo "  cheatsheet      CLI commands, endpoints, test cards"
    echo "  faq             Pricing, payouts, disputes"
    echo "  help            Show this help"
}

case "${1:-help}" in
    intro) cmd_intro ;; standards) cmd_standards ;;
    troubleshooting) cmd_troubleshooting ;; performance) cmd_performance ;;
    security) cmd_security ;; migration) cmd_migration ;;
    cheatsheet) cmd_cheatsheet ;; faq) cmd_faq ;;
    help|--help|-h) cmd_help ;;
    *) echo "Unknown: $1"; echo "Run: stripe-manager help" ;;
esac
