`timescale 1ns / 1ps



module FIFO_tb;
	parameter DATA_WIDTH  = 16,
	          DATA_DEPTH  = 32;

	reg  clk   = 0; 
	reg  rst   = 0;
	reg  write = 0;							// write request
	reg  read  = 0;							// read  request
	reg  [DATA_WIDTH-1:0] data_in = 0;		// input data
	wire empty;								// empty flag
	wire full;								// full  flag
	wire [DATA_WIDTH-1:0] data_out;			// data  out


    parameter CLK_PRD = 10;
    
	always #(CLK_PRD/2) clk <= ~clk;


	FIFO #(
		.DATA_WIDTH(DATA_WIDTH),
		.DATA_DEPTH(DATA_DEPTH)
	)FIFO(
		.clk(clk), 
		.rst(rst), 
		.write(write),
		.read(read),
		.data_in(data_in), 
		.empty(empty), 
		.full(full), 
		.data_out(data_out)	
	);
	
	integer i;
	
	initial
	begin
		#(100*CLK_PRD);
		rst = 1;
		#(20*CLK_PRD);
		rst = 0;
		#(100*CLK_PRD);

		write   = 1;
		read    = 0;

		for( i=1; i<33; i=i+1)
		begin
			data_in = i;
			$display("%d", data_out);
		    #(CLK_PRD);
		end			

		write   = 0;
		read    = 1;

		for( i=1; i<33; i=i+1)
		begin
			data_in = i;
			$display("%d", data_out);
		    #(CLK_PRD);
		end		
		
		write   = 1;
		read    = 1;

		for( i=1; i<33; i=i+1)
		begin
			data_in = i;
			$display("%d", data_out);
		    #(CLK_PRD);
		end		
	end
endmodule