###############################################################################
# Created by write_sdc
###############################################################################
current_design binarization
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 2.1690 [get_ports {clk}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {pix_in[0]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {pix_in[1]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {pix_in[2]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {pix_in[3]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {pix_in[4]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {pix_in[5]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {pix_in[6]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {pix_in[7]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {rst_n}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {threshold[0]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {threshold[1]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {threshold[2]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {threshold[3]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {threshold[4]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {threshold[5]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {threshold[6]}]
set_input_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {threshold[7]}]
set_output_delay 2.0000 -clock [get_clocks {clk}] -add_delay [get_ports {pix_out}]
set_false_path\
    -from [get_ports {rst_n}]
###############################################################################
# Environment
###############################################################################
###############################################################################
# Design Rules
###############################################################################
