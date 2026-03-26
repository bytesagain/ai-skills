#!/bin/bash
# Papermill - Parameterized Notebook Execution Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              PAPERMILL REFERENCE                            ║
║          Parameterized Jupyter Notebook Execution           ║
╚══════════════════════════════════════════════════════════════╝

Papermill parameterizes, executes, and analyzes Jupyter notebooks.
Write a notebook once, run it with different parameters — perfect
for batch processing, scheduled reports, and ML experiments.

KEY FEATURES:
  Parameterize     Inject parameters into notebooks at runtime
  Execute          Run notebooks from CLI or Python
  Collect          Gather results across multiple runs
  Storage          Read/write from local, S3, GCS, Azure
  Retry            Automatic retry on failure
  Record           Track execution metadata

WORKFLOW:
  1. Write notebook with a "parameters" cell
  2. Run: papermill input.ipynb output.ipynb -p param1 value1
  3. Output notebook has injected parameters + all cell outputs
  4. Analyze results or convert with nbconvert

INSTALL:
  pip install papermill
EOF
}

cmd_usage() {
cat << 'EOF'
CLI USAGE
===========

BASIC:
  papermill input.ipynb output.ipynb -p alpha 0.01 -p l1_ratio 0.5
  # Finds the "parameters" cell and injects alpha=0.01, l1_ratio=0.5

  # YAML parameters file
  papermill input.ipynb output.ipynb -f params.yaml

  # params.yaml
  alpha: 0.01
  l1_ratio: 0.5
  features:
    - age
    - income
    - score

PARAMETER CELL:
  # In your notebook, tag one cell as "parameters"
  # (Cell → Tags → add "parameters")
  
  # Default values in the parameters cell:
  alpha = 0.01
  l1_ratio = 0.5
  data_path = "data/train.csv"
  output_dir = "results/"
  n_estimators = 100
  random_state = 42

  # Papermill creates a new "injected-parameters" cell
  # below it with your runtime values

MULTIPLE RUNS:
  # Batch experiments
  for alpha in 0.001 0.01 0.1 1.0; do
    papermill train.ipynb "output/train_alpha_${alpha}.ipynb" \
      -p alpha $alpha \
      -p experiment_name "alpha_sweep"
  done

  # Parallel with GNU parallel
  parallel papermill train.ipynb "output/{}.ipynb" \
    -p dataset {} ::: dataset_a dataset_b dataset_c

  # Different date ranges
  for date in 2026-01 2026-02 2026-03; do
    papermill report.ipynb "reports/report_${date}.ipynb" \
      -p month "$date" \
      -p output_format "html"
  done

CLOUD STORAGE:
  # S3
  papermill s3://bucket/input.ipynb s3://bucket/output.ipynb -p x 1

  # GCS
  papermill gs://bucket/input.ipynb gs://bucket/output.ipynb

  # Azure
  papermill adl://store/input.ipynb adl://store/output.ipynb

  # HTTP
  papermill https://example.com/notebook.ipynb output.ipynb

OPTIONS:
  --kernel python3                    # Specify kernel
  --cwd /path/to/dir                  # Working directory
  --no-progress-bar                   # Quiet mode
  --start_timeout 120                 # Kernel start timeout
  --execution_timeout 3600            # Cell execution timeout
  --log-output                        # Show cell outputs in CLI
  --report-mode                       # Hide inputs in output notebook
  --prepare-only                      # Inject params but don't execute
EOF
}

cmd_python() {
cat << 'EOF'
PYTHON API & AUTOMATION
=========================

BASIC EXECUTION:
  import papermill as pm

  pm.execute_notebook(
      'input.ipynb',
      'output.ipynb',
      parameters=dict(
          alpha=0.01,
          data_path='data/train.csv',
          n_estimators=200,
      )
  )

BATCH EXPERIMENTS:
  import papermill as pm
  from itertools import product

  alphas = [0.001, 0.01, 0.1]
  ratios = [0.25, 0.5, 0.75]

  for alpha, ratio in product(alphas, ratios):
      pm.execute_notebook(
          'train.ipynb',
          f'output/train_a{alpha}_r{ratio}.ipynb',
          parameters={'alpha': alpha, 'l1_ratio': ratio}
      )

INSPECT RESULTS:
  import scrapbook as sb

  # In the notebook, record results:
  import scrapbook as sb
  sb.glue("accuracy", 0.95)
  sb.glue("confusion_matrix", cm, display=True)
  sb.glue("model_params", {"alpha": alpha, "l1_ratio": l1_ratio})

  # After execution, read results:
  nb = sb.read_notebook('output.ipynb')
  print(nb.scraps['accuracy'].data)      # 0.95
  print(nb.scraps['model_params'].data)  # {"alpha": 0.01, ...}

  # Compare across notebooks
  book = sb.read_notebooks('output/')
  book.scraps_report()
  df = book.scraps.dataframe  # All results as DataFrame

PIPELINE + NBCONVERT:
  import papermill as pm
  import subprocess

  # 1. Execute with parameters
  pm.execute_notebook('report.ipynb', 'report_output.ipynb',
                      parameters={'month': '2026-03'})

  # 2. Convert to HTML
  subprocess.run([
      'jupyter', 'nbconvert', '--to', 'html',
      '--no-input', '--output', 'report_march.html',
      'report_output.ipynb'
  ])

  # 3. Email or upload
  upload_to_s3('report_march.html')

SCHEDULING:
  # Cron
  0 9 * * 1 papermill /reports/weekly.ipynb \
    /reports/output/weekly_$(date +\%Y\%m\%d).ipynb \
    -p week_start $(date -d "last monday" +\%Y-\%m-\%d)

  # Airflow
  PapermillOperator(
      task_id='run_report',
      input_nb='/notebooks/report.ipynb',
      output_nb='/output/report_{{ ds }}.ipynb',
      parameters={'date': '{{ ds }}'},
  )

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Papermill - Parameterized Notebook Execution Reference

Commands:
  intro    Overview, workflow
  usage    CLI, batch runs, cloud storage
  python   Python API, scrapbook, scheduling

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)  cmd_intro ;;
  usage)  cmd_usage ;;
  python) cmd_python ;;
  help|*) show_help ;;
esac
