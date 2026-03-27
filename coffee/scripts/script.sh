#!/usr/bin/env bash
# coffee v2.0.0 — Brew Guide, Bean Encyclopedia & Gear Finder
# Powered by BytesAgain | bytesagain.com
set -uo pipefail
VERSION="2.0.1"

# ── Brew Methods ──────────────────────────────────────────
cmd_brew() {
    local method="${1:-list}"
    case "$method" in
        pourover|pour-over|v60)
            cat << 'EOF'
☕ POUR OVER (V60 / Hario)

Ratio:    1:15 (e.g. 20g coffee → 300ml water)
Grind:    Medium-fine (like table salt)
Temp:     92-96°C (198-205°F)
Time:     2:30-3:30 total

Steps:
  1. Rinse filter with hot water, discard rinse water
  2. Add grounds, create small well in center
  3. Bloom: pour 2x coffee weight in water (40ml), wait 30-45s
  4. Pour in slow circles, keeping water level consistent
  5. Total brew time should be 2:30-3:30

Flavor: Clean, bright, highlights origin character
Best for: Single-origin light/medium roasts

💡 Tip: A gooseneck kettle makes a huge difference in pour control.
EOF
            ;;
        espresso)
            cat << 'EOF'
☕ ESPRESSO

Ratio:    1:2 (e.g. 18g in → 36g out)
Grind:    Fine (like powdered sugar)
Temp:     90-96°C (195-205°F)
Pressure: 9 bars
Time:     25-30 seconds

Steps:
  1. Dose 18-20g into portafilter
  2. Distribute evenly, tamp with 15kg pressure
  3. Lock in, start extraction immediately
  4. Look for honey-like flow starting at 5-8s
  5. Stop at 1:2 ratio (25-30s total)

Signs of good extraction:
  ✅ Tiger striping in the stream
  ✅ Thick golden crema
  ❌ Sour = under-extracted (grind finer)
  ❌ Bitter = over-extracted (grind coarser)

💡 Tip: Weigh your output, don't just time it.
EOF
            ;;
        frenchpress|french-press|press)
            cat << 'EOF'
☕ FRENCH PRESS

Ratio:    1:12 to 1:15 (e.g. 30g coffee → 400ml water)
Grind:    Coarse (like sea salt)
Temp:     93-96°C (200-205°F)
Time:     4:00 steep

Steps:
  1. Add coarse grounds to press
  2. Pour all water at once, start timer
  3. Stir gently at 1:00
  4. Place lid on (don't press yet), wait until 4:00
  5. Press slowly and evenly
  6. Pour immediately (don't let it sit in the press)

Flavor: Full-bodied, rich, textured
Best for: Medium-dark roasts, blends

💡 Tip: For cleaner cup, skim foam off top at 4:00 before pressing.
EOF
            ;;
        coldbrew|cold-brew|cold)
            cat << 'EOF'
☕ COLD BREW

Ratio:    1:5 for concentrate, 1:8 for ready-to-drink
Grind:    Extra coarse (like raw sugar)
Temp:     Room temp or fridge
Time:     12-24 hours

Steps:
  1. Combine coarse grounds and room-temp water
  2. Stir to ensure all grounds are wet
  3. Cover and refrigerate 12-24 hours
  4. Strain through fine mesh + paper filter
  5. Concentrate: dilute 1:1 with water/milk

Flavor: Smooth, low acid, naturally sweet
Best for: Hot summer days, milk-based drinks

💡 Tip: Cold brew concentrate keeps 2 weeks refrigerated.
EOF
            ;;
        aeropress)
            cat << 'EOF'
☕ AEROPRESS (Inverted Method)

Ratio:    1:12 (17g coffee → 200ml water)
Grind:    Medium-fine
Temp:     80-85°C (175-185°F) — lower than other methods
Time:     1:30-2:00

Steps:
  1. Set up inverted (plunger on bottom)
  2. Add grounds, pour water, stir 10s
  3. Steep 1:00-1:30
  4. Attach filter cap (pre-wetted filter)
  5. Flip onto mug, press gently 20-30s

