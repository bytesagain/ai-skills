#!/bin/bash
# crypto-market-cli — Crypto Market Data Tool
# Original implementation by BytesAgain

CACHE_DIR="${HOME}/.crypto-market"
mkdir -p "$CACHE_DIR"

show_help() {
    cat << 'HELP'
Crypto Market CLI — Real-time crypto market data & analysis

Commands:
  price     Get current price of a cryptocurrency
  top       Show top cryptocurrencies by market cap
  convert   Convert between crypto and fiat
  history   Price history summary
  gas       Ethereum gas prices
  fear      Fear & Greed index
  compare   Compare two cryptocurrencies
  watch     Quick watchlist
  help      Show this help

Usage:
  crypto-market.sh price bitcoin
  crypto-market.sh top 10
  crypto-market.sh convert 1 BTC USD
  crypto-market.sh gas
  crypto-market.sh fear
HELP
}

fetch_price() {
    local coin="${1:-bitcoin}"
    local data=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=$coin&vs_currencies=usd,cny&include_24hr_change=true&include_market_cap=true" 2>/dev/null)
    if echo "$data" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d)" >/dev/null 2>&1; then
        python3 -c "
import json,sys
data = json.loads('''$data''')
if not data:
    print('Coin not found: $coin')
    sys.exit(1)
coin = list(data.keys())[0]
d = data[coin]
print('$coin:')
print('  USD: \${:,.2f}'.format(d.get('usd',0)))
print('  CNY: ¥{:,.2f}'.format(d.get('cny',0)))
print('  24h: {:.2f}%'.format(d.get('usd_24h_change',0)))
mc = d.get('usd_market_cap',0)
if mc > 1e9: print('  MCap: \${:.1f}B'.format(mc/1e9))
elif mc > 1e6: print('  MCap: \${:.1f}M'.format(mc/1e6))
"
    else
        echo "Failed to fetch data. Try again later."
    fi
}

cmd_top() {
    local n=${1:-10}
    local data=$(curl -s "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$n&sparkline=false" 2>/dev/null)
    python3 -c "
import json
data = json.loads('''$data''')
print('{:4s} {:15s} {:>12s} {:>8s} {:>12s}'.format('#','Coin','Price','24h%','MCap'))
print('-' * 55)
for i,c in enumerate(data[:$n],1):
    price = c.get('current_price',0)
    change = c.get('price_change_percentage_24h',0) or 0
    mcap = c.get('market_cap',0) or 0
    sym = '🟢' if change >= 0 else '🔴'
    mcap_s = '\${:.0f}B'.format(mcap/1e9) if mcap > 1e9 else '\${:.0f}M'.format(mcap/1e6)
    print('{} {:3d} {:15s} {:>12s} {:>+7.1f}% {:>12s}'.format(sym, i, c['symbol'].upper(), '\${:,.2f}'.format(price), change, mcap_s))
"
}

cmd_convert() {
    local amount=${1:-1} from_coin=${2:-bitcoin} to_cur=${3:-usd}
    local data=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=$from_coin&vs_currencies=$to_cur" 2>/dev/null)
    python3 -c "
import json
data = json.loads('''$data''')
if '$from_coin' in data and '$to_cur' in data['$from_coin']:
    rate = data['$from_coin']['$to_cur']
    result = $amount * rate
    print('{} {} = {:,.2f} {}'.format($amount, '$from_coin'.upper(), result, '$to_cur'.upper()))
else:
    print('Cannot convert $from_coin to $to_cur')
"
}

cmd_history() {
    local coin=${1:-bitcoin}
    local days=${2:-7}
    local data=$(curl -s "https://api.coingecko.com/api/v3/coins/$coin/market_chart?vs_currency=usd&days=$days" 2>/dev/null)
    python3 -c "
import json, datetime
data = json.loads('''$data''')
prices = data.get('prices', [])
if not prices:
    print('No data for $coin')
else:
    print('$coin — ${days}-day price history:')
    high = max(p[1] for p in prices)
    low = min(p[1] for p in prices)
    first = prices[0][1]
    last = prices[-1][1]
    change = ((last - first) / first) * 100
    print('  Current: \${:,.2f}'.format(last))
    print('  High:    \${:,.2f}'.format(high))
    print('  Low:     \${:,.2f}'.format(low))
    print('  Change:  {:+.1f}%'.format(change))
    print('  Range:   \${:,.2f}'.format(high - low))
"
}

