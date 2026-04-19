#!/usr/bin/env bash
# clawhub-stats — 用token轮转拉ClawHub下载量，同步Supabase
# 方式与 skill-manager scan 相同：urllib + token轮转 + 0.3s间隔
set -euo pipefail

ENV_FILE="/home/admin/.openclaw/workspace/projects/crypto-content/.env"
SB_URL="https://jfpeycpiyayrpjldppzq.supabase.co"
SB_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmcGV5Y3BpeWF5cnBqbGRwcHpxIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NDIzODExMiwiZXhwIjoyMDg5ODE0MTEyfQ.lD7IcVeN47mUlrP43DFhY8-BAzn_gJAqfOBBBjteA0I"

# ── sync ──────────────────────────────────────────────────────────────────────
cmd_sync() {
    echo "[$(date '+%H:%M:%S')] 开始同步 ClawHub 下载量（按账号分组，各用各的token）..."
    python3 -u - << 'PYEOF'
import urllib.request, urllib.error, time, json
from datetime import datetime, timezone
from concurrent.futures import ThreadPoolExecutor, as_completed

ENV_FILE = "/home/admin/.openclaw/workspace/projects/crypto-content/.env"
SB_URL = "https://jfpeycpiyayrpjldppzq.supabase.co"
SB_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmcGV5Y3BpeWF5cnBqbGRwcHpxIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NDIzODExMiwiZXhwIjoyMDg5ODE0MTEyfQ.lD7IcVeN47mUlrP43DFhY8-BAzn_gJAqfOBBBjteA0I"

# 账号 → token编号映射
ACCOUNT_TOKEN_NUM = {
    "ckchzh":           2,
    "xueyetianya":      3,
    "bytesagain1":      4,
    "bytesagain3":      7,
    "bytesagain-lab":   8,
    "loutai0307-prog":  9,
    "PRESSBYTESAGAIN":  5,
}

# 读所有token
tokens = {}
for line in open(ENV_FILE):
    for i in range(1, 10):
        if line.startswith(f"CLAWHUB_TOKEN_{i}="):
            tokens[i] = line.strip().split("=", 1)[1]

OUR_ACCOUNTS = list(ACCOUNT_TOKEN_NUM.keys())
owner_filter = ",".join(OUR_ACCOUNTS)
h_sb = {"apikey": SB_KEY, "Authorization": f"Bearer {SB_KEY}", "Content-Type": "application/json"}

# 从Supabase读所有自有skill（含owner字段）
req = urllib.request.Request(
    f"{SB_URL}/rest/v1/skills?owner=in.({owner_filter})&select=slug,owner,downloads&limit=2000",
    headers=h_sb
)
with urllib.request.urlopen(req) as r:
    all_skills = json.loads(r.read())

# 按账号分组
from collections import defaultdict
by_owner = defaultdict(list)
for s in all_skills:
    by_owner[s["owner"]].append(s["slug"])

for owner, slugs in sorted(by_owner.items(), key=lambda x: -len(x[1])):
    tid = ACCOUNT_TOKEN_NUM.get(owner, 1)
    print(f"  {owner}: {len(slugs)}个skill → TOKEN_{tid}", flush=True)

print(f"\n总计: {len(all_skills)}个skill，{len(by_owner)}个账号", flush=True)

# 单账号同步函数
def sync_account(owner, slugs, token):
    updated = failed = skipped = 0
    now = datetime.now(timezone.utc).isoformat()
    for slug in slugs:
        try:
            req = urllib.request.Request(
                f"https://clawhub.ai/api/v1/skills/{slug}",
                headers={"Authorization": f"Bearer {token}"}
            )
            with urllib.request.urlopen(req, timeout=10) as resp:
                d = json.loads(resp.read())
            stats = (d.get("skill") or {}).get("stats") or {}
            patch = urllib.request.Request(
                f"{SB_URL}/rest/v1/skills?slug=eq.{slug}",
                data=json.dumps({
                    "downloads":        stats.get("downloads", 0),
                    "installs_current": stats.get("installsCurrent", 0),
                    "installs_all_time":stats.get("installsAllTime", 0),
                    "stars":            stats.get("stars", 0),
                    "updated_at_clawhub": now
                }).encode(),
                headers={**h_sb, "Prefer": "return=minimal"},
                method="PATCH"
            )
            urllib.request.urlopen(patch, timeout=10)
            updated += 1
        except urllib.error.HTTPError as e:
            if e.code == 429:
                print(f"  [{owner}] 429 → 等30s", flush=True)
                time.sleep(30)
            elif e.code == 404:
                skipped += 1
            else:
                failed += 1
        except Exception:
            failed += 1
        time.sleep(0.5)  # 每个账号自己控速，0.5s间隔
    return owner, updated, failed, skipped

# 并行跑所有账号
total_updated = total_failed = total_skipped = 0
with ThreadPoolExecutor(max_workers=6) as ex:
    futures = [
        ex.submit(sync_account, owner, slugs, tokens.get(ACCOUNT_TOKEN_NUM.get(owner, 1), list(tokens.values())[0]))
        for owner, slugs in by_owner.items()
    ]
    for f in as_completed(futures):
        owner, u, fail, skip = f.result()
        total_updated += u; total_failed += fail; total_skipped += skip
        print(f"  ✅ {owner}: 更新{u} 失败{fail} 跳过{skip}", flush=True)

print(f"\n✅ 同步完成: 更新{total_updated} | 失败{total_failed} | 跳过{total_skipped}", flush=True)
PYEOF
}

