#!/usr/bin/env bash
# builder — Project scaffold generator
set -euo pipefail

CMD="${1:-help}"
shift || true
TEMPLATE="${1:-}"
NAME="${2:-my-project}"
OUTDIR="${2:-$(pwd)/$NAME}"

show_help() {
    echo "builder — Project scaffold generator"
    echo ""
    echo "Usage:"
    echo "  builder list                          List available templates"
    echo "  builder init <template> <name>        Create project in current dir"
    echo "  builder generate <template> <outdir>  Generate in specific directory"
    echo ""
    echo "Templates: node, node-cli, python, python-flask, go, go-cli"
}

cmd_list() {
    echo "Available project templates:"
    echo ""
    echo "  node          Node.js REST API with Express"
    echo "  node-cli      Node.js CLI tool with commander"
    echo "  python        Python project with virtualenv"
    echo "  python-flask  Flask web application"
    echo "  go            Go module with main.go"
    echo "  go-cli        Go CLI with cobra structure"
    echo ""
    echo "Usage: builder init <template> <project-name>"
}

scaffold_node() {
    local dir="$1"
    mkdir -p "$dir/src" "$dir/tests"
    cat > "$dir/package.json" << 'EOF'
{
  "name": "my-app",
  "version": "1.0.0",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "jest"
  },
  "dependencies": {
    "express": "^4.18.0"
  },
  "devDependencies": {
    "nodemon": "^3.0.0",
    "jest": "^29.0.0"
  }
}
EOF
    cat > "$dir/src/index.js" << 'EOF'
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req, res) => {
  res.json({ status: 'ok', message: 'Hello World' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
EOF
    cat > "$dir/.gitignore" << 'EOF'
node_modules/
.env
*.log
EOF
    echo "  src/index.js"
    echo "  package.json"
    echo "  .gitignore"
}

scaffold_python() {
    local dir="$1"
    mkdir -p "$dir/src" "$dir/tests"
    cat > "$dir/requirements.txt" << 'EOF'
# Add your dependencies here
requests>=2.28.0
EOF
    cat > "$dir/src/main.py" << 'EOF'
def main():
    print("Hello, World!")

if __name__ == "__main__":
    main()
EOF
    cat > "$dir/setup.sh" << 'EOF'
#!/bin/bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
echo "Setup complete. Run: source venv/bin/activate"
EOF
    chmod +x "$dir/setup.sh"
    cat > "$dir/.gitignore" << 'EOF'
venv/
__pycache__/
*.pyc
.env
EOF
    echo "  src/main.py"
    echo "  requirements.txt"
    echo "  setup.sh"
    echo "  .gitignore"
}

scaffold_flask() {
    local dir="$1"
    mkdir -p "$dir/app/templates" "$dir/app/static" "$dir/tests"
    cat > "$dir/requirements.txt" << 'EOF'
flask>=3.0.0
python-dotenv>=1.0.0
EOF
    cat > "$dir/app/__init__.py" << 'EOF'
from flask import Flask

def create_app():
    app = Flask(__name__)

    from .routes import main
    app.register_blueprint(main)

    return app
EOF
    cat > "$dir/app/routes.py" << 'EOF'
from flask import Blueprint, jsonify

main = Blueprint('main', __name__)

@main.route('/')
def index():
    return jsonify({'status': 'ok'})
EOF
    cat > "$dir/run.py" << 'EOF'
from app import create_app
app = create_app()

if __name__ == '__main__':
    app.run(debug=True)
EOF
    echo "  app/__init__.py"
    echo "  app/routes.py"
    echo "  run.py"
    echo "  requirements.txt"
}

scaffold_go() {
    local dir="$1"
    local modname
    modname=$(basename "$dir")
    mkdir -p "$dir/cmd" "$dir/internal"
    cat > "$dir/go.mod" << EOF
module github.com/user/$modname

go 1.21
EOF
    cat > "$dir/main.go" << 'EOF'
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
EOF
    cat > "$dir/.gitignore" << 'EOF'
bin/
*.exe
EOF
    echo "  main.go"
    echo "  go.mod"
    echo "  .gitignore"
}

scaffold_go_cli() {
    local dir="$1"
    local modname
    modname=$(basename "$dir")
    mkdir -p "$dir/cmd"
    cat > "$dir/go.mod" << EOF
module github.com/user/$modname

go 1.21

require github.com/spf13/cobra v1.8.0
EOF
    cat > "$dir/main.go" << 'EOF'
package main

import "github.com/user/myapp/cmd"

func main() {
    cmd.Execute()
}
EOF
    cat > "$dir/cmd/root.go" << 'EOF'
package cmd

import (
    "fmt"
    "github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
    Use:   "app",
    Short: "A CLI application",
    Run: func(cmd *cobra.Command, args []string) {
        fmt.Println("Hello from CLI!")
    },
}

func Execute() {
    rootCmd.Execute()
}
EOF
    echo "  main.go"
    echo "  cmd/root.go"
    echo "  go.mod"
}

scaffold_node_cli() {
    local dir="$1"
    mkdir -p "$dir/bin" "$dir/src"
    cat > "$dir/package.json" << 'EOF'
{
  "name": "my-cli",
  "version": "1.0.0",
  "bin": { "my-cli": "./bin/cli.js" },
  "scripts": { "start": "node bin/cli.js" },
  "dependencies": { "commander": "^11.0.0" }
}
EOF
    cat > "$dir/bin/cli.js" << 'EOF'
#!/usr/bin/env node
const { Command } = require('commander');
const program = new Command();

program
  .name('my-cli')
  .description('CLI tool')
  .version('1.0.0');

program
  .command('hello')
  .description('Say hello')
  .action(() => console.log('Hello!'));

program.parse();
EOF
    chmod +x "$dir/bin/cli.js"
    echo "  bin/cli.js"
    echo "  package.json"
}

do_init() {
    local template="$1"
    local name="${2:-my-project}"
    local dir="$(pwd)/$name"

    if [ -d "$dir" ]; then
        echo "Error: directory '$dir' already exists"
        exit 1
    fi
    mkdir -p "$dir"
    echo "🏗  Creating $template project: $name"
    echo "   Location: $dir"
    echo "   Files:"
    case "$template" in
        node) scaffold_node "$dir" ;;
        node-cli) scaffold_node_cli "$dir" ;;
        python) scaffold_python "$dir" ;;
        python-flask) scaffold_flask "$dir" ;;
        go) scaffold_go "$dir" ;;
        go-cli) scaffold_go_cli "$dir" ;;
        *) echo "Unknown template: $template. Run: builder list"; exit 1 ;;
    esac
    echo ""
    echo "✅ Project '$name' created at $dir"
}

do_generate() {
    local template="$1"
    local outdir="${2:-$(pwd)/generated}"
    mkdir -p "$outdir"
    echo "🏗  Generating $template scaffold in: $outdir"
    echo "   Files:"
    case "$template" in
        node) scaffold_node "$outdir" ;;
        node-cli) scaffold_node_cli "$outdir" ;;
        python) scaffold_python "$outdir" ;;
        python-flask) scaffold_flask "$outdir" ;;
        go) scaffold_go "$outdir" ;;
        go-cli) scaffold_go_cli "$outdir" ;;
        *) echo "Unknown template: $template. Run: builder list"; exit 1 ;;
    esac
    echo ""
    echo "✅ Scaffold generated at $outdir"
}

case "$CMD" in
    list) cmd_list ;;
    init) do_init "$TEMPLATE" "$NAME" ;;
    generate) do_generate "$TEMPLATE" "$OUTDIR" ;;
    help|--help|-h) show_help ;;
    *) echo "Unknown command: $CMD"; show_help; exit 1 ;;
esac
