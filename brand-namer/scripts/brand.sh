#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
run_python() {
python3 << 'PYEOF'
import sys, hashlib, itertools
cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
inp = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

PREFIXES = ["Nova","Zen","Flux","Apex","Vibe","Luma","Sync","Core","Meta","Neo","Pixel","Byte","Cloud","Wave","Spark","Blaze","Edge","Swift","True","Pure"]
SUFFIXES = ["ly","ify","io","ai","hub","lab","box","go","up","ware","base","flow","mind","stack","craft","works","spot","zone","nest","forge"]

def cmd_generate():
    if not inp:
        print("Usage: generate <keyword> [style]")
        print("Styles: tech, elegant, fun, minimal")
        return
    parts = inp.split()
    keyword = parts[0]
    style = parts[1] if len(parts) > 1 else "tech"
    seed = int(hashlib.md5(keyword.encode()).hexdigest()[:8], 16)
    print("=" * 50)
    print("  Brand Name Generator — {}".format(keyword))
    print("=" * 50)
    print("")
    names = []
    for i in range(20):
        idx = (seed + i * 7) % len(PREFIXES)
        sidx = (seed + i * 13) % len(SUFFIXES)
        p = PREFIXES[idx]
        s = SUFFIXES[sidx]
        combo1 = "{}{}".format(p, s)
        combo2 = "{}{}".format(keyword.capitalize(), s)
        combo3 = "{}{}".format(p, keyword.capitalize())
        names.extend([combo1, combo2, combo3])
    seen = set()
    unique = []
    for n in names:
        if n.lower() not in seen:
            seen.add(n.lower())
            unique.append(n)
    print("  Generated names:")
    for i, n in enumerate(unique[:15], 1):
        domain = "{}.com".format(n.lower())
        print("  {:2d}. {:20s} → {}".format(i, n, domain))
    print("")
    print("  Check availability:")
    print("    Domains: https://instantdomainsearch.com")
    print("    Trademark: https://tess2.uspto.gov")

def cmd_check():
    if not inp:
        print("Usage: check <name>")
        return
    name = inp.strip().lower()
    print("  Checking: {}".format(name))
    print("")
    extensions = [".com", ".io", ".ai", ".co", ".dev", ".app"]
    for ext in extensions:
        domain = "{}{}".format(name, ext)
        try:
            import subprocess
            result = subprocess.run(["curl","-s","-o","/dev/null","-w","%{http_code}",
                "https://{}".format(domain)], capture_output=True, text=True, timeout=5)
            code = result.stdout.strip()
            status = "TAKEN" if code in ["200","301","302","403"] else "possibly available"
        except:
            status = "check manually"
        print("    {} — {}".format(domain, status))

def cmd_cn():
    if not inp:
        print("Usage: cn <keyword>")
        return
    keyword = inp.strip()
    print("=" * 45)
    print("  Chinese Brand Name Ideas")
    print("=" * 45)
    print("")
    patterns = [
        "{}云", "{}智", "{}通", "{}达", "{}优",
        "智{}","云{}","优{}","易{}","快{}",
        "{}宝","{}客","{}帮","{}家","{}星",
    ]
    print("  Based on: {}".format(keyword))
    print("")
    for p in patterns:
        name = p.format(keyword)
        print("    {}".format(name))

commands = {"generate": cmd_generate, "check": cmd_check, "cn": cmd_cn}
if cmd == "help":
    print("Brand Namer")
    print("")
    print("Commands:")
    print("  generate <keyword> [style] — Generate brand names")
    print("  check <name>              — Check domain availability")
    print("  cn <keyword>              — Chinese brand name ideas")
elif cmd in commands:
    commands[cmd]()
else:
    print("Unknown: {}".format(cmd))
print("")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
}
run_python "$CMD" $INPUT
