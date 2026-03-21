#!/usr/bin/env bash
# biogas — Biogas Technology Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Biogas: Renewable Energy from Organic Waste ===

Biogas is produced by anaerobic digestion (AD) — microorganisms
breaking down organic matter in the absence of oxygen.

Composition (typical):
  Methane (CH₄)         50–70%    ← the energy carrier
  Carbon dioxide (CO₂)  30–50%
  Hydrogen sulfide (H₂S) 0.1–3%  ← corrosive, must be removed
  Water vapor           saturated
  Trace gases           NH₃, N₂, O₂, siloxanes

Energy Content:
  Raw biogas:    5.5–6.5 kWh/m³ (at 60% CH₄)
  Pure methane:  9.97 kWh/m³
  1 m³ biogas ≈  0.6 L diesel equivalent

Applications:
  Combined Heat & Power (CHP)    Most common, η_el=35-42%, η_th=40-50%
  Biomethane (upgraded)          Inject to gas grid or vehicle fuel
  Direct thermal use             Boilers, dryers, kilns
  Fuel cells                     Higher electrical efficiency (50-60%)

Global Scale:
  - 18,000+ biogas plants in Europe (Germany leads with 10,000+)
  - China: 40+ million household digesters
  - India: 5+ million small-scale plants
  - US: 2,200+ operational, mostly landfill gas + dairy

Feedstocks → Digester → Biogas → CHP/Upgrading
                ↓
            Digestate → Fertilizer (N, P, K rich)
EOF
}

cmd_feedstocks() {
    cat << 'EOF'
=== Biogas Feedstocks ===

Methane Yield by Feedstock (m³ CH₄ per ton fresh matter):

  Feedstock              CH₄ yield    C:N ratio    TS%
  ─────────              ─────────    ─────────    ───
  Maize silage           100–110      40–55:1      30–35
  Grass silage           80–100       20–30:1      25–40
  Sugar beet             75–85        35–40:1      23
  Food waste             80–120       15–25:1      20–30
  Cattle manure          15–25        20–30:1      8–12
  Pig manure             20–30        10–15:1      5–8
  Chicken manure         50–70        5–10:1       25–35
  Sewage sludge          10–20        6–9:1        3–6
  Grease trap waste      150–200      ∞ (no N)     90–95
  Slaughterhouse waste   50–90        varies       15–20

Optimal C:N Ratio: 20–30:1
  Too high C:N (>35:1) → nitrogen deficiency, slow digestion
  Too low C:N (<15:1) → ammonia inhibition, pH rise

Co-digestion Benefits:
  Cattle manure (C:N=25) + Chicken manure (C:N=7)
  → blend to C:N=20–25 → synergy effects, +20-30% yield

  Manure (low C:N, buffering) + Energy crops (high C:N, high yield)
  = stable process + high output

Feedstock Pre-treatment:
  Mechanical    Shredding, maceration (increase surface area)
  Thermal       70°C/1h pasteurization (required for ABP)
  Chemical      NaOH treatment of lignocellulose
  Biological    Enzymatic hydrolysis
  
ABP Regulation (EU):
  Category 3 (food waste) → 70°C, 1h, <12mm particles
  Category 2 (manure)     → pasteurization or composting
  Category 1 (high risk)  → not allowed in biogas
EOF
}

