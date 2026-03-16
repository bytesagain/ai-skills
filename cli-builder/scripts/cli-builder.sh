#!/usr/bin/env bash
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in

init)
  NAME="${1:-myapp}"
  LANG="${2:-python}"
  export CLI_NAME="$NAME"
  export CLI_LANG="$LANG"
  python3 << 'PYEOF'
import os, sys

name = os.environ.get("CLI_NAME", "myapp")
lang = os.environ.get("CLI_LANG", "python")

templates = {
    "python": {
        "files": ["{name}/cli.py", "{name}/__init__.py", "setup.py", "README.md", "LICENSE"],
        "entry": '''#!/usr/bin/env python3
import argparse
import sys

def main():
    parser = argparse.ArgumentParser(
        prog="{name}",
        description="{name} - A CLI tool"
    )
    parser.add_argument("--version", action="version", version="{name} 0.1.0")
    subparsers = parser.add_subparsers(dest="command", help="Available commands")

    # Add commands here with:
    # sub = subparsers.add_parser("cmd_name", help="description")
    # sub.add_argument("--flag", help="flag help")

    args = parser.parse_args()
    if not args.command:
        parser.print_help()
        sys.exit(1)

if __name__ == "__main__":
    main()
''',
    },
    "node": {
        "files": ["bin/{name}.js", "src/index.js", "package.json", "README.md", "LICENSE"],
        "entry": '''#!/usr/bin/env node
const {{ program }} = require("commander");

program
  .name("{name}")
  .description("{name} - A CLI tool")
  .version("0.1.0");

// Add commands:
// program.command("serve")
//   .description("Start server")
//   .option("-p, --port <number>", "port", "3000")
//   .action((opts) => {{ console.log("serving on", opts.port); }});

program.parse();
''',
    },
    "bash": {
        "files": ["{name}.sh", "README.md", "LICENSE"],
        "entry": '''#!/usr/bin/env bash
set -euo pipefail

VERSION="0.1.0"
PROG="{name}"

usage() {{
    echo "Usage: $PROG <command> [options]"
    echo ""
    echo "Commands:"
    echo "  help      Show this help"
    echo "  version   Show version"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show help"
    echo "  -v, --version  Show version"
}}

case "${{1:-help}}" in
    help|-h|--help) usage ;;
    version|-v|--version) echo "$PROG $VERSION" ;;
    *) echo "Unknown command: $1"; usage; exit 1 ;;
esac
''',
    },
    "go": {
        "files": ["main.go", "cmd/root.go", "go.mod", "README.md", "LICENSE"],
        "entry": '''package main

import (
    "fmt"
    "os"
)

var version = "0.1.0"

func main() {{
    if len(os.Args) < 2 {{
        fmt.Println("Usage: {name} <command>")
        fmt.Println("Commands: help, version")
        os.Exit(1)
    }}
    switch os.Args[1] {{
    case "version":
        fmt.Printf("{name} %s\\n", version)
    case "help":
        fmt.Println("Usage: {name} <command>")
    default:
        fmt.Fprintf(os.Stderr, "Unknown command: %s\\n", os.Args[1])
        os.Exit(1)
    }}
}}
''',
    },
}

t = templates.get(lang)
if not t:
    print("Supported languages: python, node, bash, go")
    sys.exit(1)

print("=" * 60)
print("  CLI Project: {}".format(name))
print("  Language: {}".format(lang))
print("=" * 60)
print("")
print("Project Structure:")
for f in t["files"]:
    print("  {}".format(f.format(name=name)))
print("")
print("--- Entry Point Code ---")
print(t["entry"].format(name=name))
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

command)
  APP="${1:-myapp}"
  CMDNAME="${2:-serve}"
  DESC="${3:-A new command}"
  export CLI_APP="$APP"
  export CLI_CMDNAME="$CMDNAME"
  export CLI_DESC="$DESC"
  python3 << 'PYEOF'
import os

app = os.environ.get("CLI_APP", "myapp")
cmd = os.environ.get("CLI_CMDNAME", "serve")
desc = os.environ.get("CLI_DESC", "A new command")

print("=" * 60)
print("  Add Command: {} -> {}".format(app, cmd))
print("=" * 60)
print("")
print("# Python (argparse)")
print('sub = subparsers.add_parser("{}", help="{}")'.format(cmd, desc))
print('sub.add_argument("--flag", type=str, help="Flag description")')
print('sub.set_defaults(func=handle_{})'.format(cmd.replace("-", "_")))
print("")
print("def handle_{}(args):".format(cmd.replace("-", "_")))
print('    """{}"""'.format(desc))
print("    print('Running {}...')".format(cmd))
print("")
print("# Node.js (commander)")
print('program.command("{}")'.format(cmd))
print('  .description("{}")'.format(desc))
print('  .option("-f, --flag <value>", "flag description")')
print("  .action((opts) => {")
print("    console.log('Running {}...', opts);".format(cmd))
print("  });")
print("")
print("# Bash")
print('  {}) handle_{} "$@" ;;'.format(cmd, cmd.replace("-", "_")))
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

