`timescale 1ns / 1ps
module baud_rate_generator
    #(
        parameter   N = 10,
                    M = 651
    )
    (
        input clk,
        input reset,
        output tick
    );
    reg [N-1:0] counter;
    wire [N-1:0] next;
    always @(posedge clk, posedge reset)
        if(reset)
            counter <= 0;
        else
            counter <= next;
    assign next = (counter == (M-1)) ? 0 : counter + 1;
    assign tick = (counter == (M-1)) ? 1'b1 : 1'b0;
endmodule
