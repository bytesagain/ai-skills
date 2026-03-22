#!/usr/bin/env bash
# blame — Git Blame & Code Archaeology Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Git Blame: Code Annotation ===

git blame annotates each line of a file with the commit that last
modified it — who changed it, when, and in which commit.

Basic Usage:
  git blame <file>
  git blame src/main.py

Output Format:
  abc1234d (Alice Smith 2024-03-15 14:30:22 +0800  42) def process():

  Fields:
    abc1234d       Short commit hash
    Alice Smith    Author name
    2024-03-15     Date of commit
    14:30:22       Time
    +0800          Timezone
    42             Line number
    def process(): The actual line content

  ^abc1234        Leading ^ means this line is from the initial commit
  00000000        All zeros means the line is uncommitted (working tree)

Porcelain Format (for scripting):
  git blame --porcelain <file>
  git blame --line-porcelain <file>  (full header per line)
  
  Outputs structured data:
    <hash> <orig_line> <final_line> <num_lines>
    author Alice Smith
    author-mail <alice@example.com>
    author-time 1710485422
    author-tz +0800
    committer Bob Jones
    ...
    filename src/main.py
    	def process():

When to Use Blame:
  ✓ "Who wrote this line? I have a question."
  ✓ "When was this logic added? What was the context?"
  ✓ "This looks wrong — was it intentional?"
  ✓ Finding the commit message that explains WHY

When NOT to Use Blame:
  ✗ Finding who to yell at (blame ≠ fault)
  ✗ The last change was a rename/format — use --ignore-rev
  ✗ You need history of deleted code — use git log -S
EOF
}

cmd_options() {
    cat << 'EOF'
=== Git Blame Options ===

Line Range (-L):
  git blame -L 10,20 file.py        Lines 10–20
  git blame -L 10,+5 file.py        5 lines starting from 10
  git blame -L '/def process/,/^def/' file.py   Regex range
  git blame -L :funcname file.py     Named function (language-aware)

Detect Movement (-C, -M):
  git blame -M file.py
    Detect lines moved WITHIN the same file
    Shows original commit, not the move commit
  
  git blame -C file.py
    Detect lines copied from other files in same commit
  
  git blame -C -C file.py
    Detect copies from any file in commit that created this file
  
  git blame -C -C -C file.py
    Detect copies from ANY file in ANY commit (slow but thorough)

Ignore Whitespace (-w):
  git blame -w file.py
    Ignore whitespace changes when finding last real change
    Essential for files that were re-indented

Date Range:
  git blame --since=3.months file.py
    Only show blame for changes in last 3 months
    Older lines show as ^boundary commit

Ignore Specific Revisions:
  git blame --ignore-rev abc1234 file.py
  git blame --ignore-revs-file .git-blame-ignore-revs file.py
    Skip formatting/refactoring commits
    Shows the previous meaningful change instead

Other Useful Flags:
  git blame -e file.py           Show email instead of name
  git blame -s file.py           Short format (hash + line only)
  git blame --date=short file.py Just date, no time
  git blame --color-lines        Color by commit for visual grouping
  git blame -f file.py           Show filename (useful with -C)
  git blame --root file.py       Don't treat root commits specially

Reverse Blame:
  git blame --reverse START..END file.py
    Instead of "who last changed this line",
    shows "when was this line REMOVED or changed next"
    Useful: "when did this line disappear?"
EOF
}

cmd_archaeology() {
    cat << 'EOF'
=== Code Archaeology Techniques ===

Pickaxe Search (-S):
  git log -S "search_string" -- path/
    Find commits that ADD or REMOVE "search_string"
    Looks at the diff: string count changed between commits
    
    Example: "When was this function first introduced?"
    git log -S "def calculate_tax" --oneline -- src/
    
    Example: "When was this import removed?"
    git log -S "import pandas" --oneline -- src/main.py

Regex Search (-G):
  git log -G "regex_pattern" -- path/
    Find commits where the diff MATCHES the regex
    Broader than -S: finds any line change matching pattern
    
    Example: "Any commit changing a database URL"
    git log -G "postgres://.*:5432" --oneline

Following Renames (--follow):
  git log --follow -- current_name.py
    Track history across file renames
    Without --follow: history stops at rename

  git log --follow --diff-filter=R -- current_name.py
    Show only the rename commits

Full History:
  git log --all -S "search" --oneline
    Search ALL branches, not just current
  
  git log --all --source -S "search"
    --source shows which ref led to each commit

Showing Changes:
  git log -p -- file.py           Full patch for each commit
  git log -p -S "string" -- file  Patch only for pickaxe matches
  git log --stat -- file.py       Summary of changes per commit
  git log --follow -p -- file.py  Full history with patches

Combining Techniques:
  "Who introduced this bug and why?"
  1. git blame -w file.py → find the commit hash
  2. git show <hash>      → read the full commit + diff
  3. git log --oneline --graph --ancestry-path <hash>..HEAD
     → see all commits between introduction and now
EOF
}

