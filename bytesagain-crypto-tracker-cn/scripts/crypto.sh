#!/bin/bash
# crypto.sh — Crypto market data CLI
# Uses free APIs: CoinGecko, DefiLlama, Alternative.me
# No API keys required

set -euo pipefail

GECKO="https://api.coingecko.com/api/v3"
LLAMA="https://api.llama.fi"
FNG="https://api.alternative.me/fng"

cmd="${1:-help}"
shift 2>/dev/null || true

case "$cmd" in

  price)
    # Usage: crypto.sh price bitcoin ethereum solana
    ids="${*:-bitcoin,ethereum,solana}"
    ids=$(echo "$ids" | tr ' ' ',')
    curl -s "$GECKO/simple/price?ids=$ids&vs_currencies=usd&include_24hr_change=true&include_market_cap=true" | python3 -c '
import sys, json
d = json.load(sys.stdin)
hdr = "{:<12} {:>12} {:>8} {:>14}".format("Coin","Price","24h","MCap")
print(hdr)
print("-" * 50)
for coin, data in sorted(d.items()):
    price = data.get("usd", 0)
    change = data.get("usd_24h_change", 0) or 0
    mcap = data.get("usd_market_cap", 0) or 0
    emoji = "🟢" if change > 0 else "🔴"
    p = "${:,.2f}".format(price) if price >= 1 else "${:.6f}".format(price)
    m = "${:.1f}B".format(mcap/1e9) if mcap > 1e9 else "${:.0f}M".format(mcap/1e6)
    print("{:<12} {:>12} {}{:>+.1f}% {:>12}".format(coin, p, emoji, change, m))
'
    ;;

  market)
    # Global market overview
    curl -s "$GECKO/global" | python3 -c "
import sys, json
d = json.load(sys.stdin)['data']
mcap = d['total_market_cap']['usd']
vol = d['total_volume']['usd']
btc_dom = d['market_cap_percentage']['btc']
eth_dom = d['market_cap_percentage']['eth']
change = d['market_cap_change_percentage_24h_usd']
coins = d['active_cryptocurrencies']
emoji = '🟢' if change > 0 else '🔴'
print('📊 Global Crypto Market')
print('=' * 40)
print(f'Total Market Cap:  \${mcap/1e12:.2f}T {emoji}{change:+.2f}%')
print(f'24h Volume:        \${vol/1e9:.1f}B')
print(f'BTC Dominance:     {btc_dom:.1f}%')
print(f'ETH Dominance:     {eth_dom:.1f}%')
print(f'Active Cryptos:    {coins:,}')
"
    ;;

  trending)
    curl -s "$GECKO/search/trending" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print('🔥 Trending Coins')
print('=' * 50)
for c in d.get('coins', [])[:10]:
    item = c['item']
    name = item['name']
    sym = item['symbol']
    rank = item.get('market_cap_rank', '?')
    print(f'  {name} ({sym}) — Rank #{rank}')
print()
if d.get('categories'):
    print('📁 Trending Categories')
    for cat in d['categories'][:5]:
        print(f'  {cat.get(\"name\",\"?\")}')
"
    ;;

  fear)
    curl -s "$FNG/" | python3 -c "
import sys, json
d = json.load(sys.stdin)['data'][0]
val = int(d['value'])
text = d['value_classification']
bar = '█' * (val // 5) + '░' * (20 - val // 5)
print(f'😱 Fear & Greed Index: {val}/100 ({text})')
print(f'   [{bar}]')
if val <= 25: print('   Signal: Extreme Fear — historically a buying opportunity')
elif val <= 45: print('   Signal: Fear — market cautious')
elif val <= 55: print('   Signal: Neutral')
elif val <= 75: print('   Signal: Greed — consider taking profits')
else: print('   Signal: Extreme Greed — market may be overheated')
"
    ;;

  defi)
    curl -s "$LLAMA/protocols" | python3 -c "
