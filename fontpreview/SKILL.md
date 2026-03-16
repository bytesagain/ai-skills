---
name: FontPreview
description: "Font preview and information tool. List installed system fonts, preview how text looks in different fonts, compare fonts side by side, check font file details, and find fonts by style or family. Essential for designers and developers working with typography."
version: "2.0.0"
author: "BytesAgain"
tags: ["font","typography","preview","text","design","system","css","developer"]
categories: ["Developer Tools", "Utility"]
---
# FontPreview
Preview fonts. List installed fonts. Typography info at your fingertips.
## Commands
- `list [filter]` — List installed fonts (optional filter)
- `preview <text>` — Preview text in various styles
- `info <font_file>` — Show font file details
- `count` — Count installed fonts
- `web` — Common web-safe font stacks
## Usage Examples
```bash
fontpreview list mono
fontpreview preview "Hello World"
fontpreview count
fontpreview web
```
---
Powered by BytesAgain | bytesagain.com

## When to Use

- for batch processing fontpreview operations
- as part of a larger automation pipeline

## Output

Returns summaries to stdout. Redirect to a file with `fontpreview run > output.txt`.

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
