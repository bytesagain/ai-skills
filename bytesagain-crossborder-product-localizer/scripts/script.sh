#!/usr/bin/env bash
set -euo pipefail
VERSION="1.0.0"
SKILL_NAME="BytesAgain Crossborder Product Localizer"
FOCUS="localize"

err(){ printf 'Error: %s\n' "$*" >&2; }
slugify(){ printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]+/-/g;s/^-//;s/-$//'; }
trim(){ sed 's/^ *//;s/ *$//'; }
split_csv(){ printf '%s' "$1" | tr ',' '\n' | trim | sed '/^$/d'; }

PRODUCT=""; CHANNEL="marketplace"; AUDIENCE="buyers"; FEATURES=""; KEYWORDS=""; PRICE=""; TONE="clear"; LANG="en"; INPUT=""; TARGET="US"; LENGTH="medium"
parse_opts(){
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --product) PRODUCT="${2:-}"; shift 2;;
      --channel) CHANNEL="${2:-}"; shift 2;;
      --audience) AUDIENCE="${2:-}"; shift 2;;
      --features) FEATURES="${2:-}"; shift 2;;
      --keywords) KEYWORDS="${2:-}"; shift 2;;
      --price) PRICE="${2:-}"; shift 2;;
      --tone) TONE="${2:-}"; shift 2;;
      --lang) LANG="${2:-}"; shift 2;;
      --input) INPUT="${2:-}"; shift 2;;
      --target) TARGET="${2:-}"; shift 2;;
      --length) LENGTH="${2:-}"; shift 2;;
      *) if [[ "$1" == --* ]]; then err "unknown option: $1"; return 1; else INPUT="$1"; shift; fi;;
    esac
  done
  [ -n "$PRODUCT" ] || PRODUCT="wireless desk lamp"
  [ -n "$FEATURES" ] || FEATURES="adjustable brightness, USB-C charging, foldable arm, eye comfort"
  [ -n "$KEYWORDS" ] || KEYWORDS="desk lamp, study light, home office"
}

channel_style(){
  case "$(printf '%s' "$CHANNEL" | tr '[:upper:]' '[:lower:]')" in
    amazon*) echo "Amazon: concise title, five scannable bullets, searchable attributes, claim-safe wording";;
    shopify*) echo "Shopify/independent site: brand story, benefit blocks, FAQ, trust cues, SEO metadata";;
    taobao*|taotao*) echo "Taobao: benefit-led Chinese title, scenario keywords, promo-friendly bullets";;
    pinduoduo*) echo "Pinduoduo: price-value framing, group-buy angle, direct feature proof";;
    tiktok*|tk*) echo "TikTok Shop: hook first, demo sequence, social proof, short CTA";;
    *) echo "Marketplace: clear title, benefits, specs, search terms, buyer objections";;
  esac
}

print_brief(){
  echo "# $SKILL_NAME Brief"
  echo "Product: $PRODUCT"
  echo "Channel: $CHANNEL"
  echo "Audience: $AUDIENCE"
  echo "Tone: $TONE"
  [ -n "$PRICE" ] && echo "Price: $PRICE"
  echo "Style: $(channel_style)"
  echo
  echo "## Core Features"
  split_csv "$FEATURES" | awk '{print "- " $0}'
  echo
  echo "## Search Terms"
  split_csv "$KEYWORDS" | awk '{print "- " $0}'
  echo
  echo "## Buyer Promise"
  echo "Help $AUDIENCE understand what $PRODUCT does, why it is credible, and when to buy it."
}

make_title(){
  local base="$PRODUCT"
  local kw; kw=$(split_csv "$KEYWORDS" | head -1)
  case "$(printf '%s' "$CHANNEL" | tr '[:upper:]' '[:lower:]')" in
    amazon*) echo "$base, $kw for Home Office, Adjustable and Gift Ready";;
    shopify*) echo "$base for Focused Work and Better Desk Lighting";;
    taobao*|taotao*) echo "$base 办公学习护眼灯 多档调光 桌面宿舍适用";;
    pinduoduo*) echo "$base 高性价比护眼台灯 学生办公可折叠";;
    tiktok*|tk*) echo "This $base fixes the messy desk lighting problem";;
    *) echo "$base - $kw with Practical Everyday Benefits";;
  esac
}