import sys, json
protocols = json.load(sys.stdin)
protocols.sort(key=lambda x: x.get('tvl', 0), reverse=True)
print('🏦 Top DeFi Protocols by TVL')
print(f'{\"#\":<4} {\"Protocol\":<20} {\"TVL\":>14} {\"Chain\":>12}')
print('-' * 55)
for i, p in enumerate(protocols[:15], 1):
    name = p.get('name', '?')[:18]
    tvl = p.get('tvl', 0)
    chain = p.get('chain', '?')[:10]
    t = f'\${tvl/1e9:.2f}B' if tvl > 1e9 else f'\${tvl/1e6:.0f}M'
    print(f'{i:<4} {name:<20} {t:>14} {chain:>12}')
"
    ;;

  memes)
    curl -s "$GECKO/coins/markets?vs_currency=usd&category=meme-token&order=volume_desc&per_page=15&page=1" | python3 -c "
import sys, json
coins = json.load(sys.stdin)
print('🐕 Top Meme Coins by Volume')
print(f'{\"Coin\":<10} {\"Price\":>12} {\"24h\":>8} {\"Volume\":>12} {\"MCap\":>12}')
print('-' * 60)
for c in coins[:15]:
    sym = c['symbol'].upper()[:8]
    price = c['current_price'] or 0
    change = c.get('price_change_percentage_24h', 0) or 0
    vol = c.get('total_volume', 0) or 0
    mcap = c.get('market_cap', 0) or 0
    emoji = '🟢' if change > 0 else '🔴'
    p = f'\${price:,.4f}' if price < 1 else f'\${price:,.2f}'
    v = f'\${vol/1e6:.0f}M'
    m = f'\${mcap/1e6:.0f}M' if mcap < 1e9 else f'\${mcap/1e9:.1f}B'
    print(f'{sym:<10} {p:>12} {emoji}{change:>+.1f}% {v:>10} {m:>10}')
"
    ;;

  info)
    # Detailed info on a specific coin
    coin="${1:-bitcoin}"
    curl -s "$GECKO/coins/$coin" | python3 -c "
import sys, json
d = json.load(sys.stdin)
name = d.get('name', '?')
sym = d.get('symbol', '?').upper()
rank = d.get('market_cap_rank', '?')
md = d.get('market_data', {})
price = md.get('current_price', {}).get('usd', 0)
change24 = md.get('price_change_percentage_24h', 0) or 0
change7d = md.get('price_change_percentage_7d', 0) or 0
change30d = md.get('price_change_percentage_30d', 0) or 0
mcap = md.get('market_cap', {}).get('usd', 0)
vol = md.get('total_volume', {}).get('usd', 0)
ath = md.get('ath', {}).get('usd', 0)
atl = md.get('atl', {}).get('usd', 0)
print(f'📋 {name} ({sym}) — Rank #{rank}')
print('=' * 45)
print(f'Price:     \${price:,.2f}')
print(f'24h:       {\"🟢\" if change24>0 else \"🔴\"}{change24:+.1f}%')
print(f'7d:        {\"🟢\" if change7d>0 else \"🔴\"}{change7d:+.1f}%')
print(f'30d:       {\"🟢\" if change30d>0 else \"🔴\"}{change30d:+.1f}%')
print(f'MCap:      \${mcap/1e9:.2f}B')
print(f'Volume:    \${vol/1e9:.2f}B')
print(f'ATH:       \${ath:,.2f}')
print(f'ATL:       \${atl:,.6f}')
"
    ;;

  portfolio)
    SUB="${1:-list}"; shift 2>/dev/null || true
    export _PF_SUB="$SUB" _PF_ARGS="$*"
    python3 << 'PYEOF'
import json, os, sys
try:
    from urllib.request import urlopen
except:
    from urllib2 import urlopen

DATA_DIR = os.path.expanduser("~/.crypto-tracker")
PF = os.path.join(DATA_DIR, "portfolio.json")
if not os.path.isdir(DATA_DIR):
    os.makedirs(DATA_DIR)
if not os.path.isfile(PF):
    with open(PF, "w") as f: json.dump([], f)

