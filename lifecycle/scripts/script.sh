#!/usr/bin/env bash
# lifecycle — Product Lifecycle Analysis Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Lifecycle Assessment (LCA) ===

Lifecycle Assessment is a systematic methodology for evaluating the
environmental impacts of a product, process, or service throughout
its entire life — from raw material extraction to final disposal.

Core Concept: Cradle-to-Grave Analysis
  Raw Materials → Manufacturing → Distribution → Use → End-of-Life

ISO Standards:
  ISO 14040:2006  Principles and framework
  ISO 14044:2006  Requirements and guidelines

System Boundaries:
  Cradle-to-Gate     Raw materials through factory gate
  Cradle-to-Grave    Full lifecycle including disposal
  Cradle-to-Cradle   Full lifecycle with recycling/reuse loop
  Gate-to-Gate       Single manufacturing process only
  Well-to-Wheel      Fuel lifecycle (energy sector)

History:
  1960s    First energy analyses (Coca-Cola, Mobil Chemical)
  1970s    SETAC develops LCA framework
  1990s    ISO 14040 series standardization begins
  1997     ISO 14040 published
  2006     ISO 14040/14044 revised (current versions)
  2010s    Product Environmental Footprint (PEF) by EU
  2020s    Digital LCA tools, AI-assisted data collection

Functional Unit:
  The quantified performance of a product system
  Example: "1000 liters of packaged drinking water delivered"
  All comparisons must use the same functional unit
EOF
}

