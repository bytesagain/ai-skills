#!/usr/bin/env bash
# biomass — Biomass Energy Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Biomass Energy ===

Biomass is organic material from plants and animals that stores
solar energy as chemical energy. It is the oldest energy source
used by humans and remains the largest renewable energy source globally.

Biomass Categories:
  Woody biomass     Forest residues, sawmill waste, short-rotation coppice
  Agricultural      Straw, corn stover, bagasse, husks
  Energy crops      Miscanthus, switchgrass, willow, poplar
  Waste             Municipal solid waste (organic), food waste
  Aquatic           Algae, seaweed (emerging)

Conversion Pathways:
  Thermochemical:
    Combustion    → Heat/steam → electricity (most mature)
    Gasification  → Syngas → electricity, fuels, chemicals
    Pyrolysis     → Bio-oil, biochar, syngas
    Torrefaction  → Solid biofuel (energy-dense)

  Biochemical:
    Anaerobic digestion → Biogas (CH₄ + CO₂)
    Fermentation        → Bioethanol
    Transesterification → Biodiesel

Global Context:
  - Biomass provides ~10% of global primary energy
  - 55 EJ/year (mostly traditional cooking/heating in developing world)
  - Modern biomass power: ~140 GW installed capacity
  - EU imports 20+ million tons of wood pellets/year

Carbon Neutrality Debate:
  Theory: CO₂ released = CO₂ absorbed during growth → net zero
  Reality: depends on regrowth rate, land use, supply chain emissions
  Short-rotation (1-5 yr): close to carbon-neutral
  Slow-growth forest (50+ yr): significant carbon debt
EOF
}

cmd_feedstocks() {
    cat << 'EOF'
=== Biomass Feedstock Properties ===

Heating Values (MJ/kg dry basis):
  Feedstock              HHV(dry)   Moisture%   Ash%   Bulk(kg/m³)
  ─────────              ────────   ─────────   ────   ──────────
  Wood (hardwood)        19.5       40–55       0.5–2  350–550
  Wood (softwood)        20.5       40–55       0.3–1  300–450
  Wood pellets           17.5–18.5  8–10        <1.5   650
  Bark                   18–20      45–60       3–8    250–350
  Straw (wheat)          17.5       14–20       5–8    80–120
  Straw (rice)           15.5       12–18       15–20  60–100
  Corn stover            17.5       20–30       5–7    60–80
  Bagasse (sugarcane)    17.5       48–52       2–4    120–150
  Miscanthus             18.0       15–25       2–4    100–140
  Switchgrass            17.5       12–20       4–6    120–160
  Palm kernel shells     20.5       10–15       3–5    550–650
  Olive pits             21.0       8–12        1–3    650–700

Proximate Analysis (dry basis typical wood):
  Volatile matter:  75–85%    (released as gas during heating)
  Fixed carbon:     15–25%    (burns as char)
  Ash:              0.5–2%    (inorganic residue)

Ultimate Analysis (typical wood, dry ash-free):
  Carbon:    48–52%
  Hydrogen:  5.5–6.5%
  Oxygen:    38–44%
  Nitrogen:  0.1–0.5%
  Sulfur:    <0.05%
  Chlorine:  <0.02%

Moisture Impact on Heating Value:
  HHV_wet = HHV_dry × (1 - MC) - 2.44 × MC
  (2.44 MJ/kg = latent heat of water evaporation)

  50% moisture wood: 20 × 0.5 - 2.44 × 0.5 = 8.78 MJ/kg
  10% moisture pellet: 18 × 0.9 - 2.44 × 0.1 = 15.96 MJ/kg

  Rule: Every 10% moisture reduction ≈ +2 MJ/kg usable energy
EOF
}

