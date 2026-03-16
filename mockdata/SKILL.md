---
name: MockData
description: "Fake data generator for testing and development. Generate realistic mock data including names, emails, addresses, phone numbers, companies, dates, lorem ipsum text, and structured JSON records. Create test datasets without external APIs or dependencies."
version: "2.0.0"
author: "BytesAgain"
tags: ["mock","fake","data","generator","testing","development","faker","sample"]
categories: ["Developer Tools", "Utility"]
---
# MockData
Generate realistic fake data for testing. Names, emails, addresses, and more.
## Commands
- `name [n]` — Generate random names
- `email [n]` — Generate random emails
- `phone [n]` — Generate phone numbers
- `address [n]` — Generate addresses
- `user [n]` — Generate complete user records (JSON)
- `lorem [sentences]` — Lorem ipsum text
- `number <min> <max> [n]` — Random numbers
- `csv <fields> <rows>` — Generate CSV test data
## Usage Examples
```bash
mockdata name 10
mockdata email 5
mockdata user 3
mockdata csv "name,email,age" 20
mockdata lorem 5
```
---
Powered by BytesAgain | bytesagain.com

- Run `mockdata help` for all commands

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
