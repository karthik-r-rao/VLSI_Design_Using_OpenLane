`timescale 1ns / 1ps

module execute(
    input [31:0] instruction,                   // instruction in execute stage
    input [31:0] pc,                            // pc of instruction+1 in execute stage
    input [31:0] op1,                           // operand 1
    input [31:0] op2,                           // operand 2
    input [31:0] offset,                        // immediate data used in EA calculation for loads, stores and branches
    output [31:0] aluout,                       // output of execute stage
    output [31:0] addr,                         // EA used in loads, stores and branches
    output branch                               // signal to indicate branch taken
    );

    wire [3:0] alusel;
    wire cin;
    wire [31:0] tmp;
    wire cout;
    
    assign tmp = branch?pc:op1;                 // either pc for branches or operand1 for loads/stores
    
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
                .branch(branch));
                
    assign addr = tmp + offset;
endmodule
