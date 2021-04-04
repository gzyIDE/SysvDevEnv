# Number of CPU Cores for compilation
set MAX_CORE	4

# Transistor Process selection
set PROCESS "ASAP7"
#set PROCESS "SKY130"

# toolchain setting
set synopsys_tools [info exist synopsys_program_name]
if { $synopsys_tools == 1 } {
	set USE_DB 1
} else {
	set USE_DB 0
}

# Process depending environment settings
if { $PROCESS == "ASAP7" } {
	# ASAP7 PDK
	#	url: 
	#		http://asap.asu.edu/asap/
	#	publication:
	#		L.T. Clark, V. Vashishtha, L. Shifren, A. Gujja, S. Sinha, 
	#		B. Cline, C. Ramamurthya, and G. Yeric, 
	#		“ASAP7: A 7-nm FinFET Predictive Process Design Kit,” 
	#		Microelectronics Journal, vol. 53, pp. 105-115, July 2016
	set CELLLIB "./ASAP7_PDKandLIB_v1p6/lib_release_191006"
	if { $USE_DB == 1 } {
		set CELLDIR "${CELLLIB}/asap7_7p5t_library/rev25/DB/NLDM"
	} else {
		set CELLDIR "${CELLLIB}/asap7_7p5t_library/rev25/LIB/NLDM"
	}

	# set target library cells
	set CORNERS [list \
		FF_08302018 \
		SS_08302018 \
		TT_08302018 \
	]

	# name of libraries (except corner)
	#    (In this example, only regular VT cells are used)
	set TARGET_CELL_NAME [list]
	set TARGET_CELL_NAME [list \
		${CELLDIR}/asap7sc7p5t_SIMPLE_RVT \
		${CELLDIR}/asap7sc7p5t_SEQ_RVT \
		${CELLDIR}/asap7sc7p5t_OA_RVT \
		${CELLDIR}/asap7sc7p5t_INVBUF_RVT \
		${CELLDIR}/asap7sc7p5t_AO_RVT \
	]
} elseif { $PROCESS == "SKY130" } {
	# SkyWater Open Source PDK
	#	github:
	#		https://github.com/google/skywater-pdk
	#	url:
	#		https://skywater-pdk.readthedocs.io/en/latest/
	set CELLLIB ""
	set CELLDIR ""
	set CORNERS [list]
	set TARGET_CELL_NAME [list]
} else {
	echo "Select Some Process for Synthesis"
	exit
}



##### Cell library settings
# cell libraries
set target_cell [list]
foreach cell_name $TARGET_CELL_NAME {
	foreach corner $CORNERS {
		lappend target_cell ${cell_name}_${corner}
	}
}

# hard ip libraries
set hard_ip [list]
if { [info exist HARDIP] } {
	foreach ip $HARDIP {
		foreach corner $CORNERS {
			lappend hard_ip ${ip}_${corner}
		}
	}
}

# library format
if { $USE_DB == 1 } {
	### add library extention
	set target_library [list]
	foreach lib_each [concat $target_cell $hard_ip] {
		lappend target_library  ${lib_each}.db
	}
} else {
	# add library extention
	set target_library [list]
	foreach lib_each [concat $target_cell $hard_ip] {
		lappend target_library  ${lib_each}.lib
	}
}



