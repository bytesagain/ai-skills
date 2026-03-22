#!/usr/bin/env bash
# carbon-capture — Carbon Capture Technology Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Carbon Capture, Storage & Utilization (CCS/CCUS) ===

Carbon capture prevents CO₂ from reaching the atmosphere by
capturing it at emission sources or directly from air, then
storing it permanently or converting it to useful products.

The CCS Chain:
  1. CAPTURE    Separate CO₂ from flue gas, process gas, or air
  2. TRANSPORT  Move CO₂ via pipeline, ship, or truck
  3. STORAGE    Inject into geological formations (permanent)
  -- or --
  3. UTILIZATION Convert CO₂ into products (CCUS)

Scale of the Challenge:
  Global CO₂ emissions:     ~37 Gt/year (2023)
  Current CCS capacity:     ~45 Mt/year (0.12% of emissions)
  IPCC target for CCS:      5–15 Gt/year by 2050
  Gap:                      100× current capacity needed

Capture Sources by CO₂ Concentration:
  Source                  CO₂ %      Capture cost
  ─────                   ─────      ────────────
  Ethanol fermentation    ~100%      $15–25/ton (cheapest)
  Ammonia production      ~100%      $25–35/ton
  Natural gas processing  5–70%      $15–25/ton
  Cement plant            15–30%     $50–120/ton
  Steel plant             20–30%     $60–120/ton
  Coal power plant        12–15%     $60–100/ton
  Gas power plant         3–5%       $70–120/ton
  Direct Air Capture      0.04%      $250–600/ton

Operating CCS Facilities (2024):
  Sleipner (Norway):      1 Mt/year since 1996 (longest running)
  Quest (Canada):         1 Mt/year (oil sands hydrogen)
  Gorgon (Australia):     4 Mt/year design (underperforming)
  Boundary Dam (Canada):  1 Mt/year (coal power, first of kind)
  Petra Nova (USA):       1.4 Mt/year (coal, suspended/restarted)
  Northern Lights (Norway): 1.5 Mt/year (open-source storage)
EOF
}

cmd_postcombustion() {
    cat << 'EOF'
=== Post-Combustion Capture ===

Captures CO₂ from flue gas AFTER fuel combustion.
Retrofit-friendly — can be added to existing plants.

Amine Scrubbing (MEA — Industry Standard):
  Process:
    1. Flue gas (40-60°C) enters absorber tower (bottom)
    2. MEA solution (30% amine in water) flows down from top
    3. CO₂ reacts with amine: CO₂ + MEA → carbamate
    4. Rich solvent pumped to stripper/regenerator
    5. Heat (120-140°C steam) breaks bond, releases pure CO₂
    6. Lean solvent recycled back to absorber
  
  Performance:
    Capture rate: 85-95%
    CO₂ purity: >99%
    Energy penalty: 25-40% of plant output (parasitic load!)
    Solvent degradation: 1-3 kg MEA lost per ton CO₂
    Heat requirement: 3.5-4.0 GJ/ton CO₂ (MEA baseline)

Advanced Solvents:
  Sterically hindered amines (KS-1): 2.5-3.0 GJ/ton
  Piperazine blends (CESAR1): 2.5-2.7 GJ/ton
  Non-aqueous solvents: 2.0-2.5 GJ/ton (emerging)
  Phase-change solvents: precipitate on CO₂ absorption

Membrane Separation:
  Polymeric membranes: CO₂ permeates, N₂ retained
  Two-stage for >95% purity
  No thermal energy needed (pressure-driven)
  Energy: 0.5-1.0 GJ/ton (electricity only)
  Challenge: selectivity CO₂/N₂, membrane area, cost
  Status: demonstration scale (MTR, Air Liquide)

Solid Sorbents:
  Temperature Swing Adsorption (TSA):
    Amine-functionalized silica, MOFs, zeolites
    Adsorb at 40-60°C, desorb at 80-120°C
    Lower energy than liquid amines: 2.0-3.0 GJ/ton
    Challenge: sorbent attrition, cycling stability
  
  Calcium Looping:
    CaO + CO₂ → CaCO₃ (carbonator, 650°C)
    CaCO₃ → CaO + CO₂ (calciner, 900°C)
    Uses cheap limestone, cement industry synergy
    Challenge: sorbent deactivation after 20-50 cycles

Cryogenic Separation:
  Cool flue gas → CO₂ freezes at -78.5°C
  Energy intensive, best for high CO₂ concentrations
  Produces liquid CO₂ directly (transport-ready)
EOF
}

