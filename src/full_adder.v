`timescale 1ns / 1ps

module full_adder (
    input wire in1, 
    input wire in2,
    input wire sub,
    input wire cin,
    output wire sum,
    output wire co    
    );

wire w4, w5, w6, w7;

xor u3 (w4, in2, sub);

xor u4 (w5, in1, w4);
xor u5 (sum, w5, cin);
and u6 (w6, in1, w4);
and u7 (w7, w5, cin);
or  u8 (co, w6, w7);

endmodule
