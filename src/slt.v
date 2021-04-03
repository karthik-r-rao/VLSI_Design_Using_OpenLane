`timescale 1ns / 1ps

module slt(
    input signed [31:0] a,
    input signed [31:0] b,
    output [31:0] out
    );
    
    assign out = (a<b)?1:0;
    
endmodule