package SPI_slave_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_slave_sqr_pkg::*;
import SPI_slave_driver_pkg::*;
import SPI_slave_monitor_pkg::*;
import SPI_slave_config_pkg::*;
import SPI_slave_seq_item_pkg::*;

    class SPI_slave_agent extends uvm_agent;
    `uvm_component_utils(SPI_slave_agent)

        //define handles
        SPI_slave_driver agent_driv;
        SPI_slave_sqr agent_sqr;
        SPI_slave_monitor agent_mon;
        SPI_slave_config agent_cfg;
        uvm_analysis_port #(SPI_slave_seq_item) agent_ap;

        //constructor
        function new(string name = "SPI_slave_agent", uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        //build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //get config pointer to handler
            if(!(uvm_config_db #(SPI_slave_config)::get(this,"","CFG_slave",agent_cfg))) begin
               `uvm_fatal("build_phase","can not get the CFG from DB in the agent")
            end
            //build blocks
            if (agent_cfg.is_active == UVM_ACTIVE) begin
                agent_driv=SPI_slave_driver::type_id::create("agent_driv",this);
                agent_sqr=SPI_slave_sqr::type_id::create("agent_sqr",this);
            end
            agent_mon=SPI_slave_monitor::type_id::create("agent_mon",this);
            agent_ap=new("agent_ap",this);
        endfunction

        //connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            if(agent_cfg.is_active == UVM_ACTIVE) begin
                agent_driv.seq_item_port.connect(agent_sqr.seq_item_export);
                agent_driv.SPI_slave_vif = agent_cfg.SPI_slave_vif;
            end
            agent_mon.SPI_slave_vif = agent_cfg.SPI_slave_vif;
            agent_mon.mon_ap.connect(agent_ap);
        endfunction

    endclass 

    
endpackage