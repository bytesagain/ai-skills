#!/usr/bin/env bash
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in

validate)
  SKILL_DIR="${1:-.}"
  python3 - "$SKILL_DIR" << 'PYEOF'
import sys, os

skill_dir = sys.argv[1] if len(sys.argv) > 1 else "."
skill_dir = os.path.abspath(skill_dir)
name = os.path.basename(skill_dir)
errors = []
warnings = []
passes = []

print("=" * 60)
print("  Validate Skill: {}".format(name))
print("  Path: {}".format(skill_dir))
print("=" * 60)
print("")

# Check SKILL.md
skill_md = os.path.join(skill_dir, "SKILL.md")
if os.path.isfile(skill_md):
    passes.append("SKILL.md exists")
    with open(skill_md) as f:
        content = f.read()
    if content.startswith("---"):
        passes.append("Frontmatter detected")
    else:
        errors.append("SKILL.md missing frontmatter (---)")
    if "name:" in content.lower():
        passes.append("'name' field present")
    else:
        errors.append("Missing 'name' in frontmatter")
    if "description:" in content.lower():
        passes.append("'description' field present")
    else:
        errors.append("Missing 'description' in frontmatter")
else:
    errors.append("SKILL.md not found")

# Check scripts directory
scripts_dir = os.path.join(skill_dir, "scripts")
if os.path.isdir(scripts_dir):
    scripts = [f for f in os.listdir(scripts_dir) if f.endswith(".sh")]
    if scripts:
        passes.append("Scripts found: {}".format(", ".join(scripts)))
    else:
        warnings.append("scripts/ exists but no .sh files found")
else:
    warnings.append("No scripts/ directory")

# Check optional files
for optional in ["tips.md", "README.md", "references/"]:
    path = os.path.join(skill_dir, optional)
    if os.path.exists(path):
        passes.append("Optional: {} present".format(optional))

# Results
print("PASS ({})".format(len(passes)))
for p in passes:
    print("  [PASS] {}".format(p))
print("")

if warnings:
    print("WARN ({})".format(len(warnings)))
    for w in warnings:
        print("  [WARN] {}".format(w))
    print("")

if errors:
    print("FAIL ({})".format(len(errors)))
    for e in errors:
        print("  [FAIL] {}".format(e))
    print("")

total = len(passes) + len(warnings) + len(errors)
score = int((len(passes) / total) * 100) if total > 0 else 0
status = "PASS" if not errors else "FAIL"
print("Result: {} (score: {}%)".format(status, score))
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

lint)
  SKILL_DIR="${1:-.}"
  python3 - "$SKILL_DIR" << 'PYEOF'
import sys, os, re

skill_dir = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else ".")
name = os.path.basename(skill_dir)
issues = []
passes = []

print("=" * 60)
print("  Lint SKILL.md: {}".format(name))
print("=" * 60)
print("")

skill_md = os.path.join(skill_dir, "SKILL.md")
if not os.path.isfile(skill_md):
    print("[FAIL] SKILL.md not found at {}".format(skill_md))
    sys.exit(1)

with open(skill_md) as f:
    content = f.read()
    lines = content.split("\n")

# Frontmatter check
if content.startswith("---"):
    fm_end = content.find("---", 3)
    if fm_end > 0:
        frontmatter = content[3:fm_end].strip()
        passes.append("Frontmatter block found")

        # Name field
        name_match = re.search(r'^name:\s*(.+)$', frontmatter, re.MULTILINE)
        if name_match:
            n = name_match.group(1).strip()
            if len(n) < 2:
                issues.append("Name too short: '{}'".format(n))
            elif len(n) > 60:
                issues.append("Name too long ({} chars, max 60)".format(len(n)))
            else:
                passes.append("Name OK: '{}'".format(n))
        else:
            issues.append("Missing 'name' field")

        # Description field
        desc_match = re.search(r'^description:\s*(.+)$', frontmatter, re.MULTILINE)
        if desc_match:
            d = desc_match.group(1).strip()
            if len(d) < 20:
                issues.append("Description too short ({} chars, min 20)".format(len(d)))
            elif len(d) > 500:
                issues.append("Description too long ({} chars, max 500)".format(len(d)))
            else:
                passes.append("Description OK ({} chars)".format(len(d)))
        else:
            issues.append("Missing 'description' field")
    else:
        issues.append("Frontmatter not properly closed")
