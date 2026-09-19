$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Copy-Item ..\data\gray.hex .\gray.hex -Force

if (Get-Command yosys -ErrorAction SilentlyContinue) {
    yosys -s synthesis.ys | Tee-Object -FilePath yosys_synthesis.log
} else {
    Write-Host "[INFO] Yosys not found; skipping automatic synthesis."
    Write-Host "[INFO] Gate-level verification will use binarization_gate_reference.v."
}

iverilog -g2012 -o simv_gate generic_cells.v binarization_gate_reference.v testbench_gate.sv
vvp simv_gate
python compare_gate.py
