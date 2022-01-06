`timescale 1ns/1ps
`default_nettype none

module Top(
    input var logic clk,
    input var logic rst,
    output var logic [3:0] vga_red,
    output var logic [3:0] vga_grn,
    output var logic [3:0] vga_blu,
    output var logic hsync,
    output var logic vsync
);
    logic valid;
    logic [9:0] h_cnt; // 640
    logic [9:0] v_cnt; // 480

    logic [1:0] board [5:0][5:0];
    initial begin
        $readmemb("../mem/board.mem", board);
    end

    VgaPixelGen vga_pixel_gen(
        .h_cnt,
        .v_cnt,
        .valid,
        .vga_red,
        .vga_grn,
        .vga_blu,
        .board
    );

    VgaCtrl vga_ctrl(
        .clk,
        .reset(rst),
        .hsync,
        .vsync,
        .valid,
        .h_cnt,
        .v_cnt
    );
endmodule
