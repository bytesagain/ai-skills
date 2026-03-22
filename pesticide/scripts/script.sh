#!/usr/bin/env bash
# pesticide — Pesticide Management Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Pesticide Management ===

A pesticide is any substance used to prevent, destroy, repel, or
mitigate pests — including insects, weeds, fungi, rodents, and
microorganisms that damage crops or harm human health.

Classification by Target:
  Insecticide     Kills/repels insects (aphids, caterpillars, beetles)
  Herbicide       Kills/inhibits weeds (broadleaf, grasses)
  Fungicide       Prevents/cures fungal diseases (rust, blight, mildew)
  Rodenticide     Controls rodents (rats, mice, gophers)
  Nematicide      Controls nematodes (root-knot, cyst)
  Acaricide       Controls mites and ticks
  Bactericide     Controls bacterial diseases
  Molluscicide    Controls slugs and snails
  Plant Growth Regulator (PGR)  Modifies plant growth

Classification by Mode of Action:
  Contact:     Kills on contact (must hit the pest directly)
  Systemic:    Absorbed by plant, moves through vascular system
  Translaminar: Moves through leaf but not whole plant
  Fumigant:    Gas phase — fills enclosed space
  Stomach:     Must be ingested by pest

Classification by Toxicity (WHO):
  Class Ia   Extremely hazardous    (parathion, phorate)
  Class Ib   Highly hazardous       (carbofuran, methamidophos)
  Class II   Moderately hazardous   (chlorpyrifos, DDT)
  Class III  Slightly hazardous     (malathion, glyphosate)
  Class U    Unlikely to cause harm (most biologicals)

Signal Words on Labels:
  DANGER:   Highly toxic (oral LD50 < 50 mg/kg)
  WARNING:  Moderately toxic (LD50 50-500 mg/kg)
  CAUTION:  Slightly toxic (LD50 > 500 mg/kg)

Regulatory Framework:
  US:     EPA registers pesticides under FIFRA
  EU:     EFSA evaluates, member states authorize
  China:  ICAMA (Institute for Control of Agrochemicals, MOA)
  Codex:  Codex Alimentarius sets international MRLs
  "The label is the law" — use strictly per label directions
EOF
}

cmd_classes() {
    cat << 'EOF'
=== Pesticide Chemical Classes ===

INSECTICIDES:

Organophosphates (OP):
  Mode: Acetylcholinesterase (AChE) inhibitor
  Examples: chlorpyrifos, malathion, diazinon
  Pros: broad-spectrum, effective
  Cons: high mammalian toxicity, environmental persistence
  Status: many restricted/banned (chlorpyrifos banned on food in US 2022)
  IRAC Group: 1B

Pyrethroids:
  Mode: Sodium channel modulators (nerve poison)
  Examples: permethrin, cypermethrin, lambda-cyhalothrin, bifenthrin
  Pros: low mammalian toxicity, fast knockdown
  Cons: toxic to aquatic organisms and bees, resistance widespread
  IRAC Group: 3A

Neonicotinoids:
  Mode: Nicotinic acetylcholine receptor agonists
  Examples: imidacloprid, thiamethoxam, clothianidin
  Pros: systemic, excellent for sucking insects
  Cons: highly toxic to bees (pollinator crisis), banned outdoor EU 2018
  IRAC Group: 4A

Diamides:
  Mode: Ryanodine receptor modulators (muscle paralysis)
  Examples: chlorantraniliprole, cyantraniliprole
  Pros: low toxicity to mammals and bees, long residual
  Cons: expensive, resistance emerging
  IRAC Group: 28

Bt (Bacillus thuringiensis) — Biological:
  Mode: Crystal proteins disrupt insect gut
  Strains: kurstaki (caterpillars), israelensis (mosquitoes)
  Pros: organic-approved, highly specific, safe for beneficials
  Cons: UV-sensitive, must be ingested, narrow spectrum
  IRAC Group: 11

HERBICIDES:

Glyphosate:
  Mode: EPSP synthase inhibitor (amino acid synthesis)
  HRAC Group: 9
  Pros: broad-spectrum, non-selective, no soil residual
  Cons: resistance in 50+ weed species, controversy over carcinogenicity

Atrazine:
  Mode: Photosystem II inhibitor
  HRAC Group: 5
  Use: pre/post-emergence in corn, sorghum
  Cons: groundwater contamination, banned in EU

FUNGICIDES:

Triazoles (DMI):
  Mode: Sterol biosynthesis inhibitor
  FRAC Group: 3
  Examples: propiconazole, tebuconazole, epoxiconazole
  Use: cereals, fruits, vegetables — powdery mildew, rusts

Strobilurins (QoI):
  Mode: Mitochondrial respiration inhibitor
  FRAC Group: 11
  Examples: azoxystrobin, pyraclostrobin
  Use: broad-spectrum, plant health effects
  Cons: high resistance risk (single-site mode of action)
EOF
}

