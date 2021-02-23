module xor_gate (
    input wire in1, 
    input wire in2,
    output wire xor_out
    );

xor u2 (xor_out, in1, in2);

endmodule
