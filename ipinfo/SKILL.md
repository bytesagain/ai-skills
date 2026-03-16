---
name: IPInfo
description: "IP address information and geolocation tool. Look up your public IP, get geolocation data for any IP address, check local network interfaces, and convert between IP formats. Quick IP intelligence without leaving the terminal."
version: "2.0.0"
author: "BytesAgain"
tags: ["ip","network","geolocation","address","lookup","whois","dns","internet"]
categories: ["System Tools", "Developer Tools", "Utility"]
---
# IPInfo
Know your IP. Look up any IP. Quick IP intelligence.
## Commands
- `me` — Show your public IP
- `lookup <ip>` — Get IP geolocation info
- `local` — Show local network interfaces
- `whois <ip>` — Basic WHOIS info
## Usage Examples
```bash
ipinfo me
ipinfo lookup 8.8.8.8
ipinfo local
```
---
Powered by BytesAgain | bytesagain.com

## When to Use

- as part of a larger automation pipeline
- when you need quick ipinfo from the command line

## Output

Returns structured data to stdout. Redirect to a file with `ipinfo run > output.txt`.

## Configuration

Set `IPINFO_DIR` environment variable to change the data directory. Default: `~/.local/share/ipinfo/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
