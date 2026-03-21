#!/usr/bin/env bash
# urea — Urea Fertilizer Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Urea Fertilizer — Overview ===

Urea (CO(NH₂)₂) is the world's most widely used nitrogen fertilizer,
providing 46% nitrogen by weight — the highest of any solid N fertilizer.

Key Facts:
  Chemical formula:   CO(NH₂)₂ (carbamide)
  Nitrogen content:   46-0-0 (46% N, 0% P₂O₅, 0% K₂O)
  Molecular weight:   60.06 g/mol
  Appearance:         White crystalline granules or prills
  Solubility:         1,080 g/L water at 20°C (very soluble)
  pH in solution:     ~7.0 (neutral)
  Melting point:      133°C (271°F)
  Bulk density:       720-780 kg/m³ (45-49 lb/ft³)

Production:
  Haber-Bosch process (ammonia) + carbon dioxide
  CO₂ + 2NH₃ → CO(NH₂)₂ + H₂O
  Global production: ~180 million tons/year
  Major producers: China, India, Russia, Indonesia
  Energy intensive: ~1.5 tons CO₂ per ton of urea produced
  Price typically: $300-600/ton (varies with natural gas prices)

Forms:
  Granular:    2-4mm particles, most common for field application
  Prilled:     1-2mm spheres, older process, more dusty
  Coated:      Polymer/sulfur coated for slow release
  Solution:    UAN (urea + ammonium nitrate in water, 28-32% N)
  SuperU:      Urea + urease/nitrification inhibitors

Advantages:
  - Highest N concentration of solid fertilizers (low transport cost)
  - Safe to handle and store (non-explosive)
  - Versatile application methods
  - Good compatibility with other fertilizers
  - Can be applied to most crops and soils

Disadvantages:
  - Ammonia volatilization loss (up to 30% if surface-applied)
  - Requires urease enzyme to convert to plant-available N
  - Biuret content can damage seed and foliage (if >1.5%)
  - Hygroscopic (absorbs moisture, cakes in storage)
  - Temporary soil pH increase around granule (NH₃ release)
EOF
}

cmd_chemistry() {
    cat << 'EOF'
=== Urea Chemistry in Soil ===

Step 1: Hydrolysis (Urea → Ammonium)
  CO(NH₂)₂ + H₂O → 2NH₃ + CO₂
  NH₃ + H₂O → NH₄⁺ + OH⁻ (ammonium)
  
  Catalyst: Urease enzyme (present in all soils)
  Speed: Complete in 2-7 days (faster in warm, moist soil)
  pH effect: Temporarily raises soil pH around granule to 9+
  This is when volatilization risk is highest

Step 2: Nitrification (Ammonium → Nitrate)
  NH₄⁺ → NO₂⁻ → NO₃⁻
  
  Stage 1: NH₄⁺ → NO₂⁻ (Nitrosomonas bacteria)
  Stage 2: NO₂⁻ → NO₃⁻ (Nitrobacter bacteria)
  
  Speed: Days to weeks depending on:
    - Temperature: Optimal 25-35°C, slow <10°C, stops <5°C
    - Moisture: Optimal 50-70% WFPS
    - pH: Optimal 6.0-8.0, inhibited below 5.5
    - Aeration: Requires oxygen (aerobic process)
  
  pH effect: Produces H⁺ (acidifying)
  Net effect of urea: Slight soil acidification over time

Plant Uptake Forms:
  NH₄⁺ (ammonium):  Taken up directly, held on soil particles (CEC)
  NO₃⁻ (nitrate):   Primary uptake form, mobile in soil water
  
  Preference: Most crops prefer mixed NH₄⁺/NO₃⁻
  Rice exception: Prefers NH₄⁺ (flooded conditions inhibit nitrification)

Nitrogen Cycle Summary:
  Urea → [hydrolysis] → NH₄⁺ → [nitrification] → NO₃⁻
                          ↑                           ↓
                   Soil fixation              Plant uptake
                   (clay, OM)                 Leaching loss
                          ↓                   Denitrification
                   Volatilization
                   (NH₃ gas loss)

Inhibitors:
  Urease inhibitors (slow hydrolysis):
    NBPT (N-(n-butyl)thiophosphoric triamide)
    Delays conversion to NH₃ by 7-14 days
    Reduces volatilization 30-70%
    Brand names: Agrotain, Limus
  
  Nitrification inhibitors (slow NO₃⁻ formation):
    DCD (dicyandiamide)
    Nitrapyrin (N-Serve)
    Keep N as NH₄⁺ longer → less leaching, less denitrification
    Duration: 4-8 weeks depending on temperature

  Enhanced efficiency fertilizers:
    SuperU = Urea + NBPT + DCD
    ESN (polymer-coated urea) = controlled release over 50-80 days
    Sulfur-coated urea (SCU) = slow release
EOF
}

