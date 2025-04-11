`timescale 1ns / 1ps



module FIFO #(
	parameter DATA_WITH   = 16,
	parameter DATA_DEPTH  = 1024

)(
	input 	clk, 
	input   rst,
	input   write,							// write request
	input   read, 							// read  request
	input   [DATA_WITH-1:0] data_in,		// input data
	output  [DATA_WITH-1:0] data_out,		// data  out
	output  reg empty_flag,					// empty flag
	output  reg full_flag					// full  flag
);

	reg signed [$clog2(DATA_DEPTH)-1 : 0] wr_idx;	// wr index
	reg signed [$clog2(DATA_DEPTH)-1 : 0] rd_idx;	// rd index
	
	reg wr_en;							            // write enable
	reg [DATA_WITH-1:0] data_wr;                    // data to be written
    reg empty;                                      // empty flag register
    reg full;                                       // full flag register


	bram_dual_one_clk #(
	   .DATA_WITH(DATA_WITH),
	   .DATA_DEPTH(DATA_DEPTH)
	) BRAM(
		.clk(clk), 
		.ena(1'b1), 
		.enb(1'b1),
		.wea(wr_en),
		.addra(wr_idx), 
		.addrb(rd_idx), 
		.dia(data_wr), 
		.dob(data_out)	
	);
	
	
	// Flag Registers
	always @(posedge clk, posedge rst)
	begin
	   if(rst)
	   begin
           empty_flag <= 0;
           full_flag  <= 0;	   
	   end
	   else
	   begin
           empty_flag <= empty;
           full_flag  <= full;
       end
	end
	
	
	// Read & Write Operations
	always @(posedge clk, posedge rst)
	begin
		if (rst)
		begin
			empty     <= 1'b1;
			full	  <= 1'b0;
			wr_idx    <= 0;
			rd_idx    <= 0;
			wr_en     <= 0;
			data_wr   <= 0;
		end
		else
		begin
			// Write Operation:
			if( write && ~full )
			begin
				wr_en   <= 1'b1;
				wr_idx  <= wr_idx + 1;
				data_wr <= data_in;
				if( ( wr_idx == rd_idx-1 ) && ~read )  
					full  <= 1'b1;
				else
					empty <= 1'b0;                  
			end
			else
			begin
				wr_en   <= 0;		
				data_wr <= 0;	
			end

			// Read Operation:			
			if( read && ~empty )
			begin
				rd_idx  <= rd_idx + 1;
				if( ( wr_idx-1 == rd_idx ) && ~write  )
					empty   <= 1'b1;
				else
					full    <= 1'b0;
			end
		end
	end
endmodule