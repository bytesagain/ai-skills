#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys,hashlib
from datetime import datetime
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
MEALS={"breakfast":["Oatmeal + berries + nuts","Eggs + toast + avocado","Yogurt + granola + fruit","Smoothie bowl","Pancakes + banana"],"lunch":["Chicken salad wrap","Rice + stir-fry vegetables","Pasta with tomato sauce","Soup + bread","Burrito bowl"],"dinner":["Grilled salmon + vegetables","Steak + mashed potatoes","Stir-fry tofu + rice","Pizza (homemade)","Curry + naan bread"]}
DAYS=["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
if cmd=="weekly":
    seed=int(hashlib.md5(datetime.now().strftime("%Y%W").encode()).hexdigest()[:8],16)
    print("  Weekly Meal Plan")
    print("  {:10s} {:25s} {:25s} {:25s}".format("Day","Breakfast","Lunch","Dinner"))
    print("  "+"-"*88)
    for i,day in enumerate(DAYS):
        b=MEALS["breakfast"][(seed+i)%len(MEALS["breakfast"])]
        l=MEALS["lunch"][(seed+i+3)%len(MEALS["lunch"])]
        d=MEALS["dinner"][(seed+i+7)%len(MEALS["dinner"])]
        print("  {:10s} {:25s} {:25s} {:25s}".format(day,b,l,d))
elif cmd=="calories":
    target=int(inp) if inp and inp.isdigit() else 2000
    print("  Daily Calorie Split ({} cal):".format(target))
    print("    Breakfast: {} cal (25%)".format(int(target*0.25)))
    print("    Lunch:     {} cal (35%)".format(int(target*0.35)))
    print("    Dinner:    {} cal (30%)".format(int(target*0.30)))
    print("    Snacks:    {} cal (10%)".format(int(target*0.10)))
    print("  Macros (balanced):")
    print("    Protein: {}g (30%)".format(int(target*0.30/4)))
    print("    Carbs:   {}g (40%)".format(int(target*0.40/4)))
    print("    Fat:     {}g (30%)".format(int(target*0.30/9)))
elif cmd=="grocery":
    print("  Basic Grocery List:")
    for cat,items in [("Protein",["Chicken breast","Eggs","Salmon","Tofu","Greek yogurt"]),("Carbs",["Rice","Pasta","Bread","Oats","Sweet potato"]),("Vegetables",["Broccoli","Spinach","Bell peppers","Onions","Tomatoes"]),("Fruit",["Bananas","Berries","Apples","Avocado"]),("Pantry",["Olive oil","Soy sauce","Salt/pepper","Garlic","Honey"])]:
        print("  {}:".format(cat))
        for i in items: print("    [ ] {}".format(i))
        print("")
elif cmd=="help":
    print("Meal Planner\n  weekly          — 7-day meal plan\n  calories [cal]  — Daily calorie split\n  grocery         — Basic grocery list")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT