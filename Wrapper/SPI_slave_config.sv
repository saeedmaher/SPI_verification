package SPI_slave_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_pkg::*;

    class SPI_slave_config extends uvm_object;
    `uvm_object_utils(SPI_slave_config)

        virtual SLAVE_interface SPI_slave_vif;
        uvm_active_passive_enum is_active;

        //constructor
        function new(string name = "SPI_slave_config");
            super.new(name);
        endfunction //new()


    endclass 
    
endpackage