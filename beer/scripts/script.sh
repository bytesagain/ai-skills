#!/usr/bin/env bash
# beer v2.0.0 — Styles Encyclopedia, Food Pairing & Homebrew Guide
# Powered by BytesAgain | bytesagain.com
set -uo pipefail
VERSION="2.0.1"

# ── Beer Styles ───────────────────────────────────────────
cmd_styles() {
    local style="${1:-list}"
    case "$style" in
        ipa)
            cat << 'EOF'
🍺 IPA (India Pale Ale)

ABV:      5.5-7.5% (standard) / 7.5-10%+ (Double/Imperial)
IBU:      40-70 (standard) / 60-100+ (Double)
Color:    Golden to amber

Sub-styles:
  • West Coast IPA — bitter, piney, resinous, dry finish
  • New England IPA (NEIPA/Hazy) — juicy, tropical, low bitterness, hazy
  • Session IPA — lower ABV (3.5-5%), still hoppy
  • Double/Imperial IPA — bigger, bolder, higher ABV
  • Brut IPA — bone-dry, champagne-like, effervescent

Flavor Profile:
  🍊 Citrus (grapefruit, orange)
  🌲 Pine, resin
  🥭 Tropical fruit (mango, passion fruit — in NEIPAs)
  🌿 Floral, herbal

Classic Examples:
  • Lagunitas IPA (West Coast)
  • Tree House Julius (NEIPA)
  • Pliny the Elder (Double IPA)
  • Stone IPA (West Coast classic)

History: Originally brewed in England with extra hops to survive
the sea voyage to India. Modern IPAs are an American reinvention.
EOF
            ;;
        stout)
            cat << 'EOF'
🍺 STOUT

ABV:      4-6% (dry) / 8-13% (imperial)
IBU:      25-50
Color:    Very dark brown to black

Sub-styles:
  • Dry/Irish Stout — light body, roasty, coffee-like (Guinness)
  • Milk/Sweet Stout — lactose added, creamy, dessert-like
  • Oatmeal Stout — silky, smooth, oat-enhanced body
  • Imperial/Russian Stout — big, boozy, intense
  • Pastry Stout — adjuncts (vanilla, maple, cinnamon, etc.)

Flavor Profile:
  ☕ Coffee, espresso
  🍫 Dark chocolate, cocoa
  🍞 Roasted barley, toast
  🍬 Caramel, molasses (in sweeter versions)

Classic Examples:
  • Guinness Draught (Dry Irish)
  • Left Hand Milk Stout (Sweet)
  • Founders Breakfast Stout (Imperial)
  • North Coast Old Rasputin (Russian Imperial)

Fun fact: Stout was originally short for "stout porter" — 
a stronger version of porter.
EOF
            ;;
        lager)
            cat << 'EOF'
🍺 LAGER

ABV:      4-6%
IBU:      8-25
Color:    Pale straw to golden

Sub-styles:
  • American Lager — light, crisp, mild (Budweiser, Coors)
  • Pilsner — more hoppy, floral, spicy (see 'pilsner')
  • Helles — malty, bready, Munich-style
  • Märzen/Oktoberfest — amber, toasty, malty
  • Dunkel — dark, malty, bread crust
  • Bock/Doppelbock — strong, malty, 6-10% ABV

Flavor Profile:
  🍞 Bread, cracker
  🌾 Light grain, cereal
  🍯 Mild sweetness
  💧 Clean, crisp finish

Classic Examples:
  • Augustiner Helles (Munich Helles)
  • Paulaner Oktoberfest (Märzen)
  • Spaten Dunkel (Dark Lager)
  • Ayinger Celebrator (Doppelbock)

Lager vs Ale: Lagers use bottom-fermenting yeast at cold temps
(7-13°C). Ales use top-fermenting yeast at warmer temps (15-24°C).
EOF
            ;;
        wheat|weizen|hefeweizen)
            cat << 'EOF'
🍺 WHEAT BEER (Weizen/Hefeweizen)

ABV:      4.5-5.5%
IBU:      8-15
Color:    Pale, hazy/cloudy

Sub-styles:
  • Hefeweizen — Bavarian, banana & clove, unfiltered
  • Witbier/White — Belgian, coriander & orange peel
  • American Wheat — clean, less yeast character
  • Berliner Weisse — sour, tart, low ABV (3-4%)
  • Dunkelweizen — dark wheat, banana bread flavor

