module bitwise_or #(parameter WORD_SIZE=32)(
    input wire [31:0] a, 
    input wire [31:0] b,
    output wire [31:0] c
    );
    
    genvar i;
    generate
        for(i=0;i<WORD_SIZE;i=i+1) begin
            or_gate u0(.in1(a[i]), .in2(b[i]), .or_out(c[i]));
        end
    endgenerate
endmodule
