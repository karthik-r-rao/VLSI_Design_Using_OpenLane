`timescale 1ns / 1ps

module slt(
    input [3:0] NZCV,
    output [31:0] out
    );
    
    assign out = {{31{1'b0}}, (NZCV[0] ^ NZCV[3])};
endmodule