#!/usr/bin/env bash
# esg — ESG Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== ESG: Environmental, Social, Governance ===

ESG is a framework for evaluating corporate behavior beyond
financial performance. It measures how companies manage risks
and opportunities related to sustainability.

The Three Pillars:
  E — Environmental     Climate, pollution, resources, biodiversity
  S — Social            Labor, human rights, community, diversity
  G — Governance        Board, ethics, transparency, executive pay

Why ESG Matters:

  For Investors:
    Risk management:   ESG risks → financial risks (stranded assets,
                       regulatory fines, reputational damage)
    Alpha generation:  companies with strong ESG may outperform
    Client demand:     $35+ trillion in ESG assets globally (2024)
    Regulatory:        increasing disclosure requirements

  For Companies:
    Access to capital: ESG-focused funds growing rapidly
    Cost of capital:   better ESG → lower borrowing costs
    Talent attraction: employees prefer responsible employers
    License to operate: community and regulatory goodwill
    Innovation:        sustainability drives new products/markets

History:
  2004: UN "Who Cares Wins" report coins ESG
  2006: UN Principles for Responsible Investment (PRI) launched
  2015: Paris Agreement + SDGs create policy momentum
  2019: Business Roundtable redefines corporate purpose
  2020: ESG investing goes mainstream ($30T+ AUM)
  2022: EU CSRD and SFDR regulations take effect
  2023: ISSB releases S1 and S2 sustainability standards
  2024: CSRD reporting begins for largest companies

Materiality:
  Financial materiality:    ESG issues that affect company value
    (investor perspective — "outside-in")
  Impact materiality:       Company impact on environment/society
    (stakeholder perspective — "inside-out")
  Double materiality:       BOTH perspectives together
    (EU CSRD requires this)
  
  Not all ESG issues are equally material to all sectors:
    Oil & gas: climate (E) is most material
    Banking: governance (G) and conduct risk dominant
    Retail: supply chain labor (S) is critical
    Tech: data privacy (S) and energy use (E)
EOF
}

cmd_environmental() {
    cat << 'EOF'
=== Environmental Pillar ===

Climate Change / GHG Emissions:
  Scope 1, 2, 3 emissions (see: emission skill)
  Carbon intensity (tCO₂e per revenue or unit produced)
  Science-based targets (SBTi alignment)
  Net-zero commitments and transition plans
  Climate scenario analysis (2°C, 1.5°C pathways)
  Physical risk exposure (extreme weather, sea-level rise)
  Transition risk exposure (carbon pricing, technology shifts)

Energy:
  Total energy consumption (GJ or MWh)
  Renewable energy percentage
  Energy intensity (GJ per unit output)
  Energy efficiency improvements (year over year)
  RE100 / 100% renewable electricity commitment

Water:
  Total water withdrawal by source
  Water consumption vs discharge
  Water stress area exposure (WRI Aqueduct tool)
  Water recycling and reuse rates
  Wastewater quality (BOD, COD, heavy metals)

Pollution & Waste:
  Hazardous waste generated and disposal method
  Non-hazardous waste and recycling rates
  Air pollutants (NOx, SOx, PM, VOC)
  Toxic release inventory (TRI) reports
  Circular economy metrics (% recycled content, recyclability)
  Plastic footprint

Biodiversity & Land Use:
  Operations in or near protected areas
  Biodiversity impact assessments
  Deforestation-free supply chains
  Land use change and restoration
  TNFD (Taskforce on Nature-related Financial Disclosures)
  
Key Metrics:
  GHG emissions (Scope 1+2+3)        Most reported metric
  Carbon intensity                     Normalized for company size
  Renewable energy %                   Energy transition progress
  Water intensity                      Efficiency measure
  Waste diversion rate                 Circular economy progress
  CDP score (A to D-)                  Climate disclosure quality
EOF
}

