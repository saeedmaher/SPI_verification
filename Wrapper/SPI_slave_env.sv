package SPI_slave_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_slave_agent_pkg::*;
import SPI_slave_collector_pkg::*;
import SPI_slave_scoreboard_pkg::*;

    class SPI_slave_env extends uvm_env;
    `uvm_component_utils(SPI_slave_env)

        //hadles
        SPI_slave_agent ag;
        SPI_slave_collector cvr;
        SPI_slave_scoreboard sb;

        //constructor
        function new(string name = "SPI_slave_env", uvm_component parent = null);
            super.new(name,parent);
        endfunction 

        //build
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            ag = SPI_slave_agent::type_id::create("ag",this);
            cvr = SPI_slave_collector::type_id::create("cvr",this);
            sb = SPI_slave_scoreboard::type_id::create("sb",this);
        endfunction

        //connect
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            ag.agent_ap.connect(cvr.cvr_export);
            ag.agent_ap.connect(sb.sb_export);
        endfunction
    endclass 

    
endpackage