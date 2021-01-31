module regfile #(parameter ADDR_SIZE=5, WORD_SIZE=32)(
	input clk,
	input w_en,
	input [ADDR_SIZE-1:0] raddr1,
	input [ADDR_SIZE-1:0] raddr2,
	input [ADDR_SIZE-1:0] waddr,
	input [WORD_SIZE-1:0] wdata,
	output [WORD_SIZE-1:0] rdata1,
	output [WORD_SIZE-1:0] rdata2
	);

	parameter REGFILE_SIZE = 2**ADDR_SIZE;
	reg [WORD_SIZE-1:0] regblock [REGFILE_SIZE-1:0];

	assign rdata1 = regblock[raddr1];
	assign rdata2 = regblock[raddr2];

	always @ (posedge clk)
		if(w_en)
			regblock[waddr] <= wdata; 

endmodule
