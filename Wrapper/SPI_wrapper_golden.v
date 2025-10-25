module SPI_wrapper_golden (MOSI,MISO,SS_n,clk,rst_n);

	input MOSI, SS_n, clk, rst_n;
	output MISO;

	// Internal connection wires between SPI and RAM
    wire [9:0] rx_data;
    wire rx_valid;
    wire [7:0] tx_data;
    wire tx_valid;

    SPI_slave_golden SPI_GOLDEN (MOSI, SS_n, clk, rst_n, tx_valid, tx_data, MISO, rx_valid, rx_data);

    RAM_golden RAM_GOLDEN (.clk(clk), .rst_n(rst_n), .rx_valid(rx_valid), .din(rx_data), .tx_valid(tx_valid), .dout(tx_data));
endmodule : SPI_wrapper_golden