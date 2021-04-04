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

set DESIGN		sample_com
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
#set HARDIP [list]

# If your design include clock/reset signals, define following variables
#    otherwise leave them commented out
#set CLOCK_SIG_NAME		clk
#set RESET_SIG_NAME		reset_

source -echo -verbose $TCLDIR/common.tcl

quit
