`timescale 1ns/10ps
`define __sim__

`include "../rtl/m68k.v"
`include "../rtl/sync.v"
`include "j68_cpu_include.v"

module m68k_tb();

reg clk12 = 0;
reg CLK68000 = 0;

always begin
	clk12 <= !clk12;
	#5;
end
always begin
	CLK68000 <= !CLK68000;
	#50;
end

wire [31:0] addr;
wire [15:0] data;

wire ASn;
wire R_Wn;
wire UDS;
wire LDS;
wire DTACKn;

wire BRn;
wire BGn;
wire BGACKn;

wire [2:0] IPLn;

wire [2:0] FC;

wire E;
wire VMAn;
wire VPAn;

wire BERRn;
wire RESETn;
wire HALTn;

wire DATA_OEn;
wire ADDR_OE;
wire DIR;

wire RX;
wire TX;

wire SRAM_OEn;

m68k m68k_inst(
	.clk12(clk12),
	.CLK68000(),

	.addr(addr[23:1]),
	.data(data),

	.ASn(ASn),
	.R_Wn(R_Wn),
	.UDSn(!UDS),
	.LDSn(!LDS),
	.DTACKn(DTACKn),

	.BRn(BRn),
	.BGn(BGn),
	.BGACKn(BGACKn),

	.IPLn(IPLn),

	.FC(FC),

	.E(E),
	.VMAn(VMAn),
	.VPAn(VPAn),

	.BERRn(BERRn),
	.RESETn(RESETn),
	.HALTn(HALTn),

	.DATA_OEn(DATA_OEn),
	.ADDR_OE(ADDR_OE),
	.DIR(DIR),

	.RX(RX),
	.TX(TX),

	.SRAM_OEn(SRAM_OEn)
);

reg rst = 0;
wire rd_ena;
wire wr_ena;
wire [15:0] wr_data;
wire [15:0] rd_data;
cpu_j68 cpu_j68_inst(
	.rst(rst),
	.clk(CLK68000),
	.clk_ena(1'b1),

	.rd_ena(rd_ena),
	.wr_ena(wr_ena),
	.data_ack(!DTACKn),
	.byte_ena({UDS, LDS}),
	.address(addr),
	.rd_data(rd_data),
	.wr_data(wr_data),
	.fc(FC),
	.ipl_n(IPLn)
);

assign ASn = !(rd_ena || wr_ena);
assign R_Wn = !wr_ena;

assign rd_data = trigger_read ? {in_char, in_char} : data;
assign data = DIR ? 16'hZZZZ : wr_data;

always @(negedge ASn) begin
	if (addr >= 32'h7A000 && addr <= 32'h7BFFF) begin
		$write("%c", data[15:8]);
	end
end

reg trigger_read;
always @(negedge ASn) begin
	if (addr >= 32'h78000 && addr <= 32'h79FFF) begin
		trigger_read <= 1;
	end else
		trigger_read <= 0;
end

initial begin
	$dumpfile("build/dump.vcd");
	$dumpvars;
	rst = 0;
	#5000;
	rst = 1;
	#5000;
	rst = 0;
	#1000000;
	//$finish;
end

reg [7:0] in_char = 8'h00;
initial begin
	in_char = $fgetc(32'h8000_0000);
end

endmodule
