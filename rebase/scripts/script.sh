#!/usr/bin/env bash
# rebase — Git Rebase Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Git Rebase ===

Rebase replays commits from one branch onto another, creating a linear
history as if the work happened sequentially.

Mental Model:
  Before rebase:
    main:    A---B---C
    feature:      \---D---E---F

  After: git rebase main (from feature branch)
    main:    A---B---C
    feature:          \---D'---E'---F'

  D, E, F are re-created as D', E', F' on top of C.
  They have new SHA hashes (different parent = different commit).

What Rebase Does:
  1. Finds common ancestor of current branch and target
  2. Saves all commits unique to current branch (as patches)
  3. Resets current branch to target
  4. Replays saved patches one by one on top

When to Rebase:
  ✓ Cleaning up local commits before pushing
  ✓ Keeping feature branch up-to-date with main
  ✓ Squashing WIP commits into meaningful ones
  ✓ Maintaining linear, readable history

When NOT to Rebase:
  ✗ On commits already pushed and shared with others
  ✗ On main/master (rewriting shared history)
  ✗ When merge commits carry important context

Golden Rule:
  Never rebase commits that exist outside your local repository.
  If anyone else has based work on those commits, rebase creates chaos.

Common Commands:
  git rebase main              Rebase current branch onto main
  git rebase -i HEAD~5         Interactive rebase last 5 commits
  git rebase --onto A B C      Transplant C onto A, excluding B
  git rebase --abort           Cancel in-progress rebase
  git rebase --continue        Continue after resolving conflicts
EOF
}

cmd_interactive() {
    cat << 'EOF'
=== Interactive Rebase ===

Interactive rebase lets you edit, reorder, squash, and drop commits.
The most powerful history-editing tool in git.

Start: git rebase -i HEAD~5  (edit last 5 commits)
       git rebase -i main    (edit all commits since main)

Editor opens with commit list (oldest first):
  pick a1b2c3d Add user authentication
  pick d4e5f6a Fix typo in auth module
  pick 7g8h9i0 Add password validation
  pick j1k2l3m WIP: debugging
  pick n4o5p6q Final cleanup

Commands (replace "pick" with):
  pick (p)    Use commit as-is
  reword (r)  Use commit but edit the commit message
  edit (e)    Use commit but stop for amending
  squash (s)  Meld into previous commit, combine messages
  fixup (f)   Meld into previous commit, discard this message
  drop (d)    Remove commit entirely
  exec (x)    Run shell command after this commit

--- Common Operations ---

Squash multiple commits:
  pick a1b2c3d Add user authentication
  fixup d4e5f6a Fix typo in auth module         ← absorbed into above
  pick 7g8h9i0 Add password validation
  fixup j1k2l3m WIP: debugging                  ← absorbed into above
  drop n4o5p6q Final cleanup                     ← removed

  Result: 2 clean commits instead of 5 messy ones

Reorder commits:
  pick 7g8h9i0 Add password validation           ← moved up
  pick a1b2c3d Add user authentication           ← moved down
  Just reorder lines in the editor

Edit a commit:
  edit a1b2c3d Add user authentication
  # Git stops at this commit
  # Make changes, then:
  git add .
  git commit --amend
  git rebase --continue

Split a commit:
  edit a1b2c3d Big commit to split
  # Git stops at this commit
  git reset HEAD~1                   # undo commit but keep changes
  git add file1.py && git commit -m "Part 1"
  git add file2.py && git commit -m "Part 2"
  git rebase --continue

Run tests after each commit:
  pick a1b2c3d Add feature
  exec npm test
  pick d4e5f6a Add another feature
  exec npm test
EOF
}

