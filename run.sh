#!/bin/bash

# ------------------------------------------------
# UTILITY ----------------------------------------
# ------------------------------------------------
function _info() {
    echo "Starting: Type: $1"
    echo "--------------------------------------------------"
    env
    echo "--------------------------------------------------"
    echo
    echo
}

function _create_initial_artifacts() {
  echo $1 > $PS_ARTIFACTS/type
  env > $PS_ARTIFACTS/env
}

function _checkpoint() {
  echo "----> $1"
}

function _run_main() {

  if [[ -z $NAME ]] ; then
    echo "fatal: NAME not set."
    exit 1
  fi

  _base_dir="/storage/match_2p0"
  _job_dir="$_base_dir/$NAME"
  _main_filename="main_job"

  mkdir $_job_dir

  if [[ ! -d $_job_dir ]] ; then
    echo "fatal: Could not make $_job_dir"
    exit 1
  fi

  _checkpoint "Copying files to $_job_dir"
  # ----------------------------------------------
  cd $_job_dir
  pwd

  cp -v $_base_dir/*.ipynb $_job_dir
  cp -v $_base_dir/requirements.txt $_job_dir

  echo

  _checkpoint "Installing Python requirements..."
  # ----------------------------------------------
  pip install --upgrade --requirement requirements.txt > /dev/null
  echo

  _checkpoint "Converting main..."
  # ----------------------------------------------
  jupyter nbconvert --to python $_main_filename.ipynb
  echo

  _checkpoint "Running $_main_filename.py..."
  # ----------------------------------------------
  echo "python3.7 $_main_filename.py"
  # python3.7 $_main_filename.py
}

# ------------------------------------------------
# MAIN -------------------------------------------
# ------------------------------------------------
case $1 in
  "job")
    _info $1
    _run_main $1
    ;;
  "experiment:multinode:worker")
    _info $1
    _run_main $1
    ;;
  "experiment:multinode:parameterServer")
    _info $1
    # FIX:
    ;;
  "experiment:singlenode")
    _info $1
    _run_main $1
    ;;
  *)
    echo "fatal: Invalid run type supplied."
    exit 1
    ;;
esac

