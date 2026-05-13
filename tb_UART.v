`timescale 1ns / 1ps
`include "button_debouncer.v"
`include "hex_to_7_seg.v"
`include "UART.v"
module uart_test(
    input clk,
    input reset,
    input rx,
    input btn,
    output tx,
    output [3:0] an,
    output [6:0] seg,
    output [1:0] LED
);
    wire rx_full, rx_empty, btn_tick;
    wire [7:0] rec_data, rec_data1;
    uart_top UART_UNIT (
        .clk(clk),
        .reset(reset),
        .read_uart(btn_tick),
        .write_uart(btn_tick),
        .rx(rx),
        .write_data(rec_data1),
        .rx_full(rx_full),
        .rx_empty(rx_empty),
        .read_data(rec_data),
        .tx(tx)
    );
    debounce BUTTON_DEBOUNCER (
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .db_level(),
        .db_tick(btn_tick)
    );
    assign rec_data1 = rec_data + 1;
    assign LED = {rx_full, rx_empty};
    wire [3:0] hex0 = rec_data[3:0]; 
    wire [3:0] hex1 = rec_data[7:4]; 
    reg [16:0] refresh_counter;

    always @(posedge clk or posedge reset) begin
        if (reset)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end
    wire refresh = refresh_counter[16];
    reg [3:0] hex;
    always @(*) begin
        if (refresh)
            hex = hex1;
        else
            hex = hex0;
    end
    assign an = (refresh) ? 4'b1101 : 4'b1110;
    hex_to_7seg DECODER (
        .hex(hex),
        .seg(seg)
    );
endmodule
