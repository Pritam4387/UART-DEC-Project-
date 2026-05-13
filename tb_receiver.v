`timescale 1ns/1ps
module uart_receiver_tb ;
    reg clk, reset;
    reg rx, sample_tick;
    wire [7:0] data_out;
    wire data_ready;
    uart_receiver ur(
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .sample_tick(sample_tick),
        .data_out(data_out),
        .data_ready(data_ready)
    );
    always #5 clk=~clk ;
    reg [3:0] count ;
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            sample_tick<=0;
            count<=0;
            rx<=1;
        end 
        else begin
            count<=count+1 ;
            if (count==15) begin
                sample_tick<=1;
                count<=0;
            end
            else sample_tick<=0;
        end 
    end
    task send_bytes(input [7:0] data);
        integer i ;
        begin 
            //start bit
            rx=0 ;  
            repeat(16) @(posedge sample_tick);
            for( i=0 ; i<8  ; i=i+1) begin
                rx=data[i];
                repeat(16) @(posedge sample_tick);
            end

            //stop bit
            rx=1;
            repeat(16) @(posedge sample_tick);
        end
    endtask

    initial begin
        $dumpfile("uart_receiver.vcd");
        $dumpvars(0,uart_receiver_tb);
        $monitor("reset:%b clk:%b baud:%b rx:%b ", reset, clk, sample_tick, rx);
        reset=1;
        clk=0;
        rx=1;
        #20 ;
        reset=0;
        #50
        send_bytes(8'hA5); //8'b1010_0101 165
        #1000 
        $finish;
    end
endmodule 
