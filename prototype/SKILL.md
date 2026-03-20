---
name: prototype
description: "Build interactive HTML prototypes. Use when creating clickable mockups, adding animations, linking pages, or exporting HTML."
version: "3.4.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags:
  - prototype
  - html
  - ui
  - animation
  - interaction
  - design
---

# Prototype

Create interactive HTML prototypes with components, animations, and navigation.

## Commands

### create

Create a new interactive prototype HTML page with specified sections and style.

```bash
bash scripts/script.sh create --name "app-proto" --sections "nav,hero,features,footer" --theme light --output proto/
```

### component

Generate a standalone UI component (button, modal, card, form, navbar, etc).

```bash
bash scripts/script.sh component --type modal --title "Confirm" --body "Are you sure?" --actions "cancel,confirm" --output components/
```

### animate

Add CSS animation to an element in an existing prototype HTML file.

```bash
bash scripts/script.sh animate --input proto/index.html --selector ".hero" --animation fadeIn --duration 0.5s --output proto/index.html
```

### link

Add click-based page navigation between prototype pages.

```bash
bash scripts/script.sh link --from proto/index.html --selector ".nav-about" --to proto/about.html
```

### preview

Generate a preview summary of a prototype: page list, component count, linked routes.

```bash
bash scripts/script.sh preview --input proto/
```

### export

Bundle a multi-page prototype into a single self-contained HTML file with all assets inlined.

```bash
bash scripts/script.sh export --input proto/ --output prototype-bundle.html
```

## Output

- `create`: HTML file(s) in the output directory with inline CSS and JS
- `component`: HTML snippet file for the specified component
- `animate`: Updated HTML file with injected CSS keyframes and class
- `link`: Updated HTML file with onclick navigation wired
- `preview`: Summary printed to stdout (pages, components, links)
- `export`: Single HTML file with all pages, styles, and scripts inlined


## Requirements
- bash 4+

## Feedback

https://bytesagain.com/feedback/

---

Powered by BytesAgain | bytesagain.com
