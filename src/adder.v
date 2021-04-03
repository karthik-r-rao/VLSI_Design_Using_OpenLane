`timescale 1ns / 1ps

module adder(
    input [31:0] a,
    input [31:0] b,
    input cin,
    output [31:0] out,
    output cout
    );
    
    assign {cout, out} = a + ({32{cin}}^b) + cin;
endmodule