with open(PF) as f:
    portfolio = json.load(f)

sub = os.environ.get("_PF_SUB", "list")
args = os.environ.get("_PF_ARGS", "").split()

if sub == "add":
    if len(args) < 3:
        print("Usage: crypto.sh portfolio add COIN AMOUNT BUY_PRICE")
        sys.exit(1)
    coin, amt, price = args[0].upper(), float(args[1]), float(args[2])
    portfolio.append({"coin": coin, "amount": amt, "buy_price": price})
    with open(PF, "w") as f: json.dump(portfolio, f, indent=2)
    print("Added: {} x {} @ ${}".format(coin, amt, price))

elif sub == "remove":
    coin = " ".join(args).strip().upper()
    before = len(portfolio)
    portfolio = [p for p in portfolio if p["coin"] != coin]
    with open(PF, "w") as f: json.dump(portfolio, f, indent=2)
    print("Removed {} entries for {}".format(before - len(portfolio), coin))

elif sub == "list":
    if not portfolio:
        print("Portfolio is empty. Use: crypto.sh portfolio add BTC 0.5 67000")
        sys.exit(0)
    coins = list(set(p["coin"].lower() for p in portfolio))
    ids = ",".join(coins)
    try:
        url = "https://api.coingecko.com/api/v3/simple/price?ids={}&vs_currencies=usd".format(ids)
        data = json.loads(urlopen(url).read().decode())
    except:
        data = {}
    print("=" * 60)
    print("  Portfolio Overview")
    print("=" * 60)
    total_cost = 0
    total_value = 0
    for p in portfolio:
        coin = p["coin"]
        amt = p["amount"]
        buy = p["buy_price"]
        cost = amt * buy
        cur = data.get(coin.lower(), {}).get("usd", buy)
        val = amt * cur
        pnl = val - cost
        pct = (pnl / cost * 100) if cost > 0 else 0
        total_cost += cost
        total_value += val
        sign = "+" if pnl >= 0 else ""
        print("  {} | {:.4f} | Buy: ${:,.2f} | Now: ${:,.2f} | PnL: {}${:,.2f} ({}{:.1f}%)".format(
            coin, amt, buy, cur, sign, abs(pnl), sign, pct))
    print("-" * 60)
    total_pnl = total_value - total_cost
    sign = "+" if total_pnl >= 0 else ""
    pct = (total_pnl / total_cost * 100) if total_cost > 0 else 0
    print("  Total Cost: ${:,.2f}  |  Value: ${:,.2f}  |  PnL: {}${:,.2f} ({}{:.1f}%)".format(
        total_cost, total_value, sign, abs(total_pnl), sign, pct))
else:
    print("Usage: portfolio [add|list|remove]")
PYEOF
    ;;

  alert)
    SUB="${1:-list}"; shift 2>/dev/null || true
    export _AL_SUB="$SUB" _AL_ARGS="$*"
    python3 << 'PYEOF'
import json, os, sys
try:
    from urllib.request import urlopen
except:
    from urllib2 import urlopen

DATA_DIR = os.path.expanduser("~/.crypto-tracker")
AF = os.path.join(DATA_DIR, "alerts.json")
if not os.path.isdir(DATA_DIR):
    os.makedirs(DATA_DIR)
if not os.path.isfile(AF):
    with open(AF, "w") as f: json.dump([], f)

with open(AF) as f:
    alerts = json.load(f)

sub = os.environ.get("_AL_SUB", "list")
args = os.environ.get("_AL_ARGS", "").split()

if sub == "add":
    if len(args) < 3:
        print("Usage: crypto.sh alert add BTC above 70000")
        sys.exit(1)
    coin, direction, target = args[0].upper(), args[1], float(args[2])
    alerts.append({"coin": coin, "direction": direction, "target": target})
    with open(AF, "w") as f: json.dump(alerts, f, indent=2)
    print("Alert set: {} {} ${:,.0f}".format(coin, direction, target))

