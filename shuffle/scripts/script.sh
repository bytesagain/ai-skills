#!/usr/bin/env bash
# shuffle — Shuffling & Randomization Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

cmd_intro() { cat << 'EOF'
=== Shuffling ===

A shuffle creates a random permutation of elements — every possible
ordering should be equally likely for a fair shuffle.

Why Naive Shuffling is Biased:
  Common mistake — "swap each element with random position":
    for i in 0..n-1:
      j = random(0, n-1)     ← WRONG: swap range includes all
      swap(arr[i], arr[j])

  This produces n^n possible outcomes, but only n! permutations exist.
  Since n^n is rarely divisible by n!, some permutations are more likely.
  Example: n=3 → 27 outcomes mapping to 6 permutations (27/6 = 4.5)

  For 3 elements, bias is detectable with ~10,000 trials.
  For 52 cards, bias is mathematically certain but harder to exploit.

Number of Permutations:
  3 elements:   6 permutations
  10 elements:  3,628,800
  52 cards:     8.07 × 10^67 (more than atoms in the observable universe)

Fair Shuffle = every permutation equally probable = 1/n! probability each.
EOF
}

cmd_fisher_yates() { cat << 'EOF'
=== Fisher-Yates (Knuth) Shuffle ===

The correct algorithm for generating a uniformly random permutation.
Published by Fisher & Yates (1938), computerized by Durstenfeld (1964),
popularized by Knuth in "The Art of Computer Programming."

Algorithm (modern "inside-out" version):
  for i from n-1 down to 1:
    j = random integer in [0, i]    ← inclusive
    swap(arr[i], arr[j])

  Key: swap range SHRINKS each step (0 to i, not 0 to n-1)

Proof of Uniformity:
  Step n-1: element has 1/n chance of being placed at position n-1
  Step n-2: remaining element has 1/(n-1) chance for position n-2
  ...
  Step 1:   last element has 1/2 chance for position 1
  Step 0:   remaining element goes to position 0

  Total: 1/n × 1/(n-1) × ... × 1/2 × 1/1 = 1/n!
  Exactly the uniform probability!

Time: O(n) — single pass
Space: O(1) — in-place
Optimal: can't do better than O(n) for generating a full permutation.

Implementation:
  Python: random.shuffle(lst)        # uses Fisher-Yates
  JS:     No built-in! Must implement manually
  C++:    std::shuffle(begin, end, rng)
  Java:   Collections.shuffle(list)
  Go:     rand.Shuffle(n, swap)
  Rust:   slice.shuffle(&mut rng)

JavaScript (correct):
  function shuffle(arr) {
    for (let i = arr.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [arr[i], arr[j]] = [arr[j], arr[i]];
    }
    return arr;
  }
EOF
}

