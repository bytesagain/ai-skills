#!/usr/bin/env bash
# Philips Hue — Control Hue lights, rooms, and scenes via Bridge API
# Usage: bash hue.sh <command> [options]
set -euo pipefail

COMMAND="${1:-help}"
shift 2>/dev/null || true

HUE_BRIDGE="${HUE_BRIDGE_IP:-}"
HUE_TOKEN="${HUE_API_KEY:-}"
DATA_DIR="${HOME}/.philips-hue"
mkdir -p "$DATA_DIR"

case "$COMMAND" in
  discover)
    python3 << 'PYEOF'
import json, os, sys
try:
    from urllib2 import urlopen
except ImportError:
    from urllib.request import urlopen

print("=" * 60)
print("PHILIPS HUE BRIDGE DISCOVERY")
print("=" * 60)
print("")

# Method 1: mDNS/UPnP discovery via Hue portal
try:
    resp = urlopen("https://discovery.meethue.com/", timeout=10)
    bridges = json.loads(resp.read().decode("utf-8"))
    if bridges:
        print("Found {} bridge(s):".format(len(bridges)))
        for i, b in enumerate(bridges, 1):
            ip = b.get("internalipaddress", "?")
            bid = b.get("id", "?")
            print("  {}. IP: {}  ID: {}".format(i, ip, bid))
            print("     Set env: export HUE_BRIDGE_IP={}".format(ip))
        print("")
        print("Next step: Press the button on your bridge, then run:")
        print("  bash hue.sh pair")
    else:
        print("No bridges found on network.")
except Exception as e:
    print("Discovery failed: {}".format(str(e)))
    print("")
    print("Manual setup:")
    print("  1. Find bridge IP in your router's DHCP table")
    print("  2. export HUE_BRIDGE_IP=<ip>")
    print("  3. Press bridge button")
    print("  4. bash hue.sh pair")
PYEOF
    ;;

  pair)
    python3 << 'PYEOF'
import json, os, sys
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

bridge = os.environ.get("HUE_BRIDGE_IP", "")
if not bridge:
    print("Set HUE_BRIDGE_IP first. Run 'bash hue.sh discover'")
    sys.exit(1)

print("Pairing with bridge at {}...".format(bridge))
print("Make sure you pressed the bridge button in the last 30 seconds!")
print("")

try:
    payload = json.dumps({"devicetype": "bytesagain#openclaw"}).encode("utf-8")
    req = Request("http://{}/api".format(bridge), data=payload)
    req.add_header("Content-Type", "application/json")
    resp = urlopen(req, timeout=10)
    result = json.loads(resp.read().decode("utf-8"))
    
    if isinstance(result, list) and result:
        entry = result[0]
        if "success" in entry:
            token = entry["success"]["username"]
            print("Paired successfully!")
            print("")
            print("Your API key: {}".format(token))
            print("")
            print("Set environment variable:")
            print("  export HUE_API_KEY={}".format(token))
            
            # Save locally
            config_file = os.path.join(os.path.expanduser("~/.philips-hue"), "config.json")
            config = {"bridge_ip": bridge, "api_key": token}
            with open(config_file, "w") as f:
                json.dump(config, f, indent=2)
            print("  (also saved to {})".format(config_file))
        elif "error" in entry:
            err = entry["error"]
            print("Error: {} (type {})".format(err.get("description", "?"), err.get("type", "?")))
            if err.get("type") == 101:
                print("")
                print("Press the bridge button and try again within 30 seconds.")
except Exception as e:
    print("Connection error: {}".format(str(e)))
PYEOF
    ;;

  lights)
    python3 << 'PYEOF'
import json, os, sys
try:
    from urllib2 import urlopen
except ImportError:
    from urllib.request import urlopen

bridge = os.environ.get("HUE_BRIDGE_IP", "")
token = os.environ.get("HUE_API_KEY", "")

if not bridge or not token:
    config_file = os.path.expanduser("~/.philips-hue/config.json")
    if os.path.exists(config_file):
        with open(config_file) as f:
            cfg = json.load(f)
        bridge = bridge or cfg.get("bridge_ip", "")
        token = token or cfg.get("api_key", "")

if not bridge or not token:
    print("Not configured. Run 'bash hue.sh discover' then 'bash hue.sh pair'")
    sys.exit(1)

