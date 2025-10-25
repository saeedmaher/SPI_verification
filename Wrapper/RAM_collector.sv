package RAM_collector_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item_pkg::*;
import shared_pkg::*;
    
    class RAM_collector extends uvm_component;
    `uvm_component_utils(RAM_collector)

        //seq item
        RAM_seq_item seq_item_cvr;
        
        //ports
        uvm_analysis_export #(RAM_seq_item) cvr_export;
        uvm_tlm_analysis_fifo #(RAM_seq_item) cvr_fifo;

        //covergroups
        covergroup RAM_cvr;
            din_cp: coverpoint seq_item_cvr.din[9:8] iff(seq_item_cvr.rst_n) {
                bins write_address = {2'b00};
                bins write_data    = {2'b01};
                bins read_address  = {2'b10};
                bins read_data     = {2'b11};
                bins write_data_after_write_address = (2'b00 => 2'b01);
                bins read_data_after_read_address = (2'b10 => 2'b11);
            }
            rx_valid_CP: coverpoint seq_item_cvr.rx_valid iff(seq_item_cvr.rst_n) {
                bins high = {1};
                bins low = {0};
            }
            tx_valid_CP: coverpoint seq_item_cvr.tx_valid iff(seq_item_cvr.rst_n) {
                bins high = {1};
                bins low = {0};
            }

            din_with_rx: cross din_cp,rx_valid_CP {
                ignore_bins low_tx = binsof(rx_valid_CP.low);
                ignore_bins trans_W = binsof(din_cp.write_data_after_write_address);
                ignore_bins trans_R = binsof(din_cp.read_data_after_read_address);
            }

            din_read_with_tx: cross din_cp,tx_valid_CP {
                option.cross_auto_bin_max = 0;
                bins checked = binsof(din_cp.read_data) && binsof(tx_valid_CP.high);
            } 
        endgroup

        //constructor
        function new(string name = "RAM_collector", uvm_component parent = null);
            super.new(name,parent);
            RAM_cvr = new;
        endfunction //new()

        //build
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cvr_export = new("cvr_export",this);
            cvr_fifo = new ("cvr_fifo",this);
        endfunction

        //connect
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cvr_export.connect(cvr_fifo.analysis_export);
        endfunction

        //run
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cvr_fifo.get(seq_item_cvr);
                RAM_cvr.sample();
            end
        endtask
    endclass 
endpackage