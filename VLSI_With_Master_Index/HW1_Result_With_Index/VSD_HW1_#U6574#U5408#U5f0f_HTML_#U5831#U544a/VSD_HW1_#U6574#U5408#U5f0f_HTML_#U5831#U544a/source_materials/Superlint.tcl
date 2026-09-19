clear -all
analyze -sv ../Src/ALU.sv ../Src/FPU.sv ../Src/HW1_lint_top.sv
elaborate -top HW1_lint_top
clock clk
reset rst
check_superlint -extract
