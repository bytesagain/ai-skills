#!/usr/bin/env bash
# silo — Grain Storage Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Grain Silo Storage ===

A silo is a structure for storing bulk agricultural materials,
primarily grain, but also silage, cement, coal, and other commodities.

Silo Types:

  Steel Bin (Corrugated):
    Most common farm and commercial storage
    Capacity: 1,000 - 1,000,000+ bushels
    Diameters: 15-156 feet
    Galvanized steel walls, concrete floor
    Easy to add aeration and monitoring systems

  Concrete Silo (Slip-Form):
    Tall cylindrical towers, very durable
    Capacity: 20,000 - 200,000+ bushels
    Best for: long-term storage, commercial operations
    50+ year lifespan, excellent hermetic potential

  Flat Storage (Warehouse):
    Steel or concrete buildings with flat floors
    Capacity: virtually unlimited
    Flexible — store different commodities in sections
    Requires: good aeration, conveyor systems for filling/emptying

  Hopper Bottom Bin:
    Cone-shaped bottom for gravity unloading
    No need for sweep auger
    More expensive than flat-bottom
    Best for: frequent loading/unloading, feed operations

  Grain Bag (Silo Bag):
    Polyethylene tubes, 200-500 feet long
    Capacity: 6,000-12,000 bushels per bag
    Temporary storage (1-2 seasons)
    Low cost, no infrastructure needed
    Hermetic when sealed properly

Grain Storage Principles:
  1. Store dry grain (below safe moisture content)
  2. Store cool grain (below 60°F / 15°C ideal)
  3. Store clean grain (remove fines and foreign material)
  4. Monitor regularly (temperature, moisture, insects)
  5. Maintain aeration systems (fans, ducts, controls)

Storage Duration Guidelines:
  Grain condition        Corn safe storage (months)
  14% MC, 50°F          12-18
  14% MC, 70°F          6-9
  15% MC, 50°F          6-9
  15% MC, 70°F          3-4
  16% MC, 70°F          1-2

  MC = Moisture Content
  Lower temperature + lower moisture = longer safe storage
EOF
}

cmd_moisture() {
    cat << 'EOF'
=== Grain Moisture Management ===

--- Safe Storage Moisture Content ---
  Crop            Short-term (<6 mo)  Long-term (>6 mo)
  Corn/Maize      15.5%               13.0%
  Soybeans        14.0%               11.0%
  Wheat           14.0%               12.0%
  Rice (rough)    14.0%               12.0%
  Barley          14.0%               12.0%
  Sorghum         14.0%               12.0%
  Sunflower       10.0%               8.0%
  Canola/Rapeseed 10.0%               8.0%

--- Equilibrium Moisture Content (EMC) ---
  Grain naturally absorbs or releases moisture to reach
  equilibrium with surrounding air.

  At 60°F (15°C):
    Relative Humidity    Corn EMC    Wheat EMC
    30%                  8.5%        8.0%
    50%                  11.5%       11.0%
    60%                  13.0%       12.5%
    65%                  14.0%       13.5%
    70%                  15.0%       14.5%
    80%                  18.0%       17.0%

  Rule: to dry grain, blow air with RH below the target EMC
  To maintain grain, blow air with RH at or slightly below current MC

--- Drying Methods ---
  High-Temperature Dryer:
    Tower, cross-flow, or mixed-flow dryer
    180-230°F (82-110°C) air temperature
    Removes 5-10 percentage points of moisture
    Fast: 1-2 hours per batch
    Cost: $0.03-0.06 per bushel per point removed (natural gas)

  Low-Temperature / In-Bin Drying:
    Uses aeration fans with supplemental heat (10-20°F rise)
    Removes 2-5 percentage points over weeks
    Slower but gentler on grain quality
    Fan requirement: 1-2 CFM per bushel

  Natural Air Drying:
    Uses aeration fans without heat
    Works when ambient air is dry enough
    Fill depth limited: 12-18 feet max for corn
    Fan requirement: 1.5-3 CFM per bushel
    Season-dependent: best in fall with cool, dry air

  Combination Drying:
    Dry to 17-18% in high-temp dryer
    Finish to 13-14% with in-bin aeration
    Saves energy while maintaining throughput

--- Moisture Testing ---
  Capacitance meter (portable): ±0.5% accuracy, instant
  Oven method (ASAE S352): reference standard, 72 hours
  NIRS (Near Infrared): fast, accurate, expensive
  Test weight: correlates inversely with moisture (heavier = drier)
  Sample properly: take samples from multiple locations and depths
EOF
}

