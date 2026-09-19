transcript on
if {[file exists work]} {vdel -lib work -all}
vlib work
vlog -sv ALU_tb.sv
vsim tb_ALU
run -all