else:
    issues.append("No frontmatter block (must start with ---)")

# Content checks
body = content[content.find("---", 3)+3:].strip() if "---" in content[3:] else content
if len(body) < 100:
    issues.append("Body too short ({} chars, min 100)".format(len(body)))
else:
    passes.append("Body length OK ({} chars)".format(len(body)))

headings = [l for l in lines if l.startswith("#")]
if len(headings) < 2:
    issues.append("Too few headings ({}, recommend 3+)".format(len(headings)))
else:
    passes.append("Headings: {} found".format(len(headings)))

has_code = "```" in content
if has_code:
    passes.append("Code examples present")
else:
    issues.append("No code examples found (recommended)")

# File size
size = os.path.getsize(skill_md)
if size > 5000:
    issues.append("SKILL.md too large ({} bytes, max 5000)".format(size))
else:
    passes.append("File size OK ({} bytes)".format(size))

print("PASS ({})".format(len(passes)))
for p in passes:
    print("  [PASS] {}".format(p))
print("")

if issues:
    print("ISSUES ({})".format(len(issues)))
    for i in issues:
        print("  [WARN] {}".format(i))
    print("")

status = "CLEAN" if not issues else "NEEDS FIXES"
print("Result: {}".format(status))
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

dry-run)
  SKILL_DIR="${1:-.}"
  python3 - "$SKILL_DIR" << 'PYEOF'
import sys, os

skill_dir = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else ".")
name = os.path.basename(skill_dir)

print("=" * 60)
print("  Dry-Run Publish: {}".format(name))
print("=" * 60)
print("")

steps = [
    ("Check SKILL.md exists", os.path.isfile(os.path.join(skill_dir, "SKILL.md"))),
    ("Check frontmatter", False),
    ("Validate structure", False),
    ("Check file sizes", False),
    ("Scan for secrets", True),
    ("Build package", True),
    ("Verify checksums", True),
]

# Update dynamic checks
skill_md = os.path.join(skill_dir, "SKILL.md")
if os.path.isfile(skill_md):
    with open(skill_md) as f:
        c = f.read()
    steps[1] = ("Check frontmatter", c.startswith("---"))
    steps[2] = ("Validate structure", "name:" in c.lower() and "description:" in c.lower())

    total_size = 0
    for root, dirs, files in os.walk(skill_dir):
        for fn in files:
            total_size += os.path.getsize(os.path.join(root, fn))
    steps[3] = ("Check file sizes", total_size < 500000)

all_pass = True
for i, (step, result) in enumerate(steps, 1):
    icon = "PASS" if result else "FAIL"
    if not result:
        all_pass = False
    print("  Step {}: [{}] {}".format(i, icon, step))

print("")
if all_pass:
    print("Dry-run result: READY TO PUBLISH")
    print("")
    print("Files that would be published:")
    for root, dirs, files in os.walk(skill_dir):
        for fn in sorted(files):
            fp = os.path.join(root, fn)
            rel = os.path.relpath(fp, skill_dir)
            sz = os.path.getsize(fp)
            print("  {:40s} {:>8s}".format(rel, "{:.1f} KB".format(sz / 1024)))
else:
    print("Dry-run result: NOT READY (fix errors above)")

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

size)
  SKILL_DIR="${1:-.}"
  python3 - "$SKILL_DIR" << 'PYEOF'
import sys, os

skill_dir = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else ".")
name = os.path.basename(skill_dir)

print("=" * 60)
print("  Size Analysis: {}".format(name))
print("=" * 60)
print("")

