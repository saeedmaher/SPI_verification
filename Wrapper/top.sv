import uvm_pkg::*;
import SPI_wrapper_test_pkg::*;

`include "uvm_macros.svh"

module top();
  bit clk;

  // Clock generation
  initial begin
    forever #10 clk = ~clk;
  end

  // Instantiate the interface and DUT
  SPI_wrapper_if wrapper_if (clk);
  RAM_interface ram_if (clk);
  SLAVE_interface spi_if (clk);
  
  WRAPPER            DUT    (wrapper_if.MOSI, wrapper_if.MISO,      wrapper_if.SS_n, wrapper_if.clk, wrapper_if.rst_n);
  SPI_wrapper_golden GOLDEN (wrapper_if.MOSI, wrapper_if.MISO_gold, wrapper_if.SS_n, wrapper_if.clk, wrapper_if.rst_n);

  bind WRAPPER RAM_SVA sva_RAM_inst (.din(DUT.rx_data_din), .clk(wrapper_if.clk), .rst_n(wrapper_if.rst_n),
                                     .rx_valid(DUT.rx_valid), .dout(DUT.tx_data_dout), .tx_valid(DUT.tx_valid));

  bind WRAPPER SPI_wrapper_sva sva_WRAPPER_inst (wrapper_if.MOSI, wrapper_if.MISO, wrapper_if.SS_n, wrapper_if.clk, wrapper_if.rst_n);

  assign ram_if.rst_n           = DUT.rst_n;
  assign ram_if.din             = DUT.rx_data_din;
  assign ram_if.rx_valid        = DUT.rx_valid;
  assign ram_if.dout            = DUT.tx_data_dout;
  assign ram_if.tx_valid        = DUT.tx_valid;
  assign ram_if.dout_golden     = GOLDEN.tx_data;
  assign ram_if.tx_valid_golden = GOLDEN.tx_valid;

  assign spi_if.rst_n           = DUT.rst_n;
  assign spi_if.MOSI            = DUT.MOSI;
  assign spi_if.SS_n            = DUT.SS_n;
  assign spi_if.rx_valid        = DUT.rx_valid;
  assign spi_if.rx_data         = DUT.rx_data_din;
  assign spi_if.tx_valid        = DUT.tx_valid;
  assign spi_if.tx_data         = DUT.tx_data_dout;
  assign spi_if.MISO            = DUT.MISO;
  assign spi_if.MISO_golden     = GOLDEN.MISO;
  assign spi_if.rx_data_golden  = GOLDEN.rx_data;
  assign spi_if.rx_valid_golden = GOLDEN.rx_valid;

  initial begin
    // Set the virtual interface for the uvm test
    uvm_config_db#(virtual SPI_wrapper_if)::set(null, "uvm_test_top", "inter", wrapper_if);
    uvm_config_db#(virtual RAM_interface)::set(null, "uvm_test_top", "RAM_if", ram_if);
    uvm_config_db#(virtual SLAVE_interface)::set(null, "uvm_test_top", "Slave_if", spi_if);
    run_test("SPI_wrapper_test");
  end
endmodule