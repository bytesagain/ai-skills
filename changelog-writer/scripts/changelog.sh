#!/usr/bin/env bash
# Changelog Writer - Generates and manages CHANGELOG.md files
# Usage: changelog.sh <command> [options]
set -euo pipefail

DATE=$(date +"%Y-%m-%d")

show_help() {
  cat <<'EOF'
Changelog Writer - CHANGELOG管理工具

Commands:
  init [--file CHANGELOG.md]
      Create a new CHANGELOG.md with template

  add --version "1.2.0" [--added "..."] [--changed "..."] [--fixed "..."]
      [--removed "..."] [--deprecated "..."] [--security "..."]
      Add a new version entry

  release --version "1.2.0" [--file CHANGELOG.md]
      Move [Unreleased] items into a versioned release

  format --style <keepachangelog|simple|compact>
      Output formatted changelog

  unreleased --added "Feature description"
      Add item to [Unreleased] section

  diff --from "1.0.0" --to "1.1.0" [--file CHANGELOG.md]
      Show changes between two versions

  help
      Show this help message

Options:
  --version     Version number (semver: x.y.z)
  --added       New features (comma-separated for multiple)
  --changed     Changes in existing functionality
  --fixed       Bug fixes
  --removed     Removed features
  --deprecated  Soon-to-be removed features
  --security    Security vulnerability fixes
  --file        Changelog file path (default: CHANGELOG.md)
  --style       Format style (keepachangelog, simple, compact)
  --date        Release date (default: today)

Follows https://keepachangelog.com/en/1.1.0/ and Semantic Versioning.
EOF
}

VERSION=""
ADDED=""
CHANGED=""
FIXED=""
REMOVED=""
DEPRECATED=""
SECURITY=""
FILE="CHANGELOG.md"
STYLE="keepachangelog"
RELEASE_DATE="$DATE"
FROM_VER=""
TO_VER=""

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --version) VERSION="$2"; shift 2 ;;
      --added) ADDED="$2"; shift 2 ;;
      --changed) CHANGED="$2"; shift 2 ;;
      --fixed) FIXED="$2"; shift 2 ;;
      --removed) REMOVED="$2"; shift 2 ;;
      --deprecated) DEPRECATED="$2"; shift 2 ;;
      --security) SECURITY="$2"; shift 2 ;;
      --file) FILE="$2"; shift 2 ;;
      --style) STYLE="$2"; shift 2 ;;
      --date) RELEASE_DATE="$2"; shift 2 ;;
      --from) FROM_VER="$2"; shift 2 ;;
      --to) TO_VER="$2"; shift 2 ;;
      *) shift ;;
    esac
  done
}

