#!/usr/bin/env bash
# Agent Toolkit — Swiss army knife for AI agent development
# Powered by BytesAgain

TOOLKIT_DIR="$HOME/agent-toolkit"
CMD="${1:-help}"
shift 2>/dev/null

case "$CMD" in
  scaffold)
    PROJECT="${1:-my-agent}"
    python3 << PYEOF
import os

project = "${PROJECT}"
base = os.path.join(os.getcwd(), project)

dirs = [
    "prompts",
    "tools",
    "chains",
    "configs",
    "tests",
    "logs",
    "docs",
]

print("=" * 60)
print("  AGENT TOOLKIT — Scaffold")
print("=" * 60)
print()
print("  Project: {}".format(project))
print()

for d in dirs:
    path = os.path.join(base, d)
    os.makedirs(path, exist_ok=True)
    print("  [+] {}".format(path))

# Create starter files
readme = os.path.join(base, "README.md")
with open(readme, "w") as f:
    f.write("# {}\n\nAI Agent Project\n\n## Structure\n\n".format(project))
    for d in dirs:
        f.write("- `{}/` - {}\n".format(d, d.capitalize()))

gitignore = os.path.join(base, ".gitignore")
with open(gitignore, "w") as f:
    f.write("logs/\n*.pyc\n__pycache__/\n.env\n")

print("  [+] {}".format(readme))
print("  [+] {}".format(gitignore))
print()
print("  Project scaffolded at: {}".format(base))
print("  {} directories created".format(len(dirs)))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  config)
    AGENT_NAME="${1:-default-agent}"
    python3 << PYEOF
import os, json

name = "${AGENT_NAME}"

config = {
    "agent_name": name,
    "model": "gpt-4",
    "temperature": 0.7,
    "max_tokens": 4096,
    "top_p": 1.0,
    "frequency_penalty": 0.0,
    "presence_penalty": 0.0,
    "system_prompt_file": "prompts/system.md",
    "tools_enabled": True,
    "tools_dir": "tools/",
    "max_iterations": 10,
    "timeout_seconds": 120,
    "logging": {
        "level": "INFO",
        "file": "logs/agent.log"
    },
    "safety": {
        "max_tool_calls_per_turn": 5,
        "require_confirmation": False,
        "blocked_tools": []
    }
}

print("=" * 60)
print("  AGENT TOOLKIT — Config Generator")
print("=" * 60)
print()
print("  Agent: {}".format(name))
print()
print("  Generated config:")
print()

formatted = json.dumps(config, indent=2)
for line in formatted.split("\n"):
    print("  {}".format(line))

out_file = "agent_config.json"
with open(out_file, "w") as f:
    json.dump(config, f, indent=2)
print()
print("  Saved to: {}".format(out_file))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  prompt)
    ROLE="${1:-assistant}"
    python3 << PYEOF
import os

role = "${ROLE}"

print("=" * 60)
print("  AGENT TOOLKIT — System Prompt Generator")
print("=" * 60)
print()
print("  Role: {}".format(role))
print()

prompt_template = """# System Prompt

## Role
You are a {role}. You are helpful, accurate, and concise.

## Constraints
- Always cite sources when making factual claims
- Ask clarifying questions when the request is ambiguous
- Never fabricate information
- Stay within your defined role and capabilities

## Output Format
- Use Markdown formatting for structured responses
- Keep responses focused and relevant
- Use code blocks for technical content

## Tools
You have access to the tools defined in your configuration.
Only use tools when they add value to your response.

## Safety
- Do not execute harmful commands
- Protect user privacy
- Refuse requests that violate ethical guidelines
""".format(role=role)

print("  Generated prompt:")
print("  " + "-" * 40)
for line in prompt_template.strip().split("\n"):
    print("  {}".format(line))
print()

out_file = "prompts/system_{}.md".format(role)
os.makedirs("prompts", exist_ok=True)
with open(out_file, "w") as f:
    f.write(prompt_template)

print("  Saved to: {}".format(out_file))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  tools)
    TOOL_NAME="${1:-search}"
    python3 << PYEOF
import os, json

tool_name = "${TOOL_NAME}"

schema = {
    "type": "function",
    "function": {
        "name": tool_name,
        "description": "Tool: {}. Edit this description.".format(tool_name),
        "parameters": {
            "type": "object",
            "properties": {
                "query": {
                    "type": "string",
                    "description": "The input query or argument"
                },
                "max_results": {
                    "type": "integer",
                    "description": "Maximum number of results",
                    "default": 5
                }
            },
            "required": ["query"]
        }
    }
}

print("=" * 60)
print("  AGENT TOOLKIT — Tool Schema Generator")
print("=" * 60)
print()
print("  Tool: {}".format(tool_name))
print()
print("  Generated schema:")
print()

formatted = json.dumps(schema, indent=2)
for line in formatted.split("\n"):
    print("  {}".format(line))

os.makedirs("tools", exist_ok=True)
out_file = "tools/{}_schema.json".format(tool_name)
with open(out_file, "w") as f:
    json.dump(schema, f, indent=2)

print()
print("  Saved to: {}".format(out_file))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  chain)
    CHAIN_NAME="${1:-default-chain}"
    python3 << PYEOF
import os, json

chain_name = "${CHAIN_NAME}"

chain = {
    "name": chain_name,
    "description": "Agent workflow chain",
    "steps": [
        {
            "id": "step_1",
            "name": "Parse Input",
            "type": "transform",
            "input": "user_input",
            "output": "parsed_input"
        },
        {
            "id": "step_2",
            "name": "Process",
            "type": "llm_call",
            "input": "parsed_input",
            "output": "result",
            "on_error": "fallback"
        },
        {
            "id": "step_3",
            "name": "Format Output",
            "type": "transform",
            "input": "result",
            "output": "final_output"
        },
        {
            "id": "fallback",
            "name": "Error Handler",
            "type": "transform",
            "input": "error",
            "output": "error_response"
        }
    ],
    "entry_point": "step_1",
    "max_retries": 2
}