##### Tool dependent scripts
if { [info exist synopsys_program_name] } {
	##### Synopsys Tool chain (Design Compiler, Formality)
	#### processor count
	set_host_option -max_cores ${MAX_CORE}

	### search path setting
	set_app_var search_path [concat $search_path ${DBDIR}]

	if { $synopsys_program_name == "dc_shell" } {
		### Design Compiler
		# verification file setting
		set_svf ${RESULTDIR}/${DESIGN}/${DESIGN}.mapped.svf

		# library for synthesis
		set DW_LIB ${synopsys_root}/libraries/syn/dw_foundation.sldb
		set_app_var synthetic_library ${DW_LIB}
		set_app_var link_library [concat $target_library $DW_LIB]

		# read verilog file
		if { [info exist FILE_LIST] } {
			analyze -format verilog ${FILE_LIST}
		}
		if { [info exist SV_FILE_LIST] } {
			analyze -format sverilog ${SV_FILE_LIST}
		}
		elaborate ${DESIGN}

		# dont touch constraints
		if { [info exist DONT_TOUCH_CELL] } {
			foreach cell ${DONT_TOUCH_CELL} {
				set_dont_touch [get_cells -hierarchical $cell]
			}
		}
		#set_dont_touch ${DONT_TOUCH_CELLS}

		# synthesis option and compile
		source -echo -verbose ${TCLDIR}/clk_const.tcl
		check_design > ${REPORTDIR}/${DESIGN}/check_design.rpt
		compile_ultra

		# reports
		report_area -nosplit > ${REPORTDIR}/${DESIGN}/report_area.rpt
		report_power -nosplit > ${REPORTDIR}/${DESIGN}/report_power.rpt
		report_timing -nosplit > ${REPORTDIR}/${DESIGN}/report_timing.rpt

		# output result
		write -hierarchy -format ddc -output ${RESULTDIR}/${DESIGN}/${DESIGN}.ddc
		write -hierarchy -format verilog -output ${RESULTDIR}/${DESIGN}/${DESIGN}.mapped.v
		if { [info exists SV_FILE_LIST] } {
			# if source contains systemverilog files, output systemverilog netlist wrapper
			write -hierarchy -format svsim -output ${RESULTDIR}/${DESIGN}/${DESIGN}_svsim.sv
		}
	} elseif { $synopsys_program_name == "fm_shell" } {
		### Formality
		# library for formal verification
		# Setting Design Compiler Directory
		regexp {(.*)(bin/dc_shell)} [exec which dc_shell] -> dc_shell_path
		set_app_var hdlin_dwroot $dc_shell_path
		read_db -technology_library ${target_library}

		# load reference
		if { [info exist FILE_LIST] } {
			read_verilog -r ${FILE_LIST} -work_library WORK
		}
		if { [info exist SV_FILE_LIST] } {
			read_sverilog -r ${SV_FILE_LIST} -work_library WORK
		}
		set_top r:/WORK/${DESIGN}

		# load implementation
		read_ddc -i ${RESULTDIR}/${DESIGN}/${DESIGN}.ddc
		set_top i:/WORK/${DESIGN}

		# matching reference and implementation
		match

		# output result
		if { ![verify] } {  
			report_unmatched_points > ${REPORTDIR}/${DESIGN}/fmv_unmatched_points.rpt
			report_failing_points > ${REPORTDIR}/${DESIGN}/fmv_failing_points.rpt
			report_aborted > ${REPORTDIR}/${DESIGN}fmv_aborted_points.rpt
			analyze_points -failing > ${REPORTDIR}/${DESIGN}/fmv_failing_analysis.rpt
			report_svf_operation [find_svf_operation -status rejected]
		}
	} elseif { $synopsys_program_name == "lc_shell" } { 
		foreach ip ${hard_ip} {
			if { ![ file exists ${ip}.db ] } {
				# typical corner
				read_lib ${LIBDIR}/${ip}.lib
				write_lib ${ip} -output ${DBDIR}/${ip}.db
				remove_lib ${ip}
			}
		}
	}
} else {
	##### Cadence Tool chain (GENUS)
	# target design
	set design ${DESIGN}

	# path/library settings
	set_db / .lib_search_path [concat . ${CELLDIR} ${LIBDIR}]
	set_db / .library $target_library

	# read hdl
	set_db / .hdl_search_path $search_path
	if { [info exist FILE_LIST] } {
		read_hdl ${FILE_LIST}
	}
	if { [info exist SV_FILE_LIST] } {
		read_hdl -sv ${SV_FILE_LIST}
		if { [info exist SV_COMPLEX_PORT]} {
			set_db / .hdl_sv_module_wrapper true
		}
	}
	elaborate

	# set top design
	#set design ${DESIGN}
	current_design ${DESIGN}

	# dont touch constraints
	if { [info exist DONT_TOUCH_CELL] } {
		foreach cell ${DONT_TOUCH_CELL} {
			set_dont_touch [get_cells -hierarchical $cell]
		}
	}
	#set_dont_touch ${DONT_TOUCH_CELLS}

	# synthesis option and compile
	source -echo -verbose ${TCLDIR}/clk_const.tcl
	check_design > ${REPORTDIR}/${DESIGN}/check_design.rpt

	# synthesis
	syn_generic
	syn_map
	syn_opt

	# output result
	write_hdl -generic ${DESIGN} > ${RESULTDIR}/${DESIGN}/${DESIGN}.generic_gate.v
	write_hdl -lec ${DESIGN} > ${RESULTDIR}/${DESIGN}/${DESIGN}.mapped.v
	if { [info exist SV_FILE_LIST] } {
		# if source contains systemverilog files, output systemverilog netlist wrapper
		if { [info exist SV_COMPLEX_PORT] } {
			write_sv_wrapper -wrapper_name ${DESIGN}_svsim \
				-module ${DESIGN} > ${RESULTDIR}/${DESIGN}/${DESIGN}_svsim.sv
			#write_sv_wrapper > ${RESULTDIR}/${DESIGN}/${DESIGN}_svsim.sv
		}
	}

	# report
	report_area > ${REPORTDIR}/${DESIGN}/report_area.rpt
	report_power > ${REPORTDIR}/${DESIGN}/report_power.rpt
	report_timing > ${REPORTDIR}/${DESIGN}/report_timing.rpt
}
