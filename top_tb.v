`timescale 1ns/1ps

module top_tb();
	reg clk, test_push_button;
	reg [1:0] test_opcode;
	wire [7:0]test_o_red_pr, test_o_green_pr, test_o_blue_pr;
	wire [7:0]test_o_red, test_o_green, test_o_blue;
	wire test_hsync, test_vsync;
	
	pipeline uut(.clk(clk), .o_red_pr(test_o_red_pr), .o_green_pr(test_o_green_pr), .o_blue_pr(test_o_blue_pr), .push_button(test_push_button), .opcode(test_opcode));
	
	vga_p uut1(.clk(clk), .o_red(test_o_red), .o_blue(test_o_blue), .o_green(test_o_green), .h_sync(test_hsync), .v_sync(test_vsync));
	
	initial begin
		clk = 1'b0;
		test_opcode = 2'b00;
		test_push_button = 1'b0;
	end

	always begin
		#20 clk = ~clk;
	end
	
	initial begin
		#5000000 test_push_button = 1'b1;
			test_opcode = 2'b00;
		
		#5500000 test_push_button = 1'b1;
			test_opcode = 2'b01;

		#6000000 test_push_button = 1'b1;
			test_opcode = 2'b10;

		#6500000 test_push_button = 1'b1;
			test_opcode = 2'b11;

		#7000000 test_push_button = 1'b0;
			test_opcode = 2'b11;
	end
	
	initial begin
		#43330560 $finish; //the time for the complete picture to load. 40ns time for a single pixel
	end

endmodule
