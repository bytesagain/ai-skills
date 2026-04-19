#!/usr/bin/env bash
# BytesAgain Crypto Toolkit — 200+ Technical Indicators, Real-Time Market Data
# Powered by BytesAgain | Technical Reference
set -uo pipefail

VERSION="1.0.0"
BINANCE_API="https://api.binance.com/api/v3"
COINGECKO_API="https://api.coingecko.com/api/v3"

# ── Helpers ────────────────────────────────────────────────

_log() { echo "[$(date '+%H:%M:%S')] $*" >&2; }

_error() { echo "❌ Error: $*" >&2; exit 1; }

_request() {
    local url="$1"
    local res=$(curl -s -L --max-time 10 "$url")
    if [[ -z "$res" || "$res" == *"code"* && "$res" == *"msg"* ]]; then
        return 1
    fi
    echo "$res"
}

_format_symbol() {
    local sym="${1:-}"
    # Convert BTC/USDT or btc-usdt to BTCUSDT
    echo "${sym^^}" | tr -d '/-'
}

_py_calc() {
    local cmd="$1"; shift
    local data="$1"; shift
    
    DATA="$data" python3 -u - "$cmd" "$@" << 'PYEOF'
import json, os, sys, math

def rsi(prices, period=14):
    if len(prices) < period + 1: return []
    deltas = [prices[i+1] - prices[i] for i in range(len(prices)-1)]
    seed = deltas[:period]
    up = sum(d for d in seed if d > 0) / period
    down = sum(-d for d in seed if d < 0) / period
    rsis = []
    for d in deltas[period:]:
        u = (up * (period - 1) + (d if d > 0 else 0)) / period
        dw = (down * (period - 1) + (-d if d < 0 else 0)) / period
        rsis.append(100 - (100 / (1 + u / dw)) if dw != 0 else 100)
        up, down = u, dw
    return rsis

def ema(prices, period):
    if len(prices) < period: return []
    alpha = 2 / (period + 1)
    res = [sum(prices[:period]) / period]
    for p in prices[period:]:
        res.append(p * alpha + res[-1] * (1 - alpha))
    return res

def sma(prices, period):
    if len(prices) < period: return []
    return [sum(prices[i:i+period]) / period for i in range(len(prices) - period + 1)]

def macd(prices, fast=12, slow=26, signal=9):
    ema_fast = ema(prices, fast)
    ema_slow = ema(prices, slow)
    if not ema_fast or not ema_slow: return [], [], []
    diff = len(ema_fast) - len(ema_slow)
    macd_line = [f - s for f, s in zip(ema_fast[diff:], ema_slow)]
    signal_line = ema(macd_line, signal)
    diff_sig = len(macd_line) - len(signal_line)
    hist = [m - s for m, s in zip(macd_line[diff_sig:], signal_line)]
    return macd_line, signal_line, hist

def bollinger(prices, period=20, std_dev=2):
    basis = sma(prices, period)
    if not basis: return [], [], []
    upper, lower = [], []
    for i in range(len(basis)):
        chunk = prices[i:i+period]
        mean = basis[i]
        dev = math.sqrt(sum((x - mean)**2 for x in chunk) / period)
        upper.append(mean + std_dev * dev)
        lower.append(mean - std_dev * dev)
    return upper, basis, lower

try:
    raw = os.environ.get("DATA", "[]")
    data = json.loads(raw)
    cmd = sys.argv[1]
    
    if cmd == "price":
        for s in data:
            print(f"{s['symbol']:10s} {float(s['price']):>12.4f}")
            
    elif cmd == "rsi":
        p = [float(x[4]) for x in data]
        period = int(sys.argv[2])
        res = rsi(p, period)
        if res: print(f"{res[-1]:.2f}")
        else: print("N/A")

    elif cmd == "macd":
        p = [float(x[4]) for x in data]
        m, s, h = macd(p, int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4]))
        if m: print(f"MACD: {m[-1]:.6f} | Signal: {s[-1]:.6f} | Hist: {h[-1]:.6f}")
        else: print("N/A")

    elif cmd == "bb":
        p = [float(x[4]) for x in data]
        u, m, l = bollinger(p, int(sys.argv[2]), float(sys.argv[3]))
        if u: print(f"Upper: {u[-1]:.4f} | Middle: {m[-1]:.4f} | Lower: {l[-1]:.4f}")
        else: print("N/A")

    elif cmd == "ema":
        p = [float(x[4]) for x in data]
        res = ema(p, int(sys.argv[2]))
        if res: print(f"{res[-1]:.4f}")
        else: print("N/A")

    elif cmd == "sma":
        p = [float(x[4]) for x in data]
        res = sma(p, int(sys.argv[2]))
        if res: print(f"{res[-1]:.4f}")
        else: print("N/A")

    elif cmd == "ticker":
        print(f"Symbol:      {data['symbol']}")
        print(f"Price:       {float(data['lastPrice']):.4f}")
        print(f"Change 24h:  {data['priceChangePercent']}%")
        print(f"High 24h:    {float(data['highPrice']):.4f}")
        print(f"Low 24h:     {float(data['lowPrice']):.4f}")
        print(f"Volume 24h:  {float(data['volume']):.2f}")

