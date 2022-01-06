`timescale 1ns/1ps
`default_nettype none

module Top(
    input var logic clk,
    input var logic rst,
    output var logic [3:0] vgaRed,
    output var logic [3:0] vgaGreen,
    output var logic [3:0] vgaBlue,
    output var logic hsync,
    output var logic vsync
);
    logic clk_25MHz;
    logic valid;
    logic [9:0] h_cnt; // 640
    logic [9:0] v_cnt; // 480

    VgaClockDiv vga_clock_div(
        .clk,
        .clk_out(clk_25MHz)
    );

    VgaPixelGen vga_pixel_gen(
        .h_cnt,
        .valid,
        .vgaRed,
        .vgaGreen,
        .vgaBlue
    );

    VgaCtrl vga_ctrl(
        .pclk(clk_25MHz),
        .reset(rst),
        .hsync,
        .vsync,
        .valid,
        .h_cnt,
        .v_cnt
    );
endmodule
