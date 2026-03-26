#!/usr/bin/env bash
# license-picker — Open Source License Reference
set -euo pipefail
VERSION="6.0.0"

cmd_intro() { cat << 'EOF'
# Open Source Licensing — Overview

## What is an Open Source License?
A legal framework that grants permission to use, modify, and distribute
software under specified conditions. Without a license, default copyright
applies — all rights reserved, no one can legally use your code.

## Permissive vs Copyleft

  Permissive Licenses (Do almost anything):
    MIT:        Shortest, most popular. Use freely, keep copyright notice.
    Apache-2.0: Like MIT + explicit patent grant + trademark protection.
    BSD-2:      Similar to MIT. Original from UC Berkeley.
    BSD-3:      BSD-2 + no endorsement clause.
    ISC:        Functionally identical to MIT, even shorter.

  Copyleft Licenses (Share-alike requirement):
    GPL-2.0:    Derivative works must also be GPL-2.0. Linux kernel uses this.
    GPL-3.0:    GPL-2.0 + anti-tivoization + patent retaliation clause.
    LGPL-2.1:   GPL for libraries — linking doesn't trigger copyleft.
    AGPL-3.0:   GPL-3.0 + network use triggers copyleft (SaaS killer).
    MPL-2.0:    File-level copyleft — only modified files must be shared.

  Non-Software Licenses:
    CC BY 4.0:      Attribution only — documentation, images, data.
    CC BY-SA 4.0:   Attribution + ShareAlike — Wikipedia uses this.
    CC0 1.0:        Public domain dedication — no restrictions at all.
    Unlicense:      Public domain for software (CC0 equivalent).

## Why License Choice Matters
  No license = proprietary by default (GitHub repos without LICENSE)
  License incompatibility blocks code reuse between projects
  Companies often ban AGPL (SaaS exposure risk) and GPL (linking concerns)
  License choice affects community adoption and contribution willingness
EOF
}

cmd_standards() { cat << 'EOF'
# License Standards & Identifiers

## SPDX License Identifiers
  Standard machine-readable license names (spdx.org/licenses)
  Format: Short identifier string, case-sensitive
  Examples:
    MIT                     Apache-2.0              GPL-3.0-only
    GPL-3.0-or-later        BSD-2-Clause            BSD-3-Clause
    MPL-2.0                 LGPL-2.1-only           AGPL-3.0-only
    ISC                     Unlicense               CC0-1.0
    CC-BY-4.0               CC-BY-SA-4.0

  Usage in package.json:  "license": "MIT"
  Usage in source files:  // SPDX-License-Identifier: Apache-2.0
  SPDX expressions:       MIT OR Apache-2.0 (dual license)
                          MIT AND CC-BY-4.0 (multiple licenses apply)

## OSI-Approved Licenses
  Open Source Initiative (opensource.org) certifies licenses
  ~100 approved licenses, but ~10 cover 95% of projects
  OSI approval = recognized by the open source community
  Key criteria: Free redistribution, source code available, derived works allowed

## FSF Free Software Licenses
  Free Software Foundation (gnu.org) evaluates license freedom
  "Free" = freedom to run, study, modify, distribute (not price)
  FSF approves more licenses than OSI (including some OSI rejects)
  GPL is the FSF's flagship license

## License Compatibility Matrix
  MIT → Apache-2.0 → LGPL-2.1 → GPL-2.0 → GPL-3.0  (one-way flow)
  MIT → MIT (ok)    MIT → GPL (ok)    GPL → MIT (NOT ok)
  Apache-2.0 → GPL-3.0 (ok)  Apache-2.0 → GPL-2.0 (NOT ok, patent clause conflict)
  BSD-3 → MIT (ok)  BSD-3 → GPL (ok)  GPL → BSD (NOT ok)
  Rule: Can always add more restrictions, never remove copyleft
EOF
}

