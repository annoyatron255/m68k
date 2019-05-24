module m68k (
	input clk12,
	output reg CLK68000 = 0,

	//inout [23:1] addr,
	//inout [15:0] data,
	input [23:1] addr,
	output [15:0] data,

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
	output RESETn,
	output HALTn,

	output DATA_OEn,
	output ADDR_OE,
	output reg DIR,

	input RX,
	output TX,

	input [7:0] RX_data,
	output reg [7:0] TX_data,

	output SRAM_OEn
);

reg [15:0] data_out;
wire [15:0] data_in;

//`ifdef __sim__
assign data = DIR ? data_out : 16'hZZZZ;
assign data_in = data;
/*`else // iCE40
SB_IO #( // Manually instantiate tristate IO because of yosys issues
	.PIN_TYPE(6'b1010_01), // Output: PIN_OUTPUT_TRISTATE Input: PIN_INPUT
	.PULLUP(1'b0) // Disable internal pullup
) m68k_addr [15:0] (
	.PACKAGE_PIN(data),
	.OUTPUT_ENABLE(DIR),
	.D_OUT_0(data_out),
	.D_IN_0(data_in)
);
`endif*/

//assign CLK68000 = clk12;
always @ (posedge clk12)
	CLK68000 <= ~CLK68000;


// Fix unneeded outputs to defined values
assign BRn = 1;
assign BGACKn = 1;

assign IPLn[2:0] = 3'b111;

assign VPAn = 1;

assign BERRn = 1;
assign RESETn = 1;
assign HALTn = 1;

assign ADDR_OE = 1;
assign DATA_OEn = 0;

assign SRAM_OEn = 1;

// Allocate boot rom to 2KiB
//reg [15:0] boot_rom [0:1024];
//initial $readmemh("../src/build/init.hex", boot_rom);
reg [15:0] boot_rom [0:1048575];
initial $readmemh("../src/build/monitor.hex", boot_rom);

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

always @ (posedge clk12) begin
	if (!ASn_clk12 && R_Wn_clk12) begin
		if (addr[20:1] == 20'h3c000)
			data_out <= {RX_data, RX_data};
		else
			data_out <= boot_rom[addr[20:1]]; // Read
		DTACKn <= 0;
		DIR <= 1;
	end else if (!ASn_clk12 && !R_Wn_clk12) begin
		if (addr[20:1] == 20'h3d000)
			TX_data <= data_in[15:8];
		boot_rom[addr[20:1]] <= data_in;
		DTACKn <= 0;
		DIR <= 0;
	end else begin
		DTACKn <= 1;
		DIR <= 0;
		TX_data <= 8'h00;
	end
end

endmodule
