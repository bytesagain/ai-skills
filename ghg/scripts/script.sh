#!/usr/bin/env bash
# ghg — Greenhouse Gas Accounting Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Greenhouse Gases ===

Greenhouse gases trap heat in Earth's atmosphere. Human activities have
increased atmospheric GHG concentrations to levels not seen in 800,000 years.

Major Greenhouse Gases:
  Gas           Formula   GWP-100   Atmospheric Life   Concentration
  Carbon dioxide CO₂      1         300-1000 years     421 ppm (2023)
  Methane       CH₄       28-34     12 years           1,923 ppb
  Nitrous oxide N₂O       265-298   121 years          336 ppb
  HFCs          Various   12-14,800 1-270 years        varies
  PFCs          Various   7,390-12,200  2,600-50,000 yr varies
  SF₆                     23,500    3,200 years        varies
  NF₃                     17,200    740 years           varies

  GWP-100 = Global Warming Potential over 100 years (relative to CO₂)

Global Emissions (2022):
  Total: ~53 GtCO₂e (gigatons CO₂ equivalent)

  By gas:
    CO₂ (fossil + industrial): 37.5 Gt (71%)
    CO₂ (land use change):     3.3 Gt (6%)
    CH₄:                       9.5 Gt CO₂e (18%)
    N₂O:                       2.6 Gt CO₂e (5%)
    F-gases:                   1.3 Gt CO₂e (2%)

  By sector:
    Energy (electricity/heat):  25%
    Transport:                  16%
    Industry:                   21%
    Buildings:                  6%
    Agriculture/forestry:       22%
    Waste:                      3%
    Other:                      7%

CO₂ Equivalent (CO₂e):
  Converts all GHGs to a common unit
  CO₂e = mass of gas × GWP of gas
  Example: 1 ton CH₄ = 28 tons CO₂e (using GWP-100)

Carbon Budget (remaining for 1.5°C):
  ~300 Gt CO₂ from 2023 (50% probability)
  At current rates: exhausted by ~2029
  For 2°C: ~900 Gt CO₂ remaining
EOF
}

cmd_scopes() {
    cat << 'EOF'
=== Scope 1, 2, 3 Emissions ===

The GHG Protocol defines three scopes to categorize emissions.

--- Scope 1: Direct Emissions ---
  Sources the company OWNS or CONTROLS

  Examples:
    - Combustion in owned boilers, furnaces, vehicles
    - Chemical production processes
    - Fugitive emissions (refrigerant leaks, gas pipelines)
    - Company fleet fuel consumption

  Calculation: Fuel quantity × Emission factor
  Example: 10,000 L diesel × 2.68 kg CO₂/L = 26.8 tonnes CO₂

--- Scope 2: Indirect Energy Emissions ---
  From purchased electricity, steam, heating, or cooling

  Two methods:
    Location-based: Grid average emission factor
      Example: 1,000 MWh × 0.4 kg CO₂/kWh = 400 tonnes CO₂

    Market-based: Supplier-specific factor
      With renewable energy certificate: may be near zero
      Without: residual mix factor (often higher than grid avg)

  Must report BOTH methods per GHG Protocol Scope 2 Guidance

--- Scope 3: Value Chain Emissions ---
  All other indirect emissions (typically 70-90% of total!)

  Upstream (15 categories):
    1. Purchased goods and services
    2. Capital goods
    3. Fuel- and energy-related activities (not in 1 or 2)
    4. Upstream transportation and distribution
    5. Waste generated in operations
    6. Business travel
    7. Employee commuting
    8. Upstream leased assets

  Downstream (15 categories):
    9. Downstream transportation and distribution
    10. Processing of sold products
    11. Use of sold products (often largest for energy/tech)
    12. End-of-life treatment of sold products
    13. Downstream leased assets
    14. Franchises
    15. Investments (financial institutions)

--- Typical Distribution ---
  Consumer goods company: Scope 3 = 90%+ of total
  Manufacturing company:  Scope 1+2 = 30-40%, Scope 3 = 60-70%
  Financial institution:  Scope 3 (financed emissions) = 99%+
  Software company:       Scope 2 (data centers) = major, Scope 3 = employee travel
EOF
}