Flavor Profile:
  🍌 Banana (from yeast esters)
  🌿 Clove, spice (from yeast phenols)
  🍊 Orange peel (in Witbier)
  🍞 Bready, doughy
  ☁️ Light, refreshing

Classic Examples:
  • Weihenstephaner Hefeweissbier (the benchmark)
  • Hoegaarden (Belgian Witbier)
  • Franziskaner Hefeweizen
  • Schneider Weisse

💡 Serve in a tall weizen glass. Pour slowly, swirl the last 
inch of beer to pick up yeast sediment, then top off.
EOF
            ;;
        sour)
            cat << 'EOF'
🍺 SOUR BEER

ABV:      3-8%
IBU:      0-10 (minimal hop bitterness)
Color:    Varies widely

Sub-styles:
  • Berliner Weisse — light, tart, wheat-based (3-4%)
  • Gose — salty, coriander, wheat, tart
  • Lambic — Belgian, spontaneous fermentation, funky
  • Gueuze — blend of young and old lambics, complex
  • Kriek — lambic with cherries
  • Flanders Red — vinous, aged in oak, complex
  • Fruited Sour — modern style, big fruit additions

Flavor Profile:
  🍋 Tart, acidic
  🍒 Fruit (cherry, raspberry, peach)
  🧀 Funky, barnyard (in traditional Belgian styles)
  🧂 Salt (in Gose)
  🍷 Vinous, oaky (in Flanders)

Classic Examples:
  • Cantillon Gueuze (Lambic — the gold standard)
  • Anderson Valley Gose
  • Rodenbach Grand Cru (Flanders Red)
  • Duchesse de Bourgogne (Flanders)

Sours are the fastest-growing craft beer category worldwide.
EOF
            ;;
        porter)
            cat << 'EOF'
🍺 PORTER

ABV:      4.5-6.5% (standard) / 7-12% (imperial)
IBU:      18-35
Color:    Dark brown

Sub-styles:
  • English Porter — mild, biscuity, restrained
  • American Porter — more assertive, hop-forward
  • Baltic Porter — lager-fermented, higher ABV, smooth
  • Smoked Porter — rauchbier influence, bacon-like

Flavor Profile:
  🍫 Chocolate, cocoa
  ☕ Light coffee
  🍞 Biscuit, toffee
  🥜 Nutty, caramel

Classic Examples:
  • Fuller's London Porter (English classic)
  • Founders Porter (American)
  • Sinebrychoff Porter (Baltic)
  • Alaskan Smoked Porter

Porter vs Stout: Historically the same beer — stout was a stronger
porter. Today, stouts tend to be more roasty/coffee-forward while
porters are more chocolate/caramel.
EOF
            ;;
        pilsner|pils)
            cat << 'EOF'
🍺 PILSNER

ABV:      4-5.5%
IBU:      25-45
Color:    Very pale straw to gold

Sub-styles:
  • Czech/Bohemian Pilsner — malty, soft, Saaz hops, golden
  • German Pilsner — drier, crisper, more bitter, very pale
  • Italian Pilsner — dry-hopped, modern twist

Flavor Profile:
  🌿 Floral, spicy hops (Saaz, Hallertauer)
  🍞 Light bread, cracker
  💧 Crisp, clean, dry finish
  🍯 Light honey sweetness (Czech style)

Classic Examples:
  • Pilsner Urquell (the original, since 1842)
  • Bitburger (German)
  • Rothaus Tannenzäpfle (German)
  • Birrificio Italiano Tipopils (Italian)

Fun fact: Pilsner is the most consumed beer style in the world.
It was invented in Plzeň, Czech Republic in 1842.
EOF
            ;;
        list|*)
            cat << 'EOF'
🍺 Beer Styles Encyclopedia:

  ipa        🇺🇸 Hoppy, bitter, citrus/tropical
  stout      🇮🇪 Dark, roasty, coffee/chocolate
  lager      🇩🇪 Clean, crisp, refreshing
  wheat      🇩🇪 Cloudy, banana/clove, light
  sour       🇧🇪 Tart, funky, fruity
  porter     🇬🇧 Dark, chocolatey, malty
  pilsner    🇨🇿 Crisp, floral, the world's favorite

Usage: beer styles <style>
EOF
            ;;
    esac
}

# ── Food Pairing ──────────────────────────────────────────
cmd_pair() {
    local food="${1:-list}"
    case "$food" in
        bbq|barbecue|grill)
            cat << 'EOF'
