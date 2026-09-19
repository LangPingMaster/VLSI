#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
cp ../data/gray.hex .
echo "[1] Technology mapping"
yosys -s synth_techmap.ys | tee ../reports/yosys_techmap.log
echo "[2] Mapped gate-level simulation"
iverilog -g2012 -o simv_mapped ../lib/teaching_cells.v ../results/binarization_mapped.v testbench_mapped.sv
vvp simv_mapped
python3 compare_mapped.py
echo "[3] Static timing analysis (if OpenSTA/sta exists)"
if command -v sta >/dev/null 2>&1; then sta sta.tcl | tee ../reports/sta_console.log; else echo "STA skipped: install OpenSTA and run: sta sta.tcl"; fi
