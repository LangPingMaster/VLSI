$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host "[1/4] Prepare image data..."
python .\prepare_image.py

Write-Host "[2/4] Compile Verilog..."
iverilog -g2012 -o simv .\design.sv .\testbench_image.sv

Write-Host "[3/4] Run 65,536-pixel RTL simulation..."
vvp .\simv

Write-Host "[4/4] Rebuild image and compare with Golden Model..."
python .\rebuild_and_compare.py
