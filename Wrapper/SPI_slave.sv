module SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

localparam IDLE      = 3'b000;
localparam WRITE     = 3'b001;
localparam CHK_CMD   = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

input MOSI, clk, rst_n, SS_n, tx_valid;
input [7:0] tx_data;
output reg [9:0] rx_data;
output reg rx_valid, MISO;

reg [3:0] counter;
reg received_address;

reg [2:0] cs, ns;

always @(posedge clk) begin
    if (~rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (SS_n)
                ns = IDLE;
            else begin
                if (~MOSI)
                    ns = WRITE;
                else begin
                    if (!received_address) 
                        ns = READ_ADD; 
                    else
                        ns = READ_DATA;
                end
            end
        end
        WRITE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end

        default : ns = IDLE;
    endcase
end

always @(posedge clk) begin
    if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        received_address <= 0;
        MISO <= 0;
    end
    else begin
        case (cs)
            IDLE : begin
                rx_valid <= 0;
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                    received_address <= 1;
                end
            end
            READ_DATA : begin
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (counter > 0) begin
                        MISO <= tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        received_address <= 0;
                    end
                end
                else begin
                    if (counter > 0 && ~rx_valid) begin
                        rx_data[counter-1] <= MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        rx_valid <= 1;
                        counter <= 8;
                    end
                end
            end
            default: rx_valid <= 0;
        endcase
    end
end

//assertion

`ifdef SIM

property sync_reset;
    @(posedge clk) 
    !rst_n |=> ((rx_data == 0) && (rx_valid == 0) && (MISO == 0)) ;
endproperty

assert property (sync_reset);
cover property (sync_reset);

sequence write_address;
    $fell(SS_n) ##1 (MOSI==0)[*3];
endsequence

sequence write_data;
    $fell(SS_n) ##1 (MOSI==0)[*2] ##1 (MOSI==1);
endsequence

sequence read_address;
    $fell(SS_n) ##1 (MOSI==1)[*2] ##1 (MOSI==0);
endsequence

sequence read_data;
    $fell(SS_n) ##1 (MOSI==1)[*3] ;
endsequence

sequence end_of_comm;
    rx_valid && SS_n;
endsequence

property write_address_comm;
    @(posedge clk) disable iff(!rst_n)
    write_address |-> ##10 end_of_comm;  
endproperty

assert property (write_address_comm);
cover property (write_address_comm);

property write_data_comm;
    @(posedge clk) disable iff(!rst_n)
    write_data |-> ##10 end_of_comm;  
endproperty

assert property (write_data_comm);
cover property (write_data_comm);

property read_address_comm;
    @(posedge clk) disable iff(!rst_n)
    read_address |-> ##10 end_of_comm;  
endproperty

assert property (read_address_comm);
cover property (read_address_comm);

property read_data_comm;
    @(posedge clk) disable iff(!rst_n)
    read_data |-> ##10 rx_valid |-> ##10 SS_n;  
endproperty

assert property (read_data_comm);
cover property (read_data_comm);

//last one



// 1. IDLE -> CHK_CMD
property IDLE_to_CHK_CMD;
    @(posedge clk) disable iff(!rst_n)
    (cs == IDLE) &&(!SS_n) |=> (cs == CHK_CMD)
endproperty

assert property (IDLE_to_CHK_CMD);
cover property (IDLE_to_CHK_CMD);


// 2. CHK_CMD -> WRITE or READ_ADD or READ_DATA
property CHK_CMD_to_WRITE;
    @(posedge clk) disable iff(!rst_n)
    (cs == CHK_CMD) && (!SS_n) && (!MOSI) |=> (cs == WRITE);
endproperty

assert property (CHK_CMD_to_WRITE);
cover property (CHK_CMD_to_WRITE);

property CHK_CMD_to_READ_ADD;
    @(posedge clk) disable iff(!rst_n)
    (cs == CHK_CMD) && (!SS_n) && (MOSI) && (!received_address) |=> (cs == READ_ADD);
endproperty

assert property (CHK_CMD_to_READ_ADD);
cover property (CHK_CMD_to_READ_ADD);

property CHK_CMD_to_READ_DATA;
    @(posedge clk) disable iff(!rst_n)
    (cs == CHK_CMD) && (!SS_n) && (MOSI) && (received_address) |=> (cs == READ_DATA);
endproperty

assert property (CHK_CMD_to_READ_DATA);
cover property (CHK_CMD_to_READ_DATA);


// 3. WRITE -> IDLE
property WRITE_to_IDLE;
    @(posedge clk) disable iff(!rst_n)
    (cs == WRITE) && (SS_n) |=> (cs == IDLE);
endproperty

assert property (WRITE_to_IDLE);
cover property (WRITE_to_IDLE);


// 4. READ_ADD -> IDLE
property READ_ADD_to_IDLE;
    @(posedge clk) disable iff(!rst_n)
    (cs == READ_ADD) && (SS_n) |=> (cs == IDLE);
endproperty

assert property (READ_ADD_to_IDLE);
cover property (READ_ADD_to_IDLE);


// 5. READ_DATA -> IDLE
property READ_DATA_to_IDLE;
    @(posedge clk) disable iff(!rst_n)
    (cs == READ_DATA) && (SS_n) |=> (cs == IDLE);
endproperty

assert property (READ_DATA_to_IDLE);
cover property (READ_DATA_to_IDLE);


`endif // SIM

endmodule