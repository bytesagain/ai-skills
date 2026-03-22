#!/usr/bin/env bash
# lca — Life Cycle Assessment Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Life Cycle Assessment (LCA) ===

LCA is a systematic method for evaluating the environmental impacts
of a product, process, or service throughout its entire life cycle —
from raw material extraction through disposal or recycling.

Four Phases (ISO 14040):
  1. Goal and Scope Definition
  2. Life Cycle Inventory (LCI)
  3. Life Cycle Impact Assessment (LCIA)
  4. Interpretation

The Life Cycle:
  Raw Materials → Manufacturing → Distribution → Use → End-of-Life
  "Cradle to Grave"

  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌─────────┐
  │ Extraction│───→│Production│───→│   Use    │───→│End of   │
  │(Cradle)  │    │          │    │ Phase    │    │Life     │
  └──────────┘    └──────────┘    └──────────┘    └─────────┘
       ↕                ↕              ↕              ↕
    Energy          Transport       Energy         Recycling
    Water           Chemicals       Maintenance    Landfill
    Land            Waste           Consumables    Incineration

Standards:
  ISO 14040:2006   Principles and framework
  ISO 14044:2006   Requirements and guidelines
  ISO 14067:2018   Carbon footprint of products
  PAS 2050:2011    Assessing GHG of goods and services
  PEF (EU):        Product Environmental Footprint

Applications:
  - Product design (eco-design, green procurement)
  - Environmental Product Declarations (EPD)
  - Policy making (carbon taxes, regulations)
  - Marketing claims (verified environmental labels)
  - Corporate sustainability reporting
  - Comparative assertions (must follow ISO 14044 strictly)

LCA ≠ Carbon Footprint:
  Carbon footprint = one impact category (GWP)
  LCA = multiple impact categories (comprehensive)
  Carbon footprint is a SUBSET of LCA
EOF
}

cmd_phases() {
    cat << 'EOF'
=== Four Phases of LCA ===

--- Phase 1: Goal and Scope Definition ---
  Define:
    Goal:            Why are you doing this LCA?
    Intended use:    Decision support, EPD, comparison?
    Audience:        Internal, public, regulatory?
    Functional unit: What does the product DO? (quantified)
    System boundary: What's included and excluded?
    Allocation:      How to divide impacts in multi-product systems?
    Data quality:    Requirements for data sources

  Functional Unit Examples:
    ✗ "One plastic bag" (not functional)
    ✓ "Carrying 10 kg of groceries from store to home"
    ✗ "One light bulb" (not functional)
    ✓ "Providing 1,000 hours of 800 lumen illumination"
    ✗ "One liter of paint" (not functional)
    ✓ "Protecting 1 m² of exterior wall for 10 years"

--- Phase 2: Life Cycle Inventory (LCI) ---
  Quantify ALL inputs and outputs for each process:

  Inputs:                 Outputs:
    Raw materials           Products
    Energy (MJ, kWh)        Co-products
    Water (m³)              Emissions to air
    Land use (m²·yr)        Emissions to water
    Transport (t·km)        Solid waste

  Data sources:
    Primary: measured data from actual processes
    Secondary: databases (ecoinvent, GaBi, ELCD)
    Tertiary: literature, estimates

  Mass/energy balance:
    Inputs must equal outputs (conservation laws)
    Discrepancies indicate missing flows

--- Phase 3: Life Cycle Impact Assessment (LCIA) ---
  Convert inventory flows to environmental impacts

  Steps:
    1. Classification:   Assign flows to impact categories
       CO₂ → Climate Change
       SO₂ → Acidification
       PO₄³⁻ → Eutrophication

    2. Characterization:  Quantify contribution using factors
       CO₂: CF = 1 kg CO₂e/kg
       CH₄: CF = 28 kg CO₂e/kg
       N₂O: CF = 265 kg CO₂e/kg

    3. Normalization:    Compare to reference (optional)
       Per-capita annual impact, regional reference

    4. Weighting:        Assign importance to categories (optional)
       Controversial: implies value judgments

--- Phase 4: Interpretation ---
  Identify significant issues from LCI and LCIA
  Sensitivity analysis: how robust are results?
  Consistency check: were methods applied uniformly?
  Completeness check: are significant flows missing?
  Conclusions and recommendations
  Limitations disclosure
EOF
}

