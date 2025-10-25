package RAM_sqr_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item_pkg::*;

    class RAM_sqr extends uvm_sequencer #(RAM_seq_item);
    `uvm_component_utils(RAM_sqr)

        //constructor
        function new(string name = "RAM_sqr", uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

        
    endclass 
    
endpackage