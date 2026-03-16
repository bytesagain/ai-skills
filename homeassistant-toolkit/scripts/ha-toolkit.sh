#!/usr/bin/env bash
# ha-toolkit.sh — Home Assistant REST API Toolkit
# Controls devices, manages automations, queries states, orchestrates scenes
# Requires: HA_URL, HA_TOKEN environment variables
# Python 3.6+ compatible (no f-strings)

set -euo pipefail

##############################################################################
# Configuration
##############################################################################

HA_URL="${HA_URL:-}"
HA_TOKEN="${HA_TOKEN:-}"
TIMEOUT="${HA_TIMEOUT:-15}"
SCRIPT_NAME="$(basename "$0")"

##############################################################################
# Helpers
##############################################################################

usage() {
    cat << 'USAGE'
Home Assistant Toolkit — CLI for Home Assistant REST API

USAGE:
  ha-toolkit.sh <command> [args...]

COMMANDS:
  status                        Show HA server info
  config                        Show HA configuration
  entities [domain]             List entities (optionally filter by domain)
  state <entity_id>             Get state + attributes of an entity
  history <entity_id> [hours]   Fetch state history (default: 24h)
  call <service> <entity_id> [json] Call a HA service
  toggle <entity_id>            Toggle entity on/off
  automations                   List all automations
  automation <action> <id>      trigger|enable|disable an automation
  scenes                        List all scenes
  scene activate <scene_id>     Activate a scene
  scripts                       List all scripts
  script run <script_id>        Run a script
  services [domain]             List available services
  logs [lines]                  Fetch recent log entries
  dashboard                     Interactive entity overview
  watch <entity_id> [interval]  Watch entity state changes

ENVIRONMENT:
  HA_URL       Home Assistant base URL (e.g., http://192.168.1.100:8123)
  HA_TOKEN     Long-Lived Access Token
  HA_TIMEOUT   Request timeout in seconds (default: 15)

USAGE
    exit 0
}

check_env() {
    if [ -z "$HA_URL" ]; then
        echo "ERROR: HA_URL is not set. Export it first:"
        echo "  export HA_URL=\"http://your-ha-instance:8123\""
        exit 1
    fi
    if [ -z "$HA_TOKEN" ]; then
        echo "ERROR: HA_TOKEN is not set. Export it first:"
        echo "  export HA_TOKEN=\"your-long-lived-access-token\""
        exit 1
    fi
    # Strip trailing slash
    HA_URL="${HA_URL%/}"
}

##############################################################################
# Main logic in Python for complex JSON handling
##############################################################################

run_command() {
    local cmd="$1"
    shift
    check_env

    python3 - "$cmd" "$HA_URL" "$HA_TOKEN" "$TIMEOUT" "$@" << 'PYEOF'
import sys
import json
import os
import datetime

try:
    from urllib.request import Request, urlopen
    from urllib.error import URLError, HTTPError
    from urllib.parse import quote, urlencode
except ImportError:
    print("ERROR: Python 3 with urllib is required")
    sys.exit(1)

##############################################################################
# API Client
##############################################################################

class HAClient(object):
    def __init__(self, base_url, token, timeout):
        self.base_url = base_url
        self.token = token
        self.timeout = int(timeout)
        self.headers = {
            "Authorization": "Bearer {}".format(token),
            "Content-Type": "application/json",
        }

    def _request(self, method, path, data=None):
        url = "{}{}".format(self.base_url, path)
        body = None
        if data is not None:
            body = json.dumps(data).encode("utf-8")
        req = Request(url, data=body, headers=self.headers, method=method)
        try:
            resp = urlopen(req, timeout=self.timeout)
            raw = resp.read().decode("utf-8")
            if raw.strip():
                return json.loads(raw)
            return {}
        except HTTPError as e:
            body_text = ""
            try:
                body_text = e.read().decode("utf-8")
            except Exception:
                pass
            print("HTTP Error {}: {}".format(e.code, e.reason))
            if body_text:
                try:
                    err_data = json.loads(body_text)
                    print("  Message: {}".format(err_data.get("message", body_text)))
                except Exception:
                    print("  Body: {}".format(body_text[:500]))
            sys.exit(1)
        except URLError as e:
            print("Connection error: {}".format(str(e.reason)))
            print("Check that HA_URL is correct and Home Assistant is running.")
            sys.exit(1)
        except Exception as e:
            print("Request failed: {}".format(str(e)))
            sys.exit(1)

    def get(self, path):
        return self._request("GET", path)

    def post(self, path, data=None):
        return self._request("POST", path, data)


##############################################################################
# Command Handlers
##############################################################################

def cmd_status(client, args):
    """Show HA server info"""
    data = client.get("/api/")
    print("Home Assistant Server Info")
    print("=" * 40)
    print("  Message:  {}".format(data.get("message", "N/A")))

    config = client.get("/api/config")
    print("  Version:  {}".format(config.get("version", "unknown")))
    print("  Name:     {}".format(config.get("location_name", "N/A")))
    print("  Timezone: {}".format(config.get("time_zone", "N/A")))
    print("  Latitude: {}".format(config.get("latitude", "N/A")))
    print("  Longitude:{}".format(config.get("longitude", "N/A")))
    print("  Unit:     {}".format(config.get("unit_system", {}).get("temperature", "N/A")))
    print("  Elevation:{}".format(config.get("elevation", "N/A")))
    comps = config.get("components", [])
    print("  Components: {} loaded".format(len(comps)))


def cmd_config(client, args):
    """Show HA configuration"""
    config = client.get("/api/config")
    print(json.dumps(config, indent=2, ensure_ascii=False))


def cmd_entities(client, args):
    """List all entities, optionally filtered by domain"""
    domain_filter = args[0] if args else None
    states = client.get("/api/states")

    if domain_filter:
        states = [s for s in states if s.get("entity_id", "").startswith(domain_filter + ".")]

    # Group by domain
    domains = {}
    for s in states:
        eid = s.get("entity_id", "")
        domain = eid.split(".")[0] if "." in eid else "unknown"
        if domain not in domains:
            domains[domain] = []
        domains[domain].append(s)

    total = 0
    for domain in sorted(domains.keys()):
        entities = domains[domain]
        print("\n[{}] ({} entities)".format(domain.upper(), len(entities)))
        print("-" * 60)
        for e in sorted(entities, key=lambda x: x.get("entity_id", "")):
            eid = e.get("entity_id", "")
            state = e.get("state", "unknown")
            friendly = e.get("attributes", {}).get("friendly_name", "")
            if friendly and friendly != eid:
                print("  {:<40s} {:<12s} ({})".format(eid, state, friendly))
            else:
                print("  {:<40s} {:<12s}".format(eid, state))
            total += 1

    print("\nTotal: {} entities".format(total))
    if domain_filter:
        print("(filtered by domain: {})".format(domain_filter))


def cmd_state(client, args):
    """Get state and attributes of a specific entity"""
    if not args:
        print("Usage: state <entity_id>")
        sys.exit(1)

    entity_id = args[0]
    data = client.get("/api/states/{}".format(quote(entity_id, safe="")))

    print("Entity: {}".format(data.get("entity_id", "N/A")))
    print("State:  {}".format(data.get("state", "N/A")))
    print("Last Changed: {}".format(data.get("last_changed", "N/A")))
    print("Last Updated: {}".format(data.get("last_updated", "N/A")))

    attrs = data.get("attributes", {})
    if attrs:
        print("\nAttributes:")
        for key in sorted(attrs.keys()):
            val = attrs[key]
            if isinstance(val, (list, dict)):
                val = json.dumps(val, ensure_ascii=False)
            print("  {}: {}".format(key, val))


def cmd_history(client, args):
    """Fetch state history for an entity"""
    if not args:
        print("Usage: history <entity_id> [hours]")
        sys.exit(1)

    entity_id = args[0]
    hours = int(args[1]) if len(args) > 1 else 24

    now = datetime.datetime.utcnow()
    start = now - datetime.timedelta(hours=hours)
    start_str = start.strftime("%Y-%m-%dT%H:%M:%S") + "+00:00"

    path = "/api/history/period/{}?filter_entity_id={}".format(
        quote(start_str, safe=""), quote(entity_id, safe="")
    )
    data = client.get(path)

    if not data or not data[0]:
        print("No history found for {} in the last {} hours.".format(entity_id, hours))
        return

    entries = data[0]
    print("History for {} (last {} hours, {} entries)".format(entity_id, hours, len(entries)))
    print("-" * 70)
    print("{:<25s} {:<15s} {}".format("Timestamp", "State", "Changed"))
    print("-" * 70)

    prev_state = None
    for entry in entries:
        state = entry.get("state", "?")
        last_changed = entry.get("last_changed", "")
        changed_marker = " *" if state != prev_state else ""
        # Format timestamp
        ts = last_changed[:19].replace("T", " ") if last_changed else "N/A"
        print("{:<25s} {:<15s}{}".format(ts, state, changed_marker))
        prev_state = state


def cmd_call(client, args):
    """Call a HA service"""
    if len(args) < 2:
        print("Usage: call <domain.service> <entity_id> [json_data]")
        print("Example: call light.turn_on light.bedroom '{\"brightness\": 200}'")
        sys.exit(1)

    service_full = args[0]
    entity_id = args[1]
    extra_data = {}
    if len(args) > 2:
        try:
            extra_data = json.loads(args[2])
        except json.JSONDecodeError as e:
            print("Invalid JSON data: {}".format(str(e)))
            sys.exit(1)

    if "." not in service_full:
        print("Service must be in 'domain.service' format (e.g., light.turn_on)")
        sys.exit(1)

    domain, service = service_full.split(".", 1)

    payload = {"entity_id": entity_id}
    payload.update(extra_data)

    path = "/api/services/{}/{}".format(quote(domain, safe=""), quote(service, safe=""))
    result = client.post(path, payload)

    print("Service {}.{} called on {}".format(domain, service, entity_id))
    if result:
        affected = len(result) if isinstance(result, list) else 1
        print("  {} entity(ies) affected".format(affected))


def cmd_toggle(client, args):
    """Toggle an entity on/off"""
    if not args:
        print("Usage: toggle <entity_id>")
        sys.exit(1)

    entity_id = args[0]
    domain = entity_id.split(".")[0] if "." in entity_id else ""

    # Determine current state
    state_data = client.get("/api/states/{}".format(quote(entity_id, safe="")))
    current = state_data.get("state", "unknown")

    if current in ("on", "open", "playing"):
        action = "turn_off"
        if domain == "cover":
            action = "close_cover"
    else:
        action = "turn_on"
        if domain == "cover":
            action = "open_cover"

    # Use homeassistant domain for generic toggle
    if domain in ("light", "switch", "fan", "input_boolean"):
        svc_domain = domain
    else:
        svc_domain = "homeassistant"

    path = "/api/services/{}/{}".format(svc_domain, action)
    client.post(path, {"entity_id": entity_id})
    print("{} toggled: {} -> {}".format(entity_id, current, "on" if current == "off" else "off"))


def cmd_automations(client, args):
    """List all automations"""
    states = client.get("/api/states")
    autos = [s for s in states if s.get("entity_id", "").startswith("automation.")]

    if not autos:
        print("No automations found.")
        return

    print("Automations ({})".format(len(autos)))
    print("-" * 70)
    print("{:<45s} {:<10s} {}".format("Entity ID", "State", "Friendly Name"))
    print("-" * 70)

    for a in sorted(autos, key=lambda x: x.get("entity_id", "")):
        eid = a.get("entity_id", "")
        state = a.get("state", "unknown")
        friendly = a.get("attributes", {}).get("friendly_name", "")
        status_icon = "[ON] " if state == "on" else "[OFF]"
        print("{} {:<43s} {:<10s} {}".format(status_icon, eid, state, friendly))


def cmd_automation(client, args):
    """Manage a specific automation"""
    if len(args) < 2:
        print("Usage: automation <trigger|enable|disable> <automation_id>")
        sys.exit(1)

    action = args[0].lower()
    auto_id = args[1]

    if not auto_id.startswith("automation."):
        auto_id = "automation.{}".format(auto_id)

    if action == "trigger":
        client.post("/api/services/automation/trigger", {"entity_id": auto_id})
        print("Triggered: {}".format(auto_id))
    elif action == "enable":
        client.post("/api/services/automation/turn_on", {"entity_id": auto_id})
        print("Enabled: {}".format(auto_id))
    elif action == "disable":
        client.post("/api/services/automation/turn_off", {"entity_id": auto_id})
        print("Disabled: {}".format(auto_id))
    else:
        print("Unknown action: {}. Use trigger, enable, or disable.".format(action))
        sys.exit(1)


def cmd_scenes(client, args):
    """List all scenes"""
    states = client.get("/api/states")
    scenes = [s for s in states if s.get("entity_id", "").startswith("scene.")]

    if not scenes:
        print("No scenes found.")
        return

    print("Scenes ({})".format(len(scenes)))
    print("-" * 60)
    for sc in sorted(scenes, key=lambda x: x.get("entity_id", "")):
        eid = sc.get("entity_id", "")
        friendly = sc.get("attributes", {}).get("friendly_name", eid)
        print("  {} ({})".format(friendly, eid))


def cmd_scene_activate(client, args):
    """Activate a scene"""
    if len(args) < 2 or args[0] != "activate":
        print("Usage: scene activate <scene_id>")
        sys.exit(1)

    scene_id = args[1]
    if not scene_id.startswith("scene."):
        scene_id = "scene.{}".format(scene_id)

    client.post("/api/services/scene/turn_on", {"entity_id": scene_id})
    print("Scene activated: {}".format(scene_id))


def cmd_scripts(client, args):
    """List all scripts"""
    states = client.get("/api/states")
    scripts = [s for s in states if s.get("entity_id", "").startswith("script.")]

    if not scripts:
        print("No scripts found.")
        return

    print("Scripts ({})".format(len(scripts)))
    print("-" * 60)
    for sc in sorted(scripts, key=lambda x: x.get("entity_id", "")):
        eid = sc.get("entity_id", "")
        state = sc.get("state", "")
        friendly = sc.get("attributes", {}).get("friendly_name", eid)
        print("  {:<40s} {:<10s} {}".format(eid, state, friendly))


def cmd_script_run(client, args):
    """Run a script"""
    if len(args) < 2 or args[0] != "run":
        print("Usage: script run <script_id>")
        sys.exit(1)

    script_id = args[1]
    if not script_id.startswith("script."):
        script_id = "script.{}".format(script_id)

    client.post("/api/services/script/turn_on", {"entity_id": script_id})
    print("Script executed: {}".format(script_id))


def cmd_services(client, args):
    """List available services"""
    domain_filter = args[0] if args else None
    services = client.get("/api/services")

    for svc in sorted(services, key=lambda x: x.get("domain", "")):
        domain = svc.get("domain", "")
        if domain_filter and domain != domain_filter:
            continue
        svc_list = svc.get("services", {})
        print("\n[{}] ({} services)".format(domain.upper(), len(svc_list)))
        for name, details in sorted(svc_list.items()):
            desc = details.get("description", "")
            print("  {}.{:<30s} {}".format(domain, name, desc[:60]))


def cmd_logs(client, args):
    """Fetch recent log entries"""
    data = client.get("/api/error_log")
    if isinstance(data, str):
        lines = data.strip().split("\n")
    else:
        lines = str(data).strip().split("\n")

    limit = int(args[0]) if args else 50
    display = lines[-limit:] if len(lines) > limit else lines

    print("Home Assistant Logs (last {} lines)".format(len(display)))
    print("=" * 70)
    for line in display:
        print(line)


def cmd_dashboard(client, args):
    """Show overview of key entity domains"""
    states = client.get("/api/states")

    domains_of_interest = ["light", "switch", "climate", "sensor", "binary_sensor",
                           "cover", "lock", "fan", "media_player"]

    domain_counts = {}
    domain_states = {}

    for s in states:
        eid = s.get("entity_id", "")
        domain = eid.split(".")[0]
        if domain not in domains_of_interest:
            continue
        if domain not in domain_counts:
            domain_counts[domain] = {"total": 0, "on": 0, "off": 0, "other": 0}
            domain_states[domain] = []
        domain_counts[domain]["total"] += 1
        state = s.get("state", "")
        if state in ("on", "open", "home", "playing", "locked"):
            domain_counts[domain]["on"] += 1
        elif state in ("off", "closed", "away", "idle", "unlocked"):
            domain_counts[domain]["off"] += 1
        else:
            domain_counts[domain]["other"] += 1
        domain_states[domain].append(s)

    print("=" * 60)
    print("  HOME ASSISTANT DASHBOARD")
    print("=" * 60)

    for domain in domains_of_interest:
        if domain not in domain_counts:
            continue
        c = domain_counts[domain]
        icon_map = {
            "light": "💡", "switch": "🔌", "climate": "🌡️",
            "sensor": "📊", "binary_sensor": "⚡", "cover": "🪟",
            "lock": "🔒", "fan": "🌀", "media_player": "🎵"
        }
        icon = icon_map.get(domain, "📦")
        print("\n{} {} — {} total | {} active | {} inactive | {} other".format(
            icon, domain.upper(), c["total"], c["on"], c["off"], c["other"]))

        # Show active entities
        active = [s for s in domain_states[domain]
                  if s.get("state", "") in ("on", "open", "home", "playing", "locked")]
        if active:
            for a in active[:5]:
                friendly = a.get("attributes", {}).get("friendly_name", a.get("entity_id", ""))
                state = a.get("state", "")
                print("    ├─ {} [{}]".format(friendly, state))
            if len(active) > 5:
                print("    └─ ...and {} more".format(len(active) - 5))

    print("\n" + "=" * 60)
    total_entities = sum(c["total"] for c in domain_counts.values())
    print("  Total tracked entities: {}".format(total_entities))
    print("=" * 60)


def cmd_watch(client, args):
    """Watch an entity for state changes"""
    import time

    if not args:
        print("Usage: watch <entity_id> [interval_seconds]")
        sys.exit(1)

    entity_id = args[0]
    interval = int(args[1]) if len(args) > 1 else 5

    print("Watching {} (polling every {}s, Ctrl+C to stop)".format(entity_id, interval))
    print("-" * 60)

    prev_state = None
    try:
        while True:
            data = client.get("/api/states/{}".format(quote(entity_id, safe="")))
            state = data.get("state", "unknown")
            attrs = data.get("attributes", {})

            if state != prev_state:
                ts = datetime.datetime.now().strftime("%H:%M:%S")
                extra = ""
                if "unit_of_measurement" in attrs:
                    extra = " {}".format(attrs["unit_of_measurement"])
                if prev_state is None:
                    print("[{}] Initial state: {}{}".format(ts, state, extra))
                else:
                    print("[{}] Changed: {} -> {}{}".format(ts, prev_state, state, extra))
                prev_state = state

            time.sleep(interval)
    except KeyboardInterrupt:
        print("\nStopped watching.")


##############################################################################
# Main dispatcher
##############################################################################

def main():
    argv = sys.argv[1:]
    if len(argv) < 1:
        print("No command specified. Run with --help for usage.")
        sys.exit(1)

    cmd = argv[0]
    base_url = argv[1]
    token = argv[2]
    timeout = argv[3]
    extra_args = argv[4:]

    client = HAClient(base_url, token, timeout)

    commands = {
        "status": cmd_status,
        "config": cmd_config,
        "entities": cmd_entities,
        "state": cmd_state,
        "history": cmd_history,
        "call": cmd_call,
        "toggle": cmd_toggle,
        "automations": cmd_automations,
        "automation": cmd_automation,
        "scenes": cmd_scenes,
        "scene": cmd_scene_activate,
        "scripts": cmd_scripts,
        "script": cmd_script_run,
        "services": cmd_services,
        "logs": cmd_logs,
        "dashboard": cmd_dashboard,
        "watch": cmd_watch,
    }

    handler = commands.get(cmd)
    if handler is None:
        print("Unknown command: {}".format(cmd))
        print("Available commands: {}".format(", ".join(sorted(commands.keys()))))
        sys.exit(1)

    handler(client, extra_args)


if __name__ == "__main__":
    main()
PYEOF
}

##############################################################################
# Entry point
##############################################################################

if [ $# -eq 0 ] || [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
    usage
fi

COMMAND="$1"
shift

run_command "$COMMAND" "$@"

echo ""
echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
