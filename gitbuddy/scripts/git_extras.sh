#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Git Extras — extended git utilities (inspired by tj/git-extras 18K+ stars)
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Git Extras — extended git utilities
Commands:
  summary             Repo summary (commits, authors, files)
  authors             List all authors by commits
  changelog [since]   Generate changelog
  effort [n]          Files with most commits
  fresh-branch <n>    Create branch from clean state
  ignore <pattern>    Add to .gitignore
  undo [n]            Undo last n commits (soft)
  standup [days]      What did I do (default: 1 day)
  stats               Detailed repo statistics
  info                Version info
Powered by BytesAgain | bytesagain.com";;
summary)
    echo "📊 Repo Summary:"
    echo "  Commits: $(git log --oneline 2>/dev/null | wc -l)"
    echo "  Authors: $(git shortlog -sn 2>/dev/null | wc -l)"
    echo "  Files: $(git ls-files 2>/dev/null | wc -l)"
    echo "  Branches: $(git branch -a 2>/dev/null | wc -l)"
    echo "  Tags: $(git tag 2>/dev/null | wc -l)"
    echo "  First commit: $(git log --reverse --format='%ci' 2>/dev/null | head -1)"
    echo "  Last commit: $(git log -1 --format='%ci' 2>/dev/null)"
    echo "  Repo size: $(du -sh .git 2>/dev/null | cut -f1)";;
authors)
    echo "👥 Authors by commits:"
    git shortlog -sn --no-merges 2>/dev/null || echo "Not a git repo";;
changelog)
    since="${1:-$(git describe --tags --abbrev=0 2>/dev/null || echo 'HEAD~20')}"
    echo "# Changelog (since $since)"
    echo ""
    git log "$since..HEAD" --pretty=format:'- %s (%an, %ad)' --date=short 2>/dev/null || echo "No commits";;
effort)
    n="${1:-10}"
    echo "📈 Most Changed Files (top $n):"
    git log --name-only --pretty=format: 2>/dev/null | sort | uniq -c | sort -rn | head -"$n";;
ignore)
    pattern="${1:-}"; [ -z "$pattern" ] && { echo "Usage: ignore <pattern>"; exit 1; }
    echo "$pattern" >> .gitignore
    echo "✅ Added '$pattern' to .gitignore";;
undo)
    n="${1:-1}"
    git reset --soft "HEAD~$n" 2>/dev/null && echo "✅ Undone $n commit(s) (changes preserved)" || echo "❌ Failed";;
standup)
    days="${1:-1}"
    echo "📋 Standup (last $days day(s)):"
    git log --since="$days days ago" --author="$(git config user.name 2>/dev/null)" --pretty=format:'  %h %s (%ar)' 2>/dev/null || echo "No commits";;
fresh-branch)
    name="${1:-}"; [ -z "$name" ] && { echo "Usage: fresh-branch <name>"; exit 1; }
    git checkout --orphan "$name" 2>/dev/null && echo "✅ Created orphan branch: $name" || echo "❌ Failed";;
stats)
    echo "📊 Detailed Stats:"
    echo "  Lines of code: $(git ls-files 2>/dev/null | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}')"
    echo "  Languages:"
    git ls-files 2>/dev/null | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10 | while read c e; do echo "    .$e: $c files"; done
    echo "  Commits/day:"
    git log --format='%ad' --date=short 2>/dev/null | sort | uniq -c | sort -rn | head -5 | while read c d; do echo "    $d: $c commits"; done;;
info) echo "Git Extras v1.0.0"; echo "Inspired by: tj/git-extras (18,000+ stars)"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
