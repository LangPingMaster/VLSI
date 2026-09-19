#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

cp ../data/gray.hex .

# Optional: generate a Yosys netlist/report when Yosys is installed.
if command -v yosys >/dev/null 2>&1; then
  yosys -s synthesis.ys | tee yosys_synthesis.log
else
  echo "[INFO] Yosys not found; skipping automatic synthesis."
  echo "[INFO] Gate-level verification will use binarization_gate_reference.v."
fi

iverilog -g2012 -o simv_gate       generic_cells.v       binarization_gate_reference.v       testbench_gate.sv

vvp simv_gate
python compare_gate.py