Flavor: Clean, versatile, can mimic espresso or filter
Best for: Travel, experimentation, single cups

💡 Tip: Try the World AeroPress Championship recipes for inspiration.
EOF
            ;;
        mokapot|moka)
            cat << 'EOF'
☕ MOKA POT (Stovetop Espresso)

Ratio:    Fill basket fully, water to valve line
Grind:    Medium (slightly finer than drip)
Temp:     Medium-low heat
Time:     4-5 minutes total

Steps:
  1. Fill bottom chamber with hot water (to safety valve)
  2. Fill basket with grounds, level off (don't tamp)
  3. Assemble tightly, place on medium-low heat
  4. When coffee starts flowing, reduce heat
  5. Remove from heat when you hear hissing/gurgling
  6. Run cold water over bottom to stop extraction

Flavor: Strong, concentrated, Italian-style
Best for: Making lattes at home without an espresso machine

💡 Tip: Pre-heating water prevents the coffee from cooking on the stove.
EOF
            ;;
        chemex)
            cat << 'EOF'
☕ CHEMEX

Ratio:    1:15 to 1:17
Grind:    Medium-coarse (like kosher salt)
Temp:     93-96°C (200-205°F)
Time:     3:30-4:30

Steps:
  1. Place thick side of filter toward spout
  2. Rinse filter thoroughly, discard water
  3. Add grounds, bloom with 2x weight water, wait 45s
  4. Pour in circles, maintain water level
  5. Total drawdown: 3:30-4:30

Flavor: Very clean, tea-like clarity, sweet
Best for: Showcasing delicate light roasts

💡 Tip: Chemex filters are 20-30% thicker than standard — this creates the signature clean taste.
EOF
            ;;
        siphon|vacuum)
            cat << 'EOF'
☕ SIPHON (VACUUM) BREWER

Ratio:    1:14 to 1:16
Grind:    Medium
Temp:     Water rises at ~95°C
Time:     1:00-1:30 steep in upper chamber

Steps:
  1. Add water to bottom globe, heat until bubbling
  2. Attach top chamber with filter
  3. Water rises to top — add grounds, stir gently
  4. Steep 1:00-1:30, then remove heat
  5. Vacuum pulls coffee back down through filter

Flavor: Extremely clean and complex, theatrical to make
Best for: Impressing guests, light roasts

💡 Tip: Looks like a science experiment, tastes like perfection.
EOF
            ;;
        list|*)
            cat << 'EOF'
☕ Available Brew Methods:

  pourover     Pour Over / V60 — clean, bright
  espresso     Espresso — concentrated, intense
  frenchpress  French Press — full-bodied, rich
  coldbrew     Cold Brew — smooth, low acid
  aeropress    AeroPress — versatile, travel-friendly
  mokapot      Moka Pot — strong, Italian-style
  chemex       Chemex — ultra-clean, sweet
  siphon       Siphon — theatrical, complex

Usage: coffee brew <method>
EOF
            ;;
    esac
}

# ── Ratio Calculator ─────────────────────────────────────
cmd_ratio() {
    local cups="${1:-1}"
    local strength="${2:-medium}"

    local ml_per_cup=240
    local ratio
    case "$strength" in
        strong) ratio=12 ;;
        light)  ratio=17 ;;
        *)      ratio=15 ;;  # medium default
    esac

    local total_water=$((cups * ml_per_cup))
    local grams=$(echo "scale=1; $total_water / $ratio" | bc 2>/dev/null || echo "$((total_water / ratio))")

    cat << EOF
☕ Coffee Ratio Calculator

  Cups:       $cups (${ml_per_cup}ml each)
  Strength:   $strength (1:${ratio})
  ─────────────────────
  Coffee:     ${grams}g
  Water:      ${total_water}ml (${total_water}g)

  Brew method ratios:
    Pour Over:    1:15 (medium) — ${grams}g
    French Press: 1:12 (strong) — $((total_water / 12))g
    Cold Brew:    1:5  (concentrate) — $((total_water / 5))g
    Espresso:     1:2  (18g in → 36g out)

Usage: coffee ratio <cups> [strong|medium|light]
EOF
}

