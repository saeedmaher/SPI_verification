module RAM_golden(clk,rst_n,rx_valid,din,tx_valid,dout);
parameter MEM_DEPTH = 256; 
parameter ADDR_SIZE = 8;
input clk,rst_n,rx_valid;
input [9:0] din;
output reg tx_valid;
output reg [7:0] dout; 
reg [ADDR_SIZE-1:0]ADD_read,ADD_write;
reg [7:0] mem [MEM_DEPTH-1:0];

always@(posedge clk)
begin
    if(!rst_n) begin
        tx_valid<=0;
        dout<=0;   
        ADD_read <= 0;
        ADD_write <= 0;
    end
    else begin
        if(rx_valid) begin
            case (din[9:8])
                2'b00: begin 
                    tx_valid<=0;
                    ADD_write<=din[7:0];
                end
                2'b01: begin
                    tx_valid<=0;
                    mem[ADD_write]<=din[7:0];
                end
                2'b10: begin
                    tx_valid<=0; 
                    ADD_read<=din[7:0];
                end
                2'b11: begin
                    tx_valid<=1;
                    dout<=mem[ADD_read];
                end
            endcase
        end
    end
end
endmodule
