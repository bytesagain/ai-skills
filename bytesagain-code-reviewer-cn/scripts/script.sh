#!/usr/bin/env bash
# bytesagain-code-reviewer-cn — Code review assistant
set -euo pipefail

CMD="${1:-help}"
shift || true

show_help() {
    echo "bytesagain-code-reviewer-cn — Code review checklist and analysis tool"
    echo ""
    echo "Usage:"
    echo "  bytesagain-code-reviewer-cn review <file>          Review a code file"
    echo "  bytesagain-code-reviewer-cn checklist <lang>       Show review checklist"
    echo "  bytesagain-code-reviewer-cn security <file>        Security scan"
    echo "  bytesagain-code-reviewer-cn complexity <file>      Complexity metrics"
    echo "  bytesagain-code-reviewer-cn diff <file1> <file2>   Compare two files"
    echo ""
    echo "Languages: python js go java bash"
    echo ""
}

cmd_review() {
    local file="${1:-}"
    [ -z "$file" ] && echo "Usage: review <file>" && exit 1
    [ ! -f "$file" ] && echo "File not found: $file" && exit 1

    local lang
    case "${file##*.}" in
        py)   lang="python" ;;
        js|ts) lang="javascript" ;;
        go)   lang="go" ;;
        java) lang="java" ;;
        sh)   lang="bash" ;;
        *)    lang="generic" ;;
    esac

    CR_FILE="$file" CR_LANG="$lang" python3 << 'PYEOF'
import re, os

import os; filepath = os.environ.get("CR_FILE","")
lang = os.environ.get("CR_LANG","generic")

with open(filepath) as f:
    lines = f.readlines()

total_lines = len(lines)
code_lines = sum(1 for l in lines if l.strip() and not l.strip().startswith('#'))
comment_lines = sum(1 for l in lines if l.strip().startswith('#'))
blank_lines = sum(1 for l in lines if not l.strip())
long_lines = [(i+1, len(l.rstrip())) for i, l in enumerate(lines) if len(l.rstrip()) > 100]

content = "".join(lines)

issues = []
warnings = []
suggestions = []

# Common issues across languages
if lang == "python":
    if "except:" in content and "except Exception" not in content:
        issues.append("Bare 'except:' clause — catches all exceptions including KeyboardInterrupt")
    if re.search(r'print\(', content) and "debug" not in filepath.lower():
        warnings.append("Found print() statements — consider using logging module")
    if "import *" in content:
        issues.append("Wildcard import (import *) — makes namespace unclear")
    if re.search(r'eval\(', content):
        issues.append("eval() usage detected — potential security risk")
    if not re.search(r'def \w+.*:\s*\n\s+["\']', content):
        suggestions.append("Functions appear to lack docstrings")

elif lang in ("javascript", "js"):
    if "var " in content:
        warnings.append("'var' declarations found — prefer 'const' or 'let'")
    if "==" in content and "===" not in content:
        warnings.append("Loose equality (==) found — prefer strict equality (===)")
    if re.search(r'console\.log', content):
        warnings.append("console.log statements found — remove before production")
    if re.search(r'eval\(', content):
        issues.append("eval() usage — security risk and performance issue")

elif lang == "bash":
    if re.search(r'\$\w+ ', content) and not re.search(r'"\$\w+"', content):
        warnings.append('Unquoted variables found — use "$VAR" to prevent word splitting')
    if "set -e" not in content:
        suggestions.append("Consider adding 'set -e' for fail-fast behavior")
    if re.search(r'rm -rf /', content):
        issues.append("DANGEROUS: rm -rf with root path detected!")

elif lang == "go":
    if "panic(" in content:
        warnings.append("panic() usage — consider returning errors instead")
    if re.search(r'err\s*=', content) and not re.search(r'if err', content):
        issues.append("Error assigned but not checked")

# Generic checks
if long_lines:
    warnings.append(f"{len(long_lines)} lines exceed 100 chars: lines {[l[0] for l in long_lines[:5]]}")

todos = [(i+1, l.strip()) for i, l in enumerate(lines) if "TODO" in l or "FIXME" in l or "HACK" in l]
if todos:
    suggestions.append(f"Found {len(todos)} TODO/FIXME/HACK comments to address")

print(f"\n{'='*55}")
print(f"  Code Review: {os.path.basename(filepath)} ({lang})")
print(f"{'='*55}")
print(f"  Lines: {total_lines} total | {code_lines} code | {comment_lines} comments | {blank_lines} blank")
print(f"  Comment ratio: {comment_lines/max(code_lines,1)*100:.1f}%")
print()

if issues:
    print(f"🔴 ISSUES ({len(issues)}) — Must fix:")
    for i in issues:
        print(f"   • {i}")
    print()
