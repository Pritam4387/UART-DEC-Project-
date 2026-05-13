`timescale 1ns / 1ps
`include "baudrate_gen.v"
`include "fifo.v"
`include "transmitter.v"
`include "receiver.v"
module uart_top
    #(
        parameter   DBITS = 8,
                    SB_TICK = 16,
                    BR_LIMIT = 651,
                    BR_BITS = 10,
                    FIFO_EXP = 2
    )
    (
        input clk,
        input reset,
        input read_uart,
        input write_uart,
        input rx,
        input [DBITS-1:0] write_data,
        output rx_full,
        output rx_empty,
        output tx,
        output [DBITS-1:0] read_data
    );
    wire tick;
    wire rx_done_tick;
    wire tx_done_tick;
    wire tx_empty;
    wire tx_fifo_not_empty;
    wire [DBITS-1:0] tx_fifo_out;
    wire [DBITS-1:0] rx_data_out;   
    baud_rate_generator 
        #(
            .M(BR_LIMIT), 
            .N(BR_BITS)
         ) 
        BAUD_RATE_GEN   
        (
            .clk(clk), 
            .reset(reset),
            .tick(tick)
         );
    uart_receiver
        #(
            .DBITS(DBITS),
            .SB_TICK(SB_TICK)
         )
         UART_RX_UNIT
         (
            .clk(clk),
            .reset(reset),
            .rx(rx),
            .sample_tick(tick),
            .data_ready(rx_done_tick),
            .data_out(rx_data_out)
         );
    uart_transmitter
        #(
            .DBITS(DBITS),
            .SB_TICK(SB_TICK)
         )
         UART_TX_UNIT
         (
            .clk(clk),
            .reset(reset),
            .tx_start(tx_fifo_not_empty),
            .sample_tick(tick),
            .data_in(tx_fifo_out),
            .tx_done(tx_done_tick),
            .tx(tx)
         );
    fifo
        #(
            .DATA_SIZE(DBITS),
            .ADDR_SPACE_EXP(FIFO_EXP)
         )
         FIFO_RX_UNIT
         (
            .clk(clk),
            .reset(reset),
            .write_to_fifo(rx_done_tick),
	        .read_from_fifo(read_uart),
	        .write_data_in(rx_data_out),
	        .read_data_out(read_data),
	        .empty(rx_empty),
	        .full(rx_full)            
	      );
    fifo
        #(
            .DATA_SIZE(DBITS),
            .ADDR_SPACE_EXP(FIFO_EXP)
         )
         FIFO_TX_UNIT
         (
            .clk(clk),
            .reset(reset),
            .write_to_fifo(write_uart),
	        .read_from_fifo(tx_done_tick),
	        .write_data_in(write_data),
	        .read_data_out(tx_fifo_out),
	        .empty(tx_empty),
	        .full()
	      );
    assign tx_fifo_not_empty = ~tx_empty;
endmodule