cmd_aeration() {
    cat << 'EOF'
=== Grain Aeration Systems ===

Purpose: move air through grain mass to maintain temperature
and moisture uniformity, NOT to dry grain (that requires much more airflow).

--- Aeration Airflow Rates ---
  Maintenance aeration:   0.1-0.25 CFM/bushel
  Cooling (temperature management): 0.5-1.0 CFM/bushel
  In-bin drying:          1.0-3.0 CFM/bushel
  CFM = Cubic Feet per Minute

--- Fan Sizing ---
  Total CFM needed = bushels × desired CFM/bu
  Example: 50,000 bu bin × 0.2 CFM/bu = 10,000 CFM fan

  Static pressure: depends on grain depth and type
    Corn, 20 ft depth:    ~2.5 inches water column (IWC)
    Wheat, 20 ft depth:   ~4.0 IWC (smaller kernels = more resistance)

  Select fan from manufacturer's performance chart:
    Fan must deliver target CFM at calculated static pressure

--- Airflow Direction ---
  Upward (pressure):
    Air pushed up through grain from perforated floor
    Advantages: easier to observe exhaust, better for cooling
    Disadvantages: moisture accumulates at top, condensation on roof

  Downward (suction):
    Air pulled down through grain
    Advantages: moisture driven toward perforated floor (away from grain mass)
    Disadvantages: harder to monitor, fan handles warm moist air

  Best practice: push UP in fall (cool grain from bottom),
                 pull DOWN in spring (prevent condensation at top)

--- Cooling Strategy ---
  Goal: cool grain to 35-40°F (2-4°C) for winter storage

  Step 1 (early fall):
    Cool from harvest temp (~90°F) to 60°F
    Run fans during cool nights (50-55°F ambient)
    Run time: 100-200 hours for full cooling front

  Step 2 (late fall):
    Cool from 60°F to 40°F
    Run fans when ambient is 35-40°F
    Run time: 100-150 hours

  Step 3 (spring):
    Warm from 40°F to 50-60°F to prevent condensation
    Run when ambient is 50-60°F
    Do NOT let grain stay cold while ambient warms

  Cooling front: zone of temperature change moving through grain
  At 0.2 CFM/bu, cooling front takes ~200 hours to pass through

--- Duct Design ---
  Perforated floor: most uniform airflow, best for round bins
  Surface area: at least 1 ft² per 1,000 CFM
  Duct spacing: 50% of grain depth (e.g., 20 ft grain → 10 ft spacing)
  Perforated area: 10% minimum of duct surface area
  Transition duct: connect round fan outlet to flat floor duct
EOF
}

cmd_pests() {
    cat << 'EOF'
=== Stored Grain Pests ===

--- Primary Insects (attack whole kernels) ---

  Rice Weevil (Sitophilus oryzae):
    Adult: 2-3mm, reddish-brown, snout
    Damage: female bores into kernel, lays egg inside
    Optimal: 80°F (27°C), 70% RH
    Key fact: can fly, infests grain in the field

  Lesser Grain Borer (Rhyzopertha dominica):
    Adult: 2-3mm, dark brown, cylindrical
    Damage: bores through kernels, produces distinctive flour dust
    One of the most destructive stored grain insects
    Optimal: 90°F (32°C)

  Granary Weevil (Sitophilus granarius):
    Similar to rice weevil but cannot fly
    Exclusively a stored grain pest (not field)
    Optimal: 80°F (27°C)

--- Secondary Insects (feed on damaged grain, dust, fungi) ---

  Indian Meal Moth (Plodia interpunctella):
    Larvae spin silken webbing over grain surface
    Adult moth: 10mm wingspan, copper-colored outer wings
    Indicator of grain surface problems

  Red Flour Beetle (Tribolium castaneum):
    3-4mm, reddish-brown, flat
    Cannot penetrate whole kernels
    Feeds on broken kernels, dust, fungi
    Indicator of fines and foreign material

  Sawtoothed Grain Beetle (Oryzaephilus surinamensis):
    2.5-3mm, brown, saw-toothed thorax
    Secondary feeder on broken kernels and grain dust

--- Fungi ---
  Aspergillus species: grow at 13-18% MC, produce aflatoxins
  Penicillium species: grow at 16-20% MC, musty odor
  Fusarium species: field fungi, need >20% MC
  Prevention: keep grain dry (<13% MC) and cool (<60°F)

--- Rodents ---
  Mice consume 3g grain/day, contaminate 10× what they eat
  Rats consume 25g/day, contaminate much more
  Prevention: seal entry points >6mm, bait stations around perimeter

--- Control Methods ---
  Temperature: below 60°F stops reproduction, below 40°F kills slowly
  Aeration: cooling is the first line of defense
  Sanitation: clean bins thoroughly between fills
  Grain protectants: apply to grain as it enters bin
  Fumigation: kills all life stages (see fumigation command)
  Diatomaceous earth: damages insect exoskeleton (organic option)
EOF
}

