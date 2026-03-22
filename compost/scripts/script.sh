#!/usr/bin/env bash
# compost — Composting Science & Practice Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Composting Fundamentals ===

Composting is the controlled biological decomposition of organic matter
into a stable, humus-like material called compost. Microorganisms (bacteria,
fungi, actinomycetes) break down organic waste under managed conditions.

Why Compost?
  - Diverts 30-40% of household waste from landfills
  - Creates rich soil amendment (improves structure, nutrients, water retention)
  - Reduces methane emissions (landfill organic waste produces methane)
  - Suppresses plant diseases and pests
  - Reduces need for chemical fertilizers
  - Sequesters carbon in soil (climate benefit)

The Four Requirements:
  1. Carbon (browns):   Energy source for microbes
  2. Nitrogen (greens): Protein for microbial growth
  3. Water:             Moisture for microbial activity (40-60%)
  4. Oxygen:            Aerobic decomposition (turning/aeration)

  Get these four right → compost works.
  Get them wrong → problems (smell, slow, pests).

Key Microorganisms:
  Bacteria:        Primary decomposers, dominate early stages
  Fungi:           Break down tough materials (cellulose, lignin)
  Actinomycetes:   "White threads" — break down woody material
  Protozoa:        Feed on bacteria, release nutrients
  Macro-organisms: Worms, beetles, mites (in cold composting)

Timeline:
  Hot composting:  4-8 weeks (properly managed)
  Cold composting: 6-24 months (passive, low effort)
  Vermicomposting: 3-6 months (worm-driven)
  Bokashi:         2-4 weeks fermentation + 2-4 weeks soil burial
EOF
}

cmd_ratio() {
    cat << 'EOF'
=== Carbon-to-Nitrogen Ratio (C:N) ===

The Most Important Number in Composting:
  Ideal C:N ratio: 25:1 to 30:1
  Microbes need carbon for energy and nitrogen for protein
  Too much carbon (>40:1): slow decomposition
  Too much nitrogen (<20:1): ammonia smell, nitrogen loss

C:N Ratios of Common Materials:

  HIGH NITROGEN (Greens):
    Material                C:N     Notes
    Grass clippings        15-25:1  Excellent nitrogen source
    Food scraps (mixed)    15-20:1  Fruit, vegetables, coffee
    Coffee grounds         20:1     Also adds acidity
    Chicken manure         5-10:1   Very hot, use sparingly
    Horse manure           25-30:1  Good balance
    Cow manure             18-25:1  Well-balanced
    Fresh alfalfa          12:1     Excellent activator
    Seaweed/kelp           19:1     Rich in micronutrients

  HIGH CARBON (Browns):
    Material                C:N     Notes
    Dry leaves             40-80:1  Shred for faster breakdown
    Straw                  75-100:1 Good bulking agent
    Cardboard              300-500:1 Shred, remove tape
    Newspaper              150-200:1 Shred, soy-ink OK
    Wood chips             200-500:1 Very slow, use for mulch
    Sawdust                300-500:1 Fine particles, absorbs N
    Pine needles           60-100:1 Acidic, slow to break down
    Dryer lint             100:1    Only from natural fibers
    Corn stalks            60-70:1  Chop into pieces

Practical Mixing Guide:
  Simple rule: 3 parts browns to 1 part greens by volume
  (Volume, not weight — browns are lighter)

  Example recipe:
    5 gallons food scraps (N)    → 1 part green
    15 gallons dry leaves (C)    → 3 parts brown
    Mix thoroughly, add water until sponge-damp

  Quick fixes:
    Too much nitrogen → add shredded cardboard/leaves
    Too much carbon → add grass clippings/food scraps
    Not sure → err on the side of more browns
EOF
}