cmd_troubleshooting() { cat << 'EOF'
# License Troubleshooting

## License Conflict in Dependencies
  Problem: Your project uses MIT but depends on GPL library
  Impact: If you link GPL code, your project must be GPL too
  Solutions:
    1. Find alternative library with compatible license
    2. Isolate GPL code in separate process (IPC, not linking)
    3. Re-license your project under GPL
    4. Contact author for dual-licensing or commercial license
  Check tool: license-checker (npm), pip-licenses (Python), cargo-license (Rust)

## Dual Licensing Confusion
  Pattern: "Licensed under MIT OR Apache-2.0"
  Meaning: User chooses which license to follow (OR = pick one)
  Common in Rust ecosystem (Rust itself is MIT/Apache-2.0)
  vs "Licensed under MIT AND CC-BY-4.0"
  Meaning: Both licenses apply simultaneously (AND = follow both)

## Contributor License Agreement Issues
  CLA: Contributors assign rights to project maintainer
  DCO (Developer Certificate of Origin): Lighter alternative
  Problem: Contributors refuse to sign CLA (distrust of IP transfer)
  Solution: Use DCO with "Signed-off-by" in commits (Linux kernel model)
  git commit -s  (adds Signed-off-by automatically)

## "No License" Repositories
  GitHub repo without LICENSE file = all rights reserved
  Common misconception: "It's on GitHub so it's open source" — FALSE
  Fix for maintainers: Add LICENSE file, choosealicense.com helps
  Risk for users: Using unlicensed code is copyright infringement

## Specimen and Attribution Issues
  MIT/BSD require: Reproduce copyright notice in copies
  Apache-2.0 requires: NOTICE file contents preserved
  GPL requires: Offer source code to anyone who gets binary
  LGPL dynamically linked: No copyleft trigger, but must allow re-linking
  Common violation: Mobile apps bundle MIT code without attribution
EOF
}

cmd_performance() { cat << 'EOF'
# Automated License Scanning Tools

## FOSSA (fossa.com)
  Enterprise license compliance platform
  Languages: 20+ (Java, Python, JS, Go, Ruby, C/C++, etc.)
  Features:
    - Dependency tree scanning (direct + transitive)
    - License compatibility analysis
    - SBOM generation (SPDX, CycloneDX)
    - Policy engine (ban specific licenses)
    - CI/CD integration (GitHub Actions, Jenkins, CircleCI)
  Pricing: Free for open source, paid for enterprise

## Snyk (snyk.io)
  Security + license scanning combined
  snyk test --json | jq '.vulnerabilities[].license'
  License policies: Block AGPL, warn on GPL, allow MIT/Apache
  IDE integration: VS Code, IntelliJ
  CLI: snyk monitor (continuous monitoring)

## licensee (GitHub's tool)
  Ruby gem, detects license from LICENSE file
  $ licensee detect /path/to/project
  Used by GitHub to show license badge on repos
  Limited: Only reads LICENSE file, not dependencies

## scancode-toolkit (nexB)
  Most comprehensive open source scanner
  Scans: License text, copyright notices, package metadata
  $ scancode --license --copyright /path/to/codebase -o results.json
  Detects license text embedded anywhere in source files
  Identifies 3,000+ licenses (most comprehensive database)

## SBOM (Software Bill of Materials)
  Formats: SPDX (ISO 5962), CycloneDX (OWASP)
  US Executive Order 14028: SBOM required for government software
  Generation: syft (Anchore), cdxgen (CycloneDX)
  Content: Package name, version, supplier, license, hashes
  Purpose: Supply chain transparency, license compliance, vulnerability tracking
EOF
}

