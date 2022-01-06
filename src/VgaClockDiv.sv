`timescale 1ns/1ps
`default_nettype none

// Clock divider specifically for the VgaPixelGen module.
module VgaClockDiv(
    input var logic clk,
    output var logic clk_out
);
    logic [1:0] num;

    // Note that this is different from the sample code,
    // where the output is set high for 2 clock cycles each time.
    // The clock here is used as enable signal and not an actual clock,
    // so every time it stays high for 1 cycle only.
    assign clk_out = (num == 2'b00);

    always_ff @(posedge clk) begin
        num <= num + 2'b01;
    end
endmodule
