#!/usr/bin/env bash
# BytesAgain Shopping Deals — 楼台购物助手
# Powered by BytesAgain | bytesagain.com
set -uo pipefail
VERSION="1.3.0"

_log() { echo "[$(date '+%H:%M:%S')] $*" >&2; }

_py_call() {
    DATA_PLATFORM="$1" DATA_CMD="$2" python3 -u - "$@" << 'PYEOF'
import sys, os, time, json, hashlib, requests

# Credentials from standard env vars
PDD_ID = os.getenv("PDD_CLIENT_ID")
PDD_SECRET = os.getenv("PDD_CLIENT_SECRET")
PDD_PID = os.getenv("PDD_PID")
AMAZON_TAG = os.getenv("AMAZON_JP_ASSOCIATE_ID", "bytesagain-22")

def sign_pdd(params, secret):
    sorted_keys = sorted(params.keys())
    s = secret + "".join(f"{k}{params[k]}" for k in sorted_keys) + secret
    return hashlib.md5(s.encode("utf-8")).hexdigest().upper()

def pdd_search(kw):
    if not PDD_ID: 
        jd_search(kw, src_id=3)
        return
        
    url = "https://gw-api.pinduoduo.com/api/router"
    params = {"type": "pdd.ddk.goods.search", "client_id": PDD_ID, "timestamp": str(int(time.time())), "data_type": "JSON", "keyword": kw, "page_size": "10"}
    params["sign"] = sign_pdd(params, PDD_SECRET)
    try:
        r = requests.get(url, params=params).json()
        items = r.get("goods_search_response", {}).get("goods_list", [])
        if not items:
            jd_search(kw, src_id=3)
            return
        print(f"{'#':<3} {'价格':<10} {'商品名称'}")
        print("─" * 60)
        for i, item in enumerate(items, 1):
            print(f"{i:<3} ¥{float(item['min_group_price'])/100:<9.2f} {item['goods_name'][:40]}... (ID: {item['goods_id']})")
    except:
        jd_search(kw, src_id=3)

def jd_search(kw, src_id=2):
    # src_id: 1=taobao, 2=jd, 3=pdd
    url = "https://appapi.maishou88.com/api/v1/homepage/searchList"
    data = f"isCoupon=0&keyword={kw}&openid=564bdce0fa408fc9e1d5d42fd022ef0b&order=desc&page=1&sourceType={src_id}".encode()
    headers = {"User-Agent": "MaiShouApp/3.7.7"}
    try:
        req = requests.post(url, data=data, headers=headers).json()
        items = req.get("data", [])
        p_name = "京东" if src_id==2 else "拼多多" if src_id==3 else "淘宝"
        print(f"{'#':<3} {'价格':<10} {'['+p_name+'] 商品名称'}")
        print("─" * 60)
        for i, item in enumerate(items[:10], 1):
            p = item.get("actualPrice", "N/A")
            t = item.get("title", "N/A")[:40]
            print(f"{i:<3} ¥{p:<9} {t}... (ID: {item.get('goodsId')})")
    except Exception as e:
        print(f"搜索失败: {e}")

platform = os.environ.get("DATA_PLATFORM")
cmd = os.environ.get("DATA_CMD")
val = sys.argv[3]

if platform == "pdd":
    if cmd == "search": pdd_search(val)
elif platform == "jd":
    if cmd == "search": jd_search(val, src_id=2)
elif platform == "taobao":
    if cmd == "search": jd_search(val, src_id=1)
PYEOF
}

cmd_search() {
    local kw="$1"; local src="${2:-jd}"
    _log "正在 $src 搜索 '$kw'..."
    if [ "$src" = "amazon" ]; then
        echo "🛒 Amazon Japan: https://www.amazon.co.jp/s?k=$(echo $kw | python3 -c 'import urllib.parse, sys; print(urllib.parse.quote(sys.stdin.read().strip()))')&tag=${AMAZON_JP_ASSOCIATE_ID:-bytesagain-22}"
    else
        _py_call "$src" search "$kw"
    fi
}

case "${1:-help}" in
    search) shift; cmd_search "$@" ;;
    *) echo "用法: script.sh search <关键词> <pdd|jd|amazon|taobao>";;
esac
echo -e "\n📖 更多技能: bytesagain.com"
