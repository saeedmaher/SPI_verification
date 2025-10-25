module SPI_slave_golden(MOSI,SS_n,clk,rst_n,tx_valid,tx_data,MISO,rx_valid,rx_data);
input MOSI,SS_n,clk,rst_n,tx_valid;
input [7:0]tx_data;
output reg MISO,rx_valid; 
output reg [9:0]rx_data;
reg [2:0]cs,ns;
reg address_enable;
reg [3:0]count;
localparam IDLE = 3'b000;
localparam CHK_CMD = 3'b010;
localparam WRITE = 3'b001;
localparam READ_ADD = 3'b011;
localparam READ_DATA = 3'b100;

always @(posedge clk) begin
    if (~rst_n) begin
        cs<=IDLE;
    end
    else begin
        cs<=ns;
    end
end

always @(*) begin
    case(cs) 
        IDLE: begin
          if(~SS_n) begin
            ns=CHK_CMD;
          end
        end

        CHK_CMD: begin
          if (SS_n) begin
            ns=IDLE;
          end  
          else if (~MOSI) begin
            ns=WRITE;
          end
          else begin
            if (~address_enable) begin
                ns=READ_ADD;
            end else begin
                ns=READ_DATA;
            end
          end
        end

        WRITE: begin
          if(SS_n == 1) begin
            ns=IDLE;
          end
          else begin
            ns=WRITE;
          end
        end

        READ_ADD: begin
          if(SS_n == 1) begin
            ns=IDLE;
          end
          else begin
            ns=READ_ADD;
          end
        end

        READ_DATA: begin
          if(SS_n == 1) begin
            ns=IDLE;
          end
          else begin
            ns=READ_DATA;
          end
        end

    endcase
end

always @(posedge clk) begin
    if (~rst_n) begin
        MISO<=0;
        rx_data<=0;
        rx_valid<=0;
        count<=0;
        address_enable<=0;
    end
    else begin
        case (cs)

        IDLE: rx_valid<=0;

        CHK_CMD: count<=0;

        WRITE: begin
            if (count<10) begin
              rx_data[9-count]<=MOSI;
              count<=count+1;               
            end
            else if (count == 10) begin
                rx_valid<=1;
            end
        end 

        READ_ADD : begin
          if(count<10) begin
              rx_data[9-count]<=MOSI; 
              count<=count+1;            
          end
          else if (count==10) begin 
                rx_valid<=1;    
                address_enable<=1;
                count<=count+1;        
          end
        end

        READ_DATA: begin
          if(rx_valid && ~tx_valid) begin
            count<=0;
          end
          else if(count<10 && ~tx_valid) begin
              rx_data[9-count]<=MOSI;   
              count<=count+1;          
          end
          else if (count==10 && ~tx_valid) begin
                rx_valid<=1;            
          end
          else if (tx_valid && count<8) begin
            address_enable<=0;
            rx_valid<=0;
            MISO<=tx_data[7-count];
            count<=count+1;
          end
        end
            
        endcase
    end
end

endmodule
