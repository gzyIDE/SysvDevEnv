#########################
##### tool settings #####
#########################
set MAX_JOB		8
set MAX_THREAD	2
set_param general.maxThreads ${MAX_THREAD}

##############################
##### Initialize project #####
##############################
set PARTS		[get_parts xc7z020clg400-1]
create_project -part ${PARTS} -force ${DESIGN} ${PRJ_DIR}

################################
##### search path settings #####
################################
set TOPDIR		..
set INCLUDE_SEARCH_PATH [list \
	${TOPDIR}/include \
]


##################################
##### setup source fileset #######
##################################
set SRCSET		sources_1
if {[string equal [get_filesets -quiet sources_1] ""]} {
	create_fileset -srcset ${SRCSET}
}
set obj			[get_filesets $SRCSET]

### set file list in absolute path ###
set files		[list ]
foreach fileelm ${FILE_LIST} {
	lappend files [file normalize $fileelm]
}
add_files -norecurse -fileset $obj $files

### set fileset property ###
set file_obj	[get_files -of_objects $obj]
set_property -name "file_type" -value "SysteVerilog" -objects $file_obj
set_property -name "is_enabled" -value "1" -objects $file_obj
set_property -name "is_global_include" -value "0" -objects $file_obj
set_property -name "library" -value "xil_defaultlib" -objects $file_obj
set_property -name "path_mode" -value "RelativeFirst" -objects $file_obj
set_property -name "used_in" -value "synthesis implementation simulation" -objects $file_obj
set_property -name "used_in_implementation" -value "1" -objects $file_obj
set_property -name "used_in_simulation" -value "1" -objects $file_obj
set_property -name "used_in_synthesis" -value "1" -objects $file_obj

# set sources_1 fileset properties
set_property -name "design_mode" -value "RTL" -objects $obj
set_property -name "edif_extra_search_paths" -value "" -objects $obj
set_property -name "elab_link_dcps" -value "1" -objects $obj
set_property -name "elab_load_timing_constraints" -value "1" -objects $obj
set_property -name "generic" -value "" -objects $obj
set_property -name "include_dirs" -value ${INCLUDE_SEARCH_PATH} -objects $obj
set_property -name "lib_map_file" -value "" -objects $obj
set_property -name "loop_count" -value "1000" -objects $obj
set_property -name "name" -value ${SRCSET} -objects $obj
set_property -name "top" -value ${DESIGN} -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "verilog_define" -value "" -objects $obj
set_property -name "verilog_uppercase" -value "0" -objects $obj
set_property -name "verilog_version" -value "verilog_2001" -objects $obj
set_property -name "vhdl_version" -value "vhdl_2k" -objects $obj


######################################
##### setup constricts fileset #######
######################################
set CONSTSET	constrs_1
if {[string equal [get_filesets -quiet ${CONSTSET}] ""]} {
  create_fileset -constrset ${CONSTSET}
}

###set constricts fileset###
set obj [get_filesets ${CONSTSET}]
if {[file exist ${TOPDIR}/syn/scripts/vivado/${DESIGN}.xdc]} {
	set files		[list \
		[file normalize ${TOPDIR}/syn/scripts/vivado/clk_const.xdc] \
		[file normalize ${TOPDIR}/syn/scripts/vivado/${DESIGN}.xdc] \
	]
} else {
	set files		[list \
		[file normalize ${TOPDIR}/syn/scripts/vivado/clk_const.xdc] \
	]
}
add_files -norecurse -fileset $obj $files

### set fileset property ###
set file_obj	[get_files -of_objects $obj]
set_property -name "file_type" -value "XDC" -objects $file_obj

### set constrs_1 fileset properties ###
set_property -name "target_part" -value $PARTS -objects $obj
