#!/bin/bash
# ChefPad - 食谱管理器
# Powered by BytesAgain | bytesagain.com

DATA_DIR="$HOME/.chefpad"
RECIPES_FILE="$DATA_DIR/recipes.json"
FAVORITES_FILE="$DATA_DIR/favorites.json"
mkdir -p "$DATA_DIR"
[ ! -f "$RECIPES_FILE" ] && echo "[]" > "$RECIPES_FILE"
[ ! -f "$FAVORITES_FILE" ] && echo "[]" > "$FAVORITES_FILE"

cmd_add() {
    local name="$1"; shift
    local cuisine="${1:-general}"; shift
    local time_mins="${1:-30}"
    if [ -z "$name" ]; then
        echo "Usage: chefpad add <name> [cuisine] [time_minutes]"
        return 1
    fi
    python3 << PYEOF
import json, time as t
recipe = {"id": int(t.time()), "name": "$name", "cuisine": "$cuisine", "time": int("$time_mins"), "ingredients": [], "steps": [], "rating": 0, "created": t.strftime("%Y-%m-%d")}
try:
    with open("$RECIPES_FILE") as f: data = json.load(f)
except: data = []
data.append(recipe)
with open("$RECIPES_FILE", "w") as f: json.dump(data, f, indent=2)
print("Recipe added: {} ({}, {}min)".format("$name", "$cuisine", "$time_mins"))
PYEOF
}

cmd_ingredient() {
    local recipe_id="$1"; shift
    local ingredient="$*"
    if [ -z "$recipe_id" ] || [ -z "$ingredient" ]; then
        echo "Usage: chefpad ingredient <recipe_id> <ingredient>"
        return 1
    fi
    python3 << PYEOF
import json
try:
    with open("$RECIPES_FILE") as f: data = json.load(f)
except: data = []
for r in data:
    if str(r["id"]) == "$recipe_id":
        r.setdefault("ingredients",[]).append("$ingredient")
        print("Added ingredient: $ingredient")
        break
with open("$RECIPES_FILE", "w") as f: json.dump(data, f, indent=2)
PYEOF
}

cmd_step() {
    local recipe_id="$1"; shift
    local step="$*"
    if [ -z "$recipe_id" ] || [ -z "$step" ]; then
        echo "Usage: chefpad step <recipe_id> <step_description>"
        return 1
    fi
    python3 << PYEOF
import json
try:
    with open("$RECIPES_FILE") as f: data = json.load(f)
except: data = []
for r in data:
    if str(r["id"]) == "$recipe_id":
        r.setdefault("steps",[]).append("$step")
        print("Step {} added".format(len(r["steps"])))
        break
with open("$RECIPES_FILE", "w") as f: json.dump(data, f, indent=2)
PYEOF
}

cmd_list() {
    python3 << PYEOF
import json
try:
    with open("$RECIPES_FILE") as f: data = json.load(f)
except: data = []
if not data:
    print("No recipes yet. Add one: chefpad add <name>")
else:
    print("Your Recipes:")
    print("-" * 50)
    for r in data:
        stars = "⭐" * r.get("rating",0) if r.get("rating",0) > 0 else "(unrated)"
        print("  [{}] {} - {} ({}min) {}".format(r["id"], r["name"], r["cuisine"], r["time"], stars))
        print("      Ingredients: {} | Steps: {}".format(len(r.get("ingredients",[])), len(r.get("steps",[]))))
PYEOF
}

cmd_show() {
    local recipe_id="$1"
    if [ -z "$recipe_id" ]; then
        echo "Usage: chefpad show <recipe_id>"
        return 1
    fi
    python3 << PYEOF
import json
try:
    with open("$RECIPES_FILE") as f: data = json.load(f)
except: data = []
for r in data:
    if str(r["id"]) == "$recipe_id":
        print("=== {} ===".format(r["name"]))
        print("Cuisine: {} | Time: {}min".format(r["cuisine"], r["time"]))
        stars = "⭐" * r.get("rating",0) if r.get("rating",0) > 0 else "(unrated)"
        print("Rating: {}".format(stars))
        print("\nIngredients:")
        for i, ing in enumerate(r.get("ingredients",[]), 1):
            print("  {}. {}".format(i, ing))
        print("\nSteps:")
        for i, s in enumerate(r.get("steps",[]), 1):
            print("  {}. {}".format(i, s))
        break
else:
    print("Recipe not found: $recipe_id")
PYEOF
}

