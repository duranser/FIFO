`timescale 1ns / 1ps


module bram_dual_one_clk #(
	parameter DATA_WITH   = 16,
	parameter DATA_DEPTH  = 1024
)(
	input clk,
	input ena,
	input enb,
	input wea,
	input  [$clog2(DATA_DEPTH)-1 : 0]  addra,
	input  [$clog2(DATA_DEPTH)-1 : 0]  addrb,
	input  [DATA_WITH-1:0] dia,
	output reg [DATA_WITH-1:0] dob
);

	reg [DATA_WITH-1:0] ram [DATA_DEPTH-1:0];

	always @(posedge clk) 
	begin
		if (ena) 
		begin
			if (wea)
				ram[addra] <= dia;
		end
	end

	always @(posedge clk) 
	begin
		if (enb)
			dob <= ram[addrb];
	end

endmodule