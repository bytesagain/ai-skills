#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys,hashlib
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
IDIOMS=[("画蛇添足","Draw a snake and add feet","Doing something unnecessary"),("守株待兔","Guard a tree stump waiting for rabbits","Waiting for luck instead of working"),("对牛弹琴","Playing music to a cow","Talking to wrong audience"),("班门弄斧","Showing off axe skills at master carpenter door","Being presumptuous"),("杯弓蛇影","Seeing a snake in cup reflection","Being overly suspicious"),("塞翁失马","Old man lost horse","Blessing in disguise"),("狐假虎威","Fox borrows tiger power","Bullying using borrowed authority"),("井底之蛙","Frog at bottom of well","Limited perspective"),("画龙点睛","Paint dragon add eyes","Finishing touch that brings to life"),("亡羊补牢","Fix fence after losing sheep","Better late than never"),("掩耳盗铃","Cover ears to steal bell","Self-deception"),("刻舟求剑","Mark boat to find dropped sword","Rigid thinking"),("叶公好龙","Lord Ye loves dragons","Pretending to like something"),("自相矛盾","Self-contradictory spear and shield","Paradox/contradiction"),("破釜沉舟","Break pots sink boats","Burn bridges, all-in commitment"),("卧薪尝胆","Sleep on straw taste gall","Endure hardship for revenge"),("负荆请罪","Carry thorns to apologize","Sincere apology"),("纸上谈兵","Discuss war on paper","Armchair strategist"),("三顾茅庐","Three visits to thatched cottage","Sincere repeated invitation"),("望梅止渴","Think of plums to quench thirst","Mental comfort")]
if cmd=="search":
    key=inp.strip() if inp else ""
    found=[i for i in IDIOMS if key in i[0] or key.lower() in i[1].lower() or key.lower() in i[2].lower()]
    if not found: print("  No match for: {}. Try a Chinese character or English keyword.".format(key))
    for cn,en,meaning in found:
        print("  {} — {}".format(cn,en))
        print("    Meaning: {}".format(meaning))
        print("")
elif cmd=="random":
    import hashlib
    from datetime import datetime
    seed=int(hashlib.md5(datetime.now().strftime("%Y%m%d%H%M").encode()).hexdigest()[:8],16)
    cn,en,meaning=IDIOMS[seed%len(IDIOMS)]
    print("  {} — {}".format(cn,en))
    print("  {}".format(meaning))
elif cmd=="list":
    for cn,en,meaning in IDIOMS:
        print("  {:8s} {}".format(cn,meaning))
elif cmd=="help":
    print("Idiom Dictionary (20 idioms)\n  search <keyword>  — Search by character or meaning\n  random             — Random idiom\n  list               — List all")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT