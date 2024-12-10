# VerilogProjects
# Description of files
*image.jpg* => The image file which has to be displayed using the VGA Controller.
*image_data.txt* => The image.jpg file converted to the 888RGB Hexa Format text file.
*convert.py* => Python Script file for converting the image.jpg to to 888RGB Format.
*bram.v* => 24bit wide Block Ram IP with 20 bit Address for storing the Image's RGB Pixel Data.
*tb_bram.v* => Testbench Specicfically for testing the Block Ram IP.
*vga_p.v* => VGA Controller with 1024x768 Resolution and 60Hz refresh rate (25MHz Clock) having 888RGB Standard output using Block Ram for accessing Pixel Data.
*pipeline.v* => Image Enhancement Pipeline with Brightness and Contrast control.
*top_tb.v* => The testench file for testing and comparing the enchanced and unenhanced RGB outputs.