# ── report ────────────────────────────────────────────────────────────────────
cmd_report() {
    echo "[$(date '+%H:%M:%S')] 生成下载量报告..."
    python3 -u - << 'PYEOF'
import urllib.request, json
from datetime import datetime

SB_URL = "https://jfpeycpiyayrpjldppzq.supabase.co"
SB_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmcGV5Y3BpeWF5cnBqbGRwcHpxIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NDIzODExMiwiZXhwIjoyMDg5ODE0MTEyfQ.lD7IcVeN47mUlrP43DFhY8-BAzn_gJAqfOBBBjteA0I"
OUR_ACCOUNTS = ["ckchzh","xueyetianya","bytesagain1","loutai0307-prog","bytesagain3","bytesagain-lab","PRESSBYTESAGAIN"]
owner_filter = ",".join(OUR_ACCOUNTS)

h = {"apikey": SB_KEY, "Authorization": f"Bearer {SB_KEY}"}
req = urllib.request.Request(
    f"{SB_URL}/rest/v1/skills?owner=in.({owner_filter})&select=slug,owner,downloads,updated_at_clawhub&limit=2000",
    headers=h
)
with urllib.request.urlopen(req) as r:
    skills = json.loads(r.read())

total_dl = sum(s.get("downloads") or 0 for s in skills)
by_owner = {}
for s in skills:
    o = s.get("owner","?")
    if o not in by_owner:
        by_owner[o] = {"count":0,"downloads":0}
    by_owner[o]["count"] += 1
    by_owner[o]["downloads"] += s.get("downloads") or 0

top10 = sorted(skills, key=lambda x: x.get("downloads") or 0, reverse=True)[:10]

print(f"\n=== ClawHub 下载量报告 {datetime.now().strftime('%Y-%m-%d %H:%M')} ===")
print(f"自有skill: {len(skills)}个 | 总下载: {total_dl:,}")
print()
print("账号分布:")
for o, d in sorted(by_owner.items(), key=lambda x: -x[1]["downloads"]):
    print(f"  {o}: {d['count']}个 / {d['downloads']:,}dl")
print()
print("Top 10:")
for i, s in enumerate(top10, 1):
    print(f"  {i:2}. {s['slug']} — {s.get('downloads',0):,}dl ({s['owner']})")
PYEOF
}

# ── check ─────────────────────────────────────────────────────────────────────
cmd_check() {
    echo "检查 Token 有效性..."
    python3 -u - << 'PYEOF'
import urllib.request, urllib.error, json

ENV_FILE = "/home/admin/.openclaw/workspace/projects/crypto-content/.env"
ACCOUNT_NUM = {"1":"bytesagain","2":"ckchzh","3":"xueyetianya","4":"bytesagain1",
               "5":"loutai0307-prog","7":"bytesagain3","8":"bytesagain-lab","9":"PRESSBYTESAGAIN"}
for line in open(ENV_FILE):
    line = line.strip()
    for num, acc in ACCOUNT_NUM.items():
        if line.startswith(f"CLAWHUB_TOKEN_{num}="):
            token = line.split("=",1)[1]
            try:
                req = urllib.request.Request(
                    "https://clawhub.ai/api/v1/whoami",
                    headers={"Authorization": f"Bearer {token}"}
                )
                with urllib.request.urlopen(req, timeout=10) as r:
                    data = json.loads(r.read())
                name = data.get("username") or data.get("handle") or "?"
                print(f"  ✅ TOKEN_{num} ({acc}): {name}")
            except urllib.error.HTTPError as e:
                print(f"  ❌ TOKEN_{num} ({acc}): HTTP {e.code}")
            except Exception as e:
                print(f"  ❌ TOKEN_{num} ({acc}): {e}")
PYEOF
}

