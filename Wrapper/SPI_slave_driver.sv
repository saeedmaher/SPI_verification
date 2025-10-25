package SPI_slave_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_slave_seq_item_pkg::*;
import shared_pkg::*;

    class SPI_slave_driver extends uvm_driver #(SPI_slave_seq_item);
    `uvm_component_utils (SPI_slave_driver)

        //virtual interface
        virtual SLAVE_interface SPI_slave_vif;

        //seq item
        SPI_slave_seq_item seq_item;

        //constructor
        function new(string name = "SPI_slave_driver", uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        //build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction

        //run
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item = SPI_slave_seq_item::type_id::create("seq_item");
                seq_item_port.get_next_item(seq_item);
                SPI_slave_vif.rst_n = seq_item.rst_n;
                SPI_slave_vif.MOSI = seq_item.MOSI;
                SPI_slave_vif.SS_n = seq_item.SS_n;
                SPI_slave_vif.tx_valid = seq_item.tx_valid;
                SPI_slave_vif.tx_data = seq_item.tx_data;
                @(negedge SPI_slave_vif.clk);
                seq_item_port.item_done();
            end
        endtask
    endclass


    
endpackage