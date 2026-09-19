transcript on
if {[file exists work]} {vdel -lib work -all}
vlib work
vlog -sv FPU_tb.sv
vsim tb_fp32
run -all
