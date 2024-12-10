module vga_p(clk, o_red, o_blue, o_green, h_sync, v_sync);
	parameter HSYNC = 136, HBPORCH = 160, VSYNC = 6, VBPORCH = 29, HFPORCH = 24, VFPORCH = 3; //XGA Standard
	parameter HDISPLAY = 1024, VDISPLAY = 768;
	parameter BRAM_WIDTH = 24, BRAM_ADDR_BITS = 20;

	input clk; //25MHz clock which is a standard for 60Hz VGA
	output reg [7:0] o_red = 0; 
	output reg [7:0] o_blue = 0; 
	output reg [7:0] o_green = 0;
	output h_sync, v_sync;
	
	wire [BRAM_WIDTH -1 :0] bram_output; //24Bits
	wire [BRAM_ADDR_BITS -1 :0] bram_address; //20Bits
	wire [BRAM_WIDTH -1 :0] bram_input; //24Bits
	
	bram #(.RAM_WIDTH (BRAM_WIDTH), //no of bits in a single RAM location.
		.RAM_ADDR_BITS (BRAM_ADDR_BITS), //no of address bits. 20 bit address mean: 2^20 = 1,048,576 locations.
							//19 address bits mean: 2^19 = 524,288 locations.
							//Total memory locations for the 1024x768 image = 786,432.
		.DATA_FILE ("image_data.txt"),
		.INIT_START_ADDR (0),
		.INIT_END_ADDR (786432)) //(1024x768 - 1)
	bram_inst( .clock(clk), .ram_enable(1'b1), .write_enable(1'b0),  .address(bram_address), .output_data(bram_output), .input_data(bram_input));
	
	 reg [10:0] x_counter = 0;
	 reg [9:0] y_counter = 0;

	always@(posedge clk) begin
		if(x_counter < (HDISPLAY + HSYNC + HBPORCH + HFPORCH -1)) begin  //1024 display + 136 Hsync + 160 HBackPorch + 24 HFrontPorch = 1344 Pixels (0-1343)
			x_counter <= x_counter+1;
		end

		else begin
			x_counter <= 0;
		end
	end
	
	assign bram_address = ((y_counter-(VSYNC+VBPORCH)) * HDISPLAY + (x_counter-(HSYNC+HBPORCH)));
	//y_counter - (VSYNC + VBPORCH) * HDISPLAY : This part calculates the vertical offset from the top of the display area, excluding the vertical sync pulse and the vertical back porch.
	//x_counter - (HSYNC + HBPORCH): This part calculates the horizontal offset from the left of the display area, excluding the horizontal sync pulse and the horizontal back porch.

	always@(posedge clk) begin
		if(x_counter == (HDISPLAY + HSYNC + HBPORCH + HFPORCH - 1)) begin
			if(y_counter < (VDISPLAY + VSYNC + VBPORCH + VFPORCH -1)) begin //768 display + 6 Vsync + 29 VBackPorch + 3 VFrontPorch = 806 Lines (0-805)
				y_counter <= y_counter+1;
			end
			else begin
				y_counter <= 0;
			end
		end
	end
	
	always@(posedge clk) begin
		if((x_counter >= (HSYNC + HBPORCH)) && (x_counter <= (HSYNC + HBPORCH + HDISPLAY - 1)) && (y_counter >= (VSYNC + VBPORCH)) && (y_counter <= (VSYNC + VBPORCH + VDISPLAY -1))) begin // 1320-296 = 1024 (Hsync+HBackPorch = 296, 1023-HFrontPorch = 1319)
			$display("Time=%0t, bram_output=%h", $time, bram_output);
			{o_red, o_green, o_blue} <= {bram_output[7:0], bram_output[15:8], bram_output[23:16]};
		end
		else begin
			{o_red, o_green, o_blue} <= 24'h000000;
		end
	end

	assign h_sync = (x_counter < HSYNC)? 1:0;
	assign v_sync = (y_counter < VSYNC)? 1:0; 
endmodule

