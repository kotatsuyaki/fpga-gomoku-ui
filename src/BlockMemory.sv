`timescale 1ns/1ps
`default_nettype none

module BlockMemory #(
    parameter INITFILE = "../mem/default.mem",
    // bits per entry
    parameter BITS = 16,
    // number of entries
    parameter WORDS = 64,

    /* private params, do not set */
    // width of address
    parameter ABITS = $clog2(WORDS),
    // MSB of address
    parameter AMSB = ABITS - 1,
    // MSB of content
    parameter MSB = BITS - 1
) (
    input var logic clk,
    input var logic wen,
    input var logic ren,
    input var logic [AMSB:0] addr,
    input var logic [MSB:0] din,
    output var logic [MSB:0] dout
    /* input var logic dump */
);
    (* ram_style = "block" *)
    logic [MSB:0] mem [WORDS-1:0];
    initial begin
        $readmemb(INITFILE, mem);
    end

    always_ff @(posedge clk) begin
        if (wen) begin
            mem[addr] <= din;
            dout <= dout;
        end else begin
            if (ren) begin
                dout <= mem[addr];
            end
        end
    end
endmodule
