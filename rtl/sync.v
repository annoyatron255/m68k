module sync(
	input clk,
	input async,
	output reg sync
)

reg r1;

always @ (posedge clk) begin
	r1 <= async;
	sync <= r1;
end

endmodule
