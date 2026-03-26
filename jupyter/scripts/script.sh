#!/bin/bash
# Jupyter - Interactive Computing Platform Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              JUPYTER REFERENCE                              ║
║          Interactive Computing Platform                     ║
╚══════════════════════════════════════════════════════════════╝

Jupyter is the standard interactive computing platform for
data science, ML, and scientific computing. Write code in
cells, see results inline, mix code with markdown.

JUPYTER ECOSYSTEM:
  Jupyter Notebook   Classic web-based notebook
  JupyterLab         Next-gen IDE-like interface
  JupyterHub         Multi-user server
  nbconvert          Convert notebooks to HTML/PDF/slides
  Voilà              Notebooks as dashboards
  Google Colab       Free hosted Jupyter (GPU included)

KEY CONCEPTS:
  Notebook (.ipynb)  JSON file with cells
  Kernel             Language runtime (Python, R, Julia)
  Cell               Code or Markdown block
  Output             Results rendered below cells

INSTALL:
  pip install jupyterlab           # Recommended
  pip install notebook             # Classic
  jupyter lab                      # Launch JupyterLab
  jupyter notebook                 # Launch classic
EOF
}

cmd_usage() {
cat << 'EOF'
KEYBOARD SHORTCUTS & MAGIC
=============================

MODES:
  Enter         Edit mode (green border, type in cell)
  Escape        Command mode (blue border, navigate)

COMMAND MODE SHORTCUTS:
  A             Insert cell above
  B             Insert cell below
  DD            Delete cell
  Z             Undo delete
  M             Convert to Markdown
  Y             Convert to code
  C / X / V     Copy / Cut / Paste cell
  Shift+Enter   Run cell, move to next
  Ctrl+Enter    Run cell, stay
  Alt+Enter     Run cell, insert below
  L             Toggle line numbers
  Shift+M       Merge cells
  1-6           Heading level (in Markdown)

MAGIC COMMANDS:
  %timeit       Time single statement
  %%timeit      Time entire cell
  %time         Time once (not averaged)
  %run script.py  Run Python script
  %load script.py  Load script into cell
  %who          List variables
  %whos         List variables with details
  %reset        Clear all variables
  %env          Show/set environment variables
  %pip install X  Install package from notebook
  %conda install X
  %matplotlib inline   Enable inline plots
  %autoreload 2  Auto-reload imported modules

  %%bash        Run cell as bash
  %%html        Render cell as HTML
  %%javascript  Run cell as JavaScript
  %%latex       Render cell as LaTeX
  %%sql         Run cell as SQL (needs ipython-sql)
  %%writefile f  Write cell contents to file

SHELL COMMANDS:
  !pip install pandas     Run shell command
  !ls -la                 List files
  files = !ls             Capture output
  !wget https://...       Download file

DISPLAY:
  from IPython.display import display, HTML, Image, Markdown, Audio
  display(HTML("<h1>Hello</h1>"))
  display(Image("plot.png", width=400))
  display(Markdown("**Bold text**"))

  # Rich DataFrame display
  df.style.highlight_max(color="lightgreen")
  df.style.bar(subset=["column"], color="#d65f5f")
  df.style.background_gradient(cmap="Blues")

  # Progress bar
  from tqdm.notebook import tqdm
  for i in tqdm(range(1000)):
      process(i)

INTERACTIVE WIDGETS:
  import ipywidgets as widgets
  from IPython.display import display

  slider = widgets.IntSlider(value=50, min=0, max=100)
  display(slider)

  @widgets.interact
  def f(x=(-10, 10, 0.1), color=["red", "blue"]):
      plt.plot(np.sin(np.linspace(0, x, 100)), color=color)
      plt.show()

  @widgets.interact_manual  # Adds "Run" button
  def expensive(n=(100, 10000)):
      result = heavy_computation(n)
      display(result)
EOF
}

cmd_config() {
cat << 'EOF'
CONFIGURATION & DEPLOYMENT
=============================

JUPYTERLAB EXTENSIONS:
  pip install jupyterlab-git          # Git integration
  pip install jupyterlab-lsp          # Language server
  pip install jupyterlab-vim          # Vim keybindings
  pip install jupyterlab-code-formatter  # Auto-format

JUPYTER CONFIG:
  jupyter notebook --generate-config
  # Edit ~/.jupyter/jupyter_notebook_config.py

  c.NotebookApp.ip = '0.0.0.0'
  c.NotebookApp.port = 8888
  c.NotebookApp.open_browser = False
  c.NotebookApp.password = 'hashed_password'
  c.NotebookApp.allow_origin = '*'

  # Generate password hash
  from jupyter_server.auth import passwd
  passwd()

JUPYTERHUB (multi-user):
  pip install jupyterhub
  jupyterhub --generate-config

  # config:
  c.JupyterHub.bind_url = 'http://0.0.0.0:8000'
  c.Authenticator.admin_users = {'admin'}
  c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'

NBCONVERT (export):
  jupyter nbconvert --to html notebook.ipynb
  jupyter nbconvert --to pdf notebook.ipynb
  jupyter nbconvert --to slides notebook.ipynb
  jupyter nbconvert --to markdown notebook.ipynb
  jupyter nbconvert --to script notebook.ipynb   # .py
  jupyter nbconvert --execute notebook.ipynb      # Run + convert

  # Slides
  jupyter nbconvert --to slides --post serve notebook.ipynb
  # Uses Reveal.js; set slide types in cell metadata

PAPERMILL (parameterized execution):
  pip install papermill
  papermill input.ipynb output.ipynb -p alpha 0.01 -p ratio 0.5
  # Tags cells with "parameters" to inject values
  # Great for scheduled reports and batch processing

VOILÀ (notebooks as dashboards):
  pip install voila
  voila notebook.ipynb
  # Hides code cells, shows only outputs + widgets
  # Perfect for sharing results with non-technical users

GOOGLE COLAB TIPS:
  from google.colab import drive
  drive.mount('/content/drive')        # Mount Google Drive

  from google.colab import files
  files.upload()                        # Upload from local
  files.download('output.csv')          # Download to local

  # GPU check
  !nvidia-smi
  import torch; print(torch.cuda.is_available())

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Jupyter - Interactive Computing Platform Reference

Commands:
  intro    Overview, ecosystem
  usage    Shortcuts, magic commands, widgets
  config   JupyterHub, nbconvert, Colab, deployment

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)  cmd_intro ;;
  usage)  cmd_usage ;;
  config) cmd_config ;;
  help|*) show_help ;;
esac
