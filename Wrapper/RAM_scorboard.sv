package RAM_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item_pkg::*;

    class RAM_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(RAM_scoreboard)

        //counters
        int error_counter_ram = 0;
        int correct_counter_ram = 0;

        //seq item 
        RAM_seq_item seq_item;

        //ports
        uvm_analysis_export #(RAM_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(RAM_seq_item) sb_fifo;

        //constructor
        function new(string name = "RAM_scoreboard", uvm_component parent = null);
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
                if (seq_item.dout !== seq_item.dout_golden || seq_item.tx_valid !== seq_item.tx_valid_golden) begin
                    error_counter_ram++;
                    $display("time = %0t dut : out = %d , tx = %d ----- ref : out = %d , tx = %d",$time(),seq_item.dout,seq_item.tx_valid,seq_item.dout_golden,seq_item.tx_valid_golden);
                end else begin
                    correct_counter_ram++;    
                end
            end
        endtask

        //report
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("repo phase",$sformatf("RAM correct times: %0d",correct_counter_ram),UVM_MEDIUM)
            `uvm_info("repo phase",$sformatf("RAM error times: %0d",error_counter_ram),UVM_MEDIUM)
        endfunction

    endclass    
endpackage