cmd_social() {
    cat << 'EOF'
=== Social Pillar ===

Labor Practices:
  Employee health & safety (LTIR, TRIR, fatalities)
  Workforce composition (full-time, part-time, contractors)
  Employee turnover rate and retention
  Training and development hours per employee
  Living wage vs minimum wage policies
  Freedom of association and collective bargaining
  Working hours and overtime practices

Diversity, Equity & Inclusion:
  Gender diversity (board, management, workforce)
  Racial/ethnic diversity
  Gender pay gap ratio
  LGBTQ+ inclusion policies
  Disability inclusion
  Age diversity
  
  Key metrics:
    Women on board:          global average ~24%
    Women in management:     varies widely by sector
    Pay gap:                 median vs mean, adjusted vs unadjusted

Human Rights:
  UN Guiding Principles on Business and Human Rights
  Human rights due diligence process
  Modern slavery / forced labor prevention
  Child labor policies and auditing
  Indigenous peoples' rights
  Conflict minerals (3TG: tin, tantalum, tungsten, gold)
  Supply chain human rights assessment

Community Impact:
  Community investment and philanthropy
  Local hiring and procurement policies
  Social impact assessments for projects
  Stakeholder engagement processes
  Free, prior, and informed consent (FPIC)
  Tax transparency and contribution

Product Responsibility:
  Customer health and safety
  Data privacy and cybersecurity
  Product labeling and marketing ethics
  Access to products/services (affordability)
  Responsible use of AI and algorithms

Supply Chain:
  Supplier code of conduct
  Supplier ESG auditing and assessment
  Conflict minerals reporting
  Supply chain transparency (tier mapping)
  Sustainable procurement policies
  Modern Slavery Act compliance
EOF
}

cmd_governance() {
    cat << 'EOF'
=== Governance Pillar ===

Board Structure:
  Board independence (% independent directors)
  Board size and composition
  Separation of Chair and CEO roles
  Lead independent director
  Board diversity (gender, skills, background, tenure)
  Director overboarding (too many boards)
  Board meeting attendance
  Board committees: audit, compensation, nominating, risk, sustainability
  
  Best practice:
    >50% independent directors
    Separate Chair/CEO
    Annual director elections (not staggered)
    Board diversity policy with targets
    Regular board effectiveness evaluations

Executive Compensation:
  Pay-for-performance alignment
  CEO-to-median-worker pay ratio
  Short-term vs long-term incentive mix
  ESG metrics in compensation (growing trend)
  Clawback policies
  Golden parachute provisions
  Say-on-pay vote results
  
  Red flags:
    Excessive pay disconnected from performance
    High guaranteed bonuses
    No clawback provisions
    CEO pay ratio >300:1

Ethics & Integrity:
  Anti-corruption and anti-bribery policies
  Code of conduct and ethics training
  Whistleblower protection mechanisms
  Political lobbying and contributions disclosure
  Tax transparency (country-by-country reporting)
  Anti-competitive behavior history
  Regulatory fines and sanctions history

Risk Management:
  Enterprise risk management framework
  Climate risk integration (TCFD)
  Cybersecurity governance
  Internal audit function
  Related-party transaction oversight
  Risk appetite statement

Shareholder Rights:
  One-share-one-vote vs dual-class shares
  Proxy access for director nominations
  Written consent rights
  Special meeting rights
  Anti-takeover provisions (poison pills)
  Cumulative voting for directors

Transparency:
  Financial reporting quality
  Audit firm independence and rotation
  Related-party transactions disclosure
  ESG report assurance (limited vs reasonable)
  Integrated reporting (<IR> framework)
  Real-time vs annual disclosure
EOF
}

cmd_frameworks() {
    cat << 'EOF'
=== ESG Reporting Frameworks ===

GRI (Global Reporting Initiative):
  Purpose: impact materiality (company impact on world)
  Scope: universal + sector-specific standards
  Users: 10,000+ organizations globally
  Structure:
    GRI 1: Foundation (principles)
    GRI 2: General Disclosures (governance, strategy)
    GRI 3: Material Topics
    GRI 200s: Economic topics
    GRI 300s: Environmental topics
    GRI 400s: Social topics
  Modular: report on material topics for your sector

SASB (now part of ISSB):
  Purpose: financial materiality (ESG affecting company value)
  Scope: 77 industry-specific standards
  Focus: investor audience
  Identifies: 2–8 material ESG topics per industry
  Example (Oil & Gas):
    GHG emissions, air quality, water management,
    biodiversity, reserves valuation, workforce safety

ISSB / IFRS S1 and S2:
  Purpose: global baseline for sustainability disclosure
  S1: General sustainability disclosure (all ESG)
  S2: Climate-related disclosures (TCFD-aligned)
  Status: effective January 2024
  Adoption: mandatory in UK, Japan, Brazil, Singapore, etc.
  Compatible with: GRI (can use both together)
  Industry-specific: SASB standards incorporated

EU CSRD / ESRS:
  Purpose: double materiality (financial + impact)
  Scope: all large EU companies + listed SMEs
  Standards: 12 ESRS (European Sustainability Reporting Standards)
    ESRS E1: Climate change
    ESRS E2: Pollution
    ESRS E3: Water and marine resources
    ESRS E4: Biodiversity and ecosystems
    ESRS E5: Resource use and circular economy
    ESRS S1-S4: Workers, value chain, communities, consumers
    ESRS G1: Business conduct
  Timeline: large companies 2024, smaller 2025–2026
  Assurance: limited → reasonable (phased)

TCFD (now ISSB S2):
  Four pillars: Governance, Strategy, Risk Management, Metrics & Targets
  Scenario analysis required (2°C and 1.5°C)
  Absorbed into ISSB S2 in 2023

Framework Convergence (the landscape is simplifying!):
  ISSB S1/S2 = global investor-focused baseline
  CSRD/ESRS = EU double materiality (broader)
  GRI = impact reporting (complementary to ISSB)
  SASB → incorporated into ISSB
  TCFD → incorporated into ISSB S2
  <IR> → incorporated into IFRS framework
EOF
}

