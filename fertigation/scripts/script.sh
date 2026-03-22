#!/usr/bin/env bash
# fertigation — Fertigation Systems Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Fertigation ===

Fertigation is the injection of fertilizers and soil amendments into
an irrigation system, delivering nutrients directly to the root zone
with irrigation water.

Advantages Over Broadcast Fertilization:
  Nutrient efficiency    +30-50% uptake (nutrients delivered to roots)
  Water savings          Precise delivery, less runoff and leaching
  Labor reduction        Automated application, no spreading equipment
  Flexibility            Adjust nutrients daily based on crop stage
  Uniformity             Even distribution if irrigation is uniform
  Reduced compaction     No tractor passes through the field

System Components:
  Water Source → Filter → Injection Point → Distribution → Emitters

  1. Water Source
     Well, reservoir, canal, municipal supply
     Water quality affects fertigation (pH, alkalinity, dissolved minerals)

  2. Filtration
     Sand media filter:     removes organic matter (100-200 mesh)
     Disc filter:           removes particles (120-200 mesh)
     Screen filter:         basic particle removal (80-150 mesh)
     Always filter BEFORE injection point to protect injector
     Always filter AFTER injection if precipitates are possible

  3. Injection Equipment
     Venturi injector, diaphragm pump, piston pump, proportional doser
     (see 'methods' command for details)

  4. Distribution System
     Drip tape/tubing:   most common for fertigation
     Micro-sprinklers:   good for tree crops
     Center pivot:       large-scale field crops
     Sprinkler:          possible but less efficient

  5. Control System
     Timer-based:       simple, fixed schedule
     Sensor-based:      EC/pH sensors drive injection rate
     Computer-controlled: most precise, logs everything

Key Terms:
  EC    Electrical Conductivity — measures total dissolved salts (dS/m or mS/cm)
  ppm   Parts per million — concentration of specific nutrient
  pH    Acidity/alkalinity of solution (target: 5.5-6.5 for most crops)
  Stock Solution   Concentrated fertilizer mix for injection
EOF
}

cmd_methods() {
    cat << 'EOF'
=== Fertigation Injection Methods ===

--- Venturi Injector ---
  How: Water flows through a constriction, creating suction
       that draws concentrate from a tank
  Cost: $20-200 (cheapest option)
  Pros: No electricity needed, simple, reliable
  Cons: Creates 15-30% pressure drop, variable injection rate
        Rate changes with pressure/flow fluctuations
  Best for: small farms, gravity-fed systems, backup injection
  Sizing: match to system flow rate (GPM rating)

--- Diaphragm Pump (Positive Displacement) ---
  How: Electric motor drives diaphragm, pumps fixed volume per stroke
  Cost: $500-3,000
  Pros: Constant injection rate regardless of system pressure
        Precise dosing, handles concentrated solutions
  Cons: Requires electricity, moving parts wear out
        Chemical compatibility of diaphragm material
  Best for: medium operations, acidification, precise nutrient programs
  Materials: Viton (acids), EPDM (general), Teflon (aggressive chemicals)

--- Piston Pump ---
  How: Motor-driven piston delivers precise volume per stroke
  Cost: $1,000-10,000
  Pros: Very precise, handles high pressures, durable
  Cons: Expensive, requires maintenance, crystallization risk
  Best for: large operations, high-pressure systems

--- Proportional Doser ---
  How: Water flow drives injection mechanism proportionally
       Fixed ratio (e.g., 1:100, 1:200) regardless of flow rate
  Cost: $200-2,000
  Pros: No electricity, self-adjusting to flow, consistent concentration
  Cons: Ratio is fixed (or manually adjustable), limited flow range
  Best for: greenhouse, nursery, consistent dilution ratio operations
  Example: Dosatron, MixRite

--- Injection Point Location ---
  Rule: inject AFTER the pump, AFTER the main filter
  If using acid + fertilizer: separate injection points
    (acid first, then fertilizer downstream)
  Minimum distance between injection points: 10× pipe diameter
  Check valve required between tank and injection point
    (prevents irrigation water backflowing into tank)

--- Anti-Siphon / Backflow Prevention ---
  MANDATORY — prevents fertilizer from contaminating water supply
  Types:
    Air gap:            physical gap between supply and tank
    Check valve:        one-way flow device
    Reduced pressure backflow preventer: most reliable
  Required by law in most jurisdictions
EOF
}

