# search path settings
set search_path [concat \
	. \
	../rtl \
	../include \
]

# name settings
set REPORTDIR	report
set RESULTDIR	result
set LIBDIR		lib
set DBDIR		db
set TCLDIR		tcl

set DESIGN		sample_lib_conv
# set FILE_LIST [list]
set SV_FILE_LIST	[list \
	${DESIGN}.sv \
]
# define following variable for designs with 
#    complex port definition such as enum, struct, array or interfaces
#set SV_COMPLEX_PORT	true

# Hard IPs called in source files
#    In this example, we used standard cell library for demonstration.
#    But call Hardware IP provided by vendors in real use.
set HARDIP [list \
	asap7sc7p5t_SIMPLE_RVT \
	asap7sc7p5t_AO_RVT \
	asap7sc7p5t_OA_RVT \
	asap7sc7p5t_SEQ_RVT \
	asap7sc7p5t_INVBUF_RVT \
]

# If your design include clock/reset signals, define following variables
#    otherwise leave them commented out
#set CLOCK_SIG_NAME		clk
#set RESET_SIG_NAME		reset_

source -echo -verbose $TCLDIR/common.tcl

exit