cmd_ipm() {
    cat << 'EOF'
=== Integrated Pest Management (IPM) ===

IPM is a sustainable approach that combines multiple tactics to
manage pests below economically damaging levels while minimizing
risks to people and the environment.

IPM Pyramid (least to most intervention):
  △ Chemical control (pesticides — last resort)
  ▽ Biological control (natural enemies)
  ▽ Cultural practices (crop rotation, resistant varieties)
  ▽ Prevention (sanitation, exclusion, monitoring)

1. Prevention:
  - Certified disease-free seed
  - Resistant/tolerant varieties
  - Clean equipment between fields
  - Quarantine new plant material
  - Proper irrigation (avoid leaf wetness)
  - Crop rotation (break pest cycles)

2. Monitoring / Scouting:
  - Walk fields weekly (W pattern or systematic grid)
  - Identify pests to species level
  - Count pest density per plant or per trap
  - Record weather conditions (temperature, humidity)
  - Use pheromone traps for moths (codling moth, corn borer)
  - Yellow sticky traps for whitefly, thrips, fungus gnats

3. Economic Thresholds:
  Pest density at which control cost < crop damage
  Examples:
    Soybean aphid: 250 aphids/plant with increasing population
    Corn rootworm: 1+ beetle/plant during silking
    Wheat stem rust: first pustules visible on susceptible variety
  Below threshold: don't spray (beneficial insects may handle it)
  At/above threshold: take action

4. Biological Control:
  Conservation: protect existing natural enemies
    - Reduce broad-spectrum pesticide use
    - Plant insectary strips (flowering borders)
    - Provide habitat (beetle banks, hedgerows)
  Augmentation: release purchased beneficials
    - Trichogramma wasps (caterpillar eggs)
    - Ladybugs/lacewings (aphids)
    - Parasitic nematodes (soil grubs)
  Classical: import natural enemy from pest's native range

5. Chemical Control (when justified):
  - Select least-toxic effective option
  - Use targeted products (not broad-spectrum)
  - Rotate modes of action (prevent resistance)
  - Apply at optimal timing (pest life stage matters)
  - Spot-treat rather than broadcast when possible
  - Follow label rates exactly
EOF
}

cmd_application() {
    cat << 'EOF'
=== Application Methods & Rates ===

Spray Application:
  Boom sprayer:   Field crops, broadcast application
  Airblast:       Orchards, vineyards (radial fan)
  Backpack:       Small plots, spot treatment
  Aerial:         Large acreage, difficult terrain
  Drone:          Precision spot spray, small fields

Spray Volume Categories:
  Ultra-low volume (ULV):  <5 L/ha  (concentrate, small droplet)
  Low volume:              5-200 L/ha (typical aerial)
  Medium volume:           200-600 L/ha (typical ground)
  High volume:             >600 L/ha (orchards, dense canopy)

Calculating Application Rate:
  Rate = Product amount × Area to treat
  Example: Label says 2 L/ha, field is 5 ha → need 10 L product

  Spray calibration:
    1. Fill tank with water
    2. Spray measured distance at normal speed
    3. Measure water used
    4. Calculate: L/ha = (L used × 10,000) / (width × distance)
    5. Adjust pressure/speed/nozzle until target rate achieved

Nozzle Selection:
  Flat fan:     Broadcast herbicide (110° even pattern)
  Hollow cone:  Insecticide/fungicide (fine droplets, coverage)
  Full cone:    Soil-applied, coarse spray
  Air induction: Drift reduction (large droplets with air)

  Droplet size matters:
    Fine (<200µm):    Better coverage, higher drift risk
    Medium (200-400):  General purpose
    Coarse (>400):     Drift reduction, less coverage
    VMD (Volume Median Diameter) — specify on label

Other Methods:
  Seed treatment:   Coat seeds with fungicide/insecticide before planting
  Soil drench:      Liquid poured at plant base (systemic uptake)
  Granular:         Broadcast or banded granules (soil incorporation)
  Fumigation:       Gas injected under tarp (methyl bromide, chloropicrin)
  Bait:             Rodenticide/molluscicide mixed with attractant
  Trunk injection:  Tree systemic treatment (emerald ash borer)

Mixing Order (WALE):
  W — Wettable powders / water-dispersible granules (first)
  A — Agitation (ensure suspension)
  L — Liquids / flowables / emulsifiable concentrates
  E — Emulsions / surfactants / adjuvants (last)
  Always add product to water, never water to product
EOF
}

