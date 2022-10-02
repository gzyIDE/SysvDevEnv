# clk constraints
set CLK_CYC			4.0
set IN_DELAY_RATIO	0.10
set OUT_DELAY_RATIO	0.2

########## clk constraints ##########
create_clock \
	[get_ports clk] \
	-name CPU_CLK \
	-period ${CLK_CYC} \
	-waveform [list 0.000 [expr $CLK_CYC/2.0]]

set inputs [remove_from_collection [all_inputs] [get_ports "clk"]]
set_input_delay [expr $IN_DELAY_RATIO * $CLK_CYC] -clock CPU_CLK $inputs

set outputs [all_outputs]
set_output_delay [expr $OUT_DELAY_RATIO * $CLK_CYC] -clock CPU_CLK $outputs

########## reset configuration ##########
if {[info exists DESIGN_NO_CLK] {
	if { $DESIGN_NO_CLK == 1 } {
		set_max_delay $CLK_CYC -from [all_inputs] -to [all_outputs]
	}
}
