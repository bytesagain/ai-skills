#!/usr/bin/env bash
# sequestration — Carbon Sequestration Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

cmd_intro() { cat << 'EOF'
=== Carbon Sequestration ===

Carbon sequestration is the process of capturing and storing atmospheric
carbon dioxide (CO₂) to mitigate climate change.

Scale of the Problem:
  Annual CO₂ emissions:        ~37 billion tons (2023)
  Atmospheric CO₂:             ~420 ppm (pre-industrial: 280 ppm)
  Paris Agreement target:      Limit warming to 1.5-2.0°C
  Required removal by 2050:    5-10 billion tons CO₂/year (IPCC)
  Current removal capacity:    ~0.04 billion tons/year

Sequestration Pathways:
  Geological:   Store CO₂ underground in rock formations
  Biological:   Capture via plants, soil, and ocean biology
  Industrial:   Capture from point sources (power plants, cement)
  Direct Air:   Capture CO₂ directly from ambient air (DAC)
  Mineralization: React CO₂ with minerals for permanent storage
  Ocean:        Enhance ocean's natural CO₂ absorption

Key Distinction:
  Carbon Capture: removing CO₂ from a source
  Carbon Storage: putting captured CO₂ somewhere permanent
  CCS: Carbon Capture and Storage (combined)
  CCUS: Carbon Capture, Utilization, and Storage
  CDR: Carbon Dioxide Removal (from atmosphere)

Permanence Spectrum:
  Forests: 10-100 years (fire, logging, disease risk)
  Soil carbon: 10-100 years (reversible with land use change)
  Biochar: 100-1,000 years
  Geological: 1,000-10,000+ years
  Mineralization: 10,000+ years (effectively permanent)
EOF
}

cmd_geological() { cat << 'EOF'
=== Geological Storage ===

Injecting CO₂ deep underground into suitable rock formations.

--- Storage Types ---
  Saline Aquifers:
    Deep (>800m) porous rock filled with salt water
    Largest storage capacity: trillions of tons globally
    CO₂ injected as supercritical fluid (liquid-like density)
    Example: Sleipner (Norway) — 1 million tons/year since 1996

  Depleted Oil/Gas Reservoirs:
    Well-characterized geology (decades of data)
    Existing infrastructure (wells, pipelines)
    Proven seal integrity (held oil/gas for millions of years)
    Capacity: hundreds of billions of tons

  Enhanced Oil Recovery (EOR):
    Inject CO₂ to push out remaining oil
    CO₂ stays underground, oil production extended
    Economic incentive offsets capture cost
    Controversy: enables more oil production
    Example: Permian Basin (Texas) — 30+ years of CO₂ EOR

  Basalt Mineralization:
    CO₂ reacts with basalt rock to form carbonate minerals
    Permanent storage (minerals stable for geological time)
    Example: CarbFix (Iceland) — 95% mineralized within 2 years
    Challenge: requires reactive rock and water availability

--- Trapping Mechanisms ---
  Structural:     CO₂ trapped under impermeable cap rock
  Residual:       CO₂ trapped in pore spaces by capillary forces
  Solubility:     CO₂ dissolves in formation water
  Mineral:        CO₂ reacts with rock to form solid carbonates
  Over time: structural → residual → solubility → mineral (increasingly permanent)

--- Site Selection Criteria ---
  Depth: >800m (CO₂ becomes supercritical, dense)
  Porosity: >10% (space for CO₂)
  Permeability: >10 millidarcies (CO₂ can flow in)
  Cap rock: thick, continuous, low permeability
  Seismicity: low risk of induced seismicity
  Distance: proximity to CO₂ sources
  Capacity: sufficient volume for project lifetime
EOF
}