cmd_methods() {
    cat << 'EOF'
=== Composting Methods ===

Hot Composting (Thermophilic):
  Temperature: 130-160°F (55-70°C) at peak
  Time: 4-8 weeks
  Effort: high (turning, monitoring, building volume)
  Kills weed seeds and pathogens (at >131°F for 3+ days)
  Requires: minimum 1 cubic yard (3×3×3 ft) to maintain heat
  Turn every 3-5 days, maintain 40-60% moisture
  Best for: large volumes, fast results, clean compost

Cold Composting (Passive):
  Temperature: ambient
  Time: 6-24 months
  Effort: minimal (add materials, wait)
  Does NOT kill weed seeds or pathogens reliably
  No minimum size required
  Turn occasionally or never
  Best for: small households, low effort, patience available

Vermicomposting (Worm Composting):
  Uses: red wigglers (Eisenia fetida), NOT earthworms
  Temperature: 55-77°F (13-25°C), indoor-friendly
  Time: 3-6 months
  Feed: fruit/veg scraps, coffee grounds, shredded paper
  Avoid: citrus, onions, meat, dairy, oils
  Produces: vermicast (worm castings) — premium fertilizer
  Worm population doubles every 3-4 months
  1 lb worms eats ~0.5 lb food scraps per day

Bokashi:
  Anaerobic fermentation using Effective Microorganisms (EM)
  Not true composting — fermentation (pickles the waste)
  Process:
    1. Layer food waste with bokashi bran in sealed bucket
    2. Drain liquid every 2-3 days (dilute 100:1, use as fertilizer)
    3. After 2-4 weeks, bury in soil for final decomposition
  CAN process: meat, dairy, cooked food (unlike traditional compost)
  Best for: apartments, small spaces, all food types

In-Vessel Composting:
  Enclosed reactor (drum, tunnel, container)
  Controlled: temperature, moisture, aeration, turning
  Fast: 1-3 weeks for initial decomposition
  Used by: municipalities, commercial operations
  Capital-intensive but scalable and low-odor
EOF
}

cmd_stages() {
    cat << 'EOF'
=== Decomposition Stages ===

Stage 1 — Mesophilic (Days 1-3):
  Temperature: 68-113°F (20-45°C)
  Organisms: mesophilic bacteria, fungi
  Activity:
    - Bacteria colonize fresh material
    - Easy sugars and starches consumed first
    - Rapid population growth
    - Temperature begins rising
    - pH may drop temporarily (organic acids)

Stage 2 — Thermophilic (Days 3-30+):
  Temperature: 113-160°F (45-70°C)
  Organisms: thermophilic bacteria, actinomycetes
  Activity:
    - Rapid breakdown of proteins, fats, complex carbohydrates
    - Maximum microbial activity
    - Pathogens and weed seeds killed (>131°F for 72 hours)
    - Pile shrinks rapidly (30-50% volume reduction)
    - Ammonia may off-gas (high nitrogen)
    - Turn pile when temp drops below 130°F

  Critical temperatures:
    <90°F:   Too cold — add nitrogen, turn, check moisture
    113-131°F: Good decomposition but not pathogen-killing
    131-150°F: Ideal — pathogens killed, rapid breakdown
    >160°F:  Too hot — kills beneficial microbes, turn immediately
    >180°F:  Fire risk — turn and add water immediately

Stage 3 — Cooling (Weeks 4-8):
  Temperature: drops back to 113°F and below
  Organisms: mesophilic bacteria return, fungi increase
  Activity:
    - Cellulose and lignin breakdown (slower materials)
    - Fungi produce visible white mycelium
    - Actinomycetes create earthy smell
    - Macro-organisms appear (mites, springtails, beetles)
    - Less turning needed

Stage 4 — Curing/Maturation (Weeks 8-16):
  Temperature: ambient
  Activity:
    - Humic substances form (stable organic matter)
    - Microbial community stabilizes
    - Phytotoxic compounds break down
    - pH stabilizes near neutral (6.5-7.5)
    - C:N ratio settles to 10-15:1

  DO NOT skip curing — immature compost can:
    - Rob nitrogen from soil (high C:N)
    - Release phytotoxic compounds (harm plants)
    - Contain unstable organic acids
    - Minimum 4 weeks curing recommended
EOF
}

