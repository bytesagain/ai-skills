---
name: layout
description: "Generate CSS layouts. Use when building grid or flexbox layouts, creating responsive breakpoints, or scaffolding HTML pages."
version: "3.4.0"
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags:
  - layout
  - css
  - grid
  - flexbox
  - responsive
---

# Layout

Generate CSS Grid layouts, Flexbox containers, responsive breakpoint media queries, page scaffold HTML, and spacing utility classes — all from a single shell script. Analyze existing CSS files for layout property usage.

## Commands

### `grid`

Generate a CSS Grid layout with configurable columns, rows, gap, named areas, and custom templates.

**Options:**

| Flag | Default | Description |
|------|---------|-------------|
| `--columns` | `3` | Number of grid columns |
| `--rows` | `1` | Number of grid rows |
| `--gap` | `1rem` | Gap between grid items |
| `--col-template` | `repeat(N, 1fr)` | Custom `grid-template-columns` value |
| `--row-template` | *(auto)* | Custom `grid-template-rows` value |
| `--areas` | *(none)* | Named grid areas (pipe-separated rows) |
| `--class` | `grid-container` | CSS class name |
| `--output` | *(stdout)* | Write CSS to file |

```bash
bash scripts/script.sh grid --columns 4 --rows 2 --gap "2rem" --output grid.css
bash scripts/script.sh grid --areas "header header header|sidebar main main|footer footer footer" --output layout.css
```

### `flex`

Generate a Flexbox layout with direction, wrapping, alignment, and per-item grow factor.

**Options:**

| Flag | Default | Description |
|------|---------|-------------|
| `--direction` | `row` | Flex direction (`row`, `column`, etc.) |
| `--wrap` | *(flag)* | Enable `flex-wrap: wrap` |
| `--nowrap` | *(flag)* | Force `flex-wrap: nowrap` |
| `--justify` | `flex-start` | `justify-content` value |
| `--align` | `stretch` | `align-items` value |
| `--items` | `3` | Number of flex children to generate |
| `--grow` | `0` | `flex-grow` value for children |
| `--class` | `flex-container` | CSS class name |
| `--output` | *(stdout)* | Write CSS to file |

```bash
bash scripts/script.sh flex --direction row --wrap --justify space-between --items 5 --output flex.css
```

### `responsive`

Generate mobile-first (`min-width`) and desktop-first (`max-width`) media query breakpoints.

**Options:**

| Flag | Required | Description |
|------|----------|-------------|
| `--breakpoints` | Yes | Comma-separated `name:px` pairs |
| `--prefix` | No (default `screen-`) | Class name prefix |
| `--output` | No | Write CSS to file |

```bash
bash scripts/script.sh responsive --breakpoints "sm:640,md:768,lg:1024,xl:1280" --output breakpoints.css
```

### `scaffold`

Generate a complete HTML page skeleton with semantic sections. Supports four layout types:

- **basic** — header, nav, main, footer
- **holy-grail** — header, left sidebar, main, right sidebar, footer
- **dashboard** — header with logo/nav/user, sidebar navigation, card grid, data table
- **landing** — header with nav links, hero section with CTA, features grid, pricing cards, footer

**Options:**

| Flag | Default | Description |
|------|---------|-------------|
| `--type` | `basic` | Layout type (`basic`, `holy-grail`, `dashboard`, `landing`) |
| `--title` | `Page` | HTML `<title>` value |
| `--css` | *(none)* | Path to CSS file to link |
| `--output` | *(stdout)* | Write HTML to file |

```bash
bash scripts/script.sh scaffold --type dashboard --title "Admin Panel" --css styles.css --output dashboard.html
```

### `spacing`

Generate a spacing scale system with CSS custom properties and margin/padding utility classes.

**Options:**

| Flag | Default | Description |
|------|---------|-------------|
| `--base` | `4` | Base spacing unit |
| `--steps` | `8` | Number of scale steps |
| `--unit` | `px` | CSS unit (`px`, `rem`, etc.) |
| `--prefix` | `sp` | CSS variable prefix |
| `--output` | *(stdout)* | Write CSS to file |

```bash
bash scripts/script.sh spacing --base 8 --steps 10 --unit px --output spacing.css
```

### `analyze`

Analyze an existing CSS file and report layout property usage including display types, media queries, grid/flex properties, nesting depth, and file stats.

**Options:**

| Flag | Required | Description |
|------|----------|-------------|
| `--input` | Yes | Path to CSS file to analyze |

```bash
bash scripts/script.sh analyze --input styles.css
```

## Output

- **grid** — CSS file with `.grid-container` and numbered `__item-N` rules
- **flex** — CSS file with `.flex-container` and numbered `__item-N` rules
- **responsive** — CSS file with `min-width` and `max-width` media query blocks
- **scaffold** — Complete HTML5 document with semantic sections and optional CSS link
- **spacing** — CSS file with `:root` custom properties plus `.m-*`, `.mt-*`, `.p-*`, `.px-*` (etc.) utility classes
- **analyze** — Stdout report: rule block count, display type breakdown, media queries, grid/flex properties, nesting depth, file stats

## Data Storage

No persistent data. All output goes to stdout or to the file specified by `--output`. No data directory is created.

## Requirements

- Bash 4+
- Standard Unix utilities: `grep`, `wc`, `du`, `head`, `sort`
- No API keys, no external dependencies

## When to Use

1. **Bootstrapping a new web project** — generate grid and flex CSS foundations in seconds instead of writing boilerplate by hand
2. **Creating responsive breakpoints** — produce a consistent set of mobile-first and desktop-first media queries from named breakpoints
3. **Scaffolding HTML pages** — generate semantic page skeletons for dashboards, landing pages, holy-grail layouts, or basic sites
4. **Building a spacing system** — create a uniform spacing scale with margin/padding utility classes like Tailwind but custom-fit
5. **Auditing existing CSS** — analyze a stylesheet to understand its layout property usage, media queries, and nesting complexity

## Examples

```bash
# Generate a 12-column grid with named areas
bash scripts/script.sh grid --columns 12 --gap "1.5rem" \
  --areas "header header header header header header header header header header header header|sidebar sidebar main main main main main main main main main main|footer footer footer footer footer footer footer footer footer footer footer footer" \
  --output grid.css

# Create a centered flex navbar
bash scripts/script.sh flex --direction row --justify center --align center --items 6 --class navbar --output navbar.css

# Generate responsive breakpoints with custom prefix
bash scripts/script.sh responsive --breakpoints "xs:480,sm:640,md:768,lg:1024,xl:1280,xxl:1536" --prefix "bp-" --output breakpoints.css

# Scaffold a landing page with linked CSS
bash scripts/script.sh scaffold --type landing --title "Product Launch" --css main.css --output index.html

# Analyze an existing stylesheet
bash scripts/script.sh analyze --input existing-styles.css
```

## Tips

- Use `--output` to write directly to a file; omit it to pipe or preview on stdout
- Combine `grid` + `responsive` + `spacing` to scaffold a complete design system
- The `scaffold` command produces clean HTML5 — pair it with your generated CSS files
- Run `analyze` on legacy CSS before refactoring to understand what you're working with

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