cmd_impacts() {
    cat << 'EOF'
=== Impact Categories ===

--- Midpoint Categories (cause-oriented) ---

  Climate Change (Global Warming Potential - GWP):
    Unit: kg CO₂ equivalent
    Characterization: 100-year GWP (IPCC)
    Substances: CO₂ (1), CH₄ (28), N₂O (265), HFCs, SF₆
    Most commonly reported single impact category

  Ozone Depletion (ODP):
    Unit: kg CFC-11 equivalent
    Substances: CFCs, HCFCs, halons
    Montreal Protocol has largely addressed this

  Acidification:
    Unit: kg SO₂ equivalent
    Substances: SO₂ (1), NOx (0.7), NH₃ (1.88), HCl
    Effects: acid rain, soil/water acidification, forest damage

  Eutrophication:
    Unit: kg PO₄³⁻ equivalent (or kg N equivalent)
    Substances: phosphorus, nitrogen compounds
    Effects: algal blooms, oxygen depletion, dead zones

  Photochemical Ozone Formation (Smog):
    Unit: kg NMVOC equivalent (or kg ethylene eq.)
    Substances: VOCs, NOx, CO
    Effects: ground-level ozone, respiratory issues

  Human Toxicity:
    Unit: CTUh (Comparative Toxic Units for humans)
    Cancer and non-cancer separately
    Substances: heavy metals, pesticides, organic chemicals
    Method: USEtox model

  Ecotoxicity:
    Unit: CTUe (Comparative Toxic Units for ecosystems)
    Freshwater ecotoxicity most commonly assessed
    Heavy metals, pesticides, PAHs

  Resource Depletion:
    Mineral resources: kg Sb equivalent (antimony)
    Fossil resources: MJ surplus energy
    Water use: m³ water equivalent

  Land Use:
    Unit: m²·year (area × time)
    Land occupation and transformation
    Biodiversity impact

--- Endpoint Categories (damage-oriented) ---
  Human Health:         DALY (Disability-Adjusted Life Years)
  Ecosystem Quality:    Species·year (potentially disappeared)
  Resource Scarcity:    $ (future extraction cost increase)

--- Common LCIA Methods ---
  CML 2001:       Midpoint, widely used, European
  ReCiPe 2016:    Midpoint + endpoint, global
  TRACI:          US-specific midpoints (EPA)
  IMPACT World+:  Global, regionalized
  EF 3.0/3.1:     EU Product Environmental Footprint
EOF
}

cmd_inventory() {
    cat << 'EOF'
=== Life Cycle Inventory (LCI) ===

--- Data Collection Process ---
  1. Define process flow diagram (all unit processes)
  2. Identify all inputs and outputs per process
  3. Collect primary data (measurements, bills, records)
  4. Fill gaps with secondary data (databases)
  5. Validate with mass/energy balance
  6. Document data quality for each flow

--- Primary Data Sources ---
  Utility bills (electricity, gas, water)
  Purchase records (raw materials, chemicals)
  Production logs (yields, waste, emissions)
  Transport records (distances, modes, weights)
  Waste manifests (quantities, disposal methods)
  Emission measurements (stack tests, CEMS)

--- LCI Databases ---
  ecoinvent:
    Largest LCI database (~18,000 datasets)
    Global + regionalized data
    System model: consequential & attributional
    License: paid (~$3,000/year academic)

  GaBi:
    Integrated with GaBi software
    Strong in energy, chemicals, metals
    Industry-specific datasets
    License: paid (with software)

  ELCD (European):
    European Life Cycle Database
    Free, EU-focused
    Limited scope but good quality

  USLCI (US):
    US-specific LCI data
    Free, maintained by NREL
    Growing coverage

  Agri-footprint:
    Agricultural products
    Global coverage
    Linked to ecoinvent

--- Allocation Methods ---
  When a process produces MULTIPLE products:

  Physical allocation:
    By mass: 60% cement, 40% slag → 60/40 split
    By energy content: useful for fuels
    Simple but may not reflect economic reality

  Economic allocation:
    By revenue: high-value product gets more burden
    Reflects market reality
    Volatile (prices change)

  System expansion (avoided burden):
    Preferred by ISO 14044
    Credit for displacing alternative product
    Example: waste incineration → electricity credit
    Most accurate but complex

  Cut-off:
    Recycled material enters system burden-free
    Burden stays with original product
    Simple, commonly used for recycled content

--- Data Quality Indicators ---
  Temporal:        How recent is the data?
  Geographical:    Does it match the study region?
  Technological:   Does it match the actual technology?
  Completeness:    Are all relevant flows included?
  Reliability:     Measured vs estimated vs literature?
  Pedigree matrix: Score 1-5 on each dimension
EOF
}