cmd_precombustion() {
    cat << 'EOF'
=== Pre-Combustion & Oxy-Fuel Capture ===

PRE-COMBUSTION CAPTURE:
  Remove carbon BEFORE combustion — burn hydrogen instead.

  Process (IGCC — Integrated Gasification Combined Cycle):
    1. Gasify fuel with O₂ → syngas (CO + H₂)
    2. Water-gas shift: CO + H₂O → CO₂ + H₂
    3. Separate CO₂ from H₂ (physical solvent, PSA, membrane)
    4. Burn H₂ in gas turbine → electricity
  
  Advantages:
    Higher CO₂ concentration (15-40%) → easier separation
    Physical solvents (Selexol, Rectisol) → lower energy penalty
    H₂ co-production potential
  
  Challenges:
    Requires new-build gasification plant (not retrofit)
    IGCC plants complex and expensive
    H₂ turbine combustion challenges (NOx, flashback)
  
  Applications:
    Coal IGCC: Kemper County (failed, cost overrun)
    Natural gas reforming + CCS: blue hydrogen
    Industrial H₂ production (ammonia, refining)

Blue Hydrogen (SMR/ATR + CCS):
  SMR: CH₄ + H₂O → CO + 3H₂ (then shift + capture)
  ATR: CH₄ + ½O₂ + H₂O → CO + 3H₂ (autothermal)
  Capture rate: 90-95% (ATR) vs 50-70% (SMR, process only)
  Cost: $1.5-2.5/kg H₂ (vs $1.0 grey, $4-6 green)

OXY-FUEL COMBUSTION:
  Burn fuel in pure O₂ instead of air → flue gas is CO₂ + H₂O.
  
  Process:
    1. Air Separation Unit (ASU) produces O₂ (95-99% purity)
    2. Burn fuel in O₂ + recycled flue gas (to control temperature)
    3. Flue gas: ~80% CO₂ + ~20% H₂O
    4. Condense water → nearly pure CO₂ stream
    5. Compress CO₂ for transport
  
  Advantages:
    Very high CO₂ purity (>95%)
    No chemical solvents needed
    Simpler CO₂ purification
    Eliminates NOx (no nitrogen from air)
  
  Challenges:
    ASU is energy-intensive (200-250 kWh/ton O₂)
    ASU is expensive (30-40% of plant CAPEX)
    Air leakage dilutes CO₂ stream
    Boiler redesign for oxy-fuel conditions
  
  Status: Demonstration scale (Callide, NET Power)
  
  NET Power (Allam Cycle):
    Supercritical CO₂ as working fluid
    Gas turbine: natural gas + O₂ → CO₂ + H₂O
    CO₂ drives turbine, excess is captured
    Near-zero emissions with high efficiency (~58%)
    First commercial plant: La Porte, Texas (2024)
EOF
}

