module not_gate (
    input wire in1, 
    input wire enable,
    output wire not_out
    );

nand u0 (not_out, enable, in1);

endmodule
