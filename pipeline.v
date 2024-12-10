module pipeline(clk, opcode, push_button, o_red_pr, o_blue_pr, o_green_pr);
	input [1:0] opcode;
	input clk, push_button;
	output reg [7:0] o_red_pr = 0, o_green_pr = 0, o_blue_pr = 0; //processed outputs from pipeline

	wire [7:0]o_red_vga, o_green_vga, o_blue_vga;
	wire hsync_vga, vsync_vga;
	wire x_counter, y_counter;
	
	vga_p vga_inst(.clk(clk), .o_red(o_red_vga), .o_green(o_green_vga), .o_blue(o_blue_vga), .h_sync(h_sync_vga), .v_sync(v_sync_vga));

	always@(posedge clk) begin
		if((vga_inst.x_counter >= (296)) && (vga_inst.x_counter <= (1319)) && (vga_inst.y_counter >= (35)) && (vga_inst.y_counter <= (805))) begin
			if(push_button==1'b1) begin
				case(opcode)
					2'b00: begin
						if(o_red_vga > 10 || o_green_vga > 10 || o_blue_vga > 10) begin
							o_red_pr <= o_red_vga;
							o_green_pr <= o_green_vga;
							o_blue_pr <= o_blue_vga;
						end
						else begin
							o_red_pr <= o_red_vga + 15;
							o_green_pr <= o_green_vga + 15;
							o_blue_pr <= o_blue_vga + 15;
						end
					end	
	
					2'b01: begin
						if(o_red_vga < 5 || o_green_vga < 5 || o_blue_vga < 5) begin
							o_red_pr <= o_red_vga;
							o_green_pr <= o_green_vga;
							o_blue_pr <= o_blue_vga;
						end
						else begin
							o_red_pr <= o_red_vga - 15;
							o_green_pr <= o_green_vga - 15;
							o_blue_pr <= o_blue_vga - 15;
						end
					end	

					2'b10: begin
						if(o_red_vga >= 198 || o_green_vga >= 198 || o_blue_vga >=198)begin //above 198, the pixel value will exceed 0xFF(255 IN DECIMAL)
							o_red_pr <= o_red_vga;
							o_green_pr <= o_green_vga;
							o_blue_pr <= o_blue_vga;
						end
						
						else begin
							//Original formula ((originalPixel - 128) * 1.2 + 128);  //Formula for contrast adjustment >1 for increment, <1 for decrement 
							//mem_pixel[j][i] = ((OriginalPixel - 128) * 12 + 1280)/10;
							//Since verilog does not support floating point operations and division is very resource expensive.
							//To stay resource efficient, right shift is used 3 times to divide the value by 8 and 11 is used instead of 12. so 11/8 = 1.375
							o_red_pr <= (((o_red_vga - 128) * 11 + 1280) >> 3);
							o_green_pr <= (((o_green_vga - 128) * 11 + 1280) >> 3);
							o_blue_pr <= (((o_blue_vga - 128) * 11 + 1280) >> 3);
							//1.375 would be the factor of contrast increment
	        				end
					end

					2'b11: begin
						o_red_pr <= (((o_red_vga - 128) * 9 + 1280) >> 3);
						o_green_pr <= (((o_green_vga - 128) * 9 + 1280) >> 3);
						o_blue_pr <= (((o_blue_vga - 128) * 9 + 1280) >> 3);
						//Increasing contrast can lead to values exceeding 255 and potentially being clipped.
						//Decreasing contrast will not push values below 0 or above 255 under normal circumstances, as it dampens the extremes.
					end
	
					default: begin
						o_red_pr <= o_red_vga;
						o_green_pr <= o_green_vga;
						o_blue_pr <= o_blue_vga;
					end
				endcase //ending of switch case statement
			end //ending of if block
			
			else begin
				o_red_pr <= o_red_vga;
				o_green_pr <= o_green_vga;
				o_blue_pr <= o_blue_vga;
			end
		end

		else begin			
			o_red_pr <= o_red_vga;
			o_green_pr <= o_green_vga;
			o_blue_pr <= o_blue_vga;

		end //ending of else block
	end  //ending of always block
endmodule
