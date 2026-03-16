#!/usr/bin/env bash
# excel-formula — Excel/Sheets formula builder and reference
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${EXCEL_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/excel-formula}"
mkdir -p "$DATA_DIR"

show_help() {
    cat << HELP
excel-formula v$VERSION

Usage: excel-formula <command> [args]

Lookup:
  find <keyword>              Search formulas by function name
  explain <formula>           Explain what a formula does
  category <cat>              List formulas by category
  categories                  List all categories

Builders:
  vlookup <table> <col>       Build VLOOKUP formula
  index-match <table> <col>   Build INDEX-MATCH (better VLOOKUP)
  sumifs <range> <criteria>   Build SUMIFS formula
  countifs <range> <criteria> Build COUNTIFS formula
  pivot <data> <group> <agg>  Pivot table formula
  conditional <condition>     IF/IFS formula builder
  date-calc <operation>       Date calculation formulas
  text-ops <operation>        Text manipulation formulas

Utils:
  convert <formula> <to>      Convert between Excel/Sheets/Calc
  debug <formula>             Debug formula errors
  cheatsheet                  Quick reference card
  tips                        Pro tips
  history                     Recent lookups

HELP
}

cmd_find() {
    local kw="${1:?Usage: excel-formula find <keyword>}"
    local kw_upper=$(echo "$kw" | tr '[:lower:]' '[:upper:]')
    echo "  Formulas matching '$kw':"
    
    declare -A formulas=(
        ["SUM"]="SUM(range) — Add values"
        ["AVERAGE"]="AVERAGE(range) — Mean of values"
        ["COUNT"]="COUNT(range) — Count numbers"
        ["COUNTA"]="COUNTA(range) — Count non-empty"
        ["COUNTIF"]="COUNTIF(range, criteria) — Conditional count"
        ["SUMIF"]="SUMIF(range, criteria, sum_range) — Conditional sum"
        ["VLOOKUP"]="VLOOKUP(value, table, col, FALSE) — Vertical lookup"
        ["HLOOKUP"]="HLOOKUP(value, table, row, FALSE) — Horizontal lookup"
        ["INDEX"]="INDEX(range, row, col) — Return cell value"
        ["MATCH"]="MATCH(value, range, 0) — Find position"
        ["IF"]="IF(condition, true_val, false_val) — Conditional"
        ["IFS"]="IFS(cond1, val1, cond2, val2, ...) — Multiple conditions"
        ["CONCATENATE"]="CONCATENATE(a, b, ...) — Join text"
        ["LEFT"]="LEFT(text, n) — First n characters"
        ["RIGHT"]="RIGHT(text, n) — Last n characters"
        ["MID"]="MID(text, start, n) — Extract substring"
        ["LEN"]="LEN(text) — Text length"
        ["TRIM"]="TRIM(text) — Remove extra spaces"
        ["UPPER"]="UPPER(text) — To uppercase"
        ["LOWER"]="LOWER(text) — To lowercase"
        ["TODAY"]="TODAY() — Current date"
        ["NOW"]="NOW() — Current date and time"
        ["DATEDIF"]="DATEDIF(start, end, unit) — Date difference"
        ["YEAR"]="YEAR(date) — Extract year"
        ["MONTH"]="MONTH(date) — Extract month"
        ["ROUND"]="ROUND(number, digits) — Round number"
        ["ABS"]="ABS(number) — Absolute value"
        ["MAX"]="MAX(range) — Maximum value"
        ["MIN"]="MIN(range) — Minimum value"
        ["MEDIAN"]="MEDIAN(range) — Median value"
        ["STDEV"]="STDEV(range) — Standard deviation"
        ["IFERROR"]="IFERROR(formula, fallback) — Handle errors"
        ["UNIQUE"]="UNIQUE(range) — Remove duplicates"
        ["SORT"]="SORT(range, col, order) — Sort data"
        ["FILTER"]="FILTER(range, condition) — Filter rows"
        ["XLOOKUP"]="XLOOKUP(value, lookup, return, default) — Modern lookup"
    )
    
    local found=0
    for key in $(echo "${!formulas[@]}" | tr ' ' '\n' | sort); do
        if echo "$key" | grep -qi "$kw"; then
            echo "    ${formulas[$key]}"
            found=$((found + 1))
        fi
    done
    [ "$found" -eq 0 ] && echo "    No matches. Try: sum, lookup, if, date, text"
    _log "find" "$kw ($found results)"
}

