package RAM_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_env_pkg::*;
import RAM_reset_seq_pkg::*;
import RAM_write_only_seq_pkg::*;
import RAM_read_only_seq_pkg::*;
import RAM_write_read_seq_pkg::*;
import RAM_config_pkg::*;

    class RAM_test extends uvm_test;
    `uvm_component_utils(RAM_test)

        //handles
        RAM_env RAM_ENV;
        RAM_reset_seq R_seq;
        RAM_write_only_seq Wr_seq;
        RAM_read_only_seq Rd_seq;
        RAM_write_read_seq WR_seq;
        RAM_config test_cfg;
        virtual RAM_interface RAM_vif;

        //constructor
        function new(string name = "RAM_test", uvm_component parent = null);
             super.new(name,parent);
        endfunction

        //build
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            RAM_ENV = RAM_env::type_id::create("RAM_env",this);
            R_seq = RAM_reset_seq::type_id::create("R_seq");
            Wr_seq = RAM_write_only_seq::type_id::create("Wr_seq");
            Rd_seq = RAM_read_only_seq::type_id::create("Rd_seq");
            WR_seq = RAM_write_read_seq::type_id::create("WR_seq");
            test_cfg = RAM_config::type_id::create("test_cfg");
            //get the virtual interface from db
            if(!(uvm_config_db #(virtual RAM_interface)::get(this,"","RAM_IF",test_cfg.RAM_vif))) begin
                `uvm_fatal("build phase","unable to get ALSU interface from DB in test class");
            end
            //intialize is active var
            test_cfg.is_active = UVM_ACTIVE;
            //SET cfg to the db
            uvm_config_db #(RAM_config)::set(this,"RAM_env*","CFG_RAM",test_cfg);
        endfunction

        //run
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("run phase","reset asserted",UVM_LOW)
            R_seq.start(RAM_ENV.ag.agent_sqr);
            `uvm_info("run phase","reset deasserted",UVM_LOW)
            `uvm_info("run phase","stimulas generation started of write only seq",UVM_LOW)
            Wr_seq.start(RAM_ENV.ag.agent_sqr);
            `uvm_info("run phase","stimulas generation ended of write only seq",UVM_LOW)
            `uvm_info("run phase","stimulas generation started of read only seq",UVM_LOW)
            Rd_seq.start(RAM_ENV.ag.agent_sqr);
            `uvm_info("run phase","stimulas generation ended of read only seq",UVM_LOW)
            `uvm_info("run phase","stimulas generation started of read-write seq",UVM_LOW)
            WR_seq.start(RAM_ENV.ag.agent_sqr);
            `uvm_info("run phase","stimulas generation ended of read-write seq",UVM_LOW)
            phase.drop_objection(this);
        endtask

    endclass 
    
endpackage