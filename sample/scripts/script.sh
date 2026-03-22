#!/usr/bin/env bash
# sample — Statistical Sampling Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

cmd_intro() { cat << 'EOF'
=== Statistical Sampling ===

Sampling selects a subset of a population to estimate characteristics
of the whole population without measuring every member.

Why Sample:
  Cost:    Surveying 100M people is expensive; 1,000 can suffice
  Speed:   Results in days instead of years
  Access:  Full population often impossible to reach
  Quality: Smaller sample → more resources per measurement

Key Concepts:
  Population:     The entire group you want to understand
  Sample:         The subset you actually measure
  Parameter:      True value in the population (unknown)
  Statistic:      Estimated value from the sample (known)
  Sampling Frame:  List of all members from which you sample
  Sampling Error:  Difference between statistic and parameter

Central Limit Theorem:
  The sampling distribution of the mean approaches normal distribution
  as sample size increases, regardless of population distribution.
  Rule of thumb: n ≥ 30 for CLT to apply

Confidence Level:
  90%: 1.645 standard errors (less precise, smaller sample needed)
  95%: 1.960 standard errors (most common)
  99%: 2.576 standard errors (more precise, larger sample needed)

Margin of Error:
  MOE = z × √(p(1-p)/n)
  Where: z = z-score, p = proportion, n = sample size
  Typical target: ±3% to ±5%
EOF
}

cmd_methods() { cat << 'EOF'
=== Sampling Methods ===

--- Probability Sampling (every member has known chance) ---

Simple Random Sampling (SRS):
  Every member has equal probability of selection
  Method: random number generator, lottery
  Pro: unbiased, simple analysis
  Con: needs complete sampling frame, may miss small subgroups

Stratified Sampling:
  Divide population into strata (subgroups), sample each
  Proportional: sample % matches population %
  Disproportional: oversample small strata for precision
  Pro: ensures representation of all groups
  Con: need to know strata membership
  Example: survey voters by age group (18-29, 30-44, 45-64, 65+)

Cluster Sampling:
  Divide population into clusters, randomly select clusters,
  survey ALL members of selected clusters
  Pro: no need for complete frame, reduces travel cost
  Con: less precise than SRS (members in clusters are similar)
  Example: randomly select 50 schools, survey all students in each

Systematic Sampling:
  Select every kth member (k = population/sample size)
  Start from random point, then every kth
  Pro: easy to implement, evenly spread
  Con: biased if population has periodic pattern
  Example: every 10th customer entering a store

Multi-Stage Sampling:
  Combine methods in stages:
  Stage 1: cluster sampling (select cities)
  Stage 2: stratified (by income within cities)
  Stage 3: SRS within each stratum
  Used in: national surveys, census

--- Non-Probability Sampling ---

Convenience Sampling:
  Sample whoever is available/easy to reach
  Pro: cheap, fast  Con: highly biased, not generalizable

Snowball Sampling:
  Participants recruit other participants
  Used for: hard-to-reach populations (drug users, undocumented)

Quota Sampling:
  Non-random selection to match known population proportions
  Like stratified but without random selection within strata

Purposive/Judgmental:
  Researcher selects "typical" or "extreme" cases
  Used in: qualitative research, case studies
EOF
}