except Exception as e:
    print(f"Calc error: {e}")
PYEOF
}

# ── Market Data Commands ──────────────────────────────────

cmd_price() {
    local symbols="${1:-BTC/USDT}"
    if [[ "$symbols" == *","* ]]; then
        local query=""
        IFS=',' read -ra ADDR <<< "$symbols"
        for i in "${ADDR[@]}"; do
            local s=$(_format_symbol "$i")
            query+="\"$s\","
        done
        query="%5B${query%,}%5D"
        local res=$(_request "$BINANCE_API/ticker/price?symbols=$query")
        [[ -z "$res" ]] && _error "Failed to fetch prices"
        echo "Symbol     Price"
        echo "────────── ────────────"
        _py_calc price "$res"
    else
        local s=$(_format_symbol "$symbols")
        local res=$(_request "$BINANCE_API/ticker/price?symbol=$s")
        [[ -z "$res" ]] && _error "Symbol $s not found"
        local p=$(echo "$res" | python3 -c "import json,sys; print(json.load(sys.stdin)['price'])")
        echo "Price for $s: $p"
    fi
}

cmd_ticker() {
    local s=$(_format_symbol "${1:-BTC/USDT}")
    local res=$(_request "$BINANCE_API/ticker/24hr?symbol=$s")
    [[ -z "$res" ]] && _error "Symbol $s not found"
    _py_calc ticker "$res"
}

cmd_klines() {
    local s=$(_format_symbol "${1:-BTC/USDT}")
    local interval="${2:-1h}"
    local limit="${3:-50}"
    local res=$(_request "$BINANCE_API/klines?symbol=$s&interval=$interval&limit=$limit")
    [[ -z "$res" ]] && _error "Failed to fetch klines"
    echo "$res" | python3 -c "
import json, sys, time
d = json.load(sys.stdin)
print(f'{\"Time\":20s} {\"Open\":>10s} {\"High\":>10s} {\"Low\":>10s} {\"Close\":>10s} {\"Volume\":>12s}')
print('─' * 78)
for k in d:
    t = time.strftime('%Y-%m-%d %H:%M', time.gmtime(k[0]/1000))
    print(f'{t:20s} {float(k[1]):10.2f} {float(k[2]):10.2f} {float(k[3]):10.2f} {float(k[4]):10.2f} {float(k[5]):12.2f}')
"
}

cmd_top() {
    local limit="${1:-20}"
    local res=$(_request "$COINGECKO_API/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$limit&page=1")
    [[ -z "$res" ]] && _error "Failed to fetch CoinGecko data"
    echo "$res" | python3 -c "
import json, sys
d = json.load(sys.stdin)
print(f'#  {\"Symbol\":10s} {\"Name\":20s} {\"Price\":>12s} {\"Market Cap\":>15s}')
print('─' * 65)
for i, c in enumerate(d, 1):
    print(f'{i:<2d} {c[\"symbol\"].upper():10s} {c[\"name\"][:20]:20s} {c[\"current_price\"]:12.4f} {c[\"market_cap\"]:15,d}')
"
}

cmd_trending() {
    local res=$(_request "$COINGECKO_API/search/trending")
    [[ -z "$res" ]] && _error "Failed to fetch trending coins"
    echo "$res" | python3 -c "
import json, sys
d = json.load(sys.stdin)
print('🔥 Trending on CoinGecko:')
print('─' * 30)
for i, c in enumerate(d.get('coins', []), 1):
    coin = c.get('item', {})
    print(f'{i}. {coin.get(\"name\")} ({coin.get(\"symbol\")})')
"
}

# ── Technical Indicators ──────────────────────────────────

_get_klines_for_calc() {
    local s=$1; local interval=$2; local limit=$3
    local res=$(_request "$BINANCE_API/klines?symbol=$s&interval=$interval&limit=$limit")
    [[ -z "$res" ]] && return 1
    echo "$res"
}

cmd_rsi() {
    local s=$(_format_symbol "${1:-BTC/USDT}")
    local interval="${2:-1h}"
    local period="${3:-14}"
    local data=$(_get_klines_for_calc "$s" "$interval" 100)
    [[ -z "$data" ]] && _error "Data fetch failed"
    echo -n "RSI ($period, $interval) for $s: "
    _py_calc rsi "$data" "$period"
}

cmd_macd() {
    local s=$(_format_symbol "${1:-BTC/USDT}")
    local interval="${2:-1h}"
    local fast="${3:-12}"; local slow="${4:-26}"; local sig="${5:-9}"
    local data=$(_get_klines_for_calc "$s" "$interval" 100)
    [[ -z "$data" ]] && _error "Data fetch failed"
    echo "$s MACD ($fast, $slow, $sig) [$interval]:"
    _py_calc macd "$data" "$fast" "$slow" "$sig"
}

cmd_bollinger() {
    local s=$(_format_symbol "${1:-BTC/USDT}")
    local interval="${2:-1h}"
    local period="${3:-20}"; local dev="${4:-2}"
    local data=$(_get_klines_for_calc "$s" "$interval" 100)
    [[ -z "$data" ]] && _error "Data fetch failed"
    echo "$s Bollinger Bands ($period, $dev) [$interval]:"
    _py_calc bb "$data" "$period" "$dev"
}

