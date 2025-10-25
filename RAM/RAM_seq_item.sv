package RAM_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import shared_pkg::*;


    class RAM_seq_item extends uvm_sequence_item;
    `uvm_object_utils(RAM_seq_item)

        //inputs and output
        rand logic rst_n, rx_valid;
        rand logic [9:0] din;
        logic [9:0] dout;
        logic tx_valid;
        logic [9:0] dout_golden;
        logic tx_valid_golden;
        
        //constructor
        function new (string name = "RAM_seq_item");
            super.new(name);
        endfunction

        //constraints

        //reset
        constraint reset_rate {
            rst_n dist {0:=1,1:=99};
        }

        constraint rx_rate {
            rx_valid dist {0:=5,1:=95};
        }

        constraint next_op {
            if (write_address_done) {
                soft din[9] == 1'b0;
            }
            else if (read_address_done) {
                soft din[9:8] == 2'b11;
            }
        }

        constraint next_read_data{
            if(read_data_done)
                din[9:8] == 2'b10;
        }


        constraint read_after_address {
            if(!read_address_done){
                din[9:8] != 2'b11;
            }
        }

        constraint after_write_data {
            if (write_data_done) {
                soft din[9:8] dist {2'b10 := 60 , 2'b00 := 40};
            }
            else if (read_data_done) {
                soft din[9:8] dist {2'b10 := 40 , 2'b00 := 60};
            }
        }
 
        function void post_randomize();

            if (din[9:8] == 2'b00) write_address_done = 1;
            else write_address_done = 0;

            if (din[9:8] == 2'b01) write_data_done = 1;
            else write_data_done = 0;


            if (din[9:8] == 2'b10) read_address_done = 1;
            else read_address_done = 0;

            if (din[9:8] == 2'b11) read_data_done = 1;
            else read_data_done = 0;

        endfunction

    endclass
    
endpackage