elif sub == "list":
    if not alerts:
        print("No alerts. Use: crypto.sh alert add BTC above 70000")
        sys.exit(0)
    print("  Active Alerts:")
    for i, a in enumerate(alerts):
        print("  [{}] {} {} ${:,.0f}".format(i+1, a["coin"], a["direction"], a["target"]))

elif sub == "check":
    if not alerts:
        print("No alerts set.")
        sys.exit(0)
    coins = list(set(a["coin"].lower() for a in alerts))
    ids = ",".join(coins)
    try:
        url = "https://api.coingecko.com/api/v3/simple/price?ids={}&vs_currencies=usd".format(ids)
        data = json.loads(urlopen(url).read().decode())
    except:
        print("API error")
        sys.exit(1)
    triggered = []
    for a in alerts:
        cur = data.get(a["coin"].lower(), {}).get("usd", 0)
        hit = False
        if a["direction"] == "above" and cur >= a["target"]: hit = True
        if a["direction"] == "below" and cur <= a["target"]: hit = True
        status = "TRIGGERED" if hit else "watching"
        print("  {} {} ${:,.0f} | Now: ${:,.0f} | {}".format(
            a["coin"], a["direction"], a["target"], cur, status))
        if hit: triggered.append(a)
    if triggered:
        print("\n  {} alert(s) triggered!".format(len(triggered)))
else:
    print("Usage: alert [add|list|check]")
PYEOF
    ;;

  compare)
    COIN1="${1:?请输入第一个币种ID (如 bitcoin)}"
    COIN2="${2:?请输入第二个币种ID (如 ethereum)}"
    export _CMP_C1="$COIN1" _CMP_C2="$COIN2"
    python3 << 'PYEOF'
import json, os, sys
try:
    from urllib.request import urlopen
except:
    from urllib2 import urlopen
c1 = os.environ.get("_CMP_C1", "bitcoin")
c2 = os.environ.get("_CMP_C2", "ethereum")
url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids={},{}&order=market_cap_desc".format(c1, c2)
try:
    data = json.loads(urlopen(url).read().decode())
except:
    print("API error")
    sys.exit(1)
if len(data) < 2:
    print("Could not find both coins. Use IDs like: bitcoin, ethereum, solana")
    sys.exit(1)
a, b = data[0], data[1]
print("=" * 60)
print("  Coin Comparison: {} vs {}".format(a["symbol"].upper(), b["symbol"].upper()))
print("=" * 60)
rows = [
    ("Price", "${:,.2f}".format(a["current_price"]), "${:,.2f}".format(b["current_price"])),
    ("Market Cap", "${:,.0f}".format(a["market_cap"]), "${:,.0f}".format(b["market_cap"])),
    ("24h Volume", "${:,.0f}".format(a.get("total_volume",0)), "${:,.0f}".format(b.get("total_volume",0))),
    ("24h Change", "{:.1f}%".format(a.get("price_change_percentage_24h",0)), "{:.1f}%".format(b.get("price_change_percentage_24h",0))),
    ("Rank", "#{}".format(a.get("market_cap_rank","?")), "#{}".format(b.get("market_cap_rank","?"))),
    ("ATH", "${:,.2f}".format(a.get("ath",0)), "${:,.2f}".format(b.get("ath",0))),
]
print("  {:20} {:>18} {:>18}".format("Metric", a["symbol"].upper(), b["symbol"].upper()))
print("  " + "-" * 56)
for label, v1, v2 in rows:
    print("  {:20} {:>18} {:>18}".format(label, v1, v2))
PYEOF
    ;;

  whale)
    python3 << PYEOF