args)
  LANG="${1:-python}"
  ARGS="${2:---name,--port,--verbose}"
  export CLI_LANG="$LANG"
  export CLI_ARGS="$ARGS"
  python3 << 'PYEOF'
import os

lang = os.environ.get("CLI_LANG", "python")
args_str = os.environ.get("CLI_ARGS", "--name,--port,--verbose")
args = [a.strip() for a in args_str.split(",")]

print("=" * 60)
print("  Argument Parser Code ({})".format(lang))
print("=" * 60)
print("")

if lang == "python":
    print("import argparse")
    print("")
    print("parser = argparse.ArgumentParser()")
    for a in args:
        clean = a.lstrip("-")
        if clean == "verbose":
            print('parser.add_argument("{}", "-{}", action="store_true", help="Enable verbose output")'.format(a, clean[0]))
        else:
            print('parser.add_argument("{}", "-{}", type=str, required=True, help="{} value")'.format(a, clean[0], clean.capitalize()))
    print("args = parser.parse_args()")

elif lang == "node":
    print("const { program } = require('commander');")
    print("")
    for a in args:
        clean = a.lstrip("-")
        if clean == "verbose":
            print('program.option("{}, -{}", "Enable verbose output");'.format(a, clean[0]))
        else:
            print('program.option("{} <value>, -{} <value>", "{} value");'.format(a, clean[0], clean.capitalize()))
    print("program.parse();")
    print("const opts = program.opts();")

elif lang == "bash":
    print("while [[ $# -gt 0 ]]; do")
    print("  case $1 in")
    for a in args:
        clean = a.lstrip("-")
        if clean == "verbose":
            print('    {}|-{}) VERBOSE=1; shift ;;'.format(a, clean[0]))
        else:
            print('    {}|-{}) {}="$2"; shift 2 ;;'.format(a, clean[0], clean.upper()))
    print('    *) echo "Unknown: $1"; exit 1 ;;')
    print("  esac")
    print("done")

elif lang == "go":
    print('import "flag"')
    print("")
    for a in args:
        clean = a.lstrip("-")
        if clean == "verbose":
            print('{} := flag.Bool("{}", false, "Enable verbose output")'.format(clean, clean))
        else:
            print('{} := flag.String("{}", "", "{} value")'.format(clean, clean, clean.capitalize()))
    print("flag.Parse()")

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

help)
  APP="${1:-myapp}"
  CMDS="${2:-serve,build,test}"
  export CLI_APP="$APP"
  export CLI_CMDS="$CMDS"
  python3 << 'PYEOF'
import os

app = os.environ.get("CLI_APP", "myapp")
cmds_str = os.environ.get("CLI_CMDS", "serve,build,test")
cmds = [c.strip() for c in cmds_str.split(",")]

print("=" * 60)
print("  Help Documentation: {}".format(app))
print("=" * 60)
print("")
print("Usage: {} <command> [options]".format(app))
print("")
print("Commands:")
for c in cmds:
    print("  {:<16} Run {} task".format(c, c))
print("")
print("Global Options:")
print("  -h, --help       Show this help message")
print("  -v, --version    Show version number")
print("  --no-color       Disable colored output")
print("  --verbose        Enable verbose logging")
print("")
print("Examples:")
print("  {} {} --help".format(app, cmds[0]))
if len(cmds) > 1:
    print("  {} {} --verbose".format(app, cmds[1]))
print("")
print("--- man page template ---")
print('.TH {} 1 "2024" "v0.1.0"'.format(app.upper()))
print(".SH NAME")
print("{} \\- command line tool".format(app))
print(".SH SYNOPSIS")
print(".B {}".format(app))
print("[\\fIcommand\\fR] [\\fIoptions\\fR]")
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

config)
  LANG="${1:-python}"
  FMT="${2:-yaml}"
  export CLI_LANG="$LANG"
  export CLI_FMT="$FMT"
  python3 << 'PYEOF'
import os

lang = os.environ.get("CLI_LANG", "python")
fmt = os.environ.get("CLI_FMT", "yaml")

print("=" * 60)
print("  Config File Handler ({} / {})".format(lang, fmt))
print("=" * 60)
print("")

