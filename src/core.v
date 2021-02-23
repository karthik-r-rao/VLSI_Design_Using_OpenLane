`timescale 1ns / 1ps

/*
    5-stage in-order RISC-V core.
    
    -->The core currently supports the arithmetic, logical, bitwise, load, store and branch instructions 
    listed in RV32I Instruction Set Manual.
    
    -->No support for data hazards and control hazards have been added so far.
    
    -->In the event of a branch taken, the next two instructions in the pipe are replaced by NOP, defined as 
    NOP = ADDI R0, R0, #0. 
    
    -->Loads and Stores are tested on a 32*1024 RAM implemented with registers. The lower section of the RAM region is
    reserved for instructions, and the higher section can be used for storing data. 
    A scheme of logical and physical addresses is used as implementing an 8*1024 RAM with 32 bit access is quite tough in hardware. 
    In this, the logical address is byte-addressable, and supports LB, LH, LBU, LHU, SB, and SH instructions apart from LW and SW.
    This logical address is shifted right 2 places to get the physical address. For ex:
    Suppose logical address (user view) = 97
    The required data is actually the bits [15:8] stored at address 24.
    97>>2 = 97/4 = 24.
    97%4 = 1.
    
    Logical address view                            Physical Address view
    (each location-8 bit)                           (each location-32 bit)
    --3--|--2--|--1--|--0--         =                -----0-----
    --7--|--6--|--5--|--4--         =                -----1-----
    --11--|--10--|--9--|--8--       =                -----2-----
    
    -->Registers of the form $<stage1>_<stage2>_<regname> indicate pipeline registers. 
*/
module core(
    input clk, 
    input rst
    );

    // clock buffer    
    wire clk1 [1:0];
    assign clk1[0] = ~clk;
    assign clk1[1] = ~clk1[0];

    // fetch 
    wire [31:0] phy_address_inst;
    wire [31:0] instruction;
    reg [31:0] ID_IF_PC;
    reg [31:0] next_pc;
    
    // decode
    wire [31:0] xidop1;
    wire [31:0] xidop2;
    wire [31:0] xidbo;
    reg [31:0] X_ID_INST;
    reg [31:0] X_ID_PC;
    reg [31:0] X_ID_OP1;
    reg [31:0] X_ID_OP2;
    reg [31:0] X_ID_BRANCH_OFFSET;

    // execute
    wire [31:0] memxaluout;
    wire [31:0] memxba;
    reg [31:0] MEM_X_INST;
    reg [31:0] MEM_X_PC;
    reg [31:0] MEM_X_ALUOUT;
    wire memxbt;
    reg [31:0] MEM_X_BRANCH_ADDR;
    reg MEM_X_BRANCH_TAKEN;
    
    // memory access
    wire [31:0] phy_address_data;
    wire [31:0] wbmemout;
    wire [31:0] out;
    wire [3:0] sel;
    wire [1:0] offset;
    wire mwen;
    reg [31:0] WB_MEM_PC;
    reg [31:0] WB_MEM_INST;
    reg [31:0] WB_MEM_OUT;
    
    // register write back
    wire [4:0] rd;
    wire rwen;
    
// **************************************** //

    ram ram1(.clk(clk),
             .maddr1(phy_address_inst),
             .maddr2(phy_address_data),
             .mdata1(instruction),
             .mdata2(wbmemout),
             .w_en(mwen),
             .sel(sel),
             .offset(offset));
             
// **************************************** //             
// Fetch stage

    assign phy_address_inst = ID_IF_PC>>2;
    
    always@(posedge clk) begin
        if(rst) begin
            ID_IF_PC <= 0;
            next_pc <= 4;
            end
        else if(MEM_X_BRANCH_TAKEN) begin
            ID_IF_PC <= MEM_X_BRANCH_ADDR;
            next_pc <= MEM_X_BRANCH_ADDR + 4;
            end
        else begin
            ID_IF_PC <= next_pc;
            next_pc <= next_pc+4;
            end
    end
    
// **************************************** //
// Decode stage
 
    decode d1(.clk(clk),
                .w_en(rwen),
                .instruction(instruction),
                .wdata(WB_MEM_OUT),
                .wd(rd),
                .op1(xidop1),
                .op2(xidop2),
                .branch_offset(xidbo));
                
     always@(posedge clk1[1]) begin
        if(MEM_X_BRANCH_TAKEN) begin
            X_ID_INST <= 32'h00000013; // addi r0, r0, #0; nop
            X_ID_OP1 <= 0;
            X_ID_OP2 <= 0;
            X_ID_BRANCH_OFFSET <= 0;
        end
        else begin
            X_ID_INST <= instruction;
            X_ID_OP1 <= xidop1;
            X_ID_OP2 <= xidop2;
            X_ID_BRANCH_OFFSET <= xidbo;
        end
        X_ID_PC <= ID_IF_PC;
     end 
 
 // **************************************** // 
 // Execute stage
    
    execute e1(.clk(clk),
                .instruction(X_ID_INST),
                .pc(X_ID_PC),
                .op1(X_ID_OP1),
                .op2(X_ID_OP2),
                .branch_offset(X_ID_BRANCH_OFFSET),
                .aluout(memxaluout),
                .bt(memxbt),
                .branch_addr(memxba)
                );
                
    always@(posedge clk1[1]) begin
        if(MEM_X_BRANCH_TAKEN) begin
            MEM_X_INST<=32'h00000013; // addi r0, r0, #0; nop
            MEM_X_ALUOUT <= 0;
            MEM_X_BRANCH_TAKEN <= 0;
            MEM_X_BRANCH_ADDR <= 0;
        end
        else begin
            MEM_X_INST<=X_ID_INST;
            MEM_X_ALUOUT <= memxaluout;
            MEM_X_BRANCH_TAKEN <= memxbt;
            MEM_X_BRANCH_ADDR <= memxba;
        end
        MEM_X_PC<=X_ID_PC;
    end
    
// **************************************** //
// Memory access stage
    
    assign phy_address_data = MEM_X_BRANCH_ADDR>>2;
    assign offset = {MEM_X_BRANCH_ADDR[1], MEM_X_BRANCH_ADDR[0]}; 
    
    lsu l1(.aluout(MEM_X_ALUOUT),
    .address(phy_address_data),
    .offset(offset),
    .instruction(MEM_X_INST),
    .memout(wbmemout),
    .out(out),
    .write(mwen),
    .sel(sel));
    
    always@(posedge clk1[1]) begin
        WB_MEM_INST<=MEM_X_INST;
        WB_MEM_PC<=MEM_X_PC;
        WB_MEM_OUT <= out;
    end
    
// **************************************** //
// Register writeback stage

    writeback w1(.instruction(WB_MEM_INST),
                    .w_en(rwen),
                    .rd(rd));
    
endmodule