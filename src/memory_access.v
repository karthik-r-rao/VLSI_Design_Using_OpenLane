`timescale 1ns / 1ps
`include "params.vh"

module memory_access(
    input [31:0] instruction,
    input [31:0] address,
    output reg [3:0] wstrobe,
    output reg wen,
    output reg ren
    );
    
    wire [7:0] opcode;
    wire [2:0] funct3;
    
    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    
    always@(*) begin
        case(opcode)
            `STORE: begin 
                        wen=1;ren=0;
                        case(funct3) 
                            `SW: wstrobe = 4'b1111;
                            `SH: wstrobe = address[1]? 4'b1100:4'b0011;
                            `SB: wstrobe = 4'b0001 << address[1:0];
                            default: wstrobe = 4'b0000;
                        endcase
                    end 
            `LOAD: begin wen=0; ren=1; 
                   case(funct3) 
                            `LW: wstrobe = 4'b1111;
                            `LH, `LHU: wstrobe = address[1]? 4'b1100:4'b0011;
                            `LB, `LBU: wstrobe = 4'b0001 << address[1:0];
                            default: wstrobe = 4'b0000;
                        endcase
                   end
            default: begin wen=0; ren =0; wstrobe = 4'b0000; end
        endcase
    end
endmodule
