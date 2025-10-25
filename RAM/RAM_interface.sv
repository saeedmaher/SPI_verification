interface RAM_interface (clk);

input clk;

logic [9:0] din;
logic rst_n, rx_valid;

logic [7:0] dout, dout_golden;
logic tx_valid, tx_valid_golden;

endinterface