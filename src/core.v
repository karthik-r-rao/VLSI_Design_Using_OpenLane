`timescale 1ns / 1ps

/*
    5-stage in-order RISC-V processor.
    
    --> The processor currently supports the arithmetic, logical, bitwise, load, store and branch instructions 
        listed in the RV32I Instruction Set Manual.
    
    --> Data hazards are handled by making use of bypass paths from execute and memory-access stages to the decode stage.
        Register writeback takes place in the negative edge of the clock so no extra bypass is required from the
        writeback stage to the decode stage.  
    
    --> In the event of a branch taken, the next two instructions in the pipe are replaced by NOP, defined as 
        NOP = ADDI R0, R0, #0.
    
    --> Registers of the form $<stage1>_<stage2>_<regname> indicate pipeline registers. 
*/

module core(
    input clk, 
    input rst,
    
    // instruction memory interface
    input [31:0] instruction,                               // instruction
    output [31:0] pc,                                       // program counter
    
    // data memory interface
    input [31:0] rdata,                                     // read data
    output [31:0] data_address,                             // address for read and write (data)
    output[31:0] wdata,                                     // write data
    output [3:0] wstrobe,                                   // strobe for byte stores
    output wen,                                             // write enable (data)
    output ren                                              // read enable (data)
    );

    // fetch 
    reg [31:0] ID_IF_INST;
    reg [31:0] ID_IF_PC;
    reg [31:0] next_pc;
    
    // decode
    wire [31:0] addr;
    wire [31:0] rop1;
    wire [31:0] rop2;
    wire [11:0] imm;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire sel;
    reg [31:0] X_ID_INST;
    reg [31:0] X_ID_OP1;
    reg [31:0] X_ID_OP2;
    reg [31:0] X_ID_OFFSET;
    reg [31:0] X_ID_PC;
    
    // execute
    wire [31:0] memxaluout;
    wire [31:0] memxaddr;
    wire branch;            
    reg [31:0] MEM_X_ADDR;
    reg [31:0] MEM_X_INST;
    reg [31:0] MEM_X_ALUOUT;
    reg [31:0] MEM_X_PC;
    reg MEM_X_BRANCH_TAKEN;                                 // indicates whether a branch is taken
    
    // memory access
    wire [31:0] wbmemout;
    wire [3:0] strobe;
    wire en;
    reg [31:0] WB_MEM_PC;
    reg [31:0] WB_MEM_INST;
    reg [31:0] WB_MEM_OUT;
    
    // writeback
    wire [4:0] rd;
    wire rwen;
    
    // data depenedency
    wire [3:0] dep_place;
    reg [3:0] DEP_PLACE;                                    // indicates whether there is a data dependency
                                                            // 4 bits for 4 bypass paths
                                                            // a set bit indicates data dependency present
    
// **************************************** //
// instantiations

    decode d1(.instruction(ID_IF_INST),
              .rs1(rs1),
              .rs2(rs2),
              .imm(imm),
              .sel(sel),
              .addr(addr));
                
    execute e1(.instruction(X_ID_INST),
               .pc(X_ID_PC),
               .op1(X_ID_OP1),
               .op2(X_ID_OP2),
               .offset(X_ID_OFFSET),
               .aluout(memxaluout),
               .addr(memxaddr),
               .branch(branch));
             
    regfile r1(.clk(clk),
	           .w_en(rwen),
	           .raddr1(rs1),
	           .raddr2(rs2),
	           .waddr(rd),
               .wdata(WB_MEM_OUT),
	           .rdata1(rop1),
	           .rdata2(rop2));
	            
	writeback w1(.instruction(WB_MEM_INST),
                 .w_en(rwen),
                 .rd(rd));
                 
    check_dependency c1(.instruction1(ID_IF_INST),
                        .instruction2(X_ID_INST),
                        .instruction3(MEM_X_INST),
                        .dep_place(dep_place));
    
    memory_access m1(.instruction(MEM_X_INST),
                     .address(MEM_X_ADDR),
                     .wstrobe(strobe),
                     .wen(en),
                     .ren(ren));
          
             
// **************************************** //             
// Fetch stage

    assign pc = ID_IF_PC;
    
    always@(posedge clk) begin
        if(rst) begin
            ID_IF_PC <= 0;
            next_pc <= 4;
            end
        else if(MEM_X_BRANCH_TAKEN) begin
            ID_IF_PC <= MEM_X_ADDR;
            next_pc <= MEM_X_ADDR + 4;
            end
        else begin
            ID_IF_PC <= next_pc;
            next_pc <= next_pc+4;
            end
        ID_IF_INST <= instruction;
    end


// **************************************** //
// Decode stage
                
     always@(posedge clk) begin
        if(MEM_X_BRANCH_TAKEN==1'b1) begin
            X_ID_INST <= 32'h00000013;                      // addi r0, r0, #0; nop
            X_ID_OP1 <= 0;
            X_ID_OP2 <= 0;
            X_ID_OFFSET <= 0;
        end
        else begin
            X_ID_INST <= ID_IF_INST;
            X_ID_OFFSET <= addr;
            if(DEP_PLACE[0]==1) X_ID_OP1 <= memxaluout;     // priority is given to bypass path from execute stage
            else if(DEP_PLACE[2]==1) X_ID_OP1 <= rdata;
            else X_ID_OP1 <= rop1;
            
            if(DEP_PLACE[1]==1) X_ID_OP2 <= memxaluout;     // priority is given to bypass path from execute stage
            else if(DEP_PLACE[3]==1) X_ID_OP2 <= wbmemout;
            else X_ID_OP2 <= sel? {{20{imm[11]}}, imm}:rop2;
        end
        X_ID_PC <= ID_IF_PC;
     end 
     
     always@(negedge clk)                                   // the data dependency flag is updated in the negative clock edge    
        DEP_PLACE <= dep_place;
 
 // **************************************** // 
 // Execute stage
    
                
    always@(posedge clk) begin
        if(MEM_X_BRANCH_TAKEN==1'b1) begin
            MEM_X_INST<=32'h00000013;                       // addi r0, r0, #0; nop
            MEM_X_ALUOUT <= 0;
            MEM_X_BRANCH_TAKEN <= 0;
            MEM_X_ADDR <= 0;
        end
        else begin
            MEM_X_INST<=X_ID_INST;
            MEM_X_ALUOUT <= memxaluout;
            MEM_X_BRANCH_TAKEN <= memxaluout[0]&branch;
            MEM_X_ADDR <= memxaddr;
        end
        MEM_X_PC<=X_ID_PC;
    end

// **************************************** //
// Memory access stage
    
    always @(posedge clk) begin
        WB_MEM_PC <= MEM_X_PC;
        WB_MEM_INST <= MEM_X_INST;
        WB_MEM_OUT <= wbmemout;
    end
    
    assign wbmemout = ren? rdata: MEM_X_ALUOUT;
    assign data_address = MEM_X_ADDR;
    assign wdata = MEM_X_ALUOUT;
    assign wstrobe = strobe;
    assign wen = en;
    
endmodule
