#!/bin/tcsh

############################################
#####              Vivado              #####
############################################

# design name
set DESIGN_NAME = sample_seq

# constant parameter
if ( $#argv == 0 ) then
else
	set DESIGN_NAME = $1
endif

# directory name
set TCL_DIR	= "scripts/vivado"
set LOG_DIR = "log"
set PRJ_DIR = "vivado_prj"

mkdir -p ${LOG_DIR}
vivado -mode batch -source ${TCL_DIR}/${DESIGN_NAME}.tcl | tee ${LOG_DIR}/${DESIGN_NAME}.log