cmd_gas() {
    echo "Ethereum Gas Prices:"
    local data=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd&include_24hr_change=true" 2>/dev/null)
    python3 -c "
import json
data = json.loads('''$data''')
eth = data.get('ethereum',{})
print('  ETH Price: \${:,.2f}'.format(eth.get('usd',0)))
print('  24h Change: {:.2f}%'.format(eth.get('usd_24h_change',0)))
print('')
print('  Tip: For real-time gas, check etherscan.io/gastracker')
"
}

cmd_fear() {
    local data=$(curl -s "https://api.alternative.me/fng/" 2>/dev/null)
    python3 -c "
import json
data = json.loads('''$data''')
fng = data.get('data',[{}])[0]
val = int(fng.get('value',50))
label = fng.get('value_classification','Unknown')
ts = fng.get('timestamp','')
bar = '█' * (val // 5) + '░' * (20 - val // 5)
emoji = '😱' if val < 25 else '😰' if val < 45 else '😐' if val < 55 else '😊' if val < 75 else '🤑'
print('Fear & Greed Index:')
print('  {} {} — {} {}'.format(emoji, val, label, emoji))
print('  [{}] {}/100'.format(bar, val))
"
}

cmd_compare() {
    local coin1=${1:-bitcoin} coin2=${2:-ethereum}
    local data=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=$coin1,$coin2&vs_currencies=usd&include_24hr_change=true&include_market_cap=true" 2>/dev/null)
    python3 -c "
import json
data = json.loads('''$data''')
c1 = data.get('$coin1',{})
c2 = data.get('$coin2',{})
print('{:20s} {:>15s} {:>15s}'.format('','$coin1'.upper(),'$coin2'.upper()))
print('-' * 50)
print('{:20s} {:>15s} {:>15s}'.format('Price','\${:,.2f}'.format(c1.get('usd',0)),'\${:,.2f}'.format(c2.get('usd',0))))
print('{:20s} {:>+14.1f}% {:>+14.1f}%'.format('24h Change',c1.get('usd_24h_change',0) or 0,c2.get('usd_24h_change',0) or 0))
mc1 = c1.get('usd_market_cap',0) or 0
mc2 = c2.get('usd_market_cap',0) or 0
print('{:20s} {:>15s} {:>15s}'.format('Market Cap','\${:.0f}B'.format(mc1/1e9),'\${:.0f}B'.format(mc2/1e9)))
if c2.get('usd',0) > 0:
    ratio = c1.get('usd',0) / c2.get('usd',1)
    print('')
    print('1 {} = {:.4f} {}'.format('$coin1'.upper(), ratio, '$coin2'.upper()))
"
}

cmd_watch() {
    local coins=${1:-"bitcoin,ethereum,solana,cardano,dogecoin"}
    local data=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=$coins&vs_currencies=usd&include_24hr_change=true" 2>/dev/null)
    python3 -c "
import json
data = json.loads('''$data''')
print('Watchlist:')
print('{:15s} {:>12s} {:>8s}'.format('Coin','Price','24h'))
print('-' * 38)
for coin, d in sorted(data.items()):
    change = d.get('usd_24h_change',0) or 0
    sym = '🟢' if change >= 0 else '🔴'
    print('{} {:15s} {:>12s} {:>+7.1f}%'.format(sym, coin, '\${:,.2f}'.format(d.get('usd',0)), change))
"
}

case "${1:-help}" in
    price)    shift; fetch_price "$@" ;;
    top)      cmd_top "$2" ;;
    convert)  shift; cmd_convert "$@" ;;
    history)  shift; cmd_history "$@" ;;
    gas)      cmd_gas ;;
    fear)     cmd_fear ;;
    compare)  shift; cmd_compare "$@" ;;
    watch)    cmd_watch "$2" ;;
    help)     show_help ;;
    *)        echo "Unknown: $1"; show_help ;;
esac