cmd_factors() {
    cat << 'EOF'
=== Emission Factors ===

--- Fuel Combustion (kg CO₂ per unit) ---
  Natural gas:     2.02 kg CO₂/m³     (56.1 kg CO₂/GJ)
  Diesel:          2.68 kg CO₂/L      (74.1 kg CO₂/GJ)
  Gasoline:        2.31 kg CO₂/L      (69.3 kg CO₂/GJ)
  LPG:             1.51 kg CO₂/L      (63.1 kg CO₂/GJ)
  Coal (bitum.):   2,260 kg CO₂/t     (94.6 kg CO₂/GJ)
  Jet fuel (A-1):  2.53 kg CO₂/L      (71.5 kg CO₂/GJ)
  Fuel oil (HFO):  3.11 kg CO₂/L      (77.4 kg CO₂/GJ)
  Wood pellets:    0 kg CO₂ (biogenic) — lifecycle varies

--- Electricity Grid Factors (kg CO₂/kWh, 2022 approx.) ---
  World average:     0.436
  China:             0.555
  India:             0.708
  USA:               0.386
  EU average:        0.230
  Germany:           0.350
  France:            0.055 (nuclear dominant)
  UK:                0.207
  Norway:            0.019 (hydro dominant)
  Australia:         0.660
  Japan:             0.457
  Brazil:            0.075 (hydro dominant)

--- Transport (kg CO₂ per passenger-km or tonne-km) ---
  Passenger:
    Short-haul flight:     0.255 kg CO₂/pax-km
    Long-haul flight:      0.150 kg CO₂/pax-km
    Car (average):         0.170 kg CO₂/pax-km
    Bus:                   0.089 kg CO₂/pax-km
    Train (diesel):        0.041 kg CO₂/pax-km
    Train (electric):      0.006 kg CO₂/pax-km (varies by grid)
    Electric car:          0.050 kg CO₂/pax-km (grid-dependent)

  Freight:
    Road (truck):          0.062 kg CO₂/t-km
    Rail:                  0.022 kg CO₂/t-km
    Container ship:        0.008 kg CO₂/t-km
    Air freight:           0.602 kg CO₂/t-km

--- Materials (kg CO₂e per kg product) ---
  Steel:            1.8 (BOF) / 0.4 (EAF with scrap)
  Aluminum:         8-12 (primary) / 0.5-1.0 (recycled)
  Cement:           0.6 - 0.9
  Plastics (avg):   2.0 - 3.5
  Glass:            0.7 - 1.2
  Paper:            0.8 - 1.5
  Concrete:         0.1 - 0.2
  Copper:           3.5 - 5.0
EOF
}

cmd_protocol() {
    cat << 'EOF'
=== GHG Protocol ===

The most widely used GHG accounting standard, developed by WRI + WBCSD.

--- Core Standards ---
  1. Corporate Standard (2004, rev. 2015)
     - Company-wide GHG inventory
     - Scope 1 and 2 (mandatory)
     - Operational vs equity share boundary

  2. Scope 3 Standard (2011)
     - Value chain emissions (15 categories)
     - Guidance on materiality screening
     - Calculation approaches by category

  3. Product Standard (2011)
     - Lifecycle GHG of individual products
     - Cradle-to-grave or cradle-to-gate

  4. Scope 2 Guidance (2015)
     - Dual reporting (location + market-based)
     - Quality criteria for contractual instruments

--- Five Principles ---
  Relevance:     Include all material emissions sources
  Completeness:  Account for all sources within boundary
  Consistency:   Enable meaningful comparison over time
  Transparency:  Document methodology, assumptions, data
  Accuracy:      Reduce uncertainties as much as practical

--- Organizational Boundaries ---
  Equity share:   Account for GHG based on % ownership
  Control:        Operational control (most common) or
                  Financial control

--- Base Year ---
  Fixed base year: recalculate when structural changes occur
  Rolling base year: less common, update regularly
  Recalculate if: acquisitions, methodology change, error > 5%

--- Calculation Approaches ---
  Tier 1: Emission factors (simplest, least accurate)
    Emissions = Activity data × Emission factor

  Tier 2: Country/region-specific factors
    More accurate for local context

  Tier 3: Direct measurement or modeling
    CEMS (Continuous Emission Monitoring)
    Mass balance
    Most accurate but most expensive

--- Data Quality ---
  Primary data:    Direct measurement, utility bills
  Secondary data:  Industry averages, EEIO models
  Uncertainty:     Always report data quality assessment
  Improvement:     Start rough (Scope 3), refine over time
EOF
}

