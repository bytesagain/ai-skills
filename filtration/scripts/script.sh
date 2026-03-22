#!/usr/bin/env bash
# filtration — Industrial & Water Filtration Technology Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Filtration Fundamentals ===

Filtration is the separation of solids from fluids (liquids or gases)
by passing through a permeable medium that retains particles.

Driving Forces:
  Gravity         Sand filters, settling basins
  Pressure        Pump-driven membrane systems
  Vacuum          Vacuum drum filters, belt filters
  Centrifugal     Centrifugal separators

Classification by Mechanism:
  Surface filtration    Particles retained on filter surface (cake)
  Depth filtration      Particles trapped within filter media
  Membrane filtration   Size exclusion through semi-permeable membrane
  Cross-flow            Feed flows parallel to membrane surface

Classification by Pore Size:
  Macrofiltration       > 10 μm    (screens, strainers)
  Microfiltration (MF)  0.1–10 μm  (bacteria, sediment)
  Ultrafiltration (UF)  0.01–0.1 μm (viruses, colloids)
  Nanofiltration (NF)   0.001–0.01 μm (multivalent ions, organics)
  Reverse Osmosis (RO)  < 0.001 μm (monovalent ions, dissolved salts)

Key Parameters:
  Flux (J)         Volume per unit area per unit time (L/m²·h or GFD)
  TMP              Trans-membrane pressure (driving force)
  Recovery (R)     % of feed water converted to permeate
  Rejection (σ)    % of solute retained by membrane
  Turbidity        Measure of particle content (NTU)
  SDI              Silt Density Index (membrane fouling potential)

Darcy's Law (fundamental equation):
  J = ΔP / (μ · R_total)
  where:
    J = flux, ΔP = pressure differential
    μ = viscosity, R_total = total resistance
EOF
}

cmd_membranes() {
    cat << 'EOF'
=== Membrane Filtration Types ===

--- Microfiltration (MF) ---
  Pore size:    0.1 – 10 μm
  Pressure:     0.1 – 2 bar (1.5 – 30 psi)
  Removes:      Bacteria, algae, sediment, large colloids
  Passes:       Viruses, dissolved organics, salts
  Materials:    PVDF, PP, ceramic
  Flux:         50 – 200 L/m²·h
  Applications: Pre-treatment for UF/NF/RO, clarification
                Juice clarification, beer filtration

--- Ultrafiltration (UF) ---
  Pore size:    0.01 – 0.1 μm (MWCO: 1,000 – 300,000 Da)
  Pressure:     1 – 5 bar (15 – 75 psi)
  Removes:      Viruses, proteins, endotoxins, colloids
  Passes:       Small organics, dissolved salts
  Materials:    PES, PVDF, ceramic
  Flux:         20 – 100 L/m²·h
  Applications: Drinking water (pathogen barrier)
                Dialysis, protein concentration
                Oily wastewater treatment

--- Nanofiltration (NF) ---
  Pore size:    0.001 – 0.01 μm (MWCO: 200 – 1,000 Da)
  Pressure:     3 – 20 bar (45 – 300 psi)
  Removes:      Multivalent ions (Ca²⁺, Mg²⁺), organics > 200 Da
  Passes:       Monovalent ions (Na⁺, Cl⁻) partially
  Materials:    Polyamide thin-film composite
  Flux:         15 – 50 L/m²·h
  Applications: Water softening, color removal
                Pharmaceutical purification
                Selective ion removal

--- Reverse Osmosis (RO) ---
  Pore size:    < 0.001 μm
  Pressure:     10 – 80 bar (150 – 1,200 psi)
  Removes:      Virtually all dissolved species (97–99.5%)
  Materials:    Polyamide TFC (spiral wound)
  Flux:         10 – 30 L/m²·h
  Applications: Desalination, ultrapure water
                Boiler feed water, semiconductor fab
                Wastewater reuse

Membrane Configurations:
  Hollow fiber   High packing density, backwashable (MF/UF)
  Spiral wound   Cost-effective, high area (NF/RO)
  Tubular        Handles high solids, easy cleaning
  Flat sheet     Lab scale, MBR systems
  Ceramic        High temp/chemical resistance, long life
EOF
}

