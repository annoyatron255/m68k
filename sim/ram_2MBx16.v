module ram_2MBx16 (
	input [15:0] data_in,
	output [15:0] data_out,
	input [19:0] addr,
	input OEn,
	input CEn,
	input WEn,
	input UBn,
	input LBn,
	input clk
);

// 2MiB
reg [15:0] ram_2MBx16 [0:1048575];
initial $readmemh("ram_2MBx16.hex", ram_2MBx16);

always @ (posedge clk) begin
	data_out = 16'hZZZZ;
	if (!CEn) begin
		if (WEn && !OEn) begin
			if (!UBn)
				data_out[15:8] = ram_2MBx16[addr][15:8];
			if (!LBn)
				data_out[7:0] = ram_2MBx16[addr][7:0];
		end else if (!WEn) begin
			if (!UBn)
				ram_2MBx16[addr][15:8] = data_in[15:8];
			if (!LBn)
				ram_2MBx16[addr][7:0] = data_in[7:0];
		end
	end
end
endmodule
