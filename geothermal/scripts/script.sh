#!/usr/bin/env bash
# geothermal — Geothermal Energy Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Geothermal Energy ===

Geothermal energy harnesses heat from the Earth's interior.
The Earth's core is ~5,500°C — a virtually inexhaustible heat source.

Heat Sources:
  Primordial heat:     Heat from planetary formation
  Radioactive decay:   U-238, Th-232, K-40 in crust/mantle
  Total heat flow:     ~44 TW continuously from Earth's interior
  Geothermal gradient: ~25-30°C per km depth (average)
                       Much higher at tectonic boundaries

Global Resource:
  Accessible resource (0-10 km): ~13,000 ZJ
  Current global capacity: ~16 GW electrical (2023)
  Top countries: USA (3.7 GW), Indonesia (2.4 GW),
                 Philippines (1.9 GW), Turkey (1.7 GW),
                 New Zealand (1.0 GW)

Why Geothermal Matters:
  ✓ Baseload power (24/7, not intermittent like solar/wind)
  ✓ Capacity factor: 90%+ (vs solar ~25%, wind ~35%)
  ✓ Small land footprint per MW
  ✓ Near-zero emissions in operation
  ✓ Heating AND power generation
  ✓ Proven technology (100+ years)

Geothermal Applications:
  Electricity generation:     > 150°C resources
  Direct heating:             50-150°C (district heating, greenhouses)
  Ground-source heat pumps:   10-25°C (any location)
  Industrial process heat:    Drying, pasteurization, aquaculture
  Balneology:                 Hot springs for bathing/therapy

Timeline:
  1904    First geothermal power at Larderello, Italy
  1958    Wairakei, New Zealand — first large-scale plant
  1960    The Geysers, California — largest dry steam field
  2006    Enhanced Geothermal Systems (EGS) research intensifies
  2020s   Next-gen deep drilling (Quaise, Eavor) promising breakthrough
EOF
}

cmd_resources() {
    cat << 'EOF'
=== Geothermal Resource Classification ===

--- By Temperature ---
  Low temperature:     < 90°C
    Uses: Direct heating, heat pumps, aquaculture
    Depth: 0.5 - 2 km typically

  Moderate temperature: 90 - 150°C
    Uses: Binary cycle power, industrial heat
    Depth: 1 - 3 km

  High temperature:    > 150°C
    Uses: Flash steam power, dry steam power
    Depth: 1 - 4 km (at tectonic boundaries)

--- By Reservoir Type ---

  Hydrothermal (conventional):
    Hot water or steam trapped in permeable rock
    Requires: heat source + reservoir rock + cap rock + fluid
    Where: volcanic regions, tectonic boundaries
    Most developed — majority of current capacity

  Geopressured:
    Hot, pressurized brine in sedimentary basins
    Contains dissolved methane (bonus energy)
    Gulf Coast USA — largely undeveloped

  Hot Dry Rock (HDR) / Enhanced Geothermal (EGS):
    Hot rock WITHOUT natural fluid or permeability
    Must create artificial reservoir (hydraulic stimulation)
    Available almost everywhere at sufficient depth
    Potentially 100× larger resource than hydrothermal

  Magma:
    Direct heat extraction from magma bodies
    > 600°C, enormous energy density
    Experimental only (Iceland IDDP project)

--- Geothermal Gradient Zones ---
  Normal gradient:    25-30°C/km (continental interiors)
  Elevated gradient:  40-80°C/km (sedimentary basins)
  High gradient:      80-200°C/km (volcanic regions)
  Extreme:            > 200°C/km (mid-ocean ridges, hotspots)

  Ring of Fire:       Pacific Rim — highest concentration
  East African Rift:  Kenya, Ethiopia — rapidly developing
  Iceland:            On Mid-Atlantic Ridge — unique accessibility
  Basin & Range (USA): Nevada, Utah — high heat flow
EOF
}

