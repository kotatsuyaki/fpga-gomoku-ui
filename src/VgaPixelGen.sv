`timescale 1ns/1ps
`default_nettype none

`include "colors.vh"

// Converter from board data to Vga display output.
module VgaPixelGen(
    input var logic [9:0] h_cnt,
    input var logic [9:0] v_cnt,
    input var logic valid,
    output var logic [3:0] vga_red,
    output var logic [3:0] vga_grn,
    output var logic [3:0] vga_blu,
    input var logic [1:0] board [36-1:0],
    input var logic [1:0] player,
    input var logic [5:0] cursor
);
    /* Disabler logic */
    // detect if the output should be disabled
    logic disabled;
    logic [2:0] disabled_cases;
    assign disabled = |disabled_cases;
    assign disabled_cases[0] = ~valid;
    assign disabled_cases[1] = h_cnt > 10'd640;
    assign disabled_cases[2] = v_cnt > 10'd480;

    // detect if scan line is out of the board's borders
    logic oob;
    logic [3:0] oob_cases;
    assign oob = |oob_cases;
    assign oob_cases[0] = h_cnt < 10'd128;  // 640/2 - 3*64
    assign oob_cases[1] = h_cnt >= 10'd512; // 640/2 + 3*64
    assign oob_cases[2] = v_cnt < 10'd48;   // 480/2 - 3*64
    assign oob_cases[3] = v_cnt >= 10'd432; // 480/2 + 3*64


    /* Coordinate transform */
    // coordinates w.r.t. top-left corner of the board
    logic [9:0] v, h;

    // the [5:0] bits (range: [0, 64)) is the coordinate **within** a cell
    // the [8:6] bits (range: [0, 5)) is the coordinate of the cell itself
    assign v = v_cnt - 10'd48; // range when non-oob: [0, 384)
    assign h = h_cnt - 10'd128; // range when non-oob: [0, 384)

    // coordinate within the cell
    logic [5:0] local_v, local_h;
    // row-major index of the cell
    logic [2:0] x, y;
    assign {x, local_v} = v[8:0];
    assign {y, local_h} = h[8:0];


    /* Content of cell */
    // rgb value of the current pixel if it's within a cell
    logic [11:0] cell_rgb;
    logic [5:0] cell_addr;
    logic [1:0] cell_value;
    logic cell_selected;

    assign cell_value = board[cell_addr];
    assign cell_selected = (cursor == cell_addr);

    CellCoordDecoder cell_coord_decoder(.x, .y, .cell_addr);
    CellPixelLut cell_pixel_lut(
        .local_v, .local_h, .cell_value, .cell_rgb, .cell_selected
    );

    always_comb begin
        if (disabled) begin
            {vga_red, vga_grn, vga_blu} = 12'h0;
        end else begin
            if (oob) begin
                {vga_red, vga_grn, vga_blu} = COLOR_BG;
            end else begin
                {vga_red, vga_grn, vga_blu} = cell_rgb;
            end
        end
    end
endmodule
