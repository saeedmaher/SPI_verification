package SPI_wrapper_mon_pkg;
	import uvm_pkg::*;
	import SPI_wrapper_seq_item_pkg::*;
	
	`include "uvm_macros.svh"

	class SPI_wrapper_mon extends uvm_monitor;
		`uvm_component_utils(SPI_wrapper_mon)

		virtual SPI_wrapper_if wrapper_if;
		SPI_wrapper_seq_item seq_item;
		uvm_analysis_port #(SPI_wrapper_seq_item) mon_ap;

		function new(string name = "SPI_wrapper_mon" , uvm_component parent = null);
			super.new(name , parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			mon_ap = new("mon_ap",this);
		endfunction : build_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);

			forever begin
				seq_item = SPI_wrapper_seq_item::type_id::create("seq_item");
				@(negedge wrapper_if.clk);

				seq_item.rst_n     = wrapper_if.rst_n;
				seq_item.MOSI      = wrapper_if.MOSI;
				seq_item.SS_n      = wrapper_if.SS_n;
				seq_item.MISO      = wrapper_if.MISO;
				seq_item.MISO_gold = wrapper_if.MISO_gold;

				mon_ap.write(seq_item);
				`uvm_info("run_phase" , seq_item.convert2string(), UVM_HIGH)
			end
		endtask : run_phase
		
	endclass : SPI_wrapper_mon
endpackage : SPI_wrapper_mon_pkg