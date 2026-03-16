---
name: Webhook Tester
description: "Webhook testing and debugging tool. Send test webhook payloads to any URL, simulate various webhook events (GitHub, Stripe, Slack), inspect responses, and log webhook delivery attempts. Debug webhook integrations without deploying code."
version: "2.0.0"
author: "BytesAgain"
tags: ["webhook","testing","http","api","integration","debug","developer","automation"]
categories: ["Developer Tools", "Utility"]
---
# Webhook Tester
Test webhooks. Send payloads. Debug integrations. No deployment needed.
## Commands
- `send <url> <json_payload>` — Send webhook POST
- `github <url> [event]` — Simulate GitHub webhook
- `ping <url>` — Send test ping
- `history` — View recent webhook sends
## Usage Examples
```bash
webhook-tester send https://myapp.com/webhook '{"event":"test"}'
webhook-tester github https://myapp.com/hooks push
webhook-tester ping https://myapp.com/health
```
---
Powered by BytesAgain | bytesagain.com

## When to Use

- as part of a larger automation pipeline
- when you need quick webhook tester from the command line

## Output

Returns logs to stdout. Redirect to a file with `webhook-tester run > output.txt`.

## Configuration

Set `WEBHOOK_TESTER_DIR` environment variable to change the data directory. Default: `~/.local/share/webhook-tester/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
