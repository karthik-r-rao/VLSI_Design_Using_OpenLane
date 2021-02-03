module and_gate (
    input wire in1, 
    input wire in2,
    input wire enable,
    output wire and_out
    );

wire w1;

and u0 (w1, enable, in1);
and u1 (and_out, w1, in2);

endmodule
