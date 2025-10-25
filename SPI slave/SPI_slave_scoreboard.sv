package SPI_slave_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_slave_seq_item_pkg::*;

    class SPI_slave_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(SPI_slave_scoreboard)

        //counters
        int error_counter_slave = 0;
        int correct_counter_slave = 0;

        //seq item 
        SPI_slave_seq_item seq_item;

        //ports
        uvm_analysis_export #(SPI_slave_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(SPI_slave_seq_item) sb_fifo;

        //constructor
        function new(string name = "SPI_slave_scoreboard", uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_exprt",this);
            sb_fifo = new("sb_fifo",this);
        endfunction

        //connect
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        //run 
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item);
                if (seq_item.rx_data != seq_item.rx_data_golden ||
                    seq_item.rx_valid != seq_item.rx_valid_golden ||
                    seq_item.MISO != seq_item.MISO_golden ) begin
                    error_counter_slave++;
                end else begin
                    correct_counter_slave++;
                end
            end
        endtask

        //report
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("repo phase",$sformatf("Slave correct times: %0d",correct_counter_slave),UVM_MEDIUM)
            `uvm_info("repo phase",$sformatf("Slave error times: %0d",error_counter_slave),UVM_MEDIUM)
        endfunction

    endclass    
endpackage