# ── notify ───────────────────────────────────────────────────────────────────
cmd_notify() {
    python3 -u - << 'PYEOF'
import urllib.request, json, os
from datetime import datetime

SB_URL = "https://jfpeycpiyayrpjldppzq.supabase.co"
SB_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmcGV5Y3BpeWF5cnBqbGRwcHpxIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NDIzODExMiwiZXhwIjoyMDg5ODE0MTEyfQ.lD7IcVeN47mUlrP43DFhY8-BAzn_gJAqfOBBBjteA0I"
OUR_ACCOUNTS = ["ckchzh","xueyetianya","bytesagain1","loutai0307-prog","bytesagain3","bytesagain-lab","PRESSBYTESAGAIN"]
owner_filter = ",".join(OUR_ACCOUNTS)
SNAPSHOT = "/tmp/hub-stats-snapshot.json"

h = {"apikey": SB_KEY, "Authorization": f"Bearer {SB_KEY}"}
req = urllib.request.Request(
    f"{SB_URL}/rest/v1/skills?owner=in.({owner_filter})&select=slug,owner,downloads,installs_current,installs_all_time,stars&limit=2000",
    headers=h
)
with urllib.request.urlopen(req) as r:
    skills = json.loads(r.read())

# 读昨日快照
try:
    yesterday = json.load(open(SNAPSHOT)) if os.path.exists(SNAPSHOT) else {}
except:
    yesterday = {}

# 计算增量
curr = {s["slug"]: s.get("downloads") or 0 for s in skills}
delta_map = {slug: curr[slug] - yesterday.get(slug, curr[slug]) for slug in curr}
total_delta = sum(delta_map.values())

# 增量 top10
top10_delta = sorted(delta_map.items(), key=lambda x: -x[1])[:10]
top10_delta = [(sl, d) for sl, d in top10_delta if d > 0]

total_dl = sum(curr.values())
total_inst = sum(s.get("installs_current") or 0 for s in skills)
total_inst_all = sum(s.get("installs_all_time") or 0 for s in skills)
total_stars = sum(s.get("stars") or 0 for s in skills)

# 保存当前快照
with open(SNAPSHOT, "w") as f:
    json.dump(curr, f)

top10_dl = sorted(skills, key=lambda x: x.get("downloads") or 0, reverse=True)[:10]

ts = datetime.now().strftime("%m-%d %H:%M")
delta_str = f"+{total_delta:,}" if total_delta >= 0 else f"{total_delta:,}"

lines = [
    f"=== Hub Stats {ts} ===",
    f"Skills: {len(skills)} active",
    f"Downloads: {total_dl:,} ({delta_str} vs yesterday)",
    f"Installs: {total_inst:,} (all-time: {total_inst_all:,})",
    f"Stars: {total_stars}",
    "",
    "Top 10 Downloads:",
]
for i, s in enumerate(top10_dl, 1):
    lines.append(f"  {i:2}. {s['slug']} \u2014 {s.get('downloads',0):,}dl")

if top10_delta:
    lines.append("")
    lines.append("Top 10 增量:")
    for i, (sl, d) in enumerate(top10_delta, 1):
        lines.append(f"  {i:2}. {sl} +{d:,}dl")

output = "\n".join(lines)
with open("/tmp/hub-stats-notify.txt", "w") as f:
    f.write(output)
print(output)
print("\n\u2705 hub-stats-notify.txt 已更新")
PYEOF
}

# ── help ──────────────────────────────────────────────────────────────────────
cmd_help() {
    cat << 'EOF'
clawhub-stats — ClawHub 下载量同步工具（自用）

Commands:
  sync     用token轮转拉取所有自有skill下载量并写入Supabase
  report   生成下载量报告（Top10 + 账号分布）
  check    检查所有token有效性
  help     显示帮助

特点:
  - token轮转（9个账号轮流用），与 skill-manager scan 方式相同
  - 0.3秒间隔，更快更稳定
  - 429时等60秒重试
  - urllib（无外部依赖）

EOF
}

case "${1:-help}" in
    sync)   cmd_sync ;;
    notify) cmd_notify ;;
    report) cmd_report ;;
    check)  cmd_check ;;
    help|*) cmd_help ;;
esac
