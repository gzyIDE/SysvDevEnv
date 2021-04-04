`include "stddef.vh"

`ifdef NETLIST
 `timescale 1ns/10ps
`endif

module sample_seq_test;
	parameter STEP = 100;
	parameter DATA = 32;
	parameter ADDR = 4;
	parameter DEPTH = 1 << ADDR;
	parameter READ = 4;
	parameter WRITE = 4;
	parameter ZERO_REG = `Disable;
	localparam RNUM = $clog2(READ) + 1;
	localparam WNUM = $clog2(WRITE) + 1;

	reg							clk;
	reg							reset_;
	reg [READ-1:0][ADDR-1:0]	raddr;
	wire [READ-1:0][DATA-1:0]	rdata;
	reg [WRITE-1:0]				we_;
	reg [WRITE-1:0][DATA-1:0]	in;
	reg [WRITE-1:0][ADDR-1:0]	waddr;

	always #(STEP/2) begin
		clk <= ~clk;
	end

`ifdef NETLIST
	// Parameters must be same as synthesized netlist
	// Call wrapper module instead for modules with complex ports
	sample_seq_svsim rf (
`else
	sample_seq #(
		.DATA		( DATA ),
		.ADDR		( ADDR ),
		.READ		( READ ),
		.WRITE		( WRITE ),
		.ZERO_REG	( ZERO_REG )
	) rf (
`endif
		.clk		( clk ),
		.reset_		( reset_ ),
		.raddr		( raddr ),
		.waddr		( waddr ),
		.we_		( we_ ),
		.wdata		( in ),
		.rdata		( rdata )
	);

	task reg_clear;
		raddr	= {ADDR*READ{1'b0}};
		we_	= {WRITE{1'b1}};
		in		= {DATA*WRITE{1'b0}};
		waddr	= {ADDR*WRITE{1'b0}};
	endtask

	// fetch data set
	task f_set (
		input [RNUM-1:0]	pos,
		input [ADDR-1:0]	addr
	);

		raddr[pos] = addr;
	endtask

	// backend data set
	task b_set (
		input [WNUM-1:0]	pos,
		input [ADDR-1:0]	addr,
		input [DATA-1:0]	data
	);

		waddr[pos] = addr;
		in[pos] = data;
	endtask

	task b_write (
		input [WRITE-1:0]	we_pattern_
	);

		we_ = we_pattern_;
		#(STEP)
		we_ = {WRITE{`Disable_}};
	endtask

`ifndef NETLIST
	task dump_register;
		int i;

		for ( i = 0; i < DEPTH; i = i + 1 ) begin
			$display("reg[%d] : %x", i, rf.regs[i]);
		end
	endtask
`else
	task dump_register;
		int i;

		for ( i = 0; i < DEPTH; i = i + 1 ) begin
			raddr[0] = i;
			#(STEP);
			$display("reg[%d] : %x", i, rdata[0]);
		end
	endtask
`endif

	initial begin
		clk	<= `Low;
		reset_ <= `Enable_;
		reg_clear;
		#(STEP)
		reset_ <= `Disable_;
		#(STEP)
		// Read/Write check
		b_set(0, 31, 31); 
		b_set(1, 1, 1);
		b_set(2, 2, 2);
		b_set(3, 3, 3);
		b_write(4'b0000);
		#(STEP)
		// check zero is not changed
		b_set(0,0, 32'hdeadbeef);
		b_write(4'b1110);
		#(STEP)
		// read zero register
		f_set(0, 0);
		#(STEP)
		// register read
		f_set(0, 2);
		f_set(1, 3);
		f_set(2, 1);
		f_set(3, 31);
		// Read/Write check
		b_set(0, 31, 31); 
		b_set(1, 4, 32'h10);
		b_set(2, 5, 32'h20);
		b_set(3, 6, 32'h30);
		b_write(4'b0000);
		#(STEP)
		dump_register;
		$finish;
	end

	`include "waves.vh"
	
endmodule
