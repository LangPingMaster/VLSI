$ErrorActionPreference="Stop"
Set-Location $PSScriptRoot
Copy-Item ..\data\gray.hex . -Force
Write-Host "[1] Technology mapping"
yosys -s synth_techmap.ys | Tee-Object -FilePath ..\reports\yosys_techmap.log
Write-Host "[2] Mapped gate-level simulation"
iverilog -g2012 -o simv_mapped ..\lib\teaching_cells.v ..\results\binarization_mapped.v testbench_mapped.sv
vvp simv_mapped
python compare_mapped.py
if (Get-Command sta -ErrorAction SilentlyContinue) { sta sta.tcl | Tee-Object -FilePath ..\reports\sta_console.log } else { Write-Host "STA skipped: install OpenSTA; then run: sta sta.tcl" }
