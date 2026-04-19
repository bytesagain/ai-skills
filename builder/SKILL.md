# builder

Project scaffold generator — create ready-to-use project structures for Node.js, Python, Go, and more with a single command. Lists templates, initializes directories, and generates boilerplate files.

## Usage

```
builder list
builder init <template> <project_name>
builder generate <template> <output_dir>
```

## Commands

- `list` — Show all available project templates with descriptions
- `init` — Create a new project directory with full scaffold in current location
- `generate` — Generate project scaffold in a specified output directory

## Examples

```bash
builder list
builder init node my-api
builder init python-flask web-app
builder init go my-service
builder generate node-cli /tmp/my-tool
```

## Templates

- `node` — Node.js REST API (Express + package.json + .gitignore)
- `node-cli` — Node.js CLI tool with commander
- `python` — Python project with virtualenv setup and requirements.txt
- `python-flask` — Flask web app with app factory pattern
- `go` — Go module with main.go and go.mod
- `go-cli` — Go CLI with cobra framework structure

## Requirements

- bash

## When to Use

Use when starting a new project and want a consistent, ready-to-code directory structure without manual setup.