cmd_nutrients() {
    cat << 'EOF'
=== Fertigation Nutrient Sources ===

--- Nitrogen (N) Sources ---
  Calcium Nitrate Ca(NO3)2:    15.5-0-0 + 19% Ca
    Most common fertigation N source, fully soluble
    Alkaline reaction, raises pH slightly
    ⚠ Do NOT mix with sulfate or phosphate fertilizers (precipitates)

  Potassium Nitrate KNO3:      13-0-44
    Dual-purpose N + K, fully soluble
    Clean, no residue

  Ammonium Nitrate NH4NO3:     34-0-0
    Highly soluble, acidifying effect
    Security concerns (explosive), restricted in some areas

  UAN (Urea Ammonium Nitrate): 32-0-0
    Liquid, convenient, widely available
    ⚠ Biuret content can damage through drip systems

  Ammonium Sulfate (NH4)2SO4:  21-0-0 + 24% S
    Strongly acidifying, good for high-pH soils
    Lower solubility — prepare dilute stock solutions

--- Phosphorus (P) Sources ---
  Phosphoric Acid H3PO4:       0-52-0
    Dual purpose: P fertilizer + pH control (acidification)
    Excellent for drip — helps prevent calcium carbonate clogging
    ⚠ Corrosive — handle with care

  MAP (Mono-Ammonium Phosphate): 12-61-0
    Highly soluble, slight acidifying effect
    ⚠ Do NOT mix with calcium fertilizers (precipitates)

--- Potassium (K) Sources ---
  Potassium Chloride KCl:      0-0-60
    Cheapest K source, good solubility
    ⚠ Chloride-sensitive crops: avoid (strawberry, lettuce, beans)

  Potassium Sulfate K2SO4:     0-0-50 + 18% S
    For chloride-sensitive crops
    Lower solubility — dissolve in warm water

  Potassium Nitrate KNO3:      13-0-44
    Premium source, no chloride, fully soluble

--- Compatibility Chart ---
  ✓ Compatible    ✗ Precipitates    ⚠ Mix with caution

              Ca(NO3)2  KNO3   MAP    KCl   K2SO4  MgSO4
  Ca(NO3)2      -        ✓     ✗      ✓      ✗      ✗
  KNO3          ✓        -     ✓      ✓      ✓      ✓
  MAP           ✗        ✓     -      ✓      ✓      ✓
  KCl           ✓        ✓     ✓      -      ✓      ✓
  K2SO4         ✗        ✓     ✓      ✓      -      ✓
  MgSO4         ✗        ✓     ✓      ✓      ✓      -

  KEY RULE: Never mix calcium with sulfate or phosphate in same tank!
  Use two stock tanks: Tank A (calcium) and Tank B (phosphate/sulfate)
EOF
}

cmd_scheduling() {
    cat << 'EOF'
=== Fertigation Scheduling ===

--- General Crop Stage Nutrient Ratios (N:P:K) ---

  Seedling/Transplant:     1 : 2 : 1
    High P for root development
    Low total concentration (EC 0.5-1.0 dS/m)

  Vegetative Growth:       3 : 1 : 2
    High N for leaf and stem growth
    Moderate EC (1.5-2.5 dS/m)

  Flowering/Fruit Set:     1 : 1 : 3
    Reduce N, increase K for fruit quality
    P for flower development
    EC 2.0-3.0 dS/m

  Fruiting/Maturation:     1 : 0.5 : 4
    High K for fruit sizing and quality
    Low N to prevent excessive vegetative growth
    Add Ca for fruit firmness (tomato, pepper)

  Late Season/Harvest:     0 : 0 : 1
    Reduce or stop N 2-4 weeks before harvest
    K only for final quality

--- Frequency Guidelines ---
  Sandy soil:     fertigate every irrigation (frequent, low concentration)
  Loam soil:      fertigate 2-3× per week
  Clay soil:      fertigate 1-2× per week (higher concentration)
  Hydroponics:    continuous fertigation
  Container/pot:  every irrigation

--- Pulse Fertigation ---
  Most efficient method for drip systems:
    Phase 1: Water only (5-10 min to wet soil)
    Phase 2: Fertigation (inject nutrients with water)
    Phase 3: Water only (5-10 min to flush lines and push nutrients into root zone)

  This prevents fertilizer from sitting in lines and clogging emitters.
  Also pushes nutrients below surface where roots are.

--- Seasonal Adjustments ---
  Summer/hot:     increase frequency, decrease concentration
                  (more water needed, same nutrients per day)
  Winter/cool:    decrease frequency, increase concentration
                  (less water, same nutrients)
  Rain events:    skip fertigation, check soil EC
  Drought:        water first, then fertigate (never on dry soil)
EOF
}

cmd_calculations() {
    cat << 'EOF'
=== Fertigation Calculations ===

--- PPM from Fertilizer Weight ---
  ppm = (fertilizer weight in mg) / (water volume in liters)
  ppm = (fertilizer weight in grams × 1,000,000) / (water volume in liters × 1,000,000)

  Example: Dissolve 100g KNO3 (13-0-44) in 1000L water
    N = 100g × 0.13 = 13g N in 1000L = 13 ppm N
    K₂O = 100g × 0.44 = 44g K₂O = 44 ppm K₂O
    K = 44 × 0.83 = 36.5 ppm K (elemental)

--- Stock Solution Concentration ---
  Common dilution ratios:
    1:100   → 1 liter concentrate per 100 liters water
    1:200   → 1 liter concentrate per 200 liters water

  To achieve 150 ppm N from 1:100 dilution:
    Need 150 ppm in final solution
    Stock must be 100× concentrated = 15,000 ppm N
    Using calcium nitrate (15.5% N):
    15,000 ppm ÷ 155,000 ppm per g/L = 0.097 g/mL
    = 97 grams per liter of stock solution

--- Injection Rate ---
  Injection rate (L/hr) = System flow (L/hr) × Desired concentration (ppm)
                          ÷ Stock concentration (ppm)

  Example: 5000 L/hr system, want 100 ppm N, stock = 50,000 ppm N
    Rate = 5000 × 100 / 50,000 = 10 L/hr injection rate

--- EC Estimation ---
  Rule of thumb: 1 dS/m EC ≈ 640-700 ppm total dissolved salts
  For fertilizer solutions: EC increase ≈ 0.001 per ppm of nutrients

  Target EC by crop (in irrigation water):
    Lettuce, strawberry:      1.0-1.5 dS/m
    Tomato, pepper, cucumber: 2.0-3.5 dS/m
    Rose, gerbera:            1.5-2.5 dS/m

--- Water Quality Adjustment ---
  Source water EC 0.5 dS/m → only add 1.0-2.5 dS/m from fertilizer
  Source water EC 1.5 dS/m → analyze composition, credit existing nutrients
  High bicarbonate water (>3 meq/L) → add acid to lower pH and alkalinity
  Acid injection rate: determined by titration of source water
EOF
}

cmd_drip() {
    cat << 'EOF'
=== Drip Fertigation Specifics ===

Drip irrigation is the ideal delivery method for fertigation:
  - Precise root zone delivery
  - No leaf wetting (reduces disease)
  - Highest efficiency (90-95% of water reaches roots)
  - Best fertilizer uniformity when properly designed

--- Emitter Clogging Prevention ---
  #1 issue in drip fertigation. Three types of clogging:

  Physical (particles):
    Prevention: 120-200 mesh filtration (120 micron)
    Fix: flush lines at high velocity quarterly

  Chemical (precipitates):
    Cause: calcium + sulfate = gypsum crystals
           calcium + phosphate = calcium phosphate
           iron + oxygen = iron oxide (rusty deposits)
    Prevention:
      - Keep pH < 7.0 in irrigation water
      - Never mix incompatible fertilizers
      - Inject acid (phosphoric or sulfuric) to maintain pH
      - Flush with acid solution (pH 2.0) quarterly

  Biological (algae, bacteria):
    Cause: organic matter + nutrients + sunlight = biofilm
    Prevention:
      - Chlorination: 1-2 ppm free chlorine continuously
        or 10-20 ppm shock treatment monthly
      - Hydrogen peroxide: 30-50 ppm periodically
      - Keep fertilizer tanks covered (no light)

--- Line Flushing Protocol ---
  Frequency: monthly minimum, weekly in problem areas
  Method:
    1. Open flush valves at end of laterals
    2. Run water at maximum velocity (>0.5 m/s)
    3. Flush until water runs clear (2-5 minutes)
    4. Close valves starting from farthest lateral
  After fertigation: always flush with clear water (10-15 min)

--- Drip System Design for Fertigation ---
  Emission uniformity target: >90% (EU = q_min / q_avg)
  Lateral length: shorter = more uniform (follow manufacturer specs)
  Pressure regulation: pressure-compensating emitters recommended
  Mainline sizing: adequate for peak flow + injection pressure drop
  Injection point: after filter, before first zone valve
EOF
}

cmd_monitoring() {
    cat << 'EOF'
=== Fertigation Monitoring ===

--- EC (Electrical Conductivity) ---
  What: measures total dissolved salts in solution
  Units: dS/m (deciSiemens/meter) or mS/cm (same thing)
  Measurement points:
    Source water:      background EC before fertilizer
    After injection:   EC of fertigation solution
    Soil/root zone:    EC of soil solution (1:2 extract or pour-through)
    Drainage/runoff:   EC of leachate

  Interpretation:
    Irrigation EC < root zone EC     → salt accumulating (reduce fertilizer or increase leaching)
    Drainage EC ≈ irrigation EC      → nutrients passing through (reduce rate)
    Drainage EC > 1.5× irrigation EC → salt stress risk (leach with clear water)

--- pH Monitoring ---
  Target: 5.5-6.5 for most crops (nutrient availability optimal)

  pH too high (>7.0):
    Iron, manganese, zinc become unavailable
    Calcium phosphate precipitates in lines
    Fix: inject acid (phosphoric, sulfuric, or nitric)

  pH too low (<5.0):
    Aluminum and manganese toxicity risk
    Calcium and magnesium deficiency
    Fix: reduce acid injection, add potassium bicarbonate

--- Sensor Placement ---
  Inline sensors (after injection):
    EC sensor: verify injection is occurring and at correct rate
    pH sensor: verify acid injection maintaining target
    Flow meter: calculate total volume applied

  Soil sensors:
    Tensiometer or soil moisture sensor: at 30cm and 60cm depth
    Soil EC sensor: at root zone depth
    Place at representative locations (not at edge of bed)

--- Runoff/Leachate Analysis ---
  Collect drainage water from beneath root zone
  Frequency: weekly during active fertigation season
  Test for: EC, pH, N (NO3 + NH4), P, K, Ca, Mg
  Purpose: verify nutrient uptake, detect imbalances

--- Record Keeping ---
  Log daily:
    Injection rate and duration
    Fertilizer type and concentration
    EC and pH of solution
    Irrigation volume
    Weather conditions

  Log weekly:
    Soil EC and moisture readings
    Runoff EC and pH
    Visual crop assessment

  Log monthly:
    Full nutrient analysis of soil and drainage
    Equipment calibration checks
    Filter cleaning and line flushing dates
EOF
}

cmd_problems() {
    cat << 'EOF'
=== Common Fertigation Problems ===

1. Precipitate Formation (White Deposits)
   Cause: Calcium + sulfate or phosphate mixing in concentrated solution
   Symptoms: white crystite in lines, clogged emitters, reduced flow
   Fix: Use separate stock tanks (A: calcium, B: sulfate/phosphate)
        Inject from each tank at separate points
        Flush system after each fertigation event
   Prevention: NEVER mix calcium nitrate with potassium sulfate,
               magnesium sulfate, or MAP in the same tank

2. Uneven Nutrient Distribution
   Cause: poor irrigation uniformity, pressure variation, clogged emitters
   Symptoms: nutrient deficiency in some areas, excess in others
   Fix: check emission uniformity (EU), clean/replace clogged emitters,
        install pressure regulators, reduce lateral length
   Goal: EU > 90% for fertigation to be effective

3. Salt Buildup in Soil
   Cause: insufficient leaching, high EC fertigation, low rainfall
   Symptoms: white salt crust on soil surface, leaf tip burn,
             declining yields, high soil EC readings
   Fix: leaching irrigation (apply 20-30% more water than ET)
        reduce fertilizer concentration
        switch to lower-salt fertilizer sources (nitrate vs chloride)

4. pH Drift
   Cause: alkaline source water neutralizes acid injection,
          ammonium fertilizers acidify soil over time
   Symptoms: nutrient lockout (iron chlorosis at high pH),
             toxicity symptoms at low pH
   Fix: regular pH testing of irrigation solution and soil,
        adjust acid injection rate, use appropriate N source

5. Injector Malfunction
   Cause: worn diaphragm, check valve failure, air lock, clogged suction line
   Symptoms: EC doesn't change when injection should be occurring,
             fertilizer tank level not dropping
   Fix: check suction strainer, verify check valve, bleed air,
        replace diaphragm/seals on schedule

6. Over-Fertilization
   Cause: injection rate too high, wrong stock concentration, timer malfunction
   Symptoms: leaf burn, wilting (osmotic stress), high EC runoff
   Fix: immediately flush with clear water for extended period
        reduce injection rate, verify calculations
        install EC alarm/cutoff on injection system

7. Algae in Fertilizer Tanks
   Cause: light + nutrients + warm temperature
   Symptoms: green/brown growth in tanks, clogged suction line
   Fix: use opaque tanks, keep covered, add chlorine or peroxide
        clean tanks between batches

8. Nutrient Antagonism
   Cause: excess of one nutrient blocking uptake of another
   Examples:
     Excess K → blocks Ca and Mg uptake
     Excess NH4 → blocks Ca, Mg, K uptake
     Excess P → blocks Zn and Fe uptake
   Fix: maintain balanced nutrient ratios, test tissue regularly,
        adjust individual nutrient sources as needed
EOF
}

show_help() {
    cat << EOF
fertigation v$VERSION — Fertigation Systems Reference

Usage: script.sh <command>

Commands:
  intro        Fertigation principles and system components
  methods      Injection methods: Venturi, pump, proportional
  nutrients    Fertilizer types, solubility, compatibility
  scheduling   Nutrient scheduling by crop growth stage
  calculations Injection rate and concentration math
  drip         Drip-specific issues: clogging, flushing, design
  monitoring   EC, pH, sensors, and runoff analysis
  problems     Common problems and troubleshooting
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    methods)      cmd_methods ;;
    nutrients)    cmd_nutrients ;;
    scheduling)   cmd_scheduling ;;
    calculations) cmd_calculations ;;
    drip)         cmd_drip ;;
    monitoring)   cmd_monitoring ;;
    problems)     cmd_problems ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "fertigation v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