cmd_size() { cat << 'EOF'
=== Sample Size Calculations ===

--- For Proportion (e.g., survey, yes/no question) ---

  n = (z² × p × (1-p)) / E²

  Where:
    z = z-score for confidence level (1.96 for 95%)
    p = expected proportion (use 0.5 if unknown — maximum variance)
    E = margin of error (0.05 = ±5%)

  Example: 95% confidence, ±3% margin, unknown proportion
    n = (1.96² × 0.5 × 0.5) / 0.03²
    n = (3.8416 × 0.25) / 0.0009
    n = 1,068 respondents

  Common results (95% CI, p=0.5):
    ±1% → n = 9,604
    ±2% → n = 2,401
    ±3% → n = 1,068
    ±5% → n = 385
    ±10% → n = 97

--- For Mean (continuous variable) ---

  n = (z × σ / E)²

  Where:
    z = z-score
    σ = population standard deviation (estimate from pilot)
    E = margin of error (in same units as measurement)

  Example: estimate average salary within $5,000, σ=$30,000
    n = (1.96 × 30000 / 5000)² = (11.76)² = 139

--- Finite Population Correction ---
  If sampling more than 5% of population:
    n_adj = n / (1 + (n-1)/N)

  Where N = population size
  Example: n=385, N=2000
    n_adj = 385 / (1 + 384/2000) = 385/1.192 = 323

--- A/B Test Sample Size ---
  n per group = (z_α/2 + z_β)² × 2 × p × (1-p) / δ²

  Where:
    z_α/2 = 1.96 (for α=0.05, two-tailed)
    z_β = 0.84 (for 80% power)
    p = baseline proportion
    δ = minimum detectable effect

  Example: detect 2% lift from 10% baseline conversion
    n = (1.96 + 0.84)² × 2 × 0.10 × 0.90 / 0.02²
    n = 7.84 × 0.18 / 0.0004 = 3,528 per group
    Total: 7,056 visitors needed
EOF
}

