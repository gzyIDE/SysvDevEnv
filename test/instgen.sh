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
./gen/makeinst.pl \
  -i ${RTLDIR}/${TOP_MODULE}.sv \
  -t ${TOP_MODULE} \
  ${INCLUDE}
