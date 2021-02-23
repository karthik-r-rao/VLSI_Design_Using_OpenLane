`timescale 1ns / 1ps

module lsu(
    input [31:0] aluout,
    input [31:0] address,
    input [1:0] offset,
    input [31:0] instruction,
    inout [31:0] memout,
    output [31:0] out,
    output reg [3:0] sel,
    output reg write
    );
    
    parameter LOAD= 7'b0000011; 
    parameter STORE= 7'b0100011;
    
    parameter LB =3'b000; 
    parameter LH =3'b001; 
    parameter LW =3'b010; 
    parameter LBU =3'b100; 
    parameter LHU =3'b101; 
    parameter SB =3'b000; 
    parameter SH =3'b001; 
    parameter SW =3'b010;
    
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
            LOAD: casex(funct3)
                        LB, LBU: begin sel=4'b0100; write=0; end
                        LH, LHU: begin sel=4'b0010; write=0; end
                        default: begin sel=4'b0001; write=0; end
            endcase
            STORE: casex(funct3)
                        SB: begin sel=4'b0100; write=1; end
                        SH: begin sel=4'b0010; write=1; end
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