cmd_dac() {
    cat << 'EOF'
=== Direct Air Capture (DAC) ===

Captures CO₂ directly from ambient air (400 ppm = 0.04%).
1000× more dilute than flue gas → more energy needed.

Liquid Solvent DAC (Carbon Engineering / Occidental):
  Process:
    1. Air contactor: large fans pull air through KOH solution
       CO₂ + 2KOH → K₂CO₃ + H₂O
    2. Pellet reactor: K₂CO₃ + Ca(OH)₂ → CaCO₃ + 2KOH
       (regenerate KOH, precipitate calcium carbonate)
    3. Calciner: CaCO₃ → CaO + CO₂ at 900°C
       (release pure CO₂, regenerate lime)
    4. Slaker: CaO + H₂O → Ca(OH)₂
       (complete the calcium loop)
  
  Energy: 5.3 GJ thermal + 366 kWh electric per ton CO₂
  Cost: $250-350/ton (target: $100-150)
  Scale: 1 Mt/year plant (Stratos, Texas — largest DAC facility)
  
  Pros: proven chemistry, scalable, handles any air
  Cons: high temperature heat needed (900°C), water use

Solid Sorbent DAC (Climeworks):
  Process:
    1. Air fans blow through structured sorbent beds
       Amine-functionalized filter captures CO₂
    2. Close chamber, heat to 80-100°C under vacuum
       CO₂ releases from sorbent → collected
    3. Cool sorbent, repeat cycle (every 1-3 hours)
  
  Energy: 1.5-2.0 GJ thermal + 500 kWh electric per ton CO₂
  Cost: $600-1000/ton (current), target $300-400
  Scale: Orca (Iceland): 4,000 tons/year (2021)
         Mammoth (Iceland): 36,000 tons/year (2024)
  
  Pros: low-temperature heat (waste heat, geothermal), modular
  Cons: expensive sorbent, degradation, small scale so far

Electrochemical DAC (Emerging):
  Direct electrolysis to swing pH → capture/release CO₂
  Companies: Verdox, Mission Zero, Heirloom
  Potential for much lower energy (thermodynamic minimum: 0.5 GJ/t)
  Status: lab/pilot scale

Ocean-Based Carbon Removal:
  Electrochemical ocean alkalinity enhancement
  Remove CO₂ by making ocean absorb more from atmosphere
  Companies: Ebb Carbon, Planetary Technologies
  Large potential but early stage, monitoring challenges

DAC vs Point Source:
  Point source: $30-120/ton — always cheaper per ton
  DAC: $250-1000/ton — but can be placed anywhere
  DAC value: addresses distributed emissions (transport, agriculture)
  DAC value: can achieve NET negative emissions
  Both are needed — DAC supplements, doesn't replace point source
EOF
}

cmd_transport() {
    cat << 'EOF'
=== CO₂ Transport ===

CO₂ must be transported from capture site to storage/use site.
State depends on temperature and pressure.

CO₂ Phase Diagram Key Points:
  Triple point:   -56.6°C, 5.18 bar (solid-liquid-gas)
  Critical point:  31.1°C, 73.8 bar (supercritical above this)
  Normal boiling: -78.5°C (sublimation at 1 atm)

Pipeline Transport (dominant method):
  Phase: dense/supercritical (>73.8 bar, >31°C)
  Density: 600-900 kg/m³ (liquid-like)
  Pressure: 100-150 bar (operating)
  Velocity: 1-5 m/s
  Temperature: ambient to 35°C
  
  Sizing:
    10 Mt/year: 24-36" diameter pipeline
    1 Mt/year:  12-16" diameter
    Booster stations: every 100-200 km
  
  Material: carbon steel (API 5L X65-X80)
  Corrosion: DRY CO₂ is non-corrosive
             WET CO₂ forms carbonic acid → severe corrosion
             Max water: <50 ppm for carbon steel
  
  Existing infrastructure:
    USA: ~8,000 km CO₂ pipelines (mostly for EOR)
    Planned: 40,000+ km in development globally
  
  Cost: $1-5/ton per 100 km (large pipeline)

Ship Transport:
  Phase: liquid at -50°C, 7 bar (similar to LPG)
  Tank: pressurized, insulated (semi-refrigerated)
  Capacity: 7,500-50,000 m³ per vessel
  Cost: $10-30/ton for 500-2000 km distance
  Advantage: flexible, no fixed infrastructure
  Example: Northern Lights project (Norway) — ship to offshore storage
  
  Loading/unloading: dedicated CO₂ terminals
  Boil-off: recondensed or reliquefied on vessel

Truck Transport:
  Phase: liquid at -20°C, 20 bar
  Capacity: ~20 tons per truck
  Cost: $5-15/ton per 100 km
  Only viable for small volumes, short distances
  Used for: food-grade CO₂, small capture demos

Impurity Specifications (pipeline):
  CO₂: >95% (>99% preferred)
  H₂O: <50 ppm (corrosion prevention)
  H₂S: <20 ppm (toxicity)
  O₂: <100 ppm (prevents combustion in storage)
  NOx: <100 ppm
  SOx: <100 ppm
EOF
}

