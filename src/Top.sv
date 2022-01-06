`timescale 1ns/1ps
`default_nettype none

module Top(
    input var logic clk,
    input var logic rst,
    output var logic [3:0] vga_red,
    output var logic [3:0] vga_grn,
    output var logic [3:0] vga_blu,
    output var logic hsync,
    output var logic vsync,

    input var logic raw_up,
    input var logic raw_down,
    input var logic raw_left,
    input var logic raw_right,
    input var logic raw_center
);
    logic valid;
    logic [9:0] h_cnt; // 640
    logic [9:0] v_cnt; // 480

    // the current player and board
    logic [1:0] player;
    logic [1:0] board [36-1:0];

    // sanitize the button input signals
    logic up, down, left, right, center;
    Button btn_up(.clk, .rst, .in(raw_up), .out(up));
    Button btn_down(.clk, .rst, .in(raw_down), .out(down));
    Button btn_left(.clk, .rst, .in(raw_left), .out(left));
    Button btn_right(.clk, .rst, .in(raw_right), .out(right));
    Button btn_center(.clk, .rst, .in(raw_center), .out(center));

    GameFsm game_fsm(
        .clk,
        .rst,
        .board,
        .player,
        .up, .down, .left, .right, .center
    );

    VgaPixelGen vga_pixel_gen(
        .h_cnt,
        .v_cnt,
        .valid,
        .vga_red,
        .vga_grn,
        .vga_blu,
        .board,
        .player
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