cmd_media() {
    cat << 'EOF'
=== Filter Media Reference ===

--- Granular Media ---
  Sand (silica):
    Size: 0.4 – 1.2 mm (effective size)
    Removes: Suspended solids > 10 μm
    Depth: 600 – 900 mm typical
    Flow rate: 5 – 15 m/h (gravity), 10 – 25 m/h (pressure)
    Backwash: 20 – 25 m/h for 10–15 minutes

  Anthracite:
    Size: 0.8 – 2.0 mm
    Lower density than sand → used on top in dual-media
    Captures coarser particles, extends run times
    Depth: 300 – 600 mm (in dual-media configuration)

  Dual-Media Filter:
    Top: Anthracite (coarse, light) — captures large particles
    Bottom: Sand (fine, heavy) — polishes effluent
    Benefit: longer runs, higher loading rates

  Multimedia Filter:
    Anthracite + Sand + Garnet (or ilmenite)
    Graded density: coarse-to-fine filtration
    Highest capacity of granular filters

--- Activated Carbon ---
  GAC (Granular):
    Removes: chlorine, VOCs, taste, odor, organics
    Iodine number: 800–1200 mg/g (adsorption capacity)
    Empty bed contact time (EBCT): 5–20 minutes
    Regeneration: thermal reactivation at 800–950°C

  PAC (Powdered):
    Dosed directly into water (1–50 mg/L)
    Contact time: 10–30 minutes
    Single-use (removed with sludge)
    Good for seasonal taste/odor issues

--- Cartridge Filters ---
  Wound/spun:     5–100 μm, low cost, depth filtration
  Pleated:        0.1–50 μm, high surface area, longer life
  Melt-blown:     0.5–100 μm, depth-type, graded density
  Absolute-rated: Guaranteed removal at stated size
  Nominal-rated:  Removes ~85% at stated size (less precise)

--- Bag Filters ---
  Size: 1–200 μm
  Flow: 5–50 m³/h per bag
  Low cost, easy change-out
  Higher dirt holding than cartridges
  Used in: paint, chemicals, cooling water
EOF
}

cmd_design() {
    cat << 'EOF'
=== Filtration System Design ===

--- Key Design Parameters ---

  Feed flow rate (Qf):
    Total volume to be processed per unit time
    Units: m³/h, GPM, L/min

  Flux (J):
    Volume per membrane area per time
    J = Qp / A    (L/m²·h or GFD)
    Design flux < rated flux (typically 60-80% of max)

  Membrane area required:
    A = Qp / J
    Example: 100 m³/h permeate at 25 L/m²·h → 4,000 m² membrane

  Recovery rate:
    R = Qp / Qf × 100%
    MF/UF: 90-95%
    NF: 75-90%
    RO (brackish): 75-85%
    RO (seawater): 40-50%

  Trans-Membrane Pressure (TMP):
    TMP = (Pfeed + Pretentate) / 2 - Ppermeate
    Monitor TMP trend: rising TMP at constant flux = fouling

--- Sizing Example (UF System) ---
  Given: 500 m³/h feed, 95% recovery, flux = 60 L/m²·h
  Permeate: 500 × 0.95 = 475 m³/h
  Membrane area: 475,000 / 60 = 7,917 m²
  If module = 40 m² each: 7,917 / 40 = 198 modules
  Add 10% spare: 218 modules

--- Pressure Drop ---
  ΔP = f × L × v² × ρ / (2 × d)
  Keep ΔP within manufacturer limits
  Monitor differential pressure → replacement trigger

--- Backwash Design (MF/UF) ---
  Frequency: every 20-60 minutes
  Duration: 30-60 seconds
  Air scour: 5-10 seconds before backwash
  BW flux: 2-3× operating flux
  Water consumption: 3-8% of production

--- Chemical Cleaning (CIP) ---
  Frequency: every 1-6 months
  Alkaline: NaOH (pH 11-12) for organic/biological fouling
  Acid: citric acid or HCl (pH 2-3) for mineral scaling
  Oxidant: NaOCl (200-500 ppm) for biofouling
  Temperature: 35-40°C enhances cleaning
  Soak time: 1-4 hours typical
EOF
}

