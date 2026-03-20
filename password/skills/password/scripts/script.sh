#!/usr/bin/env bash
set -euo pipefail
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Password Generator & Checker
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DATA_DIR="${HOME}/.local/share/password-tool"
VERSION="3.0.1"

LOWER="abcdefghijklmnopqrstuvwxyz"
UPPER="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
DIGITS="0123456789"
SYMBOLS='!@#$%^&*()-_=+[]{}|;:,.<>?/~`'

mkdir -p "$DATA_DIR"

# ── Helpers ──────────────────────────────────────────────────────────────────

die() { echo "Error: $*" >&2; exit 1; }

usage() {
    cat <<'EOF'
Password Tool — Generate, check, and analyze passwords

USAGE:
  password generate [length] [--symbols] [--no-upper] [--no-digits]
  password strength <password>
  password entropy <password>
  password batch <count> [length] [--symbols]
  password check-leak <password>
  password diceware [words]
  password pin [length]
  password help

COMMANDS:
  generate    Generate a random password (default: 16 chars)
  strength    Rate password strength (weak/fair/good/strong/excellent)
  entropy     Calculate Shannon entropy in bits
  batch       Generate multiple passwords at once
  check-leak  Check if password appeared in breaches (k-anonymity, safe)
  diceware    Generate a diceware-style passphrase
  pin         Generate a numeric PIN
  help        Show this help message

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
}

