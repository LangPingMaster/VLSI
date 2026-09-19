VSD HW1 - ModelSim-compatible submission package

A. ModelSim GUI
1) Open ModelSim.
2) File > Change Directory -> StudentID_HW1/Sim
3) ALU: do run_ALU_modelsim.do
4) FPU: do run_FPU_modelsim.do

B. Manual commands (inside Sim/)
ALU:
  vlib work
  vlog -sv ALU_tb.sv
  vsim tb_ALU
  run -all
FPU:
  vdel -lib work -all
  vlib work
  vlog -sv FPU_tb.sv
  vsim tb_fp32
  run -all

C. Official final check in SoC Lab
Use the course VCS commands and JasperGold Superlint before Moodle submission.
The supplied Superlint.tcl elaborates HW1_lint_top so ALU and FPU are both in the lint hierarchy.

D. IMPORTANT before submission
1) Rename folder StudentID_HW1 -> <your real StudentID>_HW1.
2) Add/rename the report to <your real StudentID>.pdf at the folder root.
3) Re-run ALU/FPU in the SoC Lab environment.
4) Run JasperGold Superlint and confirm the required coverage.
5) Create the official .tar required by the course.

Hidden-test defense (local verification only; remove these four files before final official submission if strict hierarchy is required):
  cd <...>/StudentID_HW1/Sim
  do run_ALU_hidden_defense.do
  do run_FPU_hidden_defense.do
Files: ALU_hidden_defense_tb.sv, FPU_hidden_defense_tb.sv, run_ALU_hidden_defense.do, run_FPU_hidden_defense.do
