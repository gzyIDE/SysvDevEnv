# name settings
set TCL_DIR		scripts/vivado
set PRJ_DIR		vivado_prj

set DESIGN		sample_seq
set TOPDIR ..
set FILE_LIST	[list \
	${TOPDIR}/rtl/${DESIGN}.sv \
]

set VIVADO_IP [list \
]

source -verbose $TCL_DIR/common.tcl

quit