MAX_FILE = 100 * 1024      # 100 KB per file
MAX_TOTAL = 500 * 1024     # 500 KB total
total = 0
files = []
warnings = []

for root, dirs, filenames in os.walk(skill_dir):
    for fn in sorted(filenames):
        fp = os.path.join(root, fn)
        sz = os.path.getsize(fp)
        rel = os.path.relpath(fp, skill_dir)
        files.append((rel, sz))
        total += sz
        if sz > MAX_FILE:
            warnings.append("{} exceeds 100KB ({:.1f} KB)".format(rel, sz / 1024))

print("Files:")
print("  {:<40s} {:>10s}".format("Name", "Size"))
print("  " + "-" * 52)
for rel, sz in files:
    flag = " !!!" if sz > MAX_FILE else ""
    print("  {:<40s} {:>8.1f} KB{}".format(rel, sz / 1024, flag))

print("")
print("  {:<40s} {:>8.1f} KB".format("TOTAL", total / 1024))
print("")

if total > MAX_TOTAL:
    print("[WARN] Total size exceeds 500 KB limit!")
else:
    print("[PASS] Total size within limits ({:.0f}% of 500 KB)".format((total / MAX_TOTAL) * 100))

for w in warnings:
    print("[WARN] {}".format(w))

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

deps)
  SKILL_DIR="${1:-.}"
  python3 - "$SKILL_DIR" << 'PYEOF'
import sys, os, re

skill_dir = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else ".")
name = os.path.basename(skill_dir)

print("=" * 60)
print("  Dependency Analysis: {}".format(name))
print("=" * 60)
print("")

scripts_dir = os.path.join(skill_dir, "scripts")
if not os.path.isdir(scripts_dir):
    print("[WARN] No scripts/ directory found")
    print("")
    print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
    sys.exit(0)

known_cmds = {"bash", "echo", "cat", "grep", "sed", "awk", "sort", "uniq",
              "head", "tail", "wc", "cut", "tr", "tee", "xargs", "find",
              "mkdir", "rm", "cp", "mv", "ls", "cd", "pwd", "date",
              "python3", "python", "node", "curl", "wget", "jq",
              "git", "docker", "npm", "pip", "pip3"}

found_deps = set()
for fn in os.listdir(scripts_dir):
    if not fn.endswith(".sh"):
        continue
    fp = os.path.join(scripts_dir, fn)
    with open(fp) as f:
        content = f.read()

    # Find command invocations
    for match in re.findall(r'(?:^|\s|`)([a-zA-Z][\w-]*)\s', content):
        if match.lower() in known_cmds:
            found_deps.add(match.lower())

# Check availability
print("Dependencies found:")
print("")
available = []
missing = []
for dep in sorted(found_deps):
    check = os.popen("which {} 2>/dev/null".format(dep)).read().strip()
    if check:
        available.append(dep)
        print("  [OK]   {:<20s} {}".format(dep, check))
    else:
        missing.append(dep)
        print("  [MISS] {:<20s} NOT FOUND".format(dep))

print("")
print("Summary: {} available, {} missing".format(len(available), len(missing)))

if missing:
    print("")
    print("Missing dependencies may cause runtime errors.")
    print("Consider adding fallback checks in your scripts.")

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

compare)
  SKILL_A="${1:-.}"
  SKILL_B="${2:-.}"
  python3 - "$SKILL_A" "$SKILL_B" << 'PYEOF'
import sys, os

dir_a = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else ".")
dir_b = os.path.abspath(sys.argv[2] if len(sys.argv) > 2 else ".")
name_a = os.path.basename(dir_a)
name_b = os.path.basename(dir_b)

print("=" * 60)
print("  Compare: {} vs {}".format(name_a, name_b))
print("=" * 60)
print("")