cmd_bias() { cat << 'EOF'
=== Sampling Bias ===

1. Selection Bias
   Some population members more likely to be sampled
   Example: online survey excludes people without internet
   Fix: probability sampling with complete sampling frame

2. Survivorship Bias
   Only studying "survivors" — ignoring failures
   Example: studying successful companies (ignoring ones that failed)
   Example: WWII bomber armor (should armor where bullet holes AREN'T)
   Fix: include failures in analysis

3. Non-Response Bias
   People who don't respond differ systematically from those who do
   Example: health survey — sick people less likely to respond
   Fix: track response rate, weight for demographics, follow up

4. Volunteer Bias (Self-Selection)
   Volunteers differ from non-volunteers
   Example: clinical trial volunteers are more health-conscious
   Fix: random assignment within study, incentivize participation

5. Recall Bias
   Participants remember past events inaccurately
   Example: "How many drinks did you have last month?"
   Fix: prospective design, diaries, objective measurements

6. Observer Bias (Hawthorne Effect)
   Subjects change behavior because they know they're being studied
   Fix: blinding, naturalistic observation

7. Confirmation Bias
   Researcher selects/interprets data to confirm hypothesis
   Fix: pre-registration of study design, blinded analysis

8. Temporal Bias
   Sampling at wrong time distorts results
   Example: shopping mall survey on Tuesday (misses weekday workers)
   Fix: sample across different times/days/seasons

Checking for Bias:
  - Compare sample demographics to known population
  - Report response rate (< 60% = concern)
  - Conduct non-response analysis
  - Weight results to match population
  - Use multiple sampling methods and compare
EOF
}

cmd_ab_test() { cat << 'EOF'
=== A/B Test Design ===

--- Hypothesis ---
  Null (H0):       No difference between control and treatment
  Alternative (H1): Treatment produces a measurable difference

  One-tailed: treatment is BETTER (directional)
  Two-tailed: treatment is DIFFERENT (either direction)
  Use two-tailed unless you have strong prior (more conservative)

--- Key Parameters ---
  α (significance level): probability of false positive (Type I error)
    Standard: 0.05 (5% chance of declaring effect when none exists)

  β (Type II error): probability of missing a real effect
    Standard: 0.20 (20% chance of missing real effect)

  Power = 1 - β = 0.80 (80% chance of detecting real effect)
    For important decisions: use 90% or 95% power

  MDE (Minimum Detectable Effect):
    Smallest difference worth detecting
    Smaller MDE → larger sample needed
    Business decision: "What improvement would change our strategy?"

--- Duration ---
  Duration = required sample ÷ daily traffic per variation
  Example: need 7,000 per group, 1,000 visitors/day → 14 days

  Minimum duration: 2 full business weeks (cover weekly patterns)
  Maximum: 4-6 weeks (avoid novelty/fatigue effects)

  DO NOT peek and stop early when p < 0.05
  Sequential testing or Bayesian methods allow valid early stopping

--- Common Mistakes ---
  Peeking: checking results daily, stopping when significant
    Inflates false positive rate from 5% to 20-30%
    Fix: pre-commit to duration, or use sequential testing

  Multiple comparisons: testing 10 metrics, one is p<0.05 by chance
    Fix: Bonferroni correction (α/n), or designate primary metric

  Selection effect: running test only during a promotion
    Results don't generalize to normal periods

  Underpowered: too few samples to detect realistic effect
    "We found no effect" might mean "we couldn't detect it"

  Simpson's Paradox: overall result opposite of subgroup results
    Fix: analyze by segments (device, source, user type)

--- Statistical Tests ---
  Proportions (conversion rate): Z-test for proportions, chi-squared
  Means (revenue per user): t-test (Welch's)
  Multiple variants: ANOVA with post-hoc tests
  Duration data: survival analysis (time-to-event)
EOF
}

cmd_reservoir() { cat << 'EOF'
=== Reservoir Sampling ===

Select k random items from a stream of unknown (possibly infinite) length,
where each item has equal probability of being selected.

--- Algorithm R (Vitter, 1985) ---

  Initialize:
    Fill reservoir with first k items from stream

  For each subsequent item i (index starting from k):
    Generate random integer j in range [0, i]
    If j < k: replace reservoir[j] with item i

  Result: after processing all n items, each item has
  exactly k/n probability of being in the reservoir.

  Pseudocode:
    reservoir = stream[0:k]  # first k items
    for i in range(k, n):
      j = random_int(0, i)   # inclusive
      if j < k:
        reservoir[j] = stream[i]

  Why it works:
    At any point, each seen item has equal probability k/i of being
    in the reservoir. Mathematical proof by induction.

--- Weighted Reservoir Sampling ---
  When items have different weights (importance):

  Algorithm A-Res (Efraimidis & Spirakis):
    For each item with weight w:
      key = random()^(1/w)
    Keep k items with largest keys

--- Use Cases ---
  Sampling from streams:     log files, network packets, sensor data
  Database sampling:         random rows without knowing table size
  Machine learning:          random minibatch from data pipeline
  Monitoring:                keep random sample of recent events
  A/B testing:               reservoir for recent conversion data

--- Properties ---
  Space:  O(k) — only stores k items
  Time:   O(n) — one pass through data
  Random: each item equally likely to be in reservoir
  Online: works with streaming data (no need to know n in advance)

  Limitation: can't efficiently sample from the LATEST items
  For time-windowed sampling: use sliding window instead
EOF
}

cmd_bootstrap() { cat << 'EOF'
=== Bootstrap & Resampling Methods ===

Bootstrap estimates the sampling distribution by resampling WITH
REPLACEMENT from the observed data. No distributional assumptions needed.

--- Basic Bootstrap ---
  1. Observed sample: X = {x₁, x₂, ..., xₙ}
  2. Draw B bootstrap samples (each: n values with replacement from X)
  3. Compute statistic of interest for each bootstrap sample
  4. The distribution of bootstrap statistics approximates the
     sampling distribution of the statistic

  B = 1,000 to 10,000 bootstrap samples (more = more precise)

--- Bootstrap Confidence Intervals ---

  Percentile method (simplest):
    Sort bootstrap statistics
    95% CI = [2.5th percentile, 97.5th percentile]

  BCa (Bias-Corrected and Accelerated):
    Adjusts for bias and skewness
    More accurate than percentile method
    Recommended for most applications

  Example (Python):
    from scipy import stats
    result = stats.bootstrap((data,), np.mean, n_resamples=10000)
    print(result.confidence_interval)

--- Permutation Test ---
  Tests whether two groups differ significantly.
  No distributional assumptions.

  1. Calculate test statistic (e.g., difference in means)
  2. Pool all observations from both groups
  3. Randomly permute group labels B times
  4. Calculate test statistic for each permutation
  5. p-value = proportion of permuted statistics ≥ observed

  Example: Treatment group mean = 75, Control = 70
    Permute 10,000 times
    Only 3% of permutations show difference ≥ 5
    p-value = 0.03 → significant at α=0.05

--- Jackknife ---
  Leave-one-out resampling:
    Compute statistic n times, each time leaving out one observation
    Estimate bias and variance from these n estimates
  Predecessor to bootstrap, simpler but less flexible
  Used for: variance estimation, bias correction

--- When Bootstrap Fails ---
  Very small samples (n < 10): insufficient data to resample
  Extreme values (max, min): bootstrap underestimates variability
  Dependent data (time series): need block bootstrap
  Heavy-tailed distributions: slow convergence
  Fix: parametric bootstrap (resample from fitted distribution)
EOF
}

cmd_quality() { cat << 'EOF'
=== Sample Quality ===

--- Representativeness ---
  A sample should mirror the population on key characteristics.
  Check by comparing sample vs known population demographics:
    Age distribution, gender ratio, income levels, geography

  If sample ≠ population on key variables → biased estimates
  Fix: weighting, post-stratification, or better sampling design

--- Weighting ---
  Adjust for over/under-representation of groups.

  Design weights:
    If group A is 20% of population but 40% of sample:
    Weight = 0.20 / 0.40 = 0.50
    Each group A response counts as 0.5 in analysis

  Non-response weights:
    If young people respond at 30% vs old people at 70%:
    Weight young = 1/0.30 = 3.33
    Weight old = 1/0.70 = 1.43

  Raking (iterative proportional fitting):
    Adjust weights to match multiple known population margins
    simultaneously (age AND gender AND education)
    Tools: survey package (R), weights package (Python)

--- Post-Stratification ---
  After data collection, weight results to match known population totals.
  Example: Census says 52% female, sample is 60% female
  → Weight male responses up, female down

--- Response Rate ---
  Response rate = completed surveys / total contacted
  AAPOR definitions:
    RR1: complete / (complete + partial + refusal + noncontact + unknown)
    RR3: complete / (complete + partial + refusal + noncontact)

  Acceptable rates:
    Phone survey: 10-30% (declining rapidly)
    Mail survey: 20-50%
    Online panel: 20-40%
    In-person: 50-80%

  Low response rate ≠ automatically biased
  But must demonstrate non-response doesn't distort results

--- Data Quality Checks ---
  Speeders: completed too fast (< 1/3 median time) → exclude
  Straightliners: same answer for all matrix questions → flag
  Open-end gibberish: nonsense text responses → exclude
  Duplicates: same IP/device/respondent → deduplicate
  Attention checks: embedded quality control questions
  Quota monitoring: check demographics during collection
EOF
}

show_help() { cat << EOF
sample v$VERSION — Statistical Sampling Reference

Usage: script.sh <command>

Commands:
  intro        Sampling concepts, CLT, confidence levels
  methods      Sampling methods: random, stratified, cluster, systematic
  size         Sample size calculations for proportions, means, A/B tests
  bias         Sampling bias types and mitigation strategies
  ab_test      A/B test design: hypothesis, power, duration, mistakes
  reservoir    Reservoir sampling for streams of unknown size
  bootstrap    Bootstrap and resampling confidence intervals
  quality      Sample quality: representativeness, weighting, response rate
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"
case "$CMD" in
    intro)     cmd_intro ;; methods)   cmd_methods ;; size)      cmd_size ;;
    bias)      cmd_bias ;; ab_test)   cmd_ab_test ;; reservoir) cmd_reservoir ;;
    bootstrap) cmd_bootstrap ;; quality)   cmd_quality ;;
    help|--help|-h) show_help ;; version|--version|-v) echo "sample v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
