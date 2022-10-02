#!/bin/tcsh

###########################################
###              Synthesis              ###
###########################################

if ( $#argv == 0 ) then
	# design name
	set DESIGN_NAME = sample_seq
else
	set DESIGN_NAME = $1
endif

if ( $#argv <= 1 ) then
	# design name
	set FILE_EXT = v
else
	set DESIGN_NAME = $1
endif

# constant parameter
set SCR_DIR	= "scripts/yosys"
set LOG_DIR = "log"
set RESULT_DIR = "result"


yosys \
	-c ${SCR_DIR}/common.tcl \
	| tee ${LOG_DIR}/${DESIGN_NAME}.log
