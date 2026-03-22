#!/usr/bin/env bash
# squash — Git Squash Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Git Squash ===

Squashing combines multiple commits into a single commit, creating a
cleaner, more readable Git history.

Why Squash:
  - Clean up "WIP", "fix typo", "oops" commits before merging
  - Present a logical, reviewable unit of work
  - Make git log useful for understanding project history
  - Simplify rollbacks (one commit = one feature)
  - Reduce noise in main branch history

When to Squash:
  ✓ Before merging feature branch to main
  ✓ Multiple commits that fix the same bug
  ✓ WIP commits that were stepping stones
  ✓ Typo/formatting fixes after the real commit
  ✓ Splitting work into logical units

When NOT to Squash:
  ✗ Already pushed to shared branch others have pulled
  ✗ Each commit is a meaningful, independent change
  ✗ You need to preserve the development timeline for audit
  ✗ During active code review (reviewers lose context)

Three Ways to Squash:
  1. Interactive Rebase     git rebase -i HEAD~N
     Full control. Pick, squash, fixup, reword, reorder.

  2. Squash Merge           git merge --squash feature
     Combines all branch commits into one on target branch.

  3. Soft Reset             git reset --soft HEAD~N && git commit
     Quick and dirty. Collapses N commits into staging area.

The Mental Model:
  Before squash:
    abc1234 fix typo in README
    def5678 add error handling
    ghi9012 initial feature implementation

  After squash:
    xyz7890 Add user authentication feature
    (one clean commit with all changes)
EOF
}

cmd_interactive() {
    cat << 'EOF'
=== Interactive Rebase Squash ===

Step 1: Start interactive rebase
  git rebase -i HEAD~5          # last 5 commits
  git rebase -i abc1234         # since commit abc1234
  git rebase -i main            # since branching from main

Step 2: Editor opens with commit list (oldest first!)
  pick abc1234 initial feature implementation
  pick def5678 add error handling
  pick ghi9012 fix typo in README
  pick jkl3456 add tests
  pick mno7890 update docs

Step 3: Change 'pick' to action keywords:
  pick abc1234 initial feature implementation
  squash def5678 add error handling
  fixup ghi9012 fix typo in README
  squash jkl3456 add tests
  fixup mno7890 update docs

Step 4: Save and close editor
  - 'squash' commits: editor opens to combine messages
  - 'fixup' commits: message discarded silently

Available Commands:
  pick (p)     Use commit as-is
  reword (r)   Use commit but edit the message
  edit (e)     Stop at commit for amending
  squash (s)   Meld into previous commit, combine messages
  fixup (f)    Meld into previous commit, discard this message
  drop (d)     Remove commit entirely
  exec (x)     Run shell command after commit
  break (b)    Stop here (continue with git rebase --continue)

Key Difference — squash vs fixup:
  squash: Opens editor with BOTH commit messages combined
  fixup:  Keeps only the previous commit's message (silent)

  Use squash when both messages have useful info to merge.
  Use fixup for "oops" commits whose messages are worthless.

Aborting:
  git rebase --abort             # cancel and restore original state

Conflicts During Rebase:
  1. Fix conflicts in files
  2. git add <resolved files>
  3. git rebase --continue
  4. Repeat if more conflicts

Force Push After Rebase:
  git push --force-with-lease    # safer than --force
  Only needed if branch was already pushed
  ⚠ Never force-push to shared branches (main, develop)
EOF
}

