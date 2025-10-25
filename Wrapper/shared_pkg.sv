package shared_pkg;

    bit [5:0] count;
    bit is_read, have_address_to_read;
    int limit;
    logic [10:0] keep_arr;
    

    bit write_address_done, write_data_done, read_address_done, read_data_done;

endpackage