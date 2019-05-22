module ram_2MBx16 (
	input [15:0] data_in,
	output [15:0] data_out,
	input [19:0] addr,
	input OEn,
	input CEn,
	input WEn,
	input UBn,
	input LBn
);

// 2MB
reg [15:0] ram_2MBx16 [0:1048576];
initial $readmemh("ram_2MBx16.hex", ram_2MBx16);

always @ (*) begin
	if (!CEn) begin
		if (!OEn && WEn)
			data_out = ram_2MBx16[addr];
		else if (!WEn)
			ram_2MBx16[addr] = data_in;
		else
			data_out = 16'hZZZZ;
	end else if
		data_out = 16'hZZZZ;
end