print("=" * 60)
print("  Whale Monitoring Guide")
print("=" * 60)
print()
print("  Free whale tracking tools:")
print("  1. Whale Alert (whale-alert.io) - large transfers")
print("  2. Arkham Intel (arkham.com) - wallet labels")
print("  3. Nansen (free tier) - smart money")
print("  4. Etherscan (etherscan.io) - on-chain data")
print("  5. DeBank (debank.com) - DeFi portfolios")
print()
print("  Key whale signals:")
print("  Large exchange deposits = potential sell pressure")
print("  Large exchange withdrawals = accumulation")
print("  Dormant wallet activation = old holder moving")
print("  Large DEX swaps = smart money repositioning")
print()
print("  Monitoring thresholds:")
print("  BTC: >1000 BTC (~\$67M)")
print("  ETH: >10000 ETH (~\$20M)")
print("  USDT: >10M USDT (stablecoin flow)")
PYEOF
    ;;

  events)
    python3 << PYEOF
import datetime
today = datetime.date.today()
print("=" * 60)
print("  Crypto Event Calendar")
print("  Week of {}".format(today.strftime("%Y-%m-%d")))
print("=" * 60)
print()
print("  Recurring events to track:")
print("  Mon  - Weekly market open, futures settlement prep")
print("  Tue  - On-chain data reports (Glassnode weekly)")
print("  Wed  - FOMC meeting days (check schedule)")
print("  Thu  - US unemployment claims, market volatility")
print("  Fri  - Options expiry (monthly last Friday)")
print("  Sat  - Low liquidity, potential manipulation")
print("  Sun  - Weekly close, sentiment shift")
print()
print("  Major event types:")
print("  Token unlocks - check token.unlocks.app")
print("  Network upgrades - project blogs/Twitter")
print("  Airdrops - check earndrop.io, airdrops.io")
print("  Regulatory - SEC/CFTC announcements")
print("  ETF flows - check farside.co.uk")
print()
print("  Free calendar tools:")
print("  coinmarketcal.com - community-driven events")
print("  coinglass.com - futures/options data")
PYEOF
    ;;

  learn)
    CONCEPT="${1:-区块链}"
    export _LEARN="$CONCEPT"
    python3 << 'PYEOF'
import os
concept = os.environ.get("_LEARN", "区块链")
print("=" * 60)
print("  Crypto Learn: {}".format(concept))
print("=" * 60)
db = {
    "DeFi": ("Decentralized Finance", "去中心化金融，用智能合约替代银行/交易所等中间人。包括借贷(Aave)、交易(Uniswap)、稳定币(DAI)等。", "智能合约漏洞、无常损失、流动性风险"),
    "NFT": ("Non-Fungible Token", "非同质化代币，每个独一无二。用于数字艺术、游戏道具、会员证等。", "流动性差、版权争议、市场泡沫"),
    "Layer2": ("二层扩容方案", "在主链之上建立的扩容网络，降低gas费提高速度。如Arbitrum、Optimism、zkSync。", "桥接风险、中心化风险、技术不成熟"),
    "质押": ("Staking", "锁定代币参与网络验证获取收益。ETH质押年化约3-5%。可通过Lido等协议流动质押。", "解锁期限、验证者惩罚(slashing)、协议风险"),
    "空投": ("Airdrop", "项目方免费发放代币给早期用户。需要交互协议、提供流动性等操作获取资格。", "钓鱼空投、gas费成本、时间成本"),
    "HODL": ("Hold On for Dear Life", "长期持有策略，不因短期波动卖出。源自比特币论坛拼写错误。", "机会成本、项目可能归零"),
    "区块链": ("Blockchain", "分布式账本技术，数据不可篡改。比特币是第一个应用。以太坊引入智能合约。", "51%攻击、扩容瓶颈、能耗争议"),
}
found = None
for k, v in db.items():
    if k.lower() in concept.lower() or concept.lower() in k.lower():
        found = (k, v)
        break
if found:
    k, (en, desc, risk) = found
    print()
    print("  {} ({})".format(k, en))
    print()
    print("  {} ".format(desc))
    print()
    print("  Risk: {}".format(risk))
else:
    print()
    print("  '{}' not in built-in database.".format(concept))
    print("  Available: {}".format(", ".join(db.keys())))
PYEOF
    ;;

  rsi)
    COIN="${1:-bitcoin}"
    export _RSI_COIN="$COIN"
    python3 << 'PYEOF'
