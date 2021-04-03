`timescale 1ns / 1ps
`include "params.vh"

module writeback(
    input [31:0] instruction,               // instruction at writeback stage
    output reg w_en,                        // write enable to register bank
    output [4:0] rd                         // destination register
    );
    
    wire [6:0] opcode;
    
    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    
    always@(*) begin
        case(opcode)
            `LOAD, `IMM, `REG: w_en=1;
            default: w_en=0;
        endcase
    end
endmodule