cmd_plants() {
    cat << 'EOF'
=== Geothermal Power Plant Types ===

--- Dry Steam ---
  Steam from reservoir → directly to turbine
  Simplest and most efficient type
  Resource requirement: > 235°C, dry steam dominant
  Efficiency: 30-40%
  Examples: The Geysers (USA), Larderello (Italy)

  Flow:
    Well → Steam separator → Turbine → Generator
                                  ↓
                             Condenser → Cooling tower
                                  ↓
                             Reinjection well

--- Single Flash ---
  Hot water (> 180°C) flashed to steam in separator
  Most common type worldwide
  15-20% of water flashes to steam
  Efficiency: 20-25%

  Flow:
    Well → Flash tank → Steam → Turbine → Generator
              ↓                      ↓
           Brine                Condenser
              ↓                      ↓
        Reinjection            Cooling tower

--- Double Flash ---
  Two pressure stages to extract more steam
  5-10% more power than single flash
  Higher complexity and cost
  Typical: 1st flash 3-7 bar, 2nd flash 1-2 bar

--- Binary Cycle ---
  Geothermal fluid heats secondary working fluid
  Working fluid: isobutane, isopentane, R134a
  Operates at lower temperatures (100-180°C)
  No fluid/emissions contact with atmosphere
  Efficiency: 10-15% (Carnot-limited by low ΔT)

  Flow:
    Well → Heat exchanger → Reinjection
              ↓ heat
    Working fluid → Turbine → Condenser → Pump
                       ↓
                    Generator

  ORC (Organic Rankine Cycle): Most common binary type
  Kalina Cycle: NH₃-H₂O mixture, higher efficiency but complex

--- Combined Cycle ---
  Flash + Binary: Flash steam runs turbine, then exhaust
  heats binary cycle for additional power
  10-20% more power than flash alone

--- Typical Plant Sizes ---
  Small binary:     0.5 - 5 MW
  Standard flash:   15 - 60 MW
  Large flash:      50 - 110 MW
  The Geysers total: ~900 MW across 18 plants
EOF
}

cmd_heatpump() {
    cat << 'EOF'
=== Ground-Source Heat Pumps (GSHP) ===

Use stable underground temperature (10-16°C year-round)
for heating in winter and cooling in summer.

--- Operating Principle ---
  Winter (heating mode):
    Ground (10°C) → Heat pump → Building (22°C)
    Extracts heat from ground, amplifies via vapor compression

  Summer (cooling mode):
    Building (26°C) → Heat pump → Ground (10°C)
    Rejects building heat into ground

  COP (Coefficient of Performance):
    COP = Heat delivered / Electrical input
    Heating COP: 3.0 - 5.0 (300-500% efficient!)
    Cooling EER: 15 - 25
    Compare: Resistive heater COP = 1.0
             Air-source heat pump COP = 2.0-3.5

--- Closed-Loop Systems ---
  Horizontal:
    Trenches at 1.2-1.8 m depth
    150-200 m of pipe per kW
    Needs large land area
    Lowest cost but most land-intensive

  Vertical (borehole):
    Boreholes 50-150 m deep
    U-tube HDPE pipe with grout
    Minimal land requirement
    Standard for commercial buildings
    Design: 40-80 W/m bore length

  Pond/Lake loop:
    Coils submerged in water body
    Needs nearby water source (> 2.5 m deep)
    Most efficient closed-loop type

--- Open-Loop Systems ---
  Pump groundwater → heat exchanger → return to aquifer
  Most efficient (direct water contact)
  Requires: aquifer, water rights, permits
  Water quality must be suitable (no scaling/fouling)
  Standing column well: partial recirculation

--- Sizing Example ---
  Building: 200 m², well-insulated
  Heating load: 10 kW peak
  Heat pump COP: 4.0
  Electrical input: 10/4 = 2.5 kW
  Ground extraction: 10 - 2.5 = 7.5 kW

  Vertical bore field:
    7.5 kW / 50 W per meter = 150 m of borehole
    Option: 2 × 75 m boreholes, 6 m apart

--- Economics ---
  CAPEX: $15,000-30,000 (residential)
         Higher than air-source, lower operating cost
  Payback: 5-10 years (vs. fossil fuel heating)
  Lifetime: Heat pump 15-25 years, ground loop 50+ years
  Energy savings: 30-60% vs conventional HVAC
EOF
}