🍖 BBQ + BEER PAIRING

  Smoked Brisket     → American Brown Ale, Rauchbier (smoked beer)
  Pulled Pork        → Amber Ale, Märzen/Oktoberfest
  Ribs (sweet glaze) → IPA (bitterness cuts sweetness)
  Grilled Sausage    → Pilsner, Helles (classic combo)
  Grilled Chicken    → Wheat beer, Session IPA
  Burnt Ends         → Imperial Stout (smoke meets roast)

💡 Rule: Match intensity. Heavy meat = bold beer. Light meat = light beer.
EOF
            ;;
        pizza)
            cat << 'EOF'
🍕 PIZZA + BEER PAIRING

  Margherita         → Pilsner, Italian Lager (classic)
  Pepperoni          → Amber Ale, Vienna Lager
  Hawaiian           → Wheat beer, Belgian Wit
  Meat Lovers        → IPA, Pale Ale (hop bitterness cuts fat)
  BBQ Chicken        → Brown Ale, Amber
  Veggie             → Saison, Kölsch
  White/Truffle      → Belgian Tripel, Farmhouse Ale

💡 Pizza and beer is the world's most popular pairing. You literally can't go wrong.
EOF
            ;;
        seafood|fish|sushi)
            cat << 'EOF'
🐟 SEAFOOD + BEER PAIRING

  Oysters            → Dry Stout (Guinness!), Gose
  Fish & Chips       → English Bitter, Pale Ale
  Grilled Salmon     → Amber Ale, Belgian Dubbel
  Shrimp/Prawns      → Pilsner, Witbier
  Sushi/Sashimi      → Light Lager, Gose, Rice Lager
  Lobster            → Belgian Tripel, Brut IPA
  Ceviche            → Gose, Berliner Weisse
  Mussels            → Belgian Wit, Saison

💡 Light seafood = light beer. Rich seafood = more body is OK.
   Salt in Gose mirrors ocean flavors perfectly.
EOF
            ;;
        cheese)
            cat << 'EOF'
🧀 CHEESE + BEER PAIRING

  Cheddar (mild)     → Amber Ale, English Bitter
  Cheddar (aged)     → IPA, Barleywine
  Brie/Camembert     → Belgian Wit, Saison, Wheat
  Blue Cheese        → Imperial Stout, Barleywine (big flavors match)
  Gouda              → Belgian Dubbel, Brown Ale
  Parmesan           → Belgian Tripel, Bock
  Goat Cheese        → Sour beer, Berliner Weisse
  Mozzarella         → Pilsner, Light Lager

💡 The classic rule: "What grows together goes together."
   Belgian cheese + Belgian beer = perfection.
EOF
            ;;
        dessert|sweet)
            cat << 'EOF'
🍰 DESSERT + BEER PAIRING

  Chocolate Cake     → Imperial Stout, Milk Stout
  Vanilla Ice Cream  → Barrel-aged Stout (affogato-style)
  Apple Pie          → Hefeweizen, English Cider
  Cheesecake         → Fruit Lambic, Kriek
  Crème Brûlée       → Belgian Tripel, Doppelbock
  Brownies           → Porter, Oatmeal Stout
  Tiramisu           → Coffee Stout
  Fruit Tart         → Berliner Weisse, Fruited Sour

💡 Match sweetness levels. If the beer is less sweet than the
   dessert, it will taste thin and bitter.
EOF
            ;;
        spicy|hot)
            cat << 'EOF'
🌶️ SPICY FOOD + BEER PAIRING

  Thai Curry         → Wheat beer, Belgian Wit (cooling)
  Indian Curry       → IPA (controversial but popular), Lager
  Mexican/Tacos      → Vienna Lager, Amber, Mexican Lager
  Korean BBQ         → Pilsner, Rice Lager
  Sichuan/Mapo Tofu  → Wheat beer, Light Lager
  Buffalo Wings      → IPA, Pale Ale
  Jerk Chicken       → Red Ale, Brown Ale

💡 High carbonation + lower ABV = best with spicy food.
   Alcohol amplifies heat. High-ABV beers make spicy food hotter.
   Wheat beers and lagers cool the palate best.
EOF
            ;;
        list|*)
            cat << 'EOF'
🍽️ Food Pairing Categories:

  bbq        🍖 BBQ & grilled meats
  pizza      🍕 Pizza varieties
  seafood    🐟 Fish, sushi, shellfish
  cheese     🧀 Cheese board pairings
  dessert    🍰 Sweet treats
  spicy      🌶️ Spicy cuisine

Usage: beer pair <food>
EOF
            ;;
    esac
}

