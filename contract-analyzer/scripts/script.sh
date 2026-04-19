#!/usr/bin/env bash
# contract-reviewer - AI-powered contract analysis toolkit
# Powered by BytesAgain | bytesagain.com

set -euo pipefail

COMMAND="${1:-help}"
shift || true

# ─── helpers ────────────────────────────────────────────────────────────────

die() { echo "ERROR: $*" >&2; exit 1; }

require_file() {
  [[ -n "${1:-}" ]] || die "No file specified. Usage: $COMMAND <file>"
  [[ -f "$1" ]]    || die "File not found: $1"
}

# ─── commands ───────────────────────────────────────────────────────────────

cmd_analyze() {
  require_file "${1:-}"
  local file="$1"
  echo "📄 Analyzing contract: $file"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  python3 -u - "$file" <<'PYEOF'
import sys, re

path = sys.argv[1]
try:
    text = open(path, encoding="utf-8", errors="replace").read()
except Exception as e:
    print(f"Cannot read file: {e}", file=sys.stderr)
    sys.exit(1)

# ── Party extraction ──────────────────────────────────────────────────────
party_patterns = [
    r"甲\s*方[：:]\s*([^\n，,。]{2,30})",
    r"乙\s*方[：:]\s*([^\n，,。]{2,30})",
    r"丙\s*方[：:]\s*([^\n，,。]{2,30})",
    r"(?:Party\s*A|Buyer|Employer)\s*[：:]\s*([^\n,]{2,50})",
    r"(?:Party\s*B|Seller|Contractor)\s*[：:]\s*([^\n,]{2,50})",
]
print("\n【当事人 / Parties】")
found_parties = []
for pat in party_patterns:
    for m in re.finditer(pat, text, re.IGNORECASE):
        val = m.group(1).strip()
        if val and val not in found_parties:
            found_parties.append(val)
            print(f"  • {val}")
if not found_parties:
    print("  （未检测到明确当事人）")

# ── Amount extraction ─────────────────────────────────────────────────────
amount_patterns = [
    r"(?:合同金额|合同总价|合同价款|总金额|价款)[：:\s]*([￥¥$€£]?\s*[\d,]+(?:\.\d+)?\s*(?:万?元|USD|EUR|GBP|CNY|RMB)?)",
    r"([￥¥$€£]\s*[\d,]+(?:\.\d+)?(?:\s*万?元)?)",
    r"([\d,]+(?:\.\d+)?\s*(?:万元|元整|元人民币|USD|CNY|RMB))",
    r"人民币[（(]?([^\n）)]{2,20})[）)]?整",
]
print("\n【金额 / Amounts】")
found_amounts = []
for pat in amount_patterns:
    for m in re.finditer(pat, text):
        val = m.group(1).strip()
        if val and val not in found_amounts:
            found_amounts.append(val)
            print(f"  • {val}")
if not found_amounts:
    print("  （未检测到金额信息）")

# ── Duration extraction ───────────────────────────────────────────────────
duration_patterns = [
    r"(?:合同期限|有效期限|服务期限|履行期)[：:\s]*([^\n，,。]{2,40})",
    r"(?:自|from)\s*([\d]{4}年[\d]{1,2}月[\d]{1,2}日).*?(?:至|to|until)\s*([\d]{4}年[\d]{1,2}月[\d]{1,2}日)",
    r"(?:期限|期间|duration|term)[：:\s]*(\d+\s*(?:年|个月|月|天|日|years?|months?|days?))",
    r"(\d{4}[-./年]\d{1,2}[-./月]\d{1,2})\s*[至~\-–—]\s*(\d{4}[-./年]\d{1,2}[-./月]\d{1,2})",
]
print("\n【期限 / Duration】")
found_durations = []
for pat in duration_patterns:
    for m in re.finditer(pat, text, re.IGNORECASE):
        val = " → ".join(g for g in m.groups() if g)
        if val and val not in found_durations:
            found_durations.append(val)
            print(f"  • {val}")
if not found_durations:
    print("  （未检测到明确期限）")

# ── Breach clauses ────────────────────────────────────────────────────────
breach_keywords = ["违约", "赔偿", "罚款", "解除", "终止", "违约金", "liquidated damages",
                   "breach", "penalty", "termination", "indemnif"]
print("\n【违约条款关键词 / Breach Keywords】")
found_breach = []
for kw in breach_keywords:
    if kw.lower() in text.lower():
        count = len(re.findall(re.escape(kw), text, re.IGNORECASE))
        found_breach.append((kw, count))
        print(f"  • '{kw}' — 出现 {count} 次")
if not found_breach:
    print("  （未检测到违约相关条款）")

print("\n✅ 分析完成")
PYEOF
}

