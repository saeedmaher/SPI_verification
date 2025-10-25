package RAM_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item_pkg::*;
//import RAM_config_pkg::*;
import shared_pkg::*;

    class RAM_driver extends uvm_driver #(RAM_seq_item);
    `uvm_component_utils (RAM_driver)

        //virtual interface
        virtual RAM_interface RAM_vif;

        //seq item
        RAM_seq_item seq_item;

        //constructor
        function new(string name = "RAM_driver", uvm_component parent = null);
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
                seq_item = RAM_seq_item::type_id::create("seq_item");
                seq_item_port.get_next_item(seq_item);
                RAM_vif.rst_n = seq_item.rst_n;
                RAM_vif.din = seq_item.din;
                RAM_vif.rx_valid = seq_item.rx_valid;
                @(negedge RAM_vif.clk);
                seq_item_port.item_done();
            end
        endtask
    endclass //className extends superClass


    
endpackage