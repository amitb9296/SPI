# SPI (Serial Peripheral Interface) 

The SPI bus is a Synchronous serial protocol. An SPI bus contains One Master and One or more Slave devices. 
It uses three (For One Slave) lines for communication, including one for the clock(SCLK), one for serial data input(MISO), and one for serial data output(MOSI).

The Master generates the clock signal and initiates the data transfer.
There are two shift registers, one in the master and one in the slave. The two shift registers are connected as a ring via the MOSI(Master Out Slave In)and MISO(Master In Slave Out) lines and their operation is controlled by the same clock signal, SCLK

In the beginning of the operation, both the master and the slave load data into the registers. During the data transfer, the data in the both register is shifted to the left by one bit in each SCLK cycle. After eight SCLK cycles, eight data bits are shifted and the master and slave have exchanged register values. The operation can be interpreted that the master writes data to and reads data from the slave simultaneously, which is known as "Full Duplex Operation."

In addition to the MOSI, MISO, and SCLK lines, a slave device may also have an active-low chip select input, SS (for "slave select"). This can be used for the master to select the desired slave device if there are multiple slave devices on the bus.

In SPI, the edges of the SCLK signal are used for shifting and latching a data bit. The operation mode defines the polarity and phase of SCLK with respect to the data bit. 

There are four modes. The master must know the mode of slave devices in advance and generate proper polarity and phase accordingly.
Mode 0, in which the base value of the clock is zero (i.e.,polarity is 0) and data are read at the rising edge and changed at the falling edge (i.e., phase is 0).

Basically, the data bits are placed at the falling edge and retrieved at the rising edge of the SCLK signal. This arrangement eases the timing constraint since the shifting and retrieval are done at opposite edges.

The din port is the 8-bit input data to be transferred and the dout port is the received data. The dvsr port specifies the clock divisor value, which in turn controls the frequency of sclk . The spi.clk , spi_miso, and spi_mosi ports are connected to the clock and data lines of the SPI bus.

In addition, the controller includes an input, wr, which initiates the data transfer, and two status signals, spi_idle and spi_done.

The sin_reg and sout_reg registers are shift registers storing the input and output data, respectively. The input data from spi_miso is sampled and shifted into sin_reg at the rising edge of spi.clk, which occurs when the FSM transits from the sclkO state to the sclk1 state. The MSB of sout_reg is connected to spi_mosi. The old bit is shifted out at the fallingedge of spi.clk, which occurs when the FSM transits from the sclk1 state to the sclkO state. The bit_reg register keeps track of the numbers of bits processed.