if lang == "python":
    if fmt == "yaml":
        print("import yaml")
        print("import os")
        print("")
        print("CONFIG_PATH = os.path.expanduser('~/.myapp/config.yml')")
        print("")
        print("def load_config():")
        print("    if not os.path.exists(CONFIG_PATH):")
        print("        return {}")
        print("    with open(CONFIG_PATH, 'r') as f:")
        print("        return yaml.safe_load(f) or {}")
        print("")
        print("def save_config(data):")
        print("    os.makedirs(os.path.dirname(CONFIG_PATH), exist_ok=True)")
        print("    with open(CONFIG_PATH, 'w') as f:")
        print("        yaml.dump(data, f, default_flow_style=False)")
    elif fmt == "json":
        print("import json, os")
        print("")
        print("CONFIG_PATH = os.path.expanduser('~/.myapp/config.json')")
        print("")
        print("def load_config():")
        print("    if not os.path.exists(CONFIG_PATH):")
        print("        return {}")
        print("    with open(CONFIG_PATH) as f:")
        print("        return json.load(f)")
        print("")
        print("def save_config(data):")
        print("    os.makedirs(os.path.dirname(CONFIG_PATH), exist_ok=True)")
        print("    with open(CONFIG_PATH, 'w') as f:")
        print("        json.dump(data, f, indent=2)")
    elif fmt == "toml":
        print("# Python 3.11+ has tomllib built-in")
        print("try:")
        print("    import tomllib")
        print("except ImportError:")
        print("    import pip._vendor.tomli as tomllib")
        print("")
        print("def load_config(path='config.toml'):")
        print("    with open(path, 'rb') as f:")
        print("        return tomllib.load(f)")

elif lang == "node":
    if fmt == "json":
        print("const fs = require('fs');")
        print("const path = require('path');")
        print("")
        print("const CONFIG_PATH = path.join(require('os').homedir(), '.myapp', 'config.json');")
        print("")
        print("function loadConfig() {")
        print("  try { return JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf8')); }")
        print("  catch(e) { return {}; }")
        print("}")
        print("")
        print("function saveConfig(data) {")
        print("  fs.mkdirSync(path.dirname(CONFIG_PATH), { recursive: true });")
        print("  fs.writeFileSync(CONFIG_PATH, JSON.stringify(data, null, 2));")
        print("}")

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

publish)
  PLATFORM="${1:-npm}"
  export CLI_PLATFORM="$PLATFORM"
  python3 << 'PYEOF'
import os

platform = os.environ.get("CLI_PLATFORM", "npm")

checklists = {
    "npm": [
        ("package.json has name, version, description", "Required fields"),
        ("bin field points to entry file", "CLI entry point"),
        ("README.md exists and is complete", "Documentation"),
        ("LICENSE file exists", "Legal"),
        (".npmignore or files field configured", "Publish scope"),
        ("npm pack --dry-run looks correct", "Verify contents"),
        ("npm login verified", "Authentication"),
        ("Version bumped (npm version patch/minor/major)", "Versioning"),
        ("CHANGELOG.md updated", "Release notes"),
        ("npm publish (or npm publish --access public)", "Publish!"),
    ],
    "pip": [
        ("setup.py or pyproject.toml configured", "Build config"),
        ("entry_points/scripts defined", "CLI entry point"),
        ("README.md/rst exists", "Documentation"),
        ("LICENSE file exists", "Legal"),
        ("Version bumped in __version__", "Versioning"),
        ("python -m build", "Build package"),
        ("twine check dist/*", "Validate"),
        ("twine upload dist/*", "Publish to PyPI"),
    ],
}

items = checklists.get(platform, checklists["npm"])
print("=" * 60)
print("  Publish Checklist: {}".format(platform.upper()))
print("=" * 60)
print("")
for i, (task, cat) in enumerate(items, 1):
    print("  [ ] {:>2}. [{}] {}".format(i, cat, task))
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

interactive)
  LANG="${1:-python}"
  PROMPTS="${2:-name,email,confirm}"
  export CLI_LANG="$LANG"
  export CLI_PROMPTS="$PROMPTS"
  python3 << 'PYEOF'
import os

lang = os.environ.get("CLI_LANG", "python")
prompts_str = os.environ.get("CLI_PROMPTS", "name,email,confirm")
prompts = [p.strip() for p in prompts_str.split(",")]

print("=" * 60)
print("  Interactive CLI Code ({})".format(lang))
print("=" * 60)
print("")

if lang == "python":
    print("def prompt_user():")
    print("    answers = {}")
    for p in prompts:
        if p == "confirm":
            print("    val = input('Confirm? [y/N]: ').strip().lower()")
            print("    answers['{}'] = val in ('y', 'yes')".format(p))
        else:
            print("    answers['{}'] = input('{}: ').strip()".format(p, p.capitalize()))
    print("    return answers")
    print("")
    print("if __name__ == '__main__':")
    print("    result = prompt_user()")
    print("    print(result)")