cmd_merge() {
    cat << 'EOF'
=== Squash Merge ===

git merge --squash takes ALL commits from a branch and stages them
as a single set of changes, ready to commit as one.

Workflow:
  git checkout main
  git merge --squash feature-branch
  git commit -m "Add user authentication (#42)"

What Happens:
  1. All changes from feature-branch are applied to working tree
  2. Changes are staged (added to index)
  3. NO merge commit is created yet
  4. You write a single commit message for everything
  5. Feature branch history is NOT connected to main

Before (feature-branch):
  main:    A --- B --- C
                  \
  feature:         D --- E --- F --- G

After (git merge --squash + commit):
  main:    A --- B --- C --- H
  (H contains all changes from D+E+F+G as single commit)
  (feature branch still exists with D-E-F-G, but is disconnected)

Pros:
  ✓ Clean main branch history (one commit per feature)
  ✓ Easy to revert entire feature (git revert H)
  ✓ Simple — no need to understand interactive rebase
  ✓ Branch authors don't need to clean up commits

Cons:
  ✗ Loses individual commit history
  ✗ Feature branch not marked as merged (git branch -d won't work)
    → Must use git branch -D (force delete)
  ✗ No merge base connection — can cause issues re-merging
  ✗ Blame loses granularity (entire feature = one commit)

vs Interactive Rebase:
  Squash merge: operator works on target branch
  Interactive rebase: operator works on source branch

  Squash merge: all-or-nothing (one final commit)
  Interactive rebase: can selectively squash some, keep others

Cleaning Up After Squash Merge:
  git branch -D feature-branch   # must force delete
  git push origin --delete feature-branch  # delete remote
EOF
}

cmd_fixup() {
    cat << 'EOF'
=== Autosquash with Fixup ===

Git has special commit message prefixes that auto-arrange
during interactive rebase with --autosquash.

--- fixup! prefix ---
  # Original commit:
  git commit -m "Add login form validation"

  # Later, fixing something in that commit:
  git commit -m "fixup! Add login form validation"

  # When rebasing:
  git rebase -i --autosquash main

  # Git auto-arranges:
  pick abc1234 Add login form validation
  fixup def5678 fixup! Add login form validation    ← auto-placed!

--- squash! prefix ---
  Same as fixup! but combines messages instead of discarding.
  git commit -m "squash! Add login form validation"

--- git commit --fixup ---
  Even easier — reference by commit hash:
  git commit --fixup abc1234
  # Creates commit with message: "fixup! <message of abc1234>"

  git commit --squash abc1234
  # Creates commit with message: "squash! <message of abc1234>"

--- Amend-style fixup (Git 2.32+) ---
  git commit --fixup=amend:abc1234
  # When autosquashed, replaces the commit message entirely

--- Auto-autosquash ---
  Set globally so you don't forget --autosquash:
  git config --global rebase.autoSquash true

  Now every interactive rebase automatically arranges fixup/squash commits.

Complete Workflow:
  1. git commit -m "Add user dashboard"        # main work
  2. git commit -m "Add unit tests"             # more work
  3. git commit --fixup HEAD~1                  # fix dashboard commit
  4. git commit --fixup HEAD~2                  # another dashboard fix
  5. git rebase -i --autosquash main            # everything auto-arranges
  6. Just save the editor — fixups are already placed correctly

  Result: Clean history with properly combined commits
EOF
}

cmd_messages() {
    cat << 'EOF'
=== Squash Commit Messages ===

When squashing, you get one chance to write a clear commit message
that represents the entire body of work.

Good Squash Message Template:
  <type>(<scope>): <short summary>     ← 50 chars max

  <body — what and why>                ← 72 chars per line

  <footer — references, breaking changes>

Example:
  feat(auth): add user authentication system

  Implement JWT-based authentication with login, logout,
  and token refresh. Includes:
  - Login form with email/password validation
  - JWT token generation and refresh flow
  - Protected route middleware
  - User session management
  - Rate limiting on login endpoint

  Closes #42
  Reviewed-by: Alice <alice@example.com>

Conventional Commit Types:
  feat      New feature
  fix       Bug fix
  docs      Documentation only
  style     Formatting, no code change
  refactor  Code change, no new feature or fix
  perf      Performance improvement
  test      Adding or fixing tests
  chore     Build, CI, tooling changes

What to Include in Squash Messages:
  ✓ WHAT changed (summary line)
  ✓ WHY it changed (motivation, problem being solved)
  ✓ Notable implementation decisions
  ✓ Issue/ticket references
  ✓ Breaking changes (BREAKING CHANGE: ...)

What NOT to Include:
  ✗ "WIP", "TODO", "temp fix"
  ✗ Step-by-step development narrative
  ✗ Commit-by-commit changelog
  ✗ Merge conflict resolution details

When Squash Editor Opens (combining messages):
  Git shows all commit messages concatenated.
  Delete the noise, keep useful context, rewrite as unified message.

  # Before (auto-generated in editor):
  # Add login form
  # Fix form validation
  # Add tests for login
  # Fix test mock
  # Update README

  # After (your edit):
  feat(auth): add login form with validation

  Email/password login form with client-side validation
  and comprehensive test coverage.

  Closes #42
EOF
}

cmd_workflows() {
    cat << 'EOF'
=== Team Squash Workflows ===

--- Squash and Merge (GitHub Default) ---
  How: PR → "Squash and merge" button
  Result: Single commit on main with PR title as message
  Best for: Teams that want clean main history
  Trade-off: Lose individual commit history

  main: A → B → C → [squash of feature] → D

--- Rebase and Merge ---
  How: PR → "Rebase and merge" button
  Result: Individual commits replayed on top of main (new hashes)
  Best for: Teams that want linear history with detail
  Trade-off: More commits on main, must have clean branch

  main: A → B → C → feat1 → feat2 → feat3 → D

--- Merge Commit ---
  How: PR → "Create a merge commit" button
  Result: All branch commits preserved + merge commit added
  Best for: Teams that want full history and merge points
  Trade-off: Non-linear history, harder to read

  main: A → B → C ────────────── M → D
                  \              /
  feature:         D → E → F ──┘

Comparison:
  ┌──────────────┬────────────┬─────────────┬──────────────┐
  │              │ Squash     │ Rebase      │ Merge Commit │
  ├──────────────┼────────────┼─────────────┼──────────────┤
  │ Main history │ Very clean │ Clean       │ Complex      │
  │ Commits/PR   │ 1          │ N (original)│ N + 1 merge  │
  │ Linear       │ Yes        │ Yes         │ No           │
  │ Bisect       │ Coarse     │ Fine-grained│ Fine-grained │
  │ Revert       │ Easy       │ Per-commit  │ Revert merge │
  │ Branch info  │ Lost       │ Lost        │ Preserved    │
  │ Author       │ Preserved  │ Preserved   │ Preserved    │
  └──────────────┴────────────┴─────────────┴──────────────┘

Recommended Setup (GitHub):
  Settings → Merge button:
  ☑ Allow squash merging (default message: PR title + description)
  ☐ Allow merge commits (disable for clean history)
  ☑ Allow rebase merging (for clean multi-commit PRs)
  ☑ Automatically delete head branches
EOF
}

cmd_recovery() {
    cat << 'EOF'
=== Recovering from Squash Mistakes ===

--- Undo Last Squash (before push) ---
  git reflog
  # Find the commit before rebase:
  # abc1234 HEAD@{2}: rebase (start): ...
  # def5678 HEAD@{3}: commit: my original last commit

  git reset --hard HEAD@{3}     # restore to before rebase
  # All original commits are back!

--- Reflog is Your Safety Net ---
  git reflog show HEAD           # see all HEAD movements
  git reflog show feature-branch # see branch movements

  Reflog entries survive for 90 days (default)
  Even force-pushed-over commits exist in reflog

--- Undo Squash Merge ---
  git revert HEAD                # if already pushed and shared

  # Or if not pushed yet:
  git reset --hard HEAD~1        # remove the squash commit

--- Cherry-Pick from Squashed Branch ---
  If you squash-merged but need an individual commit:
  git log --all --oneline        # find the original commit
  git cherry-pick abc1234        # apply it

--- Partial Squash Recovery ---
  Squashed too many commits? Want to split?
  git reset --soft HEAD~1        # unstage the squash commit
  # Now all changes are staged
  # Selectively commit parts:
  git reset HEAD file1.js        # unstage file1
  git commit -m "Part 1: ..."
  git add file1.js
  git commit -m "Part 2: ..."

--- Interactive Rebase Gone Wrong ---
  During rebase:
    git rebase --abort           # cancel everything

  After rebase completed:
    git reflog                   # find pre-rebase state
    git reset --hard HEAD@{N}    # go back

--- Protect Against Mistakes ---
  git config --global rebase.missingCommitsCheck error
  # Refuses rebase if you accidentally delete a commit line

  Always use --force-with-lease instead of --force:
  git push --force-with-lease
  # Fails if remote has commits you haven't fetched
  # Prevents overwriting teammates' work
EOF
}

cmd_platforms() {
    cat << 'EOF'
=== Platform Squash Settings ===

--- GitHub ---
  Settings → General → Pull Requests:
    ☑ Allow squash merging
    Default commit message:
      • PR title         → commit subject
      • PR title + description → subject + body
      • PR title + commits → subject + bullet list of commits

  Branch protection rules:
    Require linear history → forces squash or rebase merge

  API: PUT /repos/{owner}/{repo}/pulls/{pull_number}/merge
    merge_method: "squash"

--- GitLab ---
  Settings → Merge Requests:
    Squash commits when merging: Encourage / Require / Allow

  Merge request widget:
    ☑ Squash commits (checkbox per MR)

  Squash commit message template:
    %{title} (!%{merge_request_id})

  Pipeline behavior:
    Squash happens after CI passes, during merge

--- Bitbucket ---
  Repository Settings → Merge strategies:
    ☑ Squash (combine all commits)

  Pull request merge dialog:
    Strategy dropdown → "Squash"

  Squash message: defaults to PR title + description

--- Common Across Platforms ---
  All three platforms:
  - Support squash merge as a merge strategy
  - Allow setting default/required merge strategies
  - Preserve PR/MR author as commit author
  - Auto-delete source branch option after merge
  - Support branch protection rules

  Key difference:
  GitHub: Per-repo setting for allowed merge types
  GitLab: Per-project + per-MR toggle
  Bitbucket: Per-repo default, per-PR override
EOF
}

show_help() {
    cat << EOF
squash v$VERSION — Git Squash Reference

Usage: script.sh <command>

Commands:
  intro        What squashing is and when to use it
  interactive  Interactive rebase squash step-by-step
  merge        Squash merge (git merge --squash) workflow
  fixup        Autosquash with fixup! and squash! prefixes
  messages     Writing effective squash commit messages
  workflows    Team workflows: squash vs rebase vs merge commit
  recovery     Recovering from squash mistakes with reflog
  platforms    Squash settings on GitHub, GitLab, Bitbucket
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    interactive) cmd_interactive ;;
    merge)       cmd_merge ;;
    fixup)       cmd_fixup ;;
    messages)    cmd_messages ;;
    workflows)   cmd_workflows ;;
    recovery)    cmd_recovery ;;
    platforms)   cmd_platforms ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "squash v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
