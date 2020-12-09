`timescale 10ns/1ns

module tb_spi;
	reg 		 clk;    // Clock
	reg 		 rst;    // Asynchronous reset active high
	reg  [7:0]   din,dvsr;
	reg 		 wr;
	wire [7:0]   dout;
	wire         spi_clk,spi_mosi;
	reg          spi_miso;
	wire         spi_done, spi_idle;

spi dut(clk,rst,din,dvsr,wr,dout,spi_clk,spi_mosi,
        spi_miso,spi_done, spi_idle);


	initial
	  begin 

	  	// Dump File
	  	$dumpfile("spi.dmp");	// Simulation info dumped to spi.dmp	
	  	$dumpvars;			 	// Dump all the signals in the design.

	  	clk  	 = 0;
	  	rst  	 = 1;
	  	din  	 = 8'b0;
	  	dvsr 	 = 8'b0;
	  	wr   	 = 1;
	  	spi_miso = 0;
	  
	  	#100;
	  	rst  	 = 0;
	  	wr   	 = 1;
	  	spi_miso = 0;
	  	dvsr 	 = 8'd7;
	  	repeat(4)
	  		#9000	din  = $random;

	  	#20000 $stop;

	  end
    
    // Clock Source
	always #50 clk = ~clk;

endmodule