cmd_boundaries() {
    cat << 'EOF'
=== System Boundaries ===

--- Cradle-to-Grave (Full LCA) ---
  Extraction → Production → Distribution → Use → End-of-Life
  Most comprehensive assessment
  Required for comparative assertions (ISO 14044)
  Includes disposal/recycling impacts
  Use phase often dominates (energy-consuming products)

  Example: Smartphone
    Cradle: Mining rare earths, lithium, copper
    Gate: Circuit board fab, assembly, packaging
    Distribution: Shipping from factory to store
    Use: 2-3 years of charging (electricity)
    Grave: E-waste recycling or landfill

--- Cradle-to-Gate ---
  Extraction → Production (stop at factory gate)
  Most common for B2B products and EPDs
  Excludes use phase (varies by user)
  Excludes end-of-life (uncertain)

  Example: Steel production
    Iron ore mining → blast furnace → steel slab
    Report: 1.8 kg CO₂/kg steel (gate)

--- Gate-to-Gate ---
  Single manufacturing process only
  Most limited scope
  Useful for factory-level improvements
  Example: just the painting process in car manufacturing

--- Cradle-to-Cradle ---
  Circular economy concept
  End-of-life feeds back into new product
  Recycling loop explicitly modeled
  Challenging to model: multiple product lives

--- Well-to-Wheel (Transport) ---
  Fuel production (well) → vehicle operation (wheel)
  Well-to-Tank + Tank-to-Wheel
  Standard for comparing vehicle/fuel options

  Well-to-Wheel emissions (g CO₂e/km):
    Gasoline car:     200-250 (WTW)
    Diesel car:       180-230 (WTW)
    BEV (EU grid):    50-80 (WTW)
    BEV (coal grid):  100-150 (WTW)
    BEV (renewable):  5-15 (WTW)
    FCEV (green H₂):  30-60 (WTW)

--- What to Include/Exclude ---
  Always include:
    ✓ All significant mass/energy flows (> 1% of total)
    ✓ Capital goods if significant
    ✓ Transport between processes
    ✓ Waste treatment

  Often excluded (with justification):
    Human labor
    Small ancillary materials (< 1% by mass)
    Commuting of workers
    Construction of factory buildings (amortize over lifetime)

  Cut-off rules:
    Mass: exclude flows < 1% of total input mass
    Energy: exclude flows < 1% of total energy input
    Environmental: exclude if < 1% of any impact category
    Must document all exclusions and justification
EOF
}

