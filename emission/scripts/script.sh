#!/usr/bin/env bash
# emission — GHG Emission Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Greenhouse Gas Emissions ===

Greenhouse gases (GHGs) trap heat in the atmosphere, driving
global warming. Human activities have increased atmospheric
CO₂ from 280 ppm (pre-industrial) to 425+ ppm (2024).

Major Greenhouse Gases:
  Gas              GWP-100   Atmospheric life   Main sources
  ───              ───────   ───────────────     ────────────
  CO₂              1         300-1000 years      Fossil fuels, land use
  CH₄ (methane)    28        12 years            Agriculture, gas leaks
  N₂O (nitrous ox) 265      121 years           Fertilizer, industry
  HFCs             150-12400 1-270 years         Refrigeration
  PFCs             7000-12200 2600-50000 years   Electronics, aluminum
  SF₆              23500     3200 years          Electrical switchgear
  NF₃              16100     740 years           Semiconductors

  GWP-100: Global Warming Potential over 100 years (CO₂ = 1)
  CO₂e: CO₂ equivalent = quantity × GWP

Global Emissions (2023):
  Total: ~53 Gt CO₂e/year
  CO₂ from fossil fuels: ~37 Gt
  CO₂ from land use:     ~4 Gt
  CH₄:                   ~9 Gt CO₂e
  N₂O:                   ~3 Gt CO₂e

Carbon Budget (1.5°C target):
  Remaining budget: ~250 Gt CO₂ (from 2024)
  At current rate: ~7 years until exhausted
  Net zero required by: 2050 (IPCC)

Top Emitting Countries (2023):
  China:           30% of global emissions
  United States:   13%
  EU:              7%
  India:           7%
  Russia:          5%
  Japan:           3%
  Rest of world:   35%

  Per capita tells a different story:
    Qatar: 35 t CO₂e/person
    USA:   15 t CO₂e/person
    China: 10 t CO₂e/person
    EU:    7 t CO₂e/person
    India: 2.5 t CO₂e/person
EOF
}

cmd_scopes() {
    cat << 'EOF'
=== Emission Scopes (GHG Protocol) ===

SCOPE 1 — Direct Emissions
  From sources owned or controlled by the organization.
  
  Categories:
    Stationary combustion:  boilers, furnaces, generators
    Mobile combustion:      company vehicles, aircraft, ships
    Process emissions:      chemical reactions (cement clinker)
    Fugitive emissions:     refrigerant leaks, gas pipeline leaks
  
  Examples:
    Factory burns natural gas for heating → Scope 1
    Company truck fleet diesel consumption → Scope 1
    Refrigerant leak from HVAC system → Scope 1

SCOPE 2 — Indirect Energy Emissions
  From purchased electricity, heat, steam, or cooling.
  
  Two methods:
    Location-based: uses grid average emission factor
      Example: 500 MWh × 0.4 kg CO₂/kWh = 200 t CO₂
    
    Market-based: uses contractual instruments
      Green electricity contract (RE certificate) → can be 0
      But: must have matching RECs/GOs/I-RECs
  
  Report BOTH methods per GHG Protocol Scope 2 Guidance.

SCOPE 3 — Other Indirect Emissions
  All other emissions in the value chain (biggest, hardest).
  Typically 70–90% of total emissions for most companies!
  
  Upstream (15 categories):
    1.  Purchased goods & services          (usually largest!)
    2.  Capital goods                       (equipment, buildings)
    3.  Fuel & energy related activities    (upstream of Scope 1&2)
    4.  Upstream transportation             (inbound logistics)
    5.  Waste generated in operations       (landfill, recycling)
    6.  Business travel                     (flights, hotels)
    7.  Employee commuting                  (car, transit)
    8.  Upstream leased assets
  
  Downstream:
    9.  Downstream transportation           (to customer)
    10. Processing of sold products
    11. Use of sold products                (critical for energy/auto)
    12. End-of-life treatment
    13. Downstream leased assets
    14. Franchises
    15. Investments                         (critical for finance)

Materiality:
  Not all 15 categories apply to every organization.
  Screen for relevance, then prioritize by size and influence.
  Rule: categories representing >5% of total should be included.
EOF
}

