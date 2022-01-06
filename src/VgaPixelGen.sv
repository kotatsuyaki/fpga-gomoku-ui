`timescale 1ns/1ps
`default_nettype none

module VgaPixelGen(
    input var logic [9:0] h_cnt,
    input var logic valid,
    output var logic [3:0] vga_red,
    output var logic [3:0] vga_grn,
    output var logic [3:0] vga_blu
);
    always_comb begin
        if (~valid) begin
            {vga_red, vga_grn, vga_blu} = 12'h0;
        end else if (h_cnt < 128) begin
            {vga_red, vga_grn, vga_blu} = 12'h000;
        end else if (h_cnt < 256) begin
            {vga_red, vga_grn, vga_blu} = 12'h00f;
        end else if (h_cnt < 384) begin
            {vga_red, vga_grn, vga_blu} = 12'hf00;
        end else if (h_cnt < 512) begin
            {vga_red, vga_grn, vga_blu} = 12'h0f0;              
        end else if (h_cnt < 640) begin
            {vga_red, vga_grn, vga_blu} = 12'hfff;
        end else begin
            {vga_red, vga_grn, vga_blu} = 12'h0;
        end
    end
endmodule