cmd_biological() { cat << 'EOF'
=== Biological Sequestration ===

Using living systems to capture and store atmospheric CO₂.

--- Forests ---
  Afforestation: planting trees where there were none
  Reforestation: replanting previously forested areas
  Avoided deforestation: protecting existing forests (REDD+)

  Sequestration rates:
    Tropical forest:    5-10 tons CO₂/hectare/year
    Temperate forest:   2-5 tons CO₂/hectare/year
    Boreal forest:      1-2 tons CO₂/hectare/year

  Limitations:
    Saturation: mature forests reach carbon equilibrium
    Permanence: fire, disease, logging release stored carbon
    Land competition: forests vs agriculture
    Monitoring: hard to verify exact carbon stored

--- Soil Carbon ---
  Agricultural soils have lost 50-70% of original carbon
  Regenerative practices can rebuild soil organic carbon:
    Cover cropping:     +0.3-0.8 tons CO₂/ha/year
    No-till farming:    +0.2-0.5 tons CO₂/ha/year
    Compost application: +0.5-1.5 tons CO₂/ha/year
    Agroforestry:       +1-5 tons CO₂/ha/year

  Limitations: reversible if practices stop, hard to measure

--- Biochar ---
  Pyrolysis of biomass → stable charcoal buried in soil
  Permanence: 100-1,000+ years
  Co-benefits: improves soil fertility, water retention
  Production: 350-700°C in oxygen-limited environment
  Potential: 0.5-2 billion tons CO₂/year globally

--- Ocean Sequestration ---
  Ocean alkalinity enhancement:
    Add crushed minerals (olivine, limestone) to ocean
    Increases ocean's capacity to absorb CO₂
    Mimics natural weathering (accelerated)

  Seaweed/kelp farming:
    Fast growth: kelp grows 30-60 cm/day
    Challenge: what happens to carbon when it decomposes?
    Some proposals: sink harvested kelp to deep ocean

  Blue carbon:
    Mangroves, seagrasses, salt marshes
    Store 5-10× more carbon per hectare than terrestrial forests
    Rapidly being destroyed (losing 1-2% per year)
EOF
}

cmd_dac() { cat << 'EOF'
=== Direct Air Capture (DAC) ===

Capture CO₂ directly from ambient air (400+ ppm concentration).
The hardest but most scalable removal pathway.

--- How It Works ---
  Air contains ~0.04% CO₂ (420 ppm) — very dilute
  Must process enormous volumes of air

  Two main approaches:

  Solid Sorbent (Low Temperature):
    Air flows through solid material that binds CO₂
    Heat to 80-120°C to release concentrated CO₂
    Cool and repeat cycle
    Company: Climeworks (Switzerland)
    Energy: ~1,500-2,000 kWh/ton CO₂

  Liquid Solvent (High Temperature):
    Air contacts potassium hydroxide (KOH) solution
    CO₂ reacts: KOH + CO₂ → K₂CO₃
    Heat to 900°C in calciner to release pure CO₂
    Regenerate solvent and repeat
    Company: Carbon Engineering / 1PointFive (Canada/US)
    Energy: ~2,000-2,500 kWh/ton CO₂

--- Costs ---
  Current: $400-600 per ton CO₂ (Climeworks Orca/Mammoth)
  Target: $100-200 per ton CO₂ by 2030-2040
  Ultimate: $50-100 per ton CO₂ (competitive with other mitigation)
  For context: carbon price in EU ETS: ~€80-100/ton (2024)

--- Major Projects ---
  Orca (Climeworks, Iceland):
    4,000 tons CO₂/year (operational 2021)
    Stored via CarbFix mineralization in basalt
    Powered by geothermal energy

  Mammoth (Climeworks, Iceland):
    36,000 tons CO₂/year (under construction)
    10× Orca capacity

  STRATOS (1PointFive, Texas):
    500,000 tons CO₂/year (planned)
    Liquid solvent process
    Would be world's largest DAC facility

  DAC Hub Program (US DOE):
    $3.5 billion for 4 regional DAC hubs
    Each: 1 million+ tons CO₂/year

--- DAC Challenges ---
  Energy: requires 1,500-2,500 kWh per ton CO₂
    Must use clean energy (otherwise net positive emissions)
  Cost: still 4-6× more expensive than needed
  Scale: current capacity is tiny vs needed removal
  Water: some processes need significant water
  Land: large air contactor installations
  Siting: best near clean energy AND geological storage
EOF
}

