package SPI_slave_collector_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_slave_seq_item_pkg::*;
import shared_pkg::*;
    
    class SPI_slave_collector extends uvm_component;
    `uvm_component_utils(SPI_slave_collector)

        //seq item
        SPI_slave_seq_item seq_item_cvr;
        
        //ports
        uvm_analysis_export #(SPI_slave_seq_item) cvr_export;
        uvm_tlm_analysis_fifo #(SPI_slave_seq_item) cvr_fifo;

        //covergroups
        covergroup cvg_group;
            rx_data_CP: coverpoint seq_item_cvr.rx_data[9:8] iff(seq_item_cvr.rst_n) {
                bins write_address = {2'b00};
                bins write_data    = {2'b01};
                bins read_address  = {2'b10};
                bins read_data     = {2'b11};
                bins trans1[]      = (2'b00 => 2'b01,2'b10);
                bins trans2[]      = (2'b01 => 2'b00,2'b11);
                bins trans3[]      = (2'b10 => 2'b00,2'b11);
                bins trans4[]      = (2'b11 => 2'b01,2'b10);
            }
            SS_n_CP: coverpoint seq_item_cvr.SS_n iff(seq_item_cvr.rst_n){
                bins full_normal_seq = (1 => 0[*13] => 1);
                bins full_read_seq = (1 => 0[*23] => 1);

                bins start_comm = (1 => 0[*4]);
            }
            MOSI_transitions_CP: coverpoint seq_item_cvr.MOSI iff((count <= 4) && (count >= 2)) {
                bins write_address = (0 => 0 => 0);
                bins write_data    = (0 => 0 => 1);
                bins read_address  = (1 => 1 => 0);
                bins read_data     = (1 => 1 => 1);
            }
            SS_n_with_MOSI: cross SS_n_CP,MOSI_transitions_CP iff(seq_item_cvr.rst_n) {
                //as the full seq will be hit in the end of comm while the MISO seq will be at the start of comm
                illegal_bins full_seq1 = binsof(SS_n_CP.full_normal_seq);
                illegal_bins full_seq2 = binsof(SS_n_CP.full_read_seq);
            }

        endgroup

        //constructor
        function new(string name = "SPI_slave_collector", uvm_component parent = null);
            super.new(name,parent);
            cvg_group = new;
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
                cvg_group.sample();
            end
        endtask
    endclass 
endpackage