init_changelog() {
  parse_args "$@"

  cat <<ENDDOC
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project setup

### Changed

### Fixed

### Removed

### Deprecated

### Security

## [0.1.0] - ${DATE}

### Added
- Initial release
- Project scaffolding and basic structure
- README.md with project description
- License file

---

**How to use this changelog:**

1. Add new entries under \`[Unreleased]\` as you develop
2. When releasing, move unreleased items to a new version section
3. Use semantic versioning (MAJOR.MINOR.PATCH)
4. Keep entries human-readable and meaningful

**Categories:**
- \`Added\` — new features
- \`Changed\` — changes in existing functionality
- \`Deprecated\` — soon-to-be removed features
- \`Removed\` — now removed features
- \`Fixed\` — bug fixes
- \`Security\` — vulnerability fixes
ENDDOC
}

add_version() {
  parse_args "$@"

  if [[ -z "$VERSION" ]]; then
    echo "Error: --version is required"
    echo "Usage: changelog.sh add --version \"1.2.0\" --added \"New feature\" --fixed \"Bug fix\""
    exit 1
  fi

  # Validate semver format (basic check)
  if ! echo "$VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?(\+[a-zA-Z0-9.]+)?$'; then
    echo "Warning: '$VERSION' may not be valid semver (expected format: x.y.z)"
    echo ""
  fi

  echo "## [$VERSION] - ${RELEASE_DATE}"
  echo ""

  if [[ -n "$ADDED" ]]; then
    echo "### Added"
    IFS=',' read -ra items <<< "$ADDED"
    for item in "${items[@]}"; do
      item=$(echo "$item" | xargs)
      echo "- ${item}"
    done
    echo ""
  fi

  if [[ -n "$CHANGED" ]]; then
    echo "### Changed"
    IFS=',' read -ra items <<< "$CHANGED"
    for item in "${items[@]}"; do
      item=$(echo "$item" | xargs)
      echo "- ${item}"
    done
    echo ""
  fi

  if [[ -n "$FIXED" ]]; then
    echo "### Fixed"
    IFS=',' read -ra items <<< "$FIXED"
    for item in "${items[@]}"; do
      item=$(echo "$item" | xargs)
      echo "- ${item}"
    done
    echo ""
  fi

  if [[ -n "$DEPRECATED" ]]; then
    echo "### Deprecated"
    IFS=',' read -ra items <<< "$DEPRECATED"
    for item in "${items[@]}"; do
      item=$(echo "$item" | xargs)
      echo "- ${item}"
    done
    echo ""
  fi

  if [[ -n "$REMOVED" ]]; then
    echo "### Removed"
    IFS=',' read -ra items <<< "$REMOVED"
    for item in "${items[@]}"; do
      item=$(echo "$item" | xargs)
      echo "- ${item}"
    done
    echo ""
  fi

  if [[ -n "$SECURITY" ]]; then
    echo "### Security"
    IFS=',' read -ra items <<< "$SECURITY"
    for item in "${items[@]}"; do
      item=$(echo "$item" | xargs)
      echo "- ${item}"
    done
    echo ""
  fi

  # If nothing was specified, show empty template
  if [[ -z "$ADDED" && -z "$CHANGED" && -z "$FIXED" && -z "$DEPRECATED" && -z "$REMOVED" && -z "$SECURITY" ]]; then
    echo "### Added"
    echo "- (no changes specified)"
    echo ""
  fi
}

format_changelog() {
  parse_args "$@"

  case "$STYLE" in
    keepachangelog)
      echo "# Changelog"
      echo ""
      echo "All notable changes to this project will be documented in this file."
      echo ""
      echo "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),"
      echo "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)."
      echo ""
      echo "## [Unreleased]"
      echo ""

      if [[ -n "$ADDED" || -n "$CHANGED" || -n "$FIXED" ]]; then
        if [[ -n "$ADDED" ]]; then
          echo "### Added"
          IFS=',' read -ra items <<< "$ADDED"
          for item in "${items[@]}"; do
            echo "- $(echo "$item" | xargs)"
          done
          echo ""
        fi
        if [[ -n "$CHANGED" ]]; then
          echo "### Changed"
          IFS=',' read -ra items <<< "$CHANGED"
          for item in "${items[@]}"; do
            echo "- $(echo "$item" | xargs)"
          done
          echo ""
        fi
        if [[ -n "$FIXED" ]]; then
          echo "### Fixed"
          IFS=',' read -ra items <<< "$FIXED"
          for item in "${items[@]}"; do
            echo "- $(echo "$item" | xargs)"
          done
          echo ""
        fi
      fi
      ;;

    simple)
      echo "# Release Notes"
      echo ""
      echo "---"
      echo ""

      if [[ -n "$VERSION" ]]; then
        echo "## v${VERSION} (${RELEASE_DATE})"
        echo ""
        if [[ -n "$ADDED" ]]; then
          echo "**New Features:**"
          IFS=',' read -ra items <<< "$ADDED"
          for item in "${items[@]}"; do
            echo "  • $(echo "$item" | xargs)"
          done
          echo ""
        fi
        if [[ -n "$FIXED" ]]; then
          echo "**Bug Fixes:**"
          IFS=',' read -ra items <<< "$FIXED"
          for item in "${items[@]}"; do
            echo "  • $(echo "$item" | xargs)"
          done
          echo ""
        fi
        if [[ -n "$CHANGED" ]]; then
          echo "**Improvements:**"
          IFS=',' read -ra items <<< "$CHANGED"
          for item in "${items[@]}"; do
            echo "  • $(echo "$item" | xargs)"
          done
          echo ""
        fi
      else
        echo "(Use --version, --added, --fixed, --changed to populate)"
      fi
      ;;

    compact)
      if [[ -n "$VERSION" ]]; then
        local all_items=""
        if [[ -n "$ADDED" ]]; then all_items+="✨ ${ADDED}; "; fi
        if [[ -n "$FIXED" ]]; then all_items+="🐛 ${FIXED}; "; fi
        if [[ -n "$CHANGED" ]]; then all_items+="♻️ ${CHANGED}; "; fi
        if [[ -n "$REMOVED" ]]; then all_items+="🗑️ ${REMOVED}; "; fi
        if [[ -n "$SECURITY" ]]; then all_items+="🔒 ${SECURITY}; "; fi

        echo "## v${VERSION} — ${RELEASE_DATE}"
        echo "${all_items}"
      else
        echo "# Compact Changelog"
        echo ""
        echo "Use: changelog.sh format --style compact --version 1.0.0 --added \"Feature\" --fixed \"Bug\""
      fi
      ;;

    *)
      echo "Error: Unknown style '$STYLE'. Use: keepachangelog, simple, compact"
      exit 1
      ;;
  esac
}

add_unreleased() {
  parse_args "$@"

  echo "## [Unreleased]"
  echo ""

  if [[ -n "$ADDED" ]]; then
    echo "### Added"
    IFS=',' read -ra items <<< "$ADDED"
    for item in "${items[@]}"; do
      echo "- $(echo "$item" | xargs)"
    done
    echo ""
  fi

  if [[ -n "$CHANGED" ]]; then
    echo "### Changed"
    IFS=',' read -ra items <<< "$CHANGED"
    for item in "${items[@]}"; do
      echo "- $(echo "$item" | xargs)"
    done
    echo ""
  fi

  if [[ -n "$FIXED" ]]; then
    echo "### Fixed"
    IFS=',' read -ra items <<< "$FIXED"
    for item in "${items[@]}"; do
      echo "- $(echo "$item" | xargs)"
    done
    echo ""
  fi

  if [[ -n "$SECURITY" ]]; then
    echo "### Security"
    IFS=',' read -ra items <<< "$SECURITY"
    for item in "${items[@]}"; do
      echo "- $(echo "$item" | xargs)"
    done
    echo ""
  fi

  echo "---"
  echo "Tip: Add this content to your CHANGELOG.md under [Unreleased]"
}

show_diff() {
  parse_args "$@"

  if [[ -z "$FROM_VER" || -z "$TO_VER" ]]; then
    echo "Error: --from and --to are required"
    echo "Usage: changelog.sh diff --from 1.0.0 --to 1.1.0 --file CHANGELOG.md"
    exit 1
  fi

  if [[ ! -f "$FILE" ]]; then
    echo "Error: File '$FILE' not found"
    echo ""
    echo "To create one: changelog.sh init > CHANGELOG.md"
    exit 1
  fi

  echo "=== Changes from v${FROM_VER} to v${TO_VER} ==="
  echo "Source: ${FILE}"
  echo ""

  local in_range=false
  local found=false

  while IFS= read -r line; do
    if echo "$line" | grep -qE "^## \[${TO_VER}\]"; then
      in_range=true
      found=true
      echo "$line"
      continue
    fi
    if echo "$line" | grep -qE "^## \[${FROM_VER}\]"; then
      in_range=false
      continue
    fi
    if $in_range; then
      echo "$line"
    fi
  done < "$FILE"

  if ! $found; then
    echo "Version ${TO_VER} not found in ${FILE}"
  fi
}

# Main command router
CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
  init)
    init_changelog "$@"
    ;;
  add)
    add_version "$@"
    ;;
  format)
    format_changelog "$@"
    ;;
  unreleased)
    add_unreleased "$@"
    ;;
  diff)
    show_diff "$@"
    ;;
  help|--help|-h)
    show_help
    ;;
  *)
    echo "Error: Unknown command '$CMD'"
    echo "Run 'changelog.sh help' for usage information."
    exit 1
    ;;
esac
