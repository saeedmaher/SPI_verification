package RAM_monitor_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item_pkg::*;

    class RAM_monitor extends uvm_monitor;
    `uvm_component_utils(RAM_monitor)

        //virtual interface
        virtual RAM_interface RAM_vif;

        //seq item
        RAM_seq_item seq_item;

        //analysis port
        uvm_analysis_port #(RAM_seq_item) mon_ap;

        //constructor
        function new(string name = "RAM_monitor", uvm_component parent);
            super.new(name,parent);
        endfunction //new()

        //build
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap",this);
        endfunction
        
        //run
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item = RAM_seq_item::type_id::create("seq_item");
                @(negedge RAM_vif.clk);
                seq_item.rst_n = RAM_vif.rst_n;
                seq_item.rx_valid = RAM_vif.rx_valid;
                seq_item.din = RAM_vif.din;
                seq_item.dout = RAM_vif.dout;
                seq_item.tx_valid = RAM_vif.tx_valid;
                //golden outputs
                seq_item.tx_valid_golden = RAM_vif.tx_valid_golden;
                seq_item.dout_golden = RAM_vif.dout_golden;
                //broadcast
                mon_ap.write(seq_item);
            end
        endtask

    endclass 

endpackage