cmd_brief(){ parse_opts "$@"; print_brief; }
cmd_title(){ parse_opts "$@"; echo "# Title Options"; for i in 1 2 3 4 5; do echo "$i. $(make_title) - Option $i"; done; }
cmd_bullets(){
  parse_opts "$@"; echo "# Listing Bullets for $PRODUCT"; i=1
  split_csv "$FEATURES" | while read -r f; do
    echo "$i. $f: explain the concrete buyer benefit, include one proof point, avoid unsupported medical or guaranteed-result claims."
    i=$((i+1))
  done
  echo
  echo "## Attribute Hints"
  echo "- Material: fill from source facts"
  echo "- Size: include exact dimensions when available"
  echo "- Compatibility: state only verified devices or use cases"
  echo "- Package: list what buyers receive"
}
cmd_compare(){
  parse_opts "$@"; echo "# Channel Comparison for $PRODUCT"
  for c in Amazon Shopify Taobao Pinduoduo TikTokShop IndependentSite; do
    CHANNEL="$c"; echo "## $c"; echo "Title: $(make_title)"; echo "Style: $(channel_style)"; echo
  done
}
cmd_audit(){
  parse_opts "$@"; echo "# Audit Checklist"
  local score=100
  [ -n "$PRODUCT" ] || score=$((score-15))
  [ -n "$FEATURES" ] || score=$((score-20))
  [ -n "$KEYWORDS" ] || score=$((score-15))
  echo "Score: $score/100"
  echo "- Title includes product type and primary keyword"
  echo "- Bullets connect each feature to a buyer benefit"
  echo "- Claims are specific and supportable"
  echo "- Specs include size, material, compatibility, and package contents"
  echo "- CTA matches channel norms"
}
cmd_pdp(){ parse_opts "$@"; echo "# Product Detail Page"; print_brief; echo "## Sections"; echo "- Hero: $(make_title)"; echo "- Benefits grid from features"; echo "- How it works"; echo "- Reviews and trust badges"; echo "- FAQ and shipping notes"; }
cmd_seo(){ parse_opts "$@"; echo "SEO Title: $(make_title) | BytesAgain"; echo "Meta Description: Shop $PRODUCT for $AUDIENCE. Features include $(split_csv "$FEATURES" | paste -sd ', ' -)."; echo "URL Slug: $(slugify "$PRODUCT-$CHANNEL")"; }
cmd_faq(){ parse_opts "$@"; echo "# FAQ"; echo "- Who is this for? $AUDIENCE."; echo "- What problem does it solve? It addresses the main buying need behind $PRODUCT."; echo "- What should buyers check before ordering? Size, compatibility, shipping, and warranty."; echo "- What is included? List package contents from source facts."; }
cmd_hook(){ parse_opts "$@"; echo "# Hooks"; echo "1. Stop buying $PRODUCT before checking this one thing."; echo "2. If your desk setup feels wrong, this may be why."; echo "3. I tested this $PRODUCT for seven common buyer questions."; }
cmd_script(){ parse_opts "$@"; echo "# Short Video Script"; echo "0-3s: Hook with the buyer pain."; echo "3-12s: Show $PRODUCT in use."; echo "12-25s: Demonstrate top features: $FEATURES."; echo "25-35s: Compare before/after."; echo "35-45s: CTA: comment with your use case or visit product page."; }
cmd_live(){ parse_opts "$@"; echo "# Livestream Cues"; echo "- Open with use case and price anchor."; echo "- Demo one feature every 2 minutes."; echo "- Repeat shipping, guarantee, and bundle details."; echo "- Ask viewers to comment their scenario."; }
cmd_caption(){ parse_opts "$@"; echo "# Captions"; echo "- Testing a $PRODUCT for real desk setups. Would you use this?"; echo "- Three details most listings forget to explain."; echo "- Save this before you compare similar products."; }
cmd_keywords(){ parse_opts "$@"; echo "# Keyword Clusters"; for k in $(split_csv "$KEYWORDS"); do echo "## $k"; echo "- $k review"; echo "- best $k for $AUDIENCE"; echo "- $k price"; echo "- $k alternative"; done; }
cmd_rewrite(){ parse_opts "$@"; echo "# Rewritten Copy"; echo "$(make_title)"; echo; cmd_bullets --product "$PRODUCT" --features "$FEATURES" --keywords "$KEYWORDS" --channel "$CHANNEL"; }
cmd_category(){ parse_opts "$@"; echo "# Category Copy"; echo "$PRODUCT options help $AUDIENCE compare features, price, materials, and use cases before buying."; echo "Choose by primary scenario, required specs, and after-sales expectations."; }
cmd_calendar(){ parse_opts "$@"; echo "# 14-Day Ecommerce SEO Plan"; for i in $(seq 1 14); do echo "Day $i: publish one keyword-focused asset around $PRODUCT and validate search intent."; done; }
cmd_map(){ parse_opts "$@"; print_brief; echo "## Field Map"; echo "- Source facts -> title, bullets, specs, FAQ, search terms"; echo "- Target market -> tone, units, objections, compliance notes"; }
cmd_localize(){ parse_opts "$@"; echo "# Localized Copy ($TARGET, $LANG)"; echo "Title: $(make_title)"; echo "Tone: adapt to $TARGET buyer expectations; preserve factual specs."; cmd_bullets --product "$PRODUCT" --features "$FEATURES" --keywords "$KEYWORDS" --channel "$CHANNEL"; }
cmd_tone(){ parse_opts "$@"; echo "# Tone Variants"; for t in premium value technical social; do echo "## $t"; TONE="$t"; echo "$(make_title)"; done; }
cmd_compliance(){ parse_opts "$@"; echo "# Claim Safety Check"; echo "- Avoid guaranteed income, medical claims, fake scarcity, and unsupported comparisons."; echo "- Keep dimensions, materials, certifications, and compatibility factual."; echo "- Add marketplace-specific disclaimers when needed."; }
cmd_bundle(){ parse_opts "$@"; echo "# Multi-Channel Bundle"; cmd_title --product "$PRODUCT" --features "$FEATURES" --keywords "$KEYWORDS" --channel Amazon; cmd_seo --product "$PRODUCT" --features "$FEATURES" --keywords "$KEYWORDS" --channel Shopify; cmd_script --product "$PRODUCT" --features "$FEATURES" --keywords "$KEYWORDS" --channel TikTok; }
cmd_demo(){ parse_opts --product "portable blender" --channel "Amazon" --audience "busy commuters" --features "USB-C charging, 400ml cup, stainless blades, easy cleaning" --keywords "portable blender, smoothie maker, travel blender"; print_brief; echo; cmd_title; echo; cmd_bullets; echo; cmd_audit; }
usage(){ cat <<EOF
$SKILL_NAME v$VERSION
Commands: map localize tone compliance bundle demo help version
Common options: --product TEXT --channel NAME --features CSV --keywords CSV --audience TEXT --target MARKET --lang CODE
EOF
}
case "${1:-help}" in
  map) shift; cmd_map "$@";;
  localize) shift; cmd_localize "$@";;
  tone) shift; cmd_tone "$@";;
  compliance) shift; cmd_compliance "$@";;
  bundle) shift; cmd_bundle "$@";;
  demo) shift; cmd_demo "$@";;
  help|-h|--help) usage;;
  version) echo "$VERSION";;
  *) err "unknown command: $1"; usage; exit 1;;
esac