cmd_fouling() {
    cat << 'EOF'
=== Membrane Fouling ===

Fouling = accumulation of materials on or in membrane that reduces flux.
Biggest challenge in membrane operations. Can increase energy costs 50%+.

--- Types of Fouling ---

  Particulate/Colloidal Fouling:
    Cause: Suspended solids, clay, silica
    Indicator: SDI > 3, high turbidity in feed
    Prevention: Pre-filtration (5 μm cartridge), coagulation
    Cleaning: Backwash, air scour

  Biological Fouling (Biofouling):
    Cause: Bacterial growth, biofilm formation
    Indicator: Rapid TMP rise, slimy deposits
    Prevention: Chlorination, UV, biocide dosing
    Cleaning: NaOCl soak (200-500 ppm), enzymatic cleaners
    Note: #1 fouling issue in RO systems

  Organic Fouling:
    Cause: NOM (humic/fulvic acids), proteins, oils
    Indicator: TOC/DOC in feed, brown discoloration
    Prevention: Coagulation, activated carbon pre-treatment
    Cleaning: Alkaline (NaOH pH 11), surfactant-enhanced

  Scaling (Inorganic Fouling):
    Cause: CaCO₃, CaSO₄, BaSO₄, silica precipitation
    Indicator: LSI > 0 (Langelier Saturation Index)
    Prevention: Antiscalant dosing, pH adjustment, limit recovery
    Cleaning: Acid wash (HCl or citric acid, pH 2-3)

--- Fouling Monitoring ---
  TMP trending:      Plot TMP vs time at constant flux
  Normalized flux:   Correct for temperature and pressure
  Clean water flux:  Measure after cleaning → compare to new
  Autopsy:          Cut open fouled element for analysis

--- Anti-Fouling Strategies ---
  1. Proper pre-treatment (the most important factor)
  2. Design at conservative flux (80% of rated)
  3. Regular backwash and CEB (chemically enhanced backwash)
  4. Scheduled CIP before irreversible fouling
  5. Air scouring for hollow fiber systems
  6. Cross-flow velocity optimization
  7. Feed water quality monitoring (SDI, turbidity, TOC)
  8. Antiscalant and biocide dosing programs

Membrane Life:
  MF/UF: 5-10 years with proper maintenance
  NF/RO: 3-7 years, declining flux over time
  Replace when CIP can no longer restore >80% of initial flux
EOF
}

cmd_industrial() {
    cat << 'EOF'
=== Industrial Filtration Applications ===

--- Oil & Gas ---
  Produced water treatment:
    MF/UF for oil-water separation (< 5 mg/L oil in permeate)
    Ceramic membranes for high-temperature streams
    Walnut shell filters for oily water (95% removal)
    Hydrocyclones + filtration for offshore platforms

  Amine filtration:
    10 μm cartridge filters on amine circuit
    Activated carbon for heat-stable salt removal
    Prevents foaming in gas sweetening towers

--- Pharmaceutical ---
  Sterile filtration: 0.2 μm (bacteria) or 0.1 μm (mycoplasma)
  Integrity testing: bubble point, diffusion test
  Single-use filters dominate (no cleaning validation)
  Virus removal: 20 nm nanofilters (log reduction > 4)
  Tangential Flow Filtration (TFF): protein concentration

--- Food & Beverage ---
  Beer: Cross-flow MF replaces diatomaceous earth filtration
  Wine: 0.45 μm for cold stabilization, tartrate removal
  Juice: UF clarification (removes pectin, pulp)
  Dairy: UF for whey protein concentration (WPC)
  Sugar: NF for decolorization and demineralization

--- Chemicals ---
  Catalyst recovery: MF/UF to reclaim precious metal catalysts
  Solvent recovery: NF for solvent-resistant nanofiltration
  Brine purification: NF + IX for chlor-alkali membrane cells
  Electroplating: filter press for sludge dewatering

--- Electronics / Semiconductor ---
  Ultrapure water (UPW): Multi-stage RO + EDI + UF
  Target: 18.2 MΩ·cm resistivity, < 1 ppb TOC
  Point-of-use filters: 0.04 μm, absolute rated
  Particle counts: < 1 particle/mL at > 0.05 μm
EOF
}

