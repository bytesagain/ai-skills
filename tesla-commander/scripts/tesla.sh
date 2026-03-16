#!/usr/bin/env bash
# Tesla Commander — Control Tesla vehicles via Fleet API
# Usage: bash tesla.sh <command> [options]
set -euo pipefail

COMMAND="${1:-help}"
shift 2>/dev/null || true

TESLA_TOKEN="${TESLA_ACCESS_TOKEN:-}"
TESLA_VIN="${TESLA_VIN:-}"
DATA_DIR="${HOME}/.tesla-commander"
mkdir -p "$DATA_DIR"

_api() {
  local method="$1" endpoint="$2" data="${3:-}"
  local url="https://fleet-api.prd.na.vn.cloud.tesla.com/api/1${endpoint}"
  
  if [ -z "$TESLA_TOKEN" ]; then
    config_file="$DATA_DIR/config.json"
    if [ -f "$config_file" ]; then
      TESLA_TOKEN=$(python3 -c "import json;print(json.load(open('$config_file')).get('access_token',''))" 2>/dev/null)
    fi
  fi
  
  if [ "$method" = "GET" ]; then
    curl -s -H "Authorization: Bearer $TESLA_TOKEN" "$url"
  else
    curl -s -X "$method" -H "Authorization: Bearer $TESLA_TOKEN" -H "Content-Type: application/json" -d "$data" "$url"
  fi
}

case "$COMMAND" in
  setup)
    python3 << 'PYEOF'
import os, json

data_dir = os.path.expanduser("~/.tesla-commander")

print("=" * 60)
print("TESLA COMMANDER SETUP")
print("=" * 60)
print("")
print("To use Tesla Commander, you need a Tesla Fleet API token.")
print("")
print("OPTION 1: Tesla Developer Account (recommended)")
print("  1. Go to https://developer.tesla.com/")
print("  2. Create an application")
print("  3. Generate OAuth tokens")
print("  4. Set env vars:")
print("     export TESLA_ACCESS_TOKEN=<your_token>")
print("     export TESLA_VIN=<your_vehicle_vin>")
print("")
print("OPTION 2: Third-party tools")
print("  - Tesla Auth (iOS/Android): Generate tokens locally")
print("  - TeslaMate: Self-hosted Tesla data logger")
print("  - tesla_http_proxy: Local proxy for Fleet API")
print("")
print("OPTION 3: Manual config file")
print("  Save to {}/config.json:".format(data_dir))
print('  {')
print('    "access_token": "your_token_here",')
print('    "vin": "your_vin_here"')
print('  }')
print("")
print("SCOPES NEEDED:")
scopes = [
    "vehicle_device_data — Read vehicle data",
    "vehicle_cmds — Send commands (lock, climate, etc.)",
    "vehicle_charging_cmds — Control charging",
    "vehicle_location — Read GPS location"
]
for s in scopes:
    print("  - {}".format(s))
PYEOF
    ;;

  vehicles)
    python3 << 'PYEOF'
import json, os, sys
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

token = os.environ.get("TESLA_ACCESS_TOKEN", "")
data_dir = os.path.expanduser("~/.tesla-commander")
if not token:
    config_file = os.path.join(data_dir, "config.json")
    if os.path.exists(config_file):
        with open(config_file) as f:
            token = json.load(f).get("access_token", "")

if not token:
    print("Not configured. Run 'bash tesla.sh setup'")
    sys.exit(1)

try:
    url = "https://fleet-api.prd.na.vn.cloud.tesla.com/api/1/vehicles"
    req = Request(url)
    req.add_header("Authorization", "Bearer {}".format(token))
    resp = urlopen(req, timeout=15)
    data = json.loads(resp.read().decode("utf-8"))
    
    vehicles = data.get("response", [])
    print("=" * 65)
    print("YOUR TESLA VEHICLES ({})".format(len(vehicles)))
    print("=" * 65)
    print("")
    
    for i, v in enumerate(vehicles, 1):
        name = v.get("display_name", "?")
        vin = v.get("vin", "?")
        state = v.get("state", "?")
        model = v.get("vehicle_config", {}).get("car_type", "?")
        
        icon = "🟢" if state == "online" else "🔴" if state == "asleep" else "🟡"
        print("  {}. {} {} — {}".format(i, icon, name, state))
        print("     VIN: {}".format(vin))
        print("     Model: {}".format(model))
        print("     Set: export TESLA_VIN={}".format(vin))
        print("")