# ─────────────────────────────────────────────────────────────────────────────

cmd_risk() {
  require_file "${1:-}"
  local file="$1"
  echo "⚠️  Risk Analysis: $file"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  python3 -u - "$file" <<'PYEOF'
import sys, re

path = sys.argv[1]
text = open(path, encoding="utf-8", errors="replace").read()

risk_terms = {
    "极高风险": [
        ("单方面", "允许一方无条件变更或终止合同"),
        ("免除一切", "免除方几乎无任何责任"),
        ("不可撤销地", "放弃撤销权，风险极大"),
        ("永久", "永久性义务/授权，需高度警惕"),
        ("无限", "无限责任/无限期，范围不明确"),
        ("绝对免责", "完全排除违约责任"),
    ],
    "高风险": [
        ("不可抗力", "不可抗力条款定义需审查"),
        ("自动续期", "可能无意延续合同"),
        ("单方修改", "允许一方单独修改合同条款"),
        ("不可转让", "转让权受限，影响业务灵活性"),
        ("独家", "独家条款可能限制商业机会"),
        ("保密期限", "保密期限是否合理"),
    ],
    "中风险": [
        ("仲裁", "解决争议方式，需确认地点和规则"),
        ("管辖", "争议管辖法院/机构，需审查"),
        ("适用法律", "合同适用法律，跨境需注意"),
        ("违约金", "违约金比例是否公平"),
        ("担保", "担保条款范围和条件"),
        ("知识产权", "IP归属和许可范围"),
    ],
}

hits = {}
for level, terms in risk_terms.items():
    for kw, desc in terms:
        pattern = re.compile(re.escape(kw), re.IGNORECASE)
        matches = pattern.findall(text)
        if matches:
            hits.setdefault(level, []).append((kw, desc, len(matches)))

# Score
score = 0
score += len(hits.get("极高风险", [])) * 30
score += len(hits.get("高风险",   [])) * 15
score += len(hits.get("中风险",   [])) * 5

if score >= 60:
    overall = "🔴 极高风险 (CRITICAL)"
elif score >= 30:
    overall = "🟠 高风险 (HIGH)"
elif score >= 10:
    overall = "🟡 中等风险 (MEDIUM)"
else:
    overall = "🟢 低风险 (LOW)"

print(f"\n综合风险评级: {overall}  (风险得分: {score})")

for level, items in hits.items():
    print(f"\n【{level}】")
    for kw, desc, cnt in items:
        print(f"  ⚠  '{kw}'（出现{cnt}次）— {desc}")

if not hits:
    print("\n✅ 未发现明显高风险条款")

print("\n📌 建议：请结合专业法律顾问意见进行最终判断。")
PYEOF
}

# ─────────────────────────────────────────────────────────────────────────────

