# Initialize design configuration
set curdir [exec pwd]
set tcldir ${curdir}/xilinx
source ${tcldir}/top.tcl
source ${tcldir}/${TOP}/files.tcl
source ${tcldir}/${TOP}/defines.tcl
source ${tcldir}/${TOP}/dpi.tcl
set TEST_MODULE ${TOP}_test

# Configure project for simulations
if {[open_project -quiet ./xilinx/${TOP}/${TOP}.xpr] == {}} {
	create_project -force ${TOP} ./xilinx/${TOP}
}
if {[string equal [get_filesets -quiet sources_1] ""]} {
    create_fileset -srcset sources_1
}
add_files -fileset sources_1 -scan_for_includes ${INCLUDE_DIRS} ${DESIGN_FILES}

if {[string equal [get_filesets -quiet sim_1] ""]} {
    create_fileset -simset sim_1
}
add_files -fileset sim_1 -scan_for_includes ${INCLUDE_DIRS} ${TEST_FILES}

# set top module
set_property top ${TEST_MODULE} [get_filesets -quiet sim_1]

# set verilog defines
set_property verilog_define ${DEFINE_LISTS} [get_filesets sim_1]

# set simulation configuration
set_property -name {xsim.simulate.runtime} -value {1000us} -objects [get_filesets sim_1]
#set_property -name {xsim.elaborate.mt_level} -value {8} -objects [get_filesets sim_1]
if { $WAVEFORM == 1 } {
	set_property -name {xsim.elaborate.debug_level} -value {all} -objects [get_filesets sim_1]
	set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]

  set elabopt {--debug all}
  set elabopt {--sv_root "/"}
  foreach lib ${DPI_LISTS} {
    lappend elabopt "--sv_lib ${lib}"
  }
	set_property -name xelab.more_options -value [concat {*}${elabopt}] -objects [get_filesets sim_1]
} else {
	set_property -name {xsim.elaborate.debug_level} -value {none} -objects [get_filesets sim_1]
}

# simulation
launch_simulation

close_project