except Exception as e:
    print("Error: {}".format(str(e)))
    print("Check your access token.")
PYEOF
    ;;

  status)
    python3 << 'PYEOF'
import json, os, sys
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

token = os.environ.get("TESLA_ACCESS_TOKEN", "")
vin = os.environ.get("TESLA_VIN", "")
data_dir = os.path.expanduser("~/.tesla-commander")
if not token or not vin:
    config_file = os.path.join(data_dir, "config.json")
    if os.path.exists(config_file):
        with open(config_file) as f:
            cfg = json.load(f)
        token = token or cfg.get("access_token", "")
        vin = vin or cfg.get("vin", "")

if not token or not vin:
    print("Set TESLA_ACCESS_TOKEN and TESLA_VIN. Run 'bash tesla.sh setup'")
    sys.exit(1)

try:
    url = "https://fleet-api.prd.na.vn.cloud.tesla.com/api/1/vehicles/{}/vehicle_data".format(vin)
    req = Request(url)
    req.add_header("Authorization", "Bearer {}".format(token))
    resp = urlopen(req, timeout=15)
    data = json.loads(resp.read().decode("utf-8")).get("response", {})
    
    charge = data.get("charge_state", {})
    climate = data.get("climate_state", {})
    drive = data.get("drive_state", {})
    vehicle = data.get("vehicle_state", {})
    
    print("=" * 60)
    print("TESLA STATUS — {}".format(data.get("display_name", vin)))
    print("=" * 60)
    
    print("")
    print("🔋 Battery & Charging:")
    print("   Level: {}%".format(charge.get("battery_level", "?")))
    print("   Range: {:.0f} mi / {:.0f} km".format(
        charge.get("battery_range", 0),
        charge.get("battery_range", 0) * 1.609))
    print("   Charging: {}".format(charge.get("charging_state", "?")))
    if charge.get("charging_state") == "Charging":
        print("   Rate: {} mi/hr".format(charge.get("charge_rate", "?")))
        print("   Time to full: {} min".format(charge.get("minutes_to_full_charge", "?")))
    print("   Charge limit: {}%".format(charge.get("charge_limit_soc", "?")))
    
    print("")
    print("🌡️ Climate:")
    inside = climate.get("inside_temp", 0)
    outside = climate.get("outside_temp", 0)
    print("   Inside: {:.1f}°C / {:.1f}°F".format(inside, inside * 9/5 + 32))
    print("   Outside: {:.1f}°C / {:.1f}°F".format(outside, outside * 9/5 + 32))
    print("   HVAC: {}".format("ON" if climate.get("is_climate_on") else "OFF"))
    print("   Set to: {:.1f}°C".format(climate.get("driver_temp_setting", 0)))
    
    print("")
    print("📍 Location:")
    lat = drive.get("latitude", 0)
    lon = drive.get("longitude", 0)
    print("   GPS: {}, {}".format(lat, lon))
    print("   Speed: {} mph".format(drive.get("speed", 0) or 0))
    print("   Heading: {}°".format(drive.get("heading", 0)))
    if lat and lon:
        print("   Map: https://maps.google.com/maps?q={},{}".format(lat, lon))
    
    print("")
    print("🔒 Vehicle:")
    print("   Locked: {}".format("Yes" if vehicle.get("locked") else "No"))
    print("   Doors: {}".format("All closed" if not vehicle.get("df", 0) and not vehicle.get("dr", 0) else "Open"))
    print("   Trunk: {}".format("Open" if vehicle.get("rt", 0) else "Closed"))
    print("   Frunk: {}".format("Open" if vehicle.get("ft", 0) else "Closed"))
    print("   Sentry: {}".format("ON" if vehicle.get("sentry_mode") else "OFF"))
    print("   Odometer: {:,.0f} mi".format(vehicle.get("odometer", 0)))
    
    # Save snapshot
    snap_file = os.path.join(data_dir, "status-latest.json")
    with open(snap_file, "w") as f:
        json.dump(data, f, indent=2)

