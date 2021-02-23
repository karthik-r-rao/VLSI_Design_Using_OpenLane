`timescale 1ns / 1ps

module decode(
    input clk, 
    input w_en,
    input [31:0] instruction,
    input [31:0] wdata,
    input [4:0] wd,
    output [31:0] op1,
    output [31:0] op2,
    output [31:0] branch_offset,
    output [31:0] st 
    );

    decode_unit du1(.clk(clk),
        .w_en(w_en),
        .instruction(instruction),
        .wdata(wdata),
        .wd(wd),
        .op1(op1),
        .op2(op2),
        .branch_addr(branch_offset));
endmodule
