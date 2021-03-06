`timescale 1ns/10ps
`define __sim__

`include "../rtl/m68k.v"
`include "../rtl/sync.v"
`include "j68_cpu_include.v"
`include "../rtl/UART_TX.v"
`include "../rtl/UART_RX.v"

module m68k_tb(
	input clk,
	input rst,

	input [7:0] TX_data,
	input TX_start,
	output TX_active,
	//output [7:0] RX_data,
	//input TXE,
	//output TX_read
	output RX_DV,
	output [7:0] RX_data
);

wire CLK68000;

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
wire HALTn;

wire DATA_OEn;
wire ADDR_OE;
wire DIR;

wire RX;
wire TX;

wire SRAM_OEn;
wire SRAM_CEn;

UART_RX #(.CLKS_PER_BIT(104)) uart_rx_tb (
	.i_Rst_L(1'b1),
	.i_Clock(clk),
	.i_RX_Serial(TX),
	.o_RX_DV(RX_DV),
	.o_RX_Byte(RX_data)
);

UART_TX #(.CLKS_PER_BIT(104)) uart_tx_tb (
	.i_Rst_L(1'b1),
	.i_Clock(clk),
	.i_TX_DV(TX_start),
	.i_TX_Byte(TX_data),
	.o_TX_Active(TX_active),
	.o_TX_Serial(RX),
	.o_TX_Done()
);

m68k m68k_inst(
	.clk12(clk),
	.CLK68000(CLK68000),

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
	.HALTn(HALTn),

	.DATA_OEn(DATA_OEn),
	.ADDR_OE(ADDR_OE),
	.DIR(DIR),

	.RX(RX),
	.TX(TX),

	.SRAM_OEn(SRAM_OEn),
	.SRAM_CEn(SRAM_CEn)
);
/* verilator lint_off PINMISSING */
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
	.ipl_n(IPLn),

);

assign ASn = !(rd_ena || wr_ena);
assign R_Wn = !wr_ena;

assign rd_data = data;
assign data = DIR ? 16'hZZZZ : wr_data;

endmodule