cmd_ratings() {
    cat << 'EOF'
=== ESG Ratings ===

Major Rating Providers:

  MSCI ESG Ratings:
    Scale: AAA to CCC (7 levels)
    Coverage: 8,500+ companies
    Methodology: 35 key issues, industry-weighted
    Weight: governance issues underweighted vs E&S
    Update: continuous monitoring
    Used by: largest ESG index family (MSCI ESG Leaders)

  Sustainalytics (Morningstar):
    Scale: 0–100 risk score (lower = better)
    Categories: negligible, low, medium, high, severe
    Coverage: 16,000+ companies
    Focus: ESG risk exposure vs management
    Unique: unmanaged risk as key metric

  S&P Global CSA:
    Scale: 0–100 score
    Basis: Corporate Sustainability Assessment questionnaire
    Used for: Dow Jones Sustainability Indices (DJSI)
    Coverage: 10,000+ companies
    Methodology: 20-25 industry-specific criteria

  ISS ESG:
    Scale: A+ to D- (12 levels)
    Focus: governance and proxy voting
    Used by: institutional investors for voting recommendations
    Coverage: 9,000+ companies

  CDP:
    Scale: A to D- (Leadership, Management, Awareness, Disclosure)
    Focus: climate, water, forests (separate scores)
    Based on: self-reported questionnaire
    Coverage: 23,000+ companies
    Unique: raw data available (not just a score)

Rating Divergence Problem:
  Correlation between providers: only 0.4–0.6!
  (Compare: credit ratings correlate at 0.9+)
  
  Same company can be:
    MSCI: AA ("leader")
    Sustainalytics: 32 ("high risk")
    CDP: B ("management")
  
  Why divergence?
    Different scope:     which issues are included
    Different weight:    how much each issue matters
    Different measure:   policies vs performance vs disclosure
    Different source:    self-reported vs third-party vs AI/NLP

Implications:
  Don't rely on a single rating
  Understand each provider's methodology
  Look at underlying data, not just the headline score
  Consider sector-specific materiality
  ESG ratings ≠ ESG impact (ratings measure risk management)
EOF
}

cmd_investing() {
    cat << 'EOF'
=== ESG Investment Strategies ===

Strategy Spectrum (least → most impact):

  1. Negative/Exclusionary Screening:
     Exclude sectors: tobacco, weapons, fossil fuels, gambling
     Norms-based: exclude UN Global Compact violators
     Most common approach globally
     AUM: ~$15 trillion
     Criticism: doesn't change corporate behavior

  2. ESG Integration:
     Incorporate ESG factors into financial analysis
     Not exclusion — ESG as additional risk/return input
     Analyst adjusts forecasts based on ESG factors
     Example: climate risk → adjust discount rate
     AUM: ~$25 trillion (fastest growing)

  3. Best-in-Class:
     Invest in ESG leaders within each sector
     Even "dirty" sectors included (best oil company)
     Maintains sector diversification
     MSCI ESG Leaders, DJSI indexes

  4. Thematic Investing:
     Target specific ESG themes:
       Clean energy, water, circular economy, gender equality
     Concentrated exposure to sustainability trends
     Higher tracking error vs broad benchmarks
     Examples: iShares Global Clean Energy, Water ETFs

  5. Impact Investing:
     Intentional positive impact + financial return
     Measurable outcomes (SDG alignment)
     Examples: green bonds, social bonds, microfinance
     Impact measurement: IRIS+ metrics, Theory of Change
     AUM: ~$1.2 trillion (growing but still niche)

  6. Active Ownership / Stewardship:
     Use shareholder rights to drive change:
       Proxy voting on ESG resolutions
       Direct engagement with management
       Filing shareholder proposals
       Coalition engagement (Climate Action 100+)
     Doesn't require selling — changes behavior from within

Performance Debate:
  Meta-studies show:
    Positive or neutral ESG-return relationship in ~60% of studies
    Negative relationship in ~10%
    Mixed/inconclusive in ~30%
  
  Key insight: ESG is a risk factor, not automatic alpha
  Downside protection: ESG tends to outperform during crises
  Long-term: sustainability risks are financial risks

Greenwashing Risks:
  Fund labeled "ESG" but holdings include fossil fuels
  High ESG score ≠ positive environmental impact
  "ESG integration" can be minimal checkbox exercise
  Look for: process transparency, voting records, holdings disclosure
  EU SFDR classification:
    Article 6: no sustainability objective
    Article 8: promotes ESG characteristics ("light green")
    Article 9: sustainable investment objective ("dark green")
EOF
}

