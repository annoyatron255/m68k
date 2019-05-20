module m68k (
	inout [15:0] data,
	inout [23:1] addr,
	input clk12,
	output BERRn,
	inout R_Wn,
	inout UDSn,
	inout LDSn,
	input [2:0] FC,
	input BGn,
	input VMAn,
	input E,
	input ASn,
	output HALTn,
	output RESETn,
	output DTACKn,
	output [2:0] IPLn,
	output BGACKn,
	output BRn,
	output VPAn,
	output DATA_OEn,
	input RX,
	output TX,
	output ADDR_OE
);

assign RESETn = 1;

endmodule