cmd_safety() {
    cat << 'EOF'
=== Pesticide Safety ===

Personal Protective Equipment (PPE):
  Minimum for all applications:
    - Long-sleeved shirt and long pants
    - Chemical-resistant gloves
    - Shoes plus socks
    - Eye protection (goggles or face shield)

  For higher-toxicity products:
    - Chemical-resistant suit (Tyvek or similar)
    - Respirator with organic vapor cartridges
    - Chemical-resistant boots
    - Head covering

  Label specifies minimum PPE — always follow label

Restricted Entry Interval (REI):
  Time after application before workers can enter treated area
  Without full PPE
  Common REIs:
    4 hours:    Most low-toxicity products
    12 hours:   Many herbicides, some insecticides
    24 hours:   Organophosphates, some fungicides
    48 hours:   Highly toxic products
  Must post field entry restrictions (warning signs)

Pre-Harvest Interval (PHI):
  Minimum days between last application and harvest
  Ensures residues are below MRL at harvest
  Examples:
    Glyphosate on wheat:       7 days
    Chlorpyrifos on apples:    28 days
    Azoxystrobin on grapes:    14 days
    Imidacloprid on tomatoes:  1 day
  Violating PHI = illegal residues → crop rejection

Storage Requirements:
  - Locked, ventilated building (separate from feed/food)
  - Original labeled containers only
  - Organize by type (herbicides separate from insecticides)
  - Concrete or impervious floor with containment berm
  - Fire extinguisher rated for chemical fires
  - Emergency contact numbers posted
  - Inventory log maintained

Disposal:
  - Triple-rinse empty containers (rinse water into spray tank)
  - Puncture containers to prevent reuse
  - Return to dealer or approved collection site
  - NEVER burn, bury, or dump pesticide waste
  - Surplus: apply to labeled crop at labeled rate

Spill Response:
  1. Protect yourself (PPE)
  2. Stop the source
  3. Contain the spill (absorbent, berms)
  4. Clean up (sweep solids, absorb liquids)
  5. Decontaminate area
  6. Report if required (>1 lb active ingredient in water)
EOF
}

cmd_resistance() {
    cat << 'EOF'
=== Resistance Management ===

Resistance = pest population evolves to survive pesticide exposure.
Over 600 insect and mite species have documented resistance.
Over 260 weed species are herbicide-resistant.

How Resistance Develops:
  1. Natural variation: a few individuals carry resistance genes
  2. Selection pressure: pesticide kills susceptible, resistant survive
  3. Reproduction: resistant individuals breed, pass genes
  4. Dominance: resistant population replaces susceptible
  Timeline: can develop in 5-20 generations with heavy use

Mode of Action Groups:

  IRAC (Insecticide Resistance Action Committee):
    Group 1:  AChE inhibitors (OPs, carbamates)
    Group 3:  Sodium channel modulators (pyrethroids)
    Group 4:  nAChR agonists (neonicotinoids)
    Group 28: Ryanodine receptor modulators (diamides)
    Group 11: Bt proteins

  FRAC (Fungicide Resistance Action Committee):
    Group 3:  DMI fungicides (triazoles)
    Group 7:  SDHI fungicides (boscalid, fluopyram)
    Group 11: QoI fungicides (strobilurins) — HIGH RISK
    Group M:  Multi-site (mancozeb, copper) — LOW RISK

  HRAC (Herbicide Resistance Action Committee):
    Group 1:  ACCase inhibitors (graminicides)
    Group 2:  ALS inhibitors (sulfonylureas) — HIGH RISK
    Group 4:  Synthetic auxins (2,4-D, dicamba)
    Group 9:  EPSP synthase inhibitors (glyphosate)
    Group 10: Glutamine synthetase inhibitors (glufosinate)

Resistance Management Strategies:
  1. Rotate modes of action — never use same group consecutively
  2. Tank-mix different MOA groups — multiple targets simultaneously
  3. Use full labeled rates — sub-lethal doses accelerate resistance
  4. Integrate non-chemical controls (IPM pyramid)
  5. Monitor for efficacy loss — early detection critical
  6. Use refuge areas (Bt crops: 20% non-Bt refuge for insects)
  7. Alternate crop types in rotation
  8. Target most vulnerable pest life stage

Example Rotation Plan (Insecticides):
  Spray 1: Group 28 (diamide)
  Spray 2: Group 4A (neonicotinoid)
  Spray 3: Biological (Bt or beneficial release)
  Spray 4: Group 3A (pyrethroid)
  Never: Group 28 → Group 28 → Group 28
EOF
}