cmd_factors() {
    cat << 'EOF'
=== Common Emission Factors ===

Electricity (kg CO₂e/kWh, 2023 averages):
  Country/Grid          Location-based
  ──────────            ──────────────
  Australia             0.68
  Brazil                0.08 (hydro-dominant)
  Canada                0.12
  China                 0.56
  France                0.05 (nuclear-dominant)
  Germany               0.35
  India                 0.72
  Japan                 0.45
  Norway                0.01 (hydro)
  South Korea           0.42
  UK                    0.21
  USA (average)         0.38
  USA (Texas-ERCOT)     0.37
  USA (California)      0.22

Fuels (kg CO₂ per unit, combustion only):
  Fuel                  Per unit         Per kWh (LHV)
  ────                  ────────         ────────────
  Natural gas           2.0 kg/m³        0.20 kg/kWh
  Diesel                2.68 kg/L        0.27 kg/kWh
  Gasoline              2.31 kg/L        0.25 kg/kWh
  LPG                   1.51 kg/L        0.23 kg/kWh
  Coal (bituminous)     2.42 kg/kg       0.34 kg/kWh
  Kerosene (jet fuel)   2.53 kg/L        0.26 kg/kWh
  Heating oil           2.68 kg/L        0.27 kg/kWh
  Wood pellets          0* kg/kg         biogenic (report separately)

Transport (kg CO₂e per passenger-km or tonne-km):
  Passenger:
    Domestic flight:     0.25 kg/pkm
    Long-haul flight:    0.15 kg/pkm (+ radiative forcing: ×1.9)
    Car (average):       0.17 kg/pkm
    Electric car:        0.05 kg/pkm (grid-dependent)
    Bus:                 0.06 kg/pkm
    Train (diesel):      0.04 kg/pkm
    Train (electric):    0.01 kg/pkm
  
  Freight:
    Road (truck):        0.10 kg/tkm
    Rail:                0.03 kg/tkm
    Ship (container):    0.01 kg/tkm
    Air cargo:           0.60 kg/tkm

Materials (kg CO₂e per kg material):
  Steel:               1.8 (BF-BOF), 0.4 (EAF-scrap)
  Aluminum:            8–12 (primary), 0.5 (recycled)
  Cement:              0.6–0.9
  Concrete:            0.1–0.2
  Plastics (PE/PP):    2–3
  Glass:               0.6–0.9
  Paper:               0.5–1.5
  Copper:              3–5
EOF
}

cmd_calculation() {
    cat << 'EOF'
=== Emission Calculation Methodology ===

Basic Formula:
  Emissions (tCO₂e) = Activity Data × Emission Factor

  Activity data:    measurable quantity (kWh, L fuel, km, kg material)
  Emission factor:  kg CO₂e per unit of activity

Step-by-Step Process:

  1. Define Boundary
     Organizational: equity share, financial control, operational control
     Operational: which Scopes, which categories
     Temporal: calendar year (Jan-Dec or fiscal year)
  
  2. Collect Activity Data
     Priority sources (highest to lowest accuracy):
       Measured data:    meter readings, fuel receipts, utility bills
       Calculated:       engineering estimates, energy models
       Spend-based:      $ spent × spend-based emission factor
       Average:          industry averages, proxy data
  
  3. Select Emission Factors
     Source priority:
       Supplier-specific: actual data from vendor
       Country/grid:      national grid factors (IEA, EPA)
       LCA databases:     ecoinvent, DEFRA, EPA
       Spend-based:       $/revenue to emission factor (least accurate)
  
  4. Calculate
     Per source × per gas × convert to CO₂e
     CO₂e = CO₂ + (CH₄ × 28) + (N₂O × 265)
  
  5. Quality Check
     Year-over-year comparison
     Intensity metrics (tCO₂e/revenue, /employee, /unit produced)
     Benchmark vs peers
     Identify anomalies (>20% change needs explanation)

Calculation Examples:

  Natural gas heating:
    500,000 m³/year × 2.0 kg CO₂/m³ = 1,000 t CO₂
  
  Electricity:
    2,000 MWh × 0.38 kg CO₂/kWh = 760 t CO₂
  
  Business flights:
    100 flights × 2,000 km avg × 0.15 kg CO₂/pkm = 30 t CO₂
  
  Company vehicles (20 cars):
    20 × 20,000 km × 7 L/100km × 2.31 kg/L = 64.7 t CO₂

Data Quality Scoring:
  High:    metered, invoiced, auditable (±5%)
  Medium:  calculated from activity + standard EF (±15%)
  Low:     spend-based or industry average (±50%)
  Screen:  rough estimate for materiality assessment (±100%)
EOF
}

