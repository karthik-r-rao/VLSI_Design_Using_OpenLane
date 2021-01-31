module regfile #(parameter REGFILE_SIZE=32, WORD_SIZE=32)(
	input clk,
	input w_en,
	input [31:0] raddr1,
	input [31:0] raddr2,
	input [31:0] waddr,
	input [31:0] wdata,
	output [31:0] rdata1,
	output [31:0] rdata2
	);

	reg [WORD_SIZE-1:0] regblock [REGFILE_SIZE-1:0];

	assign rdata1 = regblock[raddr1];
	assign rdata2 = regblock[raddr2];

	always @ (posedge clk)
		if(w_en)
			regblock[waddr] <= wdata; 

endmodule
