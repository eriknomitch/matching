#!/bin/bash

echo "Sesion:"
whoami
pwd
echo

echo "Installing requirements..."
pip install --requirement requirements.txt > /dev/null
echo

echo "Converting..."
jupyter nbconvert --to python /storage/match_2p0/main.ipynb
cp /storage/match_2p0/main.py .

echo "Starting..."
source /paperspace/experiment_env

echo "RUN_NUM (run.sh): $RUN_NUM"

python3.7 main.py
