#!/bin/tcsh

# Files and Directories Settings
set TOPDIR = ".."
set RTLDIR = "${TOPDIR}/rtl"
set TESTDIR = "${TOPDIR}/test"
set TBDIR = "${TESTDIR}/tb"
set TESTINCDIR = "${TESTDIR}/include"
set GATEDIR = "${TOPDIR}/syn/result"
set SV2VDIR = "${TOPDIR}/sv2v"
set SV2VRTLDIR = "${SV2VDIR}/rtl"
set SV2VTESTDIR = "${SV2VDIR}/test"
set INCDIR = ( \
	${TOPDIR}/include \
	${TESTINCDIR} \
)

set DEFINE_LIST = ( \
	SIMULATION \
)
set INCLUDE = ()
set DEFINES = ()
set RTL_FILE = ()