cmd_search() {
    local query="$*"
    if [ -z "$query" ]; then
        echo "Usage: chefpad search <keyword>"
        return 1
    fi
    python3 << PYEOF
import json
try:
    with open("$RECIPES_FILE") as f: data = json.load(f)
except: data = []
q = "$query".lower()
results = [r for r in data if q in r["name"].lower() or q in r["cuisine"].lower() or any(q in i.lower() for i in r.get("ingredients",[]))]
if not results:
    print("No recipes found for: $query")
else:
    print("Found {} recipe(s):".format(len(results)))
    for r in results:
        print("  [{}] {} ({}, {}min)".format(r["id"], r["name"], r["cuisine"], r["time"]))
PYEOF
}

cmd_rate() {
    local recipe_id="$1"
    local rating="$2"
    if [ -z "$recipe_id" ] || [ -z "$rating" ]; then
        echo "Usage: chefpad rate <recipe_id> <1-5>"
        return 1
    fi
    if ! [[ "$rating" =~ ^[1-5]$ ]]; then
        echo "Rating must be 1-5"
        return 1
    fi
    python3 << PYEOF
import json
try:
    with open("$RECIPES_FILE") as f: data = json.load(f)
except: data = []
for r in data:
    if str(r["id"]) == "$recipe_id":
        r["rating"] = int("$rating")
        print("Rated {} as {}".format(r["name"], "⭐" * int("$rating")))
        break
with open("$RECIPES_FILE", "w") as f: json.dump(data, f, indent=2)
PYEOF
}

cmd_random() {
    python3 << PYEOF
import json, random
try:
    with open("$RECIPES_FILE") as f: data = json.load(f)
except: data = []
if not data:
    print("No recipes yet!")
else:
    r = random.choice(data)
    print("How about: {} ({}, {}min)?".format(r["name"], r["cuisine"], r["time"]))
PYEOF
}

cmd_suggest() {
    local ingredients="$*"
    if [ -z "$ingredients" ]; then
        echo "Usage: chefpad suggest <ingredient1> <ingredient2> ..."
        return 1
    fi
    python3 << PYEOF
import json
try:
    with open("$RECIPES_FILE") as f: data = json.load(f)
except: data = []
query_ings = "$ingredients".lower().split()
results = []
for r in data:
    recipe_ings = " ".join(r.get("ingredients",[])).lower()
    matches = sum(1 for q in query_ings if q in recipe_ings)
    if matches > 0:
        results.append((matches, r))
results.sort(key=lambda x: -x[0])
if not results:
    print("No matching recipes. Try adding more recipes first!")
else:
    print("Recipes matching your ingredients:")
    for score, r in results[:5]:
        print("  [{}] {} ({} ingredient match)".format(r["id"], r["name"], score))
PYEOF
}

cmd_info() {
    echo "ChefPad v1.0.0"
    echo "Powered by BytesAgain | bytesagain.com"
}

cmd_help() {
    echo "ChefPad - Recipe Manager"
    echo "Usage: chefpad <command> [arguments]"
    echo ""
    echo "Commands:"
    echo "  add <name> [cuisine] [mins]   Add a recipe"
    echo "  ingredient <id> <text>        Add ingredient to recipe"
    echo "  step <id> <text>              Add cooking step"
    echo "  list                          List all recipes"
    echo "  show <id>                     Show recipe details"
    echo "  search <keyword>              Search recipes"
    echo "  rate <id> <1-5>               Rate a recipe"
    echo "  random                        Get random recipe suggestion"
    echo "  suggest <ingredients...>      Find recipes by ingredients"
    echo "  info                          Version info"
    echo "  help                          Show this help"
}

case "$1" in
    add) shift; cmd_add "$@";;
    ingredient) shift; cmd_ingredient "$@";;
    step) shift; cmd_step "$@";;
    list) cmd_list;;
    show) shift; cmd_show "$@";;
    search) shift; cmd_search "$@";;
    rate) shift; cmd_rate "$@";;
    random) cmd_random;;
    suggest) shift; cmd_suggest "$@";;
    info) cmd_info;;
    help|"") cmd_help;;
    *) echo "Unknown command: $1"; cmd_help; exit 1;;
esac
