package SPI_wrapper_WR_seq_pkg;
	import uvm_pkg::*;
	import SPI_wrapper_seq_item_pkg::*;
	
	`include "uvm_macros.svh"

	class SPI_wrapper_WR_seq extends uvm_sequence #(SPI_wrapper_seq_item);
		`uvm_object_utils(SPI_wrapper_WR_seq)

		SPI_wrapper_seq_item seq_item;

		function new(string name = "SPI_wrapper_WR_seq");
			super.new(name);
		endfunction : new

		task body();
			seq_item = SPI_wrapper_seq_item::type_id::create("seq_item");
			
			seq_item.next_read_data.constraint_mode(0);
			repeat(10000) begin
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end

		endtask : body
	endclass : SPI_wrapper_WR_seq
	
endpackage : SPI_wrapper_WR_seq_pkg