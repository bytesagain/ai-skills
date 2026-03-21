#!/usr/bin/env bash
# thresh — Grain Threshing Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Threshing — Overview ===

Threshing is the process of separating grain (seeds) from the stalk
and husks of cereal plants. It is one of the most critical steps in
grain production.

The Three Operations of Grain Harvest:
  1. Cutting (reaping)     Severing the crop from the ground
  2. Threshing             Separating grain from plant material
  3. Winnowing (cleaning)  Separating grain from chaff

History:
  Ancient       Hand beating, trampling by animals, flail threshing
  1788          Andrew Meikle invents mechanical threshing machine
  1830s         Horse-powered threshers become common
  1880s         Steam-powered threshing machines
  1930s         Combine harvester merges all three operations
  1960s         Self-propelled combines dominate
  Modern        GPS-guided combines with yield mapping

Threshing Principle:
  Apply mechanical force to separate grain from panicle/ear/pod
  Force types:
    Impact      Grain knocked free by rotating bars or rasp
    Rubbing     Grain rubbed between surfaces (concave + cylinder)
    Stripping   Grain stripped from stalk by comb-like elements
    Squeezing   Compression forces grain from husk

Modern Combine Harvester Functions:
  Header       Gathers and cuts the crop
  Feeder       Conveys crop to threshing unit
  Thresher     Separates grain from straw (cylinder + concave)
  Separator    Separates remaining grain from MOG (Material Other than Grain)
  Cleaner      Removes chaff and debris (sieves + fan)
  Grain tank   Stores clean grain
  Unloader     Transfers grain to transport

Key Metrics:
  Threshing efficiency    % grain separated from heads/pods
  Grain loss              % grain lost (target: <1-2%)
  Grain damage            % kernels cracked or broken
  Capacity                Acres or tons per hour
  Fuel efficiency         Gallons per acre
EOF
}

cmd_mechanisms() {
    cat << 'EOF'
=== Threshing Mechanisms ===

Conventional (Tangential) Cylinder:
  Configuration: Cylinder + concave (half-moon shape)
  Cylinder types:
    Rasp bar:  Most common, aggressive threshing
    Spike tooth: For rice, tough-to-thresh crops
    Wire loop:  Gentle, for seed crops

  How it works:
    1. Crop enters between spinning cylinder and fixed concave
    2. Impact and rubbing separate grain
    3. Grain falls through concave grates
    4. Straw exits rear onto straw walkers

  Settings:
    Cylinder speed:  600-1,400 RPM (crop-dependent)
    Concave clearance: 10-40mm (front to rear)
    Closer = more aggressive threshing
    Faster = more aggressive but more damage

Axial Flow (Rotary):
  Configuration: Longitudinal rotor + cage/concave
  Crop spirals around the rotor (longer threshing path)
  
  Advantages:
    - Gentler threshing (grain damage lower)
    - Higher capacity (larger throughput)
    - Better in tough conditions (damp, green crop)
    - Simpler drive system
  
  Disadvantages:
    - More power required
    - More straw breakage (short straw pieces)
    - Higher fuel consumption
  
  Manufacturers: Case IH, New Holland, AGCO

Hybrid Systems:
  Conventional cylinder for initial threshing
  + Axial rotors for separation
  Best of both: aggressive thresh + gentle separation
  Manufacturers: John Deere (STS), Claas (Lexion)

Concave Design:
  Round bar concave:  Large openings, high-moisture crops
  Wire concave:       Medium openings, most grain crops
  Perforated plate:   Small grain, grass seed, fine cleaning

  Concave wrap angle:
    Conventional: 90-120°
    Rotary: 270-360° (full wrap around rotor)

Straw Walkers vs Rotary Separation:
  Straw walkers:   Oscillating racks that agitate straw
                   Grain falls through, straw moves to rear
                   4-6 walkers typical
  Rotary:          Centrifugal force pushes grain through grates
                   Straw wraps and exits rear
                   More capacity but shorter straw
EOF
}