# ── ABV Calculator ────────────────────────────────────────
cmd_abv() {
    local og="${1:-}"
    local fg="${2:-}"
    if [[ -z "$og" || -z "$fg" ]]; then
        cat << 'EOF'
🧮 ABV Calculator

Usage: beer abv <OG> <FG>

  OG = Original Gravity (before fermentation)
  FG = Final Gravity (after fermentation)

Example: beer abv 1.050 1.010

Common OG ranges by style:
  Light Lager:     1.028-1.040
  Wheat Beer:      1.044-1.052
  Pale Ale:        1.045-1.060
  IPA:             1.056-1.075
  Stout:           1.036-1.076
  Double IPA:      1.065-1.100
  Imperial Stout:  1.075-1.115
  Barleywine:      1.080-1.120
EOF
        return
    fi

    local abv=$(echo "scale=2; ($og - $fg) * 131.25" | bc 2>/dev/null)
    local attenuation=$(echo "scale=1; (($og - $fg) / ($og - 1)) * 100" | bc 2>/dev/null)
    local calories=$(echo "scale=0; ((6.9 * (($og - $fg) / (1.775 - $og))) + 4 * (($fg - 1) * 1000 * 0.1)) * 3.55" | bc 2>/dev/null || echo "N/A")

    cat << EOF
🧮 ABV Calculation Results

  Original Gravity (OG):  $og
  Final Gravity (FG):     $fg
  ─────────────────────────
  ABV:                    ${abv}%
  Apparent Attenuation:   ${attenuation}%

  Strength Category:
$(if (( $(echo "$abv < 4" | bc -l 2>/dev/null || echo 0) )); then
    echo "    🟢 Session (under 4%)"
elif (( $(echo "$abv < 6" | bc -l 2>/dev/null || echo 0) )); then
    echo "    🟡 Standard (4-6%)"
elif (( $(echo "$abv < 8" | bc -l 2>/dev/null || echo 0) )); then
    echo "    🟠 Strong (6-8%)"
else
    echo "    🔴 Very Strong (8%+)"
fi)
EOF
}

# ── Tasting Guide ─────────────────────────────────────────
cmd_taste() {
    cat << 'EOF'
🍺 Beer Tasting Framework

APPEARANCE (Look):
  Color:    Straw → Gold → Amber → Brown → Black
  Clarity:  Brilliant → Clear → Slight haze → Hazy → Opaque
  Head:     None → Thin → Moderate → Thick → Rocky
  Lacing:   None → Minimal → Moderate → Excellent

AROMA (Smell):
  □ Malt: bread, biscuit, caramel, chocolate, coffee, roast
  □ Hops: floral, citrus, pine, tropical, herbal, spicy
  □ Yeast: fruity (banana, apple), spicy (clove, pepper), funky
  □ Other: vanilla, bourbon, smoke, sour, mineral

FLAVOR (Taste):
  □ Malt character: ___
  □ Hop character: ___
  □ Bitterness: Low / Medium / High
  □ Sweetness: Dry / Off-dry / Medium / Sweet
  □ Balance: Malt-forward / Balanced / Hop-forward

MOUTHFEEL (Texture):
  □ Body: Light / Medium / Full
  □ Carbonation: Low / Medium / High
  □ Finish: Short / Medium / Lingering
  □ Warmth: None / Mild / Noticeable (from alcohol)

OVERALL IMPRESSION:
  □ Score: ___/5
  □ Would order again? Y/N
  □ Notes: ___

💡 Tip: Serve in proper glassware, pour into a glass (never
drink from the bottle/can), and let strong beers warm slightly.
EOF
}

# ── Homebrew Recipes ──────────────────────────────────────
cmd_homebrew() {
    local recipe="${1:-list}"
    case "$recipe" in
        starter|start|beginner)
            cat << 'EOF'
🏠 HOMEBREW: Getting Started

EQUIPMENT NEEDED ($50-100 starter kit):
  ✅ Fermenting bucket or carboy (5 gallon / 19L)
  ✅ Airlock and stopper
  ✅ Siphon/auto-siphon + tubing
  ✅ Bottle capper + caps
  ✅ Bottles (save ~50 12oz bottles)
  ✅ Sanitizer (Star San — most important item!)
  ✅ Hydrometer (measures gravity/ABV)
  ✅ Large pot (at least 3 gallons / 11L)
  ✅ Thermometer

FIRST BREW TIPS:
  1. Sanitize EVERYTHING. #1 cause of bad beer = infection
  2. Start with an extract kit (simpler than all-grain)
  3. Control fermentation temperature (18-22°C for ales)
  4. Be patient — 2 weeks fermenting + 2 weeks bottle conditioning
  5. Your first batch will be drinkable. Your 5th will be good.