import json, os, sys
try:
    from urllib.request import urlopen
except:
    from urllib2 import urlopen

coin = os.environ.get("_RSI_COIN", "bitcoin")
url = "https://api.coingecko.com/api/v3/coins/{}/market_chart?vs_currency=usd&days=14".format(coin)
try:
    data = json.loads(urlopen(url).read().decode())
except Exception as e:
    print("API error: {}".format(e))
    sys.exit(1)

prices_raw = data.get("prices", [])
if len(prices_raw) < 2:
    print("Not enough data for RSI calculation.")
    sys.exit(1)

# Extract closing prices (one per data point)
prices = [p[1] for p in prices_raw]
current_price = prices[-1]

# Calculate price changes
changes = []
for i in range(1, len(prices)):
    changes.append(prices[i] - prices[i-1])

# Use last 14 periods for RSI
period = min(14, len(changes))
recent = changes[-period:]
gains = [c for c in recent if c > 0]
losses = [-c for c in recent if c < 0]

avg_gain = sum(gains) / period if gains else 0
avg_loss = sum(losses) / period if losses else 0.0001

rs = avg_gain / avg_loss if avg_loss > 0 else 100
rsi = 100 - (100 / (1 + rs))

# Signal
if rsi > 70:
    signal = "🔴 超买 (Overbought)"
    advice = "RSI偏高，市场可能过热，考虑减仓或观望"
elif rsi < 30:
    signal = "🟢 超卖 (Oversold)"
    advice = "RSI偏低，市场可能被低估，可关注买入机会"
else:
    signal = "🟡 中性 (Neutral)"
    advice = "RSI处于正常区间，建议持续观察"

bar_len = int(rsi / 5)
bar = "█" * bar_len + "░" * (20 - bar_len)

print("=" * 50)
print("  📈 RSI Analysis: {}".format(coin.upper()))
print("=" * 50)
print()
print("  Current Price:  ${:,.2f}".format(current_price))
print("  14-day RSI:     {:.1f}".format(rsi))
print("  [{}]".format(bar))
print("  Signal:         {}".format(signal))
print("  Advice:         {}".format(advice))
print()
print("  RSI Guide:")
print("  > 70  Overbought  — consider selling")
print("  30-70 Neutral     — hold / observe")
print("  < 30  Oversold    — consider buying")
print()
print("⚠️ 风险提示：以上数据仅供参考，不构成投资建议。加密货币投资风险极高，请自行判断。")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
    ;;

  ma)
    COIN="${1:-bitcoin}"
    export _MA_COIN="$COIN"
    python3 << 'PYEOF'
import json, os, sys
try:
    from urllib.request import urlopen
except:
    from urllib2 import urlopen

coin = os.environ.get("_MA_COIN", "bitcoin")
url = "https://api.coingecko.com/api/v3/coins/{}/market_chart?vs_currency=usd&days=30".format(coin)
try:
    data = json.loads(urlopen(url).read().decode())
except Exception as e:
    print("API error: {}".format(e))
    sys.exit(1)

prices_raw = data.get("prices", [])
if len(prices_raw) < 7:
    print("Not enough data for MA calculation.")
    sys.exit(1)

prices = [p[1] for p in prices_raw]
current_price = prices[-1]

# Calculate moving averages
def calc_ma(data, period):
    if len(data) < period:
        return sum(data) / len(data)
    return sum(data[-period:]) / period

ma7 = calc_ma(prices, 7)
ma14 = calc_ma(prices, 14)
ma30 = calc_ma(prices, 30)

# Determine trend
def position(cur, ma, label):
    diff_pct = (cur - ma) / ma * 100
    if cur > ma:
        return "  Price vs {}: ABOVE ({:+.2f}%) 🟢".format(label, diff_pct)
    else:
        return "  Price vs {}: BELOW ({:+.2f}%) 🔴".format(label, diff_pct)

