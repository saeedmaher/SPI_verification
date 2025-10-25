interface SPI_wrapper_if (clk);
	input bit clk;

	logic MOSI, SS_n, rst_n;
	logic MISO, MISO_gold;
endinterface : SPI_wrapper_if