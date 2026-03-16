#!/usr/bin/env bash
# Unit Converter — length, weight, temperature, currency, time, speed
# Usage: bash convert.sh <command> [args]

CMD="$1"; shift 2>/dev/null; INPUT="$*"

# Helper: bc wrapper with scale
calc() {
  echo "scale=6; $1" | bc 2>/dev/null
}

# Helper: round to N decimal places (default 4)
round() {
  local val="$1" places="${2:-4}"
  printf "%.${places}f" "$val" 2>/dev/null || echo "$val"
}

# Parse input: expects "<value> <from> to <to>"
parse_input() {
  local input="$*"
  VALUE=$(echo "$input" | awk '{print $1}')
  FROM=$(echo "$input" | awk '{print tolower($2)}')
  TO=$(echo "$input" | awk '{print tolower($4)}')
  if [[ -z "$VALUE" || -z "$FROM" || -z "$TO" ]]; then
    return 1
  fi
  return 0
}

case "$CMD" in
  length)
    if ! parse_input $INPUT; then
      cat <<'EOF'
📏 长度换算 (Length Converter)

用法: length <数值> <源单位> to <目标单位>

支持单位:
  m    — 米 (meter)
  cm   — 厘米 (centimeter)
  mm   — 毫米 (millimeter)
  km   — 千米 (kilometer)
  inch — 英寸 (inch)
  ft   — 英尺 (foot)
  yard — 码 (yard)
  mile — 英里 (mile)

示例: length 100 cm to inch

常用对照表:
┌──────────┬──────────┬──────────────┐
│ 单位     │ 等于     │ 米(m)        │
├──────────┼──────────┼──────────────┤
│ 1 inch   │ 2.54 cm  │ 0.0254       │
│ 1 ft     │ 12 inch  │ 0.3048       │
│ 1 yard   │ 3 ft     │ 0.9144       │
│ 1 mile   │ 5280 ft  │ 1609.344     │
│ 1 km     │ 1000 m   │ 1000         │
│ 1 cm     │ 10 mm    │ 0.01         │
└──────────┴──────────┴──────────────┘

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    # Convert to meters first
    to_meter() {
      local v="$1" u="$2"
      case "$u" in
        m)    echo "$v" ;;
        cm)   calc "$v / 100" ;;
        mm)   calc "$v / 1000" ;;
        km)   calc "$v * 1000" ;;
        inch) calc "$v * 0.0254" ;;
        ft)   calc "$v * 0.3048" ;;
        yard) calc "$v * 0.9144" ;;
        mile) calc "$v * 1609.344" ;;
        *)    echo ""; return 1 ;;
      esac
    }

    from_meter() {
      local v="$1" u="$2"
      case "$u" in
        m)    echo "$v" ;;
        cm)   calc "$v * 100" ;;
        mm)   calc "$v * 1000" ;;
        km)   calc "$v / 1000" ;;
        inch) calc "$v / 0.0254" ;;
        ft)   calc "$v / 0.3048" ;;
        yard) calc "$v / 0.9144" ;;
        mile) calc "$v / 1609.344" ;;
        *)    echo ""; return 1 ;;
      esac
    }

    METERS=$(to_meter "$VALUE" "$FROM")
    if [[ -z "$METERS" ]]; then
      echo "❌ 不支持的源单位: $FROM"
      exit 1
    fi
    RESULT=$(from_meter "$METERS" "$TO")
    if [[ -z "$RESULT" ]]; then
      echo "❌ 不支持的目标单位: $TO"
      exit 1
    fi
    RESULT=$(round "$RESULT")

    cat <<EOF
📏 长度换算结果

  $VALUE $FROM = $RESULT $TO

公式: $FROM → m → $TO
  1. $VALUE $FROM → $METERS m
  2. $METERS m → $RESULT $TO

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;

  weight)
    if ! parse_input $INPUT; then
      cat <<'EOF'
⚖️ 重量换算 (Weight Converter)

用法: weight <数值> <源单位> to <目标单位>

支持单位:
  kg   — 千克 (kilogram)
  g    — 克 (gram)
  mg   — 毫克 (milligram)
  ton  — 公吨 (metric ton)
  lb   — 磅 (pound)
  oz   — 盎司 (ounce)
  jin  — 斤 (Chinese jin = 500g)

示例: weight 70 kg to lb

