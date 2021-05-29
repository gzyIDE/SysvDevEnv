#!/bin/tcsh

switch ( $TOP_MODULE )
	case "sample_com" :
		set TEST_FILE = ${TBDIR}/${TOP_MODULE}_test.sv
		if ( $GATE =~ 1 ) then
			set RTL_FILE = ( \
				$RTL_FILE \
				${GATEDIR}/${TOP_MODULE}/${TOP_MODULE}.mapped.v \
			)
		else
			set RTL_FILE = ( \
				${RTLDIR}/${TOP_MODULE}.sv \
			)
		endif
	breaksw

	case "sample_seq" :
		set TEST_FILE = ${TBDIR}/${TOP_MODULE}_test.sv
		if ( $GATE =~ 1 ) then
			set RTL_FILE = ( \
				$RTL_FILE \
				${GATEDIR}/${TOP_MODULE}/${TOP_MODULE}.mapped.v \
				${GATEDIR}/${TOP_MODULE}/${TOP_MODULE}_svsim.sv \
			)
		else
			set RTL_FILE = ( \
				${RTLDIR}/${TOP_MODULE}.sv \
			)
		endif
	breaksw

	case "sample_lib_conv" :
		set TEST_FILE = ${TBDIR}/${TOP_MODULE}_test.sv
		if ( $GATE =~ 1 ) then
			set RTL_FILE = ( \
				$RTL_FILE \
				${GATEDIR}/${TOP_MODULE}/${TOP_MODULE}.mapped.v \
			)
		else
			set RTL_FILE = ( \
				${RTLDIR}/${TOP_MODULE}.sv \
			)
		endif
	breaksw

	default : 
		# Error
		echo "Invalid Module"
		exit 1
	breaksw
endsw

if ( $SV2V =~ 1 ) then
	pushd $SV2VDIR
	./clean.sh
	./convert.sh $TOP_MODULE
	popd

	# Test vector
	set TEST_FILE = "${SV2VTESTDIR}/${TOP_MODULE}_test.v"

	# DUT
	set new_path = ()
	foreach file ( $RTL_FILE )
		set vfilename = `basename $file:r.v`
		set new_path = ( \
			$new_path \
			${SV2VRTLDIR}/${vfilename} \
		)
	end
	set RTL_FILE = ( $new_path )
endif