try:
    resp = urlopen("http://{}/api/{}/lights".format(bridge, token), timeout=10)
    lights = json.loads(resp.read().decode("utf-8"))
    
    print("=" * 65)
    print("HUE LIGHTS")
    print("=" * 65)
    print("")
    print("{:<4} {:<25} {:<8} {:>6} {:>8} {:<15}".format(
        "ID", "Name", "State", "Bri%", "Color", "Type"))
    print("-" * 65)
    
    for lid, light in sorted(lights.items(), key=lambda x: int(x[0])):
        name = light.get("name", "?")[:24]
        state = light.get("state", {})
        on = "ON" if state.get("on", False) else "OFF"
        bri = int(state.get("bri", 0) / 254 * 100)
        
        # Color temp or xy
        ct = state.get("ct", 0)
        if ct > 0:
            kelvin = int(1000000 / ct) if ct > 0 else 0
            color = "{}K".format(kelvin)
        else:
            color = "-"
        
        ltype = light.get("type", "?")[:14]
        
        icon = "💡" if state.get("on") else "⚫"
        print("{:<4} {} {:<23} {:<8} {:>5}% {:>8} {:<15}".format(
            lid, icon, name, on, bri, color, ltype))
    
    print("")
    print("Total: {} lights".format(len(lights)))
except Exception as e:
    print("Error: {}".format(str(e)))
PYEOF
    ;;

  on|off)
    TARGET="${1:-all}"
    STATE="$COMMAND"
    
    python3 << 'PYEOF'
import json, os, sys
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

bridge = os.environ.get("HUE_BRIDGE_IP", "")
token = os.environ.get("HUE_API_KEY", "")
target = sys.argv[1] if len(sys.argv) > 1 else "all"
state = True if os.environ.get("COMMAND", "on") == "on" or "on" in sys.argv else False

# Check command from parent
import subprocess
state_str = "STATE"
# Determine from the script name/args
for arg in sys.argv:
    if arg == "on":
        state = True
    elif arg == "off":
        state = False

config_file = os.path.expanduser("~/.philips-hue/config.json")
if (not bridge or not token) and os.path.exists(config_file):
    with open(config_file) as f:
        cfg = json.load(f)
    bridge = bridge or cfg.get("bridge_ip", "")
    token = token or cfg.get("api_key", "")

if not bridge or not token:
    print("Not configured. Run 'bash hue.sh discover' and 'bash hue.sh pair'")
    sys.exit(1)

action_word = "on" if state else "off"

if target == "all":
    # Control all lights via groups/0
    try:
        payload = json.dumps({"on": state}).encode("utf-8")
        req = Request("http://{}/api/{}/groups/0/action".format(bridge, token), data=payload)
        req.add_header("Content-Type", "application/json")
        req.get_method = lambda: "PUT"
        resp = urlopen(req, timeout=10)
        print("All lights turned {}".format(action_word))
    except Exception as e:
        print("Error: {}".format(str(e)))
else:
    try:
        payload = json.dumps({"on": state}).encode("utf-8")
        req = Request("http://{}/api/{}/lights/{}/state".format(bridge, token, target), data=payload)
        req.add_header("Content-Type", "application/json")
        req.get_method = lambda: "PUT"
        resp = urlopen(req, timeout=10)
        print("Light {} turned {}".format(target, action_word))
    except Exception as e:
        print("Error: {}".format(str(e)))
PYEOF
    ;;

  brightness)
    LIGHT="${1:-1}"
    LEVEL="${2:-100}"
    
    python3 << 'PYEOF'
import json, os, sys
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

light = sys.argv[1] if len(sys.argv) > 1 else "1"
level = int(sys.argv[2]) if len(sys.argv) > 2 else 100

bridge = os.environ.get("HUE_BRIDGE_IP", "")
token = os.environ.get("HUE_API_KEY", "")
config_file = os.path.expanduser("~/.philips-hue/config.json")
if (not bridge or not token) and os.path.exists(config_file):
    with open(config_file) as f:
        cfg = json.load(f)
    bridge = bridge or cfg.get("bridge_ip", "")
    token = token or cfg.get("api_key", "")

bri = max(1, min(254, int(level * 254 / 100)))

try:
    payload = json.dumps({"on": True, "bri": bri}).encode("utf-8")
    if light == "all":
        url = "http://{}/api/{}/groups/0/action".format(bridge, token)
    else:
        url = "http://{}/api/{}/lights/{}/state".format(bridge, token, light)
    req = Request(url, data=payload)
    req.add_header("Content-Type", "application/json")
    req.get_method = lambda: "PUT"
    resp = urlopen(req, timeout=10)
    print("Light {} brightness set to {}%".format(light, level))