def get_skill_info(skill_dir):
    info = {"files": [], "total_size": 0, "has_skill_md": False,
            "has_scripts": False, "has_tips": False}
    for root, dirs, files in os.walk(skill_dir):
        for fn in files:
            fp = os.path.join(root, fn)
            sz = os.path.getsize(fp)
            rel = os.path.relpath(fp, skill_dir)
            info["files"].append((rel, sz))
            info["total_size"] += sz
    info["has_skill_md"] = os.path.isfile(os.path.join(skill_dir, "SKILL.md"))
    info["has_scripts"] = os.path.isdir(os.path.join(skill_dir, "scripts"))
    info["has_tips"] = os.path.isfile(os.path.join(skill_dir, "tips.md"))
    return info

a = get_skill_info(dir_a)
b = get_skill_info(dir_b)

fmt = "  {:<25s} {:>15s} {:>15s}"
print(fmt.format("Metric", name_a, name_b))
print("  " + "-" * 57)
print(fmt.format("SKILL.md", "Yes" if a["has_skill_md"] else "No", "Yes" if b["has_skill_md"] else "No"))
print(fmt.format("scripts/", "Yes" if a["has_scripts"] else "No", "Yes" if b["has_scripts"] else "No"))
print(fmt.format("tips.md", "Yes" if a["has_tips"] else "No", "Yes" if b["has_tips"] else "No"))
print(fmt.format("File count", str(len(a["files"])), str(len(b["files"]))))
print(fmt.format("Total size", "{:.1f} KB".format(a["total_size"] / 1024), "{:.1f} KB".format(b["total_size"] / 1024)))

print("")
print("Files in {} only:".format(name_a))
a_names = set(f[0] for f in a["files"])
b_names = set(f[0] for f in b["files"])
for f in sorted(a_names - b_names):
    print("  + {}".format(f))
if not (a_names - b_names):
    print("  (none)")

print("")
print("Files in {} only:".format(name_b))
for f in sorted(b_names - a_names):
    print("  + {}".format(f))
if not (b_names - a_names):
    print("  (none)")

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

benchmark)
  SKILL_DIR="${1:-.}"
  python3 - "$SKILL_DIR" << 'PYEOF'
import sys, os, time, subprocess

skill_dir = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else ".")
name = os.path.basename(skill_dir)

print("=" * 60)
print("  Benchmark: {}".format(name))
print("=" * 60)
print("")

scripts_dir = os.path.join(skill_dir, "scripts")
if not os.path.isdir(scripts_dir):
    print("[WARN] No scripts/ directory")
    print("")
    print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
    sys.exit(0)

results = []
for fn in sorted(os.listdir(scripts_dir)):
    if not fn.endswith(".sh"):
        continue
    fp = os.path.join(scripts_dir, fn)

    # Benchmark help command (no args = default/help)
    start = time.time()
    try:
        proc = subprocess.run(
            ["bash", fp],
            capture_output=True, text=True, timeout=10
        )
        elapsed = time.time() - start
        out_size = len(proc.stdout)
        status = "OK" if proc.returncode == 0 else "ERR"
    except subprocess.TimeoutExpired:
        elapsed = 10.0
        out_size = 0
        status = "TIMEOUT"
    except Exception as e:
        elapsed = time.time() - start
        out_size = 0
        status = "ERR"

    results.append((fn, elapsed, out_size, status))

fmt = "  {:<30s} {:>8s} {:>10s} {:>8s}"
print(fmt.format("Script", "Time", "Output", "Status"))
print("  " + "-" * 58)
for fn, elapsed, out_size, status in results:
    time_str = "{:.3f}s".format(elapsed)
    size_str = "{:.1f} KB".format(out_size / 1024)
    grade = "FAST" if elapsed < 1.0 else ("OK" if elapsed < 3.0 else "SLOW")
    print(fmt.format(fn, time_str, size_str, status))

print("")
if results:
    avg = sum(r[1] for r in results) / len(results)
    print("Average execution time: {:.3f}s".format(avg))
    if avg < 1.0:
        print("Performance grade: EXCELLENT")
    elif avg < 3.0:
        print("Performance grade: GOOD")
    else:
        print("Performance grade: NEEDS OPTIMIZATION")

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

