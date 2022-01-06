`timescale 1ns/1ps
`default_nettype none

module VgaPixelGen(
    input var logic [9:0] h_cnt,
    input var logic valid,
    output var logic [3:0] vgaRed,
    output var logic [3:0] vgaGreen,
    output var logic [3:0] vgaBlue
);
    always_comb begin
        if (~valid) begin
            {vgaRed, vgaGreen, vgaBlue} = 12'h0;
        end else if (h_cnt < 128) begin
            {vgaRed, vgaGreen, vgaBlue} = 12'h000;
        end else if (h_cnt < 256) begin
            {vgaRed, vgaGreen, vgaBlue} = 12'h00f;
        end else if (h_cnt < 384) begin
            {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
        end else if (h_cnt < 512) begin
            {vgaRed, vgaGreen, vgaBlue} = 12'h0f0;              
        end else if (h_cnt < 640) begin
            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
        end else begin
            {vgaRed, vgaGreen, vgaBlue} = 12'h0;
        end
    end
endmodule
