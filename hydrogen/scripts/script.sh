#!/usr/bin/env bash
# hydrogen — Hydrogen Energy Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Hydrogen Energy ===

Hydrogen is the most abundant element in the universe. As an energy
carrier, it can store, move, and deliver energy from diverse sources.

Physical Properties:
  Formula:           H₂ (diatomic molecule)
  Molecular weight:  2.016 g/mol (lightest gas)
  Density (STP):     0.0899 kg/m³
  Energy content:    120 MJ/kg (LHV) / 142 MJ/kg (HHV)
                     33.3 kWh/kg (LHV)
  Boiling point:     -252.87°C (20.28 K)
  Flame speed:       2.65 m/s (6× faster than methane)
  Auto-ignition:     585°C
  Flammability:      4-75% in air (very wide range)
  Flame color:       Nearly invisible (dangerous!)

Hydrogen Color Spectrum:
  Grey       SMR of natural gas (no CCS) — 95% of today's H₂
  Blue       SMR with carbon capture (CCS) — 85-95% CO₂ captured
  Green      Water electrolysis with renewable electricity
  Pink/Red   Electrolysis with nuclear electricity
  Turquoise  Methane pyrolysis (solid carbon byproduct)
  White      Naturally occurring geological hydrogen
  Yellow     Electrolysis with grid electricity (mixed sources)

Global H₂ Production (2023):
  ~95 million tonnes/year
  Grey H₂: ~80% (from natural gas)
  Brown H₂: ~18% (from coal, mostly China)
  Green H₂: < 1% (growing rapidly)
  CO₂ from H₂ production: ~900 Mt CO₂/yr (2% of global)

Current Uses:
  Ammonia production (NH₃):     55%
  Oil refining:                  25%
  Methanol production:           10%
  Steel (DRI):                   5%
  Other (electronics, food):     5%

Future Promise:
  Heavy transport, aviation fuel, steelmaking
  Long-duration energy storage (seasonal)
  Industrial heat decarbonization
  Power-to-X (synthetic fuels, chemicals)
EOF
}

cmd_production() {
    cat << 'EOF'
=== Hydrogen Production Methods ===

--- Steam Methane Reforming (SMR) ---
  CH₄ + H₂O → CO + 3H₂ (700-1000°C, 15-30 bar)
  CO + H₂O → CO₂ + H₂ (water-gas shift)

  Efficiency: 65-75% (LHV)
  Cost: $1.0-2.0/kg H₂ (cheapest)
  CO₂: 9-12 kg CO₂ per kg H₂
  Scale: 150,000-300,000 Nm³/h (large reformers)
  Dominant method (~95% of global production)

  With CCS (Blue H₂):
    Capture 85-95% of CO₂
    Cost: $1.5-3.0/kg H₂ (CCS adds $0.5-1.0)
    Residual emissions: 1-3 kg CO₂/kg H₂

--- Autothermal Reforming (ATR) ---
  Partial oxidation + steam reforming
  Better suited for CCS (concentrated CO₂ stream)
  Higher capture rate possible (> 95%)
  Used in blue hydrogen mega-projects

--- Water Electrolysis (Green H₂) ---
  2H₂O → 2H₂ + O₂ (with electricity)
  Efficiency: 60-80% (system level)
  Cost: $3-8/kg H₂ (depending on electricity price)
  CO₂: 0 kg (if renewable electricity)
  Scale: 1 MW to 1 GW+ (scaling rapidly)
  See "electrolysis" command for details

--- Methane Pyrolysis (Turquoise H₂) ---
  CH₄ → C + 2H₂ (1000-1400°C, no oxygen)
  Solid carbon byproduct (saleable!)
  No direct CO₂ emissions
  Cost: $2-4/kg H₂ (projected)
  Technology: plasma, catalytic, molten metal
  Companies: Monolith, BASF, Hazer Group

--- Coal Gasification (Brown/Black H₂) ---
  C + H₂O → CO + H₂ (1000-1500°C)
  Followed by water-gas shift
  Cheapest in coal-rich regions (China, India)
  Very high CO₂: 18-20 kg CO₂/kg H₂
  With CCS: cost competitive but still significant emissions

--- Biomass Gasification ---
  Biomass → Syngas (CO + H₂) → H₂
  Carbon-neutral if sustainably sourced
  Small scale, variable feedstock quality
  Cost: $3-6/kg H₂

--- Thermochemical Water Splitting ---
  Use heat (800-1500°C) to split water
  Sulfur-iodine cycle, cerium oxide cycle
  Nuclear or concentrated solar heat source
  Experimental / demonstration stage
EOF
}