cmd_explain() {
    local formula="${1:?Usage: excel-formula explain <formula>}"
    echo "  Formula Analysis: $formula"
    echo "  ─────────────────────────────"
    
    # Extract function names
    local funcs=$(echo "$formula" | grep -oP '[A-Z]+(?=\()' | sort -u)
    for func in $funcs; do
        echo "  → $func: $(cmd_find "$func" 2>/dev/null | head -1 | sed 's/.*— //')"
    done
    
    # Count nesting
    local depth=$(echo "$formula" | tr -cd '(' | wc -c)
    echo "  Nesting depth: $depth"
    _log "explain" "${formula:0:30}"
}

cmd_vlookup() {
    local table="${1:?Usage: excel-formula vlookup <table-range> <col-index>}"
    local col="${2:-2}"
    echo "  VLOOKUP Builder:"
    echo "  ═══════════════════════════════"
    echo "  =VLOOKUP(A2, $table, $col, FALSE)"
    echo ""
    echo "  Parameters:"
    echo "    lookup_value: A2 (change to your cell)"
    echo "    table_array:  $table"
    echo "    col_index:    $col"
    echo "    exact_match:  FALSE (exact)"
    echo ""
    echo "  Better alternative: INDEX-MATCH"
    echo "  =INDEX(${table%%:*}:${table##*:}, MATCH(A2, ${table%%:*}:${table%%:*}, 0), $col)"
}

cmd_index_match() {
    local table="${1:?Usage: excel-formula index-match <table> <col>}"
    local col="${2:-2}"
    echo "  INDEX-MATCH Builder:"
    echo "  ═══════════════════════════════"
    echo "  =INDEX(return_range, MATCH(lookup_value, lookup_range, 0))"
    echo ""
    echo "  Why better than VLOOKUP:"
    echo "  ✓ Lookup column can be anywhere"
    echo "  ✓ Faster on large datasets"
    echo "  ✓ Won't break when columns move"
}

cmd_sumifs() {
    local range="${1:?Usage: excel-formula sumifs <sum-range> <criteria>}"
    local criteria="${2:-\">0\"}"
    echo "  SUMIFS Builder:"
    echo "  =SUMIFS($range, criteria_range1, $criteria)"
    echo ""
    echo "  Multi-criteria:"
    echo "  =SUMIFS($range, col1, \">100\", col2, \"=A\", col3, \"<>0\")"
}

cmd_conditional() {
    local cond="${1:?Usage: excel-formula conditional <condition>}"
    echo "  Conditional Formula Builder:"
    echo ""
    echo "  Simple IF:"
    echo "    =IF($cond, \"Yes\", \"No\")"
    echo ""
    echo "  Nested IF:"
    echo "    =IF($cond, \"High\", IF(A1>50, \"Medium\", \"Low\"))"
    echo ""
    echo "  IFS (cleaner):"
    echo "    =IFS($cond, \"High\", A1>50, \"Medium\", TRUE, \"Low\")"
    echo ""
    echo "  SWITCH:"
    echo "    =SWITCH(A1, 1, \"One\", 2, \"Two\", \"Other\")"
}

cmd_date_calc() {
    local op="${1:-age}"
    echo "  Date Formulas ($op):"
    case "$op" in
        age)
            echo "    =DATEDIF(birthdate, TODAY(), \"Y\") → years"
            echo "    =DATEDIF(A1, B1, \"M\") → months between"
            echo "    =DATEDIF(A1, B1, \"D\") → days between"
            ;;
        add)
            echo "    =A1 + 30 → add 30 days"
            echo "    =EDATE(A1, 3) → add 3 months"
            echo "    =DATE(YEAR(A1)+1, MONTH(A1), DAY(A1)) → add 1 year"
            ;;
        weekday)
            echo "    =WEEKDAY(A1) → day of week (1-7)"
            echo "    =NETWORKDAYS(A1, B1) → business days"
            echo "    =WORKDAY(A1, 10) → 10 business days later"
            ;;
        *)
            echo "    Operations: age, add, weekday, quarter, fiscal"
            ;;
    esac
}

cmd_text_ops() {
    local op="${1:-extract}"
    echo "  Text Formulas ($op):"
    case "$op" in
        extract)
            echo "    =LEFT(A1, 3) → first 3 chars"
            echo "    =RIGHT(A1, 4) → last 4 chars"
            echo "    =MID(A1, 2, 5) → 5 chars from pos 2"
            ;;
        clean)
            echo "    =TRIM(A1) → remove extra spaces"
            echo "    =CLEAN(A1) → remove non-printable"
            echo "    =SUBSTITUTE(A1, \"old\", \"new\")"
            ;;
        combine)
            echo "    =A1 & \" \" & B1 → concatenate"
            echo "    =TEXTJOIN(\", \", TRUE, A1:A10) → join with comma"
            ;;
        *)
            echo "    Operations: extract, clean, combine, split, case"
            ;;
    esac
}

