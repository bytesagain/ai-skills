#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# prototype/scripts/script.sh — Create interactive HTML prototypes
# Version: 3.0.0 | Author: BytesAgain
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Helpers ────────────────────────────────────────────────────────────────

die()  { echo "ERROR: $*" >&2; exit 1; }
info() { echo "▸ $*"; }

write_file() {
  local path="$1"
  shift
  local dir
  dir="$(dirname "$path")"
  mkdir -p "$dir"
  cat > "$path"
  info "Written: $path"
}

# ─── Theme palettes ────────────────────────────────────────────────────────

theme_css() {
  local theme="${1:-light}"
  case "$theme" in
    light)
      cat <<'CSS'
    :root {
      --bg: #ffffff;
      --bg-secondary: #f5f5f5;
      --text: #333333;
      --text-muted: #888888;
      --border: #e0e0e0;
      --primary: #4a90d9;
      --primary-hover: #3a7bc8;
      --accent: #e8f0fe;
    }
CSS
      ;;
    dark)
      cat <<'CSS'
    :root {
      --bg: #1a1a2e;
      --bg-secondary: #16213e;
      --text: #eaeaea;
      --text-muted: #a0a0a0;
      --border: #333355;
      --primary: #6c8fff;
      --primary-hover: #5a7de8;
      --accent: #1a2444;
    }
CSS
      ;;
    warm)
      cat <<'CSS'
    :root {
      --bg: #fdf6ec;
      --bg-secondary: #f5ebe0;
      --text: #3d2c2c;
      --text-muted: #8b7e74;
      --border: #ddd0c0;
      --primary: #c4823a;
      --primary-hover: #a6682e;
      --accent: #f9ecd8;
    }
CSS
      ;;
    *)
      die "Unknown theme: $theme (light|dark|warm)"
      ;;
  esac
}

# ─── Section generators ────────────────────────────────────────────────────

section_nav() {
  local name="${1:-Prototype}"
  cat <<HTML
  <nav style="display:flex;justify-content:space-between;align-items:center;padding:1rem 2rem;background:var(--bg-secondary);border-bottom:1px solid var(--border);">
    <div style="font-size:1.2rem;font-weight:bold;color:var(--text);">${name}</div>
    <div style="display:flex;gap:1.5rem;">
      <a href="#" style="color:var(--text-muted);text-decoration:none;">Home</a>
      <a href="#" style="color:var(--text-muted);text-decoration:none;">About</a>
      <a href="#" style="color:var(--text-muted);text-decoration:none;">Contact</a>
    </div>
  </nav>
HTML
}

section_hero() {
  cat <<'HTML'
  <section style="padding:4rem 2rem;text-align:center;background:var(--accent);">
    <h1 style="font-size:2.5rem;margin-bottom:1rem;color:var(--text);">Hero Headline</h1>
    <p style="font-size:1.1rem;color:var(--text-muted);max-width:600px;margin:0 auto 2rem;">
      A short description of your product or service goes here.
    </p>
    <button style="padding:0.8rem 2rem;background:var(--primary);color:white;border:none;border-radius:6px;font-size:1rem;cursor:pointer;">
      Call to Action
    </button>
  </section>
HTML
}

section_features() {
  cat <<'HTML'
  <section style="padding:3rem 2rem;">
    <h2 style="text-align:center;margin-bottom:2rem;color:var(--text);">Features</h2>
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:1.5rem;max-width:1000px;margin:0 auto;">
      <div style="padding:1.5rem;background:var(--bg-secondary);border-radius:8px;border:1px solid var(--border);">
        <h3 style="color:var(--text);">Feature One</h3>
        <p style="color:var(--text-muted);">Description of this feature.</p>
      </div>
      <div style="padding:1.5rem;background:var(--bg-secondary);border-radius:8px;border:1px solid var(--border);">
        <h3 style="color:var(--text);">Feature Two</h3>
        <p style="color:var(--text-muted);">Description of this feature.</p>
      </div>
      <div style="padding:1.5rem;background:var(--bg-secondary);border-radius:8px;border:1px solid var(--border);">
        <h3 style="color:var(--text);">Feature Three</h3>
        <p style="color:var(--text-muted);">Description of this feature.</p>
      </div>
    </div>
  </section>
HTML
}

