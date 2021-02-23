module or_gate (
    input wire in1, 
    input wire in2,
    output wire or_out
    );

or u2 (or_out, in1, in2);

endmodule