cmd_electrolysis() {
    cat << 'EOF'
=== Electrolysis Technologies ===

--- Alkaline Electrolysis (AEL) ---
  Most mature technology (100+ years)
  Electrolyte: KOH solution (25-30% concentration)
  Temperature: 60-90°C
  Pressure: 1-30 bar
  Efficiency: 63-70% (LHV)
  Stack life: 60,000-90,000 hours
  CAPEX: $500-1,000/kW (2023)
  Ramp rate: 10-100% in minutes (improving)
  Scale: up to 10 MW per stack

  Advantages: lowest cost, proven, no precious metals
  Challenges: slower response, lower current density

--- PEM Electrolysis (PEMEL) ---
  Proton Exchange Membrane (same as PEM fuel cell, reversed)
  Electrolyte: Solid polymer membrane (Nafion)
  Temperature: 50-80°C
  Pressure: 15-80 bar (high-pressure output native)
  Efficiency: 60-68% (LHV)
  Stack life: 40,000-60,000 hours
  CAPEX: $800-1,500/kW (2023, declining fast)
  Ramp rate: 0-100% in seconds (excellent for renewables)
  Scale: up to 5 MW per stack (growing)

  Advantages: fast response, compact, high-pressure output
  Challenges: iridium/platinum catalysts (expensive, scarce)

--- Solid Oxide Electrolysis (SOEC) ---
  High-temperature electrolysis
  Electrolyte: Ceramic (YSZ, same as SOFC)
  Temperature: 700-850°C
  Efficiency: 75-85% (LHV) — highest of all types!
  Stack life: 20,000-40,000 hours (improving)
  CAPEX: $2,000-5,000/kW (early commercial)

  Advantages:
    - Highest efficiency (uses heat + electricity)
    - Can co-electrolyze CO₂ + H₂O → syngas (CO + H₂)
    - Ideal near waste heat sources (nuclear, industrial)
    - Reversible (can run as fuel cell = SOFC)

  Challenges: degradation, thermal cycling, high cost

--- AEM Electrolysis (Anion Exchange Membrane) ---
  Emerging technology combining AEL + PEM advantages
  Non-precious metal catalysts (like AEL)
  Compact, fast response (like PEM)
  Pure water feed (no KOH)
  Membrane durability still being improved
  Companies: Enapter, Ionomr

--- Cost Drivers ---
  Electricity cost:   60-80% of LCOH
    At $30/MWh → ~$3/kg H₂
    At $15/MWh → ~$1.5/kg H₂
  Capacity factor:    Higher CF → lower LCOH
  Stack efficiency:   Higher = less electricity/kg
  Stack lifetime:     Longer = lower replacement cost
  System CAPEX:       Stack + BOP + installation

--- Scale Targets ---
  2023:  ~1 GW global electrolyzer manufacturing/year
  2025:  Targets of 10-20 GW/year manufacturing capacity
  2030:  Targets of 100+ GW cumulative installed
  Cost target: < $1.00/kg H₂ (DOE "Hydrogen Shot")
EOF
}

