`timescale 1ns / 1ps

module set_NZCV(
    input [31:0] carry,
    input [31:0] sum,
    output [3:0] NZCV
    );
    
    wire [30:0] w;
    genvar i;
    generate
        or (w[0], sum[0], sum[1]);
        for(i=1;i<32-1;i=i+1) begin
            or (w[i], w[i-1], sum[i+1]);
        end
    endgenerate
    
    assign NZCV = {sum[31], ~w[30], carry[31], carry[31]^carry[30]};
endmodule
