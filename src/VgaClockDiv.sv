`timescale 1ns/1ps
`default_nettype none

module VgaClockDiv(
    input var logic clk,
    output var logic clk_out
);
    logic [1:0] num;
    logic [1:0] next_num;

    assign next_num = num + 2'b1;
    assign clk_out = num[1];

    always_ff @(posedge clk) begin
        num <= next_num;
    end
endmodule
