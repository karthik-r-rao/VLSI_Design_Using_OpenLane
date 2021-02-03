module or_gate_32bit (
    input wire [31:0] reg_s1, 
    input wire [31:0] reg_s2,
    input wire enable,
    output wire [31:0] reg_d
    );
    
or_gate u0(.in1(reg_s1[0]), .in2(reg_s2[0]), .enable(enable), .or_out(reg_d[0]));
or_gate u1(.in1(reg_s1[1]), .in2(reg_s2[1]), .enable(enable), .or_out(reg_d[1]));
or_gate u2(.in1(reg_s1[2]), .in2(reg_s2[2]), .enable(enable), .or_out(reg_d[2]));
or_gate u3(.in1(reg_s1[3]), .in2(reg_s2[3]), .enable(enable), .or_out(reg_d[3]));
or_gate u4(.in1(reg_s1[4]), .in2(reg_s2[4]), .enable(enable), .or_out(reg_d[4]));
or_gate u5(.in1(reg_s1[5]), .in2(reg_s2[5]), .enable(enable), .or_out(reg_d[5]));
or_gate u6(.in1(reg_s1[6]), .in2(reg_s2[6]), .enable(enable), .or_out(reg_d[6]));
or_gate u7(.in1(reg_s1[7]), .in2(reg_s2[7]), .enable(enable), .or_out(reg_d[7]));
or_gate u8(.in1(reg_s1[8]), .in2(reg_s2[8]), .enable(enable), .or_out(reg_d[8]));
or_gate u9(.in1(reg_s1[9]), .in2(reg_s2[9]), .enable(enable), .or_out(reg_d[9]));
or_gate u10(.in1(reg_s1[10]), .in2(reg_s2[10]), .enable(enable), .or_out(reg_d[10]));
or_gate u11(.in1(reg_s1[11]), .in2(reg_s2[11]), .enable(enable), .or_out(reg_d[11]));
or_gate u12(.in1(reg_s1[12]), .in2(reg_s2[12]), .enable(enable), .or_out(reg_d[12]));
or_gate u13(.in1(reg_s1[13]), .in2(reg_s2[13]), .enable(enable), .or_out(reg_d[13]));
or_gate u14(.in1(reg_s1[14]), .in2(reg_s2[14]), .enable(enable), .or_out(reg_d[14]));
or_gate u15(.in1(reg_s1[15]), .in2(reg_s2[15]), .enable(enable), .or_out(reg_d[15]));
or_gate u16(.in1(reg_s1[16]), .in2(reg_s2[16]), .enable(enable), .or_out(reg_d[16]));
or_gate u17(.in1(reg_s1[17]), .in2(reg_s2[17]), .enable(enable), .or_out(reg_d[17]));
or_gate u18(.in1(reg_s1[18]), .in2(reg_s2[18]), .enable(enable), .or_out(reg_d[18]));
or_gate u19(.in1(reg_s1[19]), .in2(reg_s2[19]), .enable(enable), .or_out(reg_d[19]));
or_gate u20(.in1(reg_s1[20]), .in2(reg_s2[20]), .enable(enable), .or_out(reg_d[20]));
or_gate u21(.in1(reg_s1[21]), .in2(reg_s2[21]), .enable(enable), .or_out(reg_d[21]));
or_gate u22(.in1(reg_s1[22]), .in2(reg_s2[22]), .enable(enable), .or_out(reg_d[22]));
or_gate u23(.in1(reg_s1[23]), .in2(reg_s2[23]), .enable(enable), .or_out(reg_d[23]));
or_gate u24(.in1(reg_s1[24]), .in2(reg_s2[24]), .enable(enable), .or_out(reg_d[24]));
or_gate u25(.in1(reg_s1[25]), .in2(reg_s2[25]), .enable(enable), .or_out(reg_d[25]));
or_gate u26(.in1(reg_s1[26]), .in2(reg_s2[26]), .enable(enable), .or_out(reg_d[26]));
or_gate u27(.in1(reg_s1[27]), .in2(reg_s2[27]), .enable(enable), .or_out(reg_d[27]));
or_gate u28(.in1(reg_s1[28]), .in2(reg_s2[28]), .enable(enable), .or_out(reg_d[28]));
or_gate u29(.in1(reg_s1[29]), .in2(reg_s2[29]), .enable(enable), .or_out(reg_d[29]));
or_gate u30(.in1(reg_s1[30]), .in2(reg_s2[30]), .enable(enable), .or_out(reg_d[30]));
or_gate u31(.in1(reg_s1[31]), .in2(reg_s2[31]), .enable(enable), .or_out(reg_d[31]));

endmodule
