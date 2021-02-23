`timescale 1ns / 1ps

module adder(
    input [31:0] a,
    input [31:0] b,
    input cin,
    output [31:0] out,
    output [3:0] NZCV
    );
    
    wire [31:0] carry_bits;
    genvar i;
    generate
        full_adder unit0(.in1(a[0]),
                            .in2(b[0]), 
                            .sub(cin), 
                            .cin(cin), 
                            .sum(out[0]), 
                            .co(carry_bits[0]));
        for(i=1;i<32;i=i+1) begin
            full_adder unit1(.in1(a[i]),
                            .in2(b[i]), 
                            .sub(cin), 
                            .cin(carry_bits[i-1]), 
                            .sum(out[i]), 
                            .co(carry_bits[i]));
        end
    endgenerate
    
    set_NZCV nzcv(.carry(carry_bits),
                  .sum(out),
                  .NZCV(NZCV));
endmodule