cmd_fumigation() {
    cat << 'EOF'
=== Grain Fumigation ===

Fumigation uses toxic gas to kill all life stages of insects
(eggs, larvae, pupae, adults) in stored grain.

--- Phosphine (Aluminum Phosphide) ---
  Most common grain fumigant worldwide
  Products: Phostoxin, Fumitoxin, Degesch Plates
  
  Chemistry: AlP + moisture → PH₃ (phosphine gas)
  Toxic concentration: 200 ppm for 96 hours minimum
  Lethal dose (human): 0.5 ppm TLV-TWA
  
  Application:
    Tablet form: distribute through grain during filling
    Plates: placed on grain surface in sealed bin
    Dose: 180 tablets per 1,000 bushels (typical)
    
  Requirements:
    Temperature: >60°F (15°C) — gas doesn't work well when cold
    Seal: bin must be gas-tight (cover vents, seal doors)
    Exposure time: minimum 3-5 days at >60°F
                   7-10 days at 50-60°F
    Aeration: ventilate for 48 hours after treatment
    
  Safety:
    EXTREMELY TOXIC — restricted use pesticide
    Certified applicator required in most jurisdictions
    PH₃ detector required during and after application
    Corrosive to copper, brass, silver, gold (electronics!)
    Remove all electronics/sensors before fumigating
    Post warning placards on all entrances

--- Heat Treatment ---
  Alternative to chemical fumigation
  Heat grain to 130-140°F (54-60°C) for 1-6 hours
  Kills all insect life stages
  Energy-intensive but no chemical residue
  Used in: flour mills, organic grain operations

--- Hermetic Storage ---
  Seal grain in airtight container
  Insects consume O₂, produce CO₂
  When O₂ drops below 2%, insects die
  Time required: 2-4 weeks depending on insect population
  Used in: grain bags (hermetic), sealed silos
  No chemicals needed — approved for organic

--- CO₂ Fumigation ---
  Flood sealed bin with CO₂ to displace oxygen
  Concentration: >60% CO₂ for 10-14 days
  More expensive than phosphine
  Advantages: no chemical residue, no corrosion
  Used in: organic storage, museum collections, food grade

--- Fumigation Checklist ---
  [ ] Bin sealed (vents, fans, doors, eaves)
  [ ] Temperature >60°F throughout grain mass
  [ ] Insect identification confirms species present
  [ ] Correct dose calculated for bin volume
  [ ] Applicator has required certification
  [ ] PH₃ detection equipment calibrated
  [ ] Warning placards posted
  [ ] Re-entry plan established (48hr aeration minimum)
  [ ] Residue tablets/plates removed after treatment
  [ ] Post-fumigation sampling to verify insect kill
EOF
}