cmd_storage() {
    cat << 'EOF'
=== Hydrogen Storage ===

The biggest challenge: H₂ has high energy per kg but low energy per volume.
Energy density: 33.3 kWh/kg but only 3 kWh/m³ (at STP)

--- Compressed Gas (CGH₂) ---
  Most common method today
  Pressures: 200-700 bar
    Type I:   Steel cylinders, 200 bar, heavy
    Type III: Aluminum liner + carbon fiber, 350 bar
    Type IV:  Plastic liner + carbon fiber, 700 bar (vehicles)

  Energy density:
    350 bar: 0.8 kWh/L (23 g/L)
    700 bar: 1.3 kWh/L (40 g/L)

  Compression energy: 5-15% of H₂ energy content
  Applications: vehicles (700 bar), industrial (200 bar)

--- Liquid Hydrogen (LH₂) ---
  Cryogenic cooling to -253°C
  Density: 70.8 kg/m³ (vs 0.09 kg/m³ gas at STP)
  Energy density: 2.36 kWh/L (much better than compressed)
  Liquefaction energy: 25-35% of H₂ energy content!
  Boil-off: 0.1-1% per day (must vent or re-liquefy)

  Applications: space (NASA), long-distance transport, aviation
  Infrastructure: expensive cryogenic equipment

--- Metal Hydrides ---
  H₂ absorbed into metal alloys (like a sponge)
  Low pressure (1-10 bar), safe
  Gravimetric density: 1-7% by weight
  Volumetric density: 90-150 kg H₂/m³ (highest!)
  Release: apply heat (endothermic desorption)
  Heavy systems, slow kinetics
  Types: LaNi₅H₆, MgH₂, NaAlH₄

--- Chemical Carriers ---
  Ammonia (NH₃):
    17.6% H₂ by weight, liquid at -33°C or 10 bar
    Established infrastructure (fertilizer industry)
    Energy for cracking: ~25-30% of H₂ energy
    Toxic but well-understood handling

  LOHC (Liquid Organic Hydrogen Carriers):
    Methylcyclohexane ↔ Toluene + 3H₂
    Liquid at ambient (easy to transport)
    6.2% H₂ by weight
    Dehydrogenation needs 300-350°C heat

  Methanol (CH₃OH):
    12.5% H₂ by weight
    Liquid at ambient, existing infrastructure
    Requires CO₂ source for synthesis

--- Underground Storage ---
  Salt caverns: proven, large scale, fast cycling
    Existing: Teesside (UK), Texas (USA) — millions m³
  Depleted gas fields: huge capacity, slower cycling
  Aquifers: large potential, less proven
  Lined rock caverns: for non-salt geology

  Salt cavern capacity: 100-1000 GWh (seasonal storage!)
  Compare: biggest battery ~1 GWh
EOF
}

cmd_transport() {
    cat << 'EOF'
=== Hydrogen Transport ===

--- Pipelines ---
  Most economical for large volumes (> 10 t/day)

  Dedicated H₂ pipelines:
    ~5,000 km globally (mostly industrial, USA Gulf Coast)
    Pressure: 10-100 bar
    Diameter: 100-600 mm
    Cost: $0.5-1.5 million/km (new build)
    Capacity: up to 1 GW equivalent

  Natural gas pipeline blending:
    Blend 5-20% H₂ into existing gas grid
    No major infrastructure changes needed (< 20%)
    Reduces carbon intensity of gas supply
    Limitations: H₂ embrittlement of steel, meter calibration

  Repurposing gas pipelines:
    Convert existing natural gas to 100% H₂
    Cost: 10-35% of new pipeline construction
    Requires: material assessment, recompression, new seals
    European Hydrogen Backbone: 40,000 km proposed by 2040

--- Tube Trailers (Compressed Gas) ---
  Steel tubes on truck trailer
  200-500 bar pressure
  Capacity: 300-1,000 kg H₂ per trailer
  Range: up to 300 km economically
  Cheapest for: small volumes, short distances
  Cost: $2-8/kg delivery cost

--- Liquid H₂ Tankers ---
  Cryogenic truck tankers
  Capacity: 3,500-4,500 kg LH₂ per truck
  Range: up to 1,500 km
  Better for: medium volumes, longer distances
  Boil-off during transport: 0.3-0.5%/day

--- Maritime Transport ---
  LH₂ ships: Kawasaki SUISO FRONTIER (pilot, 75 t)
  Ammonia ships: existing fleet, proven technology
  LOHC ships: standard chemical tankers
  For intercontinental trade:
    Ammonia most economical (existing infrastructure)
    LH₂ most energy-efficient (no conversion loss)

--- Cost Comparison (per kg H₂ delivered) ---
  Pipeline (500 km):           $0.5-1.5
  Tube trailer (100 km):       $2-5
  LH₂ truck (500 km):          $3-7
  Ammonia ship (5000 km):       $2-4
  LH₂ ship (5000 km):          $4-8

--- Hydrogen Refueling Stations ---
  Compressed (700 bar): 3-5 min refueling
  Capacity: 200-1000 kg/day typical
  Cost: $1-3 million per station
  Global count: ~1,200 stations (2023)
  Highest density: Japan, Germany, California, Korea
EOF
}