cmd_regulations() {
    cat << 'EOF'
=== Pesticide Regulations ===

US Federal Framework:
  FIFRA (Federal Insecticide, Fungicide, and Rodenticide Act):
    - All pesticides must be EPA-registered before sale
    - Registration requires safety data (toxicology, ecotoxicology)
    - Re-registration every 15 years
    - States can impose additional restrictions (e.g., California)

  FQPA (Food Quality Protection Act, 1996):
    - Single health-based standard for all food uses
    - Extra 10x safety factor for children
    - Aggregate exposure (food + water + residential)
    - Cumulative risk assessment (same MOA chemicals)

Maximum Residue Limits (MRLs):
  Definition: highest legal residue level (mg/kg) in food at harvest
  Set by: EPA (US), EFSA (EU), Codex Alimentarius (international)

  Common MRL examples (mg/kg):
    Pesticide        Crop      US MRL    EU MRL    Codex
    Glyphosate       Wheat     30        10        30
    Chlorpyrifos     Apple     0.01*     0.01      1.0
    Imidacloprid     Tomato    0.5       0.5       0.5
    * US revoked most food tolerances 2022

  If no MRL set: default tolerance = 0.01 mg/kg (EU) or illegal (US)
  Export: must meet IMPORTING country's MRL (not exporting)

Record-Keeping Requirements:
  Required records per application:
    - Product name and EPA registration number
    - Date and time of application
    - Location (field ID, GPS preferred)
    - Crop treated
    - Target pest
    - Rate and total amount applied
    - Application method and equipment
    - Wind speed, temperature, REI
    - Applicator name and license number

  Retention: 2 years (federal minimum, states may require longer)
  Restricted Use Pesticides (RUP): additional reporting required

Licensing:
  Private applicator: own land, own crops
  Commercial applicator: applying for hire
  Both require: training + exam + periodic recertification
  Categories: agricultural, ornamental, structural, aquatic, etc.

Organic Certification:
  OMRI (Organic Materials Review Institute) lists approved products
  Allowed: Bt, copper, sulfur, neem, pyrethrin (natural), kaolin
  Not allowed: synthetic chemicals, GMOs
  Transition period: 3 years without prohibited substances
  National Organic Program (NOP) — USDA administered
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Pesticide Application Checklist ===

Before Application:
  [ ] Pest correctly identified (species level)
  [ ] Economic threshold reached (scouting data confirms)
  [ ] Product selected appropriate for pest and crop
  [ ] Label read completely (THE LABEL IS THE LAW)
  [ ] Product not expired or degraded
  [ ] Rate calculated for field size
  [ ] PHI compatible with harvest schedule
  [ ] REI noted and workers notified
  [ ] Weather checked (no rain 4-6h, wind <10 mph, no inversion)
  [ ] Buffer zones identified (water, schools, beehives)

Equipment:
  [ ] Sprayer calibrated recently (within 30 days)
  [ ] Nozzles inspected — replace if >10% flow variation
  [ ] Filters clean
  [ ] Correct nozzle type for application (flat fan, cone, etc.)
  [ ] Tank clean from previous product
  [ ] Agitation working properly
  [ ] PPE available and in good condition

During Application:
  [ ] PPE worn as specified on label
  [ ] Application rate verified (check pressure/speed)
  [ ] Overlap minimized (GPS guidance if available)
  [ ] Buffer zones respected
  [ ] Wind monitored continuously
  [ ] No spray drift to non-target areas
  [ ] Spill kit accessible on spray vehicle

After Application:
  [ ] Application record completed immediately
  [ ] Field posted with REI signage
  [ ] Equipment triple-rinsed (rinsate applied to field)
  [ ] PPE cleaned or disposed properly
  [ ] Containers triple-rinsed and punctured
  [ ] Storage area organized and locked
  [ ] Observation for efficacy (3-7 days post-application)
  [ ] Follow-up scouting scheduled

Compliance:
  [ ] Applicator license current
  [ ] Records stored for minimum retention period
  [ ] RUP purchase records maintained
  [ ] Worker Protection Standard (WPS) training current
  [ ] Emergency response procedures posted
  [ ] SDS (Safety Data Sheets) available for all products
EOF
}

show_help() {
    cat << EOF
pesticide v$VERSION — Pesticide Management Reference

Usage: script.sh <command>

Commands:
  intro        Pesticide overview, classification, toxicity
  classes      Chemical classes: OPs, pyrethroids, neonics, Bt
  ipm          Integrated Pest Management strategies
  application  Spray methods, calibration, nozzles, rates
  safety       PPE, REI, PHI, storage, disposal, spills
  resistance   IRAC/FRAC/HRAC groups, rotation strategies
  regulations  EPA, MRLs, record-keeping, licensing
  checklist    Application and compliance checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    classes)     cmd_classes ;;
    ipm)         cmd_ipm ;;
    application) cmd_application ;;
    safety)      cmd_safety ;;
    resistance)  cmd_resistance ;;
    regulations) cmd_regulations ;;
    checklist)   cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "pesticide v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
