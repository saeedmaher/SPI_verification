module RAM_top();
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_test_pkg::*;

    //clock generation
    bit clk;
    always begin
        #10
        clk = ~clk;
    end

    //inst of if, design and golden module
     
     //if
     RAM_interface RAM_if(clk);

     //design
     RAM DUT (
     .din(RAM_if.din),
     .clk(clk),
     .rst_n(RAM_if.rst_n),
     .rx_valid(RAM_if.rx_valid),
     .dout(RAM_if.dout),
     .tx_valid(RAM_if.tx_valid)
     );

     //golden module
     RAM_golden golden (
     .din(RAM_if.din),
     .clk(clk),
     .rst_n(RAM_if.rst_n),
     .rx_valid(RAM_if.rx_valid),
     .dout(RAM_if.dout_golden),
     .tx_valid(RAM_if.tx_valid_golden)
     );

     //virtual if to DB and run
     initial begin
        uvm_config_db #(virtual RAM_interface)::set(null,"","RAM_IF",RAM_if);
        run_test("RAM_test");
     end
    
    //bind
    bind RAM RAM_SVA assertion_mod (
     .din(RAM_if.din),
     .clk(clk),
     .rst_n(RAM_if.rst_n),
     .rx_valid(RAM_if.rx_valid),
     .dout(RAM_if.dout),
     .tx_valid(RAM_if.tx_valid)
    );

endmodule