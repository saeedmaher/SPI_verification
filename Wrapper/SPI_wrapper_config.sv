package SPI_wrapper_config_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class SPI_wrapper_config extends uvm_object;
		`uvm_object_utils(SPI_wrapper_config)

		virtual SPI_wrapper_if wrapper_if;
		uvm_active_passive_enum is_active;

		function new(string name = "SPI_wrapper_config");
			super.new(name);
		endfunction : new
			
	endclass : SPI_wrapper_config	
	
endpackage : SPI_wrapper_config_pkg