section_footer() {
  cat <<'HTML'
  <footer style="padding:2rem;text-align:center;background:var(--bg-secondary);border-top:1px solid var(--border);color:var(--text-muted);">
    <p>&copy; 2025 Prototype. All rights reserved.</p>
  </footer>
HTML
}

section_generic() {
  local name="$1"
  cat <<HTML
  <section style="padding:3rem 2rem;text-align:center;">
    <h2 style="color:var(--text);">${name}</h2>
    <p style="color:var(--text-muted);">Content for ${name} section.</p>
  </section>
HTML
}

# ─── Commands ───────────────────────────────────────────────────────────────

cmd_help() {
  cat <<'EOF'
prototype — Create interactive HTML prototypes

Commands:
  create     Create a new prototype page
  component  Generate a standalone UI component
  animate    Add CSS animation to an element
  link       Wire click navigation between pages
  preview    Show prototype summary
  export     Bundle prototype into single HTML file

Run: bash scripts/script.sh <command> [options]
EOF
}

cmd_create() {
  local name="prototype" sections_str="nav,hero,features,footer" theme="light" output="."
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --name)     name="$2";         shift 2 ;;
      --sections) sections_str="$2"; shift 2 ;;
      --theme)    theme="$2";        shift 2 ;;
      --output)   output="$2";       shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done

  mkdir -p "$output"
  IFS=',' read -ra sections <<< "$sections_str"

  local body=""
  for section in "${sections[@]}"; do
    section="$(echo "$section" | xargs)"
    case "$section" in
      nav|navbar|header) body+="$(section_nav "$name")"$'\n' ;;
      hero)              body+="$(section_hero)"$'\n' ;;
      features)          body+="$(section_features)"$'\n' ;;
      footer)            body+="$(section_footer)"$'\n' ;;
      *)                 body+="$(section_generic "$section")"$'\n' ;;
    esac
  done

  local theme_vars
  theme_vars="$(theme_css "$theme")"

  cat <<HTMLDOC | write_file "${output}/index.html"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${name}</title>
  <style>
${theme_vars}
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: var(--bg);
      color: var(--text);
      line-height: 1.6;
    }
    a { transition: color 0.2s; }
    a:hover { color: var(--primary); }
    button { transition: background 0.2s; }
    button:hover { background: var(--primary-hover) !important; }
  </style>
</head>
<body>
${body}
</body>
</html>
HTMLDOC
}

