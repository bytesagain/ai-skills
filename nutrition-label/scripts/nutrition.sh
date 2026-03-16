#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
RDV={"calories":2000,"fat":78,"saturated_fat":20,"cholesterol":300,"sodium":2300,"carbs":275,"fiber":28,"sugar":50,"protein":50,"vitamin_d":20,"calcium":1300,"iron":18,"potassium":4700}
if cmd=="calculate":
    parts=inp.split() if inp else []
    if len(parts)<4:
        print("  Usage: calculate <calories> <fat_g> <carbs_g> <protein_g>")
        print("  Example: calculate 250 8 35 12")
    else:
        cal,fat,carb,prot=float(parts[0]),float(parts[1]),float(parts[2]),float(parts[3])
        print("  Nutrition Facts")
        print("  "+"-"*30)
        print("  Calories         {:>10.0f}".format(cal))
        print("  "+"-"*30)
        print("  Total Fat        {:>8.0f}g  {:>3.0f}%".format(fat,fat/RDV["fat"]*100))
        print("  Total Carbs      {:>8.0f}g  {:>3.0f}%".format(carb,carb/RDV["carbs"]*100))
        print("  Protein          {:>8.0f}g  {:>3.0f}%".format(prot,prot/RDV["protein"]*100))
        print("  "+"-"*30)
        print("  Calorie breakdown:")
        total_cal=fat*9+carb*4+prot*4
        if total_cal>0:
            print("    Fat:     {:.0f}% ({:.0f} cal)".format(fat*9/total_cal*100,fat*9))
            print("    Carbs:   {:.0f}% ({:.0f} cal)".format(carb*4/total_cal*100,carb*4))
            print("    Protein: {:.0f}% ({:.0f} cal)".format(prot*4/total_cal*100,prot*4))
elif cmd=="rdv":
    print("  Recommended Daily Values:")
    for k,v in RDV.items():
        unit="g" if k not in ["calories","vitamin_d","calcium","iron","potassium"] else ("mg" if k in ["cholesterol","sodium","calcium","iron","potassium"] else ("mcg" if k=="vitamin_d" else "cal"))
        print("    {:15s} {:>6} {}".format(k,v,unit))
elif cmd=="help":
    print("Nutrition Label\n  calculate <cal> <fat> <carb> <prot>  — Nutrition analysis\n  rdv                                  — Daily value reference")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT