create_clock -period 25.000 -name clk -waveform {0.000 12.500} [get_ports clk]
set_input_delay -clock [get_clocks clk] -min -add_delay 2.000 [get_ports rst]
set_input_delay -clock [get_clocks clk] -max -add_delay 2.000 [get_ports rst]
set_output_delay -clock [get_clocks clk] -min -add_delay 0.000 [get_ports {stall[*]}]
set_output_delay -clock [get_clocks clk] -max -add_delay 2.000 [get_ports {stall[*]}]
