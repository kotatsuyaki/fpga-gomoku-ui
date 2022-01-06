`timescale 1ns/1ps
`default_nettype none

`include "colors.vh"

// Lookup table for pixel colors within a cell.
//
// Inputs:
//   local_v, local_h: coordinate within the cell
//   cell_value: the color of the stone at current cell
// Outputs:
//   cell_rgb: 12-bit Rgb value to be used as vga output
module CellPixelLut(
    input var logic [5:0] local_v,
    input var logic [5:0] local_h,
    input var logic [1:0] cell_value,
    output var logic [11:0] cell_rgb
);
    /* Cell stone color calculation */
    // colors for inside the circle
    logic [11:0] circle_color;
    logic non_empty;

    assign non_empty = (cell_value != 2'b00);
    always_comb begin
        case (cell_value)
            2'b00 : circle_color = COLOR_BOARD;
            2'b01 : circle_color = COLOR_BLACK;
            2'b10 : circle_color = COLOR_WHITE;
            default : circle_color = COLOR_ERROR;
        endcase
    end


    /* Final output calculation */
    // lower and upper bounds of the circle
    // if local_h is within this range, then it's within the circle
    logic [5:0] h_lower, h_upper;
    // whether local_h is within circle;
    logic local_h_in_circle;
    // whether local_v,h is on the grid lines
    logic local_v_h_on_grid;

    // calculate the final output
    always_comb begin
        // non-empty stone takes precedence
        // if the stone is empty, then grid is always displayed
        if (non_empty) begin
            if (local_h_in_circle) begin
                cell_rgb = circle_color;
            end else begin
                // grid uses the same color as bg for now
                cell_rgb = (local_v_h_on_grid) ? COLOR_BG : COLOR_BOARD;
            end
        end else begin
            // grid uses the same color as bg for now
            cell_rgb = (local_v_h_on_grid) ? COLOR_BG : COLOR_BOARD;
        end
    end


    /* Grid line test calculation */
    logic [3:0] on_grid_cases;
    assign on_grid_cases[0] = (local_v == 6'd31);
    assign on_grid_cases[1] = (local_v == 6'd32);
    assign on_grid_cases[2] = (local_h == 6'd31);
    assign on_grid_cases[3] = (local_h == 6'd32);
    assign local_v_h_on_grid = |on_grid_cases;


    /* Circle range calculation */
    // empty range (this produces range of [63, 1), which is impossible to
    // be fulfilled)
    localparam EMPTY = 6'b111111;

    assign local_h_in_circle = (local_h >= h_lower) & (local_h < h_upper);

    // calculate values of the circle bound
    assign h_upper = 6'd00 - h_lower;
    always_comb begin
        case (local_v)
            6'd00, 6'd01, 6'd02 : h_lower = EMPTY;
            6'd03, 6'd60 : h_lower = 6'd25;
            6'd04, 6'd59 : h_lower = 6'd21;
            6'd05, 6'd58 : h_lower = 6'd19;
            6'd06, 6'd57 : h_lower = 6'd17;
            6'd07, 6'd56 : h_lower = 6'd16;
            6'd08, 6'd55 : h_lower = 6'd14;
            6'd09, 6'd54 : h_lower = 6'd13;
            6'd10, 6'd53 : h_lower = 6'd12;
            6'd11, 6'd52 : h_lower = 6'd11;
            6'd12, 6'd51 : h_lower = 6'd10;
            6'd13, 6'd50 : h_lower = 6'd09;
            6'd14, 6'd49 : h_lower = 6'd09;
            6'd15, 6'd48 : h_lower = 6'd08;
            6'd16, 6'd47 : h_lower = 6'd07;
            6'd17, 6'd46 : h_lower = 6'd07;
            6'd18, 6'd45 : h_lower = 6'd06;
            6'd19, 6'd44 : h_lower = 6'd06;
            6'd20, 6'd43 : h_lower = 6'd05;
            6'd21, 6'd42 : h_lower = 6'd05;
            6'd22, 6'd41 : h_lower = 6'd04;
            6'd23, 6'd40 : h_lower = 6'd04;
            6'd24, 6'd39 : h_lower = 6'd04;
            6'd25, 6'd38 : h_lower = 6'd04;
            6'd26, 6'd37 : h_lower = 6'd03;
            6'd27, 6'd36 : h_lower = 6'd03;
            6'd28, 6'd35 : h_lower = 6'd03;
            6'd29, 6'd34 : h_lower = 6'd03;
            6'd30, 6'd33 : h_lower = 6'd03;
            6'd31, 6'd32 : h_lower = 6'd03;
            6'd61, 6'd62, 6'd63 : h_lower = EMPTY;
            default : h_lower = EMPTY;
        endcase
    end
endmodule
