package SPI_wrapper_seq_item_pkg;
	import uvm_pkg::*;
	import shared_pkg::*;
	
	`include "uvm_macros.svh"

	class SPI_wrapper_seq_item extends uvm_sequence_item;
		`uvm_object_utils(SPI_wrapper_seq_item)

		rand logic MOSI, SS_n, rst_n;
		rand logic [10:0] arr_MOSI;

		logic MISO, MISO_gold;

		function new(string name = "SPI_wrapper_seq_item");
			super.new(name);
		endfunction : new

		constraint reset_c {rst_n dist {0 := 2 , 1 := 98};}

		constraint valid_MOSI_command {
            arr_MOSI [10:8] inside {3'b000, 3'b001, 3'b110, 3'b111};

            if (!have_address_to_read) {(arr_MOSI[10:8] != {3'b111});} 
        }

        constraint next_op {
            if (write_address_done) {
                soft arr_MOSI[9] == 1'b0;
            }
            else if (read_address_done) {
                soft arr_MOSI[9:8] == 2'b11;
            }
        }

        constraint next_read_data {
            if (read_data_done) {
                soft arr_MOSI[9:8] == 2'b10;
            }
        }

        constraint read_after_address {
            if(!read_address_done){
                arr_MOSI[9:8] != 2'b11;
            }
        }

        constraint after_write_data {
            if (write_data_done) {
                soft arr_MOSI[9:8] dist {2'b10 := 60 , 2'b00 := 40};
            }
            else if (read_data_done) {
                soft arr_MOSI[9:8] dist {2'b10 := 40 , 2'b00 := 60};
            }
        }
		
        function void post_randomize();

            if (count == 0) keep_arr = arr_MOSI;

            is_read = (keep_arr [10:8] == 3'b111)? 1:0;
            limit = (is_read)? 23:13;

            SS_n = (count == limit)? 1:0;

            if (keep_arr [10:8] == 3'b110) have_address_to_read = 1'b1;
            if (is_read || (!rst_n)) have_address_to_read = 1'b0;

            //
            if((count > 0) && (count < 12)) begin
                MOSI = keep_arr [11-count];
            end else

            // ram
            if (keep_arr [9:8] == 2'b00) write_address_done = 1;
            else write_address_done = 0;

            if (keep_arr [9:8] == 2'b01) write_data_done = 1;
            else write_data_done = 0;


            if (keep_arr [9:8] == 2'b10) read_address_done = 1;
            else read_address_done = 0;

            if (keep_arr [9:8] == 2'b11) read_data_done = 1;
            else read_data_done = 0;

            // count
            if (!rst_n) begin
                count = 0;
            end else begin
                if (count == limit) count = 0; 
                else count++;
            end
        endfunction : post_randomize

		function string convert2string();
			return $sformatf("%s MOSI = %0b, SS_n = %0b, rst_n = %0b, MISO = %0b",super.convert2string(), MOSI, SS_n, rst_n, MISO);
		endfunction : convert2string

		function string convert2string_stim();
			return $sformatf("%s MOSI = %0b, SS_n = %0b, rst_n = %0b",super.convert2string(), MOSI, SS_n, rst_n);
		endfunction : convert2string_stim

	endclass : SPI_wrapper_seq_item
endpackage : SPI_wrapper_seq_item_pkg