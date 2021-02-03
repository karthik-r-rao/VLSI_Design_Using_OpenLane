module not_gate_32bit (
    input wire [31:0] reg_s1, 
    input wire enable,
    output wire [31:0] reg_d
    );
    
not_gate u0(.in1(reg_s1[0]), .enable(enable), .not_out(reg_d[0]));
not_gate u1(.in1(reg_s1[1]), .enable(enable), .not_out(reg_d[1]));
not_gate u2(.in1(reg_s1[2]), .enable(enable), .not_out(reg_d[2]));
not_gate u3(.in1(reg_s1[3]), .enable(enable), .not_out(reg_d[3]));
not_gate u4(.in1(reg_s1[4]), .enable(enable), .not_out(reg_d[4]));
not_gate u5(.in1(reg_s1[5]), .enable(enable), .not_out(reg_d[5]));
not_gate u6(.in1(reg_s1[6]), .enable(enable), .not_out(reg_d[6]));
not_gate u7(.in1(reg_s1[7]), .enable(enable), .not_out(reg_d[7]));
not_gate u8(.in1(reg_s1[8]), .enable(enable), .not_out(reg_d[8]));
not_gate u9(.in1(reg_s1[9]), .enable(enable), .not_out(reg_d[9]));
not_gate u10(.in1(reg_s1[10]), .enable(enable), .not_out(reg_d[10]));
not_gate u11(.in1(reg_s1[11]), .enable(enable), .not_out(reg_d[11]));
not_gate u12(.in1(reg_s1[12]), .enable(enable), .not_out(reg_d[12]));
not_gate u13(.in1(reg_s1[13]), .enable(enable), .not_out(reg_d[13]));
not_gate u14(.in1(reg_s1[14]), .enable(enable), .not_out(reg_d[14]));
not_gate u15(.in1(reg_s1[15]), .enable(enable), .not_out(reg_d[15]));
not_gate u16(.in1(reg_s1[16]), .enable(enable), .not_out(reg_d[16]));
not_gate u17(.in1(reg_s1[17]), .enable(enable), .not_out(reg_d[17]));
not_gate u18(.in1(reg_s1[18]), .enable(enable), .not_out(reg_d[18]));
not_gate u19(.in1(reg_s1[19]), .enable(enable), .not_out(reg_d[19]));
not_gate u20(.in1(reg_s1[20]), .enable(enable), .not_out(reg_d[20]));
not_gate u21(.in1(reg_s1[21]), .enable(enable), .not_out(reg_d[21]));
not_gate u22(.in1(reg_s1[22]), .enable(enable), .not_out(reg_d[22]));
not_gate u23(.in1(reg_s1[23]), .enable(enable), .not_out(reg_d[23]));
not_gate u24(.in1(reg_s1[24]), .enable(enable), .not_out(reg_d[24]));
not_gate u25(.in1(reg_s1[25]), .enable(enable), .not_out(reg_d[25]));
not_gate u26(.in1(reg_s1[26]), .enable(enable), .not_out(reg_d[26]));
not_gate u27(.in1(reg_s1[27]), .enable(enable), .not_out(reg_d[27]));
not_gate u28(.in1(reg_s1[28]), .enable(enable), .not_out(reg_d[28]));
not_gate u29(.in1(reg_s1[29]), .enable(enable), .not_out(reg_d[29]));
not_gate u30(.in1(reg_s1[30]), .enable(enable), .not_out(reg_d[30]));
not_gate u31(.in1(reg_s1[31]), .enable(enable), .not_out(reg_d[31]));

endmodule
