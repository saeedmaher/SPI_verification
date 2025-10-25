module RAM_SVA(
    input [9:0] din,
    input clk,
    input rst_n,
    input rx_valid,
    input [7:0] dout,
    input tx_valid
);

property sync_reset;
    @(posedge clk) 
    !rst_n |=> !tx_valid && (dout == 0);
endproperty

assert property (sync_reset);
cover property (sync_reset);

property tx_valid_off_seq_of_wrtie_add;
    @(posedge clk) disable iff(!rst_n)
    (din[9:8] == 2'b00) && (rx_valid == 1) |=> !tx_valid;
endproperty

assert property (tx_valid_off_seq_of_wrtie_add);
cover property (tx_valid_off_seq_of_wrtie_add);

property tx_valid_off_seq_of_wrtie_data;
    @(posedge clk) disable iff(!rst_n)
    (din[9:8] == 2'b01) && (rx_valid == 1) |=> !tx_valid;
endproperty

assert property (tx_valid_off_seq_of_wrtie_data);
cover property (tx_valid_off_seq_of_wrtie_data);

property tx_valid_off_seq_of_read_add;
    @(posedge clk) disable iff(!rst_n)
    (din[9:8] == 2'b10) && (rx_valid == 1) |=> !tx_valid;
endproperty

assert property (tx_valid_off_seq_of_read_add);
cover property (tx_valid_off_seq_of_read_add);
    
property tx_valid_on_seq;
    @(posedge clk) disable iff(!rst_n)
    (din[9:8] == 2'b11) && (rx_valid == 1) |=> tx_valid ##1 (!tx_valid)[->1];
endproperty

assert property (tx_valid_on_seq);
cover property (tx_valid_on_seq);    

property write_data_eventually_after_address;
    @(posedge clk) disable iff(!rst_n)
    (din[9:8] == 2'b00) && (rx_valid == 1) |=> (din[9:8] == 2'b01)[->1]; 
endproperty

assert property (write_data_eventually_after_address);
cover property (write_data_eventually_after_address);

property read_data_eventually_after_address;
    @(posedge clk) disable iff(!rst_n)
    (din[9:8] == 2'b10) && (rx_valid == 1) |=> (din[9:8] == 2'b11)[->1]; 
endproperty

assert property (read_data_eventually_after_address);
cover property (read_data_eventually_after_address);

endmodule