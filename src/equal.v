`timescale 1ns / 1ps

module equal(
    input [31:0] a,
    input [31:0] b,
    output [31:0] out
    );
    
    assign out = (a==b)?32'b1:32'b0;   
endmodule
