---
name: CurrConv
description: "Convert currencies using frankfurter.app free API. Use when converting amounts, checking exchange rates, or viewing rate history. Requires curl."
version: "3.0.1"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["currency","converter","exchange","rate","money","finance","forex","international"]
categories: ["Finance", "Utility"]
---

# CurrConv

A real currency converter using live exchange rates from the European Central Bank via the free [frankfurter.app](https://frankfurter.app) API. Convert currencies, check rates, list available currencies, and look up historical exchange rates. No API key required.

## Commands

| Command | Description |
|---------|-------------|
| `currconv convert <amount> <from> <to>` | Convert an amount from one currency to another using live rates |
| `currconv rates <base>` | Show all exchange rates for a base currency (default: EUR) |
| `currconv list` | List all available currencies with full names |
| `currconv history <from> <to> <date>` | Get a historical exchange rate with comparison to today |
| `currconv version` | Show version |
| `currconv help` | Show available commands and usage |

## Requirements

- Bash 4+ (`set -euo pipefail`)
- `curl` — for API requests
- `python3` — for JSON parsing and number formatting
- Internet connection (calls frankfurter.app API)
- No API key required (free, public API)

## When to Use

1. **Quick currency conversion** — `currconv convert 100 USD EUR` for instant conversion
2. **Checking exchange rates** — `currconv rates USD` shows all rates against the dollar
3. **Available currencies** — `currconv list` shows all 30+ supported currencies
4. **Historical rates** — `currconv history USD EUR 2024-01-15` with comparison to today's rate
5. **Travel planning** — Convert amounts between currencies before a trip

## Examples

```bash
# Convert 100 USD to EUR
currconv convert 100 USD EUR

# Convert 5000 JPY to GBP
currconv convert 5000 JPY GBP

# Convert 1000 CNY to USD
currconv convert 1000 CNY USD

# Show all rates for USD
currconv rates USD

# Show all rates for EUR (default)
currconv rates

# List all available currencies
currconv list

# Get historical rate for a specific date
currconv history USD EUR 2024-01-15

# Historical GBP to JPY rate
currconv history GBP JPY 2023-06-01
```

### Example Output

```
$ currconv convert 100 USD CNY
┌───────────────────────────────────────────────────┐
│  Currency Conversion                              │
├───────────────────────────────────────────────────┤
│  100.00         USD                                │
│  =                                                 │
│  688.82         CNY                                │
├───────────────────────────────────────────────────┤
│  Rate:  1 USD  = 6.888200   CNY                    │
│  Date:  2026-03-18                                 │
│  Source: European Central Bank                     │
└───────────────────────────────────────────────────┘

$ currconv history USD EUR 2024-01-15
┌───────────────────────────────────────────────────┐
│  Historical Exchange Rate                         │
├───────────────────────────────────────────────────┤
│  Pair:       USD → EUR                             │
│  Date:       2024-01-15                            │
│  Rate:       1 USD  = 0.91234 EUR                  │
├───────────────────────────────────────────────────┤
│  Today:      1 USD  = 0.92150 EUR                  │
│  Change:     +0.009160 (+1.00%)                    │
│  Today date: 2026-03-18                            │
├───────────────────────────────────────────────────┤
│  Source: European Central Bank                     │
└───────────────────────────────────────────────────┘
```

## Supported Currencies

Run `currconv list` for the full list. Common currencies include:

- **USD** — US Dollar
- **EUR** — Euro
- **GBP** — British Pound
- **JPY** — Japanese Yen
- **CNY** — Chinese Yuan
- **AUD** — Australian Dollar
- **CAD** — Canadian Dollar
- **CHF** — Swiss Franc
- **KRW** — South Korean Won
- **SGD** — Singapore Dollar

30+ currencies supported in total, all sourced from the European Central Bank.

## Data Source

All exchange rates come from the [European Central Bank](https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/) via the free [frankfurter.app](https://frankfurter.app) API. Rates are typically updated once per business day. No API key or registration required.

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*

## Data Storage

Rate cache stored in `~/.local/share/currconv/`.