if warnings:
    print(f"🟡 WARNINGS ({len(warnings)}) — Should fix:")
    for w in warnings:
        print(f"   • {w}")
    print()
if suggestions:
    print(f"💡 SUGGESTIONS ({len(suggestions)}):")
    for s in suggestions:
        print(f"   • {s}")
    print()

if not issues and not warnings:
    print("✅ No major issues found. Code looks clean!")

if todos:
    print(f"\n📝 TODO items:")
    for lineno, text in todos[:5]:
        print(f"   Line {lineno}: {text[:80]}")
PYEOF
}

cmd_checklist() {
    local lang="${1:-generic}"
    CR_FILE="$file" CR_LANG="$lang" python3 << 'PYEOF'
lang = os.environ.get("CR_LANG","generic")
checklists = {
    "python": """
Python Code Review Checklist
━━━━━━━━━━━━━━━━━━━━━━━━━━━
Correctness
  [ ] No bare except: clauses
  [ ] All exceptions handled appropriately
  [ ] No mutable default arguments (def f(x=[]))
  [ ] Integer division vs float division correct

Security
  [ ] No eval() or exec() with user input
  [ ] SQL queries use parameterized statements
  [ ] No hardcoded secrets or passwords
  [ ] Input validation for all user data

Style (PEP 8)
  [ ] 4-space indentation
  [ ] Lines ≤ 79 characters (or team standard)
  [ ] Meaningful variable names
  [ ] Docstrings on all public functions/classes

Performance
  [ ] No unnecessary list comprehension in tight loops
  [ ] Database queries not inside loops (N+1 problem)
  [ ] Large datasets use generators, not lists

Testing
  [ ] Unit tests cover main logic paths
  [ ] Edge cases tested (empty, None, boundary values)
  [ ] Mock external dependencies
""",
    "js": """
JavaScript Code Review Checklist
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Correctness
  [ ] Use === not == for comparisons
  [ ] Handle Promise rejections (.catch or try/catch)
  [ ] No undefined variable access
  [ ] Array/object destructuring safe (with defaults)

Security
  [ ] No eval() or new Function()
  [ ] XSS: no innerHTML with user data (use textContent)
  [ ] CSRF tokens on state-changing requests
  [ ] No sensitive data in localStorage

Modern JS
  [ ] const/let instead of var
  [ ] Arrow functions where appropriate
  [ ] Async/await over callback chains
  [ ] Optional chaining (?.) for nested access

Performance
  [ ] No synchronous operations in event handlers
  [ ] Debounce/throttle on scroll/resize handlers
  [ ] Images lazy loaded
  [ ] Bundle size checked (no unnecessary imports)
""",
    "go": """
Go Code Review Checklist
━━━━━━━━━━━━━━━━━━━━━━━
Error Handling
  [ ] All errors checked, not assigned to _
  [ ] Errors wrapped with context (fmt.Errorf)
  [ ] No panic in library code
  [ ] Sentinel errors use errors.Is/As

Concurrency
  [ ] Goroutine leaks prevented (contexts used)
  [ ] Shared data protected by mutex or channels
  [ ] No race conditions (run with -race flag)
  [ ] WaitGroups properly used

Style
  [ ] gofmt applied
  [ ] Exported identifiers have comments
  [ ] Interfaces defined where used (consumer side)
  [ ] Error types capitalized only if exported

Testing
  [ ] Table-driven tests used
  [ ] Benchmarks for performance-critical code
  [ ] Testable interfaces (mocking possible)
""",
    "generic": """
Generic Code Review Checklist
━━━━━━━━━━━━━━━━━━━━━━━━━━━
Readability
  [ ] Variable/function names are descriptive
  [ ] No magic numbers (use named constants)
  [ ] Comments explain WHY, not WHAT
  [ ] Functions do one thing (< 40 lines ideal)

Correctness
  [ ] Edge cases handled (null/empty/boundary)
  [ ] Error handling present
  [ ] No dead code or unreachable branches
  [ ] Logic matches the intended behavior

Security
  [ ] No hardcoded credentials
  [ ] User input validated and sanitized
  [ ] Dependencies up to date
  [ ] Principle of least privilege applied

Maintainability
  [ ] DRY — no duplicated logic
  [ ] Testable (no hidden global state)
  [ ] Dependencies injected, not hardcoded
  [ ] Breaking changes documented
""",
}
print(checklists.get(lang, checklists["generic"]))
PYEOF
}