cmd_digester() {
    cat << 'EOF'
=== Digester Types ===

CSTR — Continuously Stirred Tank Reactor
  Most common type worldwide
  Volume: 500–6,000 m³ typical
  TS input: 8–12% (pumpable slurry)
  Mixing: mechanical stirrer, gas recirculation, or hydraulic
  HRT: 20–40 days
  Pros: simple, handles varied feedstocks, well-understood
  Cons: short-circuiting risk, dilute feedstocks only

Plug-Flow Reactor
  Horizontal flow, no back-mixing
  Good for fibrous substrates (>12% TS)
  HRT: 15–30 days
  Pros: simple construction, no mixer needed, FIFO
  Cons: risk of crust/scum layer, hard to heat evenly

Batch Reactor (Garage-type)
  Fill → seal → digest → empty → repeat
  Cycle: 21–28 days per batch
  Often 3-4 chambers in rotation
  Pros: handles solid waste (30-40% TS), simple
  Cons: inconsistent gas production, labor intensive

UASB — Upflow Anaerobic Sludge Blanket
  For high-volume wastewater (breweries, food processing)
  OLR: 5–30 kg COD/m³/d (very high!)
  HRT: 4–12 hours (not days)
  Pros: compact, high efficiency, granular sludge
  Cons: needs consistent wastewater, granule formation time

Two-Stage Systems:
  Stage 1: Hydrolysis/acidogenesis (pH 5.5–6.5, HRT 2–4d)
  Stage 2: Methanogenesis (pH 7.0–8.0, HRT 15–25d)
  Pros: optimized conditions for each microbial group
  Cons: higher CAPEX, more complex operation

Sizing Rule of Thumb:
  Digester volume = Daily feedstock input × HRT
  Example: 50 m³/day × 30 days = 1,500 m³ digester
  Gas storage: 25–50% of daily gas production
EOF
}

cmd_process() {
    cat << 'EOF'
=== Four Stages of Anaerobic Digestion ===

Stage 1: HYDROLYSIS
  Complex organics → Simple soluble molecules
  Proteins → Amino acids
  Carbohydrates → Simple sugars
  Fats → Fatty acids + glycerol
  
  Bacteria: Bacteroides, Clostridium, facultative anaerobes
  Rate-limiting for: solid/fibrous substrates
  Duration: hours to days (depends on particle size)

Stage 2: ACIDOGENESIS
  Simple molecules → Volatile Fatty Acids (VFAs)
  Amino acids → VFAs + NH₃ + CO₂
  Sugars → Butyrate, propionate, acetate, ethanol
  
  Bacteria: Acidogenic bacteria (fast growers)
  pH: can drop to 4.5–5.5 (acid production)
  This stage is rarely rate-limiting

Stage 3: ACETOGENESIS
  VFAs + alcohols → Acetate + H₂ + CO₂
  Propionate → Acetate + CO₂ + H₂
  Butyrate → Acetate + H₂
  Ethanol → Acetate + H₂
  
  Bacteria: Syntrophobacter, Syntrophomonas
  CRITICAL: requires low H₂ partial pressure
  Syntrophic relationship with methanogens (H₂ consumers)

Stage 4: METHANOGENESIS
  Two pathways:
  Acetoclastic: CH₃COOH → CH₄ + CO₂ (70% of CH₄)
  Hydrogenotrophic: 4H₂ + CO₂ → CH₄ + 2H₂O (30%)
  
  Archaea: Methanosaeta, Methanosarcina, Methanobacterium
  Slowest growers — rate-limiting for soluble substrates
  Doubling time: 5–15 days (vs hours for acidogens)
  Very sensitive to: pH, temperature, toxins

Balance is Key:
  Acidogenesis too fast → VFA accumulation → pH drop → methanogen death
  This "acid crash" is the #1 cause of digester failure
  Prevention: monitor VFA/alkalinity ratio (keep < 0.4)
EOF
}

