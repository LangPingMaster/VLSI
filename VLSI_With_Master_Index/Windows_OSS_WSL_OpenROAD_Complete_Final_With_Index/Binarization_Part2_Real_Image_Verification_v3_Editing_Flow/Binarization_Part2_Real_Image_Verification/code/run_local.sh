#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
python prepare_image.py
iverilog -g2012 -o simv design.sv testbench_image.sv
vvp simv
python rebuild_and_compare.py
