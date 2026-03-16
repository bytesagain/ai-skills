---
name: APITest
description: "API testing and HTTP request tool. Send GET, POST, PUT, DELETE requests from the terminal, inspect response headers and body, save request history, set custom headers and authentication, and test API endpoints quickly. Lightweight Postman alternative for your terminal."
version: "2.0.0"
author: "BytesAgain"
tags: ["api","http","testing","rest","request","curl","postman","developer"]
categories: ["Developer Tools", "Utility"]
---
# APITest
Test APIs from your terminal. Send requests. Inspect responses. No GUI needed.
## Commands
- `get <url>` — Send GET request
- `post <url> <data>` — Send POST request with JSON data
- `put <url> <data>` — Send PUT request
- `delete <url>` — Send DELETE request
- `headers <url>` — Show response headers only
- `status <url>` — Quick status code check
## Usage Examples
```bash
apitest get [configured-endpoint]
apitest post [configured-endpoint] '{"key":"value"}'
apitest headers https://example.com
apitest status [configured-endpoint]
```
---
Powered by BytesAgain | bytesagain.com

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
