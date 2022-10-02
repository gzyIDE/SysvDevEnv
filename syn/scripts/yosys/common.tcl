yosys -import
yosys plugin -i systemverilog

source setup.tcl
source ${SCR_DIR}/yosys/${DESIGN}.tcl

set inc_list {}
foreach inc ${incdir} {
	yosys read -incdir ${inc}
	lappend inc_list "-I${inc}"
}
foreach fi ${v_src} {
	yosys read -sv ${fi}
}
foreach fi ${sv_src} {
	yosys read_systemverilog ${inc_list} ${fi}
}

hierarchy -top ${DESIGN}

# convert high-level behavioral parts  to d-type flip-flops and muxes
procs; 
opt;

# convert high-level memory constructs to d-type flip-flops and multiplexers
memory;
opt

# convert design to (logical) gate-level netlists
techmap;
opt

dfflibmap -liberty ref.lib
abc -liberty ref.lib
stat -liberty ref.lib

write_verilog ${RESULT_DIR}/${DESIGN}_net.v
