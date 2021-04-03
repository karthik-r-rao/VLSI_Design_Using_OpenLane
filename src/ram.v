`timescale 1ns / 1ps

module ram #(parameter ADDR_SIZE = 5)(
	input clk,
	input w_en,                                                    // write enable
	input [1:0] offset,                                            // byte/(s) in a word 
	input [3:0] sel,                                               // type of instruction
	input [31:0] maddr1,                                           // instruction address
	input [31:0] maddr2,                                           // data address
	output [31:0] mdata1,                                          // one way instruction bus
	inout [31:0] mdata2                                            // data bus
	);

	parameter MEM_SIZE = 2**ADDR_SIZE;
	reg [31:0] memblock [MEM_SIZE-1:0];

    wire clk1 [1:0];
    
    // clock buffer
    assign clk1[0] = ~clk;
    assign clk1[1] = ~clk1[0];

	assign mdata1 = memblock[maddr1];                              // instruction
	assign mdata2 = w_en? 32'hzzzzzzzz: memblock[maddr2];          // data

	always @ (posedge clk1[1])
		if(w_en) begin
		  case(sel)
		      4'b0001: memblock[maddr2] <= mdata2;
              4'b0010: begin
                case(offset[1])
                    1: memblock[maddr2][31:16] <= mdata2[15:0];
                    0: memblock[maddr2][15:0] <= mdata2[15:0];
                endcase
              end
              4'b0100: begin
                case(offset)
                    3: memblock[maddr2][31:24] <= mdata2[7:0];
                    2: memblock[maddr2][23:16] <= mdata2[7:0];
                    1: memblock[maddr2][15:8] <= mdata2[7:0];
                    0: memblock[maddr2][7:0] <= mdata2[7:0];
                endcase
              end
		  endcase
		end
endmodule
