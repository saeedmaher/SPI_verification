package SPI_wrapper_cover_collect_pkg;
	import uvm_pkg::*;
	import SPI_wrapper_seq_item_pkg::*;
	
	`include "uvm_macros.svh"

	class SPI_wrapper_cover_collect extends uvm_component;
		`uvm_component_utils(SPI_wrapper_cover_collect)
		uvm_analysis_export #(SPI_wrapper_seq_item) cov_exp;
		uvm_tlm_analysis_fifo #(SPI_wrapper_seq_item) cov_fifo;

		SPI_wrapper_seq_item seq_item;

		covergroup cg();
			// to be added
		endgroup : cg

		function new(string name = "SPI_wrapper_cover_collect" , uvm_component parent = null);
			super.new(name,parent);
			cg = new();
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cov_exp = new("cov_exp",this);
			cov_fifo = new("cov_fifo",this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			cov_exp.connect(cov_fifo.analysis_export);
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);

			forever begin
				cov_fifo.get(seq_item);
				cg.sample();
			end
		endtask : run_phase
	endclass : SPI_wrapper_cover_collect
endpackage : SPI_wrapper_cover_collect_pkg