elif lang == "node":
    print("const readline = require('readline');")
    print("")
    print("function ask(rl, question) {")
    print("  return new Promise(resolve => {")
    print("    rl.question(question + ': ', resolve);")
    print("  });")
    print("}")
    print("")
    print("async function main() {")
    print("  const rl = readline.createInterface({ input: process.stdin, output: process.stdout });")
    for p in prompts:
        print("  const {} = await ask(rl, '{}');".format(p.replace("-", "_"), p.capitalize()))
    print("  rl.close();")
    print("  console.log({" + ", ".join(["{}".format(p.replace("-","_")) for p in prompts]) + "});")
    print("}")
    print("main();")

elif lang == "bash":
    for p in prompts:
        if p == "confirm":
            print('read -p "Confirm? [y/N]: " CONFIRM')
            print('if [[ "$CONFIRM" =~ ^[Yy] ]]; then echo "Confirmed"; fi')
        else:
            print('read -p "{}: " {}'.format(p.capitalize(), p.upper()))

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

color)
  LANG="${1:-python}"
  export CLI_LANG="$LANG"
  python3 << 'PYEOF'
import os

lang = os.environ.get("CLI_LANG", "python")

print("=" * 60)
print("  Colored Output Code ({})".format(lang))
print("=" * 60)
print("")

if lang == "python":
    print("import os, sys")
    print("")
    print("def supports_color():")
    print("    return hasattr(sys.stdout, 'isatty') and sys.stdout.isatty() \\")
    print("        and os.environ.get('NO_COLOR') is None")
    print("")
    print("class Color:")
    print("    RESET = '\\033[0m'")
    print("    RED = '\\033[31m'")
    print("    GREEN = '\\033[32m'")
    print("    YELLOW = '\\033[33m'")
    print("    BLUE = '\\033[34m'")
    print("    MAGENTA = '\\033[35m'")
    print("    CYAN = '\\033[36m'")
    print("    BOLD = '\\033[1m'")
    print("    DIM = '\\033[2m'")
    print("")
    print("def colored(text, color):")
    print("    if not supports_color():")
    print("        return text")
    print("    return '{}{}{}'.format(color, text, Color.RESET)")
    print("")
    print("# Usage:")
    print("# print(colored('Success!', Color.GREEN))")
    print("# print(colored('Error!', Color.RED))")
    print("# print(colored('Warning', Color.YELLOW))")

elif lang == "node":
    print("const noColor = process.env.NO_COLOR !== undefined;")
    print("")
    print("const colors = {")
    print("  reset: '\\x1b[0m', red: '\\x1b[31m',")
    print("  green: '\\x1b[32m', yellow: '\\x1b[33m',")
    print("  blue: '\\x1b[34m', magenta: '\\x1b[35m',")
    print("  cyan: '\\x1b[36m', bold: '\\x1b[1m',")
    print("};")
    print("")
    print("function colored(text, color) {")
    print("  if (noColor) return text;")
    print("  return colors[color] + text + colors.reset;")
    print("}")
    print("")
    print("// console.log(colored('Success!', 'green'));")

elif lang == "bash":
    print("# Color definitions")
    print('RED="\\033[31m"')
    print('GREEN="\\033[32m"')
    print('YELLOW="\\033[33m"')
    print('BLUE="\\033[34m"')
    print('BOLD="\\033[1m"')
    print('RESET="\\033[0m"')
    print("")
    print("# Usage:")
    print('echo -e "${GREEN}Success!${RESET}"')
    print('echo -e "${RED}Error!${RESET}"')
    print('echo -e "${BOLD}${YELLOW}Warning${RESET}"')
    print("")
    print("# NO_COLOR support:")
    print('if [ -n \"$NO_COLOR\" ]; then')
    print('  RED="" GREEN="" YELLOW="" BLUE="" BOLD="" RESET=""')
    print("fi")

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

*)
  echo "CLI Builder - Command-Line Tool Generator"
  echo ""
  echo "Usage: bash cli-builder.sh <command> [args]"
  echo ""
  echo "Commands:"
  echo "  init <name> <lang>          Generate CLI project skeleton"
  echo "  command <app> <cmd> <desc>  Add a command to CLI"
  echo "  args <lang> <args>          Generate argument parser code"
  echo "  help <app> <commands>       Generate help documentation"
  echo "  config <lang> <format>      Config file handler code"
  echo "  publish <platform>          Publish checklist (npm/pip)"
  echo "  interactive <lang> <prompts> Interactive CLI prompts"
  echo "  color <lang>                Colored output utilities"
  echo ""
  echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
  ;;

esac
