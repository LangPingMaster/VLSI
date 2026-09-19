transcript on
if {[file exists work]} { vdel -lib work -all }
vlib work
vmap work work
vlog -sv FPU_hidden_defense_tb.sv
vsim tb_FPU_hidden_defense
run -all