cmd_materials() {
    cat << 'EOF'
=== What to Compost ===

✅ GREENS (Nitrogen-Rich):
  Kitchen:
    - Fruit and vegetable scraps
    - Coffee grounds and paper filters
    - Tea bags (remove staples)
    - Eggshells (crush for faster breakdown)
    - Stale bread and grains

  Garden:
    - Grass clippings (thin layers, mix with browns)
    - Fresh plant trimmings
    - Weeds (before seeding — or hot compost only)
    - Fresh manure (herbivore: horse, cow, chicken, rabbit)

✅ BROWNS (Carbon-Rich):
  Kitchen:
    - Paper towels and napkins (unbleached preferred)
    - Cardboard (shredded, tape removed)
    - Paper bags

  Garden:
    - Dry leaves (shred for faster decomposition)
    - Straw and hay
    - Wood chips and bark (slow, better as mulch)
    - Pine needles (acidic, use in moderation)
    - Corn stalks and cobs (chop up)
    - Dried garden debris

  Other:
    - Newspaper (shredded, soy-ink OK)
    - Paper egg cartons
    - Natural fiber scraps (cotton, wool, silk)
    - Sawdust (untreated wood only)
    - Dryer lint (natural fiber clothing only)
    - Hair and fur (human and pet)

❌ DO NOT COMPOST:
  - Meat, fish, bones (attracts pests — unless bokashi)
  - Dairy products (attracts pests, smells — unless bokashi)
  - Oils and fats (smothers microbes, attracts pests)
  - Pet waste (dog, cat — pathogens harmful to humans)
  - Diseased plants (may spread disease in garden)
  - Treated/painted wood (chemicals leach into compost)
  - Coal ash (contains sulfur, heavy metals)
  - Synthetic materials (plastic, nylon, polyester)
  - Aggressive weeds (bindweed, bermuda grass — survive composting)
  - Citrus and onions in vermicompost (worms dislike)
EOF
}

