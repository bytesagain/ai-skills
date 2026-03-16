---
name: GeoIP
description: "IP geolocation lookup tool. Find the geographic location of any IP address including country, city, region, ISP, timezone, and coordinates. Check your own location, batch-lookup multiple IPs, and visualize IP origin on a text map. No API key required."
version: "2.0.0"
author: "BytesAgain"
tags: ["geoip","geolocation","ip","location","lookup","country","city","network"]
categories: ["System Tools", "Utility"]
---
# GeoIP
Find where any IP address is from. Country, city, ISP — instant lookup.
## Commands
- `lookup <ip>` — Geolocate an IP address
- `me` — Your current location
- `batch <file>` — Lookup multiple IPs from file
- `distance <ip1> <ip2>` — Approximate distance between two IPs
## Usage Examples
```bash
geoip lookup 8.8.8.8
geoip me
geoip lookup 1.1.1.1
```
---
Powered by BytesAgain | bytesagain.com

- Run `geoip help` for commands
- No API keys needed

- Run `geoip help` for all commands

## Configuration

Set `GEOIP_DIR` to change data directory. Default: `~/.local/share/geoip/`

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