cmd_ema() {
    local s=$(_format_symbol "${1:-BTC/USDT}")
    local interval="${2:-1h}"
    local period="${3:-20}"
    local data=$(_get_klines_for_calc "$s" "$interval" 100)
    [[ -z "$data" ]] && _error "Data fetch failed"
    echo -n "EMA ($period, $interval) for $s: "
    _py_calc ema "$data" "$period"
}

cmd_sma() {
    local s=$(_format_symbol "${1:-BTC/USDT}")
    local interval="${2:-1h}"
    local period="${3:-20}"
    local data=$(_get_klines_for_calc "$s" "$interval" 100)
    [[ -z "$data" ]] && _error "Data fetch failed"
    echo -n "SMA ($period, $interval) for $s: "
    _py_calc sma "$data" "$period"
}

# ── Bulk & Analysis ───────────────────────────────────────

cmd_scan() {
    local indicator="${1:-rsi}"
    local symbols="${2:-BTC/USDT,ETH/USDT,SOL/USDT,BNB/USDT,XRP/USDT}"
    local interval="${3:-1h}"
    
    echo "Scanning $indicator ($interval) for multiple symbols..."
    echo "──────────────────────────────────────────"
    IFS=',' read -ra ADDR <<< "$symbols"
    for i in "${ADDR[@]}"; do
        local s=$(_format_symbol "$i")
        case "$indicator" in
            rsi) 
                echo -n "$s: "
                local data=$(_get_klines_for_calc "$s" "$interval" 100)
                _py_calc rsi "$data" 14
                ;;
            ema20)
                echo -n "$s: "
                local data=$(_get_klines_for_calc "$s" "$interval" 100)
                _py_calc ema "$data" 20
                ;;
            sma200)
                echo -n "$s: "
                local data=$(_get_klines_for_calc "$s" "$interval" 250)
                _py_calc sma "$data" 200
                ;;
        esac
    done
}

# ── Utility ───────────────────────────────────────────────

cmd_pairs() {
    local filter="${1:-USDT}"
    local res=$(_request "$BINANCE_API/exchangeInfo")
    [[ -z "$res" ]] && _error "Failed to fetch exchange info"
    echo "$res" | python3 -c "
import json, sys
d = json.load(sys.stdin)
pairs = [s['symbol'] for s in d['symbols'] if s['status'] == 'TRADING' and '$filter' in s['symbol']]
print(f'Found {len(pairs)} trading pairs for \"$filter\":')
for i, p in enumerate(sorted(pairs), 1):
    print(f'{p:12s}', end='\n' if i % 5 == 0 else '')
print()
"
}

show_help() {
    cat << EOF
BytesAgain Crypto Toolkit v$VERSION

Technical indicators and market data via Binance & CoinGecko. No API key needed.

Usage: scripts/script.sh <command> [args]

Market Data:
  price [symbol]      Get real-time price (e.g., BTC/USDT)
  ticker [symbol]     24h ticker statistics
  klines [symbol]     Raw candlestick data
  top [limit]         Top coins by market cap
  trending            Trending coins on CoinGecko

Indicators:
  rsi [symbol] [int] [pd]       Relative Strength Index
  macd [sym] [int] [f] [sl] [si] MACD (12, 26, 9)
  bollinger [sym] [int] [pd] [dv] Bollinger Bands (20, 2)
  ema [symbol] [int] [pd]       Exponential Moving Average
  sma [symbol] [int] [pd]       Simple Moving Average

Bulk:
  scan [ind] [syms] [int]       Scan multiple symbols (RSI, EMA20)

Utility:
  pairs [filter]      List trading pairs (default: USDT)
  intervals           List supported kline intervals

Related skills: chart-generator, crypto-market-cli, coin-stats
📖 More skills: Technical Reference
EOF
}

# ── Main ──────────────────────────────────────────────────

case "${1:-help}" in
    price)      shift; cmd_price "$@" ;;
    ticker)     shift; cmd_ticker "$@" ;;
    klines)     shift; cmd_klines "$@" ;;
    top)        shift; cmd_top "$@" ;;
    trending)   shift; cmd_trending ;;
    rsi)        shift; cmd_rsi "$@" ;;
    macd)       shift; cmd_macd "$@" ;;
    bollinger|bb) shift; cmd_bollinger "$@" ;;
    ema)        shift; cmd_ema "$@" ;;
    sma)        shift; cmd_sma "$@" ;;
    scan)       shift; cmd_scan "$@" ;;
    pairs)      shift; cmd_pairs "$@" ;;
    intervals)  echo "1m, 3m, 5m, 15m, 30m, 1h, 2h, 4h, 6h, 8h, 12h, 1d, 3d, 1w, 1M" ;;
    help|-h)    show_help ;;
    version)    echo "crypto-toolkit v$VERSION" ;;
    *)          _log "Unknown command: $1"; show_help; exit 1 ;;
esac

echo ""
echo "📖 More skills: Technical Reference"