cmd_security() { cat << 'EOF'
# License Compliance & Legal Risks

## Patent Clauses
  MIT: No patent mention — implicit license (case law varies)
  Apache-2.0 Section 3: Explicit patent grant from contributors
    "Each Contributor hereby grants... a perpetual, worldwide,
     non-exclusive, no-charge, royalty-free, irrevocable...
     patent license"
  Apache-2.0 Section 3 retaliation: If you sue for patent infringement,
    your patent license terminates automatically
  GPL-3.0: Similar patent grant + anti-patent-aggression clause
  BSD/ISC: No patent provisions (risky for patent-heavy code)

## Indemnification Risks
  Most open source licenses: "AS IS" — no warranty, no liability
  MIT: "THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND"
  Users bear all risk of using the software
  Enterprise solutions: Some companies offer commercial support + indemnification
  Example: Red Hat provides patent indemnification for RHEL customers

## AGPL and SaaS Exposure
  AGPL-3.0: If you modify AGPL code and provide network access,
    you must release your modifications
  Impact: SaaS companies using AGPL libraries must open-source
    their modifications (not necessarily entire codebase)
  Companies that ban AGPL: Google, Apple, many enterprises
  Workaround: Use AGPL service via API (separate process = no linking)

## License Compliance in Supply Chain
  Risk: Transitive dependency uses incompatible license
  Example: Your MIT app → depends on lib-A (MIT) → depends on lib-B (GPL)
    Result: GPL copyleft propagates to your app
  Prevention: Scan full dependency tree, not just direct dependencies
  Audit frequency: Every release, CI/CD pipeline integration
  Document: Maintain license inventory with SBOM
EOF
}

cmd_migration() { cat << 'EOF'
# License Migration Guide

## Proprietary → Open Source
  Steps:
    1. Choose license (consider community goals and business model)
    2. Get sign-off from all copyright holders (every contributor)
    3. Add LICENSE file to repository root
    4. Add SPDX identifier headers to all source files
    5. Add NOTICE file (for Apache-2.0) or CONTRIBUTORS file
    6. Update README with license badge and contributing guidelines
    7. Audit third-party dependencies for compatibility

  Considerations:
    - Once released as open source, cannot revoke (for received copies)
    - Dual licensing: Keep proprietary + offer open source (MySQL model)
    - Open core: Core is open source, premium features proprietary
    - CPAL/SSPL: "Source available" but not OSI-approved

## Relicensing Procedures
  Requirements:
    - Sole copyright holder: Can relicense at will
    - Multiple contributors: Need consent from every contributor
    - With CLA: Organization can relicense (contributors assigned rights)
    - Without CLA: Must contact every contributor (practically impossible for large projects)

  Famous relicensing events:
    - MongoDB: AGPL-3.0 → SSPL (2018) — sparked controversy
    - Elastic: Apache-2.0 → SSPL (2021) — AWS fork to OpenSearch
    - HashiCorp: MPL-2.0 → BSL (2023) — OpenTofu fork by Linux Foundation
    - Redis: BSD-3 → RSAL/SSPL (2024) — Valkey fork

## CLA Implementation
  Tools: CLA-bot (GitHub), EasyCLA (Linux Foundation), CLA Assistant
  Workflow:
    1. Contributor opens PR
    2. Bot checks if CLA signed
    3. If not: Bot comments with link to sign
    4. Contributor signs (DocuSign, web form, or commit sign-off)
    5. Bot marks check as passed
  DCO alternative: Require "Signed-off-by" line in commits
    Simpler, no legal document, Linux kernel standard
EOF
}

