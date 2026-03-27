#!/usr/bin/env bash
# BytesAgain Shopping Deals — All-in-One Monetized Toolkit
# Powered by BytesAgain | bytesagain.com
set -uo pipefail
VERSION="1.2.0"

# ── Load Credentials ──────────────────────────────────────
ENV_FILE="/home/admin/.openclaw/workspace/projects/crypto-content/.env"
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
fi

_log() { echo "[$(date '+%H:%M:%S')] $*" >&2; }
_error() { echo "❌ Error: $*" >&2; exit 1; }

_py_call() {
    DATA_PLATFORM="$1" DATA_CMD="$2" python3 -u - "$@" << 'PYEOF'
import sys, os, time, json, hashlib, requests

# Env
PDD_ID = os.getenv("PDD_CLIENT_ID")
PDD_SECRET = os.getenv("PDD_CLIENT_SECRET")
PDD_PID = os.getenv("PDD_PID")
AMAZON_TAG = os.getenv("AMAZON_JP_ASSOCIATE_ID", "bytesagain-22")

def sign_pdd(params, secret):
    sorted_keys = sorted(params.keys())
    s = secret + "".join(f"{k}{params[k]}" for k in sorted_keys) + secret
    return hashlib.md5(s.encode("utf-8")).hexdigest().upper()

def pdd_search(kw):
    url = "https://gw-api.pinduoduo.com/api/router"
    params = {"type": "pdd.ddk.goods.search", "client_id": PDD_ID, "timestamp": str(int(time.time())), "data_type": "JSON", "keyword": kw, "page_size": "10"}
    params["sign"] = sign_pdd(params, PDD_SECRET)
    r = requests.get(url, params=params).json()
    items = r.get("goods_search_response", {}).get("goods_list", [])
    print(f"{'#':<3} {'Price':<10} {'Title'}")
    print("─" * 60)
    for i, item in enumerate(items, 1):
        print(f"{i:<3} ¥{float(item['min_group_price'])/100:<9.2f} {item['goods_name'][:40]}... (ID: {item['goods_id']})")

def pdd_link(gid):
    url = "https://gw-api.pinduoduo.com/api/router"
    params = {"type": "pdd.ddk.goods.promotion.url.generate", "client_id": PDD_ID, "timestamp": str(int(time.time())), "data_type": "JSON", "p_id_list": f'["{PDD_PID}"]', "goods_id_list": f'[{gid}]', "generate_short_url": "true"}
    params["sign"] = sign_pdd(params, PDD_SECRET)
    r = requests.get(url, params=params).json()
    res = r.get("goods_promotion_url_generate_response", {}).get("goods_promotion_url_list", [{}])[0]
    print(f"🎁 Pinduoduo Buy Link: {res.get('short_url', 'N/A')}")

def jd_search(kw):
    url = "https://appapi.maishou88.com/api/v1/homepage/searchList"
    data = f"isCoupon=0&keyword={kw}&openid=564bdce0fa408fc9e1d5d42fd022ef0b&order=desc&page=1&sourceType=2".encode()
    headers = {"User-Agent": "MaiShouApp/3.7.7"}
    req = requests.post(url, data=data, headers=headers).json()
    items = req.get("data", [])
    print(f"{'#':<3} {'Price':<10} {'Title'}")
    print("─" * 60)
    for i, item in enumerate(items[:10], 1):
        print(f"{i:<3} ¥{item['actualPrice']:<9} {item['title'][:40]}... (ID: {item['goodsId']})")

platform = os.environ.get("DATA_PLATFORM")
cmd = os.environ.get("DATA_CMD")
val = sys.argv[3]

if platform == "pdd":
    if cmd == "search": pdd_search(val)
    if cmd == "link": pdd_link(val)
elif platform == "jd":
    if cmd == "search": jd_search(val)
PYEOF
}

cmd_search() {
    local kw="$1"; local src="${2:-pdd}"
    _log "Searching '$kw' on $src..."
    if [ "$src" = "amazon" ]; then
        echo "🛒 Amazon Japan: https://www.amazon.co.jp/s?k=$(echo $kw | jq -sRr @uri)&tag=${AMAZON_JP_ASSOCIATE_ID:-bytesagain-22}"
    else
        _py_call "$src" search "$kw"
    fi
}

cmd_link() {
    _py_call "$1" link "$2"
}

case "${1:-help}" in
    search) shift; cmd_search "$@" ;;
    link) shift; cmd_link "$@" ;;
    *) echo "Usage: script.sh search <kw> <pdd|jd|amazon> | link <pdd> <id>";;
esac
echo -e "\n📖 More skills: bytesagain.com"