cmd_capacity() {
    cat << 'EOF'
=== Silo Capacity Calculations ===

--- Round Bin Capacity ---
  Volume (ft³) = π × r² × h
  Where: r = radius in feet, h = grain depth in feet

  Bushels = Volume (ft³) ÷ 1.2444
  (1 bushel = 1.2444 cubic feet)

  Example: 36 ft diameter × 24 ft eave height
    r = 18 ft
    Volume = 3.14159 × 18² × 24 = 24,429 ft³
    Bushels = 24,429 ÷ 1.2444 = 19,632 bushels

  With peaked grain (cone on top):
    Cone volume = (π × r² × cone height) ÷ 3
    Typical peak angle: 15-20° (angle of repose for corn)
    Add cone volume to cylinder volume

--- Flat Storage Capacity ---
  Rectangular: L × W × H ÷ 1.2444 = bushels
  With peaked center:
    Volume = base area × (wall height + peak height/3)

--- Metric Conversions ---
  1 bushel (corn) = 25.4 kg at standard test weight
  1 bushel (wheat) = 27.2 kg at standard test weight
  1 metric ton corn = 39.37 bushels
  1 metric ton wheat = 36.74 bushels
  1 cubic meter = 35.314 cubic feet

--- Test Weight (Bulk Density) ---
  Standard test weights per bushel:
    Corn:       56 lbs (25.4 kg)
    Wheat:      60 lbs (27.2 kg)
    Soybeans:   60 lbs (27.2 kg)
    Barley:     48 lbs (21.8 kg)
    Oats:       32 lbs (14.5 kg)
    Sorghum:    56 lbs (25.4 kg)
    Rice:       45 lbs (20.4 kg)
    Sunflower:  30 lbs (13.6 kg)

  Actual test weight varies:
    Higher = better quality grain
    Low test weight = more fines, immature kernels, more air space

--- Weight of Grain on Bin Floor ---
  Important for structural design!
  Corn at 56 lb/bu = 45 lbs/ft³
  Wheat at 60 lb/bu = 48 lbs/ft³

  Example: 36 ft bin, 24 ft deep with corn
    19,632 bu × 56 lbs = 1,099,392 lbs = 550 tons on the floor
    Floor area = π × 18² = 1,018 ft²
    Floor load = 1,080 lbs/ft² (about 53 kPa)
    Foundation must be designed for this load + safety factor
EOF
}

cmd_safety() {
    cat << 'EOF'
=== Silo Safety ===

Grain bins are among the most dangerous environments in agriculture.
On average, 25+ entrapment fatalities per year in the US alone.

--- Grain Engulfment ---
  The #1 silo killer. Flowing grain acts like quicksand.

  How it happens:
    Standing on grain while unloading from below
    Walking on grain that has crusted over a void
    Grain avalanche from sidewall buildup

  Speed: grain can engulf a person in 4-5 seconds
  Force: impossible to self-rescue once buried to waist
         (grain exerts 300+ lbs of force on a buried person)

  Prevention:
    NEVER enter a bin while grain is being moved
    NEVER enter a bin alone
    Use body harness with lifeline attached OUTSIDE the bin
    Use lockout/tagout on all unloading equipment
    Test for oxygen, toxic gases before entry (see below)
    Have trained rescue team and equipment ready

--- Confined Space Hazards ---
  A grain bin IS a permit-required confined space (OSHA).

  Atmospheric hazards:
    Oxygen deficiency: grain respiration + insect activity consume O₂
      Normal O₂: 20.9%
      OSHA minimum: 19.5%
      Death: below 16%

    Carbon dioxide (CO₂): produced by grain/insect respiration
      Normal: 0.04%
      Dangerous: above 3%
      Lethal: above 10%

    Phosphine (PH₃): from fumigation or natural decomposition
      Lethal: above 50 ppm
      TLV: 0.3 ppm (8-hour)

    Nitrogen dioxide (NO₂): from fermentation of high-moisture grain
      Silo gas — forms within hours of filling
      Lethal: above 100 ppm
      Most dangerous in first 3 weeks after filling

  Testing: 4-gas monitor required (O₂, CO, H₂S, LEL)
           PH₃ monitor if fumigation occurred

--- Dust Explosion ---
  Grain dust is explosive at concentrations of 40-70 g/m³
  Dust explosion pentagon: Fuel + O₂ + Ignition + Dispersion + Confinement

  Prevention:
    Housekeeping: keep dust accumulation below 1/8 inch (3mm)
    Ventilation: dust collection systems at transfer points
    Ignition control: no smoking, ground all equipment, maintain bearings
    Explosion venting: relief panels on bin roof and legs
    Explosion suppression: chemical suppression systems (commercial)

  Ignition sources:
    Hot bearings (conveyors, legs)
    Welding/cutting near grain dust
    Electrical arcing
    Static discharge
    Friction (belt slippage)

--- Structural Collapse ---
  Causes: corrosion, overloading, foundation failure, wind
  Prevention: annual structural inspection, proper loading procedures
  Never exceed rated capacity, monitor wall condition

--- Safety Checklist Before Entry ---
  [ ] All grain-moving equipment locked out and tagged out
  [ ] Atmospheric testing completed (O₂, CO₂, PH₃, LEL)
  [ ] Entry permit signed
  [ ] Attendant stationed at bin opening
  [ ] Entrant wearing body harness with attached lifeline
  [ ] Rescue equipment ready (tripod, winch, trained team)
  [ ] Communication established between entrant and attendant
  [ ] Emergency services notified of planned entry
EOF
}

