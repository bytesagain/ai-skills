---
name: WeatherNow
description: "Current weather and forecast checker. Get current conditions, temperature, humidity, wind speed, and multi-day forecasts for any location. Uses free wttr.in service. Supports city names, coordinates, and airport codes. No API key needed."
version: "2.0.0"
author: "BytesAgain"
tags: ["weather","forecast","temperature","climate","wttr","location","utility"]
categories: ["Utility", "Productivity"]
---
# WeatherNow
Check the weather instantly. Current conditions and forecasts for any city.
## Commands
- `now [city]` — Current weather
- `forecast [city]` — 3-day forecast
- `short [city]` — One-line weather summary
- `moon` — Current moon phase
## Usage Examples
```bash
weathernow now "New York"
weathernow forecast London
weathernow short Tokyo
weathernow moon
```
---
Powered by BytesAgain | bytesagain.com

## When to Use

- for batch processing weathernow operations
- as part of a larger automation pipeline

## Output

Returns results to stdout. Redirect to a file with `weathernow run > output.txt`.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
