module shifter_32bit (
	input [31:0] reg_s1, reg_s2,
	input wire enable,
	output [31:0] reg_d
);

always@(reg_s1 or reg_s2)
	begin
		reg_d <= reg_s1<<reg_s2;
	end
endmodule
