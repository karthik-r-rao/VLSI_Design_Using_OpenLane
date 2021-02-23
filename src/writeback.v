`timescale 1ns / 1ps

module writeback(
    input [31:0] instruction,
    output reg w_en,
    output [4:0] rd
    );
    
    parameter LOAD= 7'b0000011; 
    parameter IMM= 7'b0010011; 
    parameter REG =7'b0110011;
    
    wire [6:0] opcode;
    
    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    
    always@(*) begin
        case(opcode)
            LOAD, IMM, REG: w_en=1;
            default: w_en=0;
        endcase
    end
endmodule