cmd_storage() {
    cat << 'EOF'
=== Geological CO₂ Storage ===

Inject CO₂ into deep geological formations for permanent storage.
Target: thousands to millions of years retention.

Storage Types:

  Deep Saline Aquifers (largest capacity):
    Porous sandstone saturated with brine (>800m depth)
    Global capacity: 1,000-10,000 Gt CO₂
    Injection: supercritical CO₂ (>31°C, >73.8 bar)
    At 800m+: CO₂ density ~600 kg/m³ (efficient storage)
    Examples: Sleipner (Norway), Illinois Basin (USA)

  Depleted Oil/Gas Reservoirs:
    Well-characterized geology (decades of production data)
    Proven seal integrity (held hydrocarbons for millions of years)
    Existing wells and infrastructure
    Global capacity: 200-900 Gt CO₂
    Risk: abandoned wells as leakage pathways

  Enhanced Oil Recovery (CO₂-EOR):
    Inject CO₂ → extract additional oil (10-20% more recovery)
    CO₂ stays trapped in reservoir (60-80% of injected)
    Revenue from oil offsets CCS cost
    USA: 40+ years of CO₂-EOR experience
    Criticism: enables more fossil fuel production

  Basalt Mineralization:
    CO₂ reacts with basaltic rock → carbonate minerals
    CarbFix (Iceland): CO₂ dissolved in water, injected into basalt
    Mineralization in 2 years (vs thousands for conventional)
    Permanent: literally turned to stone
    Challenge: needs large water volumes, basalt locations

Trapping Mechanisms (increasing permanence):
  1. Structural:    Impermeable caprock prevents upward migration
  2. Residual:      CO₂ trapped in pore spaces by capillary forces
  3. Solubility:    CO₂ dissolves in formation brine (decades)
  4. Mineral:       CO₂ reacts with rock → carbonate minerals (centuries+)

Monitoring Requirements:
  Seismic surveys (4D time-lapse): track CO₂ plume movement
  Well pressure monitoring: detect overpressure
  Groundwater sampling: detect CO₂ or brine leakage
  Surface flux monitoring: soil gas, atmospheric sensors
  InSAR satellite: detect ground deformation (mm-scale)
  Microseismic: detect induced seismicity

Storage Security:
  Risk of leakage: <1% over 1000 years (well-selected sites)
  Sleipner: 25+ years, no detected leakage
  Natural analogs: CO₂ trapped in reservoirs for millions of years
EOF
}

cmd_utilization() {
    cat << 'EOF'
=== CO₂ Utilization (CCU) ===

Convert captured CO₂ into valuable products.
Key question: does it PERMANENTLY store CO₂ or just delay emission?

Permanent Storage Pathways:

  Building Materials (mineralization):
    CO₂ + calcium/magnesium → carbonate minerals
    Concrete curing: CarbonCure injects CO₂ during mixing
    Aggregates: Blue Planet, Carbon8 make CO₂-mineralized rock
    Potential: 0.5-3 Gt/year (massive market)
    Storage duration: permanent (minerals are stable)
  
  Biochar + Soil Amendment:
    Pyrolysis of biomass → stable carbon in soil
    Potential: 0.5-2 Gt/year
    Storage: 100-1000 years

Temporary Storage Pathways:

  Enhanced Oil Recovery (CO₂-EOR):
    Largest current use: ~230 Mt/year
    60-80% of CO₂ stays in reservoir (partial permanent)
    Revenue: $15-40/ton CO₂ from oil production
  
  Synthetic Fuels (e-fuels):
    CO₂ + H₂ → methanol, diesel, jet fuel
    Fischer-Tropsch: CO₂ + H₂ → CO + H₂O → hydrocarbons
    Sabatier: CO₂ + 4H₂ → CH₄ + 2H₂O (synthetic methane)
    Requires GREEN hydrogen for climate benefit
    Energy penalty: need 6-10 MWh per ton CO₂ (via H₂)
    CO₂ re-emitted when fuel is burned (circular, not removal)
  
  Chemicals:
    Methanol: CO₂ + 3H₂ → CH₃OH + H₂O (Carbon Recycling Iceland)
    Urea: CO₂ + 2NH₃ → (NH₂)₂CO (already uses 130 Mt CO₂/yr)
    Polycarbonates: Covestro using CO₂ in polyols
    Formic acid, ethanol (via electrocatalysis)

  Food & Beverage:
    Carbonation, food preservation, dry ice
    Market: ~30 Mt/year
    Short storage duration (released on consumption)

  Greenhouse Enrichment:
    Pump CO₂ into greenhouses (800-1200 ppm) for crop growth
    Small market but local use near capture sites

Scale Reality Check:
  Total current CO₂ utilization: ~230 Mt/year
  Global emissions: ~37,000 Mt/year
  Utilization alone cannot solve the problem
  Storage (geological) must be the primary pathway
  Utilization creates revenue but limited volume
EOF
}

