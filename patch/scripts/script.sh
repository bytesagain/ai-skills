#!/usr/bin/env bash
# patch — Software Patching Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Software Patching ===

A patch is a set of changes to transform one version of software
into another. It captures the differences between files and applies
them to produce updated versions.

History:
  1974    diff utility created by Douglas McIlroy (Unix)
  1985    Larry Wall creates the patch utility
  1986    Unified diff format developed (cleaner than context diff)
  1991    CVS uses patches for version control
  2005    Git uses patches as core data exchange format
  2000s   Binary delta patching for software updates
  2010s   Live patching of running kernels (kpatch, livepatch)

Types of Patches:
  Source Patches:
    Text-based diff/patch for source code
    Human-readable, reviewable, small for text changes
    Standard format: unified diff
  
  Binary Patches:
    Delta between two binary files
    Used for: software updates, firmware, game patches
    Algorithms: bsdiff, xdelta, courgette
    Not human-readable
  
  Hot Patches:
    Applied to running systems without restart
    Kernel patches, JVM hotswap, dll injection
    Critical for high-availability systems
  
  Security Patches:
    Fix known vulnerabilities (CVEs)
    Often emergency releases outside normal schedule
    Patch Tuesday (Microsoft), zero-day patches

Patch Workflow:
  Create: diff old_file new_file > changes.patch
  Review: read the patch, understand changes
  Apply:  patch < changes.patch
  Verify: test that patched version works correctly
  Revert: patch -R < changes.patch

Patch Size vs Full Replace:
  1 MB source file, 10 lines changed:
    Patch: ~500 bytes (just the diff)
    Full replace: 1 MB (entire file)
  
  100 MB binary, small change:
    Binary delta: ~100 KB (changed regions)
    Full replace: 100 MB
  
  Bandwidth savings are enormous for updates
EOF
}

cmd_formats() {
    cat << 'EOF'
=== Patch Formats ===

Unified Diff (most common):
  diff -u old.txt new.txt
  
  --- old.txt    2024-01-15 10:00:00.000000000 +0800
  +++ new.txt    2024-01-15 11:00:00.000000000 +0800
  @@ -3,7 +3,8 @@
   unchanged line
   unchanged line
  -removed line
  +added line
  +another added line
   unchanged line
   unchanged line

  Header:
    --- : original file path and timestamp
    +++ : modified file path and timestamp
    @@ : hunk header (line range in old and new file)
    
  Hunk header format: @@ -start,count +start,count @@
    -3,7 : starting at line 3 of old file, showing 7 lines
    +3,8 : starting at line 3 of new file, showing 8 lines

  Line prefixes:
    ' ' (space): unchanged context line
    '-' : removed from old file
    '+' : added in new file

Context Diff (older):
  diff -c old.txt new.txt
  Uses *** and --- separators, ! for changed lines
  More verbose than unified, rarely used today
  15 lines of context vs 3 for unified (default)

Normal Diff (original):
  diff old.txt new.txt
  Format: NcN (change), NdN (delete), NaN (add)
  Example: 3c3 means line 3 changed
  No context lines — very compact but hard to apply to modified files

Ed Script:
  diff -e old.txt new.txt
  Produces ed editor commands to transform file
  Oldest format, compact, rarely used directly

Git Diff Format:
  Extended unified diff with extra metadata
  
  diff --git a/file.txt b/file.txt
  index abc1234..def5678 100644
  --- a/file.txt
  +++ b/file.txt
  @@ -1,5 +1,6 @@
  
  Additional features:
    - File mode changes (chmod)
    - Binary file diffs (OID-based)
    - Copy/rename detection
    - Submodule changes
    - Combined diff for merges (multiple --- headers)

Patch Options:
  -p0: don't strip path prefixes
  -p1: strip first directory (most common for git patches)
  --dry-run: test without applying
  -R: reverse (unapply a patch)
  --fuzz=N: allow N lines of fuzz (imprecise matching)
  --reject: create .rej files for failed hunks
EOF
}

cmd_algorithms() {
    cat << 'EOF'
=== Diff Algorithms ===

Myers Algorithm (Default):
  Eugene Myers, 1986 — "An O(ND) Difference Algorithm"
  
  Concept: find shortest edit script (minimum changes)
  Model: edit graph — each edit is a step in 2D grid
  Moves: right = delete, down = insert, diagonal = keep
  Goal: shortest path from (0,0) to (M,N)
  
  Properties:
    Time: O(N×D) where D = number of differences
    Space: O(N+D) with linear space optimization
    Optimal: guaranteed minimum edit distance
    Used by: GNU diff, git diff (default)
  
  Weakness: doesn't consider code structure
    May produce "correct" diff that's hard to read
    Can split function definitions oddly

Patience Algorithm:
  Bram Cohen (BitTorrent creator), 2005
  
  Steps:
    1. Find unique matching lines (appear exactly once in each file)
    2. Find Longest Common Subsequence of unique lines
    3. Use unique lines as anchors
    4. Recursively diff between anchors using Myers
  
  Properties:
    Better at matching code structure (function boundaries)
    Produces more readable diffs
    Slightly slower than Myers
    Used by: git diff --patience
  
  Best for:
    - Code with many repeated lines (blank lines, braces)
    - Refactoring where functions are moved
    - Generating diffs for human review

Histogram Algorithm:
  Developed for JGit (Java implementation of Git)
  
  Extension of patience that handles non-unique lines
  Counts occurrences of each line (histogram)
  Prefers matching low-occurrence lines first
  Falls back to patience/Myers for common lines
  
  Properties:
    Fast (better cache behavior than Myers)
    Good output quality (close to patience)
    Default in JGit
    Available in git: --diff-algorithm=histogram
  
  Best for: large files with many similar lines

Minimal Algorithm:
  git diff --minimal
  Tries harder to find smallest diff possible
  Slower but produces more compact output
  Useful when: patch size matters more than speed

Comparison:
  Algorithm    Speed    Quality    Best For
  ──────────────────────────────────────────────
  Myers        Fast     Good       Default, most files
  Patience     Medium   Better     Code review, refactoring
  Histogram    Fast     Better     Large files, JGit
  Minimal      Slow     Best       Smallest possible diff

Semantic Diff (Beyond Line-Level):
  AST-based diff: parse code, compare syntax trees
  Tools: GumTree, difftastic, semantic-diff
  Understands: moved functions, renamed variables, reformatting
  Output: "function X was moved from line 10 to line 50"
  Much better for code review but slower and language-specific
EOF
}

cmd_git() {
    cat << 'EOF'
=== Git Patch Workflow ===

Creating Patches:
  git diff > changes.patch
    Working directory changes (unstaged)
  
  git diff --cached > staged.patch
    Staged changes only
  
  git diff HEAD~3..HEAD > last3.patch
    Last 3 commits as single diff
  
  git format-patch -3
    Last 3 commits as individual patch files (0001-*.patch, ...)
    Includes commit metadata (author, date, message)
    Preferred for email-based workflows

Applying Patches:
  git apply changes.patch
    Apply diff to working directory (no commit)
    --check: dry run
    --stat: show stats only
    --3way: attempt three-way merge on failure
  
  git am < 0001-feature.patch
    Apply format-patch output: creates commit with metadata
    --3way: three-way merge on conflict
    --abort: cancel and reset on failure
    --continue: after resolving conflicts
  
  git apply vs patch:
    git apply: stricter, understands git format, binary support
    patch: more forgiving, works with standard unified diff

Cherry-Pick (commit-based patching):
  git cherry-pick abc123
    Apply a specific commit to current branch
    Creates new commit with same changes
    
  git cherry-pick abc123..def456
    Range of commits
    
  git cherry-pick -n abc123
    Apply changes without committing (--no-commit)
    
  Conflict resolution:
    Fix conflicts, git add, git cherry-pick --continue
    Or: git cherry-pick --abort

Interactive Rebase (reorder/edit patches):
  git rebase -i HEAD~5
    pick:   keep commit
    reword: change commit message
    edit:   stop to amend commit
    squash: combine with previous commit
    fixup:  combine, discard message
    drop:   remove commit

Patch Email Workflow:
  Send:    git send-email *.patch (to mailing list)
  Receive: git am mbox-file
  Used by: Linux kernel, git itself, many OSS projects
  
  Format: RFC 2822 email with patch as body
  Subject: [PATCH v2 1/3] description
  
  Cover letter: git format-patch --cover-letter -3

Conflict Resolution:
  git diff --ours    → our version
  git diff --theirs  → their version
  git checkout --ours file.txt    → take our version
  git checkout --theirs file.txt  → take their version
  git merge-tool     → visual merge tool
  
  After resolving: git add file.txt, then continue operation
EOF
}

cmd_binary() {
    cat << 'EOF'
=== Binary Delta Patching ===

Why Binary Patches?
  Software updates ship large binaries (executables, images, databases)
  Full replacement: download entire new version (wasteful)
  Binary delta: download only the changes (often 90%+ smaller)

bsdiff / bspatch:
  Colin Percival, 2003
  Algorithm:
    1. Find matching byte sequences using suffix sorting
    2. Encode differences and extra bytes
    3. Compress with bzip2
  
  Properties:
    Patch size: ~1-15% of new file size (typically)
    Memory: 17× old file size for diff generation
    Very good compression of executable diffs
    Used by: Chrome updates, macOS updates, FreeBSD
  
  Usage:
    bsdiff old_binary new_binary patch.bsdiff
    bspatch old_binary new_binary patch.bsdiff

xdelta (VCDIFF):
  Open-source, RFC 3284 (VCDIFF format)
  
  Algorithm: VCDIFF — copy/add instruction encoding
    COPY: copy N bytes from position P in source
    ADD:  insert N new bytes
    RUN:  repeat byte N times
  
  Properties:
    Faster than bsdiff (less memory too)
    Slightly larger patches for executables
    Streaming capable (can process without loading entire file)
    Good for: large files, databases, disk images
  
  Usage:
    xdelta3 -e -s old_file new_file patch.xdelta
    xdelta3 -d -s old_file patch.xdelta new_file

Courgette (Google):
  Designed specifically for executable binary updates
  1. Disassemble executable (adjust relative addresses)
  2. Apply bsdiff to the adjusted code
  3. Result: 10× smaller than bsdiff for Chrome updates
  
  Why it's better for executables:
    When code is moved, relative jumps change values
    Courgette normalizes addresses before diffing
    Same code at different address → zero difference

OTA (Over-The-Air) Update Systems:
  Android OTA:
    Block-based: diff at filesystem block level (4KB blocks)
    File-based: diff individual files (older method)
    A/B partitioning: install to inactive slot, swap on reboot
    Streaming A/B: apply update while downloading
  
  Chrome Updates:
    Courgette for small updates
    bsdiff as fallback
    Full download if delta too old
    Silent background updates

  iOS Updates:
    Delta updates between consecutive versions
    Full IPSW for major versions
    Ramdisk-based installation

Integrity Verification:
  Hash new file after patching → verify against expected hash
  If mismatch: patch corrupted or wrong base version
  Code signing: verify digital signature of patched output
  Never trust unsigned patches from untrusted sources
EOF
}

cmd_hotpatch() {
    cat << 'EOF'
=== Hot Patching ===

Hot patching applies changes to running systems without restarting.
Critical for high-availability services where downtime costs money.

Linux Kernel Live Patching:
  kpatch (Red Hat):
    Creates kernel module that replaces function implementations
    Uses ftrace to redirect function calls
    Limitations: can't change data structures, add syscalls
    
  livepatch (upstream Linux, 4.0+):
    Standardized kernel live patching framework
    Uses ftrace + consistency model
    kpatch-build creates livepatch modules from source patches
    
  kGraft (SUSE):
    Alternative approach: per-task consistency
    Each task switches to new code individually
    Merged into livepatch framework

  Limitations:
    Function-level granularity only
    Can't change function signatures
    Can't modify data structures
    Complex patches may require reboot
    Security: only for trusted kernel modules

JVM Hot Swap:
  JDWP (Java Debug Wire Protocol):
    Replace method bodies at runtime
    Cannot add/remove methods or fields
    Cannot change class hierarchy
    Available in: all JDKs (debug mode)
  
  JRebel:
    Commercial tool for full class reloading
    Supports: add/remove methods, fields, classes
    No restart, no redeploy
    Used in development (too expensive for production)
  
  Spring Boot DevTools:
    Automatic restart on classpath changes
    Not true hot patching (fast restart)
    Application context recreated

Application-Level Strategies:
  Feature Flags:
    Toggle features without deployment
    if (featureFlag.isEnabled('new-checkout')) { newCode(); }
    Tools: LaunchDarkly, Unleash, Flagsmith
    Not patching per se, but achieves same goal
  
  Blue-Green Deployment:
    Run two identical environments (blue and green)
    Deploy patch to inactive environment
    Switch traffic: blue ↔ green
    Rollback: switch back instantly
  
  Rolling Deployment:
    Update instances one at a time
    At any point, both old and new versions running
    Requires backward-compatible changes
    Used by: Kubernetes rolling update, AWS ECS
  
  Canary Deployment:
    Deploy patch to small percentage of traffic (1-5%)
    Monitor for errors
    Gradually increase to 100%
    Rollback if metrics degrade

Database Hot Patching:
  Schema changes without downtime:
    1. Add new column (nullable, no default constraint)
    2. Backfill data in batches
    3. Update application to use new column
    4. Remove old column (later)
  Tools: gh-ost (GitHub), pt-online-schema-change (Percona)
EOF
}

cmd_security() {
    cat << 'EOF'
=== Security Patching ===

CVE Lifecycle:
  1. Discovery: vulnerability found (researcher, automated scan)
  2. Reporting: reported to vendor (responsible disclosure)
  3. CVE Assignment: MITRE assigns CVE-YYYY-NNNNN
  4. Patch Development: vendor creates fix
  5. Advisory Publication: vendor publishes advisory + patch
  6. Patch Deployment: users apply the patch
  7. Public Exploit: PoC code may be published
  
  Vulnerability Window:
    Time between disclosure and patch application
    Zero-day: exploited before patch exists
    N-day: exploited N days after patch released (but not applied)

CVSS Scoring (v3.1):
  Base Score: 0.0-10.0
    Critical: 9.0-10.0  → patch immediately
    High:     7.0-8.9   → patch within days
    Medium:   4.0-6.9   → patch within weeks
    Low:      0.1-3.9   → patch within months
    None:     0.0       → informational

  Metrics:
    Attack Vector (AV): Network/Adjacent/Local/Physical
    Attack Complexity (AC): Low/High
    Privileges Required (PR): None/Low/High
    User Interaction (UI): None/Required
    Scope (S): Unchanged/Changed
    Impact: Confidentiality/Integrity/Availability (None/Low/High)

Patch Management Best Practices:
  1. Inventory: know all software and versions in your environment
  2. Subscribe: follow vendor security advisories
  3. Assess: evaluate CVSS score and applicability
  4. Test: apply patch in staging environment first
  5. Deploy: push to production within SLA window
  6. Verify: confirm patch applied and effective
  7. Document: record what was patched and when

Patch SLAs (typical enterprise):
  Critical (CVSS 9+):    24-72 hours
  High (CVSS 7-8.9):     7 days
  Medium (CVSS 4-6.9):   30 days
  Low (CVSS <4):         90 days

Automated Patch Management:
  Linux: unattended-upgrades (Debian), dnf-automatic (RHEL)
  Windows: WSUS, SCCM, Intune
  Cloud: AWS Systems Manager Patch Manager, Azure Update Management
  Containers: rebuild image with patched base, redeploy
  Dependencies: Dependabot, Snyk, Renovate

Risks of Not Patching:
  Equifax breach (2017): unpatched Apache Struts → 147M records
  WannaCry (2017): unpatched Windows SMB → global ransomware
  Log4Shell (2021): Log4j RCE → massive exploitation within hours
  
  The window between patch release and exploit is shrinking
  Average time to exploit after patch: 15 days (2023 data)
EOF
}

