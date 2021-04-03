`timescale 1ns / 1ps

module regfile #(parameter ADDR_SIZE=5, WORD_SIZE=32)(
	input clk,
	input w_en,                                        // write enable
	input [ADDR_SIZE-1:0] raddr1,                      // read address port 1
	input [ADDR_SIZE-1:0] raddr2,                      // read address port 2
	input [ADDR_SIZE-1:0] waddr,                       // write address port
	input [WORD_SIZE-1:0] wdata,                       // write port
	output [WORD_SIZE-1:0] rdata1,                     // read port 1
	output [WORD_SIZE-1:0] rdata2                      // read port 2
	);

	parameter REGFILE_SIZE = 2**ADDR_SIZE;
	reg [WORD_SIZE-1:0] regblock [REGFILE_SIZE-1:0];

	assign rdata1 = regblock[raddr1];
	assign rdata2 = regblock[raddr2];

	always @ (negedge clk)                             // writes to regfile at negedge
		if(w_en)
			regblock[waddr] <= wdata; 

endmodule
