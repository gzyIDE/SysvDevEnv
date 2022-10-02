#!/bin/tcsh

####################################################
########  Synthesis and Formal verification ########
####################################################

# tool selection
set TOOL = yosys
#set TOOL = sv2v_yosys
#set TOOL = vivado

# design name
set DESIGN_NAME = sample_seq

# directory setup
set SCR_DIR	= "scripts"
set LOG_DIR = "log"
set RESULT_DIR = "result"

mkdir -p ${LOG_DIR}
mkdir -p ${RESULT_DIR}
mkdir -p ${RESULT_DIR}/${DESIGN_NAME}

# setup file
echo "set TOP_DIR .." >! setup.tcl
echo "set DESIGN ${DESIGN_NAME}" >> setup.tcl
echo "set RESULT_DIR ${RESULT_DIR}" >> setup.tcl
echo "set SCR_DIR ${SCR_DIR}" >> setup.tcl

# tool selection
if ( $TOOL =~ "yosys") then
	yosys \
		-c ${SCR_DIR}/yosys/common.tcl \
		| tee ${LOG_DIR}/${DESIGN_NAME}.log
else if ( $TOOL =~ "sv2v_yosys" ) then
	pushd ../sv2v
	./convert.sh ${DESIGN_NAME}
	popd

	yosys \
		-c ${SCR_DIR}/yosys/common.tcl \
		| tee ${LOG_DIR}/${DESIGN_NAME}.log
else
#source ./vivado.sh $DESIGN_NAME
endif
