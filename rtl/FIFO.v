`timescale 1ns / 1ps



module FIFO #(
	parameter DATA_WIDTH  = 16,
	parameter DATA_DEPTH  = 1024         // must be power of 2

)(
	input 	clk, 
	input   rst,
	input   write,							// write request
	input   read, 							// read  request
	input   [DATA_WIDTH-1:0] data_in,		// input data
	output  [DATA_WIDTH-1:0] data_out,	    // data  out
	output  reg empty,					    // empty flag
	output  reg full     					// full  flag
);

	reg [$clog2(DATA_DEPTH)-1 : 0] wr_idx;	// wr index
	reg [$clog2(DATA_DEPTH)-1 : 0] rd_idx;	// rd index
	wire wr_en;							    // write enable
	reg  rd_en;
    
    
    assign wr_en = (write && ~full) ? 1'b1 : 1'b0;

    
	bram_dual_one_clk #(
	   .DATA_WIDTH(DATA_WIDTH),
	   .DATA_DEPTH(DATA_DEPTH)
	) BRAM(
		.clk(clk), 
		.ena(1'b1), 
		.enb(rd_en),
		.wea(wr_en),
		.addra(wr_idx), 
		.addrb(rd_idx), 
		.dia(data_in), 
		.dob(data_out)	
	);
	
	
	// Read & Write Operations
	always @(posedge clk, posedge rst)
	begin
		if (rst)
		begin
			empty     <= 1'b1;
			full	  <= 1'b0;
			wr_idx    <= 0;
			rd_idx    <= 0;
			rd_en     <= 0;
		end
		else
		begin
			// Write Operation:
			if( write && ~full )
			begin
				wr_idx  <= wr_idx + 1'b1;
				if( ( wr_idx+1'b1 == rd_idx ) && ~read )  
					full  <= 1'b1;
				else
					empty <= 1'b0;                  
			end

			// Read Operation:			
			if( read && ~empty )
			begin
			    rd_en   <= 1;
				rd_idx  <= rd_idx + 1'b1;
				if( ( wr_idx == rd_idx+1'b1 ) && ~write  )
					empty   <= 1'b1;
				else
					full    <= 1'b0;
			end
			else
			begin
			    rd_en   <= 0;			
			end
		end
	end
endmodule