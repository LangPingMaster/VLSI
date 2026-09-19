#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
python prepare_image.py
cp ../data/gray.hex .
iverilog -g2012 -o simv design.sv testbench_image.sv
vvp simv
python rebuild_and_compare.py
