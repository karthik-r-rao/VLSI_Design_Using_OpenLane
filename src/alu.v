`timescale 1ns / 1ps

module alu(
    input [31:0] a,                     // alu operand 1     
    input [31:0] b,                     // alu operand 2
    input cin,                          // carry in for addition and subtraction
    input [31:0] instruction,           // instruction in execute stage
    input [3:0] opcode,                 // signal for choosing output of alu
    input branch,                       // signal to indicate branch taken
    output reg [31:0] out               // output of alu
    );
    
    wire [31:0] and_out;
    wire [31:0] or_out;
    wire [31:0] xor_out;
    wire [31:0] slt_out;
    wire [31:0] sltu_out;
    wire [31:0] sll_out;
    wire [31:0] srl_out;
    wire [31:0] sra_out;
    wire [31:0] add_out;
    wire [31:0] equal_out;
    wire cout;
    wire branch_taken;
                   
    bitwise_and a1(.a(a),
                   .b(b),
                   .c(and_out));        // 0000
    
    bitwise_or a2(.a(a),
                   .b(b),
                   .c(or_out));         // 0001
                   
    bitwise_xor a3(.a(a),
                   .b(b),
                   .c(xor_out));        // 0010
                   
    adder a4(.a(a),
             .b(b),
             .cin(cin),
             .out(add_out),
             .cout(cout));              // 0011 and 0100
             
    slt a5(.a(a),
           .b(b),
           .out(slt_out));              // 0101
           
    sltu a6(.a(a),
            .b(b),
            .out(sltu_out));            // 0110
            
    shift_logical_left a7(.a(a),
                          .b(b[4:0]),
                          .c(sll_out)); // 0111
                          
    shift_logical_right a8(.a(a),
                          .b(b[4:0]),
                          .c(srl_out)); //1000
                          
    shift_arith_right a9(.a(a),
                          .b(b[4:0]),
                          .c(sra_out)); // 1001
                          
    equal a10(.a(a),
              .b(b),
              .out(equal_out)); 
              
    branch_unit a11(.slt_out(slt_out),
                    .sltu_out(sltu_out),
                    .equal_out(equal_out[0]),
                    .branch(branch),
                    .branch_taken(branch_taken),
                    .instruction(instruction));          
            
                          
    always @(*) begin
        casex(opcode)
            4'b0000: out = and_out;    
			4'b0001: out = or_out;      
			4'b0010: out = xor_out;    
			4'b0011, 4'b0100: out = add_out;
			4'b0101: out = slt_out; 
			4'b0110: out = sltu_out;      
			4'b0111: out = sll_out;     
			4'b1000: out = srl_out;    
			4'b1001: out = sra_out;  
			4'b1010: out = {{31{1'b0}}, branch_taken};  			
			default: out = b;
        endcase
    end
endmodule