cmd_troubleshoot() {
    cat << 'EOF'
=== Troubleshooting Compost Problems ===

Problem: Compost smells like rotten eggs / ammonia
  Cause:  Anaerobic conditions (too wet, too compact, no air)
  Fix:    Turn the pile, add dry browns, improve aeration
  If ammonia: too much nitrogen → add carbon (cardboard, leaves)
  If sulfur (rotten eggs): waterlogged → turn, add straw for structure

Problem: Compost is too slow (nothing happening)
  Causes and fixes:
    Too dry → add water until sponge-damp
    Too much carbon → add nitrogen (grass, food scraps)
    Pieces too large → chop/shred materials smaller
    Pile too small → needs minimum 3×3×3 ft for heat
    Cold weather → insulate pile, add more nitrogen

Problem: Attracting flies
  Cause:  Exposed food scraps
  Fix:    Always cover food with 4-6 inches of browns
  Also:   Bury food scraps in center of pile
  Also:   Avoid meat/dairy (unless bokashi or sealed system)
  Fruit flies: normal in summer, reduce by covering food

Problem: Attracting rodents/raccoons
  Cause:  Meat, dairy, or bread in open pile
  Fix:    Use enclosed bin with secure lid
  Fix:    Don't add cooked food, meat, or dairy
  Fix:    Hardware cloth (1/4") on bottom of bin

Problem: Pile is too wet / soggy
  Cause:  Too much green material, rain, poor drainage
  Fix:    Add shredded browns (cardboard, straw)
  Fix:    Turn to aerate
  Fix:    Cover pile during rain
  Fix:    Elevate bin for drainage

Problem: Pile is too dry
  Cause:  Too much brown material, hot/windy weather
  Fix:    Water thoroughly and turn
  Fix:    Add juicy greens (fruit scraps, fresh grass)
  Fix:    Cover to retain moisture

Problem: White mold / fungus
  This is NORMAL — actinomycetes (beneficial)
  White threads = healthy decomposition
  No action needed

Problem: Fire ants / termites
  Fire ants: pile too dry → moisten and turn
  Termites: attracted to woody material → turn more, keep moist
  Both: normal in warm climates, usually self-limiting
EOF
}

cmd_quality() {
    cat << 'EOF'
=== Compost Quality Assessment ===

Maturity Tests (Is It Ready?):
  Visual:   Dark brown/black, crumbly texture, no recognizable inputs
  Smell:    Earthy, like forest floor (no ammonia or sour smell)
  Temperature: Ambient (no re-heating after turning)
  Volume:   Reduced to 40-60% of original
  Squeeze:  Handful should hold together but not drip water

  Bag Test:
    1. Fill a sealed plastic bag with moist compost
    2. Wait 3 days at room temperature
    3. Open and smell
    4. Earthy = mature, sour/ammonia = immature (needs more time)

  Germination Test:
    1. Fill pot with compost, plant 10 radish seeds
    2. Fill another pot with potting soil (control)
    3. Wait 7-10 days
    4. Compare germination rate and seedling vigor
    5. >80% germination matching control = mature compost

Nutrient Content (Typical Finished Compost):
  Nitrogen (N):    1-2%
  Phosphorus (P):  0.5-1%
  Potassium (K):   0.5-1%
  pH:              6.5-7.5
  C:N ratio:       10-15:1
  Organic matter:  30-60%
  Moisture:        40-50%

  Note: compost is a soil AMENDMENT, not a fertilizer
  It feeds the soil biology, which feeds the plants
  Nutrient release is slow and steady (won't burn plants)

Application Rates:
  Garden beds:       1-3 inches, worked into top 6 inches
  Lawn topdressing:  1/4-1/2 inch, raked into grass
  Potting mix:       25-50% compost, rest perlite/peat/coir
  Trees/shrubs:      2-4 inches as mulch ring (keep from trunk)
  New raised bed:    50% compost, 50% native soil or topsoil
  Compost tea:       5 gallons water + 1 cup compost, aerate 24hr

  Annual application:
    Light: 1/2 inch (maintenance)
    Medium: 1-2 inches (building soil)
    Heavy: 3-4 inches (new garden, poor soil)

Storage:
  Finished compost stores for 1+ years
  Keep covered but not sealed (needs some air exchange)
  Protect from rain (nutrients leach out)
  Use within 12 months for maximum nutrient value
EOF
}

cmd_systems() {
    cat << 'EOF'
=== Composting Systems ===

Open Pile:
  Simplest method — pile materials on the ground
  Minimum size: 3×3×3 ft (1 cubic yard) for hot composting
  Turn with pitchfork every 5-7 days
  Pros: free, unlimited size, easy to build
  Cons: aesthetics, pests, weather exposure, slow edges

Three-Bin System:
  Bin 1: Active (adding new material)
  Bin 2: Cooking (no new additions, turning)
  Bin 3: Curing (finished, ready to use)
  Material: pallets, wire mesh, cinder blocks, wood
  Size: each bin 3×3×3 ft minimum
  Best for: continuous production, serious gardeners

Tumbler:
  Enclosed drum that rotates for easy turning
  Pros: pest-proof, easy turning, contained, tidy
  Cons: expensive ($100-400), limited capacity, can overheat
  Best for: small spaces, suburban yards, beginners
  Tip: have TWO tumblers — one filling, one cooking

Worm Bin:
  Stacking tray system (Can-O-Worms, Worm Factory)
  Start: 1 lb red wigglers in bedding (shredded newspaper)
  Feed: bury food scraps under bedding
  Harvest: when top tray full, add new tray on top
  Location: indoor, garage, shaded outdoor (55-77°F)
  Best for: apartments, kitchens, year-round composting

Windrow (Commercial):
  Long rows of compost (4-8 ft high, 14-16 ft wide)
  Turned with tractor-mounted windrow turner
  Scale: municipal, farm, industrial
  Time: 3-6 months with regular turning
  Aerated static pile: perforated pipes blow air (no turning needed)

In-Vessel (Industrial):
  Enclosed drums, tunnels, or containers
  Forced aeration, temperature monitoring, automated turning
  Time: 1-3 weeks primary decomposition
  Pros: fast, consistent, low odor, weather-independent
  Cons: expensive ($50K-$1M+), energy-intensive
  Best for: large-scale municipal or commercial operations

Trench/Pit Composting:
  Dig a trench or hole, fill with food scraps, cover with soil
  No bin needed, fully contained
  Time: 3-12 months (no turning, slower)
  Rotate: dig in different spots each time
  Best for: lazy composting, directly under future garden beds

Keyhole Garden:
  Circular raised bed with central compost basket
  Add food scraps to center, nutrients leach into garden
  Water the compost basket → nutrients flow to plants
  African design, excellent for water-scarce areas
EOF
}

show_help() {
    cat << EOF
compost v$VERSION — Composting Science & Practice Reference

Usage: script.sh <command>

Commands:
  intro        Composting fundamentals and why it matters
  ratio        Carbon-to-nitrogen ratio guide and mixing
  methods      Hot, cold, vermicomposting, bokashi, in-vessel
  stages       Decomposition stages — mesophilic to curing
  materials    What to compost and what to avoid
  troubleshoot Fix smells, pests, slow decomposition problems
  quality      Maturity tests, nutrient content, application rates
  systems      Bins, tumblers, windrows, worm bins, trench
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    ratio)        cmd_ratio ;;
    methods)      cmd_methods ;;
    stages)       cmd_stages ;;
    materials)    cmd_materials ;;
    troubleshoot) cmd_troubleshoot ;;
    quality)      cmd_quality ;;
    systems)      cmd_systems ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "compost v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