cmd_component() {
  local type="button" title="" body_text="" actions_str="" output="." variant=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --type)    type="$2";        shift 2 ;;
      --title)   title="$2";       shift 2 ;;
      --body)    body_text="$2";   shift 2 ;;
      --actions) actions_str="$2"; shift 2 ;;
      --output)  output="$2";      shift 2 ;;
      --variant) variant="$2";     shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done

  mkdir -p "$output"
  local html=""

  case "$type" in
    button)
      local label="${title:-Click Me}"
      local bg_color="#4a90d9"
      [[ "$variant" == "secondary" ]] && bg_color="#6c757d"
      [[ "$variant" == "danger" ]]    && bg_color="#dc3545"
      [[ "$variant" == "success" ]]   && bg_color="#28a745"
      html="<button style=\"padding:0.6rem 1.5rem;background:${bg_color};color:white;border:none;border-radius:6px;font-size:1rem;cursor:pointer;transition:opacity 0.2s;\" onmouseover=\"this.style.opacity='0.85'\" onmouseout=\"this.style.opacity='1'\">${label}</button>"
      ;;
    modal)
      title="${title:-Modal Title}"
      body_text="${body_text:-Modal content goes here.}"
      IFS=',' read -ra actions <<< "${actions_str:-cancel,confirm}"
      local action_buttons=""
      for action in "${actions[@]}"; do
        action="$(echo "$action" | xargs)"
        local abg="#4a90d9"
        [[ "$action" == "cancel" || "$action" == "close" ]] && abg="#6c757d"
        action_buttons+="<button style=\"padding:0.5rem 1.2rem;background:${abg};color:white;border:none;border-radius:4px;cursor:pointer;\" onclick=\"this.closest('.modal-overlay').style.display='none'\">${action}</button> "
      done
      html=$(cat <<MODAL
<div class="modal-overlay" style="position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.5);display:flex;justify-content:center;align-items:center;z-index:1000;">
  <div style="background:white;border-radius:12px;padding:0;width:90%;max-width:480px;box-shadow:0 8px 32px rgba(0,0,0,0.2);overflow:hidden;">
    <div style="padding:1.2rem 1.5rem;border-bottom:1px solid #eee;font-size:1.1rem;font-weight:600;">${title}</div>
    <div style="padding:1.5rem;">${body_text}</div>
    <div style="padding:1rem 1.5rem;border-top:1px solid #eee;text-align:right;display:flex;gap:0.5rem;justify-content:flex-end;">
      ${action_buttons}
    </div>
  </div>
</div>
MODAL
      )
      ;;
    card)
      title="${title:-Card Title}"
      body_text="${body_text:-Card description text.}"
      html=$(cat <<CARD
<div style="width:300px;border-radius:12px;overflow:hidden;border:1px solid #e0e0e0;background:white;">
  <div style="height:180px;background:#f0f0f0;display:flex;align-items:center;justify-content:center;color:#aaa;">Image Placeholder</div>
  <div style="padding:1.2rem;">
    <h3 style="margin-bottom:0.5rem;">${title}</h3>
    <p style="color:#666;margin-bottom:1rem;">${body_text}</p>
    <button style="padding:0.5rem 1rem;background:#4a90d9;color:white;border:none;border-radius:6px;cursor:pointer;">Action</button>
  </div>
</div>
CARD
      )
      ;;
    form)
      title="${title:-Form}"
      html=$(cat <<FORM
<form style="width:100%;max-width:400px;padding:2rem;background:white;border-radius:12px;border:1px solid #e0e0e0;" onsubmit="event.preventDefault();alert('Form submitted!');">
  <h3 style="margin-bottom:1.5rem;">${title}</h3>
  <div style="margin-bottom:1rem;">
    <label style="display:block;margin-bottom:0.3rem;font-weight:500;">Email</label>
    <input type="email" style="width:100%;padding:0.6rem;border:1px solid #ddd;border-radius:6px;font-size:1rem;" placeholder="you@example.com">
  </div>
  <div style="margin-bottom:1rem;">
    <label style="display:block;margin-bottom:0.3rem;font-weight:500;">Password</label>
    <input type="password" style="width:100%;padding:0.6rem;border:1px solid #ddd;border-radius:6px;font-size:1rem;" placeholder="••••••">
  </div>
  <button type="submit" style="width:100%;padding:0.7rem;background:#4a90d9;color:white;border:none;border-radius:6px;font-size:1rem;cursor:pointer;">Submit</button>
</form>
FORM
      )
      ;;
    navbar)
      title="${title:-Brand}"
      html=$(cat <<NAV
<nav style="display:flex;justify-content:space-between;align-items:center;padding:1rem 2rem;background:white;border-bottom:1px solid #e0e0e0;">
  <div style="font-size:1.3rem;font-weight:bold;">${title}</div>
  <div style="display:flex;gap:1.5rem;align-items:center;">
    <a href="#" style="color:#666;text-decoration:none;">Home</a>
    <a href="#" style="color:#666;text-decoration:none;">Features</a>
    <a href="#" style="color:#666;text-decoration:none;">Pricing</a>
    <button style="padding:0.5rem 1rem;background:#4a90d9;color:white;border:none;border-radius:6px;cursor:pointer;">Sign Up</button>
  </div>
</nav>
NAV
      )
      ;;
    *)
      die "Unknown component type: $type (button|modal|card|form|navbar)"
      ;;
  esac

  local filename="${type}.html"
  echo "$html" | write_file "${output}/${filename}"
}

