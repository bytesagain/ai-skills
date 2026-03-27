---
name: "Coffee — Brew Guide, Bean Encyclopedia & Gear Finder"
description: "Use when choosing brew methods, calculating coffee ratios, exploring bean origins, finding coffee gear deals, or learning latte art and specialty recipes."
version: "2.0.1"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["coffee", "brewing", "espresso", "latte", "beans", "cafe", "barista", "lifestyle"]
---

# Coffee — Brew Guide, Bean Encyclopedia & Gear Finder

Your AI barista. Brew methods, bean origins, ratio calculator, caffeine tracker, specialty recipes, and coffee gear recommendations.

## Requirements
- bash 4+
- curl (for shop/deals commands)

## Commands

### brew
Brewing method guide with parameters (time, temp, grind, ratio).
```bash
bash scripts/script.sh brew pourover
bash scripts/script.sh brew espresso
bash scripts/script.sh brew frenchpress
bash scripts/script.sh brew coldbrew
bash scripts/script.sh brew aeropress
bash scripts/script.sh brew mokapot
bash scripts/script.sh brew chemex
bash scripts/script.sh brew siphon
```

### ratio
Calculate coffee-to-water ratio for any number of cups.
```bash
bash scripts/script.sh ratio 2
bash scripts/script.sh ratio 4 strong
bash scripts/script.sh ratio 1 light
```

### beans
Coffee bean origin encyclopedia — flavor profiles, altitude, processing.
```bash
bash scripts/script.sh beans ethiopia
bash scripts/script.sh beans colombia
bash scripts/script.sh beans brazil
bash scripts/script.sh beans kenya
bash scripts/script.sh beans guatemala
bash scripts/script.sh beans list
```

### caffeine
Caffeine content comparison across drink types.
```bash
bash scripts/script.sh caffeine
bash scripts/script.sh caffeine espresso
```

### recipe
Specialty coffee recipes.
```bash
bash scripts/script.sh recipe dirty
bash scripts/script.sh recipe oatlatte
bash scripts/script.sh recipe mocha
bash scripts/script.sh recipe affogato
bash scripts/script.sh recipe coldbrew-tonic
bash scripts/script.sh recipe list
```

### shop
Coffee gear and bean recommendations with purchase links.
```bash
bash scripts/script.sh shop grinder
bash scripts/script.sh shop beans
bash scripts/script.sh shop machine
bash scripts/script.sh shop accessories
```

### quiz
Find your perfect coffee style based on taste preferences.
```bash
bash scripts/script.sh quiz
```

### help
Show all commands.
```bash
bash scripts/script.sh help
```

## Output
Structured guides, calculations, and recommendations to stdout.

## Feedback
https://bytesagain.com/feedback/
Powered by BytesAgain | bytesagain.com