cmd_kernel() {
    cat << 'EOF'
=== OS & Kernel Patching ===

Linux Kernel Patching:
  Traditional:
    1. Download new kernel source/package
    2. Build (if from source) or install package
    3. Update bootloader (GRUB)
    4. Reboot into new kernel
    
  Package-managed (recommended):
    Ubuntu/Debian: apt update && apt upgrade linux-image-*
    RHEL/CentOS:   dnf update kernel
    Auto-reboot: schedule maintenance window
    
  Live Patch (no reboot):
    Canonical Livepatch: Ubuntu Pro service
    RHEL kpatch: Red Hat subscription
    SUSE kGraft: SUSE subscription
    Amazon Linux: kernel live patching via yum
    
    Limitations:
      Only for security and critical bug fixes
      Complex changes still require reboot
      Some patches accumulate → eventual reboot needed

Windows Patching:
  Patch Tuesday: second Tuesday of each month
    Security updates, quality updates
    Out-of-band: critical zero-days (any time)
  
  Update Types:
    Quality Update (cumulative): monthly security + bug fixes
    Feature Update: major version upgrade (annual)
    Servicing Stack Update: updates the update mechanism itself
    
  Channels:
    Windows Update: consumer automatic updates
    WSUS: enterprise centralized management
    Microsoft Update Catalog: manual download
    
  Restart requirement:
    Most kernel/driver patches require restart
    Restart can be scheduled/delayed
    Active Hours: prevent restart during work time

Container/Cloud Patching:
  Immutable infrastructure:
    Don't patch running containers
    Rebuild image with updated base
    Redeploy (rolling update)
    
  Workflow:
    1. Update Dockerfile base image
    2. Rebuild container image
    3. Push to registry
    4. Rolling deploy (Kubernetes/ECS)
    5. Old containers terminated
    
  Advantage: every instance is identical, tested
  Challenge: need CI/CD pipeline for rapid rebuilds

Firmware/BIOS Patching:
  UEFI updates: vendor-provided, requires reboot
  Linux: fwupd + LVFS (Linux Vendor Firmware Service)
    fwupdmgr get-updates
    fwupdmgr update
  BMC/IPMI: out-of-band management firmware
  Microcode: CPU microcode updates (Spectre/Meltdown mitigations)
    Loaded at boot by kernel or BIOS
    Intel: /lib/firmware/intel-ucode/
    AMD: /lib/firmware/amd-ucode/
EOF
}

show_help() {
    cat << EOF
patch v$VERSION — Software Patching Reference

Usage: script.sh <command>

Commands:
  intro       Patching overview — history, types, workflow
  formats     Patch formats: unified, context, ed, git diff
  algorithms  Diff algorithms: Myers, patience, histogram
  git         Git patch workflow: format-patch, am, cherry-pick
  binary      Binary delta: bsdiff, xdelta, courgette, OTA
  hotpatch    Hot patching: kernel live patch, JVM, deployments
  security    Security patching: CVE lifecycle, management, SLAs
  kernel      OS/kernel patching: Linux, Windows, containers
  help        Show this help
  version     Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    formats)    cmd_formats ;;
    algorithms) cmd_algorithms ;;
    git)        cmd_git ;;
    binary)     cmd_binary ;;
    hotpatch)   cmd_hotpatch ;;
    security)   cmd_security ;;
    kernel)     cmd_kernel ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "patch v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