cmd_animate() {
  local input="" selector="" animation="fadeIn" duration="0.5s" output=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input)     input="$2";     shift 2 ;;
      --selector)  selector="$2";  shift 2 ;;
      --animation) animation="$2"; shift 2 ;;
      --duration)  duration="$2";  shift 2 ;;
      --output)    output="$2";    shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done
  [[ -n "$input" ]]    || die "Missing --input"
  [[ -f "$input" ]]    || die "File not found: $input"
  [[ -n "$selector" ]] || die "Missing --selector"
  output="${output:-$input}"

  # Define keyframes
  local keyframes=""
  case "$animation" in
    fadeIn)
      keyframes="@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }" ;;
    fadeOut)
      keyframes="@keyframes fadeOut { from { opacity: 1; } to { opacity: 0; } }" ;;
    slideUp)
      keyframes="@keyframes slideUp { from { transform: translateY(30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }" ;;
    slideDown)
      keyframes="@keyframes slideDown { from { transform: translateY(-30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }" ;;
    slideLeft)
      keyframes="@keyframes slideLeft { from { transform: translateX(30px); opacity: 0; } to { transform: translateX(0); opacity: 1; } }" ;;
    slideRight)
      keyframes="@keyframes slideRight { from { transform: translateX(-30px); opacity: 0; } to { transform: translateX(0); opacity: 1; } }" ;;
    bounce)
      keyframes="@keyframes bounce { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-15px); } }" ;;
    pulse)
      keyframes="@keyframes pulse { 0%,100% { transform: scale(1); } 50% { transform: scale(1.05); } }" ;;
    shake)
      keyframes="@keyframes shake { 0%,100% { transform: translateX(0); } 25% { transform: translateX(-5px); } 75% { transform: translateX(5px); } }" ;;
    *)
      die "Unknown animation: $animation (fadeIn|fadeOut|slideUp|slideDown|slideLeft|slideRight|bounce|pulse|shake)"
      ;;
  esac

  local anim_rule="${selector} { animation: ${animation} ${duration} ease both; }"

  # Inject CSS before </head>
  local inject_css="<style>\n    ${keyframes}\n    ${anim_rule}\n  </style>"

  local content
  content="$(cat "$input")"

  if echo "$content" | grep -q '</head>'; then
    content="${content//<\/head>/${inject_css}
<\/head>}"
  else
    # No head tag, prepend
    content="${inject_css}
${content}"
  fi

  echo "$content" > "$output"
  info "Added ${animation} (${duration}) to ${selector} in ${output}"
}

cmd_link() {
  local from="" selector="" to=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --from)     from="$2";     shift 2 ;;
      --selector) selector="$2"; shift 2 ;;
      --to)       to="$2";       shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done
  [[ -n "$from" ]]     || die "Missing --from HTML file"
  [[ -f "$from" ]]     || die "File not found: $from"
  [[ -n "$selector" ]] || die "Missing --selector"
  [[ -n "$to" ]]       || die "Missing --to target page"

  # Add onclick navigation script before </body>
  local nav_script
  nav_script=$(cat <<SCRIPT
<script>
  document.addEventListener('DOMContentLoaded', function() {
    var els = document.querySelectorAll('${selector}');
    els.forEach(function(el) {
      el.style.cursor = 'pointer';
      el.addEventListener('click', function(e) {
        e.preventDefault();
        window.location.href = '${to}';
      });
    });
  });
</script>
SCRIPT
  )

  local content
  content="$(cat "$from")"

  if echo "$content" | grep -q '</body>'; then
    content="${content//<\/body>/${nav_script}
<\/body>}"
  else
    content+=$'\n'"$nav_script"
  fi

  echo "$content" > "$from"
  info "Linked ${selector} in $(basename "$from") → $(basename "$to")"
}

cmd_preview() {
  local input="."
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input) input="$2"; shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done
  [[ -d "$input" ]] || die "Directory not found: $input"

  echo "=== Prototype Preview: $input ==="
  echo ""

  # List HTML pages
  local pages=()
  while IFS= read -r -d '' f; do
    pages+=("$f")
  done < <(find "$input" -name '*.html' -print0 | sort -z)

  echo "Pages (${#pages[@]}):"
  for page in "${pages[@]}"; do
    local rel
    rel="$(realpath --relative-to="$input" "$page" 2>/dev/null || echo "$page")"
    local title
    title="$(grep -oP '<title>\K[^<]+' "$page" 2>/dev/null || echo "(no title)")"
    echo "  • ${rel} — ${title}"
  done

  # Count components
  echo ""
  echo "Components found:"
  local buttons forms links images
  buttons=0; forms=0; links=0; images=0
  for page in "${pages[@]}"; do
    buttons=$(( buttons + $(grep -c '<button' "$page" 2>/dev/null || echo 0) ))
    forms=$(( forms + $(grep -c '<form' "$page" 2>/dev/null || echo 0) ))
    links=$(( links + $(grep -c '<a ' "$page" 2>/dev/null || echo 0) ))
    images=$(( images + $(grep -c '<img' "$page" 2>/dev/null || echo 0) ))
  done
  echo "  Buttons: $buttons"
  echo "  Forms:   $forms"
  echo "  Links:   $links"
  echo "  Images:  $images"

  # Check for navigation links
  echo ""
  echo "Navigation links:"
  for page in "${pages[@]}"; do
    local rel
    rel="$(realpath --relative-to="$input" "$page" 2>/dev/null || echo "$page")"
    local targets
    targets="$(grep -oP "window\.location\.href\s*=\s*'[^']+'" "$page" 2>/dev/null || true)"
    if [[ -n "$targets" ]]; then
      echo "  ${rel}:"
      echo "$targets" | while read -r t; do
        echo "    → $t"
      done
    fi
  done

  # Animations
  echo ""
  echo "Animations:"
  for page in "${pages[@]}"; do
    local anims
    anims="$(grep -oP '@keyframes\s+\w+' "$page" 2>/dev/null || true)"
    if [[ -n "$anims" ]]; then
      local rel
      rel="$(realpath --relative-to="$input" "$page" 2>/dev/null || echo "$page")"
      echo "$anims" | while read -r a; do
        echo "  ${rel}: $a"
      done
    fi
  done
}

