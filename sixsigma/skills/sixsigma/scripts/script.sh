#!/usr/bin/env bash
# sixsigma — Six Sigma Methodology Reference
set -euo pipefail
VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Six Sigma ===

Six Sigma is a data-driven methodology for eliminating defects and
reducing variation in any process. Goal: 3.4 defects per million
opportunities (DPMO).

Sigma Levels:
  1σ  691,462 DPMO  30.85% yield
  2σ  308,538 DPMO  69.15% yield
  3σ   66,807 DPMO  93.32% yield
  4σ    6,210 DPMO  99.38% yield
  5σ      233 DPMO  99.977% yield
  6σ     3.4  DPMO  99.9997% yield

(Includes 1.5σ long-term shift)

History:
  1986  Bill Smith at Motorola creates Six Sigma
  1995  Jack Welch makes it central to GE strategy
  2000s Merges with Lean → Lean Six Sigma

Belt System:
  White Belt    Awareness, support project teams
  Yellow Belt   Basic tools, part-time project member
  Green Belt    Lead small projects, know core tools
  Black Belt    Lead complex projects, mentor GBs, full-time
  Master Black Belt  Train BBs, strategic deployment, coach

Two Methodologies:
  DMAIC    Improve existing processes (most common)
  DMADV    Design new processes/products (Design for Six Sigma)
EOF
}

cmd_dmaic() {
    cat << 'EOF'
=== DMAIC Phases ===

D — DEFINE
  Purpose: What's the problem and why does it matter?
  Key activities:
    - Write problem statement (specific, measurable)
    - Define project scope (in/out boundaries)
    - Identify customer CTQs (Critical to Quality)
    - Create project charter (goal, team, timeline, budget)
    - Map high-level process (SIPOC)
  Deliverables: Project charter, SIPOC, VOC/CTQ tree

M — MEASURE
  Purpose: How bad is the problem? How do we measure it?
  Key activities:
    - Define Y (output metric) and operational definition
    - Validate measurement system (MSA / Gage R&R)
    - Collect baseline data
    - Calculate current sigma level
    - Create process map (detailed)
  Deliverables: Data collection plan, baseline Cpk, process map

A — ANALYZE
  Purpose: What causes the problem?
  Key activities:
    - Identify potential X's (input variables)
    - Analyze data: hypothesis tests, regression, ANOVA
    - Root cause analysis (fishbone, 5 Why, fault tree)
    - Validate root causes with data
    - Prioritize vital few X's
  Deliverables: Verified root causes, statistical evidence

I — IMPROVE
  Purpose: Fix the root causes
  Key activities:
    - Generate solutions for each root cause
    - Evaluate solutions (impact/effort matrix)
    - Pilot best solution (small scale test)
    - Design of Experiments (DOE) if needed
    - Implement and validate improvement
    - Calculate improved sigma level
  Deliverables: Implemented solution, before/after comparison

C — CONTROL
  Purpose: Make it stick
  Key activities:
    - Create control plan (who monitors what, how often)
    - Implement control charts (SPC)
    - Update SOPs and training materials
    - Hand off to process owner
    - Document lessons learned
    - Calculate financial impact
  Deliverables: Control plan, SPC charts, updated SOPs
EOF
}

cmd_statistics() {
    cat << 'EOF'
=== Key Statistical Concepts ===

Normal Distribution:
  Bell-shaped curve, defined by mean (μ) and std dev (σ)
  68-95-99.7 rule: ±1σ=68%, ±2σ=95%, ±3σ=99.7%
  Many processes approximate normal (Central Limit Theorem)

Hypothesis Testing:
  H₀: Null hypothesis (no difference / no effect)
  H₁: Alternative hypothesis (there IS a difference)
  α (alpha): significance level (typically 0.05)
  p-value < α → reject H₀ → statistically significant

  Common tests:
    1-sample t-test      Compare mean to target
    2-sample t-test      Compare two group means
    Paired t-test        Before/after comparison
    ANOVA (F-test)       Compare 3+ group means
    Chi-square           Compare proportions/counts
    Correlation          Linear relationship (r value)
    Regression           Predict Y from X's

  p-value interpretation:
    p < 0.001   Very strong evidence against H₀
    p < 0.01    Strong evidence
    p < 0.05    Moderate evidence (typical threshold)
    p > 0.05    Insufficient evidence to reject H₀

Regression:
  Y = β₀ + β₁X₁ + β₂X₂ + ... + ε
  R² = % of variation in Y explained by X's
  Check: residuals normal, no patterns, constant variance

Sample Size:
  Larger samples = more power to detect differences
  Minimum 30 for normal approximation
  Use power analysis for precise calculation
  Factors: desired power (80-90%), effect size, α level
EOF
}