cmd_calculate() {
    cat << 'EOF'
=== GHG Calculation Methods ===

--- Basic Formula ---
  GHG emissions = Activity data × Emission factor × GWP

  Example: Natural gas consumption
    Activity: 50,000 m³/year
    EF: 2.02 kg CO₂/m³ (combustion)
    GHG: 50,000 × 2.02 = 101,000 kg = 101 t CO₂

--- Scope 1 Calculations ---

  Stationary combustion:
    Emissions = Fuel consumed (GJ) × EF (kg CO₂/GJ)
    Include: CO₂ + CH₄ + N₂O (convert to CO₂e)

  Mobile combustion:
    Emissions = Fuel consumed (L) × EF (kg CO₂/L)
    Or: Distance (km) × EF (kg CO₂/km) for fleet average

  Fugitive emissions:
    Refrigerant: Charge × Leak rate × GWP
    Example: 50 kg R-410A × 5% leak × 2,088 GWP = 5,220 kg CO₂e

  Process emissions:
    Cement: CaCO₃ → CaO + CO₂ (0.51 t CO₂/t clinker)
    Aluminum: electrolysis PFC emissions

--- Scope 2 Calculations ---

  Location-based:
    Emissions = Electricity (kWh) × Grid EF (kg CO₂/kWh)
    Example: 2,000 MWh × 0.4 = 800 t CO₂

  Market-based:
    With RECs/GOs: Emissions = 0 (if covering 100%)
    Without: Use residual mix factor (higher than grid average)
    Supplier-specific: Use utility disclosure factor

--- Scope 3 Calculations ---

  Category 1 (Purchased goods):
    Spend-based: Spend ($) × EEIO factor (kg CO₂/$)
    Average-data: Mass (kg) × cradle-to-gate EF
    Supplier-specific: Use vendor's reported data (best)

  Category 6 (Business travel):
    Flights: Distance × cabin class factor
    Short-haul economy: 0.255 kg CO₂/pax-km
    Long-haul business: 0.424 kg CO₂/pax-km
    Add Radiative Forcing Index (RFI = 1.9) for aviation

  Category 7 (Employee commuting):
    Employees × average distance × mode factor × working days

  Category 11 (Use of sold products):
    Products sold × lifetime energy use × grid factor
    Example: 1M laptops × 40 kWh/yr × 5 yr × 0.4 = 80,000 t CO₂

--- Unit Conversions ---
  1 GJ = 277.78 kWh
  1 therm = 105.5 MJ
  1 barrel oil = 6.12 GJ
  1 MWh = 3.6 GJ
  1 Mt = 1,000,000 tonnes
  1 Gt = 1,000,000,000 tonnes
EOF
}

cmd_reporting() {
    cat << 'EOF'
=== GHG Reporting Frameworks ===

--- CDP (formerly Carbon Disclosure Project) ---
  Annual questionnaire for companies
  Scored A to D- (plus F for non-disclosure)
  Climate change, water, forests questionnaires
  9,000+ companies reporting (2023)
  Increasingly used by investors and procurement
  Aligned with TCFD recommendations

--- TCFD (Task Force on Climate-Related Financial Disclosures) ---
  Four pillars:
    1. Governance:   Board/management oversight of climate risks
    2. Strategy:     Climate risks and opportunities, scenario analysis
    3. Risk mgmt:    How climate risks are identified and managed
    4. Metrics:      GHG emissions (Scope 1, 2, 3), targets

  Scenario analysis:
    1.5°C, 2°C, 4°C warming scenarios
    Physical risks: extreme weather, sea level, drought
    Transition risks: policy, technology, market, reputation

--- SBTi (Science Based Targets initiative) ---
  Sets emission reduction targets aligned with Paris Agreement
  Criteria:
    Near-term: 42% reduction by 2030 (1.5°C pathway)
    Long-term: 90% reduction by 2050 + neutralization of residual
    Must cover Scope 1 + 2 + significant Scope 3

  Net-zero standard (2021):
    Deep cuts first (not offsets)
    Residual emissions (< 10%) offset with permanent removal

--- Regulatory Requirements ---
  EU CSRD:     All large EU companies, Scope 1+2+3, from 2024
  SEC (USA):   Proposed rule for public companies, Scope 1+2
  UK SECR:     Large UK companies, Scope 1+2 + intensity metric
  ISSB (IFRS S1/S2): Global baseline, Scope 1+2+3
  California:  Climate disclosure bills (2023), Scope 1+2+3

--- Verification ---
  Limited assurance: procedures to detect material misstatement
  Reasonable assurance: higher level (like financial audit)
  Standards: ISO 14064-3, ISAE 3410
  Third-party verifiers: SGS, Bureau Veritas, DNV, EY, PwC
EOF
}

