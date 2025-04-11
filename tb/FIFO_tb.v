`timescale 1ns / 1ps



module FIFO_tb;
	parameter DATA_WITH   = 16,
	          DATA_DEPTH  = 32;

	reg  clk   = 0; 
	reg  rst   = 0;
	reg  write = 0;							// write request
	reg  read  = 0;							// read  request
	reg  [DATA_WITH-1:0] data_in = 0;		// input data
	wire empty;								// empty flag
	wire full;								// full  flag
	wire [DATA_WITH-1:0] data_out;			// data  out


	always #10 clk <= ~clk;


	FIFO #(
		.DATA_WITH (DATA_WITH),
		.DATA_DEPTH(DATA_DEPTH)
	)FIFO(
		.clk(clk), 
		.rst(rst), 
		.write(write),
		.read(read),
		.data_in(data_in), 
		.empty_flag(empty), 
		.full_flag(full), 
		.data_out(data_out)	
	);
	
	integer i;
	
	initial
	begin
		repeat(50) @(posedge clk);
		rst = 1;
		repeat(50) @(posedge clk);
		rst = 0;
		repeat(50) @(posedge clk);
        
		write   = 1;
		read    = 0;
		for( i=1; i<33; i=i+1)
		begin
			data_in = i;
			$display("%d", data_out);
			@(posedge clk);
		end			
		write   = 0;

		@(posedge clk);
		write   = 0;
		read    = 1;
		for( i=1; i<33; i=i+1)
		begin
			data_in = i;
			$display("%d", data_out);
			@(posedge clk);
		end		
	end
endmodule