cmd_charts() {
    cat << 'EOF'
=== Control Charts (SPC) ===

Purpose: Monitor process stability over time
  In control = only common cause variation (random)
  Out of control = special cause variation (assignable)

Variable Data (measurements):
  Xbar-R Chart (subgroup size 2-10)
    Xbar: subgroup averages → detects mean shifts
    R: subgroup ranges → detects variation changes
    UCL_Xbar = Xbar + A₂ × Rbar
    LCL_Xbar = Xbar - A₂ × Rbar
    UCL_R = D₄ × Rbar
    LCL_R = D₃ × Rbar

  Xbar-S Chart (subgroup size >10)
    Same as Xbar-R but uses std dev instead of range

  I-MR Chart (Individual-Moving Range, subgroup=1)
    For single measurements (slow processes, destructive test)
    UCL_I = Xbar + 2.66 × MRbar
    LCL_I = Xbar - 2.66 × MRbar

Attribute Data (counts/proportions):
  p-chart     Proportion defective (variable sample size)
  np-chart    Number defective (constant sample size)
  c-chart     Count of defects per unit (constant area)
  u-chart     Defects per unit (variable area of opportunity)

Out-of-Control Rules (Western Electric):
  Rule 1: 1 point beyond 3σ
  Rule 2: 9 consecutive points on same side of center
  Rule 3: 6 consecutive points increasing or decreasing
  Rule 4: 14 consecutive points alternating up and down
  Rule 5: 2 of 3 consecutive points beyond 2σ (same side)
  Rule 6: 4 of 5 consecutive points beyond 1σ (same side)

When to Recalculate Limits:
  After a verified process improvement
  After a known process change (new material, equipment)
  NOT after an out-of-control signal (investigate first!)
EOF
}

cmd_capability() {
    cat << 'EOF'
=== Process Capability ===

Cp (Potential Capability):
  Cp = (USL - LSL) / (6σ)
  Measures: can the process fit within spec limits?
  Ignores centering — only spread vs tolerance
  Cp ≥ 1.33 generally acceptable
  Cp ≥ 1.67 for safety-critical or new processes

Cpk (Actual Capability):
  Cpk = min( (USL - μ)/(3σ), (μ - LSL)/(3σ) )
  Measures: does the process fit AND is it centered?
  Cpk = Cp when perfectly centered
  Cpk < Cp indicates off-center process
  Cpk < 0 means process mean is outside spec limits

Pp / Ppk (Performance):
  Same formulas as Cp/Cpk but uses overall σ (not within-subgroup)
  Pp/Ppk includes all variation (within + between subgroup)
  Use for initial studies or unstable processes
  Cp/Cpk for ongoing, stable processes

Sigma Level from Cpk:
  Sigma Level ≈ 3 × Cpk (short-term)
  Cpk 0.33 → 1σ     Cpk 1.00 → 3σ
  Cpk 0.67 → 2σ     Cpk 1.33 → 4σ
  Cpk 1.67 → 5σ     Cpk 2.00 → 6σ

DPMO (Defects Per Million Opportunities):
  DPMO = (Number of Defects / Total Opportunities) × 1,000,000
  
  Sigma from DPMO (approximate):
    690,000 → 1σ      6,210 → 4σ
    308,000 → 2σ        233 → 5σ
     66,800 → 3σ        3.4 → 6σ

Requirements for Valid Capability:
  - Process must be in statistical control (stable)
  - Data approximately normally distributed
  - Minimum 25 subgroups or 100 individual readings
  - Measurement system adequate (GRR < 30% of tolerance)
EOF
}