cmd_export() {
  local input="." output="prototype-bundle.html" title="Prototype"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --input)  input="$2";  shift 2 ;;
      --output) output="$2"; shift 2 ;;
      --title)  title="$2";  shift 2 ;;
      *) die "Unknown option: $1" ;;
    esac
  done
  [[ -d "$input" ]] || die "Directory not found: $input"

  # Collect all HTML pages
  local pages=()
  while IFS= read -r -d '' f; do
    pages+=("$f")
  done < <(find "$input" -name '*.html' -print0 | sort -z)

  [[ ${#pages[@]} -gt 0 ]] || die "No HTML files found in $input"

  # Build a tabbed single-page bundle
  local tabs_nav=""
  local tabs_content=""
  local idx=0
  for page in "${pages[@]}"; do
    local rel
    rel="$(realpath --relative-to="$input" "$page" 2>/dev/null || basename "$page")"
    local page_title
    page_title="$(grep -oP '<title>\K[^<]+' "$page" 2>/dev/null || echo "$rel")"
    local active=""
    [[ $idx -eq 0 ]] && active=" active"

    tabs_nav+="<button class=\"tab-btn${active}\" onclick=\"showTab(${idx})\">${page_title}</button>"

    # Extract body content
    local body_content
    body_content="$(sed -n '/<body[^>]*>/,/<\/body>/{ /<body[^>]*>/d; /<\/body>/d; p; }' "$page" 2>/dev/null || cat "$page")"

    # Extract styles
    local style_content
    style_content="$(grep -oP '<style>[^<]*</style>' "$page" 2>/dev/null | tr '\n' ' ' || true)"

    local display="none"
    [[ $idx -eq 0 ]] && display="block"

    tabs_content+="<div class=\"tab-page\" id=\"tab-${idx}\" style=\"display:${display}\">${style_content}${body_content}</div>"$'\n'
    (( idx++ ))
  done

  cat <<BUNDLE | write_file "$output"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${title}</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }
    .tab-bar {
      display: flex; gap: 0; background: #f0f0f0;
      border-bottom: 2px solid #ddd; position: sticky; top: 0; z-index: 999;
    }
    .tab-btn {
      padding: 0.8rem 1.5rem; border: none; background: #f0f0f0;
      cursor: pointer; font-size: 0.9rem; border-bottom: 2px solid transparent;
    }
    .tab-btn.active { background: white; border-bottom-color: #4a90d9; font-weight: 600; }
    .tab-page { min-height: 80vh; }
  </style>
</head>
<body>
  <div class="tab-bar">${tabs_nav}</div>
  ${tabs_content}
  <script>
    function showTab(idx) {
      document.querySelectorAll('.tab-page').forEach(function(p,i) {
        p.style.display = i === idx ? 'block' : 'none';
      });
      document.querySelectorAll('.tab-btn').forEach(function(b,i) {
        b.classList.toggle('active', i === idx);
      });
    }
  </script>
</body>
</html>
BUNDLE
}

# ─── Main dispatcher ───────────────────────────────────────────────────────

main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    create)    cmd_create "$@" ;;
    component) cmd_component "$@" ;;
    animate)   cmd_animate "$@" ;;
    link)      cmd_link "$@" ;;
    preview)   cmd_preview "$@" ;;
    export)    cmd_export "$@" ;;
    help|--help|-h) cmd_help ;;
    *) die "Unknown command: $cmd. Run with 'help' for usage." ;;
  esac
}

main "$@"