# ── Bean Origins ──────────────────────────────────────────
cmd_beans() {
    local origin="${1:-list}"
    case "$origin" in
        ethiopia|ethiopian)
            cat << 'EOF'
🫘 ETHIOPIA — The Birthplace of Coffee

Region:     Yirgacheffe, Sidamo, Guji, Harrar
Altitude:   1,500-2,200m
Processing: Washed & Natural
Harvest:    Oct-Feb

Flavor Profile:
  🍋 Bright citrus acidity
  🫐 Blueberry, strawberry (natural process)
  🌸 Floral, jasmine, bergamot (washed)
  🍯 Honey sweetness

Best Brew: Pour over, AeroPress
Roast:     Light to medium

Fun fact: Legend says a goat herder named Kaldi discovered coffee
when his goats danced after eating coffee cherries (~850 AD).
EOF
            ;;
        colombia|colombian)
            cat << 'EOF'
🫘 COLOMBIA — Balanced & Versatile

Region:     Huila, Nariño, Tolima, Antioquia
Altitude:   1,200-2,000m
Processing: Washed (mostly)
Harvest:    Year-round (main: Sep-Dec)

Flavor Profile:
  🍫 Chocolate, caramel
  🍎 Red apple, stone fruit
  🥜 Nutty, well-balanced
  🍬 Sweet, medium body

Best Brew: Any method — extremely versatile
Roast:     Medium

Fun fact: Colombia is the 3rd largest coffee producer.
EOF
            ;;
        brazil|brazilian)
            cat << 'EOF'
🫘 BRAZIL — #1 Producer Worldwide

Region:     Minas Gerais, São Paulo, Bahia
Altitude:   800-1,400m (lower than most)
Processing: Natural & Pulped Natural
Harvest:    May-Sep

Flavor Profile:
  🍫 Dark chocolate, cocoa
  🥜 Peanut, hazelnut
  🍬 Low acidity, heavy body
  🍞 Toasty, biscuit-like

Best Brew: Espresso, French Press
Roast:     Medium to dark

Fun fact: Brazil produces ~35% of the world's coffee.
EOF
            ;;
        kenya|kenyan)
            cat << 'EOF'
🫘 KENYA — Bold & Juicy

Region:     Nyeri, Kirinyaga, Embu, Kiambu
Altitude:   1,400-2,000m
Processing: Washed (double washed / Kenya process)
Harvest:    Oct-Dec (main), Jun-Aug (fly crop)

Flavor Profile:
  🍅 Tomato-like acidity
  🫐 Blackcurrant, grapefruit
  🍬 Brown sugar sweetness
  💪 Full body, winey

Best Brew: Pour over, Chemex
Roast:     Light to medium

Fun fact: Kenya grades beans by size — AA is the largest (screen 17-18).
EOF
            ;;
        guatemala|guatemalan)
            cat << 'EOF'
🫘 GUATEMALA — Complex & Smoky

Region:     Antigua, Huehuetenango, Atitlán, Cobán
Altitude:   1,300-2,000m
Processing: Washed
Harvest:    Dec-Mar

Flavor Profile:
  🍫 Chocolate, toffee
  🌶️ Spicy, smoky
  🍎 Apple, citrus
  🍬 Full body, complex

Best Brew: French Press, drip
Roast:     Medium to dark

Fun fact: Antigua coffees are grown between three volcanoes.
EOF
            ;;
        list|*)
            cat << 'EOF'
🫘 Coffee Bean Origins:

  ethiopia    🇪🇹 Floral, fruity, birthplace of coffee
  colombia    🇨🇴 Balanced, versatile, year-round harvest
  brazil      🇧🇷 Chocolatey, nutty, #1 producer
  kenya       🇰🇪 Bold, juicy, tomato-like acidity
  guatemala   🇬🇹 Complex, smoky, volcanic soil

Usage: coffee beans <origin>
EOF
            ;;
    esac
}

