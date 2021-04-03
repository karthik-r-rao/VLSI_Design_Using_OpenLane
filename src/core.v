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
    
    --> Loads and Stores are tested on a 32*1024 RAM implemented with registers. The lower section of the RAM region is
        reserved for instructions, and the higher section can be used for storing data. 
        A scheme of logical and physical addresses is used as implementing an 8*1024 RAM with 32 bit access is quite tough in hardware. 
        In this, the logical address is byte-addressable, and supports LB, LH, LBU, LHU, SB, and SH instructions apart from LW and SW.
        This logical address is shifted right 2 places to get the physical address. 
        For ex:
        Suppose logical address (user view) = 97
        The required data is actually the bits [15:8] stored at address 24.
        97>>2 = 97/4 = 24.
        97%4 = 1.
    
        Logical address view                            Physical Address view
        (each location-8 bit)                           (each location-32 bit)
        --3---|--2---|--1--|--0--         =                -----0-----
        --7---|--6---|--5--|--4--         =                -----1-----
        --11--|--10--|--9--|--8--         =                -----2-----
    
    --> Registers of the form $<stage1>_<stage2>_<regname> indicate pipeline registers. 
*/

module core(
    input clk, 
    input rst,
    output [31:0] executed_inst
    );

    // fetch 
    wire [31:0] phy_address_inst;
    wire [31:0] instruction;
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
    wire sel1;
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
    wire [31:0] phy_address_data;
    wire [31:0] lsu_out;
    wire [31:0] wbmemout;
    wire [3:0] sel;
    wire [1:0] addr_offset;
    wire mwen;
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

    ram ram1(.clk(clk),
             .maddr1(phy_address_inst),
             .maddr2(phy_address_data),
             .mdata1(instruction),
             .mdata2(wbmemout),
             .w_en(mwen),
             .sel(sel),
             .offset(addr_offset));
             
    decode d1(.instruction(ID_IF_INST),
              .rs1(rs1),
              .rs2(rs2),
              .imm(imm),
              .sel1(sel1),
              .addr(addr));
                
    execute e1(.instruction(X_ID_INST),
               .pc(X_ID_PC),
               .op1(X_ID_OP1),
               .op2(X_ID_OP2),
               .offset(X_ID_OFFSET),
               .aluout(memxaluout),
               .addr(memxaddr),
               .branch(branch));
                 
    lsu l1(.aluout(MEM_X_ALUOUT),
           .address(phy_address_data),
           .offset(addr_offset),
           .instruction(MEM_X_INST),
           .memout(wbmemout),
           .out(lsu_out),
           .write(mwen),
           .sel(sel));
             
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
                        
    always@(negedge clk)                                    // the data dependency flag is updated in the negative clock edge    
        DEP_PLACE <= dep_place;
             
             
// **************************************** //             
// Fetch stage

    assign phy_address_inst = ID_IF_PC>>2;
    
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
            else if(DEP_PLACE[2]==1) X_ID_OP1 <= lsu_out;
            else X_ID_OP1 <= rop1;
            
            if(DEP_PLACE[1]==1) X_ID_OP2 <= memxaluout;     // priority is given to bypass path from execute stage
            else if(DEP_PLACE[3]==1) X_ID_OP2 <= lsu_out;
            else X_ID_OP2 <= sel1? {{20{imm[11]}}, imm}:rop2;
        end
        X_ID_PC <= ID_IF_PC;
     end 
 
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
    
    assign phy_address_data = MEM_X_ADDR>>2;
    assign addr_offset = {MEM_X_ADDR[1], MEM_X_ADDR[0]}; 
    
    always@(posedge clk) begin
        WB_MEM_INST<=MEM_X_INST;
        WB_MEM_PC<=MEM_X_PC;
        WB_MEM_OUT <= lsu_out;
    end
    
    assign executed_inst = WB_MEM_INST;
    
endmodule