cmd_reporting() {
    cat << 'EOF'
=== Reporting Frameworks ===

GHG Protocol (foundation for all others):
  Published by WRI + WBCSD
  Three standards:
    Corporate Standard: Scope 1 + 2 (mandatory), Scope 3 (recommended)
    Scope 3 Standard:  detailed guidance for 15 categories
    Product Standard:  lifecycle emissions of specific products
  
  Principles: relevance, completeness, consistency, transparency, accuracy
  Base year: set a reference year, recalculate for structural changes

CDP (Carbon Disclosure Project):
  Annual questionnaire scored A to D-
  13,000+ companies report (2023)
  Investor-driven: $130T in assets request CDP data
  Covers: climate change, water, forests
  Scoring: Leadership (A/A-), Management (B/B-), Awareness (C/C-), Disclosure (D/D-)

TCFD → ISSB / IFRS S2:
  Task Force on Climate-related Financial Disclosures
  Four pillars: Governance, Strategy, Risk Management, Metrics & Targets
  Now superseded by ISSB (IFRS S1 + S2) — mandatory in many jurisdictions
  Focus: financial materiality of climate risks and opportunities

SBTi (Science Based Targets initiative):
  Set emission reduction targets aligned with Paris Agreement
  Near-term target: 42% reduction by 2030 (1.5°C pathway)
  Long-term target: 90% reduction by 2050 + neutralize residual
  Net-zero: >90% reduction + high-quality removals for residual
  FLAG: Forest, Land and Agriculture targets for food/agriculture
  8,000+ companies committed (2024)

EU CSRD (Corporate Sustainability Reporting Directive):
  Mandatory for: all large EU companies + listed SMEs
  ESRS standards: detailed disclosure requirements
  Double materiality: financial + impact perspective
  Assurance: limited assurance required (moving to reasonable)
  Timeline: large companies from 2024, SMEs from 2026

GRI (Global Reporting Initiative):
  GRI 305: Emissions disclosure standard
  Requires: Scope 1, 2, 3, intensity ratios, reductions
  Impact materiality focus (broader than financial)
  Used by 10,000+ organizations globally
EOF
}

cmd_reduction() {
    cat << 'EOF'
=== Emission Reduction Strategies ===

Hierarchy (Avoid → Reduce → Substitute → Compensate):
  1. AVOID:      eliminate the emission source entirely
  2. REDUCE:     improve efficiency, use less
  3. SUBSTITUTE: switch to lower-carbon alternative
  4. COMPENSATE: offset residual emissions (last resort)

Energy & Electricity:
  Switch to renewable electricity (PPA, on-site solar)    → 100% Scope 2
  Install LED lighting + smart controls                   → 30-50% savings
  Building insulation + heat pumps                        → 60-80% heating
  Waste heat recovery                                     → 10-30% thermal
  Energy management systems (ISO 50001)                   → 5-15% total

Transport:
  Electrify vehicle fleet (BEV)                          → 50-70% per vehicle
  Route optimization + telematics                         → 10-20%
  Modal shift: road → rail/water                          → 60-90% per tkm
  Remote work / virtual meetings                          → variable
  Sustainable aviation fuel (SAF)                         → 50-80% per flight

Industry:
  Process electrification                                → depends on grid
  Green hydrogen for high-temp heat                      → 90%+ for process
  Carbon capture and storage                             → 85-95% of stack
  Material efficiency (lightweighting, circular design)  → 20-40%
  Industrial symbiosis (waste = input for another)       → 10-30%

Agriculture & Land Use:
  Reduced tillage + cover crops                          → 20-30% soil
  Precision fertilization                                → 15-30% N₂O
  Methane digesters for livestock waste                   → 60-80% CH₄
  Dietary shift (less ruminant meat)                      → 50-80% per meal
  Reforestation / afforestation                          → carbon sink

Buildings:
  Deep retrofit (insulation + windows + airtightness)    → 50-80%
  Heat pumps (COP 3-4× more efficient than gas)         → 60-75%
  District heating from waste heat / geothermal          → 80-90%
  Passive house standard                                 → 90% vs standard

Supply Chain (Scope 3):
  Supplier engagement programs                           → most impactful
  Low-carbon procurement criteria                        → varies
  Circular economy (repair, reuse, recycle)              → 30-50% material
  Product redesign for longevity                         → lifecycle reduction
EOF
}