print("=" * 60)
print("  AGENT TOOLKIT — Chain Designer")
print("=" * 60)
print()
print("  Chain: {}".format(chain_name))
print()
print("  Workflow:")
print()
for step in chain["steps"]:
    arrow = "  ->" if step["id"] != "fallback" else "  !>"
    print("  {} [{}] {} ({})".format(arrow, step["id"], step["name"], step["type"]))
print()

os.makedirs("chains", exist_ok=True)
out_file = "chains/{}.json".format(chain_name)
with open(out_file, "w") as f:
    json.dump(chain, f, indent=2)

print("  Saved to: {}".format(out_file))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  debug)
    LOG_FILE="${1:-}"
    python3 << PYEOF
import os

log_file = "${LOG_FILE}"

print("=" * 60)
print("  AGENT TOOLKIT — Debug Guide")
print("=" * 60)
print()

if log_file and os.path.exists(log_file):
    with open(log_file) as f:
        lines = f.readlines()
    errors = [l.strip() for l in lines if "error" in l.lower() or "exception" in l.lower()]
    warnings = [l.strip() for l in lines if "warn" in l.lower()]

    print("  Log file: {}".format(log_file))
    print("  Total lines: {}".format(len(lines)))
    print("  Errors: {}".format(len(errors)))
    print("  Warnings: {}".format(len(warnings)))
    print()
    if errors:
        print("  Recent errors:")
        for e in errors[-5:]:
            print("    [E] {}".format(e[:70]))
    print()
else:
    print("  Debug Checklist:")
    print()
    print("  1. Check system prompt for contradictions")
    print("  2. Verify tool schemas are valid JSON")
    print("  3. Test each tool in isolation")
    print("  4. Review chain flow for dead ends")
    print("  5. Check temperature settings (lower = more deterministic)")
    print("  6. Verify max_tokens is sufficient")
    print("  7. Test with edge case inputs")
    print("  8. Check for infinite loops in chains")
    print()
    print("  Usage: agent-toolkit.sh debug [log_file]")

print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  monitor)
    python3 << 'PYEOF'
import os, json

print("=" * 60)
print("  AGENT TOOLKIT — Monitoring Setup")
print("=" * 60)
print()
print("  Monitoring Configuration:")
print()

monitor_config = {
    "metrics": [
        {"name": "response_time_ms", "type": "histogram", "description": "LLM response latency"},
        {"name": "token_usage", "type": "counter", "description": "Total tokens consumed"},
        {"name": "tool_calls", "type": "counter", "description": "Number of tool invocations"},
        {"name": "error_rate", "type": "gauge", "description": "Error percentage"},
        {"name": "chain_completion", "type": "gauge", "description": "Chain success rate"}
    ],
    "alerts": [
        {"metric": "error_rate", "threshold": 5, "action": "notify"},
        {"metric": "response_time_ms", "threshold": 30000, "action": "warn"},
        {"metric": "token_usage", "threshold": 100000, "action": "budget_alert"}
    ],
    "logging": {
        "format": "json",
        "level": "INFO",
        "retention_days": 30
    }
}

print("  Metrics to track:")
for m in monitor_config["metrics"]:
    print("    [{:10s}] {:25s} {}".format(m["type"], m["name"], m["description"]))

print()
print("  Alert rules:")
for a in monitor_config["alerts"]:
    print("    {} > {} -> {}".format(a["metric"], a["threshold"], a["action"]))

os.makedirs("configs", exist_ok=True)
out_file = "configs/monitoring.json"
with open(out_file, "w") as f:
    json.dump(monitor_config, f, indent=2)

print()
print("  Saved to: {}".format(out_file))
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  deploy)
    python3 << 'PYEOF'
print("=" * 60)
print("  AGENT TOOLKIT — Deployment Checklist")
print("=" * 60)
print()
print("  Pre-Deploy Checklist:")
print()

items = [
    ("Config",      "All config files reviewed and environment-specific"),
    ("Prompts",     "System prompts tested and versioned"),
    ("Tools",       "Tool schemas validated, permissions set"),
    ("Chains",      "Workflow chains tested end-to-end"),
    ("Auth",        "API keys secured, not in source code"),
    ("Rate Limits", "Rate limiting configured per tool"),
    ("Monitoring",  "Metrics, alerts, and logging enabled"),
    ("Fallbacks",   "Error handlers in place for all chains"),
    ("Testing",     "Edge cases and adversarial inputs tested"),
    ("Docs",        "README and API docs up to date"),
    ("Backup",      "Rollback plan documented"),
    ("Budget",      "Token budget and cost alerts configured"),
]

for i, (area, desc) in enumerate(items, 1):
    print("  [ ] {:2d}. {:12s} {}".format(i, area, desc))

print()
print("  Complete all items before deploying to production.")
print("  Mark items with [x] as you verify each one.")
print()
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  *)
    echo "=================================================="
    echo "  AGENT TOOLKIT — AI Agent Development Kit"
    echo "=================================================="
    echo ""
    echo "  Commands:"
    echo "    scaffold   Create agent project structure"
    echo "    config     Generate agent config files"
    echo "    prompt     Create system prompts"
    echo "    tools      Define tool/function schemas"
    echo "    chain      Design agent chains/workflows"
    echo "    debug      Debug agent behavior"
    echo "    monitor    Monitoring setup"
    echo "    deploy     Deployment checklist"
    echo ""
    echo "  Usage:"
    echo "    bash agent-toolkit.sh <command> [args]"
    echo ""
    echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;
esac
