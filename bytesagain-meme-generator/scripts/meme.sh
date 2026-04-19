#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 -c '
import sys,hashlib
from datetime import datetime
cmd=sys.argv[1] if len(sys.argv)>1 else "help"
inp=" ".join(sys.argv[2:])
FORMATS=[("Drake","Top: Thing you dislike\nBottom: Thing you prefer"),("Distracted Boyfriend","Boyfriend: You\nGirlfriend: What you should do\nOther: What you actually do"),("Change My Mind","[Your controversial opinion]. Change my mind."),("This is Fine","Everything is on fire but [situation] is fine"),("Always Has Been","Wait, it is all [thing]?\nAlways has been."),("Expanding Brain","Small brain: [basic]\nMedium: [better]\nGalaxy: [absurd genius]"),("One Does Not Simply","One does not simply [difficult task]"),("Surprised Pikachu","[Does obvious thing]\n[Obvious consequence happens]\n:O")]
if cmd=="template":
    if inp and inp.isdigit():
        idx=int(inp)-1
        if 0<=idx<len(FORMATS):
            name,fmt=FORMATS[idx]
            print("  {}".format(name))
            print("  "+fmt.replace("\n","\n  "))
    else:
        print("  Meme Templates:")
        for i,(name,_) in enumerate(FORMATS,1):
            print("  {}. {}".format(i,name))
        print("\n  Usage: template <number>")
elif cmd=="generate":
    topic=inp if inp else "programming"
    seed=int(hashlib.md5(topic.encode()).hexdigest()[:8],16)
    idx=seed%len(FORMATS)
    name,fmt=FORMATS[idx]
    print("  Meme for: {}".format(topic))
    print("  Format: {}".format(name))
    print("  ---")
    print("  Fill in:")
    print("  "+fmt.replace("\n","\n  "))
elif cmd=="caption":
    captions=["Nobody:\nAbsolutely nobody:\nMe: {}".format(inp),"Me: I should sleep early\nAlso me at 3am: {}".format(inp),"Expectation: productive day\nReality: {}".format(inp),"{} be like: [insert chaos]".format(inp)]
    print("  Caption ideas for {}:".format(inp if inp else "topic"))
    for c in captions: print("\n  > {}".format(c))
elif cmd=="help":
    print("Meme Generator\n  template [num]    — Browse/view meme formats\n  generate <topic>  — Suggest format for topic\n  caption <topic>   — Generate caption ideas")
else: print("Unknown: "+cmd)
print("\nPowered by BytesAgain | bytesagain.com")
' "$CMD" $INPUT