cmd_applications() {
    cat << 'EOF'
=== Hydrogen Applications ===

--- Industry (largest current use) ---
  Ammonia (Haber-Bosch): N₂ + 3H₂ → 2NH₃
    180 Mt NH₃/year, 32 Mt H₂/year consumed
    Fertilizer production (80% of NH₃ use)
    Green ammonia: renewable H₂ + renewable electricity

  Oil refining: hydrocracking, desulfurization
    ~40 Mt H₂/year consumed
    Declining with oil transition

  Steel (Direct Reduced Iron):
    Fe₂O₃ + 3H₂ → 2Fe + 3H₂O (replaces coal/coke)
    HYBRIT (Sweden): fossil-free steel (pilot 2021)
    Potential: 7% of global CO₂ (steelmaking)

  Methanol: CO₂ + 3H₂ → CH₃OH + H₂O
    Green methanol for shipping fuel, chemicals

--- Transport ---
  Fuel Cell Electric Vehicles (FCEV):
    Cars: Toyota Mirai, Hyundai Nexo (niche)
    Heavy trucks: better fit than batteries (range, weight, refuel)
    Buses: 60,000+ deployed globally
    Trains: Alstom iLint (replacing diesel)
    Ships: ferries, potentially deep-sea
    Aviation: H₂ combustion turbines, fuel cell propulsion

  Where H₂ beats batteries:
    Long range (> 500 km), heavy loads, fast refuel
    Cold weather performance
    Predictable route (fleet vehicles)

--- Power Generation ---
  Gas turbines: 30-100% H₂ blending (Siemens, GE)
  Fuel cells: stationary power, backup
  Energy storage: Power-to-H₂ in surplus → H₂-to-Power in deficit
  Seasonal storage: store summer renewables for winter

--- Heating ---
  H₂ boilers: direct replacement for gas boilers
  Blending: 20% H₂ in gas grid (reduces CO₂ proportionally)
  Controversy: heat pumps are 3-5× more efficient
    H₂ heating: only where heat pumps are impractical

--- Synthetic Fuels (Power-to-X) ---
  e-Kerosene: H₂ + CO₂ → Fischer-Tropsch → jet fuel
  e-Methane: H₂ + CO₂ → CH₄ (Sabatier reaction)
  e-Methanol: H₂ + CO₂ → CH₃OH
  For sectors where direct electrification is impossible
EOF
}