cmd_drilling() {
    cat << 'EOF'
=== Geothermal Drilling ===

Drilling is the largest cost component (30-50% of project).
Adapted from oil & gas but with unique challenges.

--- Well Types ---
  Exploration well:     Slim (15 cm), confirm resource
  Production well:      Large (20-30 cm), extract fluid
  Injection well:       Return cooled fluid to reservoir
  Monitoring well:      Track pressure, temperature, chemistry

--- Well Design (telescoping casing) ---
  Surface casing:     50-100 m, protects groundwater
  Intermediate:       500-1500 m, isolates formations
  Production liner:   1500-3000 m, reaches reservoir
  Open hole:          Reservoir section (no casing, allows flow)

  Casing diameters (typical):
    Surface: 13-3/8" (34 cm)
    Intermediate: 9-5/8" (24 cm)
    Production: 7" (18 cm)

--- Drilling Challenges ---
  High temperature:    > 200°C degrades drilling fluids and equipment
    Standard PDC bits fail > 200°C
    Electronics limited (MWD/LWD tools)
    Cement must be heat-resistant

  Hard rock:          Crystalline basement, volcanic formations
    Slow ROP (rate of penetration): 2-5 m/h
    Severe bit wear
    Lost circulation in fractured zones

  Corrosive fluids:   H₂S, CO₂, dissolved minerals
    Special alloy casing required
    Scaling (silica, calcite) in wellbore

--- Costs ---
  Conventional (2-3 km):     $5-10 million per well
  Deep (4-5 km):             $15-30 million per well
  Ultra-deep (> 5 km):       $30-50+ million

  Cost increases exponentially with depth
  "Drilling" = 60-70% of well cost
  "Completion" (casing, cementing) = 30-40%

--- Next-Generation Drilling ---
  Millimeter-wave drilling (Quaise Energy):
    Gyrotron vaporizes rock → no drill bit wear
    Potentially 20 km depth at reduced cost
    Would make geothermal accessible everywhere

  Closed-loop systems (Eavor):
    No fracturing needed
    Sealed underground radiator
    No fluid exchange with formation
    Reduced seismic risk
EOF
}

cmd_egs() {
    cat << 'EOF'
=== Enhanced Geothermal Systems (EGS) ===

Access geothermal energy ANYWHERE by creating artificial reservoirs.
The "holy grail" — would expand geothermal from niche to global scale.

--- Concept ---
  Hot rock exists everywhere at sufficient depth
  Problem: no natural permeability or fluid
  Solution: Create fracture network, circulate water

  Injection well → Fracture network → Production well
       ↓ cold water    (hot rock)      ↑ hot water
                                       → Power plant

--- How EGS Works ---
  1. Drill injection well to hot rock (150-300°C, 3-6 km)
  2. Hydraulic stimulation: pump high-pressure water to create/
     open fractures in rock
  3. Drill production well(s) to intercept fracture network
  4. Circulate water: cold in, hot out
  5. Generate power (binary cycle plant)
  6. Re-inject cooled water (closed loop)

--- Key Parameters ---
  Temperature:         > 150°C at target depth
  Flow rate:           50-100 L/s per well pair
  Thermal drawdown:    < 10% over 30 years (sustainable)
  Water loss:          < 5% (most water recovered)
  Fracture spacing:    50-200 m optimal for heat sweep
  Reservoir volume:    > 0.1 km³ for commercial viability

--- Challenges ---
  Induced seismicity:
    Hydraulic stimulation can trigger felt earthquakes
    Basel, Switzerland (2006): M3.4 → project cancelled
    Pohang, Korea (2017): M5.5 → project terminated
    Mitigation: traffic light protocol (stop if M > 2)
    "Soft stimulation" with lower injection pressures

  Short-circuiting:
    Water flows through few dominant fractures
    Gets warm but not hot enough
    Solution: multi-stage stimulation, proper well placement

  Thermal drawdown:
    Reservoir cools over decades
    Need large fracture surface area
    Well spacing and reservoir volume critical

--- Major EGS Projects ---
  Soultz-sous-Forêts (France): 1.5 MW, 200°C at 5 km, since 2007
  Rittershoffen (France): 24 MWth, industrial heat
  FORGE (Utah, USA): DOE flagship research site
  Cooper Basin (Australia): 250°C at 4.4 km (shelved)
  Fervo Energy (USA): commercial EGS startup, 3.5 MW pilot

--- Potential ---
  USGS estimate: 500 GW recoverable EGS in USA alone
  Could provide > 100 million GWh/year
  Enough for 10%+ of global electricity demand
  Key barrier: drilling cost, not technology
EOF
}

