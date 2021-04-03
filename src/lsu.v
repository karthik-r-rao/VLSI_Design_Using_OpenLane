`timescale 1ns / 1ps
`include "params.vh"

module lsu(
    input [31:0] aluout,                        // output of execute stage
    input [31:0] address,                       // EA calculated in execute stage
    input [1:0] offset,                         // byte/(s) in a word
    input [31:0] instruction,                   // instruction in memory access stage
    inout [31:0] memout,                        // data bus 
    output [31:0] out,                          // output of memory access stage (loads)
    output reg [3:0] sel,                       // type of instruction:- word/ halfword/ byte access 
    output reg write                            // write enable to main memory
    );
    
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [7:0] tmp1;
    wire [7:0] tmp2;
    wire [7:0] tmp3;
    wire [7:0] tmp4;
    wire [7:0] tmpb;
    wire [15:0] tmph;
    
    reg [31:0] lsout; 
    
    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign tmp1 = memout[7:0];
    assign tmp2 = memout[15:8];
    assign tmp3 = memout[23:16];
    assign tmp4 = memout[31:24];
    assign tmpb = offset[1]? (offset[0]?tmp4:tmp3):(offset[0]?tmp2:tmp1);
    assign tmph = offset[1]? {tmp4,tmp3}:{tmp2,tmp1};
    assign out = lsout;
    assign memout = write? aluout: 32'hzzzzzzzz;
    
    always@(*) begin
        casex(opcode)
            `LOAD: casex(funct3)
                        `LB, `LBU: begin sel=4'b0100; write=0; end
                        `LH, `LHU: begin sel=4'b0010; write=0; end
                        default: begin sel=4'b0001; write=0; end
            endcase
            `STORE: casex(funct3)
                        `SB: begin sel=4'b0100; write=1; end
                        `SH: begin sel=4'b0010; write=1; end
                        default: begin sel=4'b0001; write=1; end
            endcase
            default: begin sel=4'b1000; write=0; end
        endcase
    end
    
    always@(*) begin
        casex(sel)
            4'b0001: lsout = {tmp4, tmp3, tmp2, tmp1};
            4'b0010: lsout = tmph;
            4'b0100: lsout = tmpb;
            default: lsout = aluout;
        endcase
    end
endmodule