cmd_industrial() { cat << 'EOF'
=== Industrial Carbon Capture ===

Capturing CO₂ from large point sources before it reaches the atmosphere.

--- Post-Combustion Capture ---
  Capture CO₂ from flue gas AFTER burning fuel
  Most retrofit-friendly (can add to existing plants)

  Amine scrubbing (most common):
    Flue gas bubbles through amine solvent (e.g., MEA)
    Amine absorbs CO₂ at 40-60°C
    Heat solvent to 120°C to release concentrated CO₂
    Regenerate solvent and repeat
    Capture rate: 85-95%
    Energy penalty: 25-40% of plant output

  Other methods:
    Membrane separation, cryogenic separation,
    calcium looping, pressure/vacuum swing adsorption

--- Pre-Combustion Capture ---
  Convert fuel to syngas (CO + H₂) BEFORE combustion
  Shift reaction: CO + H₂O → CO₂ + H₂
  Capture CO₂ from high-concentration stream (easier)
  Burn hydrogen for power (clean)
  Used in: IGCC power plants, hydrogen production

--- Oxy-Fuel Combustion ---
  Burn fuel in pure oxygen instead of air
  Flue gas is mainly CO₂ + H₂O (no nitrogen)
  Condense water → nearly pure CO₂ stream
  No chemical separation needed
  Challenge: air separation unit is expensive

--- Major Emitters (Capture Targets) ---
  Power generation:     CO₂ concentration 12-15%
  Cement production:    CO₂ concentration 14-33%
  Steel production:     CO₂ concentration 15-27%
  Hydrogen (SMR):       CO₂ concentration 15-30%
  Ethanol fermentation: CO₂ concentration ~100% (easiest!)
  Natural gas processing: CO₂ concentration 5-70%

  Higher concentration = easier and cheaper to capture

--- Cost by Source ---
  Ethanol/natural gas processing: $15-25/ton CO₂
  Cement/steel: $50-100/ton CO₂
  Power plants: $50-120/ton CO₂
  Direct air capture: $400-600/ton CO₂

  Lesson: capture from concentrated sources first (cheapest)
EOF
}

cmd_economics() { cat << 'EOF'
=== Carbon Economics ===

--- Carbon Pricing Mechanisms ---

  Carbon Tax:
    Direct price on CO₂ emissions ($/ton)
    Examples: Canada ($65 CAD/ton, rising to $170 by 2030)
              Sweden ($130/ton, highest in world)
    Simple, predictable price signal

  Cap-and-Trade (ETS):
    Government sets emissions cap, issues allowances
    Companies trade allowances on open market
    Price determined by supply/demand
    EU ETS: €80-100/ton (2024), covers ~40% of EU emissions
    California: ~$30/ton

  45Q Tax Credit (US):
    $85/ton for geological storage
    $60/ton for utilization (EOR, building materials)
    $180/ton for DAC + geological storage (IRA 2022)
    Largest incentive for CCS in the world

--- Carbon Offset Markets ---

  Compliance Markets:
    Regulated by government, mandatory participation
    EU ETS, California, RGGI, Korea, China
    ~$900 billion traded/year

  Voluntary Markets:
    Companies/individuals buy offsets voluntarily
    Certifiers: Verra (VCS), Gold Standard, ACR, CAR
    Prices: $5-50/ton (wide range, quality varies)
    Growing rapidly: ~$2 billion/year

--- Offset Quality Criteria ---
  Additionality:  Would it have happened without offset funding?
  Permanence:     How long will carbon stay stored?
  Leakage:        Does activity shift emissions elsewhere?
  Verification:   Can stored carbon be measured and verified?
  Double counting: Is the reduction claimed by multiple parties?

  High quality: geological storage, DAC (permanent, verifiable)
  Lower quality: forestry (impermanence risk), cookstoves (hard to verify)

--- Break-Even Carbon Price ---
  For CCS to be economically viable without subsidies:
    Industrial capture: $50-100/ton (near current EU ETS price)
    DAC: $200-400/ton (not yet viable without subsidies)
    Biological: $10-50/ton (cheapest but least permanent)
EOF
}

