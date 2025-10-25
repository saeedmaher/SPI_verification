package SPI_slave_monitor_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_slave_seq_item_pkg::*;

    class SPI_slave_monitor extends uvm_monitor;
    `uvm_component_utils(SPI_slave_monitor)

        //virtual interface
        virtual SLAVE_interface SPI_slave_vif;

        //seq item
        SPI_slave_seq_item seq_item;

        //analysis port
        uvm_analysis_port #(SPI_slave_seq_item) mon_ap;

        //constructor
        function new(string name = "SPI_slave_monitor", uvm_component parent);
            super.new(name,parent);
        endfunction //new()

        //build
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap",this);
        endfunction
        
        //run
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item = SPI_slave_seq_item::type_id::create("seq_item");
                @(negedge SPI_slave_vif.clk);
                seq_item.rst_n = SPI_slave_vif.rst_n;
                seq_item.MOSI = SPI_slave_vif.MOSI;
                seq_item.SS_n = SPI_slave_vif.SS_n;
                seq_item.tx_data = SPI_slave_vif.tx_data;
                seq_item.tx_valid = SPI_slave_vif.tx_valid;
                seq_item.rx_valid = SPI_slave_vif.rx_valid;
                seq_item.rx_data = SPI_slave_vif.rx_data;
                seq_item.MISO = SPI_slave_vif.MISO;
                //golden outputs
                seq_item.rx_valid_golden = SPI_slave_vif.rx_valid_golden;
                seq_item.rx_data_golden = SPI_slave_vif.rx_data_golden;
                seq_item.MISO_golden = SPI_slave_vif.MISO_golden;
                //broadcast
                mon_ap.write(seq_item);
            end
        endtask

    endclass 

endpackage