cmd_crops() {
    cat << 'EOF'
=== Crop-Specific Threshing Settings ===

Wheat:
  Cylinder speed:     900-1,200 RPM
  Concave clearance:  15-25mm (front), 8-15mm (rear)
  Fan speed:          800-1,000 RPM
  Top sieve:          12-16mm opening
  Bottom sieve:       6-8mm opening
  Harvest moisture:   13-14% ideal, max 18%
  Notes: Most forgiving crop to thresh

Corn (Maize):
  Cylinder speed:     400-600 RPM (lower to reduce damage)
  Concave clearance:  25-35mm (front), 15-25mm (rear)
  Fan speed:          700-900 RPM
  Top sieve:          18-22mm opening
  Bottom sieve:       10-14mm opening
  Harvest moisture:   15-20% (will need drying)
  Notes: Use corn head with snapping rolls, not cutting header

Rice (Paddy):
  Cylinder speed:     600-800 RPM
  Concave clearance:  18-28mm (front), 10-18mm (rear)
  Fan speed:          600-800 RPM
  Top sieve:          8-12mm opening
  Bottom sieve:       4-6mm opening
  Harvest moisture:   20-24% (requires drying to 14%)
  Notes: Spike-tooth cylinder preferred, very prone to cracking

Soybeans:
  Cylinder speed:     400-600 RPM (beans damage easily)
  Concave clearance:  20-30mm (front), 12-20mm (rear)
  Fan speed:          800-1,000 RPM
  Top sieve:          12-16mm opening
  Bottom sieve:       6-8mm opening
  Harvest moisture:   13-15%
  Notes: Low cylinder speed critical — cracked beans = dock at elevator

Barley:
  Cylinder speed:     800-1,000 RPM
  Concave clearance:  15-22mm (front), 8-14mm (rear)
  Fan speed:          700-900 RPM
  Top sieve:          10-14mm opening
  Bottom sieve:       5-7mm opening
  Harvest moisture:   13-14%
  Notes: Awns can cause cleaning problems; pre-cleaner helpful

Canola (Rapeseed):
  Cylinder speed:     600-800 RPM
  Concave clearance:  20-30mm
  Fan speed:          500-700 RPM (low to keep small seeds)
  Top sieve:          6-10mm opening
  Bottom sieve:       3-5mm opening
  Harvest moisture:   8-10%
  Notes: Very small seeds, easily blown out; seal combine well
EOF
}

cmd_loss() {
    cat << 'EOF'
=== Grain Loss Management ===

Sources of Grain Loss:

Pre-harvest Loss (5-25% in developing countries):
  Shattering     Grain falls before harvest (overripe, wind, rain)
  Lodging        Plants fall over (hard to harvest)
  Bird/insect    Wildlife feeding on mature crop
  Disease        Late-season fungal damage

Header Loss (typically 1-3%):
  Shatter loss   Grain knocked off by reel or header
  Stubble loss   Cut too high, grain left on stalks
  Lodged crop    Header misses fallen plants
  Fix: Adjust reel speed, cutting height, ground speed

Threshing Loss (typically 0.5-1%):
  Unthreshed heads  Grain not separated from head/ear
  Cause: Cylinder speed too low, concave too open
  Fix: Increase cylinder speed, tighten concave

Separation Loss (typically 0.5-1.5%):
  Grain carried over straw walkers/rotors
  Cause: Too much material (ground speed too fast)
  Fix: Reduce ground speed, adjust straw walker/rotor speed

Cleaning Loss (typically 0.5-1%):
  Grain blown out with chaff by cleaning fan
  Cause: Fan speed too high, sieves too closed
  Fix: Reduce fan speed, open sieves slightly

Measuring Grain Loss:
  Drop pan method:
    1. Place pans behind combine (known area, e.g., 1 sq ft)
    2. Collect grain from several passes
    3. Count kernels per square foot
    4. Convert to bushels per acre using tables
  
  Approximate kernel counts per bushel:
    Wheat:     14 kernels/sq ft = 1 bu/acre
    Corn:      2 kernels/sq ft = 1 bu/acre
    Soybeans:  4 beans/sq ft = 1 bu/acre
    Barley:    19 kernels/sq ft = 1 bu/acre

Acceptable Loss Targets:
  Total machine loss: <1% of yield for most crops
  Each loss point = real money lost
  Example: 1% loss on 200 bu/acre corn at $5/bu = $10/acre
  On a 1,000-acre farm = $10,000 lost per percentage point

Loss Reduction Strategy:
  1. Monitor loss continuously (yield monitor, drop pans)
  2. Adjust settings when changing field/crop conditions
  3. Reduce ground speed in tough conditions
  4. Harvest at optimal moisture content
  5. Maintain sharp cutter bar and tight belts
  6. Clean concave and sieves regularly
EOF
}

