module bram
	#(
		parameter RAM_WIDTH 		= 24, //no of bits in a single ram location.
		parameter RAM_ADDR_BITS 	= 20, //no of address bits. 20 bit address means 1,048,576 locations.
							//Total memory locations for the 1024x768 image = 786,432.
		parameter DATA_FILE 		= "image_data.txt",
		parameter INIT_START_ADDR 	= 0,
		parameter INIT_END_ADDR		= 10 
	)
	(
	input							clock,
	input							ram_enable,
	input							write_enable,
    input 		[RAM_ADDR_BITS-1:0]	address,
    input 		[RAM_WIDTH-1:0] 	input_data,
	output reg 	[RAM_WIDTH-1:0] 	output_data
	);
	
   
   (* RAM_STYLE="BLOCK" *)
   reg [RAM_WIDTH-1:0] block_ram [(2**RAM_ADDR_BITS)-1:0];


   //  The forllowing code is only necessary if you wish to initialize the RAM 
   //  contents via an external file (use $readmemb for binary data)
   initial
      $readmemh(DATA_FILE, block_ram, INIT_START_ADDR, INIT_END_ADDR);

   always @(posedge clock)
      if (ram_enable) begin
         if (write_enable)
            block_ram[address] <= input_data;
         output_data <= block_ram[address];
      end

endmodule
						