cmd_compare() {
  require_file "${1:-}"
  require_file "${2:-}"
  local file1="$1"
  local file2="$2"
  echo "🔍 Comparing contracts:"
  echo "   A: $file1"
  echo "   B: $file2"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  python3 -u - "$file1" "$file2" <<'PYEOF'
import sys, difflib, re

def read_paragraphs(path):
    text = open(path, encoding="utf-8", errors="replace").read()
    # Split on blank lines or Chinese paragraph markers
    paras = re.split(r"\n\s*\n|(?=第[一二三四五六七八九十百]+条)", text)
    return [p.strip() for p in paras if p.strip()]

path_a, path_b = sys.argv[1], sys.argv[2]
paras_a = read_paragraphs(path_a)
paras_b = read_paragraphs(path_b)

matcher = difflib.SequenceMatcher(None, paras_a, paras_b, autojunk=False)
opcodes = matcher.get_opcodes()

added = removed = changed = 0
output_lines = []

for tag, i1, i2, j1, j2 in opcodes:
    if tag == "equal":
        continue
    elif tag == "replace":
        changed += 1
        for p in paras_a[i1:i2]:
            output_lines.append(f"  [-] {p[:120]}{'...' if len(p)>120 else ''}")
        for p in paras_b[j1:j2]:
            output_lines.append(f"  [+] {p[:120]}{'...' if len(p)>120 else ''}")
        output_lines.append("")
    elif tag == "delete":
        removed += 1
        for p in paras_a[i1:i2]:
            output_lines.append(f"  [-] {p[:120]}{'...' if len(p)>120 else ''}")
        output_lines.append("")
    elif tag == "insert":
        added += 1
        for p in paras_b[j1:j2]:
            output_lines.append(f"  [+] {p[:120]}{'...' if len(p)>120 else ''}")
        output_lines.append("")

similarity = matcher.ratio() * 100
print(f"\n相似度: {similarity:.1f}%")
print(f"段落变动: +{added} 新增  -{removed} 删除  ~{changed} 修改\n")

if output_lines:
    print("【差异详情】")
    for line in output_lines[:80]:   # cap output
        print(line)
    if len(output_lines) > 80:
        print(f"  … 还有更多差异（共 {len(output_lines)} 行）")
else:
    print("✅ 两份合同内容完全相同")
PYEOF
}

# ─────────────────────────────────────────────────────────────────────────────

cmd_summary() {
  require_file "${1:-}"
  local file="$1"
  echo "📋 Contract Summary: $file"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  python3 -u - "$file" <<'PYEOF'
import sys, re

path = sys.argv[1]
text = open(path, encoding="utf-8", errors="replace").read()

def first_match(patterns, text, default="未检测到"):
    for pat in patterns:
        m = re.search(pat, text, re.IGNORECASE)
        if m:
            return m.group(1).strip() if m.lastindex else m.group(0).strip()
    return default

# Contract type
type_patterns = [
    (r"购销合同",      "购销合同"),
    (r"服务合同|服务协议","服务合同"),
    (r"劳动合同",      "劳动合同"),
    (r"租赁合同",      "租赁合同"),
    (r"承揽合同",      "承揽合同"),
    (r"委托合同",      "委托合同"),
    (r"保密协议|NDA",  "保密协议(NDA)"),
    (r"框架协议",      "框架协议"),
    (r"合作协议",      "合作协议"),
]
contract_type = "未识别"
for pat, name in type_patterns:
    if re.search(pat, text, re.IGNORECASE):
        contract_type = name
        break

party_a = first_match([r"甲\s*方[：:]\s*([^\n，,。]{2,30})",
                        r"Party\s*A\s*[：:]\s*([^\n,]{2,50})"], text)
party_b = first_match([r"乙\s*方[：:]\s*([^\n，,。]{2,30})",
                        r"Party\s*B\s*[：:]\s*([^\n,]{2,50})"], text)

amount  = first_match([
    r"(?:合同金额|总金额|合同总价)[：:\s]*([^\n，,]{2,30})",
    r"([￥¥$€£][\d,]+(?:\.\d+)?(?:\s*万?元)?)",
    r"([\d,]+\s*万?元(?:人民币)?)",
], text)

duration = first_match([
    r"(?:合同期限|有效期限|履行期)[：:\s]*([^\n，,。]{2,40})",
    r"(?:期限)[：:\s]*(\d+\s*(?:年|个月|天))",
], text)

# Subject / scope
subject = first_match([
    r"(?:合同标的|标的物|服务内容|工作内容)[：:\s]*([^\n。]{5,80})",
    r"(?:甲方委托乙方|乙方同意)[^\n]{0,10}([^\n。]{5,60})",
], text)

# Special clauses detection
special = []
if re.search(r"保密|confidential", text, re.IGNORECASE):
    special.append("含保密条款")
if re.search(r"知识产权|intellectual property", text, re.IGNORECASE):
    special.append("含知识产权条款")
if re.search(r"竞业|non.?compet", text, re.IGNORECASE):
    special.append("含竞业限制条款")
if re.search(r"仲裁|arbitration", text, re.IGNORECASE):
    special.append("争议解决：仲裁")
if re.search(r"诉讼|litigation|court", text, re.IGNORECASE):
    special.append("争议解决：诉讼")

print(f"""
┌─────────────────────────────────────────┐
│           合同摘要 CONTRACT SUMMARY      │
├─────────────────────────────────────────┤
│ 合同类型: {contract_type:<30}│
│ 甲    方: {party_a[:30]:<30}│
│ 乙    方: {party_b[:30]:<30}│
│ 合同标的: {subject[:30]:<30}│
│ 合同金额: {amount[:30]:<30}│
│ 合同期限: {duration[:30]:<30}│
│ 特殊条款: {', '.join(special) if special else '无':<30}│
└─────────────────────────────────────────┘""")
PYEOF
}

