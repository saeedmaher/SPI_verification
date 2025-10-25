package SPI_wrapper_scoreboard_pkg;
	import uvm_pkg::*;
	import SPI_wrapper_seq_item_pkg::*;
	
	`include "uvm_macros.svh"

	class SPI_wrapper_scoreboard extends uvm_scoreboard;
		`uvm_component_utils(SPI_wrapper_scoreboard)
		uvm_analysis_export #(SPI_wrapper_seq_item) sb_exp;
		uvm_tlm_analysis_fifo #(SPI_wrapper_seq_item) sb_fifo;
		SPI_wrapper_seq_item seq_item;

		int correct_count = 0 , error_count = 0;

		function new(string name = "SPI_wrapper_scoreboard" , uvm_component parent = null);
			super.new(name,parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sb_exp = new("sb_exp",this);
			sb_fifo = new("sb_fifo",this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			sb_exp.connect(sb_fifo.analysis_export);
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
		 	super.run_phase(phase);

		 	forever begin
		 		sb_fifo.get(seq_item);
		 		if(seq_item.MISO === seq_item.MISO_gold)
		 			correct_count++;
		 		else begin
		 			error_count++;
		 			$display("time:%0t SS_n =%b dut out = %b , ref out = %b",$time,seq_item.SS_n,seq_item.MISO,seq_item.MISO_gold);
		 		end
		 	end
		 endtask : run_phase

		 function void report_phase(uvm_phase phase);
		 	super.report_phase(phase);
		 	`uvm_info("repo phase",$sformatf("SPI wrapper correct times: %0d",correct_count),UVM_MEDIUM)
            `uvm_info("repo phase",$sformatf("SPI wrapper error times: %0d",error_count),UVM_MEDIUM)
		 endfunction : report_phase
		
	endclass : SPI_wrapper_scoreboard
endpackage : SPI_wrapper_scoreboard_pkg