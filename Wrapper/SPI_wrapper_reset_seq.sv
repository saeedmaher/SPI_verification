package SPI_wrapper_reset_seq_pkg;
	import uvm_pkg::*;
	import SPI_wrapper_seq_item_pkg::*;
	
	`include "uvm_macros.svh"

	class SPI_wrapper_reset_seq extends uvm_sequence #(SPI_wrapper_seq_item);
		`uvm_object_utils(SPI_wrapper_reset_seq)

		SPI_wrapper_seq_item seq_item;

		function new(string name = "SPI_wrapper_reset_seq");
			super.new(name);
		endfunction : new

		task body();
			seq_item = SPI_wrapper_seq_item::type_id::create("seq_item");
			
			start_item(seq_item);
			seq_item.rst_n = 0;
			finish_item(seq_item);

		endtask : body
	endclass : SPI_wrapper_reset_seq
	
endpackage : SPI_wrapper_reset_seq_pkg