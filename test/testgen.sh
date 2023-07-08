#!/bin/tcsh

source directory_setup.sh
source target.sh

foreach dir ( $INCDIR )
  set INCLUDE = ( \
    -incdir=$dir \
    $INCLUDE \
  )
end

# Simulation Target Selection
if ( $# =~ 0 ) then
	set TOP_MODULE = $DEFAULT_DESIGN
else
	set TOP_MODULE = $1
endif


# Test bench generation
set dmpfile = tb_dump.sv
grep \`include ${RTLDIR}/${TOP_MODULE}.sv >! ${dmpfile}
echo "" >> ${dmpfile}
./gen/tbgen.pl \
  -i ${RTLDIR}/${TOP_MODULE}.sv \
  -t ${TOP_MODULE} \
  ${INCLUDE} >> ${dmpfile}