cmd_phases() {
    cat << 'EOF'
=== Four Phases of LCA (ISO 14040) ===

Phase 1: Goal and Scope Definition
  Define:
    - Purpose of the study (comparison, hotspot, reporting)
    - Functional unit (what is being compared)
    - System boundaries (what's included/excluded)
    - Allocation procedures (how to handle co-products)
    - Impact categories to evaluate
    - Data quality requirements
    - Critical review needs

  Key decisions:
    Cut-off criteria: typically <1% mass, energy, or environmental relevance
    Temporal scope: time period for data collection
    Geographic scope: regional vs global averages

Phase 2: Life Cycle Inventory (LCI)
  Quantify all inputs and outputs:
    Inputs: raw materials, energy, water, land use
    Outputs: products, co-products, emissions, waste

  Data sources:
    Primary: direct measurements from specific processes
    Secondary: databases (ecoinvent, GaBi, USLCI)
    Tertiary: literature, estimates

  Iteration: LCI often requires revisiting goal/scope

Phase 3: Life Cycle Impact Assessment (LCIA)
  Steps:
    1. Classification — assign LCI results to impact categories
    2. Characterization — convert to common unit per category
    3. Normalization (optional) — compare to reference values
    4. Weighting (optional) — rank categories by importance

  Example:
    CO₂ emission → Climate Change category
    1 kg CH₄ = 28 kg CO₂-eq (characterization factor, GWP100)

Phase 4: Interpretation
  - Identify significant issues (hotspots)
  - Completeness, sensitivity, consistency checks
  - Conclusions and recommendations
  - Limitations and uncertainty analysis
  - Communication of results
EOF
}

cmd_impacts() {
    cat << 'EOF'
=== Environmental Impact Categories ===

Global Warming Potential (GWP):
  Unit: kg CO₂-equivalent
  Timeframe: typically GWP100 (100-year horizon)
  Key substances:
    CO₂   = 1 kg CO₂-eq
    CH₄   = 28 kg CO₂-eq (GWP100, AR5)
    N₂O   = 265 kg CO₂-eq
    SF₆   = 23,500 kg CO₂-eq
    HFC-134a = 1,300 kg CO₂-eq

Acidification Potential (AP):
  Unit: kg SO₂-equivalent
  Cause: acid rain from SO₂, NOₓ, NH₃ emissions
  SO₂ = 1.0, NOₓ = 0.7, NH₃ = 1.88 kg SO₂-eq

Eutrophication Potential (EP):
  Unit: kg PO₄³⁻-equivalent
  Cause: nutrient enrichment in water/soil
  Sources: nitrogen, phosphorus from agriculture, wastewater

Ozone Depletion Potential (ODP):
  Unit: kg CFC-11-equivalent
  Cause: stratospheric ozone destruction
  Key substances: CFCs, HCFCs, halons, methyl bromide

Photochemical Ozone Creation Potential (POCP):
  Unit: kg C₂H₄-equivalent (ethylene)
  Cause: ground-level smog from VOCs + NOₓ + sunlight

Abiotic Depletion Potential (ADP):
  Elements: kg Sb-equivalent (antimony reference)
  Fossil fuels: MJ (energy content)
  Measures resource scarcity

Human Toxicity Potential (HTP):
  Unit: kg 1,4-DCB-equivalent
  Carcinogenic and non-carcinogenic effects
  Exposure routes: inhalation, ingestion, dermal

Ecotoxicity:
  Freshwater, marine, terrestrial
  Unit: kg 1,4-DCB-equivalent
  Toxic effects on ecosystems

Water Depletion:
  Unit: m³ water
  Methods: AWARE, Water Footprint Network
  Considers water scarcity index by region

Land Use:
  Unit: m²·year
  Occupation (area × time) and transformation
  Biodiversity impacts
EOF
}

cmd_inventory() {
    cat << 'EOF'
=== Life Cycle Inventory (LCI) ===

Data Collection Process:
  1. Map all unit processes in the system
  2. Collect input/output data for each process
  3. Validate data quality and fill gaps
  4. Calculate total inventory flows

Input Categories:
  Energy:
    Electricity (specify grid mix: country, year)
    Natural gas, coal, oil, biomass
    Renewable: solar, wind, hydro
  Materials:
    Raw materials (ores, biomass, minerals)
    Process chemicals, catalysts
    Water (surface, ground, municipal)
  Land:
    Agricultural, industrial, forestry

Output Categories:
  Products & co-products
  Emissions to air: CO₂, CH₄, NOₓ, SOₓ, PM, VOCs
  Emissions to water: BOD, COD, heavy metals, nutrients
  Emissions to soil: pesticides, heavy metals
  Solid waste: hazardous, non-hazardous, radioactive

Allocation Methods (for co-products):
  Physical allocation:
    By mass, volume, or energy content
    Example: refinery outputs allocated by mass fraction
  Economic allocation:
    By revenue share of co-products
    Preferred when physical relationship unclear
  System expansion (substitution):
    Expand system to include avoided production
    ISO 14044 preferred approach
    Example: surplus electricity from CHP → displaces grid electricity

Major LCI Databases:
  ecoinvent     ~18,000 datasets, Swiss-based, most widely used
  GaBi          ~12,000 datasets, by Sphera
  USLCI         US-specific, by NREL (free)
  ELCD          European reference data (free)
  Agribalyse    French agricultural products
  IDEMAT        Materials-focused, TU Delft

Data Quality Indicators (Pedigree Matrix):
  Reliability, completeness, temporal correlation,
  geographic correlation, technological correlation
  Score 1 (best) to 5 (worst) for each indicator
EOF
}

cmd_circular() {
    cat << 'EOF'
=== Circular Economy & Design Strategies ===

Linear vs Circular:
  Linear:   Take → Make → Dispose
  Circular: Design → Use → Return → Regenerate

The R-Strategies (10R Framework):
  R0  Refuse      Don't use the product; make it redundant
  R1  Rethink     Make product use more intensive (sharing)
  R2  Reduce      Use fewer materials and energy
  R3  Reuse       Use again for same purpose (secondhand)
  R4  Repair      Fix and maintain to extend life
  R5  Refurbish   Restore to good condition
  R6  Remanufacture  Use parts in new product with same function
  R7  Repurpose   Use product or parts for different function
  R8  Recycle     Process materials for new products
  R9  Recover     Incinerate with energy recovery

  Higher R-number = less circular = more resource loss

Design for X Strategies:
  Design for Disassembly (DfD):
    - Use snap-fits instead of adhesives
    - Minimize number of fastener types
    - Make disassembly sequence logical
    - Label material types on components

  Design for Recycling (DfR):
    - Use mono-materials where possible
    - Avoid incompatible material combinations
    - Make materials easily separable
    - Use standard recycling-compatible materials

  Design for Longevity (DfL):
    - Modular design for easy upgrades
    - Timeless aesthetics
    - Durable materials and construction
    - Available spare parts and repair guides

Biological vs Technical Nutrients:
  Biological: materials that safely biodegrade (compost, soil)
  Technical: materials that circulate (metals, plastics, minerals)
  Never mix the two cycles

Material Passports:
  Digital record of materials in a product
  Enables informed end-of-life decisions
  Tracks material composition, origin, recycling potential
EOF
}

cmd_carbon() {
    cat << 'EOF'
=== Carbon Footprint & GHG Protocol ===

GHG Protocol Scopes:
  Scope 1: Direct emissions
    Company-owned sources: boilers, vehicles, furnaces
    Refrigerant leaks, process emissions
    Example: natural gas combustion in factory

  Scope 2: Indirect emissions from purchased energy
    Electricity, steam, heating, cooling
    Two methods:
      Location-based: average grid emission factor
      Market-based: specific supplier/contract factor
    Example: electricity from national grid

  Scope 3: All other indirect emissions (upstream + downstream)
    Upstream:
      Purchased goods & services, capital goods
      Fuel & energy related (not in Scope 1/2)
      Transportation & distribution
      Waste generated, business travel, commuting
    Downstream:
      Processing, use of sold products
      End-of-life treatment, leased assets
      Franchises, investments
    Typically 70-90% of total footprint

Emission Factors (examples):
  Electricity:
    Coal power:   ~1.0 kg CO₂/kWh
    Natural gas:  ~0.4 kg CO₂/kWh
    Solar PV:     ~0.04 kg CO₂/kWh (lifecycle)
    Wind:         ~0.01 kg CO₂/kWh (lifecycle)
    Nuclear:      ~0.012 kg CO₂/kWh (lifecycle)

  Transport:
    Truck:        ~0.1 kg CO₂/tkm
    Rail:         ~0.03 kg CO₂/tkm
    Ship:         ~0.01 kg CO₂/tkm
    Air freight:  ~0.6 kg CO₂/tkm

  Materials (embodied carbon per kg):
    Steel:        1.5-3.0 kg CO₂
    Aluminum:     8-12 kg CO₂ (primary)
    Cement:       0.6-0.9 kg CO₂
    Plastics:     2-6 kg CO₂
    Timber:       -1.5 kg CO₂ (carbon stored)

Carbon Offsetting:
  Types: avoided emissions, removal/sequestration
  Standards: Gold Standard, VCS (Verra), CDM
  Hierarchy: Avoid → Reduce → Offset
EOF
}

cmd_materials() {
    cat << 'EOF'
=== Material Environmental Profiles ===

Embodied Energy (Cradle-to-Gate, MJ/kg):
  Material            Embodied Energy    CO₂ (kg/kg)
  ─────────────────────────────────────────────────────
  Concrete            1.0-1.5            0.13
  Timber (softwood)   7-10               -1.5 (stored)
  Brick               3.0                0.24
  Glass               15-25              0.85
  Steel (primary)     20-35              1.8
  Steel (recycled)    8-12               0.4
  Copper              50-90              3.5
  Aluminum (primary)  170-230            11.0
  Aluminum (recycled) 10-25              0.6
  Titanium            360-600            35
  PET plastic         80-85              3.4
  HDPE plastic        76-80              2.5
  PVC                 55-80              2.0
  Carbon fiber        180-300            25
  Silicon (PV grade)  1000-1500          45

Recyclability Rankings:
  Excellent: aluminum, steel, glass, copper, gold
  Good: PET, HDPE, paper/cardboard
  Moderate: PP, LDPE, concrete (downcycled)
  Poor: composites, mixed plastics, thermosets
  Very Poor: electronics (mixed), textiles (blended)

End-of-Life Pathways:
  Reuse:        lowest impact, maintains product value
  Recycling:    closed-loop (same quality) vs open-loop (downcycled)
  Composting:   biological materials, returns nutrients to soil
  Incineration: energy recovery, but emissions and ash
  Landfill:     last resort, methane from organics, leaching risk

Material Selection Heuristics:
  - Prefer materials with high recycled content availability
  - Favor mono-materials over composites for recyclability
  - Consider local sourcing to reduce transport impacts
  - Assess entire lifecycle, not just embodied energy
  - Factor in service life (durable materials may win overall)
EOF
}

cmd_cases() {
    cat << 'EOF'
=== LCA Case Studies ===

--- Paper vs Plastic Bags ---
  Functional unit: carry 10 kg groceries home
  Paper bag:
    Higher embodied energy (manufacturing)
    More water use and eutrophication
    Biodegradable, recyclable
    Reuse: ~3 times average
  Plastic (HDPE) bag:
    Lower manufacturing impacts per bag
    Fossil resource depletion
    Persistent in environment if littered
    Reuse as bin liner: displaces another bag
  Cotton tote bag:
    Very high manufacturing impacts (water, pesticides)
    Must be reused 131+ times to beat plastic (GWP)
    Organic cotton: 20,000 L water per kg
  Winner: depends on reuse rate and end-of-life management

--- Electric vs Internal Combustion Vehicle ---
  Functional unit: 200,000 km driven over 15 years
  EV (Tesla Model 3 class):
    Manufacturing: ~30% higher (battery production)
    Use phase: depends entirely on electricity grid
    Norway (hydro): 70% lifecycle GWP reduction
    Poland (coal): ~15% lifecycle GWP reduction
    Battery recycling: critical for mineral recovery
  ICE (comparable sedan):
    Lower manufacturing impact
    ~80% of lifecycle GWP from fuel combustion
    Oil change, exhaust system maintenance
  Breakeven: typically 30,000-60,000 km depending on grid

--- Aluminum vs Steel Beverage Can ---
  Functional unit: contain and deliver 330 mL beverage
  Aluminum:
    Higher embodied energy (primary production)
    ~75% recycling rate globally
    Recycled aluminum saves 95% energy
    Infinite recyclability without quality loss
  Steel:
    Lower embodied energy (primary)
    ~85% recycling rate (magnetic separation)
    Recycled steel saves 60-75% energy
    Heavier → more transport energy
  Key insight: recycled content percentage dominates the result

--- LED vs CFL vs Incandescent Lighting ---
  Functional unit: 20,000 hours of 800 lumens
  Incandescent: 1 lamp × 1,000 hr = 20 lamps needed
    ~1,600 kWh electricity, ~1,300 kg CO₂ (US grid)
  CFL: 1 lamp × 10,000 hr = 2 lamps needed
    ~360 kWh electricity, mercury content issue
  LED: 1 lamp × 25,000 hr = 1 lamp needed
    ~200 kWh electricity, electronic waste
  Winner: LED dominates across all impact categories
EOF
}

show_help() {
    cat << EOF
lifecycle v$VERSION — Product Lifecycle Analysis Reference

Usage: script.sh <command>

Commands:
  intro        LCA overview — history, ISO standards, concepts
  phases       Four LCA phases (ISO 14040 framework)
  impacts      Environmental impact categories and units
  inventory    Life Cycle Inventory — data collection and allocation
  circular     Circular economy strategies and design principles
  carbon       Carbon footprint, GHG Protocol, Scope 1/2/3
  materials    Embodied energy and profiles of common materials
  cases        Real-world LCA case studies
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    phases)     cmd_phases ;;
    impacts)    cmd_impacts ;;
    inventory)  cmd_inventory ;;
    circular)   cmd_circular ;;
    carbon)     cmd_carbon ;;
    materials)  cmd_materials ;;
    cases)      cmd_cases ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "lifecycle v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
