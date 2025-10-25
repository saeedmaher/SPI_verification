package RAM_write_only_seq_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item_pkg::*;
    
    class RAM_write_only_seq extends uvm_sequence #(RAM_seq_item);
    `uvm_object_utils(RAM_write_only_seq)

        //seq item
        RAM_seq_item seq_item;

        //construcotr
        function new(string name = "RAM_write_only_seq");
            super.new(name);
        endfunction //new()

        //body
        task body();
            seq_item = RAM_seq_item::type_id::create("seq_item");            
            repeat(10000) begin
                start_item(seq_item);
                assert(seq_item.randomize() with {din[9] == 1'b0;});
                finish_item(seq_item);
            end
        endtask

    endclass 
endpackage