`timescale 1ns/1ps
module uart_transmitter_tb #( parameter DBITS = 8);
    reg clk, reset , tx_start, sample_tick ;
    reg [DBITS-1:0] data_in;
    wire tx, tx_ready ;

    uart_transmitter uut(
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .sample_tick(sample_tick),
        .data_in(data_in),
        .tx(tx),
        .tx_ready(tx_ready)
    );
    always #5 clk=~clk;
    always #20 sample_tick=~sample_tick;

    initial begin
        $dumpfile("uart_transmitter.vcd");
        $dumpvars(0,uart_transmitter_tb);
        $monitor("reset:%b clk:%b baud:%b tx:%b tx_ready:%b",reset , clk , sample_tick, tx, tx_ready);
        clk=0;
        sample_tick=0;
        reset=1;
        tx_start=0;
        data_in=8'b10101010 ;//170

        #20;
        reset=0 ;
        #50;
        tx_start=1 ;
        #10;
        tx_start=0;

        #3000 ;
        $finish;
    end
endmodule
