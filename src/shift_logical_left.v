`timescale 1ns / 1ps

// 32 bit mux tree shifter-logical left
module shift_logical_left(
    input [31:0] a,
    input [4:0] b,
    output [31:0] c 
    );
    
    assign c = a<<b;
    
    /*wire [31:0] tmp1, tmp2, tmp3, tmp4;
    genvar i, j;
    generate
        for(j=0;j<1;j=j+1) begin
            assign tmp1[j] = (b[0])?0:a[j];
        end
        for(i=1;i<32;i=i+1) begin
            assign tmp1[i] = (b[0])?a[i-1]:a[i];
        end
    endgenerate
    
    generate
        for(j=0;j<2;j=j+1) begin
            assign tmp2[j] = (b[1])?0:tmp1[j];
        end
        for(i=2;i<32;i=i+1) begin
            assign tmp2[i] = (b[1])?tmp1[i-2]:tmp1[i];
        end
    endgenerate
    
    generate
        for(j=0;j<4;j=j+1) begin
            assign tmp3[j] = (b[2])?0:tmp2[j];
        end
        for(i=4;i<32;i=i+1) begin
            assign tmp3[i] = (b[2])?tmp2[i-4]:tmp2[i];
        end
    endgenerate
    
    generate
        for(j=0;j<8;j=j+1) begin
            assign tmp4[j] = (b[3])?0:tmp3[j];
        end
        for(i=8;i<32;i=i+1) begin
            assign tmp4[i] = (b[3])?tmp3[i-8]:tmp3[i];
        end
    endgenerate
    
    generate
        for(j=0;j<16;j=j+1) begin
            assign c[j] = (b[4])?0:tmp4[j];
        end
        for(i=16;i<32;i=i+1) begin
            assign c[i] = (b[4])?tmp4[i-16]:tmp4[i];
        end
    endgenerate*/
endmodule
