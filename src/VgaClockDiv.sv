`timescale 1ns/1ps
`default_nettype none

module VgaClockDiv(
    input var logic clk,
    output var logic clk_out
);
    logic [1:0] num;
    assign clk_out = (num == 2'b00);

    always_ff @(posedge clk) begin
        num <= num + 2'b01;
    end
endmodule
