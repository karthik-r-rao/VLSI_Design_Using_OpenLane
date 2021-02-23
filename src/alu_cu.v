`timescale 1ns / 1ps

module alu_cu(
    input [31:0] instruction,
    output reg [3:0] alusel,
    output reg cin,
    output reg branch
    );
    
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
        
        assign opcode = instruction[6:0];
        assign funct3 = instruction[14:12];
        assign funct7 = instruction[31:25];
        
        always@(*) begin
            casex(opcode)
                REG: begin
                    casex(funct3) 
                        ADDSUB: begin
                            casex(funct7)
                                ADD:begin alusel=4'b0011;cin=0; branch=0; end
                                SUB:begin alusel=4'b0100;cin=1; branch=0; end
                                default: begin alusel=4'b0000; cin=0; branch=0; end
                            endcase
                        end
                        SLL: begin alusel=4'b0111;cin=0;branch=0; end
                        SLT: begin alusel=4'b0101;cin=1;branch=0; end
                        SLTU:begin alusel=4'b0110;cin=1;branch=0; end
                        XOR: begin alusel=4'b0010;cin=0;branch=0; end
                        SR:  begin
                            casex(funct7)
                                SRL: begin alusel=4'b1000;cin=0;branch=0; end
                                SRA: begin alusel=4'b1001;cin=0;branch=0; end
                                default: begin alusel=4'b0000; cin=0; branch=0; end
                            endcase 
                        end
                        OR:  begin alusel=4'b0001;cin=0;branch=0; end
                        AND: begin alusel=4'b0000;cin=0;branch=0; end  
                        default: begin alusel=4'b0000; cin=0; branch=0; end
                    endcase
                end 
                
                IMM: begin
                    casex(funct3) 
                        ADDI: begin alusel=4'b0011; cin=0;branch=0; end
                        SLLI: begin alusel=4'b0111;cin=0;branch=0; end
                        SLTI: begin alusel=4'b0101;cin=1;branch=0; end
                        SLTIU:begin alusel=4'b0110;cin=1;branch=0; end
                        XORI: begin alusel=4'b0010;cin=0;branch=0; end
                        SRI:  begin
                            casex(funct7)
                                SRLI: begin alusel=4'b1000;cin=0;branch=0; end
                                SRAI: begin alusel=4'b1001;cin=0;branch=0; end
                                default: begin alusel=4'b0000; cin=0; branch=0; end
                            endcase 
                        end
                        ORI:  begin alusel=4'b0001;cin=0;branch=0; end
                        ANDI: begin alusel=4'b0000;cin=0;branch=0; end  
                        default: begin alusel=4'b0000; cin=0; branch=0; end
                    endcase
                end 
                
                LOAD: begin alusel=4'b1010;cin=0;branch=0; end
                STORE: begin alusel=4'b1010;cin=0;branch=0; end
                BRANCH: begin alusel=4'b0100;cin=1;branch=1; end
                default: begin alusel=4'b0000; cin=0; branch=0; end
            endcase
        end  
endmodule
