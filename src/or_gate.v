module or_gate (
    input wire in1, 
    input wire in2,
    input wire enable,
    output wire or_out
    );

wire w1, w2;

and u0 (w1, enable, in1);
and u1 (w2, enable, in2);

or u2 (or_out, w1, w2);

endmodule