cmd_tools() {
    cat << 'EOF'
=== Six Sigma Tools ===

SIPOC (Define):
  Suppliers → Inputs → Process → Outputs → Customers
  High-level process map on one page
  Aligns team on scope and boundaries

Fishbone / Ishikawa (Analyze):
  Categories: Man, Machine, Method, Material, Measurement, Mother Nature
  Brainstorm causes in each category
  Identify potential X's for investigation

5 Why (Analyze):
  Ask "why?" five times to reach root cause
  Example: Why did the machine stop? → Overload
  Why overload? → Bearing seized → Why? → No lubrication...
  Simple but effective for single-thread causes

Pareto Chart (Analyze):
  Bar chart sorted by frequency/impact
  80/20 rule: 80% of problems from 20% of causes
  Focus improvement on the vital few

FMEA — Failure Mode and Effects Analysis (Analyze/Improve):
  List potential failures, rate each:
    Severity (S): 1-10
    Occurrence (O): 1-10
    Detection (D): 1-10
  RPN = S × O × D (higher = more critical)
  Prioritize actions on highest RPNs or highest severity

MSA — Measurement System Analysis (Measure):
  Gage R&R: can the measurement system detect process variation?
    %GRR < 10%: excellent
    %GRR 10-30%: acceptable
    %GRR > 30%: unacceptable, fix before proceeding
  Components: repeatability (within operator) + reproducibility (between)

DOE — Design of Experiments (Improve):
  Systematically test factor combinations
  Full factorial: all combinations (2ᵏ runs for k factors at 2 levels)
  Fractional factorial: subset of combinations (when too many factors)
  Response surface: optimize continuous factors
  Identifies main effects AND interactions
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Six Sigma Project Examples ===

--- Reduce Call Center Wait Time ---
Define:  Avg wait time 4.2 min, target < 2 min, 50K calls/month
Measure: Collected 4 weeks of data, confirmed 4.2 min avg, σ=2.1 min
         Cpk = 0.32 (well below 1.33 target)
Analyze: Pareto: 60% of long waits during 10am-2pm
         Root cause: lunch coverage gaps + call routing inefficiency
Improve: Staggered lunches, skill-based routing, added 2 agents peak
         New avg: 1.6 min, σ=0.8 min, Cpk = 1.67
Control: Real-time dashboard, hourly staffing checks
Savings: $180K/year (reduced callbacks + improved satisfaction)

--- Reduce Assembly Defect Rate ---
Define:  Solder defect rate 2.3% (23,000 DPMO), target < 0.5%
Measure: GRR on inspection: 18% (acceptable)
         Baseline: p = 0.023, n = 500/day
Analyze: Fishbone → top 3 causes: paste volume, reflow profile, PCB warp
         DOE: paste volume and reflow temp are significant (p < 0.01)
Improve: Adjusted paste aperture +15%, reflow zone 3 temp +8°C
         Pilot: defect rate dropped to 0.3% (3,000 DPMO)
Control: SPC on paste weight, reflow profile monitoring
Savings: $420K/year in rework and scrap reduction
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== DMAIC Phase Gate Checklist ===

Define Gate:
  [ ] Problem statement: specific, measurable, bounded
  [ ] Project scope: clear in/out boundaries
  [ ] Business case: financial or strategic impact
  [ ] Customer CTQs identified and prioritized
  [ ] SIPOC map completed
  [ ] Team assigned with roles (champion, BB/GB, members)
  [ ] Timeline with milestones

Measure Gate:
  [ ] Y (output metric) operationally defined
  [ ] Measurement system validated (MSA/GRR acceptable)
  [ ] Baseline data collected (minimum 30 data points)
  [ ] Current sigma level / Cpk calculated
  [ ] Detailed process map with inputs (X's) identified
  [ ] Data is representative (all shifts, products, operators)

Analyze Gate:
  [ ] Potential causes (X's) listed and prioritized
  [ ] Statistical analysis performed (appropriate tests)
  [ ] Root causes verified with data (not just opinions)
  [ ] Vital few X's identified (separated from trivial many)
  [ ] No jumping to solutions (analysis before improvement)

Improve Gate:
  [ ] Solutions address verified root causes
  [ ] Solution selection criteria documented
  [ ] Pilot/trial completed with positive results
  [ ] Before vs after comparison (statistical significance)
  [ ] Improved sigma level / Cpk calculated
  [ ] Risk assessment of solution (unintended consequences)
  [ ] Implementation plan with timeline

Control Gate:
  [ ] Control plan documented (what, who, when, how)
  [ ] Control charts in place and being monitored
  [ ] SOPs updated to reflect new process
  [ ] Training completed for process operators
  [ ] Process owner identified and handed off
  [ ] Financial savings validated by finance
  [ ] Lessons learned documented and shared
EOF
}

show_help() {
    cat << EOF
sixsigma v$VERSION — Six Sigma Methodology Reference

Usage: script.sh <command>

Commands:
  intro       Six Sigma overview, sigma levels, belt system
  dmaic       DMAIC phases: Define, Measure, Analyze, Improve, Control
  statistics  Statistical concepts: distributions, hypothesis tests
  charts      Control charts: Xbar-R, p-chart, I-MR, rules
  capability  Process capability: Cp, Cpk, Pp, Ppk, DPMO
  tools       Six Sigma tools: fishbone, FMEA, DOE, MSA, Pareto
  examples    Example DMAIC project walkthroughs
  checklist   DMAIC phase gate review checklist
  help        Show this help
  version     Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    dmaic)      cmd_dmaic ;;
    statistics) cmd_statistics ;;
    charts)     cmd_charts ;;
    capability) cmd_capability ;;
    tools)      cmd_tools ;;
    examples)   cmd_examples ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "sixsigma v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