cmd_application() {
    cat << 'EOF'
=== Urea Application Methods ===

Surface Broadcast:
  Method: Spread urea granules uniformly on soil surface
  Equipment: Spinner spreader, air boom, aircraft
  
  Pros:
    - Fast, covers large areas quickly
    - Low equipment cost
    - Can apply on growing crop (top-dress)
  
  Cons:
    - Highest volatilization risk (10-30% N loss)
    - Must incorporate within 48 hours if possible
    - Uneven distribution with spinner spreaders
  
  Reduce losses:
    - Apply before rain (0.25-0.5" rainfall incorporates)
    - Apply to moist soil (not dry, hot surfaces)
    - Use urease inhibitor (NBPT)
    - Avoid surface application when >50°F and windy
    - Irrigate after application if possible

Incorporation (Soil-Mixed):
  Method: Broadcast then disc/cultivate into soil (2-4")
  Or: Apply with tillage equipment
  
  Pros:
    - Virtually eliminates volatilization
    - Places N in root zone
  
  Cons:
    - Requires additional field pass
    - Not possible in no-till or growing crops
    - Additional fuel and time cost

Band Application:
  Method: Place urea in concentrated band below or beside seed
  Equipment: Fertilizer drill, strip-till applicator
  
  Types:
    Side-band:  2" to side, 2" below seed (safe)
    Mid-row:    Between every other row
    Deep band:  4-6" deep (injection)
  
  Pros:
    - Reduces volatilization (soil-covered)
    - Higher efficiency (closer to roots)
    - Less fertilizer needed (20-30% rate reduction possible)
  
  Seed placement warning:
    Never place urea IN the seed row!
    NH₃ from hydrolysis burns seedlings
    Safe distance: ≥2" from seed for most crops
    Maximum safe rate in-furrow: 5-10 lbs N/acre

Foliar Application:
  Method: Spray dissolved urea on crop leaves
  Concentration: 2-5% urea solution (20-50 g/L)
  
  Pros:
    - Rapid N uptake (hours)
    - Useful for correcting mid-season deficiency
    - Bypasses soil issues
  
  Cons:
    - Small amounts per application (5-15 lbs N/acre)
    - Leaf burn risk above 5% concentration
    - Multiple applications needed
    - Weather dependent (avoid hot, sunny conditions)
  
  Best practice: Apply early morning or late afternoon
  Max concentration: 3% for most broadleaf crops

Fertigation:
  Method: Dissolve urea in irrigation water
  Systems: Drip, sprinkler, pivot
  
  Advantage: Spoon-feeding N through season
  Rate: Match to crop growth stage needs
  Solubility: No issue (urea very water-soluble)
  Uniformity: Depends on irrigation system uniformity
  Caution: Don't mix with calcium-containing solutions (precipitation)
EOF
}

cmd_rates() {
    cat << 'EOF'
=== Crop Nitrogen Rates & Urea Calculation ===

Conversion:
  Urea is 46% N
  To calculate urea needed:
  Urea (lbs) = N needed (lbs) ÷ 0.46

  Example: Need 150 lbs N/acre
  Urea = 150 ÷ 0.46 = 326 lbs urea/acre

Crop Nitrogen Recommendations (typical ranges):

  Corn (Maize):
    Rate: 0.8-1.2 lbs N per bushel yield goal
    Example: 200 bu/acre goal × 1.0 = 200 lbs N/acre
    Urea: 200 ÷ 0.46 = 435 lbs/acre
    Timing: 1/3 at planting, 2/3 side-dress at V6-V8
    Credit: Soybeans previous crop = -40 to -50 lbs N

  Wheat (Winter):
    Rate: 1.0-1.4 lbs N per bushel yield goal
    Example: 80 bu/acre × 1.2 = 96 lbs N/acre
    Urea: 96 ÷ 0.46 = 209 lbs/acre
    Timing: 20-30 lbs N fall, remainder topdress in spring (Feekes 3-5)

  Rice (Paddy):
    Rate: 100-180 lbs N/acre (variety dependent)
    Urea: 220-390 lbs/acre
    Timing: 2/3 preflood, 1/3 at panicle initiation
    Key: Apply to dry soil, flood within 5 days (reduce loss)

  Soybeans:
    Generally: No N fertilizer needed (nitrogen fixation)
    Exception: Starter N 10-20 lbs/acre in some systems
    Inoculation more important than N fertilizer

  Cotton:
    Rate: 60-100 lbs N/acre
    Urea: 130-220 lbs/acre
    Timing: Split — 1/3 at planting, 2/3 at first square
    Over-fertilization → excessive vegetative growth

  Pasture/Hay:
    Rate: 40-80 lbs N/acre per cutting
    Urea: 87-174 lbs/acre per application
    Timing: After each harvest cut
    Annual total: 150-300 lbs N/acre

Soil Test Credit:
  Soil nitrate test (0-24"): Subtract ppm × conversion factor
  Organic matter credit: ~20 lbs N per 1% OM
  Previous crop residual N:
    After soybeans: -40 lbs N
    After alfalfa (1st year): -150 lbs N
    After alfalfa (2nd year): -75 lbs N
  Manure credit: Calculate available N from application records

Economic Optimum:
  Maximum return to N (MRTN) approach
  Diminishing returns: Last 50 lbs N contributes less yield
  Optimal rate balances: N cost vs grain price
  When corn price high and N cheap → apply more
  When corn price low and N expensive → apply less
EOF
}

cmd_losses() {
    cat << 'EOF'
=== Nitrogen Loss Pathways ===

1. Ammonia Volatilization:
   Urea → NH₃ gas escapes to atmosphere
   
   Conditions that increase volatilization:
     High temperature:     >50°F (10°C), rapid above 70°F
     High pH:              Alkaline soils (pH >7.5) worse
     Low moisture:         Dry soil surface, no rain to incorporate
     High wind:            Removes NH₃ from soil surface
     Heavy residue:        Urease enzyme concentrated in residue
     Surface application:  Not incorporated into soil
   
   Loss magnitude:
     Best case: <5% (cold, wet, incorporated)
     Typical: 10-15% (surface-applied, incorporated by rain)
     Worst case: 25-40% (hot, dry, high pH, no incorporation)
   
   Mitigation:
     - Incorporate within 48 hours (rain or tillage)
     - Use NBPT urease inhibitor (reduces loss 30-70%)
     - Apply before forecasted rain (0.25"+ within 2 days)
     - Band or inject instead of broadcast
     - Apply when temp <50°F if possible

2. Nitrate Leaching:
   NO₃⁻ moves below root zone with excess water
   
   Risk factors:
     - Sandy soils (low water-holding capacity)
     - High rainfall or over-irrigation
     - Fall/winter application (crop not actively growing)
     - Excessive N rates
   
   Environmental impact:
     - Groundwater contamination (drinking water >10 ppm NO₃-N)
     - Contributes to hypoxic zones (Gulf of Mexico dead zone)
   
   Mitigation:
     - Split applications (don't apply all N at once)
     - Nitrification inhibitors (keep N as NH₄⁺ longer)
     - Match rate to crop uptake timing
     - Avoid fall application on sandy soils

3. Denitrification:
   NO₃⁻ → N₂O → N₂ (gaseous loss)
   Occurs in waterlogged (anaerobic) conditions
   
   Risk factors:
     - Saturated soils (after heavy rain)
     - Warm temperatures (>50°F)
     - High organic matter (energy for bacteria)
     - Fine-textured soils (poor drainage)
   
   Loss: 5-25% of applied N in wet years
   N₂O: Potent greenhouse gas (298× CO₂)
   
   Mitigation:
     - Improve drainage
     - Delay N application until soil dries
     - Nitrification inhibitors

4. Crop Removal:
   Not a "loss" but important for N balance
   Corn grain: ~0.65 lbs N per bushel removed
   Wheat grain: ~1.0 lbs N per bushel removed
   Soybean grain: ~3.3 lbs N per bushel removed
   Hay: ~50 lbs N per ton removed
EOF
}

cmd_comparison() {
    cat << 'EOF'
=== Nitrogen Fertilizer Comparison ===

Product              N%    Form           Cost Index
Urea                 46    Granular       1.0×
UAN-28              28    Liquid         1.2×
UAN-32              32    Liquid         1.1×
Ammonium Nitrate    34    Granular       1.3×
Ammonium Sulfate    21    Granular       1.5×
Anhydrous Ammonia   82    Pressurized    0.7×
DAP (18-46-0)       18    Granular       N/A (P source)
MAP (11-52-0)       11    Granular       N/A (P source)

Urea (46-0-0):
  Most popular globally, easy to handle
  Main risk: volatilization when surface-applied
  Best for: broadcast, fertigation, foliar
  Storage: Keep dry (hygroscopic)

Anhydrous Ammonia (82-0-0):
  Cheapest N per pound
  Must be injected 6-8" deep under pressure
  Dangerous: toxic gas, requires certified applicators
  Best for: pre-plant, side-dress (injection)
  Equipment: Nurse tanks, applicator with knife injectors

UAN Solution (28-32%):
  Liquid blend of urea + ammonium nitrate + water
  Easy to handle and apply (sprayer or dribble)
  Can mix with herbicides (check compatibility)
  Volatilization risk moderate (half is urea-based)
  Best for: top-dress, sidedress, with herbicide

Ammonium Nitrate (34-0-0):
  Fast-acting, low volatilization risk
  Regulated: explosive potential (ANFO)
  Banned for retail sale in some regions post-Oklahoma City
  Best for: top-dress, immediate availability
  Acidifying: produces H⁺ during nitrification

Ammonium Sulfate (21-0-0-24S):
  Provides both nitrogen AND sulfur
  Low volatilization risk (acidic reaction)
  Good for S-deficient soils
  Lower N content → more product to haul
  Best for: crops needing sulfur (canola, alfalfa, corn)

Controlled-Release Products:
  ESN (polymer-coated urea): 44% N, releases over 50-80 days
  SCU (sulfur-coated urea): 36-38% N, releases over 30-60 days
  Cost: 1.5-2.0× urea, but reduce losses significantly
  Best for: single-application systems, high-loss environments

Cost Comparison (per lb of N):
  Calculate: Price per ton ÷ (2000 × %N)
  Example: Urea at $500/ton = $500 ÷ (2000 × 0.46) = $0.54/lb N
  Example: NH₃ at $600/ton = $600 ÷ (2000 × 0.82) = $0.37/lb N
  Always compare cost per pound of actual nitrogen!
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Urea Application Scenarios ===

--- Corn Side-Dress Calculation ---
Goal: 180 lbs N/acre total for 180 bu/acre corn
Already applied: 50 lbs N/acre as starter (DAP at planting)
Remaining: 180 - 50 = 130 lbs N/acre needed
Urea: 130 ÷ 0.46 = 283 lbs urea/acre
Application: Side-dress at V6 stage, band 3" deep
Timing: When corn is 18-24 inches tall
Equipment: Coulter applicator or hopper side-dress rig

--- Winter Wheat Top-Dress ---
Goal: 100 lbs N/acre for 75 bu/acre wheat
Fall-applied: 25 lbs N/acre (at planting)
Spring top-dress: 75 lbs N/acre
Urea: 75 ÷ 0.46 = 163 lbs urea/acre
Timing: Late February/early March (Feekes 3-4, greenup)
Method: Broadcast with spinner spreader
Risk: Surface volatilization — apply before rain forecast
Tip: Use NBPT-treated urea if rain unlikely within 48 hours
Cost of NBPT: ~$3-5/acre (cheap insurance vs 15% N loss)

--- Pasture Application ---
Goal: 50 lbs N/acre per application, 4 cuttings/year
Per application: 50 ÷ 0.46 = 109 lbs urea/acre
Annual total: 436 lbs urea/acre (200 lbs N/acre)
Timing: After each hay cutting, when regrowth starts
Method: Broadcast after hay removal
Important: Don't apply to wet foliage (leaf burn)
Water: Need 0.5"+ rain within 3 days for incorporation

--- Rice Paddy Urea Management ---
Goal: 150 lbs N/acre
Pre-flood application: 100 lbs N/acre = 217 lbs urea/acre
  1. Drain paddy to dry soil surface
  2. Broadcast urea onto dry soil
  3. Flood within 3-5 days (critical — reduces volatilization 80%)
  4. Maintain 2-4" flood depth

Panicle initiation: 50 lbs N/acre = 109 lbs urea/acre
  Apply into floodwater at panicle differentiation stage

--- Volatilization Loss Estimate ---
Scenario: 200 lbs N/acre surface-broadcast on warm day
Conditions: 80°F, pH 7.8, dry, no rain for 5 days
Estimated loss: 25% of applied N
N lost: 200 × 0.25 = 50 lbs N/acre
Dollar impact: 50 × $0.55/lb N = $27.50/acre
On 1,000 acres = $27,500 lost

With NBPT inhibitor:
Cost: $4.00/acre
Loss reduced to: 8% = 16 lbs N/acre lost
Savings: (50 - 16) × $0.55 = $18.70/acre saved
Net benefit: $18.70 - $4.00 = $14.70/acre profit
ROI: 367% — always use inhibitor for surface application!
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Urea Application Planning Checklist ===

Rate Determination:
  [ ] Soil test reviewed (residual N, OM, pH)
  [ ] Yield goal established for the field
  [ ] Crop N recommendation looked up
  [ ] Previous crop N credit applied
  [ ] Manure N credit calculated (if applicable)
  [ ] Irrigation water N credit (if applicable)
  [ ] Final N rate determined
  [ ] Urea amount calculated (N ÷ 0.46)

Timing:
  [ ] Crop growth stage appropriate for application
  [ ] Weather forecast checked (rain within 48 hours?)
  [ ] Soil temperature considered (<50°F reduces volatilization)
  [ ] Wind conditions acceptable (low wind preferred)
  [ ] Split application schedule planned (if applicable)
  [ ] Avoid applying before extended dry period

Application Method:
  [ ] Method selected (broadcast, band, inject, foliar)
  [ ] Equipment calibrated for correct rate
  [ ] Spreader pattern checked (overlap, uniformity)
  [ ] Incorporation plan in place (if surface broadcast)
  [ ] NBPT urease inhibitor considered (surface application)
  [ ] Seed-safe distance maintained (if banding)

Product Quality:
  [ ] Urea stored dry and covered
  [ ] No caking or excessive moisture
  [ ] Biuret content <1.0% (especially for foliar/seed-placed)
  [ ] Granule size uniform (spreading pattern)
  [ ] Not mixed with incompatible products

Environmental:
  [ ] Buffer from waterways maintained (state regulations)
  [ ] No application to frozen or saturated soil
  [ ] Nitrate leaching risk assessed (sandy soils, high water table)
  [ ] Application rate within agronomic recommendation
  [ ] Records maintained for nutrient management plan
  [ ] 4R Stewardship: Right source, rate, time, place

Post-Application:
  [ ] Confirm incorporation occurred (rain, irrigation, tillage)
  [ ] Monitor crop for N deficiency symptoms (yellowing)
  [ ] Tissue test at appropriate growth stage
  [ ] Document application (date, rate, method, conditions)
  [ ] Evaluate results at harvest (yield vs N applied)
EOF
}

show_help() {
    cat << EOF
urea v$VERSION — Urea Fertilizer Reference

Usage: script.sh <command>

Commands:
  intro        Urea overview — chemistry, production, forms
  chemistry    Soil chemistry — hydrolysis, nitrification, N cycle
  application  Application methods — broadcast, band, foliar
  rates        Crop-specific N rates and urea calculation
  losses       N loss pathways — volatilization, leaching
  comparison   Nitrogen fertilizer source comparison
  examples     Application scenarios and calculations
  checklist    Application planning checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    chemistry)  cmd_chemistry ;;
    application) cmd_application ;;
    rates)      cmd_rates ;;
    losses)     cmd_losses ;;
    comparison) cmd_comparison ;;
    examples)   cmd_examples ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "urea v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