# ── Caffeine Content ──────────────────────────────────────
cmd_caffeine() {
    local drink="${1:-all}"
    if [[ "$drink" == "all" ]]; then
        cat << 'EOF'
☕ Caffeine Content Comparison (per serving)

  Drink               Serving    Caffeine    Per 100ml
  ─────────────────   ────────   ────────    ────────
  Espresso            30ml       63mg        210mg
  Drip/Filter         240ml      96mg        40mg
  Pour Over           240ml      80-100mg    35-42mg
  Cold Brew           240ml      200mg       83mg
  French Press        240ml      80-100mg    35-42mg
  AeroPress           240ml      50-70mg     21-29mg
  Latte               360ml      63mg        18mg
  Cappuccino          180ml      63mg        35mg
  Americano           240ml      63mg        26mg
  Instant Coffee      240ml      30-90mg     12-38mg
  Decaf               240ml      2-7mg       1-3mg

  ⚠️ Daily recommended limit: 400mg (≈4 espressos or 4 cups drip)
  
  Surprising fact: Cold brew has the MOST caffeine per serving
  because of the long extraction time (12-24 hours).
EOF
    else
        echo "Usage: coffee caffeine"
        echo "Shows caffeine comparison for all drink types."
    fi
}

# ── Recipes ───────────────────────────────────────────────
cmd_recipe() {
    local name="${1:-list}"
    case "$name" in
        dirty)
            cat << 'EOF'
🥤 DIRTY COFFEE (Dirty Latte)

Ingredients:
  • 1 shot espresso (30ml), freshly pulled
  • 200ml cold whole milk (full fat is key)
  • Ice cubes

Steps:
  1. Fill a clear glass with ice
  2. Pour cold milk over ice
  3. Slowly pour hot espresso over the back of a spoon
  4. The espresso floats on top creating layers

The "dirty" look comes from the espresso slowly sinking
through the milk. Don't stir — drink through the layers.

Variations:
  • Dirty Matcha: replace espresso with matcha shot
  • Dirty Chai: add chai concentrate to milk first
  • Oat Dirty: use oat milk for creamier texture
EOF
            ;;
        oatlatte|oat-latte|oat)
            cat << 'EOF'
🥤 OAT MILK LATTE

Ingredients:
  • 1-2 shots espresso (or strong moka pot coffee)
  • 200ml oat milk (barista edition froths better)

Steps:
  1. Pull espresso into cup
  2. Steam/heat oat milk to 60-65°C (don't overheat — oat milk burns easily)
  3. Pour steamed milk, holding back foam with spoon
  4. Spoon foam on top

Tips:
  • Oatly Barista Edition froths best
  • Don't heat above 65°C or it gets slimy
  • Oat milk is naturally sweeter than cow's milk — try without sugar first
EOF
            ;;
        mocha)
            cat << 'EOF'
🥤 MOCHA (Café Mocha)

Ingredients:
  • 1-2 shots espresso
  • 15-20g dark chocolate or 2 tbsp cocoa powder
  • 200ml steamed milk
  • Whipped cream (optional)

Steps:
  1. Melt chocolate in cup with a splash of hot water
     (or mix cocoa powder with hot water to form paste)
  2. Pull espresso directly into chocolate mixture
  3. Stir to combine
  4. Add steamed milk
  5. Top with whipped cream and cocoa powder dusting

Variations:
  • White Mocha: use white chocolate
  • Peppermint Mocha: add peppermint extract
  • Iced Mocha: skip steaming, pour over ice
EOF
            ;;
        affogato)
            cat << 'EOF'
🥤 AFFOGATO

Ingredients:
  • 1 shot hot espresso
  • 1 scoop vanilla gelato or ice cream

Steps:
  1. Place scoop of gelato in a small cup or bowl
  2. Pour hot espresso directly over gelato
  3. Serve immediately — eat/drink before it fully melts

That's it. Two ingredients. Perfect dessert.

Variations:
  • Add a shot of Amaretto or Baileys
  • Use salted caramel ice cream
  • Sprinkle crushed biscotti on top
EOF
            ;;
        coldbrew-tonic|tonic)
            cat << 'EOF'
🥤 COLD BREW TONIC (Espresso Tonic)