# Golden cross / Death cross detection
# Golden: short MA crosses above long MA
# Death: short MA crosses below long MA
if ma7 > ma14 and ma7 > ma30:
    cross_signal = "🟢 金叉信号 (Golden Cross) — 短期均线在长期均线上方，上升趋势"
elif ma7 < ma14 and ma7 < ma30:
    cross_signal = "🔴 死叉信号 (Death Cross) — 短期均线在长期均线下方，下降趋势"
elif ma7 > ma14:
    cross_signal = "🟡 弱金叉 — MA7 > MA14, 但尚未完全突破MA30"
else:
    cross_signal = "🟡 盘整中 — 均线交织，趋势不明朗"

# Overall trend
if current_price > ma7 > ma14 > ma30:
    trend = "📈 强势上涨 (Strong Bullish)"
elif current_price < ma7 < ma14 < ma30:
    trend = "📉 强势下跌 (Strong Bearish)"
elif current_price > ma30:
    trend = "📊 偏多震荡 (Bullish Consolidation)"
else:
    trend = "📊 偏空震荡 (Bearish Consolidation)"

print("=" * 55)
print("  📊 Moving Average Analysis: {}".format(coin.upper()))
print("=" * 55)
print()
print("  Current Price:  ${:,.2f}".format(current_price))
print()
print("  MA7  (7-day):   ${:,.2f}".format(ma7))
print("  MA14 (14-day):  ${:,.2f}".format(ma14))
print("  MA30 (30-day):  ${:,.2f}".format(ma30))
print()
print(position(current_price, ma7, "MA7"))
print(position(current_price, ma14, "MA14"))
print(position(current_price, ma30, "MA30"))
print()
print("  Cross:  {}".format(cross_signal))
print("  Trend:  {}".format(trend))
print()
print("⚠️ 风险提示：以上数据仅供参考，不构成投资建议。加密货币投资风险极高，请自行判断。")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
    ;;

  defi-yield)
    python3 << 'PYEOF'
import json, sys
try:
    from urllib.request import urlopen
except:
    from urllib2 import urlopen

url = "https://yields.llama.fi/pools"
try:
    raw = urlopen(url).read().decode()
    data = json.loads(raw)
except Exception as e:
    print("API error: {}".format(e))
    sys.exit(1)

pools = data.get("data", [])
# Filter: TVL > 1M, APY > 0, stablecoin or mainstream tokens preferred
filtered = []
for p in pools:
    tvl = p.get("tvlUsd", 0) or 0
    apy = p.get("apy", 0) or 0
    if tvl >= 1000000 and apy > 0 and apy < 10000:
        filtered.append(p)

# Sort by APY descending
filtered.sort(key=lambda x: x.get("apy", 0), reverse=True)
top = filtered[:20]

print("=" * 75)
print("  🌾 DeFi Yield — Top 20 High-Yield Pools (TVL > $1M)")
print("=" * 75)
print()
print("  {:<4} {:<16} {:<22} {:>8} {:>12} {:<10}".format(
    "#", "Protocol", "Pool", "APY", "TVL", "Chain"))
print("  " + "-" * 72)

for i, p in enumerate(top, 1):
    project = (p.get("project", "?") or "?")[:14]
    symbol = (p.get("symbol", "?") or "?")[:20]
    apy = p.get("apy", 0) or 0
    tvl = p.get("tvlUsd", 0) or 0
    chain = (p.get("chain", "?") or "?")[:8]
    tvl_str = "${:.1f}M".format(tvl / 1e6) if tvl < 1e9 else "${:.2f}B".format(tvl / 1e9)
    print("  {:<4} {:<16} {:<22} {:>7.1f}% {:>12} {:<10}".format(
        i, project, symbol, apy, tvl_str, chain))

print()
print("  Tips:")
print("  · APY超高(>100%)的池子通常伴随高风险，注意无常损失")
print("  · TVL越大通常越稳定，但不代表零风险")
print("  · 建议分散投资，不要all-in单一池子")
print()
print("⚠️ 风险提示：以上数据仅供参考，不构成投资建议。加密货币投资风险极高，请自行判断。")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
    ;;

  gas)
    python3 << 'PYEOF'
