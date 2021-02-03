module xor_gate_32bit (
    input wire [31:0] reg_s1, 
    input wire [31:0] reg_s2,
    input wire enable,
    output wire [31:0] reg_d
    );
    
xor_gate u0(.in1(reg_s1[0]), .in2(reg_s2[0]), .enable(enable), .xor_out(reg_d[0]));
xor_gate u1(.in1(reg_s1[1]), .in2(reg_s2[1]), .enable(enable), .xor_out(reg_d[1]));
xor_gate u2(.in1(reg_s1[2]), .in2(reg_s2[2]), .enable(enable), .xor_out(reg_d[2]));
xor_gate u3(.in1(reg_s1[3]), .in2(reg_s2[3]), .enable(enable), .xor_out(reg_d[3]));
xor_gate u4(.in1(reg_s1[4]), .in2(reg_s2[4]), .enable(enable), .xor_out(reg_d[4]));
xor_gate u5(.in1(reg_s1[5]), .in2(reg_s2[5]), .enable(enable), .xor_out(reg_d[5]));
xor_gate u6(.in1(reg_s1[6]), .in2(reg_s2[6]), .enable(enable), .xor_out(reg_d[6]));
xor_gate u7(.in1(reg_s1[7]), .in2(reg_s2[7]), .enable(enable), .xor_out(reg_d[7]));
xor_gate u8(.in1(reg_s1[8]), .in2(reg_s2[8]), .enable(enable), .xor_out(reg_d[8]));
xor_gate u9(.in1(reg_s1[9]), .in2(reg_s2[9]), .enable(enable), .xor_out(reg_d[9]));
xor_gate u10(.in1(reg_s1[10]), .in2(reg_s2[10]), .enable(enable), .xor_out(reg_d[10]));
xor_gate u11(.in1(reg_s1[11]), .in2(reg_s2[11]), .enable(enable), .xor_out(reg_d[11]));
xor_gate u12(.in1(reg_s1[12]), .in2(reg_s2[12]), .enable(enable), .xor_out(reg_d[12]));
xor_gate u13(.in1(reg_s1[13]), .in2(reg_s2[13]), .enable(enable), .xor_out(reg_d[13]));
xor_gate u14(.in1(reg_s1[14]), .in2(reg_s2[14]), .enable(enable), .xor_out(reg_d[14]));
xor_gate u15(.in1(reg_s1[15]), .in2(reg_s2[15]), .enable(enable), .xor_out(reg_d[15]));
xor_gate u16(.in1(reg_s1[16]), .in2(reg_s2[16]), .enable(enable), .xor_out(reg_d[16]));
xor_gate u17(.in1(reg_s1[17]), .in2(reg_s2[17]), .enable(enable), .xor_out(reg_d[17]));
xor_gate u18(.in1(reg_s1[18]), .in2(reg_s2[18]), .enable(enable), .xor_out(reg_d[18]));
xor_gate u19(.in1(reg_s1[19]), .in2(reg_s2[19]), .enable(enable), .xor_out(reg_d[19]));
xor_gate u20(.in1(reg_s1[20]), .in2(reg_s2[20]), .enable(enable), .xor_out(reg_d[20]));
xor_gate u21(.in1(reg_s1[21]), .in2(reg_s2[21]), .enable(enable), .xor_out(reg_d[21]));
xor_gate u22(.in1(reg_s1[22]), .in2(reg_s2[22]), .enable(enable), .xor_out(reg_d[22]));
xor_gate u23(.in1(reg_s1[23]), .in2(reg_s2[23]), .enable(enable), .xor_out(reg_d[23]));
xor_gate u24(.in1(reg_s1[24]), .in2(reg_s2[24]), .enable(enable), .xor_out(reg_d[24]));
xor_gate u25(.in1(reg_s1[25]), .in2(reg_s2[25]), .enable(enable), .xor_out(reg_d[25]));
xor_gate u26(.in1(reg_s1[26]), .in2(reg_s2[26]), .enable(enable), .xor_out(reg_d[26]));
xor_gate u27(.in1(reg_s1[27]), .in2(reg_s2[27]), .enable(enable), .xor_out(reg_d[27]));
xor_gate u28(.in1(reg_s1[28]), .in2(reg_s2[28]), .enable(enable), .xor_out(reg_d[28]));
xor_gate u29(.in1(reg_s1[29]), .in2(reg_s2[29]), .enable(enable), .xor_out(reg_d[29]));
xor_gate u30(.in1(reg_s1[30]), .in2(reg_s2[30]), .enable(enable), .xor_out(reg_d[30]));
xor_gate u31(.in1(reg_s1[31]), .in2(reg_s2[31]), .enable(enable), .xor_out(reg_d[31]));

endmodule
