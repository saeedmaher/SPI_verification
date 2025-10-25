package SPI_wrapper_test_pkg;

import SPI_wrapper_env_pkg::*;
import SPI_wrapper_config_pkg::*;
import SPI_wrapper_reset_seq_pkg::*;
import SPI_wrapper_WO_seq_pkg::*;
import SPI_wrapper_RO_seq_pkg::*;
import SPI_wrapper_WR_seq_pkg::*;

import SPI_slave_config_pkg::*;
import SPI_slave_env_pkg::*;

import RAM_config_pkg::*;
import RAM_env_pkg::*;

import uvm_pkg::*;
`include "uvm_macros.svh"


class SPI_wrapper_test extends uvm_test;
  `uvm_component_utils(SPI_wrapper_test)

  virtual SPI_wrapper_if wrapper_if;
  virtual RAM_interface ram_if;
  virtual SLAVE_interface spi_if;

  SPI_wrapper_env wrapper_env;
  SPI_wrapper_config wrapper_cfg;

  RAM_env ram_env;
  RAM_config ram_cfg;

  SPI_slave_env spi_env;
  SPI_slave_config spi_cfg;

  SPI_wrapper_reset_seq reset_seq;
  SPI_wrapper_WO_seq write_seq;
  SPI_wrapper_RO_seq read_seq;
  SPI_wrapper_WR_seq write_read_seq; 

  function new(string name = "SPI_wrapper_test" , uvm_component parent = null);
    super.new(name,parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wrapper_env = SPI_wrapper_env::type_id::create("wrapper_env",this);
    wrapper_cfg = SPI_wrapper_config::type_id::create("wrapper_cfg");

    ram_env = RAM_env::type_id::create("ram_env",this);
    ram_cfg = RAM_config::type_id::create("ram_cfg");

    spi_env = SPI_slave_env::type_id::create("spi_env",this);
    spi_cfg = SPI_slave_config::type_id::create("spi_cfg");

    write_seq = SPI_wrapper_WO_seq::type_id::create("write_seq");
    reset_seq = SPI_wrapper_reset_seq::type_id::create("reset_seq");
    read_seq = SPI_wrapper_RO_seq::type_id::create("read_seq");
    write_read_seq = SPI_wrapper_WR_seq::type_id::create("write_read_seq");

    if(!uvm_config_db#(virtual SPI_wrapper_if)::get(this, "", "inter", wrapper_cfg.wrapper_if))
      `uvm_fatal("build_phase" , "error test");

    if(!uvm_config_db#(virtual RAM_interface)::get(this, "", "RAM_if", ram_cfg.RAM_vif))
      `uvm_fatal("build_phase" , "error test");

    if(!uvm_config_db#(virtual SLAVE_interface)::get(this, "", "Slave_if", spi_cfg.SPI_slave_vif))
      `uvm_fatal("build_phase" , "error test");

    wrapper_cfg.is_active = UVM_ACTIVE;
    ram_cfg.is_active     = UVM_PASSIVE;
    spi_cfg.is_active     = UVM_PASSIVE;

    uvm_config_db#(SPI_wrapper_config)::set(this, "*", "CFG", wrapper_cfg);
    uvm_config_db#(RAM_config)::set(this, "*", "CFG_RAM", ram_cfg);
    uvm_config_db#(SPI_slave_config)::set(this, "*", "CFG_slave", spi_cfg);
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    reset_seq.start(wrapper_env.agt.seqr);
    write_seq.start(wrapper_env.agt.seqr);
    read_seq.start(wrapper_env.agt.seqr);
    write_read_seq.start(wrapper_env.agt.seqr);
    phase.drop_objection(this);
  endtask : run_phase

endclass: SPI_wrapper_test

endpackage : SPI_wrapper_test_pkg