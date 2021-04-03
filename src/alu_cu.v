`timescale 1ns / 1ps
`include "params.vh"

module alu_cu(
    input [31:0] instruction,                       // instruction in execute stage
    output reg [3:0] alusel,                        // signal for choosing output of alu
    output reg cin,                                 // carry in for addition and subtraction
    output reg branch                               // signal to indicate branch taken
    );
    
        wire [6:0] funct7;
        wire [2:0] funct3;
        wire [6:0] opcode;
        
        assign opcode = instruction[6:0];
        assign funct3 = instruction[14:12];
        assign funct7 = instruction[31:25];
        
        always@(*) begin
            casex(opcode)
                `REG: begin
                    casex(funct3) 
                        `ADDSUB: begin
                            casex(funct7)
                                `ADD:begin alusel=4'b0011;cin=0; branch=0; end
                                `SUB:begin alusel=4'b0100;cin=1; branch=0; end
                                default: begin alusel=4'b0000; cin=0; branch=0; end
                            endcase
                        end
                        `SLL: begin alusel=4'b0111;cin=0;branch=0; end
                        `SLT: begin alusel=4'b0101;cin=1;branch=0; end
                        `SLTU:begin alusel=4'b0110;cin=1;branch=0; end
                        `XOR: begin alusel=4'b0010;cin=0;branch=0; end
                        `SR:  begin
                            casex(funct7)
                                `SRL: begin alusel=4'b1000;cin=0;branch=0; end
                                `SRA: begin alusel=4'b1001;cin=0;branch=0; end
                                default: begin alusel=4'b0000; cin=0; branch=0; end
                            endcase 
                        end
                        `OR:  begin alusel=4'b0001;cin=0;branch=0; end
                        `AND: begin alusel=4'b0000;cin=0;branch=0; end  
                        default: begin alusel=4'b0000; cin=0; branch=0; end
                    endcase
                end 
                
                `IMM: begin
                    casex(funct3) 
                        `ADDI: begin alusel=4'b0011; cin=0;branch=0; end
                        `SLLI: begin alusel=4'b0111;cin=0;branch=0; end
                        `SLTI: begin alusel=4'b0101;cin=1;branch=0; end
                        `SLTIU:begin alusel=4'b0110;cin=1;branch=0; end
                        `XORI: begin alusel=4'b0010;cin=0;branch=0; end
                        `SRI:  begin
                            casex(funct7)
                                `SRLI: begin alusel=4'b1000;cin=0;branch=0; end
                                `SRAI: begin alusel=4'b1001;cin=0;branch=0; end
                                default: begin alusel=4'b0000; cin=0; branch=0; end
                            endcase 
                        end
                        `ORI:  begin alusel=4'b0001;cin=0;branch=0; end
                        `ANDI: begin alusel=4'b0000;cin=0;branch=0; end  
                        default: begin alusel=4'b0000; cin=0; branch=0; end
                    endcase
                end 
                
                `LOAD: begin alusel=4'b1011;cin=0;branch=0; end
                `STORE: begin alusel=4'b1011;cin=0;branch=0; end
                `BRANCH: begin alusel=4'b1010;cin=0;branch=1;end
                default: begin alusel=4'b0000; cin=0; branch=0; end
            endcase
        end  
endmodule