cmd_economics() {
    cat << 'EOF'
=== CCS Economics ===

Capture Costs ($/ton CO₂ avoided):
  Source                      $/ton     Maturity
  ─────                       ─────     ────────
  Natural gas processing      $15-25    Commercial
  Ethanol/ammonia             $25-35    Commercial
  Coal power plant            $60-100   First-of-a-kind
  Gas power plant (NGCC)      $70-120   Demonstration
  Cement                      $50-120   Demonstration
  Steel                       $60-120   Demonstration
  Direct Air Capture          $250-600  Early commercial
  
Transport Costs:
  Pipeline (onshore, 250km):  $2-8/ton
  Pipeline (offshore):        $3-15/ton
  Ship (1500km):              $15-30/ton

Storage Costs:
  Saline aquifer:             $5-20/ton
  Depleted reservoir:         $2-10/ton
  CO₂-EOR:                   -$10 to -$40/ton (revenue!)
  Monitoring (30 years):      $1-5/ton

Full Chain Cost:
  Gas processing + pipeline + storage:  $30-60/ton
  Coal power + pipeline + storage:      $70-130/ton
  DAC + pipeline + storage:             $270-650/ton

Policy Incentives:

  US 45Q Tax Credit (Inflation Reduction Act, 2022):
    Geological storage:     $85/ton CO₂ (industrial)
    DAC + storage:          $180/ton CO₂
    CO₂-EOR:                $60/ton CO₂
    DAC + EOR:              $130/ton CO₂
    Duration: 12-year credit, facilities before 2033

  EU Emissions Trading System (ETS):
    CO₂ price: €80-100/ton (2024)
    Covers: power, industry, aviation
    Rising trajectory → CCS becomes economic at >€80-100/ton

  Carbon Border Adjustment Mechanism (CBAM):
    EU imports taxed on embedded carbon
    Creates incentive for CCS in exporting countries

  Norway Carbon Tax:
    $70-90/ton (one of the highest globally)
    Drove Sleipner project in 1996 (first large CCS)

Breakeven Analysis:
  CCS viable when: carbon price > full chain cost
  Power sector: needs €80-120/ton CO₂ price
  Industry: needs €50-100/ton (some processes cheaper)
  DAC: needs $180+/ton incentive (45Q provides this)
  
Learning Rate:
  Expected cost reduction: 10-15% per doubling of capacity
  2030 target: $40-60/ton for industrial CCS
  2040 target: $100-200/ton for DAC
EOF
}

show_help() {
    cat << EOF
carbon-capture v$VERSION — Carbon Capture Technology Reference

Usage: script.sh <command>

Commands:
  intro           CCS overview, scale, and operating facilities
  postcombustion  Amine scrubbing, membranes, solid sorbents
  precombustion   IGCC, blue hydrogen, oxy-fuel combustion
  dac             Direct Air Capture technologies
  transport       Pipeline, ship, truck — CO₂ phase and specs
  storage         Geological storage, mineralization, monitoring
  utilization     CO₂ to products: fuels, materials, chemicals
  economics       Costs, 45Q credits, ETS pricing, breakeven
  help            Show this help
  version         Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)          cmd_intro ;;
    postcombustion) cmd_postcombustion ;;
    precombustion)  cmd_precombustion ;;
    dac)            cmd_dac ;;
    transport)      cmd_transport ;;
    storage)        cmd_storage ;;
    utilization)    cmd_utilization ;;
    economics)      cmd_economics ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "carbon-capture v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