cmd_variants() { cat << 'EOF'
=== Shuffle Variants ===

--- Partial Shuffle (Top-K) ---
  Need only k random elements from n? Don't shuffle everything.

  for i from n-1 down to n-k:
    j = random in [0, i]
    swap(arr[i], arr[j])
  return arr[n-k:]

  Time: O(k) instead of O(n)
  Use: random sample of 5 items from 1,000,000

--- Inside-Out Shuffle (for copying) ---
  Shuffle during array creation (doesn't modify source):

  result = new array of size n
  for i from 0 to n-1:
    j = random in [0, i]
    result[i] = result[j]
    result[j] = source[i]

  Creates shuffled copy without modifying original.

--- Sattolo's Algorithm ---
  Generates random cyclic permutation (every element moves).
  No element stays in its original position.

  for i from n-1 down to 1:
    j = random in [0, i-1]       ← exclusive of i (key difference)
    swap(arr[i], arr[j])

  Use: Secret Santa assignments (no one gets themselves)
  Difference from Fisher-Yates: j < i, never j == i

--- Streaming Shuffle (Online) ---
  Shuffle elements as they arrive (don't know total count):

  Use reservoir sampling:
    reservoir = first k elements
    for each new element (index i > k):
      j = random in [0, i]
      if j < k: reservoir[j] = element

  For full shuffle of stream: k = "all seen so far"

--- Merge Shuffle ---
  For parallel/distributed shuffle:
    1. Split data into chunks across workers
    2. Each worker locally shuffles its chunk
    3. Merge chunks with random interleaving
  Used in: Spark, MapReduce shuffle operations

--- Balanced Shuffle (Spotify-style) ---
  "Shuffle" that sounds random but avoids clusters.
  True random shuffle may play 5 songs by same artist in a row.
  Balanced shuffle spaces out similar items.
  Not mathematically random — designed for perception.
EOF
}

cmd_rng() { cat << 'EOF'
=== Random Number Generators ===

--- PRNG (Pseudo-Random Number Generator) ---
  Deterministic algorithm that produces numbers that LOOK random.
  Given same seed → same sequence (reproducible).

  Common PRNGs:
    Mersenne Twister (MT19937):
      Period: 2^19937 - 1 (astronomically long)
      NOT cryptographically secure
      Default in: Python, Ruby, PHP, R, MATLAB

    xoshiro256** / xoroshiro128+:
      Fast, small state, good statistical properties
      Default in: many modern languages
      NOT cryptographically secure

    PCG (Permuted Congruential Generator):
      Good statistical properties, small state
      Recommended for non-crypto uses

  Seeding:
    ALWAYS seed from OS entropy (not from time alone!)
    Python: random.seed()  — auto-seeds from os.urandom
    C++: std::random_device rd; std::mt19937 gen(rd());

--- CSPRNG (Cryptographically Secure PRNG) ---
  Unpredictable: knowing past outputs doesn't help predict future.
  Required for: passwords, tokens, encryption keys, lottery.

  Sources:
    /dev/urandom (Linux): kernel entropy pool, always available
    /dev/random (Linux): blocks if entropy "low" (usually unnecessary)
    CryptGenRandom (Windows): OS-provided CSPRNG
    os.urandom() (Python): OS CSPRNG, always use for security
    crypto.getRandomValues() (JavaScript): Web Crypto API
    secrets module (Python): designed for security-sensitive uses

--- Common Pitfalls ---
  Using Math.random() for security → NEVER (predictable PRNG)
  Seeding with time → predictable if attacker knows approximate time
  Using modulo for range: random() % 6 → biased! (modulo bias)
    Fix: rejection sampling or proper range functions
  Reusing seeds across sessions → same "random" sequence
  Using PRNG for cryptography → attacker can predict future values
EOF
}

cmd_cards() { cat << 'EOF'
=== Card Shuffling Math ===

--- Physical Riffle Shuffle ---
  Split deck in half, interleave cards from each half.

  Gilbert-Shannon-Reeds model:
    Mathematical model of how humans riffle shuffle.
    Each card drops from left or right half with probability
    proportional to remaining cards in that half.

  How many riffle shuffles for randomness?
    7 riffle shuffles for a 52-card deck (Bayer & Diaconis, 1992)
    After 7: all 52! permutations roughly equally likely
    After 6: still significantly non-random
    This is the "7 shuffles theorem" — widely cited in math

  Persi Diaconis proved this using total variation distance
  between the shuffle distribution and uniform distribution.

--- Perfect (Faro) Shuffle ---
  Perfectly interleave cards from two equal halves.
  Out-shuffle: top card stays on top
    8 out-shuffles restore a 52-card deck to original order!
  In-shuffle: top card moves to second position
    52 in-shuffles restore original order

  Used by: magicians for card control (not randomization)

--- Overhand Shuffle ---
  Transfer small packets from one hand to the other.
  Much less effective than riffle shuffle.
  Need ~2,500 overhand shuffles for full randomization!
  Conclusion: riffle shuffle >> overhand shuffle

--- Entropy Calculation ---
  52 cards: log₂(52!) = 225.6 bits of entropy needed
  A perfect riffle shuffle: ~1.5 bits of entropy per shuffle
  7 shuffles: ~48 bits... but the GSR model adds more entropy
  per shuffle due to imperfect splitting and dropping.

  Computer shuffle: generate 225.6+ bits of randomness
    CSPRNG provides this easily
    PRNG (Mersenne Twister): 19,937-bit state — more than enough

--- Online Poker Shuffling ---
  Requirements: CSPRNG, not PRNG (predictable = cheatable)
  Famous bug: 1999 ASF Software used rand() seeded with millisecond clock
    → 86,400,000 possible shuffles (not 8×10^67)
    → Could be brute-forced to determine all cards
  Lesson: use cryptographic randomness for real-stakes shuffling
EOF
}

cmd_fairness() { cat << 'EOF'
=== Fair Selection Systems ===

--- Lottery ---
  Requirements for a fair lottery draw:
    1. CSPRNG or physical randomness (ball machines)
    2. Independent draws (each number equally likely)
    3. Auditable process (recorded, witnessed)
    4. Verifiable (results can be independently checked)

  Physical methods: numbered balls, air-mixed drum
  Digital methods: CSPRNG + public seed commitment
    Publish hash of seed BEFORE draw
    Reveal seed AFTER draw
    Anyone can verify: hash(seed) matches, seed generates winning numbers

--- Jury Selection ---
  Random selection from voter registration / DMV records
  Steps:
    1. Source list (sampling frame)
    2. Random selection (Fisher-Yates or systematic)
    3. Qualification screening
    4. Voir dire (attorney challenges)
  Randomness ensures representative cross-section

--- Random Assignment (A/B Testing) ---
  Assign users to control/treatment groups randomly.
  Requirements:
    Deterministic: same user always gets same group
    Balanced: approximately equal group sizes
    Independent: assignment of user A doesn't affect user B

  Common method: hash(user_id + experiment_id) % 100
    0-49 → control, 50-99 → treatment
    Deterministic, no storage needed, balanced

--- Draft Lottery (NBA, military) ---
  Weighted randomness: worse teams get more lottery balls
  Ensures fairness while giving disadvantaged participants better odds
  Public, audited, verifiable process

--- Sortition (Random Democracy) ---
  Ancient Athens selected officials by lottery
  Modern proposals: randomly selected citizen assemblies
  Advantages: representative, no campaign corruption
  Used: Citizens' assemblies in Ireland, France, UK
EOF
}

cmd_testing() { cat << 'EOF'
=== Testing Randomness ===

--- Chi-Squared Test ---
  Test if observed distribution matches expected uniform distribution.

  1. Generate N random values in range [0, k)
  2. Count occurrences of each value
  3. Expected count per value = N/k
  4. χ² = Σ (observed - expected)² / expected
  5. Compare to chi-squared distribution with k-1 degrees of freedom
  6. p-value < 0.05 → distribution is NOT uniform (reject)

  Example: roll simulated die 6000 times
    Expected: 1000 per face
    Observed: 980, 1020, 995, 1010, 1005, 990
    χ² = (20²+20²+5²+10²+5²+10²)/1000 = 1.05
    Critical value (df=5, α=0.05) = 11.07
    1.05 < 11.07 → cannot reject uniformity (good!)

--- Kolmogorov-Smirnov Test ---
  Tests if a sample comes from a specific distribution.
  Compares empirical CDF to theoretical CDF.
  Good for continuous distributions (uniform, normal).

--- Runs Test ---
  Tests for independence (no patterns in sequence).
  Count "runs" of consecutive values above/below median.
  Too few runs → clustering (not random).
  Too many runs → alternating (not random).

--- Diehard / TestU01 / PractRand ---
  Comprehensive test suites for RNG quality:
    Diehard: 18 tests (George Marsaglia, 1995)
    TestU01 (SmallCrush/Crush/BigCrush): most rigorous
    PractRand: modern, practical, catches many failures

  What they test:
    Birthday spacings, overlapping patterns, matrix rank,
    linear complexity, serial correlation, runs, gaps,
    spectral test, and many more

--- Shuffle-Specific Testing ---
  Generate all permutations of small array (n=6)
  Run shuffle 720,000 times (1000 × 6!)
  Each permutation should appear ~1000 times
  Chi-squared test on permutation frequencies
  If any permutation appears significantly more/less → biased

--- Quick Sanity Checks ---
  1. Shuffle 1,000,000 times, check element frequency per position
  2. Each element should appear equally at each position
  3. Plot 2D: (output[i], output[i+1]) — should fill space uniformly
  4. Autocorrelation: lag-k correlations should be near zero
EOF
}

cmd_mistakes() { cat << 'EOF'
=== Common Shuffling Mistakes ===

1. Naive Swap (Wrong Range)
   BAD:
     for i in 0..n-1:
       j = random(0, n-1)      // full range every time
       swap(arr[i], arr[j])

   GOOD (Fisher-Yates):
     for i from n-1 down to 1:
       j = random(0, i)        // shrinking range
       swap(arr[i], arr[j])

   The bad version produces n^n outcomes for n! permutations.

2. Sort with Random Comparator
   BAD:
     array.sort(() => Math.random() - 0.5)

   Why bad:
     - Comparison function must be consistent (a<b always same)
     - Random comparator violates transitivity
     - Different sort algorithms produce different biases
     - Some implementations crash on inconsistent comparators
     - Chrome V8 used to produce VERY biased results

3. Modulo Bias
   BAD: random_byte() % 6    // for dice roll
     256 values → 6 outcomes: 256/6 = 42.67 (not even!)
     Values 0-3 appear 43 times, 4-5 appear 42 times
     Bias: 2.3%

   FIX: rejection sampling
     do { x = random_byte(); } while (x >= 252);
     return x % 6;
     252 is largest multiple of 6 ≤ 256

4. Insufficient Entropy
   BAD: srand(time(NULL))   // seed with seconds
     Only 86,400 possible seeds per day
     Attacker can brute-force all possible shuffles

   FIX: seed from OS CSPRNG
     /dev/urandom, CryptGenRandom, os.urandom()

5. Off-by-One in Range
   random(0, i) vs random(0, i-1) vs random(1, i)
   Each produces different distribution — only one is correct.
   Fisher-Yates needs inclusive [0, i].

6. Shuffling a Copy Unintentionally
   Python: random.shuffle(lst) shuffles IN PLACE, returns None
   Using: shuffled = random.shuffle(lst) → shuffled is None!
   Fix: random.shuffle(lst) then use lst, or use random.sample(lst, len(lst))

7. Thinking "Random" Means "No Clusters"
   True random WILL produce clusters (3 reds in a row is normal).
   If you want "perceived randomness" → use balanced shuffle.
   Spotify learned this: their shuffle is intentionally non-random.
EOF
}

show_help() { cat << EOF
shuffle v$VERSION — Shuffling & Randomization Reference

Usage: script.sh <command>

Commands:
  intro        Why naive shuffle is biased, what fairness means
  fisher_yates Fisher-Yates algorithm with proof of correctness
  variants     Partial, inside-out, Sattolo, streaming, balanced shuffle
  rng          PRNG vs CSPRNG, seeding, and common pitfalls
  cards        Card shuffling math: riffle, perfect, and entropy
  fairness     Lottery, jury selection, random assignment systems
  testing      Chi-squared, K-S, diehard, and shuffle-specific tests
  mistakes     Common shuffling bugs and anti-patterns
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"
case "$CMD" in
    intro) cmd_intro ;; fisher_yates) cmd_fisher_yates ;; variants) cmd_variants ;;
    rng) cmd_rng ;; cards) cmd_cards ;; fairness) cmd_fairness ;;
    testing) cmd_testing ;; mistakes) cmd_mistakes ;;
    help|--help|-h) show_help ;; version|--version|-v) echo "shuffle v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
