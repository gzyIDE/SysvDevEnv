/*
* <sample_lib_conv.sv>
* 
* Copyright (c) 2021 Yosuke Ide <yosuke.ide@keio.jp>
* 
* This software is released under the MIT License.
* http://opensource.org/licenses/mit-license.php
*/

// Library Conversion and hard ip example
// For Synopsys tools...
//	  Design compiler requires .lib files to be converted into .db files 
//	using lc_shell. This example shows how to compile .lib files using
//	ASAP7 standard cell library.
//	  Vendor provided hard-ip can be called in the same way as
//  "sample_lib_conv.tcl".
//
// For Cadence tools...
//	  GENUS can read .lib file directly to compile rtl. 
//	  Vendor provided hard-ip can be called by enumeration them in the 
//  same way as sample_lib_conv.tcl".

module sample_lib_conv (
	input wire			clk,
	input wire			in1,
	input wire			in2,
	output reg			out
);

	reg					out_reg;

	always_ff @( posedge clk ) begin
		out <= in1 && in2;
	end

endmodule