常用对照表:
┌──────────┬───────────┬──────────────┐
│ 单位     │ 等于      │ 千克(kg)     │
├──────────┼───────────┼──────────────┤
│ 1 lb     │ 16 oz     │ 0.453592     │
│ 1 oz     │ 28.35 g   │ 0.028350     │
│ 1 ton    │ 1000 kg   │ 1000         │
│ 1 jin    │ 500 g     │ 0.5          │
│ 1 g      │ 1000 mg   │ 0.001        │
└──────────┴───────────┴──────────────┘

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    to_kg() {
      local v="$1" u="$2"
      case "$u" in
        kg)  echo "$v" ;;
        g)   calc "$v / 1000" ;;
        mg)  calc "$v / 1000000" ;;
        ton) calc "$v * 1000" ;;
        lb)  calc "$v * 0.453592" ;;
        oz)  calc "$v * 0.028350" ;;
        jin) calc "$v * 0.5" ;;
        *)   echo ""; return 1 ;;
      esac
    }

    from_kg() {
      local v="$1" u="$2"
      case "$u" in
        kg)  echo "$v" ;;
        g)   calc "$v * 1000" ;;
        mg)  calc "$v * 1000000" ;;
        ton) calc "$v / 1000" ;;
        lb)  calc "$v / 0.453592" ;;
        oz)  calc "$v / 0.028350" ;;
        jin) calc "$v / 0.5" ;;
        *)   echo ""; return 1 ;;
      esac
    }

    KG=$(to_kg "$VALUE" "$FROM")
    if [[ -z "$KG" ]]; then echo "❌ 不支持的源单位: $FROM"; exit 1; fi
    RESULT=$(from_kg "$KG" "$TO")
    if [[ -z "$RESULT" ]]; then echo "❌ 不支持的目标单位: $TO"; exit 1; fi
    RESULT=$(round "$RESULT")

    cat <<EOF
⚖️ 重量换算结果

  $VALUE $FROM = $RESULT $TO

公式: $FROM → kg → $TO
  1. $VALUE $FROM → $KG kg
  2. $KG kg → $RESULT $TO

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;

  temperature)
    if ! parse_input $INPUT; then
      cat <<'EOF'
🌡️ 温度换算 (Temperature Converter)

用法: temperature <数值> <源单位> to <目标单位>

支持单位:
  c — 摄氏度 (Celsius)
  f — 华氏度 (Fahrenheit)
  k — 开尔文 (Kelvin)

示例: temperature 100 c to f

公式:
  °F = °C × 9/5 + 32
  °C = (°F - 32) × 5/9
  K  = °C + 273.15

常用温度参考:
┌───────────────┬────────┬────────┬─────────┐
│ 场景          │ °C     │ °F     │ K       │
├───────────────┼────────┼────────┼─────────┤
│ 绝对零度      │ -273.15│ -459.67│ 0       │
│ 水结冰        │ 0      │ 32     │ 273.15  │
│ 室温          │ 25     │ 77     │ 298.15  │
│ 体温          │ 37     │ 98.6   │ 310.15  │
│ 水沸腾        │ 100    │ 212    │ 373.15  │
└───────────────┴────────┴────────┴─────────┘

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    # Convert to Celsius first
    to_celsius() {
      local v="$1" u="$2"
      case "$u" in
        c) echo "$v" ;;
        f) calc "($v - 32) * 5 / 9" ;;
        k) calc "$v - 273.15" ;;
        *) echo ""; return 1 ;;
      esac
    }

    from_celsius() {
      local v="$1" u="$2"
      case "$u" in
        c) echo "$v" ;;
        f) calc "$v * 9 / 5 + 32" ;;
        k) calc "$v + 273.15" ;;
        *) echo ""; return 1 ;;
      esac
    }

    CELSIUS=$(to_celsius "$VALUE" "$FROM")
    if [[ -z "$CELSIUS" ]]; then echo "❌ 不支持的源单位: $FROM"; exit 1; fi
    RESULT=$(from_celsius "$CELSIUS" "$TO")
    if [[ -z "$RESULT" ]]; then echo "❌ 不支持的目标单位: $TO"; exit 1; fi
    RESULT=$(round "$RESULT" 2)

    # Show formula
    case "${FROM}-${TO}" in
      c-f) FORMULA="°F = °C × 9/5 + 32" ;;
      f-c) FORMULA="°C = (°F - 32) × 5/9" ;;
      c-k) FORMULA="K = °C + 273.15" ;;
      k-c) FORMULA="°C = K - 273.15" ;;
      f-k) FORMULA="°F → °C → K" ;;
      k-f) FORMULA="K → °C → °F" ;;
      *)   FORMULA="$FROM → °C → $TO" ;;
    esac

    cat <<EOF
🌡️ 温度换算结果

  $VALUE°${FROM^^} = $RESULT°${TO^^}

公式: $FORMULA

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;

  currency)
    if ! parse_input $INPUT; then
      cat <<'EOF'
