#!/usr/bin/env bash
# education skill - Learning plan generator, quiz, progress tracker
# Usage: bash script.sh <plan|quiz|progress> [args...]
set -euo pipefail

COMMAND="${1:-}"
ARG1="${2:-}"
ARG2="${3:-}"

BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

STORAGE_DIR="${HOME}/.local/share/education-skill"
PROGRESS_FILE="${STORAGE_DIR}/progress.json"

usage() {
  cat <<EOF
${BOLD}education skill${RESET} — Learning plan generator & progress tracker

Commands:
  plan <topic>                  Generate a 7-day learning plan
  quiz <topic> [num]            Generate quiz questions (default: 5)
  progress show                 Show current progress
  progress done "<milestone>"   Mark a milestone as completed
  progress reset                Reset progress

Examples:
  bash script.sh plan "Python"
  bash script.sh quiz "Docker" 3
  bash script.sh progress show
  bash script.sh progress done "Day 1"
EOF
  exit 0
}

# ── Python core ──────────────────────────────────────────────────────────────

run_python() {
  python3 -u - "$@" <<'PYEOF'
import sys
import json
import os
import re
import hashlib
import datetime

cmd  = sys.argv[1]
args = sys.argv[2:]

STORAGE_DIR  = os.path.expanduser("~/.local/share/education-skill")
PROGRESS_FILE = os.path.join(STORAGE_DIR, "progress.json")

BOLD  = "\033[1m"
GREEN = "\033[0;32m"
CYAN  = "\033[0;36m"
YELLOW= "\033[1;33m"
RED   = "\033[0;31m"
RESET = "\033[0m"
BAR   = "━" * 42

# ── Knowledge base ────────────────────────────────────────────────────────────

PLANS = {
    "_default": {
        "days": [
            {"title": "Foundations & Setup",
             "goals": ["Understand the core concepts", "Set up your environment", "Complete a hello-world example"],
             "resources": ["Official documentation (search: '{topic} official docs')",
                           "freeCodeCamp YouTube channel", "Wikipedia overview article"]},
            {"title": "Core Concepts Deep Dive",
             "goals": ["Study the main concepts in detail", "Take notes on key terminology", "Find 3 real-world use cases"],
             "resources": ["Official tutorial (Getting Started section)",
                           "MDN Web Docs / language reference"]},
            {"title": "Hands-On Practice",
             "goals": ["Build a small project", "Solve 3 beginner exercises", "Review solutions and patterns"],
             "resources": ["Exercism.io — free coding exercises", "Codewars — kata challenges"]},
            {"title": "Intermediate Topics",
             "goals": ["Explore advanced features", "Read source code of a popular library", "Understand error handling"],
             "resources": ["Official advanced guides", "Dev.to articles on the topic"]},
            {"title": "Real-World Project",
             "goals": ["Build a slightly larger project", "Use best practices", "Write basic tests"],
             "resources": ["GitHub — search for '{topic} examples'", "Stack Overflow Q&A"]},
            {"title": "Community & Ecosystem",
             "goals": ["Explore popular libraries/tools", "Read changelog / release notes", "Join a community forum"],
             "resources": ["Reddit r/{topic}", "Official community forums or Discord"]},
            {"title": "Review & Next Steps",
             "goals": ["Review all notes", "Identify gaps — revisit weak areas", "Plan your next learning goal"],
             "resources": ["Your own notes", "Roadmap.sh — structured roadmaps"]},
        ]
    },
    "python": {
        "days": [
            {"title": "Python Basics",
             "goals": ["Install Python 3 and set up a virtual env", "Learn variables, types, and control flow", "Write your first script"],
             "resources": ["Python Official Tutorial: https://docs.python.org/3/tutorial/",
                           "freeCodeCamp Python Full Course (YouTube)"]},
            {"title": "Functions & Modules",
             "goals": ["Define and call functions", "Understand scope and closures", "Import standard library modules"],
             "resources": ["Real Python — Functions: https://realpython.com/defining-your-own-python-function/",
                           "Python stdlib docs: https://docs.python.org/3/library/"]},
            {"title": "Data Structures",
             "goals": ["Master lists, dicts, sets, tuples", "List comprehensions and generators", "Practice with LeetCode easy problems"],
             "resources": ["Python Data Structures docs", "Exercism Python track: https://exercism.org/tracks/python"]},
            {"title": "OOP in Python",
             "goals": ["Classes, inheritance, dunder methods", "dataclasses and properties", "Build a small OOP project"],
             "resources": ["Real Python OOP guide", "Python docs: classes"]},
            {"title": "File I/O & Error Handling",
             "goals": ["Read/write files with context managers", "Exception handling patterns", "JSON and CSV processing"],
             "resources": ["Python exceptions docs", "Real Python file I/O guide"]},
            {"title": "Testing & Packaging",
             "goals": ["Write tests with pytest", "Package a module with pyproject.toml", "Run CI with GitHub Actions"],
             "resources": ["pytest docs: https://docs.pytest.org/", "Python Packaging Guide: https://packaging.python.org/"]},
            {"title": "Python Ecosystem",
             "goals": ["Explore pip, virtualenv, poetry", "Intro to popular libs: requests, click, pydantic", "Build and share a small CLI tool"],
             "resources": ["Awesome Python: https://awesome-python.com/", "PyPI: https://pypi.org/"]},
        ]
    },
    "docker": {
        "days": [
            {"title": "Containers & Docker Basics",
             "goals": ["Understand containers vs VMs", "Install Docker Engine", "Run: docker run hello-world"],
             "resources": ["Docker Get Started: https://docs.docker.com/get-started/",
                           "Play with Docker: https://labs.play-with-docker.com/"]},
            {"title": "Images & Dockerfile",
             "goals": ["Pull and inspect images", "Write your first Dockerfile", "Build and tag an image"],
             "resources": ["Dockerfile reference: https://docs.docker.com/engine/reference/builder/",
                           "Docker Hub: https://hub.docker.com/"]},
            {"title": "Containers & Networking",
             "goals": ["Run containers with port mapping", "Understand bridge networks", "Link containers together"],
             "resources": ["Docker networking docs: https://docs.docker.com/network/"]},
            {"title": "Volumes & Data",
             "goals": ["Bind mounts vs named volumes", "Persist database data", "Inspect volumes"],
             "resources": ["Docker storage docs: https://docs.docker.com/storage/"]},
            {"title": "Docker Compose",
             "goals": ["Write docker-compose.yml", "Multi-container apps (app + db)", "docker compose up/down/logs"],
             "resources": ["Compose docs: https://docs.docker.com/compose/",
                           "Awesome Compose examples: https://github.com/docker/awesome-compose"]},
            {"title": "Best Practices & Security",
             "goals": ["Multi-stage builds", "Minimize image size", "Scan images with docker scout"],
             "resources": ["Docker best practices: https://docs.docker.com/develop/dev-best-practices/"]},
            {"title": "Kubernetes Intro",
             "goals": ["Understand k8s vs Docker Compose", "Run a pod with kubectl", "Explore minikube locally"],
             "resources": ["Kubernetes official tutorial: https://kubernetes.io/docs/tutorials/",
                           "KillerCoda free k8s labs: https://killercoda.com/"]},
        ]
    },
    "javascript": {
        "days": [
            {"title": "JS Fundamentals",
             "goals": ["Variables (let/const/var), types", "Control flow and functions", "Run JS in browser and Node.js"],
             "resources": ["MDN JavaScript Guide: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide",
                           "javascript.info: https://javascript.info/"]},
            {"title": "Arrays & Objects",
             "goals": ["Array methods: map, filter, reduce", "Object destructuring and spread", "Practice on Exercism"],
             "resources": ["MDN Array reference", "javascript.info Objects"]},
            {"title": "Async JavaScript",
             "goals": ["Callbacks, Promises, async/await", "fetch() API basics", "Error handling in async code"],
             "resources": ["javascript.info Promises: https://javascript.info/promise-basics",
                           "MDN async/await guide"]},
            {"title": "DOM & Browser APIs",
             "goals": ["Select and modify DOM elements", "Event listeners", "LocalStorage and SessionStorage"],
             "resources": ["MDN DOM API", "javascript30.com — 30 vanilla JS projects"]},
            {"title": "Modern JS (ES6+)",
             "goals": ["Modules (import/export)", "Classes and iterators", "Optional chaining and nullish coalescing"],
             "resources": ["javascript.info Modern JS"]},
            {"title": "Node.js & npm",
             "goals": ["Create an HTTP server", "Use npm packages", "Build a small CLI tool"],
             "resources": ["Node.js Getting Started: https://nodejs.org/en/docs/guides/getting-started-guide",
                           "npm docs: https://docs.npmjs.com/"]},
            {"title": "Testing & Tooling",
             "goals": ["Write tests with Jest", "Lint with ESLint", "Bundle with Vite or esbuild"],
             "resources": ["Jest docs: https://jestjs.io/", "ESLint: https://eslint.org/"]},
        ]
    },
    "go": {
        "days": [
            {"title": "Go Basics",
             "goals": ["Install Go, run hello world", "Variables, types, functions", "Understand packages and imports"],
             "resources": ["A Tour of Go: https://go.dev/tour/", "Go by Example: https://gobyexample.com/"]},
            {"title": "Control Flow & Arrays",
             "goals": ["for loops (only loop in Go)", "Arrays, slices, maps", "Structs and methods"],
             "resources": ["Go by Example: https://gobyexample.com/"]},
            {"title": "Interfaces & Error Handling",
             "goals": ["Define and implement interfaces", "Error type and idiomatic handling", "Multiple return values"],
             "resources": ["Effective Go: https://go.dev/doc/effective_go"]},
            {"title": "Goroutines & Channels",
             "goals": ["Launch goroutines", "Send/receive on channels", "Select statement"],
             "resources": ["Go concurrency guide: https://go.dev/blog/concurrency-is-not-parallelism"]},
            {"title": "Standard Library",
             "goals": ["net/http — build a web server", "encoding/json — marshal/unmarshal", "os and io packages"],
             "resources": ["Go stdlib reference: https://pkg.go.dev/std"]},
            {"title": "Testing & Modules",
             "goals": ["Write tests with testing package", "Benchmarks and examples", "Manage deps with go.mod"],
             "resources": ["Go testing docs: https://pkg.go.dev/testing"]},
            {"title": "Real-World Go",
             "goals": ["Build a REST API", "Explore popular libs: chi, sqlx, zap", "Deploy with Docker"],
             "resources": ["Awesome Go: https://awesome-go.com/"]},
        ]
    },
}

QUIZZES = {
    "_default": [
        {"q": "What does '{topic}' primarily help with?", "options": ["A) General purpose", "B) Specific domain tasks", "C) Both A and B", "D) Neither"], "ans": "C"},
        {"q": "Which is a best practice when learning '{topic}'?", "options": ["A) Reading only theory", "B) Hands-on practice with projects", "C) Memorizing syntax", "D) Avoiding documentation"], "ans": "B"},
        {"q": "What is the first step when starting with '{topic}'?", "options": ["A) Advanced optimization", "B) Setting up the environment", "C) Production deployment", "D) Team coordination"], "ans": "B"},
        {"q": "How do you handle errors in most '{topic}' workflows?", "options": ["A) Ignore them", "B) Crash and restart", "C) Log and handle gracefully", "D) Delete the code"], "ans": "C"},
        {"q": "Where can you find community help for '{topic}'?", "options": ["A) Only paid courses", "B) Official docs and community forums", "C) Only YouTube", "D) Only books"], "ans": "B"},
    ],
    "python": [
        {"q": "What is the output of: print(type([]))", "options": ["A) <class 'tuple'>", "B) <class 'list'>", "C) <class 'array'>", "D) <class 'dict'>"], "ans": "B"},
        {"q": "Which keyword defines a function in Python?", "options": ["A) function", "B) fn", "C) def", "D) lambda"], "ans": "C"},
        {"q": "What does list(range(3)) return?", "options": ["A) [1, 2, 3]", "B) [0, 1, 2]", "C) [0, 1, 2, 3]", "D) [1, 2]"], "ans": "B"},
        {"q": "How do you open a file safely in Python?", "options": ["A) f = open('x')", "B) with open('x') as f:", "C) file.open('x')", "D) import open('x')"], "ans": "B"},
        {"q": "What does 'self' refer to in a class method?", "options": ["A) The class itself", "B) The instance of the class", "C) A global variable", "D) The parent class"], "ans": "B"},
        {"q": "Which is a valid list comprehension?", "options": ["A) [x*2 for x in range(5)]", "B) {x*2 : range(5)}", "C) list(x*2, range(5))", "D) (x*2 range(5))"], "ans": "A"},
        {"q": "What does 'pip install requests' do?", "options": ["A) Installs Python", "B) Installs the requests HTTP library", "C) Runs an HTTP request", "D) Updates pip itself"], "ans": "B"},
    ],
    "docker": [
        {"q": "What command runs a Docker container interactively?", "options": ["A) docker start -i", "B) docker run -it", "C) docker exec bash", "D) docker attach"], "ans": "B"},
        {"q": "What does a Dockerfile FROM instruction specify?", "options": ["A) Output directory", "B) Base image", "C) Port to expose", "D) Entry command"], "ans": "B"},
        {"q": "How do you list running containers?", "options": ["A) docker list", "B) docker ps", "C) docker show", "D) docker containers"], "ans": "B"},
        {"q": "What is the purpose of EXPOSE in a Dockerfile?", "options": ["A) Opens firewall port", "B) Documents that a port is used", "C) Binds port to host", "D) Starts a service"], "ans": "B"},
        {"q": "What file does Docker Compose read by default?", "options": ["A) dockerfile.yml", "B) compose.yaml or docker-compose.yml", "C) container.json", "D) services.yml"], "ans": "B"},
        {"q": "How do you stop and remove all compose services?", "options": ["A) docker stop all", "B) docker compose down", "C) docker rm -f", "D) docker purge"], "ans": "B"},
        {"q": "What does a named volume do?", "options": ["A) Exposes a port", "B) Persists data across container restarts", "C) Sets environment vars", "D) Limits CPU usage"], "ans": "B"},
    ],
    "javascript": [
        {"q": "What does 'typeof null' return in JavaScript?", "options": ["A) 'null'", "B) 'object'", "C) 'undefined'", "D) 'number'"], "ans": "B"},
        {"q": "Which array method returns a new array with transformed elements?", "options": ["A) filter()", "B) map()", "C) reduce()", "D) find()"], "ans": "B"},
        {"q": "What is the correct way to declare a constant?", "options": ["A) var x = 1", "B) let x = 1", "C) const x = 1", "D) int x = 1"], "ans": "C"},
        {"q": "What does async/await help with?", "options": ["A) Synchronous code", "B) Writing asynchronous code more readably", "C) Type checking", "D) Memory management"], "ans": "B"},
        {"q": "Which method adds an element to the end of an array?", "options": ["A) unshift()", "B) push()", "C) append()", "D) add()"], "ans": "B"},
    ],
    "go": [
        {"q": "What is Go's only loop keyword?", "options": ["A) while", "B) loop", "C) for", "D) each"], "ans": "C"},
        {"q": "How do you declare an error in Go?", "options": ["A) throw new Error()", "B) raise Exception()", "C) return fmt.Errorf('msg')", "D) panic('msg')"], "ans": "C"},
        {"q": "What does 'go' keyword do before a function call?", "options": ["A) Imports a package", "B) Starts a goroutine", "C) Defines a method", "D) Runs tests"], "ans": "B"},
        {"q": "How do you handle multiple return values in Go?", "options": ["A) result, _ := fn()", "B) result = fn()", "C) [result, err] = fn()", "D) fn() -> result, err"], "ans": "A"},
        {"q": "What is the zero value of a string in Go?", "options": ['A) null', 'B) ""', 'C) None', 'D) undefined'], "ans": "B"},
    ],
}

# ── Helper functions ─────────────────────────────────────────────────────────

def load_progress():
    if os.path.exists(PROGRESS_FILE):
        with open(PROGRESS_FILE) as f:
            return json.load(f)
    return {"topic": None, "started": None, "completed": []}

def save_progress(data):
    os.makedirs(os.path.dirname(PROGRESS_FILE), exist_ok=True)
    with open(PROGRESS_FILE, 'w') as f:
        json.dump(data, f, indent=2)

def get_plan(topic):
    key = topic.lower().strip()
    for k in PLANS:
        if k != "_default" and k in key:
            return PLANS[k]
    return PLANS["_default"]

def get_quizzes(topic):
    key = topic.lower().strip()
    for k in QUIZZES:
        if k != "_default" and k in key:
            return QUIZZES[k]
    return QUIZZES["_default"]

def progress_bar(done, total, width=20):
    filled = int(width * done / total) if total else 0
    return "█" * filled + "░" * (width - filled)

# ── Commands ─────────────────────────────────────────────────────────────────

if cmd == "plan":
    topic = args[0] if args else "General"
    plan  = get_plan(topic)

    print(f"\n{BOLD}📚 Learning Plan: {topic}{RESET}")
    print(BAR)
    print(f"Duration  : 7 days")
    print(f"Level     : Beginner → Intermediate\n")

    for i, day in enumerate(plan["days"], 1):
        print(f"{BOLD}Day {i}: {day['title']}{RESET}")
        print(f"  {CYAN}Goals:{RESET}")
        for g in day["goals"]:
            print(f"    • {g.replace('{topic}', topic)}")
        print(f"  {CYAN}Resources:{RESET}")
        for r in day["resources"]:
            print(f"    → {r.replace('{topic}', topic)}")
        print()

    print(f"{YELLOW}Tip:{RESET} Use 'bash script.sh progress done \"Day N\"' to track your progress.")
    print()

elif cmd == "quiz":
    topic = args[0] if args else "General"
    num   = int(args[1]) if len(args) > 1 else 5
    pool  = get_quizzes(topic)
    # Deterministically select questions
    selected = pool[:num] if num <= len(pool) else pool * (num // len(pool) + 1)
    selected = selected[:num]

    print(f"\n{BOLD}📝 Quiz: {topic}  ({num} questions){RESET}")
    print(BAR + "\n")

    for i, q in enumerate(selected, 1):
        question = q["q"].replace("{topic}", topic)
        print(f"{BOLD}Q{i}. {question}{RESET}")
        ans_key = q["ans"]
        for opt in q["options"]:
            letter = opt[0]
            if letter == ans_key:
                print(f"  {GREEN}{opt}   ✓{RESET}")
            else:
                print(f"  {opt}")
        print()

elif cmd == "progress":
    subcmd = args[0] if args else "show"

    if subcmd == "show":
        data = load_progress()
        topic     = data.get("topic") or "—"
        started   = data.get("started") or "—"
        completed = data.get("completed") or []
        plan      = get_plan(topic) if data.get("topic") else get_plan("_default")
        total     = len(plan["days"])
        done_n    = len(completed)

        print(f"\n{BOLD}📊 Study Progress{RESET}")
        print(BAR)
        print(f"Topic     : {topic}")
        print(f"Started   : {started}")
        if completed:
            print(f"Completed : {', '.join(completed)}")
        else:
            print(f"Completed : (none yet)")
        bar = progress_bar(done_n, total)
        pct = int(100 * done_n / total) if total else 0
        print(f"Progress  : {GREEN}{bar}{RESET}  {done_n}/{total} days ({pct}%)")
        print()

    elif subcmd == "done":
        milestone = args[1] if len(args) > 1 else "Day 1"
        data = load_progress()
        if not data.get("topic"):
            data["topic"]   = "General"
            data["started"] = str(datetime.date.today())
        if milestone not in data["completed"]:
            data["completed"].append(milestone)
            save_progress(data)
            print(f"{GREEN}✅ Marked as done: {milestone}{RESET}")
        else:
            print(f"{YELLOW}Already completed: {milestone}{RESET}")

    elif subcmd == "reset":
        save_progress({"topic": None, "started": None, "completed": []})
        print(f"{YELLOW}Progress reset.{RESET}")

    elif subcmd == "set-topic":
        topic = args[1] if len(args) > 1 else "General"
        data  = load_progress()
        data["topic"]   = topic
        data["started"] = str(datetime.date.today())
        data["completed"] = []
        save_progress(data)
        print(f"{GREEN}Topic set: {topic}  (started today){RESET}")

    else:
        print(f"Unknown progress subcommand: {subcmd}")
        print("Usage: progress show | progress done '<milestone>' | progress reset")

else:
    print(f"Unknown command: {cmd}")
    sys.exit(1)
PYEOF
}

case "$COMMAND" in
  plan)
    [[ -z "$ARG1" ]] && { echo "Usage: bash script.sh plan \"topic\""; exit 1; }
    run_python "plan" "$ARG1"
    ;;
  quiz)
    [[ -z "$ARG1" ]] && { echo "Usage: bash script.sh quiz \"topic\" [num_questions]"; exit 1; }
    run_python "quiz" "$ARG1" "${ARG2:-5}"
    ;;
  progress)
    SUBCMD="${ARG1:-show}"
    EXTRA="${ARG2:-}"
    run_python "progress" "$SUBCMD" "$EXTRA"
    ;;
  help|--help|-h|"")
    usage
    ;;
  *)
    echo -e "${RED}Unknown command: $COMMAND${RESET}"
    echo "Run: bash script.sh help"
    exit 1
    ;;
esac
