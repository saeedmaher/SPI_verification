package SPI_slave_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import shared_pkg::*;


    class SPI_slave_seq_item extends uvm_sequence_item;
    `uvm_object_utils(SPI_slave_seq_item)

        //inputs and output
        rand logic rst_n, SS_n, tx_valid, MOSI;
        rand logic [7:0] tx_data;
        logic [9:0] rx_data;
        rand logic [10:0] arr_MOSI;
        logic rx_valid,MISO;
        logic rx_valid_golden,MISO_golden;
        logic [9:0] rx_data_golden;

        //constructor
        function new (string name = "SPI_slave_seq_item");
            super.new(name);
        endfunction

        //constraints

        //reset
        constraint reset_rate {
            rst_n dist {0:=1,1:=99};
        }

        constraint valid_MOSI_command {
            arr_MOSI[10:8] inside {3'b000, 3'b001, 3'b110, 3'b111};
            if(!have_address_to_read) {(arr_MOSI[10:8] != {3'b111});} 
        }

        constraint ready_to_read {
            if(count >= 15) tx_valid ==1;
            else tx_valid == 0;
        }

        function void post_randomize();

            if(count == 0) keep_arr = arr_MOSI;

            is_read = (keep_arr[10:8] == 3'b111)? 1:0;
            limit = (is_read)? 23:13;

            SS_n = (count == limit)? 1:0;

            if(keep_arr[10:8] == 3'b110) have_address_to_read = 1'b1;
            if (is_read || (!rst_n)) have_address_to_read = 1'b0;

            //
            if((count > 0) && (count < 12)) begin
                MOSI = keep_arr [11-count];
            end

            //count
            if (!rst_n) begin
                count = 0;
            end
            else begin
                if (count == limit) count = 0; 
                else count++;
            end
     
        endfunction

    endclass
    
endpackage