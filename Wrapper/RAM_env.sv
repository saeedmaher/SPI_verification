package RAM_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_agent_pkg::*;
import RAM_collector_pkg::*;
import RAM_scoreboard_pkg::*;

    class RAM_env extends uvm_env;
    `uvm_component_utils(RAM_env)

        //hadles
        RAM_agent ag;
        RAM_collector cvr;
        RAM_scoreboard sb;

        //constructor
        function new(string name = "RAM_env", uvm_component parent = null);
            super.new(name,parent);
        endfunction 

        //build
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            ag = RAM_agent::type_id::create("ag",this);
            cvr = RAM_collector::type_id::create("cvr",this);
            sb = RAM_scoreboard::type_id::create("sb",this);
        endfunction

        //connect
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            ag.agent_ap.connect(cvr.cvr_export);
            ag.agent_ap.connect(sb.sb_export);
        endfunction
        
    endclass 

    
endpackage