import json, sys
try:
    from urllib.request import urlopen
except:
    from urllib2 import urlopen

print("=" * 50)
print("  ⛽ Ethereum Gas Tracker")
print("=" * 50)
print()

# Try etherscan-compatible free API first (no key needed for basic)
apis = [
    ("https://api.etherscan.io/api?module=gastracker&action=gasoracle", "etherscan"),
    ("https://gas.api.infura.io/v3/gas/feeHistory?chain=ethereum&blockCount=1", "infura"),
]

success = False
for api_url, source in apis:
    try:
        raw = urlopen(api_url).read().decode()
        data = json.loads(raw)
        if source == "etherscan" and data.get("status") == "1":
            result = data["result"]
            low = result.get("SafeGasPrice", "?")
            avg = result.get("ProposeGasPrice", "?")
            high = result.get("FastGasPrice", "?")
            base = result.get("suggestBaseFee", "?")
            print("  Source:    Etherscan")
            print("  Base Fee:  {} Gwei".format(base))
            print()
            print("  🐢 Low:    {} Gwei  (>10 min)".format(low))
            print("  🚶 Medium: {} Gwei  (~3 min)".format(avg))
            print("  🚀 Fast:   {} Gwei  (~30 sec)".format(high))
            success = True
            break
    except:
        continue

if not success:
    print("  [API unavailable — showing reference guide]")
    print()
    print("  Typical Gas Price Ranges:")
    print("  🐢 Low:    5-15 Gwei   (>10 min, cheap transfers)")
    print("  🚶 Medium: 15-40 Gwei  (~3 min, normal)")
    print("  🚀 Fast:   40-100 Gwei (~30 sec, urgent)")
    print("  🔥 Surge:  100+ Gwei   (NFT mint / high demand)")

print()
print("  Transaction Cost Estimates (at Medium gas):")
print("  · ETH Transfer:  ~$0.50-2.00")
print("  · ERC20 Transfer: ~$1.00-5.00")
print("  · Uniswap Swap:  ~$3.00-15.00")
print("  · NFT Mint:      ~$5.00-30.00")
print()
print("  💡 Gas省钱Tips:")
print("  · 周末/凌晨(UTC) gas通常最低")
print("  · 用Layer2 (Arbitrum/Optimism/Base) 省95%+ gas")
print("  · 批量操作用multicall合约")
print("  · 实时监控: etherscan.io/gastracker")
print()
print("⚠️ 风险提示：以上数据仅供参考，不构成投资建议。加密货币投资风险极高，请自行判断。")
print("Powered by BytesAgain | bytesagain.com")
PYEOF
    ;;

  help|*)
    echo "🪙 Crypto Tracker — Free crypto market data"
    echo ""
    echo "Usage: crypto.sh <command> [args]"
    echo ""
    echo "Commands:"
    echo "  price [coins...]   Price check (default: btc eth sol)"
    echo "  market             Global market overview"
    echo "  trending           Trending coins & categories"
    echo "  fear               Fear & Greed Index"
    echo "  defi               Top DeFi protocols by TVL"
    echo "  memes              Top meme coins by volume"
    echo "  info <coin>        Detailed coin info"
    echo "  portfolio [add|list|remove]  Manage holdings"
    echo "  alert [add|list|check]      Price alerts"
    echo "  compare coin1 coin2         Side-by-side comparison"
    echo "  whale                       Whale monitoring guide"
    echo "  events                      Event calendar"
    echo "  learn [concept]             Learn crypto terms"
    echo ""
    echo "  📈 Technical Analysis:"
    echo "  rsi <coin>         RSI indicator (14-day)"
    echo "  ma <coin>          Moving average analysis (7/14/30-day)"
    echo ""
    echo "  💰 DeFi & Gas:"
    echo "  defi-yield         DeFi yield comparison (top pools)"
    echo "  gas                Ethereum gas tracker"
    echo ""
    echo "  help               Show this help"
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;
esac