cmd_reduction() {
    cat << 'EOF'
=== Emission Reduction Strategies ===

--- Energy / Electricity ---
  Switch to renewables (solar, wind, hydro)
  Energy efficiency improvements (LED, insulation, HVAC)
  Green power purchasing agreements (PPAs)
  On-site generation (rooftop solar)
  Battery storage to optimize renewable use
  Potential: -90% Scope 2 emissions

--- Transport ---
  Fleet electrification (BEV, FCEV)
  Route optimization, load consolidation
  Modal shift: road → rail/water
  Sustainable aviation fuel (SAF): -80% vs jet fuel
  Remote work, video conferencing (reduce travel)
  Potential: -50-80% transport emissions

--- Industry ---
  Industrial heat electrification (heat pumps)
  Green hydrogen for steel (DRI-H₂ process)
  CCUS (Carbon Capture, Utilization and Storage)
  Circular economy (reduce virgin material demand)
  Process optimization, waste heat recovery
  Alternative cement (LC3, geopolymer)

--- Buildings ---
  Deep energy retrofit (insulation, windows, HVAC)
  Heat pump heating (COP 3-5)
  Smart building controls
  Net-zero building standards
  Embodied carbon in construction materials

--- Agriculture ---
  Precision fertilizer application (reduce N₂O)
  Livestock feed additives (reduce enteric CH₄)
  Anaerobic digestion of manure
  Regenerative agriculture (soil carbon sequestration)
  Reduced food waste in supply chain

--- Abatement Cost Curve ---
  Negative cost (saves money):  LED, insulation, efficiency
  Low cost ($0-50/t CO₂):      Solar PV, wind, EVs
  Medium cost ($50-100/t):      Heat pumps, green hydrogen
  High cost ($100-300/t):       CCUS, DAC, SAF, green steel
  Very high cost (> $300/t):    Direct air capture (current)
EOF
}

cmd_offsets() {
    cat << 'EOF'
=== Carbon Offsets & Credits ===

--- What Are Carbon Offsets? ---
  1 offset = 1 tonne CO₂e reduced/removed elsewhere
  Used to "neutralize" emissions you can't yet eliminate
  Controversial: some see as license to pollute

--- Types of Offsets ---

  Avoidance/Reduction:
    Renewable energy projects (replacing fossil fuel)
    Energy efficiency programs
    Avoided deforestation (REDD+)
    Methane capture from landfills

  Removal (higher quality):
    Afforestation/reforestation
    Direct Air Capture (DAC)
    Biochar
    Enhanced weathering
    Ocean-based CDR
    BECCS (Bioenergy with CCS)

--- Quality Criteria ---
  Additionality:    Would the project happen without offset funding?
  Permanence:       Will carbon stay stored? (Forests can burn)
  Leakage:          Does reduction shift emissions elsewhere?
  Verification:     Third-party validated?
  No double counting: Only one buyer claims the reduction

--- Standards & Registries ---
  Verra (VCS):          Largest voluntary market standard
  Gold Standard:        Co-benefits focus (SDGs)
  ACR:                  American Carbon Registry
  CAR:                  Climate Action Reserve
  Plan Vivo:            Community-based projects
  Puro.earth:           Engineered carbon removal

--- Market Pricing (2023-2024) ---
  Renewable energy offsets:   $1-10/t CO₂ (low quality)
  Forestry/REDD+:             $5-30/t CO₂
  Improved cookstoves:        $5-15/t CO₂
  Methane capture:            $10-25/t CO₂
  Biochar:                    $100-200/t CO₂
  Direct Air Capture:         $400-1000/t CO₂

--- Controversies ---
  Many forest offsets found non-additional (would have existed anyway)
  Permanence risk: forest fires, political changes
  Over-crediting: baselines inflated → phantom reductions
  Greenwashing: offsets used to avoid real reduction

--- Best Practice ---
  "Mitigation hierarchy":
    1. Reduce emissions first (maximum effort)
    2. Offset only residual unavoidable emissions
    3. Prioritize removal over avoidance credits
    4. Use high-quality, verified credits only
    5. Transparently report: reductions vs offsets separately
    6. Set science-based targets alongside offset strategy
EOF
}

show_help() {
    cat << EOF
ghg v$VERSION — Greenhouse Gas Accounting Reference

Usage: script.sh <command>

Commands:
  intro        Greenhouse gases overview and global emissions
  scopes       Scope 1, 2, 3 definitions and boundaries
  factors      Emission factors for fuels, electricity, transport
  protocol     GHG Protocol standards and principles
  calculate    Calculation methods and examples
  reporting    CDP, TCFD, SBTi, and regulatory frameworks
  reduction    Emission reduction strategies by sector
  offsets      Carbon offsets, credits, and quality criteria
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    scopes)     cmd_scopes ;;
    factors)    cmd_factors ;;
    protocol)   cmd_protocol ;;
    calculate)  cmd_calculate ;;
    reporting)  cmd_reporting ;;
    reduction)  cmd_reduction ;;
    offsets)    cmd_offsets ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "ghg v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