cmd_security() {
    local file="${1:-}"
    [ -z "$file" ] && echo "Usage: security <file>" && exit 1
    [ ! -f "$file" ] && echo "File not found: $file" && exit 1

    CR_FILE="$file" CR_LANG="$lang" python3 << 'PYEOF'
import re

with open("$file") as f:
    content = f.read()
    lines = content.split("\n")

findings = []

patterns = [
    (r'password\s*=\s*["\'][^"\']+["\']', "Hardcoded password"),
    (r'secret\s*=\s*["\'][^"\']+["\']', "Hardcoded secret"),
    (r'api_key\s*=\s*["\'][^"\']+["\']', "Hardcoded API key"),
    (r'token\s*=\s*["\'][^"\']+["\']', "Hardcoded token"),
    (r'eval\s*\(', "eval() — code injection risk"),
    (r'exec\s*\(', "exec() — code injection risk"),
    (r'os\.system\s*\(', "os.system() — shell injection risk"),
    (r'subprocess.*shell=True', "subprocess with shell=True — injection risk"),
    (r'SELECT.*\+.*WHERE', "Possible SQL injection (string concatenation)"),
    (r'innerHTML\s*=', "innerHTML assignment — XSS risk"),
    (r'document\.write\s*\(', "document.write() — XSS risk"),
    (r'md5\s*\(|MD5\s*\(', "MD5 usage — weak hash for security purposes"),
    (r'http://', "HTTP (not HTTPS) URL"),
    (r'0\.0\.0\.0', "Binding to all interfaces"),
]

for i, line in enumerate(lines, 1):
    for pattern, desc in patterns:
        if re.search(pattern, line, re.IGNORECASE):
            findings.append((i, desc, line.strip()[:80]))

print(f"\n🔒 Security Scan: $file\n")
if findings:
    print(f"⚠️  Found {len(findings)} potential issue(s):\n")
    for lineno, desc, snippet in findings:
        print(f"  Line {lineno}: [{desc}]")
        print(f"    {snippet}")
        print()
else:
    print("✅ No common security issues detected.")
    print("   Note: This is a pattern-based scan. Manual review still recommended.")
PYEOF
}

cmd_complexity() {
    local file="${1:-}"
    [ -z "$file" ] && echo "Usage: complexity <file>" && exit 1
    [ ! -f "$file" ] && echo "File not found: $file" && exit 1

    CR_FILE="$file" CR_LANG="$lang" python3 << 'PYEOF'
import re, os

with open("$file") as f:
    lines = f.readlines()

content = "".join(lines)
total = len(lines)
code_lines = sum(1 for l in lines if l.strip() and not l.strip().startswith("#"))

# Rough complexity indicators
branches = len(re.findall(r'\b(if|elif|else|for|while|try|except|case|switch)\b', content))
functions = len(re.findall(r'\bdef \w+|function \w+|\w+ := func|func \w+', content))
classes = len(re.findall(r'\bclass \w+|struct \w+|interface \w+', content))
nesting = max((len(l) - len(l.lstrip())) // 4 for l in lines if l.strip())
long_fns = len(re.findall(r'def .*:\n(?:(?!\ndef ).)*' * 40, content, re.DOTALL))

complexity_score = branches + nesting * 2
rating = "LOW ✅" if complexity_score < 20 else ("MEDIUM ⚠️" if complexity_score < 50 else "HIGH 🔴")

print(f"\n📊 Complexity Report: {os.path.basename('$file')}")
print(f"{'─'*40}")
print(f"  Total lines:       {total}")
print(f"  Code lines:        {code_lines}")
print(f"  Functions/methods: {functions}")
print(f"  Classes/structs:   {classes}")
print(f"  Branch statements: {branches}")
print(f"  Max nesting depth: {nesting} levels")
print(f"  Complexity score:  {complexity_score} ({rating})")
print()
if nesting > 4:
    print("  💡 Deep nesting detected — consider extracting functions")
if branches > 30:
    print("  💡 High branching — consider strategy pattern or early returns")
if functions > 0 and code_lines / functions > 50:
    print(f"  💡 Avg function size: {code_lines//functions} lines — consider splitting large functions")
PYEOF
}

cmd_diff() {
    local f1="${1:-}"; local f2="${2:-}"
    [ -z "$f1" ] || [ -z "$f2" ] && echo "Usage: diff <file1> <file2>" && exit 1
    diff --unified=3 "$f1" "$f2" | head -100 || true
    echo ""
    echo "Lines in $f1: $(wc -l < "$f1")"
    echo "Lines in $f2: $(wc -l < "$f2")"
}

case "$CMD" in
    review)     cmd_review "$@" ;;
    checklist)  cmd_checklist "$@" ;;
    security)   cmd_security "$@" ;;
    complexity) cmd_complexity "$@" ;;
    diff)       cmd_diff "$@" ;;
    help|--help|-h) show_help ;;
    *) echo "Unknown: $CMD"; show_help; exit 1 ;;
esac