# ─────────────────────────────────────────────────────────────────────────────

cmd_checklist() {
  echo "✅ 合同审查清单 (Contract Review Checklist)"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  cat <<'EOF'

 □  1. 当事人主体资格
       确认合同各方的法律主体资格（营业执照、授权书等）是否完整有效

 □  2. 合同标的明确性
       合同标的（货物/服务/工程等）是否描述清晰、无歧义

 □  3. 合同金额与支付条款
       金额、币种、支付方式、支付节点是否明确；有无预付款/尾款安排

 □  4. 合同期限与生效条件
       生效日期、终止日期、生效条件是否清晰；是否含自动续期条款

 □  5. 履约标准与验收条件
       交付标准、验收流程、验收时限是否明确；不合格品处理方式

 □  6. 违约责任条款
       违约情形、违约金计算方式、赔偿上限是否公平合理

 □  7. 不可抗力条款
       不可抗力定义范围是否合理；通知义务和期限是否明确

 □  8. 保密条款
       保密信息范围、保密义务期限、例外情形是否清晰

 □  9. 知识产权归属
       工作成果、发明创造的IP归属是否明确；有无授权许可条款

 □ 10. 争议解决机制
       选择仲裁还是诉讼；仲裁机构/法院、适用法律是否约定明确

 □ 11. 合同变更与终止条款
       变更程序（书面/口头）；单方解除权的触发条件和通知期限

 □ 12. 担保与抵押条款
       有无担保安排；担保范围、担保期限、担保物价值是否合理

 □ 13. 通知条款
       通知方式（邮件/快递/公告）；通知地址是否最新；送达生效规则

 □ 14. 合同附件与优先顺序
       附件（规格书/报价单/SLA等）是否齐全；与正文冲突时的优先级

 □ 15. 签署与盖章规范
       签署人是否有授权；骑缝章/公章/法人章使用是否规范；份数是否足够

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📌 提示：本清单为通用参考，具体合同请结合行业特点和专业法律意见进行审查。
EOF
}

# ─────────────────────────────────────────────────────────────────────────────

cmd_help() {
  cat <<'EOF'
contract-reviewer — 合同智能审查工具
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
USAGE:
  script.sh <command> [args]

COMMANDS:
  analyze  <file>         解析合同：提取当事人、金额、期限、违约条款
  risk     <file>         风险检测：识别高风险条款，输出风险等级
  compare  <file1> <file2> 合同对比：用 difflib 找出两份合同的差异
  summary  <file>         合同摘要：输出标准化摘要（当事人/标的/金额/期限）
  checklist               审查清单：15个合同审查检查项
  help                    显示此帮助

EXAMPLES:
  script.sh analyze  contract.txt
  script.sh risk     contract.pdf.txt
  script.sh compare  v1.txt v2.txt
  script.sh summary  contract.txt
  script.sh checklist

NOTES:
  • 支持 UTF-8 编码的纯文本文件（.txt）
  • PDF 请先用 pdftotext 转换后再分析
  • 本工具仅供参考，不构成法律意见

Powered by BytesAgain | bytesagain.com
EOF
}

# ─── dispatch ────────────────────────────────────────────────────────────────

case "$COMMAND" in
  analyze)   cmd_analyze  "$@" ;;
  risk)      cmd_risk     "$@" ;;
  compare)   cmd_compare  "$@" ;;
  summary)   cmd_summary  "$@" ;;
  checklist) cmd_checklist       ;;
  help|--help|-h) cmd_help      ;;
  *) echo "Unknown command: $COMMAND"; cmd_help; exit 1 ;;
esac
