`timescale 1ns / 1ps

// second stage in pipeline
// sel1 0 for reg, 1 for immediate
module decode_unit(
        input clk,
        input w_en,
        input [31:0] instruction,
        input [31:0] wdata,
        input [4:0] wd,
        output [31:0] op1,
        output [31:0] op2,
        output [31:0] branch_addr);
         
        parameter LUI = 7'b0110111; 
        parameter AUIPC= 7'b0010111;
        parameter JAL= 7'b1101111; 
        parameter JALR= 7'b1100111; 
        parameter BRANCH= 7'b1100011; 
        parameter LOAD= 7'b0000011; 
        parameter STORE= 7'b0100011; 
        parameter IMM= 7'b0010011; 
        parameter REG =7'b0110011; 
        
        parameter BEQ =3'b000;  
        parameter BNE =3'b001; 
        parameter BLT =3'b100; 
        parameter BGE =3'b101; 
        parameter BLTU= 3'b110; 
        parameter BGEU= 3'b111; 
        parameter LB =3'b000; 
        parameter LH =3'b001; 
        parameter LW =3'b010; 
        parameter LBU =3'b100; 
        parameter LHU =3'b101; 
        parameter SB =3'b000; 
        parameter SH =3'b001; 
        parameter SW =3'b010; 
        parameter ADDI =3'b000; 
        parameter SLTI =3'b010; 
        parameter SLTIU =3'b011; 
        parameter XORI =3'b100; 
        parameter ORI =3'b110; 
        parameter ANDI =3'b111; 
        parameter SLLI =3'b001; 
        parameter SRI =3'b101;     // SRLI and SRAI
        parameter ADDSUB =3'b000;  // ADD and SUB  
        parameter SLL =3'b001; 
        parameter SLT =3'b010; 
        parameter SLTU =3'b011; 
        parameter XOR =3'b100; 
        parameter SR =3'b101;      // SRL and SRA
        parameter OR =3'b110; 
        parameter AND =3'b111; 
        
        parameter SRLI =7'b0000000; 
        parameter SRAI =7'b0100000; 
        parameter ADD =7'b0000000; 
        parameter SUB =7'b0100000; 
        parameter SRL =7'b0000000; 
        parameter SRA =7'b0100000; 


        wire [6:0] funct7;
        wire [2:0] funct3;
        wire [6:0] opcode;
        wire [4:0] rs1;
        wire [4:0] rs2;
        wire [4:0] rd;
        wire [31:0] temp;
        
        reg [11:0] imm;
        reg sel1;
        reg sel2;
        
        assign opcode = instruction[6:0];
        assign funct3 = instruction[14:12];
        assign funct7 = instruction[31:25];
        assign rd = instruction[11:7];
        assign rs1 = instruction[19:15];
        assign rs2 = instruction[24:20];
        assign op2 = sel2? {{20{imm[11]}}, imm}: temp;
        assign branch_addr = {{20{imm[11]}}, imm};
        
        regfile regfile1(.clk(clk),
                            .w_en(w_en),
                            .raddr1(rs1),
                            .raddr2(rs2),
                            .waddr(wd),
                            .wdata(wdata),
                            .rdata1(op1),
                            .rdata2(temp));
        
        always@(*) begin
            casex(opcode)
                REG: begin sel2=0; imm=0; end 
                IMM: begin
                    casex(funct3) 
                        ADDI: begin sel2=1; imm=instruction[31:20]; end
                        SLLI: begin sel2=1; imm=instruction[24:20]; end
                        SLTI: begin sel2=1; imm=instruction[31:20]; end
                        SLTIU:begin sel2=1; imm=instruction[31:20]; end
                        XORI: begin sel2=1; imm=instruction[31:20]; end
                        SRI:  begin
                            casex(funct7)
                                SRLI: begin sel2=1; imm=instruction[24:20]; end
                                SRAI: begin sel2=1; imm=instruction[24:20]; end
                                default: begin sel2=0; imm=0; end
                            endcase 
                        end
                        ORI:  begin sel2=1; imm=instruction[31:20]; end
                        ANDI: begin sel2=1; imm=instruction[31:20]; end 
                        default: begin sel2=0; imm=0; end
                    endcase
                end 
                LOAD: begin sel2=1; imm=instruction[31:20]; end
                STORE: begin sel2=0; imm={instruction[31:25], instruction[11:7]}; end
                BRANCH: begin sel2=0; imm={instruction[31], instruction[7], instruction[30:25], instruction[11:8]}; end
                default: begin sel2=0; imm=0; end
            endcase
        end  

endmodule