cmd_safety() {
    cat << 'EOF'
=== Hydrogen Safety ===

Hydrogen is different from natural gas — not more or less dangerous,
but DIFFERENTLY dangerous. Understanding the differences is critical.

--- Key Properties ---
  Flammability range: 4-75% in air (methane: 5-15%)
    Much wider range → easier to ignite
  Auto-ignition temp:  585°C (methane: 537°C)
  Flame speed:         2.65 m/s (methane: 0.40 m/s)
    Burns 6× faster → detonation risk in confined spaces
  Minimum ignition:    0.02 mJ (methane: 0.29 mJ)
    Static spark can ignite H₂
  Flame visibility:    Nearly invisible in daylight
    Cannot see H₂ fire → thermal cameras needed
  Buoyancy:            14× lighter than air → rises and disperses fast
    ADVANTAGE: open-air leaks dissipate rapidly

--- Risk Comparison ---
  Hydrogen advantages over fossil fuels:
    ✓ Non-toxic (not poisonous to breathe)
    ✓ Non-carcinogenic
    ✓ Rises and disperses quickly outdoors
    ✓ Does not pool like gasoline
    ✓ Lower radiant heat from fire

  Hydrogen challenges:
    ✗ Invisible flame
    ✗ Very wide flammability range
    ✗ Easy to ignite (low energy)
    ✗ Hydrogen embrittlement of metals
    ✗ Very small molecule → leaks easily
    ✗ Odorless (no natural warning, can't add odorant like gas)

--- Hydrogen Embrittlement ---
  H₂ atoms diffuse into metal crystal structure
  Causes: cracking, reduced ductility, failure
  Affected: carbon steel, high-strength steel
  Resistant: austenitic stainless steel, aluminum alloys
  Prevention: proper material selection, coatings, lower pressure

--- Codes & Standards ---
  ISO 19880:      Hydrogen fueling stations
  ISO 14687:      Hydrogen fuel quality
  NFPA 2:         Hydrogen technologies code
  SAE J2601:      Hydrogen vehicle fueling protocol
  ASME B31.12:    Hydrogen piping and pipelines
  EN 17124:       European H₂ fuel quality standard

--- Safety Systems ---
  Detection: H₂ sensors (catalytic, thermal conductivity)
  Ventilation: always ventilate enclosed spaces
  Emergency shutoff: automatic and manual isolation
  Flame detection: UV/IR detectors (visible camera useless!)
  Purging: N₂ purge before maintenance
  Grounding: prevent static discharge during transfer
  Signage: "HYDROGEN — FLAMMABLE GAS — NO IGNITION SOURCES"
EOF
}

cmd_economics() {
    cat << 'EOF'
=== Hydrogen Economics ===

--- LCOH (Levelized Cost of Hydrogen) ---

  Grey H₂ (SMR, no CCS):
    $1.0-2.0/kg → benchmark to beat
    Dominated by natural gas price
    At $10/MMBtu gas: ~$1.5/kg

  Blue H₂ (SMR + CCS):
    $1.5-3.0/kg
    CCS adds $0.5-1.0/kg
    Carbon price sensitivity: $50/t CO₂ → +$0.5/kg grey

  Green H₂ (electrolysis):
    2023: $3-8/kg (location dependent)
    2030 target: $1.5-3.0/kg
    2050 target: < $1.0/kg (DOE Hydrogen Shot: $1/kg by 2031)

--- Green H₂ Cost Breakdown ---
  Electricity:        60-80% of LCOH
  Electrolyzer CAPEX: 15-25%
  Water:              1-2%
  O&M:                5-10%

  Sensitivity to electricity price:
    $10/MWh → ~$1.5/kg (Saudi Arabia, Chile scenario)
    $30/MWh → ~$3.0/kg (good renewable site)
    $50/MWh → ~$5.0/kg (average grid)
    $80/MWh → ~$8.0/kg (expensive grid)

  Electrolyzer CAPEX decline:
    2020: $1,000-1,500/kW
    2025: $500-800/kW (expected)
    2030: $200-400/kW (target)

--- Market Projections ---
  Global H₂ demand forecast (IEA NZE scenario):
    2022:  ~95 Mt/year
    2030:  ~150 Mt/year
    2050:  ~530 Mt/year

  Green H₂ capacity:
    2022:  ~0.1 GW installed electrolyzer
    2025:  ~10-20 GW (announced projects)
    2030:  ~100-200 GW (pipeline, uncertain execution)

--- Policy Support ---
  USA IRA: $3/kg production tax credit (45V)
    Makes green H₂ < $1/kg in best locations!
  EU: 40 GW electrolyzer target by 2030
  China: aggressive scale-up, lowest equipment cost
  Japan: H₂ society vision, 3 Mt/year by 2030
  India: Green Hydrogen Mission, 5 Mt/year by 2030
  Australia: H₂ export hub (to Japan, Korea)

--- Price Parity Timeline ---
  Green = Grey parity:
    With policy support: 2025-2028 (some regions already)
    Without policy: 2030-2035
    Key factors: electricity cost, electrolyzer CAPEX, carbon price
EOF
}

show_help() {
    cat << EOF
hydrogen v$VERSION — Hydrogen Energy Reference

Usage: script.sh <command>

Commands:
  intro          Hydrogen properties and color spectrum
  production     Production methods: SMR, electrolysis, pyrolysis
  electrolysis   Electrolysis technologies: PEM, alkaline, SOEC
  storage        Storage: compressed, liquid, hydrides, underground
  transport      Transport: pipelines, trailers, ships
  applications   End uses: industry, transport, power, heating
  safety         Safety properties, risks, and standards
  economics      LCOH, cost drivers, and market outlook
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)         cmd_intro ;;
    production)    cmd_production ;;
    electrolysis)  cmd_electrolysis ;;
    storage)       cmd_storage ;;
    transport)     cmd_transport ;;
    applications|apps) cmd_applications ;;
    safety)        cmd_safety ;;
    economics|econ) cmd_economics ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "hydrogen v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
