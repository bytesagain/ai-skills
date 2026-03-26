#!/bin/bash
# nbconvert - Jupyter Notebook Conversion Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              NBCONVERT REFERENCE                            ║
║          Convert Jupyter Notebooks to Any Format            ║
╚══════════════════════════════════════════════════════════════╝

nbconvert converts Jupyter notebooks (.ipynb) to HTML, PDF,
Markdown, LaTeX, slides, scripts, and more. Essential for
sharing results, generating reports, and CI/CD pipelines.

OUTPUT FORMATS:
  html         Static HTML page
  pdf          PDF via LaTeX
  latex        LaTeX source
  slides       Reveal.js presentation
  markdown     Markdown
  rst          reStructuredText
  script       Python/R/Julia script (.py)
  notebook     Cleaned notebook (.ipynb)
  asciidoc     AsciiDoc

INSTALL:
  pip install nbconvert
  # For PDF: also install LaTeX
  # Ubuntu: sudo apt install texlive-xetex texlive-fonts-recommended
  # macOS: brew install --cask mactex-no-gui
EOF
}

cmd_convert() {
cat << 'EOF'
CONVERSION COMMANDS
=====================

BASIC:
  jupyter nbconvert --to html notebook.ipynb
  jupyter nbconvert --to pdf notebook.ipynb
  jupyter nbconvert --to markdown notebook.ipynb
  jupyter nbconvert --to script notebook.ipynb
  jupyter nbconvert --to latex notebook.ipynb
  jupyter nbconvert --to slides notebook.ipynb

EXECUTE + CONVERT (run then export):
  jupyter nbconvert --to html --execute notebook.ipynb
  jupyter nbconvert --to pdf --execute notebook.ipynb
  # Runs all cells, then converts output
  # Great for automated reports!

  # With timeout
  jupyter nbconvert --execute --ExecutePreprocessor.timeout=600 \
    --to html notebook.ipynb

  # Allow errors (continue on cell failure)
  jupyter nbconvert --execute --allow-errors --to html notebook.ipynb

BATCH:
  jupyter nbconvert --to html *.ipynb
  jupyter nbconvert --to html notebooks/*.ipynb --output-dir=output/

OUTPUT OPTIONS:
  --output report              # Custom output filename
  --output-dir ./output        # Output directory
  --no-input                   # Hide code cells (show only output)
  --no-prompt                  # Remove In[]/Out[] prompts
  --template lab               # Use JupyterLab template
  --template classic           # Classic notebook template

SLIDES:
  jupyter nbconvert --to slides notebook.ipynb
  jupyter nbconvert --to slides --post serve notebook.ipynb
  # Serves locally using Reveal.js

  # Set slide types in cell metadata:
  # Slide       = new slide (→)
  # Sub-Slide   = new sub-slide (↓)
  # Fragment    = appear on click
  # Skip        = hidden
  # Notes       = speaker notes

HTML OPTIONS:
  # Embed images inline (single file)
  jupyter nbconvert --to html --HTMLExporter.embed_images=True notebook.ipynb

  # Custom CSS
  jupyter nbconvert --to html --template-file custom.tpl notebook.ipynb

  # Dark theme
  jupyter nbconvert --to html --theme dark notebook.ipynb
EOF
}

cmd_automation() {
cat << 'EOF'
AUTOMATION & CUSTOM TEMPLATES
================================

PYTHON API:
  import nbformat
  from nbconvert import HTMLExporter, PDFExporter
  from nbconvert.preprocessors import ExecutePreprocessor

  # Load notebook
  with open('notebook.ipynb') as f:
      nb = nbformat.read(f, as_version=4)

  # Execute
  ep = ExecutePreprocessor(timeout=600, kernel_name='python3')
  ep.preprocess(nb)

  # Convert to HTML
  exporter = HTMLExporter()
  exporter.exclude_input = True  # Hide code
  (html_body, resources) = exporter.from_notebook_node(nb)

  with open('report.html', 'w') as f:
      f.write(html_body)

  # Convert to PDF
  pdf_exporter = PDFExporter()
  (pdf_body, resources) = pdf_exporter.from_notebook_node(nb)
  with open('report.pdf', 'wb') as f:
      f.write(pdf_body)

PREPROCESSORS:
  # Tag-based cell removal
  jupyter nbconvert --to html \
    --TagRemovePreprocessor.enabled=True \
    --TagRemovePreprocessor.remove_cell_tags='["remove"]' \
    notebook.ipynb
  # Tag cells with "remove" in metadata to hide them

  # Remove cells by content
  --RegexRemovePreprocessor.patterns='["^#\\s*DEBUG"]'

CI/CD (automated reports):
  # GitHub Actions
  - name: Generate report
    run: |
      pip install jupyter nbconvert
      jupyter nbconvert --execute --to html \
        --no-input --output report.html \
        analysis.ipynb

  # Scheduled reports
  0 9 * * 1 jupyter nbconvert --execute --to html \
    --output /var/www/reports/weekly.html weekly.ipynb

  # Email report
  jupyter nbconvert --execute --to html report.ipynb
  mutt -e "set content_type=text/html" -s "Weekly Report" \
    team@company.com < report.html

CUSTOM TEMPLATE:
  # Create templates/mytemplate/index.html.j2
  {%- extends 'lab/index.html.j2' -%}
  {%- block header -%}
  <style>
    .jp-Notebook { max-width: 800px; margin: 0 auto; }
    body { font-family: 'Inter', sans-serif; }
  </style>
  {{ super() }}
  {%- endblock -%}

  # Use it
  jupyter nbconvert --to html --template mytemplate notebook.ipynb

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
nbconvert - Jupyter Notebook Conversion Reference

Commands:
  intro       Overview, output formats
  convert     CLI commands, slides, HTML options
  automation  Python API, CI/CD, templates

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  convert)    cmd_convert ;;
  automation) cmd_automation ;;
  help|*)     show_help ;;
esac
