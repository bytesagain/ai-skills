#!/usr/bin/env bash
# pitch-deck — 商业计划书/路演PPT生成器
# Usage: bash pitch.sh <command> [args]
# Powered by BytesAgain | bytesagain.com
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

run_python() {
python3 << 'PYEOF'
import sys, json, math
from datetime import datetime

cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
inp = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

def cmd_outline():
    if not inp:
        print("Usage: outline <company_name> [industry]")
        print("Example: outline BytesAgain AI-Tools")
        return
    parts = inp.split()
    company = parts[0]
    industry = parts[1] if len(parts) > 1 else "Tech"

    slides = [
        ("Cover", "Title Slide", [
            "{} — Pitch Deck".format(company),
            "Tagline: [One sentence value proposition]",
            "Date: {}".format(datetime.now().strftime("%Y-%m-%d")),
            "Presenter: [Name, Title]",
        ]),
        ("Problem", "The Problem", [
            "What pain point exists in {} market?".format(industry),
            "Who experiences this problem?",
            "How big is this problem? (stats/data)",
            "Current solutions and their shortcomings",
        ]),
        ("Solution", "Our Solution", [
            "How {} solves the problem".format(company),
            "Key features (3-4 bullet points)",
            "Demo screenshot / product visual",
            "Why now? What changed?",
        ]),
        ("Market", "Market Opportunity", [
            "TAM (Total Addressable Market): $___",
            "SAM (Serviceable Available): $___",
            "SOM (Serviceable Obtainable): $___",
            "Growth rate: ___% CAGR",
        ]),
        ("Business Model", "How We Make Money", [
            "Revenue streams",
            "Pricing model (freemium/subscription/usage)",
            "Unit economics: CAC=$___, LTV=$___",
            "Path to profitability",
        ]),
        ("Traction", "Traction & Milestones", [
            "Users/Revenue to date",
            "Growth metrics (MoM/YoY)",
            "Key partnerships",
            "Notable achievements",
        ]),
        ("Competition", "Competitive Landscape", [
            "Competitor 1: [strength] / [weakness]",
            "Competitor 2: [strength] / [weakness]",
            "Our differentiation",
            "Moat / barriers to entry",
        ]),
        ("Team", "The Team", [
            "Founder 1: [Name] — [Role] — [Experience]",
            "Founder 2: [Name] — [Role] — [Experience]",
            "Key hires planned",
            "Advisors / Board",
        ]),
        ("Financials", "Financial Projections", [
            "Year 1: Revenue $___  Costs $___",
            "Year 2: Revenue $___  Costs $___",
            "Year 3: Revenue $___  Costs $___",
            "Key assumptions",
        ]),
        ("Ask", "The Ask", [
            "Raising: $___",
            "Use of funds breakdown",
            "Timeline: ___ months runway",
            "Contact: [email]",
        ]),
    ]

    print("=" * 60)
    print("  {} — Pitch Deck Outline".format(company))
    print("  Industry: {}".format(industry))
    print("=" * 60)
    for i, (tag, title, bullets) in enumerate(slides, 1):
        print("")
        print("  Slide {}: {} [{}]".format(i, title, tag))
        print("  " + "-" * 45)
        for b in bullets:
            print("    - {}".format(b))

def cmd_tam():
    if not inp:
        print("Usage: tam <total_users> <price_per_user> [growth_rate] [years]")
        print("Example: tam 1000000 50 15 5")
        return
    parts = inp.split()
    users = float(parts[0])
    price = float(parts[1])
    growth = float(parts[2]) if len(parts) > 2 else 10
    years = int(parts[3]) if len(parts) > 3 else 5

    tam = users * price
    sam = tam * 0.3
    som = tam * 0.05

    print("=" * 50)
    print("  Market Size Analysis (TAM/SAM/SOM)")
    print("=" * 50)
    print("")
    print("  Input:")
    print("    Total addressable users: {:,.0f}".format(users))
    print("    Price per user/year: ${:,.0f}".format(price))
    print("    Growth rate: {:.0f}%".format(growth))
    print("")
    print("  Current Market:")
    print("    TAM: ${:>14,.0f}  (100%)".format(tam))
    print("    SAM: ${:>14,.0f}  (30%)".format(sam))
    print("    SOM: ${:>14,.0f}  (5%)".format(som))
    print("")
    print("  {:>4s} {:>16s} {:>16s} {:>16s}".format("Year", "TAM", "SAM", "SOM"))
    print("  " + "-" * 56)
    for y in range(1, years + 1):
        factor = (1 + growth / 100) ** y
        print("  {:>4d} ${:>14,.0f} ${:>14,.0f} ${:>14,.0f}".format(
            y, tam * factor, sam * factor, som * factor))

def cmd_unit_economics():
    if not inp:
        print("Usage: unit-economics <cac> <ltv> <monthly_revenue> <churn_pct>")
        print("Example: unit-economics 50 600 30 5")
        return
    parts = inp.split()
    cac = float(parts[0])
    ltv = float(parts[1])
    mrr = float(parts[2]) if len(parts) > 2 else 0
    churn = float(parts[3]) if len(parts) > 3 else 5

    ratio = ltv / cac if cac > 0 else 0
    payback = cac / mrr if mrr > 0 else 0
    lifetime = 1 / (churn / 100) if churn > 0 else 0

    print("=" * 50)
    print("  Unit Economics Dashboard")
    print("=" * 50)
    print("")
    print("  CAC (Customer Acquisition Cost): ${:,.0f}".format(cac))
    print("  LTV (Lifetime Value):            ${:,.0f}".format(ltv))
    print("  LTV:CAC Ratio:                   {:.1f}x".format(ratio))
    print("  Monthly Revenue/User:            ${:,.0f}".format(mrr))
    print("  Payback Period:                  {:.1f} months".format(payback))
    print("  Monthly Churn:                   {:.1f}%".format(churn))
    print("  Avg Customer Lifetime:           {:.0f} months".format(lifetime))
    print("")
    if ratio >= 3:
        print("  Assessment: HEALTHY — LTV:CAC >= 3x is the gold standard")
    elif ratio >= 1:
        print("  Assessment: MARGINAL — Need to improve LTV or reduce CAC")
    else:
        print("  Assessment: UNSUSTAINABLE — Spending more to acquire than earning")

def cmd_financial():
    if not inp:
        print("Usage: financial <year1_rev> <year2_rev> <year3_rev> <margin_pct>")
        print("Example: financial 100000 500000 2000000 70")
        return
    parts = inp.split()
    revs = [float(parts[i]) for i in range(min(3, len(parts)))]
    while len(revs) < 3:
        revs.append(revs[-1] * 2)
    margin = float(parts[3]) if len(parts) > 3 else 70

    print("=" * 60)
    print("  3-Year Financial Projection")
    print("=" * 60)
    print("")
    print("  {:>20s} {:>14s} {:>14s} {:>14s}".format("", "Year 1", "Year 2", "Year 3"))
    print("  " + "-" * 58)
    print("  {:>20s} {:>14,.0f} {:>14,.0f} {:>14,.0f}".format("Revenue", *revs))
    costs = [r * (100 - margin) / 100 for r in revs]
    print("  {:>20s} {:>14,.0f} {:>14,.0f} {:>14,.0f}".format("COGS", *costs))
    gross = [r - c for r, c in zip(revs, costs)]
    print("  {:>20s} {:>14,.0f} {:>14,.0f} {:>14,.0f}".format("Gross Profit", *gross))
    print("  {:>20s} {:>13.0f}% {:>13.0f}% {:>13.0f}%".format("Gross Margin", *[margin]*3))
    opex = [r * 0.5 for r in revs]
    print("  {:>20s} {:>14,.0f} {:>14,.0f} {:>14,.0f}".format("OpEx", *opex))
    ebitda = [g - o for g, o in zip(gross, opex)]
    print("  {:>20s} {:>14,.0f} {:>14,.0f} {:>14,.0f}".format("EBITDA", *ebitda))

    if len(revs) >= 2:
        g1 = (revs[1] - revs[0]) / revs[0] * 100 if revs[0] > 0 else 0
        g2 = (revs[2] - revs[1]) / revs[1] * 100 if revs[1] > 0 else 0
        print("")
        print("  YoY Growth: {:.0f}% / {:.0f}%".format(g1, g2))

def cmd_competitor():
    print("=" * 60)
    print("  Competitive Analysis Framework")
    print("=" * 60)
    print("")
    print("  Use this 2x2 matrix to position competitors:")
    print("")
    print("  High Price")
    print("    |")
    print("    |  [Premium]          [Enterprise]")
    print("    |")
    print("    |-------- Low Feature ----+---- High Feature -------")
    print("    |")
    print("    |  [Budget]            [Value Leader]")
    print("    |")
    print("  Low Price")
    print("")
    print("  Fill in this comparison table:")
    print("")
    print("  {:>15s} {:>10s} {:>10s} {:>10s} {:>10s}".format("Feature", "Us", "Comp 1", "Comp 2", "Comp 3"))
    print("  " + "-" * 58)
    features = ["Price", "Ease of Use", "Features", "Support", "Speed", "Integration", "Security", "Scalability"]
    for f in features:
        print("  {:>15s} {:>10s} {:>10s} {:>10s} {:>10s}".format(f, "___", "___", "___", "___"))
    print("")
    print("  Rating: 1-5 stars or Low/Med/High")

# Dispatch
commands = {
    "outline": cmd_outline,
    "tam": cmd_tam,
    "unit-economics": cmd_unit_economics,
    "financial": cmd_financial,
    "competitor": cmd_competitor,
}

if cmd == "help":
    print("Pitch Deck Generator")
    print("")
    print("Commands:")
    print("  outline <company> [industry]         — 10-slide pitch deck template")
    print("  tam <users> <price> [growth] [years]  — TAM/SAM/SOM analysis")
    print("  unit-economics <cac> <ltv> <mrr> <churn> — Unit economics")
    print("  financial <y1> <y2> <y3> [margin]     — 3-year financial projection")
    print("  competitor                            — Competitive analysis framework")
elif cmd in commands:
    commands[cmd]()
else:
    print("Unknown command: {}. Run with help.".format(cmd))

print("")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
}

run_python "$CMD" $INPUT
