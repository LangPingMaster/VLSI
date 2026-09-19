# Part 4 P&R template. A real P&R run needs a PDK-specific technology LEF + standard-cell LEF.
# Replace the two placeholders below with files licensed/provided by your course/PDK.
set tech_lef  "../lib/TECH.lef"
set cells_lef "../lib/CELLS.lef"
read_lef $tech_lef
read_lef $cells_lef
read_liberty ../lib/teaching.lib
read_verilog ../results/binarization_mapped.v
link_design binarization
read_sdc constraints.sdc
initialize_floorplan -die_area "0 0 100 100" -core_area "10 10 90 90" -site core
place_pins -hor_layers metal2 -ver_layers metal3
global_placement
detailed_placement
estimate_parasitics -placement
report_checks -path_delay max > ../reports/post_place_sta.rpt
global_route
detailed_route
write_def ../results/binarization_routed.def
write_verilog ../results/binarization_postroute.v
write_sdc ../results/binarization_postroute.sdc