cmd_water() {
    cat << 'EOF'
=== Water Treatment Filtration ===

--- Drinking Water ---
  Conventional treatment train:
    Raw water → Coagulation → Flocculation → Sedimentation
    → Filtration (sand/multimedia) → Disinfection

  Membrane treatment train:
    Raw water → Screen → MF/UF → Disinfection

  Log removal requirements (EPA LT2):
    Cryptosporidium: 3-log (99.9%)
    Giardia: 4-log (99.99%)
    Viruses: 4-log
    UF provides: 4+ log Crypto, 4+ log Giardia, 0 log viruses
    UF + chlorine = comprehensive barrier

  Turbidity standards:
    EPA: < 0.3 NTU (95% of time), never > 1 NTU
    Typical UF permeate: < 0.05 NTU

--- Wastewater Treatment ---
  Tertiary filtration:
    After secondary clarifier, before discharge
    Sand/multimedia: removes TSS to < 10 mg/L
    Cloth/disc filters: compact, low head loss

  Membrane Bioreactor (MBR):
    Combines biological treatment + membrane filtration
    MF/UF immersed in activated sludge tank
    Benefits: compact footprint, excellent effluent quality
    Effluent: TSS < 1 mg/L, turbidity < 0.2 NTU
    Challenge: membrane fouling from sludge

--- Water Reuse ---
  Treatment train for indirect potable reuse (IPR):
    Secondary effluent → MF/UF → RO → UV/AOP → Storage
    "Full Advanced Treatment" (FAT) — proven barrier

  Treatment train for non-potable reuse:
    Secondary effluent → MF/UF → Disinfection
    Uses: irrigation, cooling, toilet flushing

--- Desalination Pre-treatment ---
  Seawater → Intake screen → Coagulation → DMF or UF → RO
  UF pre-treatment advantages:
    - Consistent SDI < 3 regardless of raw water quality
    - Smaller footprint than conventional
    - Better RO membrane protection
    - Handles algal blooms and high turbidity events
EOF
}

cmd_compare() {
    cat << 'EOF'
=== Filtration Technology Comparison ===

                    MF        UF        NF        RO
Pore size (μm)     0.1-10    0.01-0.1  0.001     <0.001
Pressure (bar)     0.1-2     1-5       3-20      10-80
Energy (kWh/m³)    0.1-0.4   0.2-1     0.5-3     2-6
Salt rejection     None      None      50-90%    95-99.5%
Removes bacteria   Yes       Yes       Yes       Yes
Removes viruses    No        Yes       Yes       Yes
Removes hardness   No        No        Yes       Yes
Removes TDS        No        No        Partial   Yes

--- Selection Decision Guide ---

  Need to remove:
    Sediment/bacteria only         → MF
    Viruses/colloids               → UF
    Hardness/color/organics        → NF
    All dissolved salts             → RO

  Feed water quality:
    Clean feed (SDI < 3)           → Direct NF/RO possible
    Variable/dirty feed            → MF/UF pre-treatment required
    High fouling potential          → Ceramic MF/UF

  Operating considerations:
    Lowest energy cost             → Gravity sand filter
    Smallest footprint             → Membrane (MF/UF)
    Best effluent quality          → RO
    Highest recovery               → MF/UF (90-95%)
    Most chemical resistant        → Ceramic membranes
    Lowest CAPEX                   → Sand filtration
    Lowest OPEX (long-term)        → Depends on application

--- Cost Comparison (typical ranges) ---
  Sand filter:    $50-150/m³/day CAPEX,  $0.01-0.05/m³ OPEX
  MF/UF:          $100-300/m³/day CAPEX, $0.05-0.15/m³ OPEX
  NF:             $200-500/m³/day CAPEX, $0.10-0.30/m³ OPEX
  RO (brackish):  $300-700/m³/day CAPEX, $0.15-0.40/m³ OPEX
  RO (seawater):  $800-1500/m³/day CAPEX,$0.50-1.00/m³ OPEX
EOF
}

show_help() {
    cat << EOF
filtration v$VERSION — Industrial & Water Filtration Technology Reference

Usage: script.sh <command>

Commands:
  intro        Filtration principles and classification
  membranes    Membrane types: MF, UF, NF, RO
  media        Filter media: sand, carbon, cartridge, bag
  design       System design and sizing calculations
  fouling      Membrane fouling causes and solutions
  industrial   Industrial filtration applications
  water        Water treatment filtration systems
  compare      Technology comparison and selection guide
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    membranes)  cmd_membranes ;;
    media)      cmd_media ;;
    design)     cmd_design ;;
    fouling)    cmd_fouling ;;
    industrial) cmd_industrial ;;
    water)      cmd_water ;;
    compare)    cmd_compare ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "filtration v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
