package RAM_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import uvm_pkg::*;

    class RAM_config extends uvm_object;
    `uvm_object_utils(RAM_config)

        virtual RAM_interface RAM_vif;
        uvm_active_passive_enum is_active;

        //constructor
        function new(string name = "RAM_config");
            super.new(name);
        endfunction //new()


    endclass 
    
endpackage