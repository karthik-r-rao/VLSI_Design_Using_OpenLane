`timescale 1ns / 1ps

module execute(
    input clk,
    input [31:0] instruction,
    input [31:0] pc,
    input [31:0] op1,
    input [31:0] op2,
    input [31:0] branch_offset,
    output [31:0] aluout,
    output bt,
    output [31:0] branch_addr
    );

    wire [3:0] alusel;
    wire cin;
    wire branch;
    wire [31:0] tmp;
    
    assign tmp = branch?pc:op1;
    
    alu_cu alucu1(.instruction(instruction),
                    .alusel(alusel),
                    .cin(cin),
                    .branch(branch));
                    
    alu alu1(.a(op1),
                .b(op2),
                .cin(cin),
                .instruction(instruction),
                .opcode(alusel),
                .out(aluout),
                .branch(branch),
                .branch_taken(bt));
                
    adder add1(.a(tmp),
                .b(branch_offset),
                .cin(0),
                .out(branch_addr));
endmodule