Ingredients:
  • 60ml cold brew concentrate (or 1 shot espresso, cooled)
  • 150ml tonic water (quality matters — Fever-Tree recommended)
  • Ice cubes
  • Lemon slice (optional)

Steps:
  1. Fill glass with ice
  2. Pour tonic water over ice
  3. Slowly pour cold brew on top
  4. Garnish with lemon slice

The bubbles from tonic + coffee bitterness = surprisingly refreshing.
Perfect for hot summer afternoons.
EOF
            ;;
        list|*)
            cat << 'EOF'
🥤 Coffee Recipes:

  dirty          Dirty Coffee — espresso on cold milk
  oatlatte       Oat Milk Latte — creamy, plant-based
  mocha          Café Mocha — chocolate + espresso
  affogato       Affogato — espresso on gelato
  coldbrew-tonic Espresso Tonic — fizzy and refreshing

Usage: coffee recipe <name>
EOF
            ;;
    esac
}

# ── Shopping Recommendations ──────────────────────────────
cmd_shop() {
    local category="${1:-all}"
    case "$category" in
        grinder|grinders)
            cat << 'EOF'
🛒 Coffee Grinder Recommendations

ENTRY LEVEL ($30-80):
  • Timemore C2 — Best bang for buck hand grinder
  • Hario Skerton Pro — Reliable, widely available
  • JavaPresse Manual — Budget-friendly starter

MID RANGE ($80-250):
  • 1Zpresso JX — Excellent hand grinder, fast grinding
  • Baratza Encore — The standard home electric grinder
  • Fellow Ode Brew — Beautiful design, great for filter

HIGH END ($250+):
  • Niche Zero — Single dose, zero retention
  • Baratza Sette 270 — Best value espresso grinder
  • Comandante C40 — The gold standard hand grinder

💡 Rule of thumb: Spend as much on your grinder as your brewer.
   A good grinder with a cheap brewer > expensive brewer with blade grinder.
EOF
            ;;
        beans)
            cat << 'EOF'
🛒 Where to Buy Great Coffee Beans

ONLINE ROASTERS (ship fresh):
  • Trade Coffee — curated subscriptions
  • Counter Culture — excellent single origins
  • Blue Bottle — smooth, accessible
  • Onyx Coffee Lab — award-winning
  • SEY Coffee — rare microlots

TIPS FOR BUYING:
  ✅ Look for roast date (not expiration date)
  ✅ Buy whole bean, grind fresh
  ✅ Use within 2-4 weeks of roast date
  ✅ Light roast = more origin flavor
  ✅ Dark roast = more roast flavor (chocolate, smoky)
  ❌ Avoid beans with no roast date
  ❌ Avoid pre-ground unless using within 1 week

BUDGET TIP: Local roasters often have better prices than
big online brands and you support your community.
EOF
            ;;
        machine|machines|espresso)
            cat << 'EOF'
🛒 Espresso Machine Recommendations

ENTRY LEVEL ($100-300):
  • Flair NEO — Manual lever, no electricity needed
  • DeLonghi Stilosa — Cheapest real espresso machine
  • Breville Bambino — Compact, fast heat-up

MID RANGE ($300-700):
  • Breville Barista Express — Built-in grinder, all-in-one
  • Gaggia Classic Pro — Italian classic, upgradeable
  • Rancilio Silvia — Built like a tank, great steaming

HIGH END ($700+):
  • Breville Dual Boiler — PID, simultaneous brew+steam
  • Lelit Bianca — Flow control paddle
  • Decent DE1 — Digital, app-controlled, the future

💡 Don't forget: Budget for a good grinder too.
   Espresso grinder matters MORE than the machine.
EOF
            ;;
        accessories|gear)
            cat << 'EOF'
🛒 Essential Coffee Accessories

MUST HAVE:
  • Scale with 0.1g precision ($15-30) — weighing is everything
  • Gooseneck kettle ($25-60) — essential for pour over
  • Timer (or phone) — consistency matters