PROCESS OVERVIEW:
  Brew Day (3-4 hours):
    Boil water → Add malt extract → Add hops → Cool → Add yeast
  
  Fermentation (2 weeks):
    Seal with airlock → Store at 18-22°C → Wait

  Bottling (1-2 hours):
    Add priming sugar → Fill bottles → Cap → Wait 2 more weeks

  Drink! 🍻
EOF
            ;;
        wheat|weizen)
            cat << 'EOF'
🏠 HOMEBREW: American Wheat Beer (5 gallon / 19L)

Target: OG 1.048 | FG 1.010 | ABV 5.0% | IBU 18

INGREDIENTS:
  Malt:
    • 3.3 lb Wheat LME (liquid malt extract)
    • 3.3 lb Pilsner LME
  Hops:
    • 0.75 oz Cascade (60 min) — bittering
    • 0.25 oz Cascade (5 min) — aroma
  Yeast:
    • Safale WB-06 (wheat beer yeast) or US-05 (clean)
  Other:
    • 5 oz priming sugar (for bottling)

BREW DAY:
  1. Heat 2.5 gal water to 70°C, remove from heat
  2. Stir in both LMEs until dissolved
  3. Bring to boil, add 0.75 oz Cascade
  4. Boil 55 min, add 0.25 oz Cascade
  5. Boil 5 more min (60 total)
  6. Cool to 20°C, transfer to fermenter
  7. Top up to 5 gallons with cold water
  8. Pitch yeast, seal with airlock
  9. Ferment at 18-20°C for 14 days
  10. Bottle with priming sugar, condition 14 days

Easy, refreshing, crowd-pleasing first recipe.
EOF
            ;;
        ipa)
            cat << 'EOF'
🏠 HOMEBREW: American IPA (5 gallon / 19L)

Target: OG 1.065 | FG 1.012 | ABV 7.0% | IBU 60

INGREDIENTS:
  Malt:
    • 6.6 lb Pale LME
    • 1 lb Crystal 40L (steep, don't boil)
    • 1 lb Munich LME
  Hops:
    • 1 oz Centennial (60 min) — bittering
    • 1 oz Citra (15 min) — flavor
    • 1 oz Citra (5 min) — aroma
    • 2 oz Citra (dry hop, day 7) — tropical bomb
  Yeast:
    • Safale US-05 (clean American ale)
  Other:
    • 5 oz priming sugar

BREW DAY:
  1. Steep Crystal 40L in mesh bag at 65-70°C for 30 min
  2. Remove bag, add LMEs, bring to boil
  3. 60 min: add Centennial
  4. 15 min: add 1 oz Citra
  5. 5 min: add 1 oz Citra
  6. Cool rapidly to 18°C (ice bath)
  7. Transfer, top up to 5 gal, pitch yeast
  8. Ferment at 18-20°C
  9. Day 7: add 2 oz Citra dry hop (in mesh bag)
  10. Day 14: bottle, condition 14 days

⚠️ Drink fresh! IPAs are best within 4-6 weeks of brewing.
   Hop flavor and aroma fade quickly.
EOF
            ;;
        list|*)
            cat << 'EOF'
🏠 Homebrew Recipes:

  starter    🔰 Getting started guide & equipment list
  wheat      🌾 American Wheat Beer (beginner-friendly)
  ipa        🍊 American IPA (intermediate)

Usage: beer homebrew <recipe>
EOF
            ;;
    esac
}

# ── Shopping Recommendations ──────────────────────────────
cmd_shop() {
    local category="${1:-all}"
    case "$category" in
        craft)
            cat << 'EOF'
🛒 Craft Beer Recommendations

