package SPI_wrapper_seqr_pkg;
	import uvm_pkg::*;
	import SPI_wrapper_seq_item_pkg::*;
	
	`include "uvm_macros.svh"

	class SPI_wrapper_seqr extends uvm_sequencer #(SPI_wrapper_seq_item);
		`uvm_component_utils(SPI_wrapper_seqr)

		function new(string name = "SPI_wrapper_seqr" , uvm_component parent = null);
			super.new(name , parent);
		endfunction : new
	endclass : SPI_wrapper_seqr
	
endpackage : SPI_wrapper_seqr_pkg