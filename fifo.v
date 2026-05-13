`timescale 1ns / 1ps

module fifo
#(
   parameter DATA_SIZE = 8,
             ADDR_SPACE_EXP = 4
)
(
   input clk,
   input reset,
   input write_to_fifo,
   input read_from_fifo,
   input [DATA_SIZE-1:0] write_data_in,
   output reg [DATA_SIZE-1:0] read_data_out,
   output empty,
   output full
);
    localparam DEPTH = 2**ADDR_SPACE_EXP;
    reg [DATA_SIZE-1:0] memory [0:DEPTH-1];
    reg [ADDR_SPACE_EXP-1:0] wr_ptr, rd_ptr;
    reg [ADDR_SPACE_EXP:0] count;
    wire write_en = write_to_fifo & ~full;
    wire read_en  = read_from_fifo & ~empty;
    always @(posedge clk) begin
        if (write_en) begin
            memory[wr_ptr] <= write_data_in;
        end
    end
    always @(posedge clk) begin
        if (read_en) begin
            read_data_out <= memory[rd_ptr];
        end
    end
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count  <= 0;
        end
        else begin
            if (write_en)
                wr_ptr <= wr_ptr + 1;
            if (read_en)
                rd_ptr <= rd_ptr + 1;
            case ({write_en, read_en})
                2'b10: count <= count + 1;
                2'b01: count <= count - 1;
                default: count <= count;
            endcase
        end
    end
    assign full  = (count == DEPTH);
    assign empty = (count == 0);

endmodule