NICE TO HAVE:
  • WDT tool ($10) — distribute espresso grounds evenly
  • Knock box ($15-25) — for espresso puck disposal
  • Milk frothing pitcher ($12-20) — for latte art
  • Airtight canister ($15-30) — keep beans fresh
  • Cupping spoon ($8) — taste like a pro

GAME CHANGERS:
  • Fellow Stagg EKG kettle — precise temp, gorgeous
  • Acaia Pearl scale — Bluetooth, auto-tare, flow rate
  • Normcore V4 tamper — spring-loaded, consistent tamp
EOF
            ;;
        *)
            cat << 'EOF'
🛒 Coffee Gear Categories:

  grinder       Grinder recommendations (hand & electric)
  beans         Where to buy great coffee beans
  machine       Espresso machine recommendations
  accessories   Essential accessories & gear

Usage: coffee shop <category>
EOF
            ;;
    esac
}

# ── Coffee Quiz ───────────────────────────────────────────
cmd_quiz() {
    cat << 'EOF'
☕ Find Your Perfect Coffee Style

Answer these questions to find your ideal brew:

Q1: How much time do you have in the morning?
  a) Under 2 minutes → Espresso or AeroPress
  b) 3-5 minutes → Pour over or French press
  c) I prep the night before → Cold brew

Q2: What flavor do you prefer?
  a) Strong & bold → Espresso, Moka pot, or dark roast French press
  b) Clean & bright → Pour over with light roast Ethiopian
  c) Smooth & easy → Cold brew or medium roast drip
  d) Sweet & milky → Latte or mocha with any base

Q3: Your budget?
  a) Minimal ($20-50) → French press or AeroPress
  b) Moderate ($50-150) → Pour over setup (kettle + dripper + grinder)
  c) All in ($200+) → Espresso machine + grinder

QUICK PICKS:
  ☀️ Morning rush     → AeroPress + hand grinder
  🏠 Home café        → Breville Bambino + Baratza Encore
  🎒 Travel           → AeroPress Go + Timemore C2
  💰 Budget king      → French press + Hario Skerton
  🧊 Summer default   → Cold brew pitcher + coarse grounds
  🎨 Impress guests   → Chemex + light roast Ethiopian

Run 'coffee brew <method>' for detailed instructions on any method.
EOF
}

# ── Help ──────────────────────────────────────────────────
show_help() {
    cat << EOF
☕ coffee v${VERSION} — Brew Guide, Bean Encyclopedia & Gear Finder

Usage: coffee <command> [args]

Commands:
  brew <method>      Brewing method guide (pourover, espresso, frenchpress,
                     coldbrew, aeropress, mokapot, chemex, siphon)
  ratio <cups> [str] Coffee-to-water ratio calculator
  beans <origin>     Bean origin encyclopedia (ethiopia, colombia, brazil,
                     kenya, guatemala)
  caffeine           Caffeine content comparison across drinks
  recipe <name>      Specialty recipes (dirty, oatlatte, mocha, affogato,
                     coldbrew-tonic)
  shop <category>    Gear recommendations (grinder, beans, machine, accessories)
  quiz               Find your perfect coffee style
  help               Show this help
  version            Show version

Examples:
  coffee brew pourover          # Learn pour over technique
  coffee ratio 4 strong         # Calculate for 4 strong cups
  coffee beans ethiopia         # Ethiopian coffee guide
  coffee recipe dirty           # Make a dirty coffee

Related skills: beer, mealplan, mychef, nutrition-label
📖 More skills: bytesagain.com
EOF
}

# ── Main ──────────────────────────────────────────────────
case "${1:-help}" in
    brew)       cmd_brew "${2:-list}" ;;
    ratio)      cmd_ratio "${2:-1}" "${3:-medium}" ;;
    beans)      cmd_beans "${2:-list}" ;;
    caffeine)   cmd_caffeine "${2:-all}" ;;
    recipe)     cmd_recipe "${2:-list}" ;;
    shop)       cmd_shop "${2:-all}" ;;
    quiz)       cmd_quiz ;;
    help|-h|--help) show_help ;;
    version|-v|--version) echo "coffee v${VERSION}" ;;
    *)          echo "Unknown command: $1"; show_help ;;
esac
