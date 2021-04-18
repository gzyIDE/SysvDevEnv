#!/bin/tcsh

switch ( $TOP_MODULE )
	case "sample_com" :
		set RTL_FILE = ( \
			${SVDIR}/${TOP_MODULE}.sv \
		)
	breaksw

	case "sample_seq" :
		set RTL_FILE = ( \
			${SVDIR}/${TOP_MODULE}.sv \
		)
	breaksw

	case "sample_lib_conv" :
		set RTL_FILE = ( \
			${SVDIR}/${TOP_MODULE}.sv \
		)
	breaksw

	default : 
		# Error
		echo "Invalid Module"
		exit 1
	breaksw
endsw
