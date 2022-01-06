`timescale 1ns/1ps
`default_nettype none

module Button(
    input var logic clk,
    input var logic rst,
    input var logic in,
    output var logic out
);
    logic deb_out, out_delay;
    Debounce deb(
        .clk, .rst, .in, .out(deb_out)
    );

    always_ff @(posedge clk) begin
        out <= deb_out & (~out_delay);
        out_delay <= deb_out;
    end
endmodule