except Exception as e:
    print("Error: {}".format(str(e)))
PYEOF
    ;;

  color)
    LIGHT="${1:-1}"
    COLOR="${2:-red}"
    
    python3 << 'PYEOF'
import json, os, sys
try:
    from urllib2 import urlopen, Request
except ImportError:
    from urllib.request import urlopen, Request

light = sys.argv[1] if len(sys.argv) > 1 else "1"
color = sys.argv[2] if len(sys.argv) > 2 else "red"

bridge = os.environ.get("HUE_BRIDGE_IP", "")
token = os.environ.get("HUE_API_KEY", "")
config_file = os.path.expanduser("~/.philips-hue/config.json")
if (not bridge or not token) and os.path.exists(config_file):
    with open(config_file) as f:
        cfg = json.load(f)
    bridge = bridge or cfg.get("bridge_ip", "")
    token = token or cfg.get("api_key", "")

# Hue uses xy color space; predefined colors
colors = {
    "red": {"xy": [0.675, 0.322]},
    "green": {"xy": [0.409, 0.518]},
    "blue": {"xy": [0.167, 0.04]},
    "yellow": {"xy": [0.444, 0.517]},
    "purple": {"xy": [0.3, 0.15]},
    "orange": {"xy": [0.6, 0.38]},
    "pink": {"xy": [0.45, 0.23]},
    "white": {"ct": 250},
    "warm": {"ct": 400},
    "cool": {"ct": 153},
    "daylight": {"ct": 200},
    "relax": {"ct": 447},
    "concentrate": {"ct": 233}
}

if color not in colors:
    print("Available colors: {}".format(", ".join(sorted(colors.keys()))))
    sys.exit(1)

payload = {"on": True}
payload.update(colors[color])

try:
    data = json.dumps(payload).encode("utf-8")
    if light == "all":
        url = "http://{}/api/{}/groups/0/action".format(bridge, token)
    else:
        url = "http://{}/api/{}/lights/{}/state".format(bridge, token, light)
    req = Request(url, data=data)
    req.add_header("Content-Type", "application/json")
    req.get_method = lambda: "PUT"
    resp = urlopen(req, timeout=10)
    print("Light {} set to {}".format(light, color))
except Exception as e:
    print("Error: {}".format(str(e)))
PYEOF
    ;;

  scenes)
    python3 << 'PYEOF'
import json, os, sys
try:
    from urllib2 import urlopen
except ImportError:
    from urllib.request import urlopen

bridge = os.environ.get("HUE_BRIDGE_IP", "")
token = os.environ.get("HUE_API_KEY", "")
config_file = os.path.expanduser("~/.philips-hue/config.json")
if (not bridge or not token) and os.path.exists(config_file):
    with open(config_file) as f:
        cfg = json.load(f)
    bridge = bridge or cfg.get("bridge_ip", "")
    token = token or cfg.get("api_key", "")

try:
    resp = urlopen("http://{}/api/{}/scenes".format(bridge, token), timeout=10)
    scenes = json.loads(resp.read().decode("utf-8"))
    
    print("=" * 50)
    print("HUE SCENES")
    print("=" * 50)
    print("")
    for sid, scene in sorted(scenes.items()):
        name = scene.get("name", "?")
        stype = scene.get("type", "?")
        lights = scene.get("lights", [])
        print("  {} — {} ({}, {} lights)".format(sid[:12], name, stype, len(lights)))
    
    print("")
    print("Activate: bash hue.sh scene <scene_id> <group_id>")
except Exception as e:
    print("Error: {}".format(str(e)))
PYEOF
    ;;

  help|*)
    cat << 'HELPEOF'
Philips Hue — Control your Hue lights via Bridge API

SETUP:
  discover              Find Hue Bridge on your network
  pair                  Pair with bridge (press button first!)

CONTROL:
  lights                List all lights and status
  on [light_id|all]     Turn light(s) on
  off [light_id|all]    Turn light(s) off
  brightness <id> <0-100>  Set brightness
  color <id> <color>    Set color (red/blue/green/warm/cool/etc.)
  scenes                List available scenes

ENV VARS:
  HUE_BRIDGE_IP — Bridge IP address
  HUE_API_KEY   — API key from pairing

EXAMPLES:
  bash hue.sh discover
  bash hue.sh pair
  bash hue.sh lights
  bash hue.sh on all
  bash hue.sh brightness 1 50
  bash hue.sh color 2 warm
  bash hue.sh off all
HELPEOF
    ;;
esac

echo ""
echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
