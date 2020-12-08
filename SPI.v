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

	// One-Hot Encoding 
	localparam [2:0] IDLE  = 3'b001,
					 SCLK0 = 3'b010,
					 SCLK1 = 3'b100;


	// Signal Declaration
	reg [1:0] state_reg, state_next;
	reg [7:0] c_reg, c_next;	
	reg       spi_clk_reg,spi_idle_i,spi_done;
	reg [2:0] bit_reg,bit_next;
	reg [7:0] sin_reg,sin_next,sout_reg,sout_next;
	wire spi_clk_next;


// Sequential Block
	always @(posedge clk or posedge rst) 
		if(rst) 
		  begin
		    state_reg 	<= IDLE;
		    c_reg     	<= 0;
		    bit_reg   	<= 0;
		    sin_reg   	<= 0;
		    sout_reg  	<= 0;
		    spi_clk_reg <= 0;
		  end 
		else 
		  begin
	        state_reg 	<= state_next;
		    c_reg     	<= c_next;
		    bit_reg   	<= bit_next;
		    sin_reg   	<= bit_next;
		    sout_reg  	<= sout_next;
		    spi_clk_reg <= spi_clk_next;
		  end

	always @(*) 
	  begin
	    state_next = state_reg;
	    c_next     = c_reg + 1;	// Timer runs continuously
	    bit_next   = bit_reg;
	    sin_next   = sin_reg;
	    sout_next  = sout_reg;
	    spi_idle_i = 1'b0;
	    spi_done   = 1'b0;

	    case (state_reg)
	    	IDLE :  begin
	    		     spi_idle_i = 1'b1;

	    		     if(wr)
	    		       begin
	    		         sout_next  = din;
	    		         state_next = SCLK0;
	    		         bit_next   = 0;
	    		         c_next     = 8'b1;
	    		       end
	    		    end
	    	SCLK0 : begin
	    			  if(c_reg == dvsr)  // spi_clk 0-to-1
	    			    begin
	    			      state_next = SCLK1;
	    			      sin_next   = {sin_reg[6:0],spi_miso};
	    			      c_next     = 8'b1;
	    			    end
	    		    end
	    	SCLK1 : begin
	    			  if (c_reg == dvsr) // spi_clk 1-to-0
	    			    begin
	    			  	  if(bit_reg == 3'b111)
	    			  	    begin
   							  spi_done   = 1'b1;
   							  state_next = IDLE;
	    			  	    end
	    			  	  else
	    			  	    begin 
	    			  	  	  sout_next  = {sout_reg[6:0],1'b0};
	    			  	  	  state_next = SCLK0;
	    			  	  	  bit_next   = bit_reg + 1;
	    			  	  	  c_next     = 8'b1;
	    			  	  	end
	    			    end
	    		    end
	    endcase
	  end

	assign spi_clk_next = (state_next == SCLK1);

	assign dout = sin_reg;
	assign spi_mosi = sout_reg[7];
	assign spi_clk  = spi_clk_reg;
	assign spi_idle = spi_idle_i;

endmodule