cmd_monitoring() { cat << 'EOF'
=== Monitoring & Verification ===

MRV (Monitoring, Reporting, and Verification) ensures claimed
carbon sequestration is real, measurable, and permanent.

--- Geological Storage Monitoring ---

  Subsurface:
    Seismic surveys: track CO₂ plume migration (4D seismic)
    Pressure monitoring: wellhead and reservoir pressure
    Microseismic: detect induced seismicity
    Well logs: monitor injection zone integrity
    Tracer tests: verify CO₂ movement matches models

  Surface:
    Soil gas sampling: detect leakage to surface
    Atmospheric monitoring: CO₂ flux measurements
    Groundwater monitoring: detect CO₂ or brine migration
    Satellite (InSAR): detect surface deformation

  Sleipner (Norway) example:
    Annual seismic surveys since 1996
    CO₂ plume tracked over 25+ years
    No detectable leakage
    Stored 20+ million tons safely

--- Biological Monitoring ---

  Forest carbon:
    Remote sensing (LiDAR, satellite): canopy height, area
    Ground plots: tree diameter, species, wood density
    Allometric equations: tree dimensions → biomass → carbon
    Uncertainty: ±10-30% depending on method

  Soil carbon:
    Direct sampling: auger/core samples at multiple depths
    Lab analysis: dry combustion (most accurate)
    Spectroscopy: NIR/MIR for rapid field estimates
    Challenge: soil carbon varies widely within small areas

--- MRV Standards ---
  ISO 14064: Greenhouse gas accounting standard
  ISO 27914: Geological storage of CO₂
  GHG Protocol: Corporate carbon accounting
  IPCC Guidelines: National greenhouse gas inventories
  Verra VCS: Voluntary carbon market methodology
  Gold Standard: Highest-integrity offset certification

--- Reporting Requirements ---
  Quantify: total CO₂ captured, transported, stored
  Account for: energy used in capture (net sequestration)
  Monitor: storage site for defined period (typically 20-50 years)
  Report: annually to regulatory authority
  Verify: independent third-party verification
  Liability: who is responsible after site closure?
    Typically: operator for 20-50 years, then transfers to state
EOF
}

cmd_projects() { cat << 'EOF'
=== Major CCS Projects Worldwide ===

--- Operating Projects ---

  Sleipner (Norway, 1996-present):
    First commercial CCS project
    1 million tons CO₂/year from natural gas processing
    Stored in Utsira saline formation (North Sea)
    25+ years of safe storage, extensively monitored

  Quest (Canada, 2015-present):
    1.2 million tons CO₂/year from oil sands upgrader
    Stored in Basal Cambrian Sands (2km deep)
    Shell/Chevron/Marathon joint venture

  Boundary Dam (Canada, 2014-present):
    First commercial CCS on a power plant
    1 million tons CO₂/year from coal power
    Used for EOR and saline storage
    Had operational challenges, ran below capacity initially

  Gorgon (Australia, 2019-present):
    Largest CCS project by design capacity
    4 million tons CO₂/year from LNG processing
    Stored in Dupuy Formation (Barrow Island)
    Chevron-operated, had injection issues initially

  Orca (Iceland, 2021-present):
    First commercial DAC plant
    4,000 tons CO₂/year (small but pioneering)
    Climeworks technology, CarbFix mineralization
    Powered by geothermal (near zero-carbon energy)

--- Under Construction / Planned ---

  Mammoth (Iceland): 36,000 tons/year DAC (Climeworks)
  STRATOS (Texas): 500,000 tons/year DAC (1PointFive)
  Northern Lights (Norway): CO₂ transport and storage hub
  HyNet (UK): industrial CCS cluster in northwest England
  Porthos (Netherlands): Rotterdam industrial CCS hub

--- Cumulative Impact ---
  Total operational CCS capacity: ~45 million tons CO₂/year (2024)
  Needed by 2050: 5-10 billion tons/year
  Gap: ~100× current capacity must be built
  Growth rate needed: comparable to solar PV scale-up trajectory
EOF
}

show_help() { cat << EOF
sequestration v$VERSION — Carbon Sequestration Reference

Usage: script.sh <command>

Commands:
  intro        Carbon sequestration overview and pathways
  geological   Geological storage: aquifers, reservoirs, mineralization
  biological   Forests, soil carbon, biochar, ocean sequestration
  dac          Direct Air Capture technology and projects
  industrial   Point-source capture: post/pre-combustion, oxy-fuel
  economics    Carbon pricing, credits, offset markets
  monitoring   MRV frameworks, leakage detection, standards
  projects     Major CCS projects worldwide
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"
case "$CMD" in
    intro) cmd_intro ;; geological) cmd_geological ;; biological) cmd_biological ;;
    dac) cmd_dac ;; industrial) cmd_industrial ;; economics) cmd_economics ;;
    monitoring) cmd_monitoring ;; projects) cmd_projects ;;
    help|--help|-h) show_help ;; version|--version|-v) echo "sequestration v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