except Exception as e:
    print("Error: {}".format(str(e)))
    print("Vehicle may be asleep. Try 'bash tesla.sh wake' first.")
PYEOF
    ;;

  wake)
    echo "Waking up vehicle..."
    _api POST "/vehicles/${TESLA_VIN}/wake_up"
    echo "Wake command sent. Wait 30 seconds then try again."
    ;;

  lock)
    echo "Locking vehicle..."
    _api POST "/vehicles/${TESLA_VIN}/command/door_lock"
    echo "Lock command sent."
    ;;

  unlock)
    echo "Unlocking vehicle..."
    _api POST "/vehicles/${TESLA_VIN}/command/door_unlock"
    echo "Unlock command sent."
    ;;

  climate-on)
    TEMP="${1:-22}"
    echo "Starting climate control at ${TEMP}°C..."
    _api POST "/vehicles/${TESLA_VIN}/command/auto_conditioning_start"
    _api POST "/vehicles/${TESLA_VIN}/command/set_temps" "{\"driver_temp\":${TEMP},\"passenger_temp\":${TEMP}}"
    echo "Climate control started."
    ;;

  climate-off)
    echo "Stopping climate control..."
    _api POST "/vehicles/${TESLA_VIN}/command/auto_conditioning_stop"
    echo "Climate control stopped."
    ;;

  charge-start)
    echo "Starting charge..."
    _api POST "/vehicles/${TESLA_VIN}/command/charge_start"
    echo "Charge started."
    ;;

  charge-stop)
    echo "Stopping charge..."
    _api POST "/vehicles/${TESLA_VIN}/command/charge_stop"
    echo "Charge stopped."
    ;;

  charge-limit)
    LIMIT="${1:-80}"
    echo "Setting charge limit to ${LIMIT}%..."
    _api POST "/vehicles/${TESLA_VIN}/command/set_charge_limit" "{\"percent\":${LIMIT}}"
    echo "Charge limit set."
    ;;

  honk)
    echo "Honking horn..."
    _api POST "/vehicles/${TESLA_VIN}/command/honk_horn"
    ;;

  flash)
    echo "Flashing lights..."
    _api POST "/vehicles/${TESLA_VIN}/command/flash_lights"
    ;;

  sentry-on)
    echo "Enabling sentry mode..."
    _api POST "/vehicles/${TESLA_VIN}/command/set_sentry_mode" '{"on":true}'
    ;;

  sentry-off)
    echo "Disabling sentry mode..."
    _api POST "/vehicles/${TESLA_VIN}/command/set_sentry_mode" '{"on":false}'
    ;;

  help|*)
    cat << 'HELPEOF'
Tesla Commander — Control your Tesla via Fleet API

SETUP:
  setup                  Show configuration instructions
  vehicles               List your vehicles

STATUS:
  status                 Full vehicle status
  wake                   Wake up sleeping vehicle

CONTROLS:
  lock / unlock          Door lock controls
  climate-on [temp_C]    Start climate (default 22°C)
  climate-off            Stop climate
  charge-start / stop    Charging controls
  charge-limit <0-100>   Set charge limit percentage
  honk                   Honk horn
  flash                  Flash headlights
  sentry-on / off        Sentry mode toggle

ENV VARS:
  TESLA_ACCESS_TOKEN — Fleet API access token
  TESLA_VIN          — Vehicle identification number

EXAMPLES:
  bash tesla.sh setup
  bash tesla.sh vehicles
  bash tesla.sh wake
  bash tesla.sh status
  bash tesla.sh climate-on 21
  bash tesla.sh charge-limit 90
  bash tesla.sh lock
HELPEOF
    ;;
esac

echo ""
echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