cmd_timing() {
    cat << 'EOF'
=== Harvest Timing ===

Maturity Indicators by Crop:

Wheat:
  Physiological maturity: Peduncle (stem below head) turns yellow
  Harvest-ready: Kernel hard, cannot be dented with thumbnail
  Moisture at maturity: 30-35% → field dry to 13-14%
  Window: 7-14 days optimal harvest window
  Late harvest risk: Shattering, sprouting, quality loss

Corn:
  Physiological maturity: Black layer forms at kernel tip
  Milk line: Watch progress from crown to tip
  Harvest-ready: Black layer formed, 25-30% moisture
  Dry to: 15% for safe storage (can harvest wetter, dry artificially)
  Window: Several weeks (corn dries on stalk)

Soybeans:
  Physiological maturity: Pods turn brown, leaves drop
  Harvest-ready: Beans rattle in pods, 13-15% moisture
  Window: Narrow — too dry causes shattering, too wet = green stems
  Risk: Delayed harvest = pod shatter, field losses increase 2-4%/week

Rice:
  Maturity: 80-85% of grains turned from green to gold
  Harvest-ready: Top panicle grains golden, lower grains firm
  Moisture at harvest: 20-24% (must dry to 14%)
  Window: 5-7 days optimal
  Late risk: Shattering, grain discoloration, quality downgrade

Weather Considerations:
  Rain at harvest:
    - Increases grain moisture → drying costs
    - Causes sprouting (wheat, barley)
    - Promotes fungal growth (DON/vomitoxin in wheat)
    - Can lodge (flatten) mature crop
  
  Dew:
    - Morning harvest in dew → higher moisture
    - Wait until dew burns off (typically 10 AM)
    - Late afternoon: moisture may start rising again
  
  Wind:
    - Moderate wind helps dry crop
    - Strong wind causes shattering and lodging
    - Harvest windward side first if storm approaching

Harvest Logistics:
  Combine capacity planning:
    - Typical combine: 30-80 acres/day (crop-dependent)
    - Track daily: acres × yield = bushels to handle
    - Grain cart + truck logistics: match to combine speed
    - Rule: 1 combine needs 2-3 grain carts + trucks

  Timing decisions:
    - Harvest at higher moisture → drying cost but lower field loss
    - Wait for field drying → save drying cost but risk weather
    - Calculate breakeven: drying cost vs field loss per day waiting
EOF
}

