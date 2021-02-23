module and_gate (
    input wire in1, 
    input wire in2,
    output wire and_out
    );

wire w1;

and u1 (and_out, in1, in2);

endmodule
