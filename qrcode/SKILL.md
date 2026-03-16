---
name: QRCode
description: "QR code generator for terminal. Create QR codes from text, URLs, WiFi credentials, and contact info. Display QR codes as ASCII art in the terminal, encode any data as a scannable QR code. No external dependencies or GUI required."
version: "2.0.0"
author: "BytesAgain"
tags: ["qrcode","qr","generator","barcode","encode","terminal","ascii","utility"]
categories: ["Utility", "Developer Tools"]
---
# QRCode
Generate QR codes right in your terminal. Text, URLs, WiFi — anything.
## Commands
- `text <string>` — Generate QR for text/URL
- `wifi <ssid> <password> [encryption]` — WiFi QR code
- `contact <name> <phone> [email]` — Contact vCard QR
- `file <path>` — Read text from file and encode
## Usage Examples
```bash
qrcode text "https://bytesagain.com"
qrcode wifi "MyNetwork" "password123" WPA
qrcode contact "John" "+1234567890" "john@example.com"
```
---
Powered by BytesAgain | bytesagain.com

## When to Use

- for batch processing qrcode operations
- as part of a larger automation pipeline

## Output

Returns logs to stdout. Redirect to a file with `qrcode run > output.txt`.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
