# EasySysvEnv
Easy to use RTL development environment for SystemVerilog

# Directory
For more 
* rtl
- Directory for SystemVerilog source files

* include
- Directory for Verilog or SystemVerilog include files

* test
- Directory for test vectors and test utilities
  - Scripts
    - testvec.sh :<br>
		Execute testvec.sh to start RTL/Netlist Simulations.
    - target.sh :<br>
		Select DUT (Design Under Test) in this file.
    - module.sh :<br>
		Describe dependent files in this file.
    - sim_tool.sh :<br>
		Select Logic Simulators in this file.
	- clean.sh :<br>
		This scripts eliminates logs and binaries created by simulators.
  - Verilog Headers
    - sim.vh : <br>
		Some utilities for simulators.
    - waves.vh :<br>
		Wave dump options for RTL/Netlist Simulations.
		Include this file inside test vectors.

* syn
- Directory for logic synthesis scripts for ASIC

* fpga
- Directory for logic synthesis and P&R scripts for FPGA



# Compiling sample scripts
