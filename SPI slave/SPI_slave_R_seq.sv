package SPI_slave_reset_seq_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_slave_seq_item_pkg::*;
//import shared_pkg::*;
    
    class SPI_slave_reset_seq extends uvm_sequence #(SPI_slave_seq_item);
    `uvm_object_utils(SPI_slave_reset_seq)

        //seq item
        SPI_slave_seq_item seq_item;

        //construcotr
        function new(string name = "SPI_slave_reset_seq");
            super.new(name);
        endfunction //new()

        //body
        task body();
            seq_item = SPI_slave_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n = 0;
            seq_item.MOSI = 1;
            seq_item.SS_n = 0;
            seq_item.tx_valid = 0;
            seq_item.tx_data = 4;
            finish_item(seq_item);
        endtask

    endclass //className extends superClass
endpackage