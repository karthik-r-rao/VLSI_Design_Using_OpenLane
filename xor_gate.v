module xor_gate (
    input wire in1, 
    input wire in2,
    input wire enable,
    output wire xor_out
    );

wire w1, w2;

and u0 (w1, enable, in1);
and u1 (w2, enable, in2);

xor u2 (xor_out, w1, w2);

endmodule
