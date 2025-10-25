package SPI_wrapper_agent_pkg;
	import uvm_pkg::*;
	import SPI_wrapper_seqr_pkg::*;
	import SPI_wrapper_driver_pkg::*;
	import SPI_wrapper_mon_pkg::*;
	import SPI_wrapper_config_pkg::*;
	import SPI_wrapper_seq_item_pkg::*;
	
	`include "uvm_macros.svh"

	class SPI_wrapper_agent extends uvm_agent;
		`uvm_component_utils(SPI_wrapper_agent);

		SPI_wrapper_seqr seqr;
		SPI_wrapper_driver drv;
		SPI_wrapper_mon mon;
		SPI_wrapper_config cfg;
		uvm_analysis_port #(SPI_wrapper_seq_item) agt_ap;

		function new(string name = "SPI_wrapper_agent" , uvm_component parent = null);
			super.new(name, parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);

			uvm_config_db#(SPI_wrapper_config)::get(this, "", "CFG", cfg);
			
			mon = SPI_wrapper_mon::type_id::create("mon",this);
			if (cfg.is_active == UVM_ACTIVE) begin
				seqr = SPI_wrapper_seqr::type_id::create("seqr",this);
				drv = SPI_wrapper_driver::type_id::create("drv",this);
			end
	
			agt_ap = new("agt_ap",this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
	
			mon.wrapper_if = cfg.wrapper_if;
			mon.mon_ap.connect(agt_ap);

			if (cfg.is_active == UVM_ACTIVE) begin
				drv.wrapper_if = cfg.wrapper_if;
				drv.seq_item_port.connect(seqr.seq_item_export);
			end
		endfunction : connect_phase

	endclass : SPI_wrapper_agent
endpackage : SPI_wrapper_agent_pkg