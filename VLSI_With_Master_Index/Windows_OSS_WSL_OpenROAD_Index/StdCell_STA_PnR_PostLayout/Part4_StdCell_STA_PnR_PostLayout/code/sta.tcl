read_liberty ../lib/teaching.lib
read_verilog ../results/binarization_mapped.v
link_design binarization
read_sdc constraints.sdc
report_checks -path_delay max -digits 3 > ../reports/sta_max.rpt
report_checks -path_delay min -digits 3 > ../reports/sta_min.rpt
report_clock_min_period > ../reports/min_period.rpt
report_tns > ../reports/tns.rpt
report_wns > ../reports/wns.rpt
