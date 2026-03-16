#!/usr/bin/env bash
# license-picker — 开源许可证选择器
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
run_python() {
python3 << 'PYEOF'
import sys
from datetime import datetime

cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
inp = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

LICENSES = {
    "mit": {"name":"MIT License","permissive":True,"copyleft":False,"patent":False,
        "can":["Commercial use","Modify","Distribute","Private use"],
        "cannot":["Hold liable"],
        "must":["Include copyright","Include license"],
        "projects":"React, jQuery, Rails, .NET, Babel"},
    "apache2": {"name":"Apache License 2.0","permissive":True,"copyleft":False,"patent":True,
        "can":["Commercial use","Modify","Distribute","Patent use","Private use"],
        "cannot":["Hold liable","Use trademark"],
        "must":["Include copyright","Include license","State changes","Include NOTICE"],
        "projects":"Android, Kubernetes, Swift, TensorFlow"},
    "gpl3": {"name":"GNU GPL v3","permissive":False,"copyleft":True,"patent":True,
        "can":["Commercial use","Modify","Distribute","Patent use","Private use"],
        "cannot":["Hold liable","Sublicense"],
        "must":["Include source","Include copyright","State changes","Same license"],
        "projects":"Linux, GCC, WordPress, GIMP"},
    "lgpl3": {"name":"GNU LGPL v3","permissive":False,"copyleft":True,"patent":True,
        "can":["Commercial use","Modify","Distribute","Patent use","Private use"],
        "cannot":["Hold liable","Sublicense"],
        "must":["Include copyright","Include license","State changes","Same license (library)"],
        "projects":"FFmpeg, glibc"},
    "bsd2": {"name":"BSD 2-Clause","permissive":True,"copyleft":False,"patent":False,
        "can":["Commercial use","Modify","Distribute","Private use"],
        "cannot":["Hold liable"],
        "must":["Include copyright","Include license"],
        "projects":"FreeBSD, nginx"},
    "bsd3": {"name":"BSD 3-Clause","permissive":True,"copyleft":False,"patent":False,
        "can":["Commercial use","Modify","Distribute","Private use"],
        "cannot":["Hold liable","Use contributor names in endorsement"],
        "must":["Include copyright","Include license"],
        "projects":"Go, Django, Flask"},
    "mpl2": {"name":"Mozilla Public License 2.0","permissive":False,"copyleft":True,"patent":True,
        "can":["Commercial use","Modify","Distribute","Patent use","Private use"],
        "cannot":["Hold liable","Use trademark"],
        "must":["Include copyright","Include license","Disclose source (modified files only)"],
        "projects":"Firefox, Thunderbird"},
    "unlicense": {"name":"The Unlicense","permissive":True,"copyleft":False,"patent":False,
        "can":["Commercial use","Modify","Distribute","Private use"],
        "cannot":["Hold liable"],
        "must":["Nothing"],
        "projects":"youtube-dl (formerly)"},
    "agpl3": {"name":"GNU AGPL v3","permissive":False,"copyleft":True,"patent":True,
        "can":["Commercial use","Modify","Distribute","Patent use"],
        "cannot":["Hold liable","Sublicense"],
        "must":["Include source","Include copyright","Network use = distribution","Same license"],
        "projects":"MongoDB (old), Mastodon, Nextcloud"},
}

def cmd_compare():
    print("=" * 75)
    print("  Open Source License Comparison")
    print("=" * 75)
    print("")
    print("  {:12s} {:>10s} {:>10s} {:>8s} {:>10s}".format("License","Permissive","Copyleft","Patent","Simplicity"))
    print("  " + "-" * 55)
    simple = {"mit":5,"bsd2":5,"bsd3":4,"apache2":3,"mpl2":3,"lgpl3":2,"gpl3":2,"agpl3":1,"unlicense":5}
    for key in ["mit","bsd2","bsd3","apache2","unlicense","mpl2","lgpl3","gpl3","agpl3"]:
        l = LICENSES[key]
        p = "Yes" if l["permissive"] else "No"
        c = "Yes" if l["copyleft"] else "No"
        pat = "Yes" if l["patent"] else "No"
        s = "*" * simple.get(key, 3)
        print("  {:12s} {:>10s} {:>10s} {:>8s} {:>10s}".format(key.upper(), p, c, pat, s))

def cmd_recommend():
    if not inp:
        print("Usage: recommend <use_case>")
        print("Cases: library, app, saas, maximum-freedom, corporate, keep-open")
        return
    use = inp.strip().lower()
    recs = {
        "library": ("MIT or Apache-2.0", "Most adopted for libraries. MIT is simpler, Apache adds patent protection."),
        "app": ("MIT or GPL-3.0", "MIT for maximum adoption. GPL if you want derivatives to stay open."),
        "saas": ("AGPL-3.0", "Forces SaaS providers to share modifications. Closes the ASP loophole."),
        "maximum-freedom": ("MIT or Unlicense", "Least restrictions. Users can do anything."),
        "corporate": ("Apache-2.0", "Patent grant protects both sides. NOTICE file for attribution."),
        "keep-open": ("GPL-3.0 or AGPL-3.0", "Copyleft ensures derivatives remain open source."),
    }
    if use in recs:
        name, reason = recs[use]
        print("  Use case: {}".format(use))
        print("  Recommended: {}".format(name))
        print("  Why: {}".format(reason))
    else:
        print("Available: {}".format(", ".join(recs.keys())))

def cmd_detail():
    if not inp:
        print("Usage: detail <license>")
        print("Licenses: {}".format(", ".join(LICENSES.keys())))
        return
    key = inp.strip().lower()
    if key not in LICENSES:
        print("Unknown. Available: {}".format(", ".join(LICENSES.keys())))
        return
    l = LICENSES[key]
    print("=" * 55)
    print("  {}".format(l["name"]))
    print("=" * 55)
    print("")
    print("  CAN:")
    for c in l["can"]:
        print("    + {}".format(c))
    print("  CANNOT:")
    for c in l["cannot"]:
        print("    - {}".format(c))
    print("  MUST:")
    for c in l["must"]:
        print("    * {}".format(c))
    print("")
    print("  Used by: {}".format(l["projects"]))

def cmd_generate():
    if not inp:
        print("Usage: generate <license> <author>")
        print("Example: generate mit JohnDoe")
        return
    parts = inp.split()
    key = parts[0].lower()
    author = " ".join(parts[1:]) if len(parts) > 1 else "[Author]"
    year = datetime.now().year

    templates = {
        "mit": "MIT License\n\nCopyright (c) {} {}\n\nPermission is hereby granted, free of charge, to any person obtaining a copy\nof this software and associated documentation files (the \"Software\"), to deal\nin the Software without restriction, including without limitation the rights\nto use, copy, modify, merge, publish, distribute, sublicense, and/or sell\ncopies of the Software, and to permit persons to whom the Software is\nfurnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all\ncopies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\nSOFTWARE.".format(year, author),
        "bsd2": "BSD 2-Clause License\n\nCopyright (c) {}, {}\n\nRedistribution and use in source and binary forms, with or without\nmodification, are permitted provided that the following conditions are met:\n\n1. Redistributions of source code must retain the above copyright notice,\n   this list of conditions and the following disclaimer.\n2. Redistributions in binary form must reproduce the above copyright notice,\n   this list of conditions and the following disclaimer in the documentation\n   and/or other materials provided with the distribution.\n\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\"\nAND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE\nIMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE\nARE DISCLAIMED.".format(year, author),
        "unlicense": "This is free and unencumbered software released into the public domain.\n\nAnyone is free to copy, modify, publish, use, compile, sell, or distribute\nthis software, either in source code form or as a compiled binary, for any\npurpose, commercial or non-commercial, and by any means.",
    }

    if key in templates:
        print(templates[key])
    else:
        print("Template available for: mit, bsd2, unlicense")
        print("For others, visit: https://choosealicense.com/licenses/{}/".format(key))

commands = {"compare": cmd_compare, "recommend": cmd_recommend, "detail": cmd_detail, "generate": cmd_generate}
if cmd == "help":
    print("Open Source License Picker")
    print("")
    print("Commands:")
    print("  compare                    — Side-by-side comparison table")
    print("  recommend <use_case>       — Get recommendation by scenario")
    print("  detail <license>           — Full details of a license")
    print("  generate <license> <author> — Generate LICENSE file text")
    print("")
    print("Licenses: mit, apache2, gpl3, lgpl3, bsd2, bsd3, mpl2, agpl3, unlicense")
elif cmd in commands:
    commands[cmd]()
else:
    print("Unknown: {}".format(cmd))
print("")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
}
run_python "$CMD" $INPUT