cmd_tools() {
    cat << 'EOF'
=== LCA Software and Databases ===

--- Software ---

  openLCA:
    Free, open-source
    Desktop application (Java)
    Supports all major databases
    Good for academic and SME use
    Community support, active development
    https://www.openlca.org

  SimaPro:
    Industry standard (most cited in literature)
    Includes ecoinvent, multiple LCIA methods
    Parametric modeling, Monte Carlo
    License: ~$5,000-15,000/year
    https://simapro.com

  GaBi:
    Integrated with thinkstep/Sphera database
    Strong automotive and chemical industry coverage
    Plan-level and professional editions
    License: varies
    https://gabi.sphera.com

  Brightway2:
    Python-based, open-source
    Fully scriptable LCA
    Best for researchers and automation
    Steep learning curve
    https://brightway.dev

  GREET:
    Argonne National Laboratory
    Free, focused on energy and transport
    Well-to-wheel and fuel cycle analysis
    US-centric but widely used
    https://greet.es.anl.gov

--- Databases ---
  ecoinvent:     18,000+ datasets, global, $3K/yr academic
  GaBi/Sphera:   12,000+ datasets, integrated with GaBi
  USLCI:         Free, US-focused, NREL maintained
  ELCD:          Free, EU-focused, European Commission
  Agri-footprint: Agriculture-focused, linked to ecoinvent
  IDEA:          Japan-specific datasets
  AusLCI:        Australia-specific

--- LCIA Methods Available ---
  CML-IA 2001:      Midpoint, legacy standard
  ReCiPe 2016:      Midpoint + endpoint (H/I/E perspectives)
  TRACI 2.1:        US midpoint (EPA)
  EF 3.0/3.1:       EU PEF method
  IMPACT World+:    Regionalized, comprehensive
  IPCC 2021:        GWP factors only (latest AR6 values)
  USEtox 2.0:       Toxicity characterization
  ReCiPe (Individualist/Hierarchist/Egalitarian):
    I: Short-term, optimistic on technology
    H: Balanced (most commonly used)
    E: Long-term, precautionary

--- Quick Start with openLCA ---
  1. Download openLCA
  2. Import ecoinvent or ELCD database
  3. Create product system from process
  4. Select LCIA method (ReCiPe or CML)
  5. Calculate → view results by impact category
  6. Analyze contribution by process
  7. Sensitivity analysis on key parameters
EOF
}

cmd_examples() {
    cat << 'EOF'
=== LCA Examples ===

--- Paper vs Plastic Bag ---
  Functional unit: carrying 10 kg groceries, 1 trip

  Paper bag:
    Forestry + pulping + bag making + transport
    GWP: 5.5 kg CO₂e per bag
    Acidification: 0.02 kg SO₂e
    Water use: 100 L
    Must reuse 3× to beat plastic on GWP

  LDPE plastic bag:
    Oil extraction + polymerization + extrusion + transport
    GWP: 1.6 kg CO₂e per bag
    Acidification: 0.008 kg SO₂e
    Water use: 20 L
    But: persistence in environment, marine pollution

  Cotton tote bag:
    Cotton farming (water, pesticides) + weaving + transport
    GWP: 150-270 kg CO₂e per bag
    Must reuse 130-270× to beat plastic on GWP
    Organic cotton: even worse on GWP (lower yields)

  Conclusion: No universally "best" option — depends on impact
  category, reuse rate, and end-of-life management

--- Electric vs Gasoline Car ---
  Functional unit: 200,000 km lifetime driving

  BEV (EU average grid, 2023):
    Production: 8-12 t CO₂e (battery is 30-50%)
    Use: 15-20 t CO₂e (electricity)
    End-of-life: -1 t CO₂e (recycling credit)
    Total: 22-31 t CO₂e

  ICE (gasoline):
    Production: 5-7 t CO₂e
    Use: 35-45 t CO₂e (fuel combustion)
    End-of-life: -0.5 t CO₂e
    Total: 40-52 t CO₂e

  BEV with 100% renewable:
    Production: 8-12 t CO₂e
    Use: 1-3 t CO₂e
    Total: 9-15 t CO₂e (60-70% less than ICE)

  Breakeven: BEV beats ICE after 30,000-60,000 km (EU grid)

--- Building Materials ---
  Per m² of wall (R-20 insulation, 60-year life):
    Concrete block:  40-60 kg CO₂e/m²
    Wood frame:      15-25 kg CO₂e/m² (carbon stored!)
    Steel frame:     30-50 kg CO₂e/m²
    CLT (cross-lam): 10-20 kg CO₂e/m²

  But: operational energy (heating/cooling) dominates
  over 60 years, embodied carbon is 10-20% of total

--- Packaging ---
  Per liter of beverage packaged:
    Glass bottle (reuse 15×):  90 g CO₂e/L
    Glass bottle (single):    300 g CO₂e/L
    PET bottle:               120 g CO₂e/L
    Aluminum can:             200 g CO₂e/L
    Tetra Pak:                60 g CO₂e/L
    Refillable glass: best IF logistics are short
EOF
}

