`timescale 1ns / 1ps
`include "params.vh"

module check_dependency(
    input [31:0] instruction1,          // decode stage
    input [31:0] instruction2,          // execute stage
    input [31:0] instruction3,          // mem access stage
    output reg [3:0] dep_place
    );
    
    wire [7:0] opcode1;
    wire [7:0] opcode2;
    wire [7:0] opcode3;
    wire [4:0] rs1_1;                   // source1 register in decode stage
    wire [4:0] rs2_1;                   // source 2 register in decode stage
    wire [4:0] rd_2;                    // destination register in execute stage
    wire [4:0] rd_3;                    // destination register in memory access stage
    
    reg dep_flag;
    reg dep_flag1; 
    reg dep_flag2;
    
    assign rs1_1 = instruction1[19:15];
    assign rs2_1 = instruction1[24:20];
    assign rd_2 = instruction2[11:7];
    assign rd_3 = instruction3[11:7];
    assign opcode1 = instruction1[6:0];
    assign opcode2 = instruction2[6:0];
    assign opcode3 = instruction3[6:0];
    
    always@(*) begin
        casex(opcode1)
            `REG, `BRANCH: dep_flag1 = (rs1_1==rd_2)||(rs2_1==rd_2);
            `IMM: dep_flag1 = (rs1_1==rd_2);
            default: dep_flag1=0;
        endcase
    end
    
    always@(*) begin
        casex(opcode1)
            `REG, `BRANCH: dep_flag2 = (rs1_1==rd_3)||(rs2_1==rd_3);
            `IMM, `LOAD: dep_flag2 = (rs1_1==rd_3);
            default: dep_flag2=0;
        endcase
    end
    
    always@(*) begin
    dep_flag = dep_flag1 | dep_flag2;
        if(dep_flag) begin
            if(rs1_1==rd_2) dep_place[0] = 1;
            if(rs2_1==rd_2) dep_place[1] = 1;
            if(rs1_1==rd_3) dep_place[2] = 1;
            if(rs2_1==rd_3) dep_place[3] = 1;
            else dep_place = 4'b0000;
        end
        else dep_place = 4'b0000;
    end
endmodule
