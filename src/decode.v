`timescale 1ns / 1ps
`include "params.vh"

// second stage in pipeline
// sel 0 for reg, 1 for immediate
module decode(
        input [31:0] instruction,                           // instruction to be decoded
        output [4:0] rs1,                                   // source register 1
        output [4:0] rs2,                                   // source register 2
        output reg [11:0] imm,                              // immediate value in instruction
        output reg sel,                                    // signal to choose between source register 2 and immediate data
        output [31:0] addr);                                // immediate data used in EA calculation for loads, stores and branches
     
        wire [6:0] funct7;
        wire [2:0] funct3;
        wire [6:0] opcode;
        
        assign opcode = instruction[6:0];
        assign funct3 = instruction[14:12];
        assign funct7 = instruction[31:25];
        assign rs1 = instruction[19:15];
        assign rs2 = instruction[24:20];
        assign addr = {{20{imm[11]}}, imm};
        
        always@(*) begin
            casex(opcode)
                `REG: begin sel=0; imm=0; end 
                `IMM: begin
                    casex(funct3) 
                        `ADDI: begin sel=1; imm=instruction[31:20]; end
                        `SLLI: begin sel=1; imm=instruction[24:20]; end
                        `SLTI: begin sel=1; imm=instruction[31:20]; end
                        `SLTIU:begin sel=1; imm=instruction[31:20]; end
                        `XORI: begin sel=1; imm=instruction[31:20]; end
                        `SRI:  begin
                            casex(funct7)
                                `SRLI: begin sel=1; imm=instruction[24:20]; end
                                `SRAI: begin sel=1; imm=instruction[24:20]; end
                                default: begin sel=0; imm=0; end
                            endcase 
                        end
                        `ORI:  begin sel=1; imm=instruction[31:20]; end
                        `ANDI: begin sel=1; imm=instruction[31:20]; end 
                        default: begin sel=0; imm=0; end
                    endcase
                end 
                `LOAD: begin sel=0; imm=instruction[31:20]; end
                `STORE: begin sel=0; imm={instruction[31:25], instruction[11:7]}; end
                `BRANCH: begin sel=0; imm={instruction[31], instruction[7], instruction[30:25], instruction[11:8]}; end
                default: begin sel=0; imm=0; end
            endcase
        end  

endmodule