cmd_parameters() {
    cat << 'EOF'
=== Critical Operating Parameters ===

Temperature:
  Psychrophilic   <25°C     Slow, used in lagoons/household
  Mesophilic      35–40°C   Most common, stable, robust
  Thermophilic    50–55°C   Faster, higher yield, pathogen kill
  
  Mesophilic pros: stable, lower heating cost, tolerant
  Thermophilic pros: 25-50% faster, better pathogen reduction
  NEVER between 40-50°C (transition zone, neither optimal)
  Temperature fluctuation: keep within ±2°C!

pH:
  Optimal: 6.8–7.5 (methanogens)
  Acidogens tolerate: 5.5–8.0
  Below 6.5 → methanogen inhibition → acid crash
  Above 8.3 → free ammonia inhibition
  Natural buffering: bicarbonate system (HCO₃⁻)

OLR — Organic Loading Rate:
  kg VS / m³ digester / day
  Typical CSTR: 2–4 kg VS/m³/d
  High-performance: 4–8 kg VS/m³/d
  Too high → VFA accumulation → process failure
  Start low (1–2), increase gradually over weeks

HRT — Hydraulic Retention Time:
  Average time material stays in digester
  Mesophilic: 25–40 days typical
  Thermophilic: 15–25 days
  Below minimum HRT → washout of methanogens

VFA/Alkalinity Ratio (Ripley Index):
  < 0.3     Stable, healthy digester
  0.3–0.4   Caution, reduce loading
  0.4–0.8   Stressed, stop feeding
  > 0.8     Process failure imminent

Ammonia:
  Total Ammonia Nitrogen (TAN): safe below 3 g/L
  Free Ammonia (NH₃): toxic above 0.7 g/L
  Higher pH and temperature → more free ammonia
  Acclimated microbes can tolerate higher levels

Monitoring Priority:
  Daily:   gas production, temperature, pH
  Weekly:  VFA, alkalinity, VFA/alk ratio
  Monthly: TS, VS, TAN, trace elements (Co, Ni, Se, Mo)
EOF
}

cmd_upgrading() {
    cat << 'EOF'
=== Biogas Upgrading to Biomethane ===

Goal: Remove CO₂ + impurities → >97% CH₄ (grid/vehicle quality)

Water Scrubbing:
  CO₂ dissolves in water under pressure (5–10 bar)
  CH₄ recovery: 98–99%
  Energy: 0.2–0.3 kWh/Nm³
  Pros: no chemicals, simple, proven
  Cons: high water use (regenerative systems reduce this)
  Market share: ~40% of upgrading plants

Pressure Swing Adsorption (PSA):
  Activated carbon/zeolite adsorbs CO₂ at high pressure
  4–7 bar, 4 vessels cycling
  CH₄ recovery: 96–98%
  Energy: 0.2–0.25 kWh/Nm³
  Pros: dry process, compact, modular
  Cons: requires H₂S pre-removal, methane slip 2–4%

Chemical Scrubbing (Amine):
  Amine solution (MEA, MDEA) absorbs CO₂ at low pressure
  Regeneration at 120–160°C
  CH₄ recovery: 99.5–99.9%
  Energy: 0.12–0.15 kWh/Nm³ elec + 0.5–0.7 kWh/Nm³ heat
  Pros: highest purity, lowest methane slip (<0.1%)
  Cons: chemical costs, heat requirement, amine degradation

Membrane Separation:
  Polymeric membranes (polyimide, polysulfone)
  CO₂ permeates through, CH₄ retained
  Pressure: 6–20 bar, 2–3 stage cascade
  CH₄ recovery: 96–99%
  Energy: 0.18–0.25 kWh/Nm³
  Pros: modular, scalable, no chemicals/water
  Cons: membrane replacement every 5–10 years

Cryogenic Separation:
  Cool biogas to -80°C → CO₂ liquefies
  CH₄ recovery: 99%+
  Produces liquid CO₂ (sellable byproduct!)
  Pros: very high purity, liquid CO₂ revenue
  Cons: high CAPEX, energy intensive, for large plants only

Pre-treatment Required for All:
  H₂S removal:   Iron sponge, activated carbon, biological
  Moisture:       Condensation, silica gel
  Siloxanes:      Activated carbon (landfill gas especially)
EOF
}