💱 货币换算参考 (Currency Reference)

用法: currency <数值> <源货币> to <目标货币>

⚠️ 汇率为离线参考值，实际交易请以银行为准！

支持货币:
  usd — 美元    cny — 人民币   eur — 欧元
  gbp — 英镑    jpy — 日元     krw — 韩元
  hkd — 港币    twd — 新台币   sgd — 新加坡元
  aud — 澳元    cad — 加元

示例: currency 100 usd to cny

参考汇率表 (基于 1 USD):
┌──────┬──────────┬──────────────┐
│ 货币 │ 代码     │ ≈ 汇率       │
├──────┼──────────┼──────────────┤
│ 美元 │ USD      │ 1.000        │
│ 人民币│ CNY      │ 7.250        │
│ 欧元 │ EUR      │ 0.920        │
│ 英镑 │ GBP      │ 0.790        │
│ 日元 │ JPY      │ 149.500      │
│ 韩元 │ KRW      │ 1330.000     │
│ 港币 │ HKD      │ 7.820        │
│ 新台币│ TWD      │ 31.500       │
│ 新加坡│ SGD      │ 1.340        │
│ 澳元 │ AUD      │ 1.530        │
│ 加元 │ CAD      │ 1.360        │
└──────┴──────────┴──────────────┘

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    # Reference rates to USD
    rate_to_usd() {
      case "$1" in
        usd) echo "1" ;;
        cny) echo "7.25" ;;
        eur) echo "0.92" ;;
        gbp) echo "0.79" ;;
        jpy) echo "149.5" ;;
        krw) echo "1330" ;;
        hkd) echo "7.82" ;;
        twd) echo "31.5" ;;
        sgd) echo "1.34" ;;
        aud) echo "1.53" ;;
        cad) echo "1.36" ;;
        *)   echo "" ;;
      esac
    }

    FROM_RATE=$(rate_to_usd "$FROM")
    TO_RATE=$(rate_to_usd "$TO")
    if [[ -z "$FROM_RATE" ]]; then echo "❌ 不支持的货币: $FROM"; exit 1; fi
    if [[ -z "$TO_RATE" ]]; then echo "❌ 不支持的货币: $TO"; exit 1; fi

    RESULT=$(calc "$VALUE / $FROM_RATE * $TO_RATE")
    RESULT=$(round "$RESULT" 2)
    RATE=$(calc "$TO_RATE / $FROM_RATE")
    RATE=$(round "$RATE" 4)

    cat <<EOF
💱 货币换算参考

  $VALUE ${FROM^^} ≈ $RESULT ${TO^^}

参考汇率: 1 ${FROM^^} ≈ $RATE ${TO^^}

⚠️ 此为离线参考汇率，实际交易请以银行实时汇率为准！

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;

  time)
    if ! parse_input $INPUT; then
      cat <<'EOF'
⏱️ 时间换算 (Time Converter)

用法: time <数值> <源单位> to <目标单位>

支持单位:
  ms   — 毫秒 (millisecond)
  s    — 秒 (second)
  min  — 分钟 (minute)
  h    — 小时 (hour)
  day  — 天 (day)
  week — 周 (week)
  month— 月 (≈30.44天)
  year — 年 (≈365.25天)

示例: time 3600 s to h

常用对照表:
┌──────────┬──────────────┬──────────────┐
│ 单位     │ 等于         │ 秒(s)        │
├──────────┼──────────────┼──────────────┤
│ 1 min    │ 60 s         │ 60           │
│ 1 h      │ 60 min       │ 3600         │
│ 1 day    │ 24 h         │ 86400        │
│ 1 week   │ 7 day        │ 604800       │
│ 1 month  │ ≈30.44 day   │ 2629746      │
│ 1 year   │ ≈365.25 day  │ 31557000     │
└──────────┴──────────────┴──────────────┘

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    to_seconds() {
      local v="$1" u="$2"
      case "$u" in
        ms)    calc "$v / 1000" ;;
        s)     echo "$v" ;;
        min)   calc "$v * 60" ;;
        h)     calc "$v * 3600" ;;
        day)   calc "$v * 86400" ;;
        week)  calc "$v * 604800" ;;
        month) calc "$v * 2629746" ;;
        year)  calc "$v * 31557000" ;;
        *)     echo ""; return 1 ;;
      esac
    }

    from_seconds() {
      local v="$1" u="$2"
      case "$u" in
        ms)    calc "$v * 1000" ;;
        s)     echo "$v" ;;
        min)   calc "$v / 60" ;;
        h)     calc "$v / 3600" ;;
        day)   calc "$v / 86400" ;;
        week)  calc "$v / 604800" ;;
        month) calc "$v / 2629746" ;;
        year)  calc "$v / 31557000" ;;
        *)     echo ""; return 1 ;;
      esac
    }

    SECONDS_VAL=$(to_seconds "$VALUE" "$FROM")
    if [[ -z "$SECONDS_VAL" ]]; then echo "❌ 不支持的源单位: $FROM"; exit 1; fi
    RESULT=$(from_seconds "$SECONDS_VAL" "$TO")
    if [[ -z "$RESULT" ]]; then echo "❌ 不支持的目标单位: $TO"; exit 1; fi
    RESULT=$(round "$RESULT")

    cat <<EOF
