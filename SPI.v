// SPI

module spi (
	input 		 clk,    // Clock
	input 		 rst,    // Asynchronous reset active high
	input  [7:0] din,dvsr,
	input 		 wr,
	output [7:0] dout,
	output       spi_clk,spi_mosi,
	input        spi_miso,
	output       spi_done, spi_idle
);


endmodule