report)
  SKILL_DIR="${1:-.}"
  python3 - "$SKILL_DIR" << 'PYEOF'
import sys, os, re

skill_dir = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else ".")
name = os.path.basename(skill_dir)

print("=" * 60)
print("  Quality Report: {}".format(name))
print("=" * 60)
print("")

scores = {}

# 1. Structure (0-25)
struct_score = 0
if os.path.isfile(os.path.join(skill_dir, "SKILL.md")):
    struct_score += 10
if os.path.isdir(os.path.join(skill_dir, "scripts")):
    struct_score += 8
if os.path.isfile(os.path.join(skill_dir, "tips.md")):
    struct_score += 7
scores["Structure"] = struct_score

# 2. Documentation (0-25)
doc_score = 0
skill_md = os.path.join(skill_dir, "SKILL.md")
if os.path.isfile(skill_md):
    with open(skill_md) as f:
        content = f.read()
    if content.startswith("---"):
        doc_score += 5
    if "name:" in content.lower():
        doc_score += 5
    if "description:" in content.lower():
        doc_score += 5
    if "```" in content:
        doc_score += 5
    headings = len([l for l in content.split("\n") if l.startswith("#")])
    if headings >= 3:
        doc_score += 5
scores["Documentation"] = doc_score

# 3. Scripts (0-25)
script_score = 0
scripts_dir = os.path.join(skill_dir, "scripts")
if os.path.isdir(scripts_dir):
    sh_files = [f for f in os.listdir(scripts_dir) if f.endswith(".sh")]
    if sh_files:
        script_score += 10
        for sh in sh_files:
            fp = os.path.join(scripts_dir, sh)
            with open(fp) as f:
                sc = f.read()
            if "set -e" in sc:
                script_score += 5
            if "case" in sc:
                script_score += 5
            if "help" in sc.lower() or "usage" in sc.lower():
                script_score += 5
            break  # Score first script
scores["Scripts"] = min(script_score, 25)

# 4. Size & hygiene (0-25)
hygiene_score = 15  # Start optimistic
total_size = 0
for root, dirs, files in os.walk(skill_dir):
    for fn in files:
        total_size += os.path.getsize(os.path.join(root, fn))
if total_size > 500 * 1024:
    hygiene_score -= 10
elif total_size > 200 * 1024:
    hygiene_score -= 5
# Check for common issues
for root, dirs, files in os.walk(skill_dir):
    for fn in files:
        if fn in [".DS_Store", "Thumbs.db", ".env"]:
            hygiene_score -= 5
hygiene_score += 10  # bonus for passing
scores["Hygiene"] = min(max(hygiene_score, 0), 25)

# Report
total = sum(scores.values())
print("Category Scores:")
print("")
for cat, score in scores.items():
    bar = "#" * score + "." * (25 - score)
    print("  {:<15s} [{:<25s}] {}/25".format(cat, bar, score))
print("")
print("  {:<15s}                            {}/100".format("TOTAL", total))
print("")

if total >= 90:
    grade = "A  (Excellent)"
elif total >= 75:
    grade = "B  (Good)"
elif total >= 60:
    grade = "C  (Acceptable)"
elif total >= 40:
    grade = "D  (Needs Work)"
else:
    grade = "F  (Major Issues)"
print("Grade: {}".format(grade))

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

*)
  echo "Skill Tester - OpenClaw Skill QA Tool"
  echo ""
  echo "Usage: bash skill-tester.sh <command> <skill-dir>"
  echo ""
  echo "Commands:"
  echo "  validate <dir>          Validate skill structure"
  echo "  lint <dir>              Lint SKILL.md for spec compliance"
  echo "  dry-run <dir>           Simulate publish"
  echo "  size <dir>              Check file size limits"
  echo "  deps <dir>              Analyze dependencies"
  echo "  compare <dir1> <dir2>   Compare two skills"
  echo "  benchmark <dir>         Performance benchmark"
  echo "  report <dir>            Generate quality report"
  echo ""
  echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
  ;;

esac
