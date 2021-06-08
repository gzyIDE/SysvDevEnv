# SysvDevEnv
Easy to use RTL development environment for SystemVerilog.  
Vivadoを中心に、各種商用EDA (Synopsys, Cadence)での開発も考慮に入れた、System Verilogの開発環境です。

# Directory
For more details, see comments of each files
* rtl
  - Directory for SystemVerilog source files

* include
  - Directory for Verilog or SystemVerilog include files

* test
  - Directory for test vectors and test utilities
    - Scripts
      - testvec.sh :<br>
  		Execute testvec.sh to start RTL/Netlist Simulations
      - target.sh :<br>
  		Select DUT (Design Under Test) in this file
      - module.sh :<br>
  		Describe dependent files in this file
      - sim_tool.sh :<br>
  		Select Logic Simulators in this file
  	  - clean.sh :<br>
  		This scripts eliminates logs and binaries created by simulators
    - Verilog Headers
      - sim.vh : <br>
  		Some utilities for simulators
      - waves.vh :<br>
  		Wave dump options for RTL/Netlist Simulations<br>
  		Include this file inside test vectors
  - For more details, see README.md in [test](test) directory

* sv2v
  - Based on [sv2v]
  - If you want to test your design with [iverilog] or synthesize one with [Yosys]

[sv2v]: https://github.com/zachjs/sv2v
[iverilog]: http://iverilog.icarus.com/
[Yosys]: http://www.clifford.at/yosys/

* syn
  - Directory for logic synthesis scripts for ASIC
  - For more details, see README.md in [syn](syn) directory

* fpga (Coming soon...)
  - Directory for logic synthesis and P&R scripts for FPGA
  - For more details, see README.md in [fpga](fpga) directory

* vim
  - Enviroment for syntax checking using vim syntastic plug-in
  - See [vim/README.md](vim/README.md) for more information.
