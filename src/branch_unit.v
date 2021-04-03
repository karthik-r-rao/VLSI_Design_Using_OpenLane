`timescale 1ns / 1ps
`include "params.vh"

module branch_unit(
    input [31:0] slt_out,
    input [31:0] sltu_out,
    input equal_out,
    input branch,
    input [31:0] instruction,
    output reg branch_taken
    );
    
    always@(*) begin
        casex(instruction[14:12])
            `BEQ: begin branch_taken=(equal_out)&branch; end
            `BNE: begin branch_taken=(~equal_out)&branch; end
            `BLT: begin branch_taken=(slt_out)&branch; end 
            `BGE: begin branch_taken=(~slt_out)&branch; end 
            `BLTU: begin branch_taken=(sltu_out)&branch; end 
            `BGEU: begin branch_taken=(~sltu_out)&branch; end     
            default: branch_taken=0;    
        endcase
    end
endmodule
