#!/bin/bash
# Conda - Package & Environment Manager Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              CONDA REFERENCE                                ║
║          Package, Dependency, and Environment Manager       ║
╚══════════════════════════════════════════════════════════════╝

Conda is a cross-platform package and environment manager.
Unlike pip, it manages non-Python dependencies too (C libraries,
CUDA, R, etc.).

DISTRIBUTIONS:
  Anaconda       Full distribution (~3GB, 250+ packages)
  Miniconda      Minimal (conda + Python, ~50MB)
  Miniforge      Community-driven, conda-forge default
  Mambaforge     Miniforge + Mamba (fast solver)

CONDA vs PIP:
  ┌──────────────┬──────────┬──────────┐
  │ Feature      │ Conda    │ pip      │
  ├──────────────┼──────────┼──────────┤
  │ Languages    │ Any      │ Python   │
  │ Dependencies │ All deps │ Python   │
  │ C/C++ libs   │ Yes      │ No       │
  │ CUDA         │ Yes      │ Limited  │
  │ Environments │ Built-in │ venv     │
  │ Channels     │ Multiple │ PyPI     │
  │ Solver       │ SAT      │ PIP      │
  │ Speed        │ Slow*    │ Fast     │
  └──────────────┴──────────┴──────────┘
  * Use Mamba for 10-100x faster solving

INSTALL MINICONDA:
  # Linux
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  bash Miniconda3-latest-Linux-x86_64.sh

  # macOS
  brew install --cask miniconda

  # Or Miniforge (recommended)
  curl -L -O https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh
  bash Miniforge3-$(uname)-$(uname -m).sh
EOF
}

cmd_environments() {
cat << 'EOF'
ENVIRONMENTS
==============

CREATE:
  conda create -n myenv python=3.12
  conda create -n ml python=3.11 numpy pandas scikit-learn
  conda create -n myenv python=3.11 --channel conda-forge

  # From environment.yml
  conda env create -f environment.yml

  # Clone existing
  conda create -n newenv --clone oldenv

ACTIVATE/DEACTIVATE:
  conda activate myenv
  conda deactivate

  # Auto-activate on shell start
  conda config --set auto_activate_base false  # Don't auto-activate base

LIST ENVIRONMENTS:
  conda env list
  conda info --envs

REMOVE:
  conda env remove -n myenv
  conda remove -n myenv --all

EXPORT:
  # Full (platform-specific)
  conda env export > environment.yml

  # Cross-platform (no builds)
  conda env export --no-builds > environment.yml

  # Only explicitly installed
  conda env export --from-history > environment.yml

ENVIRONMENT.YML:
  name: ml-project
  channels:
    - conda-forge
    - defaults
  dependencies:
    - python=3.11
    - numpy=1.26
    - pandas>=2.0
    - scikit-learn
    - matplotlib
    - jupyter
    - pip:
      - transformers
      - wandb

  # Install: conda env create -f environment.yml
  # Update:  conda env update -f environment.yml --prune

ENVIRONMENT VARIABLES:
  conda activate myenv
  conda env config vars set MY_VAR=value
  conda env config vars list
  conda env config vars unset MY_VAR
  # Variables auto-set on activate, unset on deactivate
EOF
}

cmd_packages() {
cat << 'EOF'
PACKAGE MANAGEMENT
====================

INSTALL:
  conda install numpy
  conda install numpy=1.26.4           # Exact version
  conda install "numpy>=1.26"          # Minimum version
  conda install numpy pandas matplotlib # Multiple
  conda install -c conda-forge package  # Specific channel
  conda install --file requirements.txt # From file

REMOVE:
  conda remove numpy
  conda remove numpy pandas             # Multiple

UPDATE:
  conda update numpy
  conda update --all                    # Update everything
  conda update conda                   # Update conda itself
  conda update -n base conda           # Update base conda

SEARCH:
  conda search numpy
  conda search "numpy>=1.26"
  conda search -c conda-forge package

LIST:
  conda list                           # All packages
  conda list numpy                     # Specific package
  conda list --export > packages.txt   # Export list
  conda list --revisions               # History

CHANNELS:
  # Add channel
  conda config --add channels conda-forge
  conda config --set channel_priority strict  # Recommended

  # Priority order (first = highest)
  conda config --show channels

  Popular channels:
    defaults       Anaconda official
    conda-forge    Community-maintained (largest)
    nvidia         CUDA/GPU packages
    bioconda       Bioinformatics
    pytorch        PyTorch official

USING PIP INSIDE CONDA:
  # Best practice: install conda packages first, then pip
  conda install numpy pandas
  pip install some-pip-only-package

  # Don't mix pip and conda for the same package!
  # pip packages not tracked by conda solver

MAMBA (fast alternative):
  conda install -n base -c conda-forge mamba
  # Then use mamba instead of conda:
  mamba install numpy
  mamba create -n ml python=3.11 pytorch
  mamba env create -f environment.yml
  # Same syntax, 10-100x faster solving
EOF
}

cmd_advanced() {
cat << 'EOF'
ADVANCED USAGE
================

GPU/CUDA:
  # PyTorch with CUDA
  conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia

  # TensorFlow with GPU
  conda install tensorflow-gpu

  # CUDA toolkit
  conda install -c nvidia cuda-toolkit=12.1

  # Check CUDA
  python -c "import torch; print(torch.cuda.is_available())"

CONFIGURATION:
  ~/.condarc

  channels:
    - conda-forge
    - defaults
  channel_priority: strict
  auto_activate_base: false
  ssl_verify: true
  show_channel_urls: true
  default_threads: 4

  # Useful settings
  conda config --set channel_priority strict    # Prevent mixing
  conda config --set auto_activate_base false   # Clean shell
  conda config --set show_channel_urls true     # Show where packages come from

CLEANUP:
  conda clean --all                  # Remove caches, tarballs, unused packages
  conda clean --tarballs             # Remove downloaded .tar.bz2
  conda clean --packages             # Remove unused packages

CONDA-LOCK (reproducible):
  pip install conda-lock
  conda-lock -f environment.yml      # Generate lockfile
  conda-lock install conda-lock.yml  # Install from lock

TROUBLESHOOTING:
  # Solver conflict
  conda install package --strict-channel-priority
  # Or try mamba (better solver)

  # Broken environment
  conda list --revisions
  conda install --revision 2         # Rollback

  # Reset base
  conda install --revision 0

  # Package not found
  conda search -c conda-forge package  # Try conda-forge
  pip install package                  # Fallback to pip

  # Slow solving
  conda install -n base mamba         # Switch to mamba
  conda config --set channel_priority strict

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Conda - Package & Environment Manager Reference

Commands:
  intro         Overview, distributions, comparison
  environments  Create, activate, export, environment.yml
  packages      Install, channels, Mamba, pip integration
  advanced      GPU/CUDA, config, cleanup, troubleshooting

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)        cmd_intro ;;
  environments) cmd_environments ;;
  packages)     cmd_packages ;;
  advanced)     cmd_advanced ;;
  help|*)       show_help ;;
esac
