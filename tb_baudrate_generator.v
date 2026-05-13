module baudgen_tb ;
    reg clk, reset;
    wire sample_tick;
    baud_rate_generator #(
        .N(10),.M(651)
    ) uut (
        .clk(clk),
        .reset(reset),
        .sample_tick(sample_tick)
    );
    always #5 clk=~clk ;
    initial begin
        $dumpfile("baud_rate.vcd");
        $dumpvars(0,baudgen_tb);
        clk = 0;
        reset = 1;
        #20;
        reset = 0;
        #10000;
        $stop;
    end
endmodule 