# Generate random bytes and map to charset
_rand_chars() {
    local charset="$1" count="$2"
    local charset_len=${#charset}
    local result=""
    local bytes
    bytes=$(od -An -tu1 -N "$((count * 2))" /dev/urandom | tr -s ' ' '\n' | grep -v '^$')
    local collected=0
    while IFS= read -r byte; do
        [[ $collected -ge $count ]] && break
        local idx=$(( byte % charset_len ))
        result+="${charset:$idx:1}"
        ((collected++))
    done <<< "$bytes"
    echo "$result"
}

# Shuffle a string in-place using Fisher-Yates on chars
_shuffle_string() {
    local s="$1"
    local len=${#s}
    local arr=()
    for (( i=0; i<len; i++ )); do
        arr+=("${s:$i:1}")
    done
    local bytes
    bytes=$(od -An -tu4 -N "$((len * 4))" /dev/urandom | tr -s ' ' '\n' | grep -v '^$')
    local idx=0
    local rand_vals=()
    while IFS= read -r v; do
        rand_vals+=("$v")
    done <<< "$bytes"
    for (( i=len-1; i>0; i-- )); do
        local j=$(( rand_vals[idx] % (i + 1) ))
        ((idx++)) || true
        local tmp="${arr[$i]}"
        arr[$i]="${arr[$j]}"
        arr[$j]="$tmp"
    done
    local out=""
    for c in "${arr[@]}"; do out+="$c"; done
    echo "$out"
}

# ── Commands ─────────────────────────────────────────────────────────────────

cmd_generate() {
    local length=16
    local use_symbols=false
    local use_upper=true
    local use_digits=true

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --symbols)    use_symbols=true; shift ;;
            --no-upper)   use_upper=false; shift ;;
            --no-digits)  use_digits=false; shift ;;
            [0-9]*)       length="$1"; shift ;;
            *)            die "Unknown option: $1" ;;
        esac
    done

    [[ $length -lt 4 ]] && die "Minimum length is 4"
    [[ $length -gt 256 ]] && die "Maximum length is 256"

    # Build charset
    local charset="$LOWER"
    $use_upper && charset+="$UPPER"
    $use_digits && charset+="$DIGITS"
    $use_symbols && charset+="$SYMBOLS"

    # Generate with guaranteed character class coverage
    local required=""
    required+="$(_rand_chars "$LOWER" 1)"
    $use_upper && required+="$(_rand_chars "$UPPER" 1)"
    $use_digits && required+="$(_rand_chars "$DIGITS" 1)"
    $use_symbols && required+="$(_rand_chars "$SYMBOLS" 1)"

    local remaining=$(( length - ${#required} ))
    [[ $remaining -lt 0 ]] && remaining=0

    local fill=""
    if [[ $remaining -gt 0 ]]; then
        fill="$(_rand_chars "$charset" "$remaining")"
    fi

    local password
    password="$(_shuffle_string "${required}${fill}")"
    echo "$password"
}

cmd_strength() {
    local pw="${1:-}"
    [[ -z "$pw" ]] && die "Usage: password strength <password>"

    local score=0
    local len=${#pw}
    local feedback=()

    # Length scoring
    if [[ $len -ge 16 ]]; then
        ((score += 30))
    elif [[ $len -ge 12 ]]; then
        ((score += 20))
    elif [[ $len -ge 8 ]]; then
        ((score += 10))
    else
        feedback+=("Too short (min 8 recommended)")
    fi

    # Character class diversity
    [[ "$pw" =~ [a-z] ]] && ((score += 10)) || feedback+=("No lowercase letters")
    [[ "$pw" =~ [A-Z] ]] && ((score += 15)) || feedback+=("No uppercase letters")
    [[ "$pw" =~ [0-9] ]] && ((score += 10)) || feedback+=("No digits")
    [[ "$pw" =~ [^a-zA-Z0-9] ]] && ((score += 20)) || feedback+=("No special characters")

    # Bonus for length beyond 20
    if [[ $len -ge 20 ]]; then
        ((score += 10))
    fi

    # Penalize repeated characters
    local unique_chars
    unique_chars=$(echo -n "$pw" | fold -w1 | sort -u | wc -l)
    local ratio=$(( (unique_chars * 100) / len ))
    if [[ $ratio -lt 40 ]]; then
        ((score -= 15))
        feedback+=("Too many repeated characters")
    elif [[ $ratio -ge 80 ]]; then
        ((score += 5))
    fi

    # Penalize common patterns
    local pw_lower
    pw_lower=$(echo "$pw" | tr '[:upper:]' '[:lower:]')
    for pattern in "password" "123456" "qwerty" "abc123" "admin" "letmein" "welcome" "monkey"; do
        if [[ "$pw_lower" == *"$pattern"* ]]; then
            ((score -= 20))
            feedback+=("Contains common pattern: $pattern")
        fi
    done

    # Penalize sequential characters
    if echo "$pw" | grep -qP '(.)\1{2,}'; then
        ((score -= 10))
        feedback+=("Contains character repetitions (3+)")
    fi

    [[ $score -lt 0 ]] && score=0
    [[ $score -gt 100 ]] && score=100

    local rating
    if [[ $score -ge 85 ]]; then rating="EXCELLENT ████████████████████ ✓"
    elif [[ $score -ge 70 ]]; then rating="STRONG   ████████████████░░░░"
    elif [[ $score -ge 50 ]]; then rating="GOOD     ████████████░░░░░░░░"
    elif [[ $score -ge 30 ]]; then rating="FAIR     ████████░░░░░░░░░░░░"
    else rating="WEAK     ████░░░░░░░░░░░░░░░░ ✗"
    fi

    echo "Password Strength Analysis"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Length:   $len characters"
    echo "Score:    $score / 100"
    echo "Rating:   $rating"
    if [[ ${#feedback[@]} -gt 0 ]]; then
        echo ""
        echo "Suggestions:"
        for f in "${feedback[@]}"; do
            echo "  • $f"
        done
    fi
}

cmd_entropy() {
    local pw="${1:-}"
    [[ -z "$pw" ]] && die "Usage: password entropy <password>"

    local len=${#pw}

    # Determine pool size based on character classes present
    local pool=0
    [[ "$pw" =~ [a-z] ]] && ((pool += 26))
    [[ "$pw" =~ [A-Z] ]] && ((pool += 26))
    [[ "$pw" =~ [0-9] ]] && ((pool += 10))
    [[ "$pw" =~ [^a-zA-Z0-9] ]] && ((pool += 32))
    [[ $pool -eq 0 ]] && pool=1

    # Entropy = len * log2(pool)
    # log2(x) = ln(x) / ln(2) — use awk for floating point
    local entropy
    entropy=$(awk -v l="$len" -v p="$pool" 'BEGIN { printf "%.2f", l * (log(p) / log(2)) }')

    # Shannon entropy per character (actual distribution)
    local shannon
    shannon=$(echo -n "$pw" | fold -w1 | sort | uniq -c | awk '
        BEGIN { total=0; ent=0 }
        { counts[NR]=$1; total+=$1 }
        END {
            for (i in counts) {
                p = counts[i] / total
                ent -= p * (log(p) / log(2))
            }
            printf "%.2f", ent * total
        }
    ')

    local strength
    if awk "BEGIN { exit ($entropy >= 128) ? 0 : 1 }"; then strength="Excellent (128+ bits)"
    elif awk "BEGIN { exit ($entropy >= 80) ? 0 : 1 }"; then strength="Strong (80+ bits)"
    elif awk "BEGIN { exit ($entropy >= 60) ? 0 : 1 }"; then strength="Adequate (60+ bits)"
    elif awk "BEGIN { exit ($entropy >= 40) ? 0 : 1 }"; then strength="Weak (40+ bits)"
    else strength="Very Weak (<40 bits)"
    fi

    echo "Entropy Analysis"
    echo "━━━━━━━━━━━━━━━━"
    echo "Length:          $len characters"
    echo "Character pool:  $pool possible characters"
    echo "Max entropy:     ${entropy} bits"
    echo "Shannon entropy: ${shannon} bits"
    echo "Strength:        $strength"
    echo ""
    echo "Note: Max entropy assumes random selection from the pool."
    echo "      Shannon entropy measures actual randomness of this password."
}

cmd_batch() {
    local count="${1:-5}"
    local length="${2:-16}"
    local extra_args=()

    shift 2 2>/dev/null || true
    while [[ $# -gt 0 ]]; do
        extra_args+=("$1")
        shift
    done

    [[ $count -lt 1 || $count -gt 100 ]] && die "Count must be between 1 and 100"

    echo "Generating $count passwords (length=$length):"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    for (( i=1; i<=count; i++ )); do
        printf "%3d. %s\n" "$i" "$(cmd_generate "$length" "${extra_args[@]}")"
    done
}

cmd_check_leak() {
    local pw="${1:-}"
    [[ -z "$pw" ]] && die "Usage: password check-leak <password>"

    command -v curl &>/dev/null || die "curl is required for breach checking"

    # k-anonymity: only send first 5 chars of SHA-1 hash
    local sha1
    sha1=$(printf '%s' "$pw" | openssl sha1 | awk '{print toupper($NF)}')

    local prefix="${sha1:0:5}"
    local suffix="${sha1:5}"

    echo "Checking password against Have I Been Pwned database..."
    echo "(Using k-anonymity — your full password is never sent)"
    echo ""

    local response
    response=$(curl -sS "https://api.pwnedpasswords.com/range/${prefix}" 2>&1) || {
        die "Failed to reach HIBP API. Check your internet connection."
    }

    local match
    match=$(echo "$response" | grep -i "^${suffix}:" || true)

    if [[ -n "$match" ]]; then
        local occurrences
        occurrences=$(echo "$match" | cut -d: -f2 | tr -d '[:space:]')
        echo "⚠  PASSWORD COMPROMISED"
        echo "   This password has appeared in ${occurrences} data breach(es)."
        echo "   You should NOT use this password."
        return 1
    else
        echo "✓  Password not found in any known breaches."
        echo "   (This doesn't guarantee safety — use a strong unique password.)"
        return 0
    fi
}

cmd_diceware() {
    local word_count="${1:-6}"
    [[ $word_count -lt 3 || $word_count -gt 20 ]] && die "Word count must be between 3 and 20"

    # Embedded minimal word list (common EFF-inspired short words)
    local words=(
        able acid aged also area army away baby back ball band bank base bath bear beat been beer bell belt best bill bird bite blow blue boat body bomb bond bone book born boss both bowl burn busy cafe cage cake call calm came camp card care case cash cast cave chat chip city claim clan clay clip club coal coat code coin cold come cook cool cope copy core cost crew crop cube curl cute dare dark data date dawn days dead deal dear debt deck deep deer demo deny desk dial diet dirt dish disk dock does done door dose down draw drew drop drug drum dual duel duke dumb dump dust duty each earn ease east easy edge else emit ends envy epic euro even evil exam exec exit face fact fail fair fall fame fast fate fear feed feel feet fell file fill film find fine fire firm fish fist five flag flat flew flip flow fold folk food foot ford fore fork form fort four free from fuel full fund gain game gang gate gave gear gene gift girl give glad glow glue goal goes gold golf gone good grab gray grew grey grip grow gulf guru half hall hand hang hard harm hash hate have head heal heap hear heat heavy heel held help here hero high hill hint hire hold hole holy home hope horn host hour huge hung hunt idea inch info iron isle item jack jail jean jobs join joke jump jury just keen keep kent keys kick kids kill kind king kiss knee knew knit knot know lack laid lake lamp land lane last late lawn laws lead left lend less life lift like limb line link lion list live load loan lock logo long look lord lose loss lost lots love luck made mail main make male mall many maps mark mass mate mayo meal mean meat meet menu mere mess mile milk mind mine miss mode mood moon more most move much must myth name navy near neat neck need nest news next nice nine node none norm nose note noun odds okay once only onto open oral otto ours oval oven over pace pack page paid pair palm palm pane papa park part pass past path paul peak peer pick pile pine pink pipe plan play plot plug plus poem poet poll pond pool poor pope port pose post pour pray prey pull pump pure push race rain rank rare rate read real rear rely rent rest rice rich ride ring rise risk road rock role roll roof room root rope rose rule rush ruth safe said sake sale salt same sand sang save seal seat seed seek seem seen self sell semi send sent sept shed ship shop shot show shut sick side sign silk site size skin slip slot slow snap snow soft soil sold some song soon sort soul spot star stay stem step stop such suit sure swim tail take tale talk tall tank tape task taxi team tech tell tend tent term test text than that them then they thin this thus tide tied till time tiny told toll tone took tool tops tore torn tour town trap tree trim trip true tube luck turn twin type ugly unit upon urge used user vast very vice view vote wage wait wake walk wall want ward warm wash wave weak wear week well went were west what when whom wide wife wild will wind wine wing wire wise wish with wood word wore work worn wrap yard yeah year your zero zone
    )
    local dict_size=${#words[@]}

    local passphrase=()
    local rand_bytes
    rand_bytes=$(od -An -tu4 -N "$((word_count * 4))" /dev/urandom | tr -s ' ' '\n' | grep -v '^$')

    local idx=0
    while IFS= read -r val; do
        [[ $idx -ge $word_count ]] && break
        local word_idx=$(( val % dict_size ))
        passphrase+=("${words[$word_idx]}")
        ((idx++))
    done <<< "$rand_bytes"

    local result
    result=$(IFS='-'; echo "${passphrase[*]}")

    # Estimate entropy: log2(dict_size) * word_count
    local entropy
    entropy=$(awk -v n="$word_count" -v s="$dict_size" 'BEGIN { printf "%.1f", n * (log(s)/log(2)) }')

    echo "Diceware Passphrase"
    echo "━━━━━━━━━━━━━━━━━━━"
    echo "Passphrase: $result"
    echo "Words:      $word_count"
    echo "Dictionary: $dict_size words"
    echo "Entropy:    ~${entropy} bits"
}

cmd_pin() {
    local length="${1:-6}"
    [[ $length -lt 3 || $length -gt 20 ]] && die "PIN length must be between 3 and 20"

    local pin
    pin=$(_rand_chars "$DIGITS" "$length")
    echo "PIN: $pin"
    echo "Length: $length digits"
}

# ── Main ─────────────────────────────────────────────────────────────────────

main() {
    local cmd="${1:-help}"
    shift 2>/dev/null || true

    case "$cmd" in
        generate)    cmd_generate "$@" ;;
        strength)    cmd_strength "$@" ;;
        entropy)     cmd_entropy "$@" ;;
        batch)       cmd_batch "$@" ;;
        check-leak)  cmd_check_leak "$@" ;;
        diceware)    cmd_diceware "$@" ;;
        pin)         cmd_pin "$@" ;;
        help|--help|-h) usage ;;
        version)     echo "password-tool v${VERSION}" ;;
        *)           die "Unknown command: $cmd. Run 'password help' for usage." ;;
    esac
}

main "$@"
