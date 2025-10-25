package RAM_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_sqr_pkg::*;
import RAM_driver_pkg::*;
import RAM_monitor_pkg::*;
import RAM_config_pkg::*;
import RAM_seq_item_pkg::*;

    class RAM_agent extends uvm_agent;
    `uvm_component_utils(RAM_agent)

        //define handles
        RAM_driver agent_driv;
        RAM_sqr agent_sqr;
        RAM_monitor agent_mon;
        RAM_config agent_cfg;
        uvm_analysis_port #(RAM_seq_item) agent_ap;

        //constructor
        function new(string name = "RAM_agent", uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        //build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //get config pointer to handler
            if(!(uvm_config_db #(RAM_config)::get(this,"","CFG_RAM",agent_cfg))) begin
               `uvm_fatal("build_phase","can not get the CFG from DB in the agent")
            end
            //build blocks
            if (agent_cfg.is_active == UVM_ACTIVE) begin
                agent_driv=RAM_driver::type_id::create("agent_driv",this);
                agent_sqr=RAM_sqr::type_id::create("agent_sqr",this);
            end
            agent_mon=RAM_monitor::type_id::create("agent_mon",this);
            agent_ap=new("agent_ap",this);
        endfunction

        //connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            if(agent_cfg.is_active == UVM_ACTIVE) begin
                agent_driv.seq_item_port.connect(agent_sqr.seq_item_export);
                agent_driv.RAM_vif = agent_cfg.RAM_vif;
            end
            agent_mon.RAM_vif = agent_cfg.RAM_vif;
            agent_mon.mon_ap.connect(agent_ap);
        endfunction

    endclass 

    
endpackage