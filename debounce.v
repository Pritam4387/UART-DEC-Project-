module debounce(
    input clk,
    input reset,
    input btn,
    output reg db_level,
    output db_tick
);
parameter N = 22;
reg [N-1:0] count;
reg btn_sync0, btn_sync1;
always @(posedge clk) begin
    btn_sync0 <= btn;
    btn_sync1 <= btn_sync0;
end
always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 0;
        db_level <= 0;
    end
    else if (btn_sync1 != db_level) begin
        count <= count + 1;
        if (&count)
            db_level <= btn_sync1;
    end
    else
        count <= 0;
end
assign db_tick = db_level & ~btn_sync1;
endmodule
