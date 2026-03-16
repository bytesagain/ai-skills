# Tips — Stripe Manager

> Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

## Quick Start

1. Go to https://dashboard.stripe.com/apikeys
2. Copy your Secret Key (starts with `sk_test_` for test mode or `sk_live_` for live)
3. Set `STRIPE_API_KEY=sk_test_xxx` and start using commands
4. **Always test with `sk_test_` keys first!**

## Test vs Live Mode

- `sk_test_` keys only affect test data — safe to experiment
- `sk_live_` keys affect real payments — use with caution
- Use test card numbers: `4242424242424242` (success), `4000000000000002` (decline)
- Test mode data is separate from live mode

## Amount Format

- Amounts are in the **smallest currency unit** (cents for USD/EUR)
- $29.99 = `2999`
- €10.00 = `1000`
- ¥500 = `500` (JPY has no decimals)

## Customer Search

Search uses Stripe's search syntax:
- `email:'alice@example.com'`
- `name:'Alice Smith'`
- `metadata['company']:'Acme'`

## Subscription Intervals

When creating prices with recurring billing:
- `day` — Daily billing
- `week` — Weekly billing
- `month` — Monthly billing
- `year` — Annual billing

## Webhook Events

Common event types to filter:
- `charge.succeeded` — Payment completed
- `charge.failed` — Payment failed
- `customer.subscription.created` — New subscription
- `customer.subscription.deleted` — Subscription canceled
- `invoice.payment_failed` — Invoice payment failed

## Troubleshooting

- **401 Invalid API Key**: Check your key is correct and not expired
- **402 Card Declined**: In test mode, use appropriate test card numbers
- **404 Resource Not Found**: Check the ID format (should start with `cus_`, `ch_`, `sub_`, etc.)
- **429 Rate Limited**: Stripe allows 100 read + 100 write requests per second in live mode

## Pro Tips

- Use `summary` for quick financial overviews
- Create payment links for one-off payments without code
- Use partial refunds when only part of an order needs refunding
- Monitor `events` for real-time payment activity
- Use test mode keys for development and staging environments
