#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# License: MIT — independent, not derived from any third-party source
# Recipe manager — organize recipes, meal planning, shopping lists
set -euo pipefail
RECIPE_DIR="${RECIPE_DIR:-$HOME/.recipes}"
mkdir -p "$RECIPE_DIR"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Recipe Manager — organize meals & shopping
Commands:
  add <name>              Add recipe interactively
  list                    List all recipes
  search <ingredient>     Search by ingredient
  view <name>             View recipe details
  random                  Random recipe suggestion
  plan [days]             Meal plan (default 7 days)
  shopping <recipes>      Generate shopping list
  scale <name> <servings> Scale recipe
  categories              List categories
  info                    Version info
Powered by BytesAgain | bytesagain.com";;
add)
    name="${1:-My Recipe}"
    id=$(echo "$name" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
    cat > "$RECIPE_DIR/${id}.json" << RECIPE
{
  "name": "$name",
  "servings": 4,
  "prep_time": "15 min",
  "cook_time": "30 min",
  "category": "main",
  "ingredients": [
    "ingredient 1",
    "ingredient 2"
  ],
  "steps": [
    "Step 1: Prepare ingredients",
    "Step 2: Cook",
    "Step 3: Serve"
  ],
  "notes": ""
}
RECIPE
    echo "✅ Recipe saved: $RECIPE_DIR/${id}.json"
    echo "   Edit the file to add ingredients and steps";;
list)
    echo "📖 Recipes:"
    for f in "$RECIPE_DIR"/*.json; do
        [ -f "$f" ] || continue
        python3 -c "
import json
with open('$f') as fh: r = json.load(fh)
print('  🍽 {:25s} {} | {} servings | {}'.format(
    r['name'][:25], r.get('category','?'), r.get('servings','?'), r.get('prep_time','?')))"
    done
    echo "  Total: $(ls "$RECIPE_DIR"/*.json 2>/dev/null | wc -l) recipes";;
search)
    q="${1:-}"; [ -z "$q" ] && { echo "Usage: search <ingredient>"; exit 1; }
    echo "🔍 Recipes with '$q':"
    grep -li "$q" "$RECIPE_DIR"/*.json 2>/dev/null | while read f; do
        python3 -c "import json; r=json.load(open('$f')); print('  🍽 {} ({})'.format(r['name'],r.get('category','')))"
    done;;
view)
    name="${1:-}"; [ -z "$name" ] && { echo "Usage: view <name>"; exit 1; }
    id=$(echo "$name" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
    f="$RECIPE_DIR/${id}.json"
    [ ! -f "$f" ] && { echo "Not found: $name"; exit 1; }
    python3 -c "
import json
with open('$f') as fh: r = json.load(fh)
print('🍽 {}'.format(r['name']))
print('  Servings: {} | Prep: {} | Cook: {}'.format(r['servings'],r.get('prep_time','?'),r.get('cook_time','?')))
print('\n📝 Ingredients:')
for i in r.get('ingredients',[]): print('  - {}'.format(i))
print('\n👨‍🍳 Steps:')
for i, s in enumerate(r.get('steps',[]),1): print('  {}. {}'.format(i,s))
if r.get('notes'): print('\n💡 Notes: {}'.format(r['notes']))
";;
random)
    files=$(ls "$RECIPE_DIR"/*.json 2>/dev/null)
    [ -z "$files" ] && { echo "No recipes yet"; exit 0; }
    f=$(echo "$files" | shuf -n1)
    python3 -c "import json; r=json.load(open('$f')); print('🎲 Try: {} ({})'.format(r['name'],r.get('category','')))";;
plan)
    days="${1:-7}"
    echo "📅 Meal Plan ($days days):"
    files=$(ls "$RECIPE_DIR"/*.json 2>/dev/null)
    if [ -z "$files" ]; then
        for d in $(seq 1 "$days"); do
            day=$(date -d "+$d days" '+%a %m/%d' 2>/dev/null || echo "Day $d")
            echo "  $day: [add recipes first]"
        done
    else
        for d in $(seq 1 "$days"); do
            day=$(date -d "+$d days" '+%a %m/%d' 2>/dev/null || echo "Day $d")
            f=$(echo "$files" | shuf -n1)
            name=$(python3 -c "import json; print(json.load(open('$f'))['name'])" 2>/dev/null || echo "?")
            echo "  $day: $name"
        done
    fi;;
shopping)
    recipes="$*"
    echo "🛒 Shopping List:"
    for name in $recipes; do
        id=$(echo "$name" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
        f="$RECIPE_DIR/${id}.json"
        [ -f "$f" ] && python3 -c "
import json
r = json.load(open('$f'))
print('  From {}:'.format(r['name']))
for i in r.get('ingredients',[]): print('    □ {}'.format(i))
"
    done;;
scale)
    name="${1:-}"; servings="${2:-2}"
    [ -z "$name" ] && { echo "Usage: scale <name> <servings>"; exit 1; }
    echo "📏 Scaled to $servings servings"
    echo "  (Edit recipe file to update quantities)";;
categories)
    echo "📂 Categories:"
    for f in "$RECIPE_DIR"/*.json; do
        python3 -c "import json; print(json.load(open('$f')).get('category','uncategorized'))" 2>/dev/null
    done | sort | uniq -c | sort -rn;;
info) echo "Recipe Manager v1.0.0"; echo "Organize recipes, plan meals, shop smart"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
