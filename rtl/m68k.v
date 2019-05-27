module m68k (
	input clk12,
	output reg CLK68000 = 0,

	//inout [23:1] addr,
	inout [15:0] data,
	input [23:1] addr,
	//output [15:0] data,

	input ASn,
	//inout R_Wn,
	//inout UDSn,
	//inout LDSn,
	input R_Wn,
	input UDSn,
	input LDSn,
	output reg DTACKn,

	output BRn,
	input BGn,
	output BGACKn,

	output [2:0] IPLn,

	input [2:0] FC,

	input E,
	input VMAn,
	output VPAn,

	output BERRn,
	output HALTn,

	output DATA_OEn,
	output ADDR_OE,
	output reg DIR,

	input RX,
	output TX,

	output SRAM_OEn,
	output SRAM_CEn
);

reg [15:0] data_out;
wire [15:0] data_in;

`ifdef verilator
assign data = DIR ? data_out : 16'hZZZZ;
assign data_in = data;
`else // iCE40
SB_IO #( // Manually instantiate tristate IO because of yosys issues
	.PIN_TYPE(6'b1010_01), // Output: PIN_OUTPUT_TRISTATE Input: PIN_INPUT
	.PULLUP(1'b0) // Disable internal pullup
) m68k_addr [15:0] (
	.PACKAGE_PIN(data),
	.OUTPUT_ENABLE(DIR),
	.D_OUT_0(data_out),
	.D_IN_0(data_in)
);
`endif

always @ (posedge clk12)
	CLK68000 <= ~CLK68000;

// Fix unneeded outputs to defined values
assign BRn = 1;
assign BGACKn = 1;

assign IPLn[2:0] = 3'b111;

assign VPAn = 1;

assign BERRn = 1;
assign HALTn = 1;

assign ADDR_OE = 1;
assign DATA_OEn = 0;

assign SRAM_OEn = 1;
assign SRAM_CEn = 1;

// Allocate boot rom to 8KiB
reg [15:0] boot_rom [0:4095];
`ifdef verilator
//initial $readmemh("../src/build/init.hex", boot_rom); // Directly load boot_rom
initial $readmemh("../src/test.hex", boot_rom); // Directly load boot_rom
`else // iCE40
initial $readmemh("./build/rand.hex", boot_rom); // Load random data for icebram
`endif

// Synchronize control signals
wire ASn_clk12;
sync ASn_sync (
	.clk(clk12),
	.async(ASn),
	.sync(ASn_clk12)
);
wire R_Wn_clk12;
sync R_Wn_sync (
	.clk(clk12),
	.async(R_Wn),
	.sync(R_Wn_clk12)
);

reg [7:0] tx_data;
reg tx_dv;
wire txe_n;
// 115200 baud at 12MHz
UART_TX #(.CLKS_PER_BIT(104)) uart_tx (
	.i_Rst_L(1'b1),
	.i_Clock(clk12),
	.i_TX_DV(tx_dv),
	.i_TX_Byte(tx_data),
	.o_TX_Active(txe_n),
	.o_TX_Serial(TX),
	.o_TX_Done()
);

wire [7:0] rx_data_in;
reg [7:0] rx_data;
wire rx_dv;
reg rxf_n;
UART_RX #(.CLKS_PER_BIT(104)) uart_rx (
	.i_Rst_L(1'b1),
	.i_Clock(clk12),
	.i_RX_Serial(RX),
	.o_RX_DV(rx_dv),
	.o_RX_Byte(rx_data_in)
);

always @ (*) begin
	casez (addr)
		23'h03c000 : data_out = {rx_data, rx_data};
		23'h03e000 : data_out = {16{rxf_n}};
		23'h03e800 : data_out = {16{txe_n}};
		default    : data_out = boot_rom_data_out;
	endcase
end

reg [15:0] boot_rom_data_out;
always @ (posedge clk12) begin
	DTACKn <= 1;
	DIR <= 0;
	tx_dv <= 0;
	tx_data <= 8'hXX;
	boot_rom_data_out <= 16'hXXXX;

	if (rx_dv) begin
		rx_data <= rx_data_in;
		rxf_n <= 0;
	end else if (!ASn_clk12 && R_Wn_clk12 && (addr == 23'h03c000)) begin
		rxf_n <= 1;
	end

	if (!ASn_clk12 && R_Wn_clk12) begin
		boot_rom_data_out <= boot_rom[addr[12:1]];
		DTACKn <= 0;
		DIR <= 1;
	end else if (!ASn_clk12 && !R_Wn_clk12) begin
		if (addr == 23'h03d000) begin
			tx_data <= data_in[15:8];
			tx_dv <= 1;
		end
		boot_rom[addr[12:1]] <= data_in;
		DTACKn <= 0;
		DIR <= 0;
	end
end

endmodule
