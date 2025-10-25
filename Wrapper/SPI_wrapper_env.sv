package SPI_wrapper_env_pkg;

import SPI_wrapper_cover_collect_pkg::*;
import SPI_wrapper_scoreboard_pkg::*;
import SPI_wrapper_agent_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_wrapper_env extends uvm_env;
  `uvm_component_utils(SPI_wrapper_env)

  SPI_wrapper_scoreboard sb;
  SPI_wrapper_cover_collect cov;
  SPI_wrapper_agent agt;

  function new(string name = "SPI_wrapper_env" , uvm_component parent = null);
    super.new(name,parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb = SPI_wrapper_scoreboard::type_id::create("sb",this);
    cov = SPI_wrapper_cover_collect::type_id::create("cov",this);
    agt = SPI_wrapper_agent::type_id::create("agt",this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    agt.agt_ap.connect(sb.sb_exp);
    agt.agt_ap.connect(cov.cov_exp);
  endfunction : connect_phase

endclass : SPI_wrapper_env
endpackage : SPI_wrapper_env_pkg