cmd_postharvest() {
    cat << 'EOF'
=== Post-Harvest Handling ===

Grain Drying:

Moisture Targets for Safe Storage:
  Crop         Short-term (<6mo)  Long-term (>6mo)
  Wheat        14.0%              13.0%
  Corn         15.5%              14.0%
  Soybeans     13.0%              11.0%
  Rice         14.0%              12.5%
  Barley       14.5%              13.0%

Drying Methods:
  Natural air drying:
    - Ambient air forced through grain bin
    - Slow (days to weeks), low energy cost
    - Best when air temp >40°F, RH <70%
    - Fan airflow: 1.0-1.5 CFM per bushel
    - Maximum initial moisture: 18-20%
  
  Low-temperature drying:
    - Heated 5-10°F above ambient
    - Faster than natural air
    - Good for corn at 20-22% moisture
  
  High-temperature drying:
    - Heated to 150-230°F
    - Fast: removes 5-10% moisture points per pass
    - Types: continuous flow, batch, mixed flow
    - Fuel: LP gas, natural gas (~0.02 gal/bu per point removed)
    - Caution: over-drying = weight loss = revenue loss
    - Stress cracks in corn above 200°F

Grain Cleaning:
  Remove fines (broken kernels, dust, weed seeds)
  Fines accumulate in center of bin → airflow blockage
  Pre-cleaning before storage improves airability
  Equipment: scalper, rotary cleaner, gravity separator
  Target: <3% foreign material for most grain

Grain Storage:
  Bin preparation:
    - Clean out old grain completely (insect/mold source)
    - Inspect for leaks, seal openings
    - Check fans and aeration system
    - Treat walls with approved insecticide
  
  Aeration:
    - Purpose: equalize temperature, prevent condensation
    - Fan airflow: 0.1-0.25 CFM/bu for aeration
    - Run when outdoor temp is 10-15°F below grain temp
    - Cool grain in stages: harvest temp → fall → winter
    - Target: 35-40°F for winter storage
  
  Monitoring:
    - Check temperature cables weekly
    - Look for hot spots (insect activity, spoilage)
    - Sample for moisture, insects monthly
    - Watch for crusting on surface (condensation)

Quality Factors (affecting price):
  Test weight:   Bushel weight (lb/bu) — heavier = better
  Moisture:      Dockage if above acceptable level
  Damage:        Broken, sprouted, heat-damaged kernels
  Foreign material: Weed seeds, dirt, plant material
  Mycotoxins:    Aflatoxin (corn), DON/vomitoxin (wheat)
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Threshing Scenarios & Troubleshooting ===

--- Unthreshed Heads Coming Out the Back ---
Problem: Whole or partially threshed heads in straw residue
Causes:
  1. Cylinder speed too low → Increase speed 50-100 RPM
  2. Concave too wide → Close concave 2-3mm
  3. Feeding too fast → Reduce ground speed
  4. Worn rasp bars → Replace cylinder bars
Check: Look at straw residue behind combine regularly

--- Cracked/Broken Grain in Tank ---
Problem: High percentage of damaged kernels
Causes:
  1. Cylinder speed too high → Reduce speed 50-100 RPM
  2. Concave too tight → Open concave 2-3mm
  3. Grain too dry → Harvest earlier in the day
  4. Wrong concave type → Use wider-spaced concave
Acceptable damage:
  Corn: <3% for commercial, <1% for seed
  Soybeans: <10% splits for commercial
  Wheat: <2% broken kernels

--- Grain Going Over the Sieves (Lost in Chaff) ---
Problem: Clean grain found in chaff pile behind combine
Causes:
  1. Fan speed too high → Reduce fan speed
  2. Sieves closed too tight → Open sieve 2-4mm
  3. Top sieve plugged → Clean sieve screens
  4. Uneven feeding → Adjust feeder house chain
Test: Walk behind combine, check for grain in chaff

--- Combine Plugging / Wrapping ---
Problem: Crop wraps around cylinder or plugs feeder
Causes:
  1. Crop too green/tough → Wait for drier conditions
  2. Ground speed too fast → Slow down
  3. Cutting height too low → Raise header
  4. Worn/dull cutter bar → Replace sections
Solution: Stop immediately, reverse if possible, clear manually

--- Optimizing for Wet Conditions ---
Scenario: Rain forecast, crop at 18-20% moisture
Adjustments:
  - Increase cylinder speed 10-15%
  - Close concave 3-5mm tighter
  - Reduce fan speed slightly (wet chaff heavier)
  - Open sieves 2-3mm wider (wet material flows slower)
  - Reduce ground speed 20-30%
  - Plan for drying costs ($0.03-0.06 per bushel per point)
  - Decision: field loss risk vs drying cost
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Threshing Operations Checklist ===

Pre-Season Preparation:
  [ ] Combine serviced (oil, filters, belts, bearings)
  [ ] Concave bars/plates inspected (replace if worn)
  [ ] Cylinder rasp bars checked for wear
  [ ] Sieves cleaned and adjusted
  [ ] Straw walkers/rotors inspected
  [ ] Feeder chain tension checked
  [ ] Cutter bar sections sharpened/replaced
  [ ] Reel tines straight and functional
  [ ] Grain tank clean (no old grain/contaminants)
  [ ] Unloading auger inspected

Pre-Harvest Field Check:
  [ ] Crop maturity assessed (moisture test)
  [ ] Weather forecast reviewed (7-day)
  [ ] Harvest order planned (driest fields first)
  [ ] Grain transport arranged (trucks, carts)
  [ ] Drying capacity confirmed
  [ ] Storage bins cleaned and prepared
  [ ] Buyer/elevator contacted (delivery schedule)

Daily Harvest Operations:
  [ ] Wait for dew to dry (check grain moisture)
  [ ] Set initial combine settings for crop/conditions
  [ ] Run test strip — check behind combine for losses
  [ ] Adjust cylinder speed, concave, fan, sieves as needed
  [ ] Monitor grain sample for damage and cleanliness
  [ ] Check loss readings every 30-60 minutes
  [ ] Re-check when moving to new field or conditions change
  [ ] Grease and inspect at mid-day break
  [ ] Record yields, moisture, and field data

Post-Harvest:
  [ ] Clean combine thoroughly (crop residue = fire risk)
  [ ] Drain fuel system if storing combine long-term
  [ ] Store combine under cover if possible
  [ ] Cool grain with aeration within 24 hours
  [ ] Verify grain moisture in bins with probe
  [ ] Set up temperature monitoring cables
  [ ] Schedule first bin check within one week
  [ ] Document harvest data (yield, quality, costs)
EOF
}

show_help() {
    cat << EOF
thresh v$VERSION — Grain Threshing Reference

Usage: script.sh <command>

Commands:
  intro        Threshing overview — history, principles, modern combines
  mechanisms   Cylinder types, concave settings, rotary systems
  crops        Crop-specific settings (wheat, corn, rice, soy, canola)
  loss         Grain loss sources, measurement, and reduction
  timing       Harvest timing — moisture, maturity, weather
  postharvest  Post-harvest — drying, cleaning, storage
  examples     Troubleshooting scenarios
  checklist    Pre-harvest and operations checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    mechanisms)  cmd_mechanisms ;;
    crops)       cmd_crops ;;
    loss)        cmd_loss ;;
    timing)      cmd_timing ;;
    postharvest) cmd_postharvest ;;
    examples)    cmd_examples ;;
    checklist)   cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "thresh v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
