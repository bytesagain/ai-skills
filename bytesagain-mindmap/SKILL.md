# mindmap

**Text Mind Map Generator** — Transform plain outlines and bullet lists into beautiful ASCII tree diagrams. Visualize your ideas, document structures, and hierarchies directly in the terminal.

## Commands

| Command | Description | Example |
|---------|-------------|---------|
| `create` | Generate ASCII mind map from text input | `create "Project\n  Frontend\n    React\n  Backend\n    Node"` |
| `view` | Read a text file and render as mind map | `view outline.txt` |
| `export` | Render and output as Markdown code block | `export outline.txt` |

## Usage

```bash
# From a string (use \n for newlines)
bash script.sh create "Root\n  Branch A\n    Leaf 1\n    Leaf 2\n  Branch B"

# From a file
bash script.sh view my-outline.txt

# Export as Markdown
bash script.sh export my-outline.txt > mindmap.md

# Pipe from stdin
cat outline.txt | bash script.sh view -
```

## Input Format

Use indentation (spaces or tabs) to define hierarchy. The first non-empty line is the root node.

```
My Project
  Frontend
    React
      Components
      Hooks
    CSS
      Tailwind
  Backend
    Node.js
    PostgreSQL
  DevOps
    Docker
    CI/CD
```

## Requirements

- `bash` >= 4.0
- `python3` >= 3.7
- No external packages required (uses only stdlib)

## Examples

```
$ bash script.sh create "Learning Python\n  Basics\n    Variables\n    Functions\n  OOP\n    Classes\n    Inheritance\n  Libraries\n    NumPy\n    Pandas"

Learning Python
├── Basics
│   ├── Variables
│   └── Functions
├── OOP
│   ├── Classes
│   └── Inheritance
└── Libraries
    ├── NumPy
    └── Pandas
```

```
$ bash script.sh export outline.txt

```mindmap
My Project
├── Frontend
│   ├── React
│   └── CSS
└── Backend
    └── Node.js
```
```
