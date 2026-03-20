---
version: "2.0.0"
name: cooking-recipe
description: "Manage recipes and grocery lists with ingredient tracking and meal plans. Use when adding recipes, searching by ingredient, or building shopping lists."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# ChefPad — Recipe Manager

A local-first recipe management tool. Add recipes with cuisine and cooking time, build ingredient lists and step-by-step instructions, rate your favorites, search by keyword or ingredient, and get random meal suggestions — all from the command line.

## Commands

| Command | Description |
|---------|-------------|
| `chefpad add <name> [cuisine] [mins]` | Add a new recipe with optional cuisine type and cooking time (default: general, 30min) |
| `chefpad ingredient <id> <text>` | Add an ingredient to an existing recipe by its ID |
| `chefpad step <id> <text>` | Add a cooking step to an existing recipe by its ID |
| `chefpad list` | List all saved recipes with ratings, ingredient and step counts |
| `chefpad show <id>` | Show full recipe details — ingredients, steps, cuisine, time, rating |
| `chefpad search <keyword>` | Search recipes by name, cuisine, or ingredient |
| `chefpad rate <id> <1-5>` | Rate a recipe from 1 to 5 stars |
| `chefpad random` | Get a random recipe suggestion from your collection |
| `chefpad suggest <ingredients...>` | Find recipes that match the ingredients you have on hand |
| `chefpad info` | Show version and branding info |
| `chefpad help` | Show all available commands |

## Data Storage

- **Location:** `~/.chefpad/`
- `recipes.json` — Stores all recipes with their ingredients, steps, ratings, cuisine, and cooking time
- `favorites.json` — Reserved for favorite recipe tracking
- Both files are auto-created as empty JSON arrays on first run
- All data is stored locally as JSON — no external APIs, no network calls, no accounts needed

## Requirements

- bash (any modern version)
- python3 (standard library only — uses `json`, `time`, `random`)
- No external dependencies or API keys required

## When to Use

1. **Building a personal recipe collection** — Add recipes you discover or create, complete with ingredients and step-by-step instructions, all stored locally.
2. **Meal planning with what you have** — Use `suggest` with ingredients in your fridge to find matching recipes from your collection.
3. **Quick dinner decisions** — Use `random` when you can't decide what to cook and want a surprise pick from your saved recipes.
4. **Searching by cuisine or ingredient** — Quickly find all Italian recipes or everything that uses chicken with the `search` command.
5. **Rating and tracking favorites** — Rate recipes after cooking them to build a curated list of your best dishes over time.

## Examples

```bash
# Add a new recipe
chefpad add "Kung Pao Chicken" chinese 25

# Add ingredients to the recipe (use the ID shown after adding)
chefpad ingredient 1710000000 "500g chicken breast, diced"
chefpad ingredient 1710000000 "100g roasted peanuts"
chefpad ingredient 1710000000 "3 dried chili peppers"
chefpad ingredient 1710000000 "2 tbsp soy sauce"

# Add cooking steps
chefpad step 1710000000 "Marinate chicken with soy sauce for 15 minutes"
chefpad step 1710000000 "Stir-fry chicken until golden, set aside"
chefpad step 1710000000 "Fry chili peppers, add chicken and peanuts, toss"

# List all your recipes
chefpad list

# Show full recipe details
chefpad show 1710000000

# Rate a recipe
chefpad rate 1710000000 5

# Search for chicken recipes
chefpad search chicken

# Find recipes matching ingredients you have
chefpad suggest chicken peanuts

# Get a random meal suggestion
chefpad random
```

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