cmd_regulation() {
    cat << 'EOF'
=== ESG Regulation ===

European Union (most advanced):

  EU Taxonomy:
    Classification system defining "sustainable" activities
    6 environmental objectives:
      1. Climate mitigation
      2. Climate adaptation
      3. Water & marine resources
      4. Circular economy
      5. Pollution prevention
      6. Biodiversity
    
    Three tests for each activity:
      Substantial contribution to ≥1 objective
      Do No Significant Harm (DNSH) to other objectives
      Minimum social safeguards
    
    Disclosure: companies report % revenue/CAPEX/OPEX aligned

  SFDR (Sustainable Finance Disclosure Regulation):
    Applies to: asset managers, advisors, pension funds
    Entity-level: sustainability risk policy, adverse impact statement
    Product-level:
      Article 6:  considers sustainability risks (baseline)
      Article 8:  promotes E or S characteristics
      Article 9:  has sustainable investment as objective
    PAI (Principal Adverse Impact) indicators: 14 mandatory

  CSRD (Corporate Sustainability Reporting Directive):
    Replaces: NFRD (Non-Financial Reporting Directive)
    Scope: ~50,000 EU companies (vs 11,000 under NFRD)
    Standards: ESRS (12 topic standards)
    Assurance: limited, moving to reasonable
    Timeline: 2024 (large), 2025 (listed), 2026 (SMEs)
    Digital tagging: XBRL taxonomy for machine readability

  CSDDD (Corporate Sustainability Due Diligence):
    Human rights and environmental due diligence in value chain
    Applies to: large EU companies and non-EU with EU revenue
    Liability: potential civil liability for harm

United States:

  SEC Climate Disclosure Rule (2024):
    Scope 1 and 2 GHG emissions (large accelerated filers)
    Climate risk governance and strategy
    Scenario analysis encouraged
    Assurance: limited → reasonable (phased)
    Status: challenged in court, implementation uncertain

  State-level:
    California SB 253: Scope 1,2,3 for companies >$1B revenue
    California SB 261: climate risk disclosure
    Various state divestment/anti-divestment laws

Asia-Pacific:

  Japan: ISSB S1/S2 adoption for Prime Market companies
  Singapore: mandatory climate disclosure (2025+)
  Hong Kong: ISSB-aligned disclosure (2025+)
  China: mandatory ESG disclosure for listed companies (2024+)
  Australia: mandatory climate disclosure (2024+)
  India: BRSR (Business Responsibility and Sustainability Report)

Global Trend:
  2020: ~20 jurisdictions with ESG disclosure rules
  2024: ~50 jurisdictions with mandatory or recommended rules
  Direction: convergence around ISSB baseline + jurisdictional additions
  Assurance: moving from voluntary to mandatory
  Scope 3: most controversial, being phased in gradually
EOF
}

show_help() {
    cat << EOF
esg v$VERSION — ESG Reference

Usage: script.sh <command>

Commands:
  intro          ESG overview, pillars, history, materiality
  environmental  Climate, energy, water, waste, biodiversity metrics
  social         Labor, diversity, human rights, community
  governance     Board structure, ethics, compensation, transparency
  frameworks     GRI, SASB, ISSB/IFRS, CSRD/ESRS, TCFD
  ratings        MSCI, Sustainalytics, S&P, CDP — divergence problem
  investing      Screening, integration, thematic, impact, stewardship
  regulation     EU Taxonomy, SFDR, SEC, global ESG regulation
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)         cmd_intro ;;
    environmental) cmd_environmental ;;
    social)        cmd_social ;;
    governance)    cmd_governance ;;
    frameworks)    cmd_frameworks ;;
    ratings)       cmd_ratings ;;
    investing)     cmd_investing ;;
    regulation)    cmd_regulation ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "esg v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