cmd_troubleshoot() {
    cat << 'EOF'
=== Biogas Plant Troubleshooting ===

Problem: Gas Production Dropping
  Check VFA/alkalinity ratio → if rising, overloaded
  Check temperature → fluctuation kills methanogens
  Check feedstock → composition change? contamination?
  Check mixing → dead zones accumulating?
  Action: reduce OLR by 50%, monitor daily

Problem: Foaming
  Causes: protein-rich feed, surfactants, overloading
  Indicators: foam in gas pipes, pressure fluctuations
  Quick fix: add anti-foam agent (vegetable oil, silicone)
  Long fix: reduce protein content, lower OLR
  Prevention: avoid sudden feedstock changes

Problem: Acid Crash (VFA Buildup)
  Symptoms: pH dropping, CO₂% rising (>45%), gas drop
  Cause: OLR too high, methanogens overwhelmed
  Emergency: STOP feeding immediately
  Add alkalinity: NaHCO₃ or lime (CaCO₃)
  Wait for VFA to drop below 2 g/L before resuming
  Resume at 50% of previous loading rate

Problem: Ammonia Inhibition
  Symptoms: rising pH (>8.0), declining gas, high TAN
  Common with: chicken manure, protein-rich waste
  Fix: dilute with water or co-digest with high-C feedstock
  Fix: lower temperature (reduces free ammonia fraction)
  Long-term: allow acclimatization (gradual increase)

Problem: H₂S Too High (>500 ppm)
  Causes: sulfur-rich feed (brewery waste, protein)
  Risk: corrosion of CHP engine, toxic gas
  Fix: add iron chloride (FeCl₃) to digester — binds sulfur
  Fix: iron sponge in gas line
  Fix: micro-aeration (inject 2-6% air into headspace)

Problem: Scum/Crust Layer
  Causes: fibrous material, grease, long straw
  Blocks gas release, reduces active volume
  Fix: improve mixing intensity
  Fix: pre-chop feedstock to <10mm
  Fix: install top-mounted mixer
  Prevention: avoid dry fibrous feed without pre-treatment
EOF
}

cmd_economics() {
    cat << 'EOF'
=== Biogas Plant Economics ===

CAPEX (Investment Cost):
  Small farm plant (75 kW):      €3,000–5,000/kW → €225k–375k
  Medium agricultural (500 kW):  €2,500–4,000/kW → €1.25M–2M
  Large waste plant (1 MW):      €3,500–6,000/kW → €3.5M–6M
  
  Cost breakdown (typical):
    Digester + gas storage    35–40%
    CHP engine               15–20%
    Feedstock handling        10–15%
    Civil works              10–15%
    Electrical + controls     5–10%
    Planning + permits        5–10%

OPEX (Annual Operating Cost):
  Feedstock (if purchased):  40–60% of OPEX
  Maintenance:               10–15%
  Labor:                     10–15% (1 FTE per 500 kW typical)
  Insurance + admin:         5–10%
  Own electricity use:       8–12% of generation

Revenue Streams:
  Electricity (feed-in tariff or PPA)     Primary revenue
  Heat sales (district heating, drying)   Often 20-30% of revenue
  Gate fees (waste treatment)             €30–80/ton for food waste
  Digestate (fertilizer replacement)      €5–15/m³
  Biomethane (if upgraded)                Grid injection premium
  Carbon credits                          Emerging revenue stream

Payback Period:
  With feed-in tariff:      5–8 years
  Without subsidies:        8–15 years
  With gate fees:           4–7 years (waste-fed plants)

Key Financial Metrics:
  Specific gas yield:       target >350 Nm³/ton VS
  CHP running hours:        >8,000 h/year (92%+ availability)
  Own use:                  <10% of electricity generated
  Heat utilization:         >50% (improves economics significantly)

Breakeven Electricity Price:
  Small plant: €0.15–0.20/kWh needed
  Large plant: €0.08–0.12/kWh needed
  With gate fees: €0.05–0.08/kWh viable
EOF
}

show_help() {
    cat << EOF
biogas v$VERSION — Biogas Technology Reference

Usage: script.sh <command>

Commands:
  intro         Biogas overview, composition, and applications
  feedstocks    Methane yields, C:N ratios, co-digestion
  digester      Digester types: CSTR, plug-flow, UASB, batch
  process       Four stages of anaerobic digestion
  parameters    Temperature, pH, OLR, HRT, VFA monitoring
  upgrading     Biomethane upgrading technologies
  troubleshoot  Diagnosing digester problems and fixes
  economics     CAPEX, OPEX, revenue, payback analysis
  help          Show this help
  version       Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    feedstocks)   cmd_feedstocks ;;
    digester)     cmd_digester ;;
    process)      cmd_process ;;
    parameters)   cmd_parameters ;;
    upgrading)    cmd_upgrading ;;
    troubleshoot) cmd_troubleshoot ;;
    economics)    cmd_economics ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "biogas v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