cmd_offsets() {
    cat << 'EOF'
=== Carbon Offsets & Credits ===

Carbon offset: 1 credit = 1 ton CO₂e avoided or removed.
Purchased to "compensate" for emissions elsewhere.

Types:
  Avoidance/Reduction:
    Renewable energy projects (wind, solar)
    Methane capture (landfill, coal mine)
    Cookstoves (avoid deforestation/health harm)
    Energy efficiency projects
    REDD+ (avoided deforestation)
  
  Removal:
    Reforestation / afforestation
    Direct Air Capture + storage (DACCS)
    Biochar
    Enhanced weathering
    Ocean alkalinity enhancement
    BECCS (bioenergy with CCS)

Quality Criteria (5 pillars):
  1. Additionality:   Would it have happened without credit revenue?
  2. Permanence:      Will the carbon stay stored? (forest fire risk)
  3. Leakage:         Does protection here cause emissions elsewhere?
  4. Verification:    Is it independently audited and measured?
  5. No double counting: Not claimed by both buyer and host country

Standards:
  Verra (VCS):       Largest registry, 1.5 billion credits issued
  Gold Standard:      Stricter criteria, SDG co-benefits required
  ACR:               American Carbon Registry
  CAR:               Climate Action Reserve
  Plan Vivo:         Community land use projects
  Puro.earth:        Engineered carbon removal

Pricing (2024):
  REDD+ (avoided deforestation):  $5–20/ton
  Renewable energy:               $2–10/ton
  Cookstoves:                     $5–15/ton
  Reforestation:                  $10–30/ton
  Biochar:                        $100–200/ton
  Direct Air Capture:             $400–1,000/ton
  Enhanced weathering:            $50–200/ton

Controversies:
  Permanence risk:    fires, disease, political changes
  Over-crediting:     baseline inflation (credit more than actual reduction)
  Low quality:        "junk credits" that don't represent real reductions
  Greenwashing:       using offsets instead of reducing own emissions
  Additionality:      many RE projects would be built anyway
  
  SBTi position: offsets CANNOT be used toward Scope 1/2/3 targets
  Only for neutralizing RESIDUAL emissions after 90%+ reduction

Best Practice:
  1. Reduce own emissions first (insetting before offsetting)
  2. Use removal credits, not avoidance (higher integrity)
  3. Prioritize verified, high-quality standards
  4. Be transparent about what offsets cover
  5. Aim for "contribution claims" not "neutrality claims"
EOF
}

cmd_sectoral() {
    cat << 'EOF'
=== Emissions by Sector ===

Global GHG by Sector (53 Gt CO₂e/year, 2023):

  Energy (electricity & heat):        25%  (~13 Gt)
    Coal power plants:          ~10 Gt
    Gas power plants:           ~3 Gt
    
  Transport:                          16%  (~8.5 Gt)
    Road (cars & trucks):       ~6 Gt
    Aviation:                   ~1 Gt
    Shipping:                   ~1 Gt
    Rail + other:               ~0.5 Gt
    
  Industry:                           21%  (~11 Gt)
    Iron & steel:               ~2.6 Gt
    Cement:                     ~2.5 Gt
    Chemicals:                  ~2 Gt
    Aluminum:                   ~1 Gt
    Other manufacturing:        ~3 Gt
    
  Buildings:                          6%   (~3 Gt)
    Heating & cooling:          ~2 Gt
    Cooking:                    ~0.5 Gt
    Other:                      ~0.5 Gt
    
  Agriculture:                        12%  (~6 Gt)
    Enteric fermentation (CH₄): ~2 Gt CO₂e
    Rice cultivation (CH₄):    ~1 Gt CO₂e
    Fertilizer (N₂O):          ~1.5 Gt CO₂e
    Manure management:         ~0.5 Gt CO₂e
    Other:                     ~1 Gt CO₂e
    
  Land Use & Forestry:                11%  (~6 Gt)
    Deforestation:             ~4 Gt
    Peatland drainage:         ~1 Gt
    Other land conversion:     ~1 Gt
    
  Waste:                              3%   (~1.5 Gt)
    Landfill (CH₄):           ~0.8 Gt CO₂e
    Wastewater (CH₄, N₂O):   ~0.5 Gt CO₂e
    Incineration:             ~0.2 Gt

Hard-to-Abate Sectors:
  These sectors lack easy decarbonization pathways:
    Aviation:     energy density of kerosene hard to replace
    Shipping:     long voyages, existing fleet, fuel logistics
    Steel:        blast furnace requires coke (reducing agent)
    Cement:       process emissions from CaCO₃ → CaO + CO₂
    Chemicals:    feedstock carbon (plastics, fertilizer)
    Agriculture:  biological processes, dispersed sources
  
  Solutions: green hydrogen, CCS, e-fuels, circular economy,
             alternative materials, dietary shifts
EOF
}

show_help() {
    cat << EOF
emission v$VERSION — GHG Emission Reference

Usage: script.sh <command>

Commands:
  intro        GHG overview, gases, GWP, global budget
  scopes       Scope 1, 2, 3 definitions and categories
  factors      Emission factors: electricity, fuels, transport, materials
  calculation  Activity data × emission factor methodology
  reporting    GHG Protocol, CDP, TCFD/ISSB, SBTi, CSRD
  reduction    Reduction strategies by sector
  offsets      Carbon credits, standards, quality, controversies
  sectoral     Global emissions breakdown by sector
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    scopes)      cmd_scopes ;;
    factors)     cmd_factors ;;
    calculation) cmd_calculation ;;
    reporting)   cmd_reporting ;;
    reduction)   cmd_reduction ;;
    offsets)     cmd_offsets ;;
    sectoral)    cmd_sectoral ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "emission v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
