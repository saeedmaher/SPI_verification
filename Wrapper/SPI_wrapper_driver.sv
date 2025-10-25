package SPI_wrapper_driver_pkg;
	import SPI_wrapper_seq_item_pkg::*;
	import uvm_pkg::*;

	`include "uvm_macros.svh"

	class SPI_wrapper_driver extends uvm_driver #(SPI_wrapper_seq_item);
		`uvm_component_utils(SPI_wrapper_driver)

		virtual SPI_wrapper_if wrapper_if;
		SPI_wrapper_seq_item seq_item;

		function new(string name = "SPI_wrapper_driver" , uvm_component parent = null);
			super.new(name,parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
        	super.build_phase(phase);
    	endfunction : build_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			
			forever begin
				seq_item = SPI_wrapper_seq_item::type_id::create("seq_item");
				seq_item_port.get_next_item(seq_item);

				wrapper_if.MOSI  = seq_item.MOSI;
				wrapper_if.SS_n  = seq_item.SS_n;
				wrapper_if.rst_n = seq_item.rst_n;

				@(negedge wrapper_if.clk);
				seq_item_port.item_done();
				`uvm_info("run_phase" , seq_item.convert2string_stim(), UVM_HIGH)
			end
		endtask : run_phase
		
	endclass : SPI_wrapper_driver
endpackage : SPI_wrapper_driver_pkg