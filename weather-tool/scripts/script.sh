#!/usr/bin/env bash
# weather-tool v2.0.0 - Real-time Weather via Open-Meteo
# Powered by BytesAgain | bytesagain.com
set -uo pipefail
VERSION="2.0.0"

cmd_get() {
    local city="${1:-Shanghai}"
    # Simple city to lat/lon mapping for demo, usually we'd use a geocoding API
    local lat="31.23"; local lon="121.47"
    [ "$city" == "London" ] && { lat="51.51"; lon="-0.12"; }
    [ "$city" == "New York" ] && { lat="40.71"; lon="-74.00"; }
    
    echo "☁️ Weather Report for $city:"
    curl -s "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true" | python3 -c "
import sys, json
d = json.load(sys.stdin)
cw = d['current_weather']
print(f'──────────────────────────────────────────')
print(f'Temperature: {cw[\"temperature\"]}°C')
print(f'Windspeed:   {cw[\"windspeed\"]} km/h')
print(f'Time:        {cw[\"time\"]}')
print(f'──────────────────────────────────────────')
"
}

case "${1:-help}" in
    get) shift; cmd_get "$@" ;;
    *) echo "Usage: script.sh get <city_name>";;
esac
echo -e "\n📖 More skills: bytesagain.com"