cmd_cheatsheet() { cat << 'EOF'
# License Quick Reference

## Top 10 Licenses Comparison
  License       Type       Patent  Copyleft   Key Feature
  MIT           Permissive No      None       Simplest, most popular
  Apache-2.0    Permissive Yes     None       Patent grant + NOTICE file
  GPL-2.0       Copyleft   No      Strong     Linux kernel license
  GPL-3.0       Copyleft   Yes     Strong     Anti-tivoization
  LGPL-2.1      Copyleft   No      Weak       Library linking allowed
  AGPL-3.0      Copyleft   Yes     Network    SaaS must share source
  MPL-2.0       Copyleft   Yes     File-level Only modified files shared
  BSD-2-Clause  Permissive No      None       Two conditions (notice+disclaimer)
  BSD-3-Clause  Permissive No      None       + No endorsement clause
  ISC           Permissive No      None       Simplified BSD (OpenBSD)

## Quick Decision Guide
  "I want maximum adoption"          → MIT
  "I want patent protection"         → Apache-2.0
  "I want modifications shared back" → GPL-3.0
  "Library, don't infect users"      → LGPL-2.1 or MPL-2.0
  "SaaS must share modifications"    → AGPL-3.0
  "Public domain"                    → Unlicense or CC0-1.0
  "Documentation/media"              → CC-BY-4.0

## License Badge Markdown
  [![MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
  [![Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
  [![GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)

## SPDX Header Format
  // SPDX-License-Identifier: MIT
  // SPDX-License-Identifier: Apache-2.0
  // SPDX-License-Identifier: GPL-3.0-only
  // SPDX-License-Identifier: MIT OR Apache-2.0

## CLI Tools
  licensee detect .                    # Detect license (GitHub's tool)
  npx license-checker --summary        # npm dependency licenses
  pip-licenses --format=table          # Python dependency licenses
  cargo license                        # Rust dependency licenses
  scancode -l --json results.json .    # Full codebase scan
  reuse lint                           # FSFE REUSE compliance check
EOF
}

cmd_faq() { cat << 'EOF'
# Open Source License — FAQ

Q: Can I use MIT-licensed code in a commercial product?
A: Yes. MIT allows commercial use, modification, distribution.
   You must include the MIT copyright notice and license text.
   You do NOT need to open-source your product.
   This applies to Apache-2.0, BSD, ISC as well.

Q: What happens if I violate a GPL license?
A: You're committing copyright infringement. Enforcement options:
   1. Cease and desist letter (most common)
   2. Lawsuit for damages and injunction
   3. The Software Freedom Conservancy actively enforces GPL
   Most violations are resolved by coming into compliance (releasing source).
   Busybox and Linux kernel have been enforced multiple times.

Q: Do I need a license for internal tools?
A: No — internal use doesn't trigger distribution requirements.
   GPL copyleft only applies when you distribute the software.
   Exception: AGPL triggers on network access (not just distribution).
   If internal tool uses AGPL library and is accessed over network
   by non-employees, AGPL obligations may apply.

Q: MIT or Apache-2.0 — which should I choose?
A: MIT: Simpler, shorter, most recognized. Best for small projects.
   Apache-2.0: Adds explicit patent grant and NOTICE file mechanism.
   Best for projects with potential patent concerns or corporate use.
   Note: Apache-2.0 is NOT compatible with GPL-2.0 (patent clause conflict).
   Apache-2.0 IS compatible with GPL-3.0.

Q: Can I change my project's license later?
A: If you're sole copyright holder: Yes, at any time.
   If you have contributors: Need every contributor's consent.
   Already distributed copies retain the original license.
   To prepare: Use CLA (contributors assign rights) or DCO.
   Without CLA: Practically impossible for large projects.
EOF
}

cmd_help() {
    echo "license-picker v$VERSION — Open Source License Reference"
    echo ""
    echo "Usage: license-picker <command>"
    echo ""
    echo "Commands:"
    echo "  intro           Permissive vs copyleft, license types"
    echo "  standards       SPDX identifiers, OSI/FSF, compatibility"
    echo "  troubleshooting Conflicts, dual licensing, CLA issues"
    echo "  performance     Scanning tools: FOSSA, Snyk, scancode"
    echo "  security        Patents, indemnification, AGPL/SaaS risks"
    echo "  migration       Proprietary→open source, relicensing"
    echo "  cheatsheet      License comparison table, decision guide"
    echo "  faq             Commercial use, GPL enforcement, choosing"
    echo "  help            Show this help"
}

case "${1:-help}" in
    intro) cmd_intro ;; standards) cmd_standards ;;
    troubleshooting) cmd_troubleshooting ;; performance) cmd_performance ;;
    security) cmd_security ;; migration) cmd_migration ;;
    cheatsheet) cmd_cheatsheet ;; faq) cmd_faq ;;
    help|--help|-h) cmd_help ;;
    *) echo "Unknown: $1"; echo "Run: license-picker help" ;;
esac
