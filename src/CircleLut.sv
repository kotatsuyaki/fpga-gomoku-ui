`timescale 1ns/1ps
`default_nettype none

`include "colors.vh"

module CircleLut(
    input var logic [5:0] local_v,
    input var logic [5:0] local_h,
    input var logic [1:0] cell_value,
    output var logic [11:0] cell_rgb
);
    // colors for inside and outside of the circle
    // logic [11:0] in_color, out_color;
    // assign out_color = COLOR_BOARD;
    always_comb begin
        case (cell_value)
            2'b00 : cell_rgb = COLOR_BOARD;
            2'b01 : cell_rgb = COLOR_BLACK;
            2'b10 : cell_rgb = COLOR_WHITE;
            default : cell_rgb = COLOR_ERROR;
        endcase
    end
endmodule
