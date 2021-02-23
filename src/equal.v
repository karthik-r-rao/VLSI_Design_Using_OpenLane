`timescale 1ns / 1ps

module equal(
    input [3:0] NZCV,
    output out
    );
    
    assign out = NZCV[2];   
endmodule