⏱️ 时间换算结果

  $VALUE $FROM = $RESULT $TO

公式: $FROM → s → $TO
  1. $VALUE $FROM → $SECONDS_VAL s
  2. $SECONDS_VAL s → $RESULT $TO

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;

  speed)
    if ! parse_input $INPUT; then
      cat <<'EOF'
🚀 速度换算 (Speed Converter)

用法: speed <数值> <源单位> to <目标单位>

支持单位:
  kmh  — 千米/时 (km/h)
  mph  — 英里/时 (miles/h)
  ms   — 米/秒 (m/s)
  knot — 节 (nautical knot)
  fts  — 英尺/秒 (ft/s)

示例: speed 100 kmh to mph

常用对照表:
┌──────────┬──────────────┬──────────────┐
│ 单位     │ 等于         │ m/s          │
├──────────┼──────────────┼──────────────┤
│ 1 km/h   │ 0.2778 m/s   │ 0.277778     │
│ 1 mph    │ 1.609 km/h   │ 0.447040     │
│ 1 knot   │ 1.852 km/h   │ 0.514444     │
│ 1 ft/s   │ 0.3048 m/s   │ 0.304800     │
└──────────┴──────────────┴──────────────┘

常见速度参考:
  🚶 步行 ≈ 5 km/h ≈ 3.1 mph
  🚴 骑车 ≈ 20 km/h ≈ 12.4 mph
  🚗 高速 ≈ 120 km/h ≈ 74.6 mph
  ✈️ 客机 ≈ 900 km/h ≈ 559 mph
  🔊 音速 ≈ 1235 km/h ≈ 343 m/s

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    to_ms() {
      local v="$1" u="$2"
      case "$u" in
        ms)   echo "$v" ;;
        kmh)  calc "$v * 0.277778" ;;
        mph)  calc "$v * 0.447040" ;;
        knot) calc "$v * 0.514444" ;;
        fts)  calc "$v * 0.304800" ;;
        *)    echo ""; return 1 ;;
      esac
    }

    from_ms() {
      local v="$1" u="$2"
      case "$u" in
        ms)   echo "$v" ;;
        kmh)  calc "$v / 0.277778" ;;
        mph)  calc "$v / 0.447040" ;;
        knot) calc "$v / 0.514444" ;;
        fts)  calc "$v / 0.304800" ;;
        *)    echo ""; return 1 ;;
      esac
    }

    MS_VAL=$(to_ms "$VALUE" "$FROM")
    if [[ -z "$MS_VAL" ]]; then echo "❌ 不支持的源单位: $FROM"; exit 1; fi
    RESULT=$(from_ms "$MS_VAL" "$TO")
    if [[ -z "$RESULT" ]]; then echo "❌ 不支持的目标单位: $TO"; exit 1; fi
    RESULT=$(round "$RESULT")

    cat <<EOF
🚀 速度换算结果

  $VALUE $FROM = $RESULT $TO

公式: $FROM → m/s → $TO
  1. $VALUE $FROM → $MS_VAL m/s
  2. $MS_VAL m/s → $RESULT $TO

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;

  *)
    cat <<'EOF'
📐 单位换算工具 (Unit Converter)

用法: bash convert.sh <command> [args]

命令:
  length       长度换算 (m/cm/mm/km/inch/ft/yard/mile)
  weight       重量换算 (kg/g/mg/ton/lb/oz/jin)
  temperature  温度换算 (C/F/K)
  currency     货币换算参考 (USD/CNY/EUR/GBP/JPY...)
  time         时间换算 (ms/s/min/h/day/week/month/year)
  speed        速度换算 (kmh/mph/ms/knot/fts)

示例:
  bash convert.sh length 100 cm to inch
  bash convert.sh weight 70 kg to lb
  bash convert.sh temperature 100 c to f
  bash convert.sh currency 100 usd to cny
  bash convert.sh time 3600 s to h
  bash convert.sh speed 100 kmh to mph

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
esac
