#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# cz-cli — commitizen-style commit message generator (inspired by 17K+ stars)
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Commitizen — conventional commit helper
Commands:
  commit [type]       Generate commit message
  types               Show commit types
  changelog           Generate changelog from commits
  validate <msg>      Validate commit message format
  lint                Lint recent commits
  breaking            List breaking changes
  scope <msg>         Add scope to commit
  info                Version info
Powered by BytesAgain | bytesagain.com";;
commit)
    type="${1:-feat}"; scope="${2:-}"; desc="${3:-update}"
    msg="$type"
    [ -n "$scope" ] && msg="${msg}(${scope})"
    msg="${msg}: ${desc}"
    echo "📝 Commit message:"
    echo "  $msg"
    echo ""
    echo "Copy and run:"
    echo "  git commit -m \"$msg\"";;
types) cat << 'EOF'
📋 Conventional Commit Types:
  feat:     ✨ New feature
  fix:      🐛 Bug fix
  docs:     📝 Documentation
  style:    💄 Code style (no logic change)
  refactor: ♻️  Code refactor
  perf:     ⚡ Performance
  test:     ✅ Tests
  build:    📦 Build system
  ci:       🔧 CI/CD
  chore:    🔨 Maintenance
  revert:   ⏪ Revert
EOF
;;
changelog)
    echo "# Changelog"; echo ""
    prev_type=""
    git log --pretty=format:'%s' 2>/dev/null | while IFS= read -r msg; do
        if echo "$msg" | grep -qE '^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)'; then
            type=$(echo "$msg" | grep -oE '^[a-z]+')
            if [ "$type" != "$prev_type" ]; then
                echo ""; echo "### ${type^}"
                prev_type="$type"
            fi
            echo "- $msg"
        fi
    done;;
validate)
    msg="${1:-}"
    [ -z "$msg" ] && { echo "Usage: validate <message>"; exit 1; }
    if echo "$msg" | grep -qE '^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?: .+'; then
        echo "✅ Valid: $msg"
    else
        echo "❌ Invalid: $msg"
        echo "  Expected: type(scope): description"
        echo "  Example: feat(auth): add login page"
    fi;;
lint)
    echo "🔍 Linting recent commits:"
    git log -10 --pretty=format:'%s' 2>/dev/null | while IFS= read -r msg; do
        if echo "$msg" | grep -qE '^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)'; then
            echo "  ✅ $msg"
        else
            echo "  ❌ $msg"
        fi
    done;;
breaking)
    echo "⚠ Breaking Changes:"
    git log --pretty=format:'%s%n%b' 2>/dev/null | grep -i "BREAKING CHANGE\|!" | head -10
    [ $? -ne 0 ] && echo "  None found";;
scope)
    msg="${1:-feat: update}"; scope="${2:-core}"
    new=$(echo "$msg" | sed "s/: /($scope): /")
    echo "📝 With scope: $new";;
info) echo "Commitizen v1.0.0"; echo "Inspired by: cz-cli (17,000+ stars)"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
