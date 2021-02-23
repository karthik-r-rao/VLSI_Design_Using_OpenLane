`timescale 1ns / 1ps

module shift_arith_right(
    input [31:0] a,
    input [4:0] b,
    output [31:0] c 
    );
    
    assign c = a>>>b;
endmodule