cmd_combustion() {
    cat << 'EOF'
=== Biomass Combustion ===

Combustion Phases:
  1. Drying        (100°C)   Moisture evaporates — consumes energy
  2. Pyrolysis     (200-500°C) Volatiles released as gas
  3. Volatile burn (500-800°C) Gases combust with air
  4. Char burnout  (800-1000°C) Fixed carbon combustion
  5. Ash           Inorganic residue remains

Combustion Technologies:

  Fixed Grate (5 kW – 5 MW):
    Moving grate, step grate, or vibrating grate
    Air staged: primary (under grate) + secondary (above)
    Fuel: chips, pellets, logs — uniform size preferred
    Efficiency: 80–90% (modern automated systems)

  Fluidized Bed (5 MW – 300 MW):
    Bubbling (BFB): sand bed at 700-900°C, low velocity
    Circulating (CFB): higher velocity, cyclone recirculation
    Fuel flexibility: mixed waste, wet fuels, RDF
    Efficiency: 85–92%
    Lower NOx (temperature control), handles high-ash fuels

  Stoker (1 MW – 50 MW):
    Underfeed, overfeed, or spreader stoker
    Mature technology, lower capital cost
    Efficiency: 75–85%

  Pulverized Fuel (50 MW+):
    Biomass ground to <1mm, blown into combustion chamber
    Can co-fire with coal (5–20% biomass typical)
    Highest capacity, needs dry feedstock (<15% MC)

Air Supply:
  Excess air ratio (λ): 1.3–1.8 for biomass
  Too low → CO, soot, unburnt carbon
  Too high → heat loss through exhaust

Efficiency Factors:
  Moisture content    Most significant — dry fuel = high efficiency
  Excess air          Minimize while ensuring complete combustion
  Flue gas temperature Lower = more heat captured (limit: acid dew point)
  Ash carbon content  <3% indicates good burnout
  Radiation losses    Surface insulation, smaller in larger plants
EOF
}

cmd_gasification() {
    cat << 'EOF'
=== Biomass Gasification ===

Gasification converts solid biomass to combustible gas (syngas/producer gas)
using limited oxygen (equivalence ratio 0.2–0.4).

Syngas Composition (typical air-blown):
  Component    Vol%     Notes
  ─────────    ────     ─────
  N₂           45–55    From air (eliminated in O₂-blown)
  CO           15–25    Main fuel component
  H₂           10–20    Main fuel component
  CO₂          10–15    
  CH₄          2–5      
  Tar          1–50 g/Nm³  Must be removed for engines

  HHV air-blown:  4–6 MJ/Nm³ (low — due to N₂ dilution)
  HHV O₂-blown:   10–15 MJ/Nm³ (medium)
  HHV steam:      15–20 MJ/Nm³ (high — suitable for synthesis)

Gasifier Types:

  Updraft (Counter-current):
    Air enters bottom, fuel enters top
    Gas exits top at 200–400°C
    High tar content (50–100 g/Nm³)
    High efficiency, simple, handles wet fuel
    Use: heat production (tar burns in burner)

  Downdraft (Co-current):
    Air enters middle, gas exits bottom through char bed
    Tar cracking in hot zone → low tar (0.01–1 g/Nm³)
    Gas exits at 700°C, needs cooling
    Use: engine power (clean gas)
    Limit: <1 MW, needs dry uniform fuel (<20% MC)

  Fluidized Bed:
    BFB or CFB with sand/olivine/dolomite bed
    700–900°C, scalable 1–100 MW
    Moderate tar (5–20 g/Nm³)
    Use: large-scale power, co-gasification

  Plasma:
    Electric arc at 3000–10000°C
    Handles any waste including hazardous
    Very clean syngas, vitrified ash (glass slag)
    High electricity consumption

Tar Management:
  Primary (in-gasifier):  bed catalysts, temperature control
  Secondary (downstream): cyclone, scrubber, ceramic filter
  Catalytic: Ni-based, dolomite, olivine at 800–900°C
  Tar dew point must be below gas usage temperature
EOF
}

cmd_pyrolysis() {
    cat << 'EOF'
=== Biomass Pyrolysis ===

Pyrolysis thermally decomposes biomass in the ABSENCE of oxygen.
Three products: bio-oil (liquid), biochar (solid), syngas (gas).

Product Distribution by Process Type:
                    Bio-oil   Biochar   Syngas
  ──────────        ───────   ───────   ──────
  Slow pyrolysis    25–30%    30–40%    25–35%
  Fast pyrolysis    60–75%    12–20%    10–20%
  Flash pyrolysis   70–80%    10–15%    10–15%
  Torrefaction      0–5%      70–80%    20–25%
  Carbonization     0–5%      80–90%    10–15%

Slow Pyrolysis (Carbonization):
  Temperature: 300–500°C
  Heating rate: 1–10°C/min
  Residence time: hours to days
  Primary product: BIOCHAR
  Traditional: charcoal kilns (30% yield)
  Modern: retort kilns (35–40% yield)

Fast Pyrolysis:
  Temperature: 450–550°C (optimal ~500°C)
  Heating rate: 100–1000°C/sec
  Vapor residence time: <2 seconds (critical!)
  Primary product: BIO-OIL
  Reactor types: fluidized bed, ablative, rotating cone
  Rapid quenching needed to prevent secondary cracking

Bio-oil Properties:
  Water content:     15–30%
  pH:                2–3 (very acidic, corrosive)
  Heating value:     16–19 MJ/kg (vs 42 for diesel)
  Density:           1.2 kg/L (heavier than water!)
  Viscosity:         25–1000 cP (varies hugely)
  Aging:             polymerizes over time, viscosity increases
  Not miscible with petroleum fuels
  Requires upgrading (hydrodeoxygenation) for engine use

Biochar Applications:
  Soil amendment:     Increases water retention, CEC, pH
  Carbon sequestration: stable for 100–1000 years
  Animal feed additive: toxin binding
  Water filtration:    Activated biochar
  Building material:   Concrete additive
  Carbon value: 2.5–3.0 tons CO₂ per ton biochar

Torrefaction:
  "Coffee roasting" of biomass — mild pyrolysis
  Temperature: 200–300°C, 15–60 minutes
  Product: hydrophobic, grindable solid
  Energy density: 20–23 MJ/kg (vs 18 raw wood)
  Mass loss: 20–30%, energy loss: 10%
  Perfect pre-treatment for co-firing with coal
EOF
}