cmd_bisect() {
    cat << 'EOF'
=== Git Bisect ===

Binary search through commits to find which one introduced a bug.
Tests O(log₂ n) commits instead of O(n).

Basic Workflow:
  git bisect start
  git bisect bad                  # current commit is broken
  git bisect good v1.0            # this tag/commit was working
  
  # Git checks out a middle commit. Test it, then:
  git bisect good                 # if this commit works
  # OR
  git bisect bad                  # if this commit is broken
  
  # Repeat until Git finds the first bad commit
  # "abc1234 is the first bad commit"
  
  git bisect reset                # go back to original HEAD

Automated Bisect:
  git bisect start HEAD v1.0
  git bisect run ./test_script.sh
  
  Script must exit:
    0     = good commit
    1-124 = bad commit (non-zero except 125)
    125   = skip (can't test this commit)

  Example test script:
    #!/bin/bash
    make && ./run_tests 2>/dev/null
    # exit code propagates automatically

Bisect with Terms:
  # Don't like "good/bad"? Use custom terms:
  git bisect start --term-old=fast --term-new=slow
  git bisect slow HEAD
  git bisect fast v2.0
  # Now use: git bisect fast / git bisect slow

Bisect Log & Replay:
  git bisect log > bisect.log     Save your bisect session
  git bisect replay bisect.log    Replay saved session

Skip Commits:
  git bisect skip                 Can't test this one (build broken)
  git bisect skip v2.1..v2.2      Skip a range of untestable commits

Visualize:
  git bisect visualize            Open gitk showing remaining suspects
  git bisect visualize --oneline  Text version

Tips:
  - Bisect is O(log₂ n): 1000 commits → ~10 tests
  - Write automated test scripts when possible
  - Skip broken builds (exit 125)
  - Use stash if you need local changes at each step
  - Works across merge commits (follows first-parent by default)
EOF
}

cmd_ignorerevs() {
    cat << 'EOF'
=== Ignore Revisions for Blame ===

Problem: Formatting/refactoring commits pollute blame output.
A bulk "fix whitespace" commit makes blame show that commit
for hundreds of lines, hiding the real author.

Solution: .git-blame-ignore-revs

Setup:
  1. Create file at repo root:
     # .git-blame-ignore-revs
     # Apply prettier formatting (2024-01-15)
     abc1234def567890abc1234def567890abc1234d
     
     # Convert tabs to spaces project-wide (2024-02-01)  
     def4567890abc1234def4567890abc1234def456
     
     # Rename variables for style guide (2024-03-01)
     890abc1234def4567890abc1234def4567890abc

  2. Configure git to use it automatically:
     git config blame.ignoreRevsFile .git-blame-ignore-revs
     
     # Or globally:
     git config --global blame.ignoreRevsFile .git-blame-ignore-revs

  3. Commit the file to the repo (share with team)

How It Works:
  - When blaming, Git skips listed commits
  - Lines changed ONLY in those commits → attributed to previous commit
  - Lines changed in BOTH listed AND other commits → shows other commit

GitHub Support:
  GitHub automatically uses .git-blame-ignore-revs if present!
  Shows "Ignoring revisions in .git-blame-ignore-revs" banner
  Each ignored commit gets a note in the blame view

Best Practices:
  - Only ignore PURE formatting/mechanical changes
  - Include full 40-char commit hash (not short hash)
  - Add comment above each hash explaining what it was
  - Don't ignore commits that changed logic AND formatting
  - Review with: git diff <hash> — verify it's truly mechanical

Common Candidates to Ignore:
  ✓ Prettier/Black/gofmt formatting runs
  ✓ Tab-to-space or line-ending conversions
  ✓ Copyright header updates
  ✓ Import sorting (isort)
  ✓ Mass rename of a variable/function
  ✗ Refactoring that changed behavior
  ✗ Moving code between files (that's real history)
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Investigation Patterns ===

Pattern 1: "Why does this line exist?"
  git blame -w file.py               → find commit hash
  git show <hash>                     → read commit message + full diff
  git log --oneline <hash>~5..<hash>  → see surrounding commits
  
  Tip: Good commit messages make this instant.
  Bad commit messages ("fix bug") make this painful.

Pattern 2: "When was this function added?"
  git log -S "def calculate_tax" --oneline -- src/
  # Shows the commit that first introduced the string
  git show <first_hit>   → the full addition

Pattern 3: "What did this file look like on date X?"
  git log --until="2024-01-01" -1 --format=%H -- file.py
  git show <hash>:file.py
  
  # Or directly:
  git show $(git rev-list -1 --before="2024-01-01" HEAD):file.py

Pattern 4: "How has this function evolved?"
  git log -L :function_name:file.py
  # Shows every change to the function, with patches
  # Language-aware: understands function boundaries

Pattern 5: "Who deleted this code?"
  git log --diff-filter=D -- path/to/deleted_file.py
  # For deleted lines within a file:
  git log -S "deleted_code_string" --oneline -- file.py

Pattern 6: "What changed between two dates?"
  git log --after="2024-01-01" --before="2024-02-01" -- src/
  git diff HEAD@{2024-01-01}..HEAD@{2024-02-01} -- src/

Pattern 7: "Is this line part of a revert chain?"
  git log --grep="revert" --oneline -- file.py
  git log --all --oneline | grep -i "revert.*<keyword>"

Pattern 8: "Trace through cherry-picks and merges"
  git log --cherry-mark --oneline branch1...branch2
  # = marks equivalent commits, + marks unique ones
EOF
}

cmd_tooling() {
    cat << 'EOF'
=== Blame Tooling ===

VS Code:
  GitLens extension (most popular):
    - Inline blame: shows author/date at end of current line
    - Hover: full commit details on hover
    - Gutter blame: toggleable blame annotations
    - File history view: browse all changes
    - Line history: see every change to current line
    Keybinding: Ctrl+Shift+G B (toggle file blame)
    Command palette: "GitLens: Toggle File Blame"

IntelliJ / JetBrains:
  Built-in "Annotate with Git Blame":
    Right-click gutter → Annotate with Git Blame
    Click annotation → see commit details
    Right-click annotation → "Annotate Previous Revision"
    → Drill through blame history layer by layer
    
    Show Diff: click annotation → "Show Diff"
    Copy Revision: click → Copy Revision Number

GitHub:
  Web blame view: click "Blame" button on file view
  Keyboard shortcut: press 'b' on any file
  Click commit hash → goes to commit
  "View blame prior to this change" → drill deeper
  Supports .git-blame-ignore-revs automatically

tig (terminal UI):
  tig blame file.py        Open blame view
  Press Enter on a line    Show commit
  Press , (comma)           Blame at parent commit (drill deeper)
  Press < / >               Navigate blame history
  Press /                   Search within blame

vim-fugitive:
  :Git blame               Open blame in split
  Press Enter              Show commit in new buffer
  Press o                  Open commit in split
  Press ~ (tilde)          Re-blame at parent commit
  :Glog -- %               File history for current file
  :0Glog                   Commit log for current file

Git GUI Tools:
  gitk:    gitk -- file.py (graphical history)
  git gui blame: git gui blame file.py
  Tower/Fork/Sourcetree: all have integrated blame views
EOF
}

cmd_forensics() {
    cat << 'EOF'
=== Advanced Git Forensics ===

Reflog — Your Safety Net:
  git reflog                     Last 90 days of HEAD movements
  git reflog show branch-name    Reflog for a specific branch
  git reflog --date=iso          With timestamps
  
  "I lost a commit after rebase/reset!"
  git reflog → find the hash → git checkout <hash>
  git branch recovery-branch <hash>

Recover Deleted Branches:
  git reflog | grep "checkout.*deleted-branch"
  git branch restored-branch <hash-before-deletion>

Find Lost Commits:
  git fsck --lost-found --unreachable
  # Dangling commits appear in .git/lost-found/
  git show <dangling-hash>

Merge Archaeology:
  git log --merges --oneline              All merge commits
  git log --merges --first-parent         Only to this branch
  git log --no-merges --oneline           Exclude merges
  git log --ancestry-path A..B            Only commits between A and B
  
  "What branch was this commit originally on?"
  git branch --contains <hash>
  git log --oneline --source --all | grep <short-hash>

File Resurrection:
  # File deleted in commit abc1234:
  git checkout abc1234~1 -- path/to/file.py
  # Or find it:
  git log --all --full-history -- path/to/file.py
  git show <last-commit-with-file>:path/to/file.py > restored.py

Who Changed the Most:
  git shortlog -sn -- path/          Top contributors to a path
  git shortlog -sn --since=1.year    Last year's contributors
  git log --format='%an' -- file | sort | uniq -c | sort -rn

Commit Frequency Analysis:
  git log --format='%ad' --date=format:'%Y-%m' | sort | uniq -c
  # Shows commits per month — spot activity patterns

Blame Statistics:
  git blame --line-porcelain file | grep "^author " | sort | uniq -c | sort -rn
  # Who "owns" the most lines in a file right now

Find All Files a Commit Touched:
  git diff-tree --no-commit-id --name-only -r <hash>
  
Binary File Changes:
  git log --follow --diff-filter=M -- path/to/image.png
  # Track when binary files were modified
EOF
}

show_help() {
    cat << EOF
blame v$VERSION — Git Blame & Code Archaeology Reference

Usage: script.sh <command>

Commands:
  intro        Git blame basics, output format, when to use
  options      Key flags: -L, -C, -M, -w, --ignore-rev
  archaeology  Pickaxe search, --follow, -G regex, history tracing
  bisect       Binary search for bug-introducing commits
  ignorerevs   Setting up .git-blame-ignore-revs
  patterns     Common investigation workflows
  tooling      IDE and tool integration (VS Code, IntelliJ, tig)
  forensics    Reflog, lost commits, merge archaeology, recovery
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    options)     cmd_options ;;
    archaeology) cmd_archaeology ;;
    bisect)      cmd_bisect ;;
    ignorerevs)  cmd_ignorerevs ;;
    patterns)    cmd_patterns ;;
    tooling)     cmd_tooling ;;
    forensics)   cmd_forensics ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "blame v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
