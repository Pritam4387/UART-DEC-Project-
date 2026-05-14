`timescale 1ns/1ps
module uart_fifo_tb;
    parameter DBITS=8, ADDR_SPACE_EXP=4;

    reg clk,reset,write_to_fifo,read_from_fifo;
    reg [DBITS-1:0] write_data_in ;
    wire [DBITS-1:0] read_data_out ;
    wire full, empty ;

  fifo #(DBITS,ADDR_SPACE_EXP) fut(
        .clk(clk),
        .reset(reset),
        .write_to_fifo(write_to_fifo),
        .read_from_fifo(read_from_fifo),
        .write_data_in(write_data_in),
        .read_data_out(read_data_out),
        .empty(empty),
        .full(full)
    );
    always #5 clk=~clk ;
    integer i ;
    initial begin
        $dumpfile("fifo_simulation.vcd");
        $dumpvars(0,uart_fifo_tb);

        clk=0 ;
        reset=1;
        write_to_fifo=0;
        read_from_fifo=0;
        write_data_in=0;
        #20 ;

        reset=0 ;

        for (i=0 ; i<16 ; i=i+1) begin
            @(posedge clk);
                if(!full) begin
                    write_to_fifo=1;
                    write_data_in=i ;
                end
            @(posedge clk) ;
            write_to_fifo<=0 ;
        end
        for (i=0 ; i<16 ; i=i+1) begin
            @(posedge clk);
            if(!empty) begin
                read_from_fifo=1;
                $display("read_data:%0d", read_data_out);
            end
            @(posedge clk);
            read_from_fifo=0;
        end

        for( i=0 ;i<8;i=i+1) begin
            @(posedge clk) ;
            write_to_fifo=1;
            read_from_fifo=1;
            write_data_in=i+100;
            $display("write_data:%0d", write_data_in);

            @(posedge clk);
            write_to_fifo=0;
            read_from_fifo=0;
        end
        #100;
        $finish;
    end
endmodule 
