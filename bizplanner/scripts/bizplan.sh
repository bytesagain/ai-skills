#!/usr/bin/env bash
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
python3 << PYEOF
import sys
cmd = "$CMD"; inp = """$INPUT"""
def cmd_outline():
    parts = inp.split() if inp else ["MyCompany"]
    co = parts[0]
    sections = [("Executive Summary","Company overview, mission, key financials"),("Company Description","Legal structure, history, location, team size"),("Market Analysis","Industry trends, target market, TAM/SAM/SOM, competitors"),("Organization","Org chart, key team members, hiring plan"),("Products/Services","Offerings, pricing, IP, R&D roadmap"),("Marketing Strategy","Channels, customer acquisition, brand positioning"),("Financial Projections","Revenue model, 3-year P&L, cash flow, break-even"),("Funding Request","Amount needed, use of funds, ROI for investors")]
    print("=" * 55)
    print("  Business Plan — {}".format(co))
    print("=" * 55)
    for i,(t,d) in enumerate(sections,1):
        print("")
        print("  {}. {}".format(i,t))
        print("     {}".format(d))
def cmd_canvas():
    print("=" * 60)
    print("  Business Model Canvas")
    print("=" * 60)
    blocks = [("Key Partners","Who are your key suppliers and partners?"),("Key Activities","What do you do to deliver value?"),("Key Resources","What assets are essential?"),("Value Proposition","What problem do you solve?"),("Customer Relationships","How do you interact with customers?"),("Channels","How do you reach customers?"),("Customer Segments","Who are your customers?"),("Cost Structure","What are your major costs?"),("Revenue Streams","How do you make money?")]
    for b,q in blocks:
        print("")
        print("  {}".format(b))
        print("    {}".format(q))
        print("    > ___")
def cmd_swot():
    print("=" * 50)
    print("  SWOT Analysis")
    print("=" * 50)
    for label in ["Strengths (internal +)","Weaknesses (internal -)","Opportunities (external +)","Threats (external -)"]:
        print("")
        print("  {}:".format(label))
        for i in range(1,4):
            print("    {}. ___".format(i))
cmds = {"outline":cmd_outline,"canvas":cmd_canvas,"swot":cmd_swot}
if cmd == "help":
    print("Business Plan Generator")
    print("  outline [company]  — Full business plan template")
    print("  canvas             — Business Model Canvas")
    print("  swot               — SWOT analysis template")
elif cmd in cmds: cmds[cmd]()
else: print("Unknown: {}".format(cmd))
print("\nPowered by BytesAgain | bytesagain.com")
PYEOF