cmd_vs_merge() {
    cat << 'EOF'
=== Rebase vs Merge ===

--- Merge ---
  git checkout main && git merge feature

  Before:
    main:    A---B---C
    feature:      \---D---E

  After:
    main:    A---B---C---------M
    feature:      \---D---E---/

  Creates merge commit M with two parents.

  Pros:
    ✓ Non-destructive (history is preserved exactly)
    ✓ Safe for shared branches
    ✓ Merge commit shows when integration happened
    ✓ Easy to revert (revert the merge commit)

  Cons:
    ✗ Creates "railroad tracks" in history
    ✗ Can be hard to follow with many branches
    ✗ Merge commits add noise to git log

--- Rebase ---
  git checkout feature && git rebase main

  Before:
    main:    A---B---C
    feature:      \---D---E

  After:
    main:    A---B---C
    feature:          \---D'---E'

  Then fast-forward merge: git checkout main && git merge feature
    main:    A---B---C---D'---E'

  Pros:
    ✓ Linear history (easy to read git log)
    ✓ Each commit builds on the previous cleanly
    ✓ git bisect works better (no merge commits to skip)
    ✓ Clean git log --oneline

  Cons:
    ✗ Rewrites history (new commit hashes)
    ✗ Dangerous on shared branches
    ✗ Conflict resolution per commit (not once like merge)
    ✗ Loses context of when integration happened

--- Team Workflows ---

  Rebase workflow (linear history):
    1. Work on feature branch
    2. git rebase main (update to latest)
    3. git push --force-with-lease
    4. Create PR, merge with fast-forward
    Result: perfectly linear main branch

  Merge workflow (preserved history):
    1. Work on feature branch
    2. git merge main (update to latest)
    3. Create PR, merge with merge commit
    Result: full branch topology preserved

  Squash merge (hybrid):
    1. Work on feature branch (messy commits OK)
    2. PR merged with "squash and merge" button
    3. All commits compressed into one on main
    Result: linear main, feature branch history lost

  Recommendation:
    Personal branches: rebase freely
    Team branches: merge (or squash merge)
    Main/master: never rebase
EOF
}

