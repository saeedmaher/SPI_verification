package SPI_slave_sqr_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_slave_seq_item_pkg::*;

    class SPI_slave_sqr extends uvm_sequencer #(SPI_slave_seq_item);
    `uvm_component_utils(SPI_slave_sqr)

        //constructor
        function new(string name = "SPI_slave_sqr", uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        
    endclass
    
endpackage