cmd_quality() {
    cat << 'EOF'
=== Grain Quality Assessment ===

--- USDA Grading Factors (Corn Example) ---

  Grade    Test Weight  Broken/Foreign  Damaged  Heat Damaged
  US #1    56.0 lb/bu   2.0%            3.0%     0.1%
  US #2    54.0 lb/bu   3.0%            5.0%     0.2%
  US #3    52.0 lb/bu   4.0%            7.0%     0.5%
  US #4    49.0 lb/bu   5.0%            10.0%    1.0%
  US #5    46.0 lb/bu   7.0%            15.0%    3.0%
  Sample   Below #5     Above #5        Above #5  Above #5

  Each load graded on WORST factor (one bad factor = lower grade)

--- Quality Indicators ---

  Test Weight (Bulk Density):
    Higher = better quality, more starch, less air space
    Affected by: moisture, maturity, variety, drying damage
    Measured with: Winchester bushel cup (standard container)

  Moisture Content:
    Primary factor determining storability and price
    Corn marketed at 15.0% (discounts above, premiums below)
    Measured with: capacitance meter, NIR, oven

  Damaged Kernels:
    Total damaged: insect, mold, heat, sprout, frost, weather
    Heat damaged: specifically from dryer or storage heating
    Stress cracks: from rapid drying (internal fissures)

  Broken Corn and Foreign Material (BCFM):
    Broken pieces + non-corn material (cob, stalk, weed seeds)
    Increases spoilage risk (fines hold moisture, block airflow)
    Clean grain stores better — aim for <2% BCFM

  Mycotoxins:
    Aflatoxin (Aspergillus): FDA limit 20 ppb
    Fumonisin (Fusarium): FDA guidance 2-4 ppm
    Vomitoxin/DON (Fusarium): FDA advisory 1-5 ppm
    Tested by: ELISA strip test (field), HPLC (lab)

--- Sampling Protocol ---
  Incoming grain:
    Probe truck at 5+ locations per load
    Composite sample for testing
    Retain reference sample (labeled, sealed)

  Stored grain:
    Sample every 2 weeks in warm weather
    Monthly in cool weather
    Use grain probe: sample at multiple depths
    Temperature cables: read weekly (rising temp = problem)

--- Deterioration Signs ---
  Musty or sour smell → fungal growth, spoilage
  Crusting on surface → moisture migration, condensation
  Hot spots (>10°F above average) → insect activity or mold
  Visible insects or webbing → active infestation
  Discoloration → weathering, mold, heat damage
  Sprouting → excessive moisture
  Clumping → moisture + fungal binding
  CO₂ > 0.05% in headspace → active biological activity
EOF
}

show_help() {
    cat << EOF
silo v$VERSION — Grain Storage Reference

Usage: script.sh <command>

Commands:
  intro        Grain silo types and storage principles
  moisture     Moisture management and drying methods
  aeration     Aeration systems and cooling strategies
  pests        Stored grain insects, fungi, and rodents
  fumigation   Fumigation procedures and safety protocols
  capacity     Storage capacity calculations and conversions
  safety       Silo safety: engulfment, confined space, explosions
  quality      Grain grading, sampling, and quality indicators
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    moisture)    cmd_moisture ;;
    aeration)    cmd_aeration ;;
    pests)       cmd_pests ;;
    fumigation)  cmd_fumigation ;;
    capacity)    cmd_capacity ;;
    safety)      cmd_safety ;;
    quality)     cmd_quality ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "silo v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