MUST-TRY STYLES (start here):
  IPA:
    • Sierra Nevada Torpedo (West Coast classic)
    • Bell's Two Hearted (balanced, best in class)
    • Other Half Green Diamonds (NEIPA)

  Stout:
    • Guinness Draught (the gateway stout)
    • Founders Breakfast Stout (coffee + chocolate)
    • Left Hand Milk Stout Nitro (creamy dessert)

  Wheat:
    • Weihenstephaner Hefeweissbier (world's oldest brewery)
    • Hoegaarden (Belgian classic)
    • Blue Moon (widely available intro)

  Sour:
    • Anderson Valley Gose (easy entry point)
    • Dogfish Head SeaQuench (gose/kolsch/weisse blend)

  Lager:
    • Pilsner Urquell (the original pilsner)
    • Augustiner Helles (Munich's finest)

WHERE TO BUY:
  Online: Tavour, CraftShack, Drizly
  Local: Check brewery taprooms and bottle shops
  
💡 Tip: Buy singles to explore, not six-packs.
   Most craft beer shops let you build your own mix pack.
EOF
            ;;
        gear)
            cat << 'EOF'
🛒 Beer Gear & Accessories

FOR DRINKING:
  • Proper glassware set ($20-40) — makes a real difference
  • Bottle opener (get a nice wall-mounted one)
  • Growler or crowler for fresh fills from breweries

FOR HOMEBREWING:
  Starter Kit ($50-100):
    • Northern Brewer Brew Share Enjoy kit
    • Brooklyn Brew Shop kits (1 gallon, great for beginners)
    • Mr. Beer (simplest possible entry point)

  Upgrades ($100-300):
    • Wort chiller — cools beer fast, reduces contamination
    • Auto-siphon — makes transfers painless
    • Temperature controller — consistent fermentation
    • Refractometer — instant gravity readings

  Going All-Grain ($200-500):
    • Mash tun (cooler conversion or dedicated)
    • Brew-in-a-bag (BIAB) setup — simplest all-grain method
    • Grain mill — fresh-crushed grain = better beer
EOF
            ;;
        glasses|glassware)
            cat << 'EOF'
🛒 Beer Glassware Guide

THE RIGHT GLASS MATTERS — here's what to use:

  🍺 Pint Glass (Shaker)    → American ales, IPAs, stouts
  🥂 Tulip                  → Belgian ales, IPAs, strong ales
  🍷 Snifter                → Imperial stouts, barleywines, strong
  🥃 Teku                   → Universal craft beer glass (best all-rounder)
  🍺 Weizen Glass (tall)    → Wheat beers, hefeweizen
  🍺 Pilsner Glass (tall)   → Pilsners, lagers
  🍺 Mug/Stein              → Oktoberfest, traditional lagers
  🥂 Goblet/Chalice         → Belgian Trappist ales
  🍺 Stange (slim cylinder) → Kölsch, Altbier

IF YOU BUY ONLY ONE:
  → Teku glass. Designed to work with every style.
    Concentrates aromas, looks professional, dishwasher safe.

💡 Always pour beer into a glass. Aroma is 80% of flavor,
   and you can't smell beer through a can.
EOF
            ;;
        *)
            cat << 'EOF'
🛒 Beer Shopping Categories:

  craft      🍺 Craft beer recommendations by style
  gear       🔧 Equipment for drinking & homebrewing
  glasses    🥂 Glassware guide — which glass for which beer

Usage: beer shop <category>
EOF
            ;;
    esac
}

# ── Help ──────────────────────────────────────────────────
show_help() {
    cat << EOF
🍺 beer v${VERSION} — Styles Encyclopedia, Food Pairing & Homebrew Guide

Usage: beer <command> [args]

Commands:
  styles <style>     Beer style encyclopedia (ipa, stout, lager, wheat,
                     sour, porter, pilsner)
  pair <food>        Food pairing guide (bbq, pizza, seafood, cheese,
                     dessert, spicy)
  abv <OG> <FG>      Calculate ABV from gravity readings
  taste              Tasting notes framework and scoring guide
  homebrew <recipe>  Homebrew recipes (starter, wheat, ipa)
  shop <category>    Recommendations (craft, gear, glasses)
  help               Show this help
  version            Show version

Examples:
  beer styles ipa              # Learn about IPA
  beer pair bbq                # What beer with BBQ?
  beer abv 1.050 1.010         # Calculate 5.25% ABV
  beer homebrew starter        # How to start homebrewing

Related skills: coffee, mealplan, mychef, nutrition-label
📖 More skills: bytesagain.com
EOF
}

# ── Main ──────────────────────────────────────────────────
case "${1:-help}" in
    styles|style)  cmd_styles "${2:-list}" ;;
    pair|pairing)  cmd_pair "${2:-list}" ;;
    abv)           cmd_abv "${2:-}" "${3:-}" ;;
    taste|tasting) cmd_taste ;;
    homebrew|brew) cmd_homebrew "${2:-list}" ;;
    shop)          cmd_shop "${2:-all}" ;;
    help|-h|--help) show_help ;;
    version|-v|--version) echo "beer v${VERSION}" ;;
    *)             echo "Unknown command: $1"; show_help ;;
esac