cmd_environmental() {
    cat << 'EOF'
=== Environmental Considerations ===

--- Emissions ---
  CO₂ emissions (geothermal vs others):
    Geothermal:  15-55 g CO₂/kWh (flash plants, dissolved gases)
    Binary:      ~0 g CO₂/kWh (closed loop, no contact)
    Coal:        ~1000 g CO₂/kWh
    Natural gas: ~450 g CO₂/kWh
    Solar PV:    ~40 g CO₂/kWh (lifecycle)

  H₂S (hydrogen sulfide):
    Released from some reservoirs
    Abatement: Stretford process, activated carbon
    Modern plants: > 99.5% H₂S removal

  Non-condensable gases (NCGs):
    CO₂, H₂S, NH₃, CH₄, N₂
    0.5-5% of steam by weight
    Managed by gas extraction systems

--- Induced Seismicity ---
  Cause: Fluid injection changes pore pressure → fault slip
  Flash/dry steam plants: generally low risk (extraction-dominated)
  EGS: highest risk (intentional fracture stimulation)

  Traffic Light Protocol:
    Green:   M < 0    Continue operations
    Yellow:  M 0-2    Reduce injection rate, increase monitoring
    Red:     M > 2    Shut down injection immediately

  Basel (2006): M3.4 from EGS stimulation → project cancelled
  Largest geothermal quake: Pohang (2017) M5.5

--- Water Use ---
  Flash plants: use geothermal fluid (no freshwater intake)
  Binary plants: closed loop (minimal water use)
  Cooling towers: evaporative loss ~5-15 L/MWh
  Air-cooled condensers: no water but 10-15% less power

--- Land Use ---
  Very small footprint: 1-8 acres/MW
  Compare: solar 5-10 acres/MW, wind 30-60 acres/MW
  Wellheads can coexist with agriculture
  Subsidence: possible with fluid extraction (mitigated by reinjection)

--- Chemical Contamination ---
  Geothermal fluids may contain:
    Arsenic, boron, mercury, silica, lithium
  All fluids reinjected (no surface discharge)
  Well integrity critical to protect aquifers
  Brine ponds being eliminated (closed systems preferred)
EOF
}

cmd_economics() {
    cat << 'EOF'
=== Geothermal Economics ===

--- LCOE (Levelized Cost of Energy) ---
  Hydrothermal:    $50-80/MWh (established sites)
  EGS:             $100-200/MWh (current, declining)
  Ground-source HP: Competitive with gas heating

  For comparison:
    Solar PV:      $25-50/MWh
    Onshore wind:  $25-55/MWh
    Natural gas:   $40-80/MWh
    Nuclear:       $70-120/MWh

  But: geothermal is baseload (90%+ CF) vs intermittent renewables

--- Cost Breakdown ---
  Exploration & permitting:   10-15%
  Drilling & well completion: 30-50% (dominant cost)
  Power plant construction:   20-30%
  Steam gathering system:     10-15%
  Transmission:               5-10%

--- Risk Profile ---
  High upfront risk (exploration wells may fail)
  Resource confirmation well: $5-10M, 20-30% failure rate
  Once confirmed: very predictable returns
  Operating costs low: $10-30/MWh (no fuel cost!)

--- Capacity Factor ---
  Geothermal:     90-95% (nearly constant output)
  Solar PV:       20-25%
  Wind:           25-45%
  Nuclear:        90%
  Natural gas:    40-60% (load following)

  This high CF means lower LCOE than headline $/kW suggests

--- Revenue Streams ---
  Electricity sales (PPA or wholesale market)
  Capacity payments (firm, dispatchable power)
  Heat sales (district heating, industrial)
  Lithium extraction (from geothermal brine)
  Carbon credits (displacing fossil fuels)
  Green hydrogen production (baseload electrolysis)

--- Investment Considerations ---
  Project timeline: 5-7 years from exploration to generation
  Typical plant life: 30-50 years
  Reservoir decline: 1-3% per year (managed by make-up wells)
  Tax incentives: ITC/PTC in USA, feed-in tariffs in EU
  Financing challenge: high-risk exploration, low-risk operation

--- Cost Reduction Trends ---
  Advanced drilling (gyrotron, plasma): could halve well costs
  Closed-loop EGS: eliminates induced seismicity risk
  Supercritical resources (> 400°C): 5-10× more power per well
  Co-production: lithium, minerals, heat, power from same well
EOF
}

show_help() {
    cat << EOF
geothermal v$VERSION — Geothermal Energy Reference

Usage: script.sh <command>

Commands:
  intro          Geothermal energy overview and global potential
  resources      Resource types and temperature classification
  plants         Power plant types: dry steam, flash, binary
  heatpump       Ground-source heat pumps and COP
  drilling       Geothermal well design and drilling challenges
  egs            Enhanced Geothermal Systems
  environmental  Emissions, seismicity, water, and land use
  economics      LCOE, costs, and project economics
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)         cmd_intro ;;
    resources)     cmd_resources ;;
    plants)        cmd_plants ;;
    heatpump|hp)   cmd_heatpump ;;
    drilling)      cmd_drilling ;;
    egs)           cmd_egs ;;
    environmental|env) cmd_environmental ;;
    economics|econ) cmd_economics ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "geothermal v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