cmd_categories() {
    echo "  Formula Categories:"
    echo "    math      — SUM, AVERAGE, ROUND, ABS, MOD"
    echo "    lookup    — VLOOKUP, INDEX, MATCH, XLOOKUP"
    echo "    text      — LEFT, RIGHT, MID, TRIM, CONCAT"
    echo "    date      — TODAY, YEAR, MONTH, DATEDIF"
    echo "    logic     — IF, IFS, AND, OR, NOT"
    echo "    stats     — COUNT, COUNTA, MEDIAN, STDEV"
    echo "    filter    — FILTER, SORT, UNIQUE"
    echo "    error     — IFERROR, ISNA, ISERROR"
}

cmd_cheatsheet() {
    echo "  ═══ EXCEL FORMULA CHEATSHEET ═══"
    echo ""
    echo "  LOOKUP           │ MATH             │ TEXT"
    echo "  VLOOKUP(v,t,c,F) │ SUM(range)       │ LEFT(t,n)"
    echo "  INDEX(r,row,col) │ AVERAGE(range)    │ RIGHT(t,n)"
    echo "  MATCH(v,r,0)     │ ROUND(n,d)       │ MID(t,s,n)"
    echo "  XLOOKUP(v,l,r)   │ MAX/MIN(range)   │ TRIM(t)"
    echo ""
    echo "  LOGIC            │ DATE             │ STATS"
    echo "  IF(c,t,f)        │ TODAY()          │ COUNT(r)"
    echo "  IFS(c1,v1,...)   │ DATEDIF(s,e,u)   │ COUNTA(r)"
    echo "  AND/OR(c1,c2)    │ EDATE(d,m)       │ COUNTIF(r,c)"
    echo "  IFERROR(f,alt)   │ NETWORKDAYS(s,e) │ SUMIF(r,c,s)"
}

cmd_tips() {
    echo "  ═══ PRO TIPS ═══"
    echo "  1. Use XLOOKUP instead of VLOOKUP (newer, better)"
    echo "  2. Wrap formulas in IFERROR to handle #N/A"
    echo "  3. Use named ranges for readability"
    echo "  4. F4 to toggle absolute references (\$A\$1)"
    echo "  5. Ctrl+\` to show all formulas"
    echo "  6. Use Tables for auto-expanding ranges"
    echo "  7. INDEX-MATCH > VLOOKUP for flexibility"
}

cmd_debug() {
    local formula="${1:?Usage: excel-formula debug <formula>}"
    echo "  Debug: $formula"
    echo "  ─────────────────────"
    echo "  Common issues:"
    echo "  • #N/A → lookup value not found"
    echo "  • #REF → deleted column/row reference"
    echo "  • #VALUE → wrong data type"
    echo "  • #DIV/0! → dividing by zero"
    echo "  • #NAME? → misspelled function name"
    echo "  Fix: =IFERROR($formula, \"Error\")"
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

case "${1:-help}" in
    find|search)    shift; cmd_find "$@" ;;
    explain)        shift; cmd_explain "$@" ;;
    category|cat)   shift; cmd_categories ;;
    categories)     cmd_categories ;;
    vlookup)        shift; cmd_vlookup "$@" ;;
    index-match|im) shift; cmd_index_match "$@" ;;
    sumifs)         shift; cmd_sumifs "$@" ;;
    countifs)       shift; echo "Similar to SUMIFS but counts" ;;
    pivot)          shift; echo "TODO: pivot formulas" ;;
    conditional|if) shift; cmd_conditional "$@" ;;
    date-calc|date) shift; cmd_date_calc "$@" ;;
    text-ops|text)  shift; cmd_text_ops "$@" ;;
    convert)        shift; echo "TODO: formula conversion" ;;
    debug)          shift; cmd_debug "$@" ;;
    cheatsheet|cs)  cmd_cheatsheet ;;
    tips)           cmd_tips ;;
    history)        [ -f "$DATA_DIR/history.log" ] && tail -20 "$DATA_DIR/history.log" || echo "No history" ;;
    help|-h)        show_help ;;
    version|-v)     echo "excel-formula v$VERSION" ;;
    *)              echo "Unknown: $1"; show_help; exit 1 ;;
esac