cmd_conflicts() {
    cat << 'EOF'
=== Rebase Conflict Resolution ===

During rebase, conflicts can occur at EACH commit being replayed.
Unlike merge (one conflict resolution), rebase may require multiple.

--- When Conflicts Occur ---
  Commit being replayed changes same lines as upstream changes.
  Git stops and asks you to resolve before continuing.

  $ git rebase main
  CONFLICT (content): Merge conflict in src/auth.py
  error: could not apply a1b2c3d... Add authentication

--- Resolution Steps ---
  1. Open conflicted files
     <<<<<<< HEAD
     current_upstream_version
     =======
     your_changes_being_replayed
     >>>>>>> a1b2c3d (Add authentication)

  2. Edit to desired result (remove markers)

  3. Stage resolved files
     git add src/auth.py

  4. Continue rebase
     git rebase --continue

  5. Repeat for each conflicting commit

--- Abort ---
  Lost? Want to start over?
  git rebase --abort
  Returns to exact state before rebase started. Always safe.

--- Skip a commit ---
  git rebase --skip
  Drops the current commit (useful if conflict resolution makes it empty)

--- rerere (Reuse Recorded Resolution) ---
  Git remembers how you resolved conflicts and auto-applies next time.

  Enable: git config --global rerere.enabled true

  How it works:
    1. First time: you resolve conflict manually
    2. Git records the resolution
    3. Next rebase with same conflict: auto-resolved!

  Especially useful when rebasing repeatedly (stacked PRs, long-lived branches)

--- Reducing Conflict Pain ---
  1. Rebase frequently (small updates = fewer conflicts)
  2. Keep commits small and focused
  3. Avoid reformatting unrelated code in feature commits
  4. Use rerere
  5. Consider merge instead if conflicts are frequent

--- After Force Push ---
  After rebase, local branch has diverged from remote:
  git push --force-with-lease origin feature

  --force-with-lease is safer than --force:
  It refuses if remote has commits you haven't seen
  (prevents overwriting someone else's work)
EOF
}

cmd_onto() {
    cat << 'EOF'
=== Rebase --onto ===

--onto transplants a range of commits from one base to another.
The most powerful (and confusing) form of rebase.

Syntax: git rebase --onto <newbase> <oldbase> <branch>
  Translation: take commits between oldbase and branch,
               replay them onto newbase

--- Use Case 1: Change base branch ---
  Situation: feature branched from develop, should be on main

  Before:
    main:     A---B
    develop:      \---C---D
    feature:              \---E---F

  Command:
    git rebase --onto main develop feature

  After:
    main:     A---B---E'---F'  (feature is now based on main)
    develop:      \---C---D    (unchanged)

--- Use Case 2: Remove commits ---
  Situation: want to remove commits C and D from middle of branch

  Before:
    main: A---B---C---D---E---F  (feature)

  Command:
    git rebase --onto B D feature

  Translation: take commits after D up to feature, put on B

  After:
    main: A---B---E'---F'  (C and D removed)

--- Use Case 3: Stacked branches ---
  Situation: feature-2 is based on feature-1, feature-1 was rebased

  Before:
    main:       A---B---C
    feature-1:      \---D---E      (old)
    feature-2:              \---F---G

  After feature-1 is rebased onto main:
    main:       A---B---C---D'---E'  (feature-1 rebased)
    feature-2:          \---D---E---F---G  (still on old base!)

  Fix feature-2:
    git rebase --onto feature-1 E feature-2
    (take commits after old E, put on new feature-1)

  Result:
    main:       A---B---C---D'---E'---F'---G'

--- Understanding the Three Arguments ---
  git rebase --onto A B C

  A = where to put the commits (new base)
  B = where to start cutting (exclusive — commits AFTER B)
  C = where to stop cutting (inclusive — up to and including C)

  Think of it as: "cut commits (B, C] and paste onto A"
EOF
}

cmd_autosquash() {
    cat << 'EOF'
=== Autosquash Workflow ===

Autosquash automatically reorders fixup and squash commits during
interactive rebase, matching them to their target commits.

--- Setup ---
  git config --global rebase.autosquash true

--- Creating fixup commits ---
  # Original commit
  git commit -m "Add user validation"     # SHA: abc123

  # Later, fix a bug in that commit:
  git add fixed_file.py
  git commit --fixup=abc123
  # Creates commit: "fixup! Add user validation"

  # Or to squash (combine messages):
  git commit --squash=abc123
  # Creates commit: "squash! Add user validation"

--- During rebase ---
  git rebase -i main --autosquash

  Editor shows (auto-reordered):
    pick abc123 Add user validation
    fixup def456 fixup! Add user validation    ← auto-placed after target
    pick ghi789 Add email notification

  Without autosquash you'd have to manually reorder.

--- Amend-like workflow ---
  Instead of git commit --amend (which only works on last commit):

  1. Make fix for any previous commit
  2. Stage the fix: git add .
  3. git commit --fixup=<target-sha>
  4. When ready: git rebase -i main --autosquash
  5. Fixups automatically absorbed into their targets

--- Tips ---
  Find SHA to fixup:
    git log --oneline -20     # pick the target SHA

  Fixup + push in one go:
    git commit --fixup=abc123
    git rebase -i main --autosquash
    git push --force-with-lease

  Auto-enable:
    git config --global rebase.autosquash true
    Then just: git rebase -i main  (autosquash always active)

--- fixup vs squash ---
  fixup:  absorbs changes, DISCARDS fixup's commit message
  squash: absorbs changes, COMBINES both commit messages
  Use fixup 90% of the time (cleaner history)
EOF
}

cmd_safety() {
    cat << 'EOF'
=== Rebase Safety ===

--- The Golden Rule ---
  DO NOT rebase commits that have been pushed to a shared branch
  and that others may have based work on.

  Safe to rebase:
    ✓ Local commits not yet pushed
    ✓ Your personal feature branch (you're the only user)
    ✓ Branch where all collaborators agree to rebase workflow

  Dangerous to rebase:
    ✗ main/master branch
    ✗ develop/staging branches
    ✗ Any branch others are actively working on

--- Reflog Recovery ---
  Rebase went wrong? Git reflog saves you.

  git reflog
  # Shows all recent HEAD movements:
  abc1234 HEAD@{0}: rebase (finish): ...
  def5678 HEAD@{1}: rebase (start): ...
  ghi9012 HEAD@{2}: commit: My last good state

  # Restore to before rebase:
  git reset --hard HEAD@{2}    # or the SHA before rebase started

  Reflog entries last 90 days by default.
  As long as you don't gc, your old commits are recoverable.

--- Force Push Safety ---

  NEVER: git push --force
    Overwrites remote unconditionally
    Can destroy other people's work

  ALWAYS: git push --force-with-lease
    Refuses if remote has commits you haven't fetched
    Safe: won't overwrite someone else's push

  Even safer: git push --force-with-lease --force-if-includes
    Also checks that you've integrated remote changes locally

--- Pre-Rebase Backup ---
  Before complex rebase, create a backup branch:
  git branch backup-feature-branch
  # Do your rebase
  # If everything looks good:
  git branch -D backup-feature-branch

--- Rebase Onto Wrong Target? ---
  git rebase --abort           # if still in progress
  git reset --hard ORIG_HEAD   # if just finished
  git reset --hard @{1}        # using reflog

--- Team Agreement ---
  If your team uses rebase workflow:
  1. Document it in CONTRIBUTING.md
  2. Protect main branch (no force push)
  3. Everyone must understand force-push etiquette
  4. Use --force-with-lease, never --force
  5. Communicate before rebasing shared branches
EOF
}

cmd_workflows() {
    cat << 'EOF'
=== Rebase Workflows ===

--- Trunk-Based Development with Rebase ---
  All work done in short-lived feature branches, rebased onto main.

  Flow:
    1. git checkout -b feature main
    2. Make commits (small, focused)
    3. git fetch origin && git rebase origin/main
    4. git push --force-with-lease
    5. PR review
    6. Merge with fast-forward (linear history)

  Rules:
    Feature branches live < 2 days
    Rebase onto main at least daily
    No merge commits on main

--- Feature Branch with Squash ---
  Messy work allowed on feature branch, cleaned up before merge.

  Flow:
    1. Work on feature branch (WIP commits OK)
    2. When ready: git rebase -i main
    3. Squash WIP into meaningful commits
    4. Force push to update PR
    5. Merge with fast-forward

  Result: Clean main history, messy process allowed

--- Stacked PRs ---
  Build features incrementally, each PR based on previous.

  Setup:
    main → feature-part1 → feature-part2 → feature-part3

  When part1 merges:
    git checkout feature-part2
    git rebase main  (picks up part1 via main)
    git checkout feature-part3
    git rebase feature-part2

  Tools: ghstack, git-branchless, Graphite (automate this)

--- Daily Rebase Routine ---
  Morning:
    git fetch origin
    git rebase origin/main
    # Resolve any conflicts
    git push --force-with-lease

  This keeps your branch current and conflicts small.

--- Rebase Policy Comparison ---
  GitHub:   "Rebase and merge" button (linear history)
  GitLab:   "Fast-forward merge" option
  Bitbucket: "Rebase, fast-forward" strategy

  All achieve linear history on the target branch.
  Developer rebases locally, platform verifies it's fast-forwardable.
EOF
}

show_help() {
    cat << EOF
rebase v$VERSION — Git Rebase Reference

Usage: script.sh <command>

Commands:
  intro        Git rebase overview and mental model
  interactive  Interactive rebase: pick, squash, fixup, edit
  vs_merge     Rebase vs merge trade-offs and workflows
  conflicts    Conflict resolution during rebase
  onto         Rebase --onto for branch transplanting
  autosquash   Fixup! and squash! commit workflow
  safety       Golden rule, reflog recovery, force-push safety
  workflows    Trunk-based, feature branch, stacked PR workflows
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    interactive) cmd_interactive ;;
    vs_merge)    cmd_vs_merge ;;
    conflicts)   cmd_conflicts ;;
    onto)        cmd_onto ;;
    autosquash)  cmd_autosquash ;;
    safety)      cmd_safety ;;
    workflows)   cmd_workflows ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "rebase v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