cmd_pellets() {
    cat << 'EOF'
=== Biomass Pelletization ===

Wood pellets are compressed biomass fuel — standardized, energy-dense,
easy to transport, store, and automate.

Production Process:
  1. Reception & screening    Remove contaminants, oversize
  2. Drying                   From 40-55% MC to 10-12% MC
                              (rotary drum or belt dryer)
  3. Grinding                 Hammer mill to 2-4mm particles
  4. Conditioning             Steam injection, 10-20 sec at 100°C
                              Softens lignin (natural binder)
  5. Pelleting                Ring die or flat die press
                              Pressure: 150-300 MPa
                              Die temperature: 80-120°C
  6. Cooling                  Counter-flow cooler → <5°C above ambient
  7. Screening                Remove fines (<3.15mm)
  8. Bagging/bulk storage     15kg bags or bulk silo

ENplus Quality Standards:
  Property          A1 (premium)    A2          B (industrial)
  ─────────         ────────────    ──          ─────────────
  Diameter          6 or 8 mm      6 or 8 mm   6 or 8 mm
  Length            3.15–40 mm     3.15–40 mm  3.15–40 mm
  Moisture          ≤10%           ≤10%        ≤10%
  Ash               ≤0.7%          ≤1.2%       ≤2.0%
  Durability        ≥98.0%         ≥97.5%      ≥97.5%
  Fines (<3.15mm)   ≤1.0%          ≤1.0%       ≤1.0%
  Net calorific     ≥16.5 MJ/kg   ≥16.5       ≥16.5
  Nitrogen          ≤0.3%          ≤0.5%       ≤1.0%
  Chlorine          ≤0.02%         ≤0.02%      ≤0.03%

Die Specifications:
  Hole diameter:    6mm (residential) or 8mm (industrial)
  Press channel L/D ratio: 4:1 to 6:1 (higher = more compression)
  Roller gap: 0.5–1.5 mm
  Die wear: 2,000–5,000 hours lifespan

Energy for Pelletizing:
  Drying:           ~70% of total energy
  Grinding:         ~15%
  Pelleting:        ~12%
  Cooling/handling:  ~3%
  Total: 10-15% of pellet energy content

Global Pellet Market:
  Production: ~50 million tons/year (2023)
  Top producers: USA, Canada, Russia, EU
  Top consumers: UK, Denmark, South Korea, Japan
  Price (2023): €250-400/ton (FOB port)
  Trade: 25+ million tons/year cross-border
EOF
}