cmd_pitfalls() {
    cat << 'EOF'
=== Common LCA Pitfalls ===

--- 1. Inappropriate Functional Unit ---
  Comparing products with different functions
  ✗ "1 kg of steel vs 1 kg of aluminum" (different strength)
  ✓ "Bridge beam carrying 10 tons over 20 m for 50 years"
  Fix: Define FU by FUNCTION delivered, not physical quantity

--- 2. System Boundary Mismatch ---
  Comparing cradle-to-gate with cradle-to-grave
  Missing significant life cycle stages
  Example: ignoring use phase for energy-consuming products
    (LED bulb production > incandescent, but use phase reverses this)
  Fix: Same boundaries for comparative studies

--- 3. Data Quality Issues ---
  Using old data (>10 years) for rapidly changing technologies
  Using wrong geography (Chinese electricity for German factory)
  Proxy data without documentation
  Fix: Data quality assessment, sensitivity analysis

--- 4. Ignoring Uncertainty ---
  Presenting single-point results as definitive
  LCA data has ±20-50% uncertainty typically
  Fix: Monte Carlo simulation, sensitivity analysis
  Report ranges, not just single numbers

--- 5. Single-Score Fallacy ---
  Weighting all impacts into one number
  Hides trade-offs (lower GWP but higher toxicity)
  ISO 14044 PROHIBITS single-score in comparative assertions
  Fix: Report all relevant impact categories separately

--- 6. Burden Shifting ---
  Reducing one impact while increasing another
  Example: lightweighting reduces fuel use but increases
  production energy (aluminum vs steel)
  Fix: Check ALL impact categories, not just GWP

--- 7. Allocation Errors ---
  Multi-output processes: how to split?
  Different allocation methods → different results
  Economic vs physical allocation can change conclusions
  Fix: Sensitivity analysis on allocation method

--- 8. Cherry-Picking ---
  Choosing LCIA method that gives favorable results
  Choosing system boundary that excludes unfavorable stages
  Fix: Follow ISO 14044, disclose all choices, peer review

--- 9. Temporal Mismatch ---
  Comparing current technology with future projections
  Grid mix changes over product lifetime
  Fix: Scenario analysis for long-lived products

--- 10. Confusing LCA with Sustainability ---
  LCA covers environmental impacts only
  Does not cover: social impacts, economic viability,
  worker safety, community effects, biodiversity fully
  Fix: LCA is one tool — combine with Social-LCA, LCC
  for comprehensive sustainability assessment
EOF
}

show_help() {
    cat << EOF
lca v$VERSION — Life Cycle Assessment Reference

Usage: script.sh <command>

Commands:
  intro        LCA overview and ISO standards
  phases       Four phases: goal, inventory, impact, interpretation
  impacts      Impact categories: GWP, acidification, toxicity
  inventory    LCI data collection and databases
  boundaries   System boundaries: cradle-to-gate/grave
  tools        LCA software: openLCA, SimaPro, GaBi, Brightway
  examples     Product comparison examples with LCA results
  pitfalls     Common LCA mistakes and how to avoid them
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
    boundaries) cmd_boundaries ;;
    tools)      cmd_tools ;;
    examples)   cmd_examples ;;
    pitfalls)   cmd_pitfalls ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "lca v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
