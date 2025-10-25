package SPI_slave_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_slave_env_pkg::*;
import SPI_slave_main_seq_pkg::*;
import SPI_slave_reset_seq_pkg::*;
import SPI_slave_config_pkg::*;

    class SPI_slave_test extends uvm_test;
    `uvm_component_utils(SPI_slave_test)

        //handles
        SPI_slave_env slave_env;
        SPI_slave_main_seq M_seq;
        SPI_slave_reset_seq R_seq;
        SPI_slave_config test_cfg;
        virtual SLAVE_interface SPI_slave_vif;

        //constructor
        function new(string name = "SPI_slave_test", uvm_component parent = null);
             super.new(name,parent);
        endfunction

        //build
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            slave_env = SPI_slave_env::type_id::create("slave_env",this);
            M_seq = SPI_slave_main_seq::type_id::create("M_seq");
            R_seq = SPI_slave_reset_seq::type_id::create("R_seq");
            test_cfg = SPI_slave_config::type_id::create("test_cfg");
            //get the virtual interface from db
            if(!(uvm_config_db #(virtual SLAVE_interface)::get(this,"","SLAVE_IF",test_cfg.SPI_slave_vif))) begin
                `uvm_fatal("build phase","unable to get ALSU interface from DB in test class");
            end
            //intialize is active var
            test_cfg.is_active = UVM_ACTIVE;
            //SET cfg to the db
            uvm_config_db #(SPI_slave_config)::set(this,"slave_env*","CFG_slave",test_cfg);
        endfunction

        //run
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("run phase","reset asserted",UVM_LOW)
            R_seq.start(slave_env.ag.agent_sqr);
            `uvm_info("run phase","reset deasserted",UVM_LOW)
            `uvm_info("run phase","stimulas generation started of main seq",UVM_LOW)
            M_seq.start(slave_env.ag.agent_sqr);
            `uvm_info("run phase","stimulas generation ended of main seq",UVM_LOW)
            phase.drop_objection(this);
        endtask

    endclass 
    
endpackage