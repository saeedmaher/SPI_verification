module SPI_slave_top();
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_slave_test_pkg::*;

    //clock generation
    bit clk;
    always begin
        #10
        clk = ~clk;
    end

    //inst of if, design and golden module
     
     //if
     SLAVE_interface slave_if(clk);

     //design
     SLAVE DUT (
     .MOSI(slave_if.MOSI),
     .MISO(slave_if.MISO),
     .SS_n(slave_if.SS_n),
     .clk(clk),
     .rst_n(slave_if.rst_n),
     .rx_data(slave_if.rx_data),
     .rx_valid(slave_if.rx_valid),
     .tx_data(slave_if.tx_data),
     .tx_valid(slave_if.tx_valid)
     );

     //golden module
     SPI_slave_golden golden (
     .MOSI(slave_if.MOSI),
     .MISO(slave_if.MISO_golden),
     .SS_n(slave_if.SS_n),
     .clk(clk),
     .rst_n(slave_if.rst_n),
     .rx_data(slave_if.rx_data_golden),
     .rx_valid(slave_if.rx_valid_golden),
     .tx_data(slave_if.tx_data),
     .tx_valid(slave_if.tx_valid)
     );

     //virtual if to DB and run
     initial begin
        uvm_config_db #(virtual SLAVE_interface)::set(null,"","SLAVE_IF",slave_if);
        run_test("SPI_slave_test");
     end


endmodule