cmd_emissions() {
    cat << 'EOF'
=== Biomass Emissions ===

Biomass combustion emits pollutants that require management.
Different from fossil fuels in composition and mitigation.

Emission Types:

  Particulate Matter (PM):
    Major issue for biomass — 10-100× higher than gas
    PM2.5 (fine): health concern, penetrates lungs
    Sources: incomplete combustion, ash entrainment, condensables
    Small stoves: 50–500 mg/Nm³ (uncontrolled)
    Modern boiler: 20–50 mg/Nm³ (with ESP or bag filter)
    EU limit (MCP): 20–50 mg/Nm³ depending on size

  NOx (Nitrogen Oxides):
    Fuel-NOx: from nitrogen in biomass (dominant)
    Thermal-NOx: from air at >1300°C (minor for biomass)
    Wood: 100–250 mg/Nm³ typical
    Straw/grass: 300–600 mg/Nm³ (higher fuel-N)
    Mitigation: air staging, SNCR (urea injection), SCR

  CO (Carbon Monoxide):
    Indicator of incomplete combustion
    Well-operated boiler: <100 mg/Nm³
    Poorly operated: >1000 mg/Nm³
    Mitigation: proper air supply, mixing, temperature

  SO₂ (Sulfur Dioxide):
    Biomass sulfur very low (0.01–0.1%)
    Usually not an issue — 10–50 mg/Nm³
    Exception: some agricultural residues, distillers grains

  HCl (Hydrogen Chloride):
    From chlorine in biomass (straw, grass, RDF)
    Causes corrosion in boilers at >450°C
    Mitigation: limit Cl in fuel blend, lower steam temp

  Dioxins/Furans (PCDD/F):
    Form at 200–400°C in presence of Cl + Cu catalyst
    Prevention: maintain >850°C, 2 sec residence
    Activated carbon injection for post-combustion control

Control Technologies:
  Cyclone:          PM >10μm, simple, low cost
  Multicyclone:     PM >5μm, 70–90% removal
  Electrostatic P.: PM >0.1μm, 95–99%, higher CAPEX
  Bag filter:       PM >0.1μm, 99%+, handles sticky particles
  Scrubber:         HCl, SO₂, PM, combined removal
  SCR:              NOx >85% reduction, needs 300–400°C
  SNCR:             NOx 40–70%, urea/ammonia at 900–1000°C
EOF
}

cmd_sizing() {
    cat << 'EOF'
=== Biomass Plant Sizing ===

Fuel Consumption:
  Fuel rate (kg/h) = Thermal output (kW) / (HHV × η)
  
  Example: 1 MW thermal boiler, wood chips (MC=35%)
    HHV_wet = 20 × 0.65 - 2.44 × 0.35 = 12.15 MJ/kg
    η (boiler) = 0.85
    Fuel = 1000 / (12150/3600 × 0.85) = 348 kg/h
    Annual (7500 h): 2,610 tons/year

Boiler Sizing Rules of Thumb:
  Residential heating: 40–60 W/m² floor area
  Commercial: 60–100 W/m² (depending on insulation)
  Industrial process heat: direct calculation from process need
  
  200m² house → 10–12 kW boiler
  1000m² building → 60–100 kW boiler
  Buffer tank: 30–50 L per kW boiler capacity

Storage Requirements:
  Pellets:  volume = annual consumption / bulk density
            10kW house ≈ 5 tons/yr ≈ 8 m³ silo
  Chips:    2.5–3× volume of pellets for same energy
            Covered storage essential (moisture management)
  
  Rule: 1 MW boiler needs ~3,000 tons/year of green chips
        → ~300m³ storage for 2-week supply

Electrical Generation:
  Steam turbine ORC (Organic Rankine Cycle):
    Thermal input → 15–20% electrical efficiency
    1 MW thermal → 150–200 kW electrical
    Viable above 500 kW thermal
  
  Steam turbine (conventional):
    Viable above 2 MW electrical
    25–30% efficiency (biomass scale)
    Need dry fuel for high steam temperatures

District Heating Pipe Sizing:
  Supply: 80–90°C, Return: 50–60°C (ΔT = 30°C)
  Capacity = ṁ × cp × ΔT
  Rule: DN80 pipe ≈ 1 MW at ΔT=30°C
  Pre-insulated pipes: heat loss 10–15 W/m

Economic Rules:
  Heat density: >2 MWh/year per meter of pipe (viable DH)
  Plant utilization: >4,000 full-load hours for good economics
  Backup boiler: 100% of peak (oil/gas for redundancy)
  Peak shaving: biomass covers base load (50–60% of peak)
EOF
}

show_help() {
    cat << EOF
biomass v$VERSION — Biomass Energy Reference

Usage: script.sh <command>

Commands:
  intro        Biomass energy overview and conversion pathways
  feedstocks   Heating values, moisture, ash, composition
  combustion   Boiler types, air staging, efficiency factors
  gasification Syngas production, gasifier types, tar management
  pyrolysis    Slow/fast/flash pyrolysis, bio-oil, biochar
  pellets      Pelletization process and ENplus quality standards
  emissions    PM, NOx, CO emissions and control technologies
  sizing       Plant sizing, fuel consumption, storage rules
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    feedstocks)  cmd_feedstocks ;;
    combustion)  cmd_combustion ;;
    gasification) cmd_gasification ;;
    pyrolysis)   cmd_pyrolysis ;;
    pellets)     cmd_pellets ;;
    emissions)   cmd_emissions ;;
    sizing)      cmd_sizing ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "biomass v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
