`timescale 1ns / 1ps

module alu_decoder(
    input [3:0] opcode,
    output reg [6:0] enable
    );
    
    always @ (*) begin
        case(opcode)
            4'b0000: enable = 7'b0000001;    // and
			4'b0001: enable = 7'b0000010;    // or   
			4'b0010: enable = 7'b0000100;    // xor
			4'b0011, 4'b0100, 4'b0101, 4'b0110: enable = 7'b0001000;    // addsub
			4'b0111: enable = 7'b0010000;    // sll
			4'b1000: enable = 7'b0100000;    // srl
			4'b1001: enable = 7'b1000000;    // sra 			
			default: enable = 7'b0000000;
        endcase
    end
endmodule
